Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:24368 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYKAK3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 06:29:31 -0400
Received: by ey-out-2122.google.com with SMTP id 6so603541eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 03:29:28 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Sat, 1 Nov 2008 11:29:25 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg> <200811010958.09194.IvDoorn@gmail.com> <1225530913.3560.0.camel@johannes.berg>
In-Reply-To: <1225530913.3560.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811011129.25387.IvDoorn@gmail.com> (sfid-20081101_112938_334108_92987AF8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 November 2008, Johannes Berg wrote:
> On Sat, 2008-11-01 at 09:58 +0100, Ivo van Doorn wrote:
> 
> > Could you try this patch? It doesn't matter if it is on top or as a replacement
> > of my previous patch.
> > 
> > This patch should also fix suspend/resume handling in general, I suddenly realized
> > there was quite a big bug in there regarding EEPROM/CSR handling. 
> 
> Now it just hangs at resume, rather than crashing. At suspend it already
> logs some MCU errors though.

Hmm that is strange, those MCU errors could only come from right before the code I
just changed. :S

In any case, could you revert the previous patches and try this. This is the same LED patch
as before, but I have added the check for set_key() to return immediately when this is called
while the module is busy unloading.

Ivo
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index b362a1c..bbac5c1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -125,6 +125,7 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 	int retval;
 
 	led->led_dev.name = name;
+	led->led_dev.brightness = LED_OFF;
 
 	retval = led_classdev_register(device, &led->led_dev);
 	if (retval) {
@@ -196,10 +197,12 @@ exit_fail:
 	rt2x00leds_unregister(rt2x00dev);
 }
 
-static void rt2x00leds_unregister_led(struct rt2x00_led *led)
+static inline void rt2x00leds_unregister_led(struct rt2x00_led *led)
 {
+	if (!(led->led_dev.flags & LED_SUSPENDED))
+		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
 	led_classdev_unregister(&led->led_dev);
-	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+
 	led->flags &= ~LED_REGISTERED;
 }
 
@@ -213,22 +216,34 @@ void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev)
 		rt2x00leds_unregister_led(&rt2x00dev->led_radio);
 }
 
+static inline void rt2x00leds_suspend_led(struct rt2x00_led *led)
+{
+	led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+	led_classdev_suspend(&led->led_dev);
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
+	led->led_dev.brightness_set(&led->led_dev, led->led_dev.brightness);
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
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 8fc2315..188f891 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -486,7 +486,9 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			struct ieee80211_key_conf *key);
 	struct rt2x00lib_crypto crypto;
 
-	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		return 0;
+	else if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags))
 		return -EOPNOTSUPP;
 	else if (key->keylen > 32)
 		return -ENOSPC;
