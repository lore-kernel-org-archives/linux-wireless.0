Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:39598 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbXHBPxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:53:46 -0400
Date: Thu, 02 Aug 2007 10:53:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 4/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fdfa.b23/SBAsflcopXZo%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This if file 4 of 10 of the port of the bcm43xx driver from softmac
to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
@@ -312,41 +312,24 @@ const u16 bcm43xx_ilt_sigmasqr2[BCM43xx_
 
 /**** Helper functions to access the device Internal Lookup Tables ****/
 
-void bcm43xx_ilt_write(struct bcm43xx_private *bcm, u16 offset, u16 val)
+void bcm43xx_ilt_write(struct bcm43xx_wldev *dev, u16 offset, u16 val)
 {
-	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_CTRL, offset);
-		mmiowb();
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA1, val);
-	} else {
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_CTRL, offset);
-		mmiowb();
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA1, val);
-	}
+	bcm43xx_phy_write(dev, BCM43xx_PHY_ILT_G_CTRL, offset);
+	mmiowb();
+	bcm43xx_phy_write(dev, BCM43xx_PHY_ILT_G_DATA1, val);
 }
 
-void bcm43xx_ilt_write32(struct bcm43xx_private *bcm, u16 offset, u32 val)
+void bcm43xx_ilt_write32(struct bcm43xx_wldev *dev, u16 offset, u32 val)
 {
-	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_CTRL, offset);
-		mmiowb();
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA2, (val & 0xFFFF0000) >> 16);
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA1, val & 0x0000FFFF);
-	} else {
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_CTRL, offset);
-		mmiowb();
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA2, (val & 0xFFFF0000) >> 16);
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA1, val & 0x0000FFFF);
-	}
+	bcm43xx_phy_write(dev, BCM43xx_PHY_ILT_G_CTRL, offset);
+	mmiowb();
+	bcm43xx_phy_write(dev, BCM43xx_PHY_ILT_G_DATA2, (val & 0xFFFF0000) >>
+			  16);
+	bcm43xx_phy_write(dev, BCM43xx_PHY_ILT_G_DATA1, val & 0x0000FFFF);
 }
 
-u16 bcm43xx_ilt_read(struct bcm43xx_private *bcm, u16 offset)
+u16 bcm43xx_ilt_read(struct bcm43xx_wldev *dev, u16 offset)
 {
-	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_CTRL, offset);
-		return bcm43xx_phy_read(bcm, BCM43xx_PHY_ILT_A_DATA1);
-	} else {
-		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_CTRL, offset);
-		return bcm43xx_phy_read(bcm, BCM43xx_PHY_ILT_G_DATA1);
-	}
+	bcm43xx_phy_write(dev, BCM43xx_PHY_ILT_G_CTRL, offset);
+	return bcm43xx_phy_read(dev, BCM43xx_PHY_ILT_G_DATA1);
 }
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
@@ -26,8 +26,8 @@ extern const u16 bcm43xx_ilt_sigmasqr1[B
 extern const u16 bcm43xx_ilt_sigmasqr2[BCM43xx_ILT_SIGMASQR_SIZE];
 
 
-void bcm43xx_ilt_write(struct bcm43xx_private *bcm, u16 offset, u16 val);
-void bcm43xx_ilt_write32(struct bcm43xx_private *bcm, u16 offset, u32 val);
-u16 bcm43xx_ilt_read(struct bcm43xx_private *bcm, u16 offset);
+void bcm43xx_ilt_write(struct bcm43xx_wldev *dev, u16 offset, u16 val);
+void bcm43xx_ilt_write32(struct bcm43xx_wldev *dev, u16 offset, u32 val);
+u16 bcm43xx_ilt_read(struct bcm43xx_wldev *dev, u16 offset);
 
 #endif /* BCM43xx_ILT_H_ */
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_leds.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_leds.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_leds.c
@@ -3,10 +3,11 @@
   Broadcom BCM43xx wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-                     Stefano Brivio <st3@riseup.net>
-                     Michael Buesch <mbuesch@freenet.de>
-                     Danny van Dyk <kugelfang@gentoo.org>
-                     Andreas Jaggi <andreas.jaggi@waterwave.ch>
+		     Stefano Brivio <st3@riseup.net>
+		     Michael Buesch <mb@bu3sch.de>
+		     Danny van Dyk <kugelfang@gentoo.org>
+		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -26,38 +27,35 @@
 */
 
 #include "bcm43xx_leds.h"
-#include "bcm43xx_radio.h"
 #include "bcm43xx.h"
-
-#include <asm/bitops.h>
-
+#include "bcm43xx_main.h"
 
 static void bcm43xx_led_changestate(struct bcm43xx_led *led)
 {
-	struct bcm43xx_private *bcm = led->bcm;
+	struct bcm43xx_wldev *dev = led->dev;
 	const int index = bcm43xx_led_index(led);
 	const u16 mask = (1 << index);
 	u16 ledctl;
 
-	assert(index >= 0 && index < BCM43xx_NR_LEDS);
-	assert(led->blink_interval);
-	ledctl = bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_CONTROL);
+	BCM43xx_WARN_ON(!(index >= 0 && index < BCM43xx_NR_LEDS));
+	BCM43xx_WARN_ON(!led->blink_interval);
+	ledctl = bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_CONTROL);
 	ledctl = (ledctl & mask) ? (ledctl & ~mask) : (ledctl | mask);
-	bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
+	bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
 }
 
 static void bcm43xx_led_blink(unsigned long d)
 {
 	struct bcm43xx_led *led = (struct bcm43xx_led *)d;
-	struct bcm43xx_private *bcm = led->bcm;
+	struct bcm43xx_wldev *dev = led->dev;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bcm->leds_lock, flags);
+	spin_lock_irqsave(&dev->wl->leds_lock, flags);
 	if (led->blink_interval) {
 		bcm43xx_led_changestate(led);
 		mod_timer(&led->blink_timer, jiffies + led->blink_interval);
 	}
-	spin_unlock_irqrestore(&bcm->leds_lock, flags);
+	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
 }
 
 static void bcm43xx_led_blink_start(struct bcm43xx_led *led,
@@ -73,7 +71,7 @@ static void bcm43xx_led_blink_start(stru
 
 static void bcm43xx_led_blink_stop(struct bcm43xx_led *led, int sync)
 {
-	struct bcm43xx_private *bcm = led->bcm;
+	struct bcm43xx_wldev *dev = led->dev;
 	const int index = bcm43xx_led_index(led);
 	u16 ledctl;
 
@@ -86,19 +84,21 @@ static void bcm43xx_led_blink_stop(struc
 	led->blink_interval = 0;
 
 	/* Make sure the LED is turned off. */
-	assert(index >= 0 && index < BCM43xx_NR_LEDS);
-	ledctl = bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_CONTROL);
+	BCM43xx_WARN_ON(!(index >= 0 && index < BCM43xx_NR_LEDS));
+	ledctl = bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_CONTROL);
 	if (led->activelow)
 		ledctl |= (1 << index);
 	else
 		ledctl &= ~(1 << index);
-	bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
+	bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
 }
 
-static void bcm43xx_led_init_hardcoded(struct bcm43xx_private *bcm,
+static void bcm43xx_led_init_hardcoded(struct bcm43xx_wldev *dev,
 				       struct bcm43xx_led *led,
 				       int led_index)
 {
+	struct ssb_bus *bus = dev->dev->bus;
+
 	/* This function is called, if the behaviour (and activelow)
 	 * information for a LED is missing in the SPROM.
 	 * We hardcode the behaviour values for various devices here.
@@ -110,12 +110,12 @@ static void bcm43xx_led_init_hardcoded(s
 	case 0:
 		led->behaviour = BCM43xx_LED_ACTIVITY;
 		led->activelow = 1;
-		if (bcm->board_vendor == PCI_VENDOR_ID_COMPAQ)
+		if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
 			led->behaviour = BCM43xx_LED_RADIO_ALL;
 		break;
 	case 1:
 		led->behaviour = BCM43xx_LED_RADIO_B;
-		if (bcm->board_vendor == PCI_VENDOR_ID_ASUSTEK)
+		if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
 			led->behaviour = BCM43xx_LED_ASSOC;
 		break;
 	case 2:
@@ -125,30 +125,30 @@ static void bcm43xx_led_init_hardcoded(s
 		led->behaviour = BCM43xx_LED_OFF;
 		break;
 	default:
-		assert(0);
+		BCM43xx_BUG_ON(1);
 	}
 }
 
-int bcm43xx_leds_init(struct bcm43xx_private *bcm)
+int bcm43xx_leds_init(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_led *led;
 	u8 sprom[4];
 	int i;
 
-	sprom[0] = bcm->sprom.wl0gpio0;
-	sprom[1] = bcm->sprom.wl0gpio1;
-	sprom[2] = bcm->sprom.wl0gpio2;
-	sprom[3] = bcm->sprom.wl0gpio3;
+	sprom[0] = dev->dev->bus->sprom.r1.gpio0;
+	sprom[1] = dev->dev->bus->sprom.r1.gpio1;
+	sprom[2] = dev->dev->bus->sprom.r1.gpio2;
+	sprom[3] = dev->dev->bus->sprom.r1.gpio3;
 
 	for (i = 0; i < BCM43xx_NR_LEDS; i++) {
-		led = &(bcm->leds[i]);
-		led->bcm = bcm;
+		led = &(dev->leds[i]);
+		led->dev = dev;
 		setup_timer(&led->blink_timer,
 			    bcm43xx_led_blink,
 			    (unsigned long)led);
 
 		if (sprom[i] == 0xFF) {
-			bcm43xx_led_init_hardcoded(bcm, led, i);
+			bcm43xx_led_init_hardcoded(dev, led, i);
 		} else {
 			led->behaviour = sprom[i] & BCM43xx_LED_BEHAVIOUR;
 			led->activelow = !!(sprom[i] & BCM43xx_LED_ACTIVELOW);
@@ -158,84 +158,79 @@ int bcm43xx_leds_init(struct bcm43xx_pri
 	return 0;
 }
 
-void bcm43xx_leds_exit(struct bcm43xx_private *bcm)
+void bcm43xx_leds_exit(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_led *led;
 	int i;
 
 	for (i = 0; i < BCM43xx_NR_LEDS; i++) {
-		led = &(bcm->leds[i]);
+		led = &(dev->leds[i]);
 		bcm43xx_led_blink_stop(led, 1);
 	}
-	bcm43xx_leds_switch_all(bcm, 0);
+	bcm43xx_leds_switch_all(dev, 0);
 }
 
-void bcm43xx_leds_update(struct bcm43xx_private *bcm, int activity)
+void bcm43xx_leds_update(struct bcm43xx_wldev *dev, int activity)
 {
 	struct bcm43xx_led *led;
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	const int transferring = (jiffies - bcm->stats.last_tx) < BCM43xx_LED_XFER_THRES;
+	struct bcm43xx_phy *phy = &dev->phy;
+	const int transferring = (jiffies - dev->stats.last_tx)
+				  < BCM43xx_LED_XFER_THRES;
 	int i, turn_on;
 	unsigned long interval = 0;
 	u16 ledctl;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bcm->leds_lock, flags);
-	ledctl = bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_CONTROL);
+	spin_lock_irqsave(&dev->wl->leds_lock, flags);
+	ledctl = bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_CONTROL);
 	for (i = 0; i < BCM43xx_NR_LEDS; i++) {
-		led = &(bcm->leds[i]);
+		led = &(dev->leds[i]);
 
 		turn_on = 0;
 		switch (led->behaviour) {
 		case BCM43xx_LED_INACTIVE:
 			continue;
 		case BCM43xx_LED_OFF:
-		case BCM43xx_LED_BCM4303_3:
 			break;
 		case BCM43xx_LED_ON:
 			turn_on = 1;
 			break;
 		case BCM43xx_LED_ACTIVITY:
-		case BCM43xx_LED_BCM4303_0:
 			turn_on = activity;
 			break;
 		case BCM43xx_LED_RADIO_ALL:
-			turn_on = radio->enabled && bcm43xx_is_hw_radio_enabled(bcm);
+			turn_on = phy->radio_on &&
+				  bcm43xx_is_hw_radio_enabled(dev);
 			break;
 		case BCM43xx_LED_RADIO_A:
-		case BCM43xx_LED_BCM4303_2:
-			turn_on = (radio->enabled && bcm43xx_is_hw_radio_enabled(bcm) &&
-				   phy->type == BCM43xx_PHYTYPE_A);
 			break;
 		case BCM43xx_LED_RADIO_B:
-		case BCM43xx_LED_BCM4303_1:
-			turn_on = (radio->enabled && bcm43xx_is_hw_radio_enabled(bcm) &&
+			turn_on = (phy->radio_on &&
+				   bcm43xx_is_hw_radio_enabled(dev) &&
 				   (phy->type == BCM43xx_PHYTYPE_B ||
 				    phy->type == BCM43xx_PHYTYPE_G));
 			break;
 		case BCM43xx_LED_MODE_BG:
-			if (phy->type == BCM43xx_PHYTYPE_G && bcm43xx_is_hw_radio_enabled(bcm) &&
-			    1/*FIXME: using G rates.*/)
+			if (phy->type == BCM43xx_PHYTYPE_G &&
+			    bcm43xx_is_hw_radio_enabled(dev))
 				turn_on = 1;
 			break;
 		case BCM43xx_LED_TRANSFER:
 			if (transferring)
-				bcm43xx_led_blink_start(led, BCM43xx_LEDBLINK_MEDIUM);
+				bcm43xx_led_blink_start(led,
+						BCM43xx_LEDBLINK_MEDIUM);
 			else
 				bcm43xx_led_blink_stop(led, 0);
 			continue;
 		case BCM43xx_LED_APTRANSFER:
-			if (bcm->ieee->iw_mode == IW_MODE_MASTER) {
+			if (bcm43xx_is_mode(dev->wl, IEEE80211_IF_TYPE_AP)) {
 				if (transferring) {
 					interval = BCM43xx_LEDBLINK_FAST;
 					turn_on = 1;
 				}
 			} else {
 				turn_on = 1;
-				if (0/*TODO: not assoc*/)
-					interval = BCM43xx_LEDBLINK_SLOW;
-				else if (transferring)
+				if (transferring)
 					interval = BCM43xx_LEDBLINK_FAST;
 				else
 					turn_on = 0;
@@ -246,12 +241,9 @@ void bcm43xx_leds_update(struct bcm43xx_
 				bcm43xx_led_blink_stop(led, 0);
 			continue;
 		case BCM43xx_LED_WEIRD:
-			//TODO
 			break;
 		case BCM43xx_LED_ASSOC:
-			if (bcm->softmac->associnfo.associated)
-				turn_on = 1;
-			break;
+			turn_on = 1;
 #ifdef CONFIG_BCM43XX_DEBUG
 		case BCM43xx_LED_TEST_BLINKSLOW:
 			bcm43xx_led_blink_start(led, BCM43xx_LEDBLINK_SLOW);
@@ -264,8 +256,7 @@ void bcm43xx_leds_update(struct bcm43xx_
 			continue;
 #endif /* CONFIG_BCM43XX_DEBUG */
 		default:
-			dprintkl(KERN_INFO PFX "Bad value in leds_update,"
-				" led->behaviour: 0x%x\n", led->behaviour);
+			BCM43xx_BUG_ON(1);
 		};
 
 		if (led->activelow)
@@ -275,11 +266,11 @@ void bcm43xx_leds_update(struct bcm43xx_
 		else
 			ledctl &= ~(1 << i);
 	}
-	bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
-	spin_unlock_irqrestore(&bcm->leds_lock, flags);
+	bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
+	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
 }
 
-void bcm43xx_leds_switch_all(struct bcm43xx_private *bcm, int on)
+void bcm43xx_leds_switch_all(struct bcm43xx_wldev *dev, int on)
 {
 	struct bcm43xx_led *led;
 	u16 ledctl;
@@ -287,10 +278,10 @@ void bcm43xx_leds_switch_all(struct bcm4
 	int bit_on;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bcm->leds_lock, flags);
-	ledctl = bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_CONTROL);
+	spin_lock_irqsave(&dev->wl->leds_lock, flags);
+	ledctl = bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_CONTROL);
 	for (i = 0; i < BCM43xx_NR_LEDS; i++) {
-		led = &(bcm->leds[i]);
+		led = &(dev->leds[i]);
 		if (led->behaviour == BCM43xx_LED_INACTIVE)
 			continue;
 		if (on)
@@ -302,6 +293,6 @@ void bcm43xx_leds_switch_all(struct bcm4
 		else
 			ledctl &= ~(1 << i);
 	}
-	bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
-	spin_unlock_irqrestore(&bcm->leds_lock, flags);
+	bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_CONTROL, ledctl);
+	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
 }
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_leds.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_leds.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_leds.h
@@ -9,11 +9,11 @@ struct bcm43xx_led {
 	u8 behaviour:7;
 	u8 activelow:1;
 
-	struct bcm43xx_private *bcm;
+	struct bcm43xx_wldev *dev;
 	struct timer_list blink_timer;
 	unsigned long blink_interval;
 };
-#define bcm43xx_led_index(led)	((int)((led) - (led)->bcm->leds))
+#define bcm43xx_led_index(led)	((int)((led) - (led)->dev->leds))
 
 /* Delay between state changes when blinking in jiffies */
 #define BCM43xx_LEDBLINK_SLOW		(HZ / 1)
@@ -34,7 +34,7 @@ enum { /* LED behaviour values */
 	BCM43xx_LED_MODE_BG,
 	BCM43xx_LED_TRANSFER,
 	BCM43xx_LED_APTRANSFER,
-	BCM43xx_LED_WEIRD,//FIXME
+	BCM43xx_LED_WEIRD,
 	BCM43xx_LED_ASSOC,
 	BCM43xx_LED_INACTIVE,
 
@@ -46,17 +46,11 @@ enum { /* LED behaviour values */
 	BCM43xx_LED_TEST_BLINKSLOW,
 	BCM43xx_LED_TEST_BLINKMEDIUM,
 	BCM43xx_LED_TEST_BLINKFAST,
-
-	/* Misc values for BCM4303 */
-	BCM43xx_LED_BCM4303_0 = 0x2B,
-	BCM43xx_LED_BCM4303_1 = 0x78,
-	BCM43xx_LED_BCM4303_2 = 0x2E,
-	BCM43xx_LED_BCM4303_3 = 0x19,
 };
 
-int bcm43xx_leds_init(struct bcm43xx_private *bcm);
-void bcm43xx_leds_exit(struct bcm43xx_private *bcm);
-void bcm43xx_leds_update(struct bcm43xx_private *bcm, int activity);
-void bcm43xx_leds_switch_all(struct bcm43xx_private *bcm, int on);
+int bcm43xx_leds_init(struct bcm43xx_wldev *dev);
+void bcm43xx_leds_exit(struct bcm43xx_wldev *dev);
+void bcm43xx_leds_update(struct bcm43xx_wldev *dev, int activity);
+void bcm43xx_leds_switch_all(struct bcm43xx_wldev *dev, int on);
 
 #endif /* BCM43xx_LEDS_H_ */

