import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 480
    height: 480
    flags: Qt.FramelessWindowHint
    property date currentDate: new Date()
    Canvas {
        id: clock
        anchors.fill: parent
        antialiasing: true

        function drawHand(cx, num, den, length, color, lineWidth, drawCircle)
        {
            var angle = Math.PI * 2 * num / den
            var endX = length * Math.sin(angle)
            var endY = -length * Math.cos(angle)
            cx.strokeStyle = color
            cx.fillStyle = color
            cx.lineWidth = lineWidth
            cx.lineCap = "round"
            cx.beginPath()
            cx.moveTo(0, 0)
            cx.lineTo(endX, endY)
            cx.stroke()
            if (drawCircle) {
                cx.beginPath()
                cx.arc(endX, endY, 10, 0, 2 * Math.PI)
                cx.fill()
            }
        }

        onPaint: {
            var cx = getContext("2d")
            var radius = Math.min(width, height) / 2
            cx.reset()
            cx.translate(width / 2, height / 2)

            for (var i = 0; i < 60; i++) {
                var angle = i * Math.PI / 30
                var startRadius
                if (i % 5 == 0) {
                    startRadius = radius - 20
                    cx.strokeStyle = "#000"
                    cx.lineWidth = 2
                } else {
                    startRadius = radius - 10
                    cx.strokeStyle = "#666"
                    cx.lineWidth = 1
                }

                var startX = startRadius * Math.sin(angle)
                var startY = -startRadius * Math.cos(angle)
                var endX = radius * Math.sin(angle)
                var endY = -radius * Math.cos(angle)

                cx.beginPath()
                cx.moveTo(startX, startY)
                cx.lineTo(endX, endY)
                cx.stroke()
            }
            var h = currentDate.getHours()
            var m = currentDate.getMinutes()
            var s = currentDate.getSeconds()
            var ms = currentDate.getMilliseconds()
            s += ms / 1000
            m += s / 60
            h += m / 60
            drawHand(cx, h, 12, radius * 0.5, "#000", 6, false)
            drawHand(cx, m, 60, radius * 0.7, "#000", 4, false)
            drawHand(cx, s, 60, radius * 0.9, "#F00", 2, true)
        }
    }

    function updateClockHands()
    {
        currentDate = new Date()
        clock.requestPaint()
    }

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: updateClockHands()
    }
}
