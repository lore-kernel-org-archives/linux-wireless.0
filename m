Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:21552 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYJaTbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 15:31:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so632626nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 12:31:06 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Fri, 31 Oct 2008 20:31:03 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg> <200810302247.28609.IvDoorn@gmail.com> <1225408055.3535.1.camel@johannes.berg>
In-Reply-To: <1225408055.3535.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810312031.03314.IvDoorn@gmail.com> (sfid-20081031_203117_699881_80B71415)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 October 2008, Johannes Berg wrote:
> On Thu, 2008-10-30 at 22:47 +0100, Ivo van Doorn wrote:
> > Hi,
> > 
> > > Maybe it was stupid, but with USB it always works, I suspended, ejected
> > > the card (because I had to go and didn't want to resume) while suspended
> > > and resumed when I arrived at uni, to find the laptop crashing.
> > > 
> > > http://johannes.sipsolutions.net/files/rt61pci-resume-crash.jpg
> 
> > Heh well these 2 functions are the most important ones in the trace anyway. ;)
> > The only reason I see that rt61pci_mcu_request might fail like this is if writel()
> > crashes when a device is unplugged while a driver still has a reference to the
> > register base pointer which came from ioremap().
> > But I don't know if that would be a valid assumption. :S
> 
> It looks like a NULL dereference to me. Look at
> 
> http://johannes.sipsolutions.net/files/rt61pci-resume-crash2.jpg
> 
> (ignore the first backtrace, it's something I always get, but it allows
> me to see this oops because it turns on the console early :) )

Hmm, it looks like CSR base is NULL, after which the H2M_MAILBOX_CSR
offset is added to it (0x2100)

The strange part is thet CSR is freed and set to NULL _after_ the
rt2x00lib_remove_dev() call...
Oh wait never mind, I get the picture, I missed the "ejected _while_ suspended"
part. I think what is happening is that first the suspend handler is called,
and during resume not the resume handler but the remove handler is running,
and rt2x00 doesn't protect against that.

Could you check if below patch does the trick? If I am not mistaken only the
LED handler actually accesses the hardware to make sure they are off.

Thanks,

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
