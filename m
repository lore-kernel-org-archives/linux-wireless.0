Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41180
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbXI2WFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 18:05:02 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Leds spinlock SMP compilefix
Date: Sun, 30 Sep 2007 00:04:36 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200709300004.36905.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was missing an address operator.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c	2007-09-29 12:44:08.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/leds.c	2007-09-30 00:02:18.000000000 +0200
@@ -37,14 +37,14 @@ static void b43_led_turn_on(struct b43_w
 	unsigned long flags;
 	u16 ctl;
 
-	spin_lock_irqsave(wl->leds_lock, flags);
+	spin_lock_irqsave(&wl->leds_lock, flags);
 	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
 	if (activelow)
 		ctl &= ~(1 << led_index);
 	else
 		ctl |= (1 << led_index);
 	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
-	spin_unlock_irqrestore(wl->leds_lock, flags);
+	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
 static void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
@@ -54,14 +54,14 @@ static void b43_led_turn_off(struct b43_
 	unsigned long flags;
 	u16 ctl;
 
-	spin_lock_irqsave(wl->leds_lock, flags);
+	spin_lock_irqsave(&wl->leds_lock, flags);
 	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
 	if (activelow)
 		ctl |= (1 << led_index);
 	else
 		ctl &= ~(1 << led_index);
 	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
-	spin_unlock_irqrestore(wl->leds_lock, flags);
+	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
 /* Callback from the LED subsystem. */
