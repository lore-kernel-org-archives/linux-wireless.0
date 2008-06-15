Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39026 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516AbYFOOCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 10:02:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix possible MMIO access while device is down
Date: Sun, 15 Jun 2008 16:01:24 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806151601.24322.mb@bu3sch.de> (sfid-20080615_160241_129806_BBD1BCCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a possible MMIO access while the device is still down
from a suspend cycle. MMIO accesses with the device powered down
may cause crashes on certain devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/leds.c	2008-05-15 23:31:37.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/leds.c	2008-06-15 15:55:42.000000000 +0200
@@ -69,12 +69,15 @@ static void b43_led_brightness_set(struc
 				   enum led_brightness brightness)
 {
 	struct b43_led *led = container_of(led_dev, struct b43_led, led_dev);
 	struct b43_wldev *dev = led->dev;
 	bool radio_enabled;
 
+	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED))
+		return;
+
 	/* Checking the radio-enabled status here is slightly racy,
 	 * but we want to avoid the locking overhead and we don't care
 	 * whether the LED has the wrong state for a second. */
 	radio_enabled = (dev->phy.radio_on && dev->radio_hw_enable);
 
 	if (brightness == LED_OFF || !radio_enabled)
