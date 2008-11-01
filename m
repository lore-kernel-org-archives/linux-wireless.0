Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12762 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYKAXiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 19:38:22 -0400
Received: by ey-out-2122.google.com with SMTP id 6so664663eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 16:38:20 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/4] rt2x00: Fix LED state handling
Date: Sun, 2 Nov 2008 00:37:09 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200811020036.40746.IvDoorn@gmail.com>
In-Reply-To: <200811020036.40746.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811020037.09726.IvDoorn@gmail.com> (sfid-20081102_003835_071291_3703AF23)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For every global LED state change (register/unregister,
suspend/resume) we should force the LEDS to turn off.
This makes sure that the LEDS will always be in a sane
state after the state switch.

Note that when unregister is called but the LED class
wasn't resumed yet, we shouldn't change the LED state
since we might not have access to the device (device
was unplugged while suspended).

Also remove the checks in the activity, assoc and
radio LEDS which blocked calls to brightness_set()
when the state hasn't changed. Some of those LEDS
could be enabled by themselves when something happens
in the hardware (e.g. firmware is loaded). We already
did called rt2x00leds to switch the LED off, but those
calls were blocked.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00leds.c |   94 ++++++++++++++++++------------
 1 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index b362a1c..66c61b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -72,49 +72,33 @@ void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi)
 	}
 }
 
-void rt2x00led_led_activity(struct rt2x00_dev *rt2x00dev, bool enabled)
+static void rt2x00led_led_simple(struct rt2x00_led *led, bool enabled)
 {
-	struct rt2x00_led *led = &rt2x00dev->led_qual;
-	unsigned int brightness;
+	unsigned int brightness = enabled ? LED_FULL : LED_OFF;
 
-	if ((led->type != LED_TYPE_ACTIVITY) || !(led->flags & LED_REGISTERED))
+	if (!(led->flags & LED_REGISTERED))
 		return;
 
-	brightness = enabled ? LED_FULL : LED_OFF;
-	if (brightness != led->led_dev.brightness) {
-		led->led_dev.brightness_set(&led->led_dev, brightness);
-		led->led_dev.brightness = brightness;
-	}
+	led->led_dev.brightness_set(&led->led_dev, brightness);
+	led->led_dev.brightness = brightness;
 }
 
-void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled)
+void rt2x00led_led_activity(struct rt2x00_dev *rt2x00dev, bool enabled)
 {
-	struct rt2x00_led *led = &rt2x00dev->led_assoc;
-	unsigned int brightness;
-
-	if ((led->type != LED_TYPE_ASSOC) || !(led->flags & LED_REGISTERED))
-		return;
+	if (rt2x00dev->led_qual.type == LED_TYPE_ACTIVITY)
+		rt2x00led_led_simple(&rt2x00dev->led_qual, enabled);
+}
 
-	brightness = enabled ? LED_FULL : LED_OFF;
-	if (brightness != led->led_dev.brightness) {
-		led->led_dev.brightness_set(&led->led_dev, brightness);
-		led->led_dev.brightness = brightness;
-	}
+void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled)
+{
+	if (rt2x00dev->led_assoc.type == LED_TYPE_ASSOC)
+		rt2x00led_led_simple(&rt2x00dev->led_assoc, enabled);
 }
 
 void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev, bool enabled)
 {
-	struct rt2x00_led *led = &rt2x00dev->led_radio;
-	unsigned int brightness;
-
-	if ((led->type != LED_TYPE_RADIO) || !(led->flags & LED_REGISTERED))
-		return;
-
-	brightness = enabled ? LED_FULL : LED_OFF;
-	if (brightness != led->led_dev.brightness) {
-		led->led_dev.brightness_set(&led->led_dev, brightness);
-		led->led_dev.brightness = brightness;
-	}
+	if (rt2x00dev->led_radio.type == LED_TYPE_ASSOC)
+		rt2x00led_led_simple(&rt2x00dev->led_radio, enabled);
 }
 
 static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
@@ -125,6 +109,13 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 	int retval;
 
 	led->led_dev.name = name;
+	led->led_dev.brightness = LED_OFF;
+
+	/*
+	 * Ensure the LED is off, it might have been enabled
+	 * by the hardware when the device was powered on.
+	 */
+	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
 
 	retval = led_classdev_register(device, &led->led_dev);
 	if (retval) {
@@ -199,7 +190,16 @@ exit_fail:
 static void rt2x00leds_unregister_led(struct rt2x00_led *led)
 {
 	led_classdev_unregister(&led->led_dev);
-	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+
+	/*
+	 * This might look weird, but when we are unregistering while
+	 * suspended the led is already off, and since we haven't
+	 * fully resumed yet, access to the device might not be
+	 * possible yet.
+	 */
+	if (!(led->led_dev.flags & LED_SUSPENDED))
+		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+
 	led->flags &= ~LED_REGISTERED;
 }
 
@@ -213,22 +213,40 @@ void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev)
 		rt2x00leds_unregister_led(&rt2x00dev->led_radio);
 }
 
+static inline void rt2x00leds_suspend_led(struct rt2x00_led *led)
+{
+	led_classdev_suspend(&led->led_dev);
+
+	/* This shouldn't be needed, but just to be safe */
+	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+	led->led_dev.brightness = LED_OFF;
+}
+
 void rt2x00leds_suspend(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->led_qual.flags & LED_REGISTERED)
-		led_classdev_suspend(&rt2x00dev->led_qual.led_dev);
+		rt2x00leds_suspend_led(&rt2x00dev->led_qual);
 	if (rt2x00dev->led_assoc.flags & LED_REGISTERED)
-		led_classdev_suspend(&rt2x00dev->led_assoc.led_dev);
+		rt2x00leds_suspend_led(&rt2x00dev->led_assoc);
 	if (rt2x00dev->led_radio.flags & LED_REGISTERED)
-		led_classdev_suspend(&rt2x00dev->led_radio.led_dev);
+		rt2x00leds_suspend_led(&rt2x00dev->led_radio);
+}
+
+static inline void rt2x00leds_resume_led(struct rt2x00_led *led)
+{
+	led_classdev_resume(&led->led_dev);
+
+	/* Device might have enabled the LEDS during resume */
+	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+	led->led_dev.brightness = LED_OFF;
 }
 
 void rt2x00leds_resume(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->led_radio.flags & LED_REGISTERED)
-		led_classdev_resume(&rt2x00dev->led_radio.led_dev);
+		rt2x00leds_resume_led(&rt2x00dev->led_radio);
 	if (rt2x00dev->led_assoc.flags & LED_REGISTERED)
-		led_classdev_resume(&rt2x00dev->led_assoc.led_dev);
+		rt2x00leds_resume_led(&rt2x00dev->led_assoc);
 	if (rt2x00dev->led_qual.flags & LED_REGISTERED)
-		led_classdev_resume(&rt2x00dev->led_qual.led_dev);
+		rt2x00leds_resume_led(&rt2x00dev->led_qual);
 }
-- 
1.5.6.1

