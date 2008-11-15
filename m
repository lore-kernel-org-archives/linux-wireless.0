Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:11057 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYKOXIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 18:08:55 -0500
Received: by ug-out-1314.google.com with SMTP id 39so159602ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2008 15:08:53 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Don't switch off LED on initialization
Date: Sun, 16 Nov 2008 00:08:50 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811160008.51235.IvDoorn@gmail.com> (sfid-20081116_000903_696833_7208DE9E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we switch off the LEDS during initialization
we kill rt73usb from proper functioning. The immediate
result after the first LED command are MCU failures
and a complete breakdown of TX/RX.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00leds.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index 66c61b1..68f4e0f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -111,12 +111,6 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.name = name;
 	led->led_dev.brightness = LED_OFF;
 
-	/*
-	 * Ensure the LED is off, it might have been enabled
-	 * by the hardware when the device was powered on.
-	 */
-	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
-
 	retval = led_classdev_register(device, &led->led_dev);
 	if (retval) {
 		ERROR(rt2x00dev, "Failed to register led handler.\n");
-- 
1.5.6.1

