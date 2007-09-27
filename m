Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55583
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbXI0NgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 09:36:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: LED triggers support
Date: Thu, 27 Sep 2007 15:31:40 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709271531.42155.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drive the LEDs through the generic LED triggers.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig	2007-09-27 15:00:12.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/Kconfig	2007-09-27 15:06:23.000000000 +0200
@@ -61,6 +61,12 @@ config B43_PCMCIA
 
 	  If unsure, say N.
 
+# LED support
+config B43_LEDS
+	bool
+	depends on MAC80211_LEDS
+	default y
+
 config B43_DEBUG
 	bool "Broadcom 43xx debugging"
 	depends on B43
Index: wireless-2.6/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Makefile	2007-09-27 15:00:12.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/Makefile	2007-09-27 15:06:23.000000000 +0200
@@ -3,9 +3,10 @@ b43-y				+= main.o
 b43-y				+= tables.o
 b43-y				+= phy.o
 b43-y				+= sysfs.o
-b43-y				+= leds.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
+# b43 LED support
+b43-$(CONFIG_B43_LEDS)		+= leds.o
 # b43 PCMCIA support
 b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
 # b43 debugging
Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-09-27 15:00:12.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-09-27 15:06:23.000000000 +0200
@@ -707,8 +707,10 @@ struct b43_wldev {
 	/* Various statistics about the physical device. */
 	struct b43_stats stats;
 
-#define B43_NR_LEDS		4
-	struct b43_led leds[B43_NR_LEDS];
+	/* The device LEDs. */
+	struct b43_led led_tx;
+	struct b43_led led_rx;
+	struct b43_led led_assoc;
 
 	/* Reason code of the last interrupt. */
 	u32 irq_reason;
Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c	2007-09-27 15:00:12.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/leds.c	2007-09-27 15:29:05.000000000 +0200
@@ -1,12 +1,13 @@
 /*
 
   Broadcom B43 wireless driver
+  LED control
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-                     Stefano Brivio <st3@riseup.net>
-                     Michael Buesch <mb@bu3sch.de>
-                     Danny van Dyk <kugelfang@gentoo.org>
-                     Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
+  Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -27,272 +28,204 @@
 
 #include "b43.h"
 #include "leds.h"
-#include "main.h"
 
-static void b43_led_changestate(struct b43_led *led)
-{
-	struct b43_wldev *dev = led->dev;
-	const int index = led->index;
-	u16 ledctl;
-
-	B43_WARN_ON(!(index >= 0 && index < B43_NR_LEDS));
-	B43_WARN_ON(!led->blink_interval);
-	ledctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
-	ledctl ^= (1 << index);
-	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ledctl);
-}
 
-static void b43_led_blink(unsigned long d)
+static void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
+			    bool activelow)
 {
-	struct b43_led *led = (struct b43_led *)d;
-	struct b43_wldev *dev = led->dev;
+	struct b43_wl *wl = dev->wl;
 	unsigned long flags;
+	u16 ctl;
 
-	spin_lock_irqsave(&dev->wl->leds_lock, flags);
-	if (led->blink_interval) {
-		b43_led_changestate(led);
-		mod_timer(&led->blink_timer, jiffies + led->blink_interval);
-	}
-	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
+	spin_lock_irqsave(wl->leds_lock, flags);
+	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
+	if (activelow)
+		ctl &= ~(1 << led_index);
+	else
+		ctl |= (1 << led_index);
+	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
+	spin_unlock_irqrestore(wl->leds_lock, flags);
 }
 
-static void b43_led_blink_start(struct b43_led *led, unsigned long interval)
+static void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
+			     bool activelow)
 {
-	if (led->blink_interval)
-		return;
-	led->blink_interval = interval;
-	b43_led_changestate(led);
-	led->blink_timer.expires = jiffies + interval;
-	add_timer(&led->blink_timer);
+	struct b43_wl *wl = dev->wl;
+	unsigned long flags;
+	u16 ctl;
+
+	spin_lock_irqsave(wl->leds_lock, flags);
+	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
+	if (activelow)
+		ctl |= (1 << led_index);
+	else
+		ctl &= ~(1 << led_index);
+	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
+	spin_unlock_irqrestore(wl->leds_lock, flags);
 }
 
-static void b43_led_blink_stop(struct b43_led *led, int sync)
+/* Callback from the LED subsystem. */
+static void b43_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
 {
+	struct b43_led *led = container_of(led_dev, struct b43_led, led_dev);
 	struct b43_wldev *dev = led->dev;
-	const int index = led->index;
-	u16 ledctl;
+	bool radio_enabled;
 
-	if (!led->blink_interval)
-		return;
-	if (unlikely(sync))
-		del_timer_sync(&led->blink_timer);
-	else
-		del_timer(&led->blink_timer);
-	led->blink_interval = 0;
+	/* Checking the radio-enabled status here is slightly racy,
+	 * but we want to avoid the locking overhead and we don't care
+	 * whether the LED has the wrong state for a second. */
+	radio_enabled = (dev->phy.radio_on && dev->radio_hw_enable);
 
-	/* Make sure the LED is turned off. */
-	B43_WARN_ON(!(index >= 0 && index < B43_NR_LEDS));
-	ledctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
-	if (led->activelow)
-		ledctl |= (1 << index);
+	if (brightness == LED_OFF || !radio_enabled)
+		b43_led_turn_off(dev, led->index, led->activelow);
 	else
-		ledctl &= ~(1 << index);
-	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ledctl);
+		b43_led_turn_on(dev, led->index, led->activelow);
 }
 
-static void b43_led_init_hardcoded(struct b43_wldev *dev,
-				   struct b43_led *led, int led_index)
-{
-	struct ssb_bus *bus = dev->dev->bus;
+static int b43_register_led(struct b43_wldev *dev, struct b43_led *led,
+			    const char *name, char *default_trigger,
+			    u8 led_index, bool activelow)
+{
+	int err;
+
+	b43_led_turn_off(dev, led_index, activelow);
+	if (led->dev)
+		return -EEXIST;
+	if (!default_trigger)
+		return -EINVAL;
+	led->dev = dev;
+	led->index = led_index;
+	led->activelow = activelow;
+	strncpy(led->name, name, sizeof(led->name));
+
+	led->led_dev.name = led->name;
+	led->led_dev.default_trigger = default_trigger;
+	led->led_dev.brightness_set = b43_led_brightness_set;
+
+	err = led_classdev_register(dev->dev->dev, &led->led_dev);
+	if (err) {
+		b43warn(dev->wl, "LEDs: Failed to register %s\n", name);
+		led->dev = NULL;
+		return err;
+	}
+	return 0;
+}
 
-	/* This function is called, if the behaviour (and activelow)
-	 * information for a LED is missing in the SPROM.
-	 * We hardcode the behaviour values for various devices here.
-	 * Note that the B43_LED_TEST_XXX behaviour values can
-	 * be used to figure out which led is mapped to which index.
-	 */
-
-	switch (led_index) {
-	case 0:
-		led->behaviour = B43_LED_ACTIVITY;
-		led->activelow = 1;
-		if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
-			led->behaviour = B43_LED_RADIO_ALL;
+static void b43_unregister_led(struct b43_led *led)
+{
+	if (!led->dev)
+		return;
+	led_classdev_unregister(&led->led_dev);
+	b43_led_turn_off(led->dev, led->index, led->activelow);
+	led->dev = NULL;
+}
+
+static void b43_map_led(struct b43_wldev *dev,
+			u8 led_index,
+			enum b43_led_behaviour behaviour,
+			bool activelow)
+{
+	struct ieee80211_hw *hw = dev->wl->hw;
+	char name[B43_LED_MAX_NAME_LEN + 1];
+
+	/* Map the b43 specific LED behaviour value to the
+	 * generic LED triggers. */
+	switch (behaviour) {
+	case B43_LED_INACTIVE:
 		break;
-	case 1:
-		led->behaviour = B43_LED_RADIO_B;
-		if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
-			led->behaviour = B43_LED_ASSOC;
+	case B43_LED_OFF:
+		b43_led_turn_off(dev, led_index, activelow);
 		break;
-	case 2:
-		led->behaviour = B43_LED_RADIO_A;
+	case B43_LED_ON:
+		b43_led_turn_on(dev, led_index, activelow);
 		break;
-	case 3:
-		led->behaviour = B43_LED_OFF;
+	case B43_LED_ACTIVITY:
+	case B43_LED_TRANSFER:
+	case B43_LED_APTRANSFER:
+		snprintf(name, sizeof(name),
+			 "b43-%s:tx", wiphy_name(hw->wiphy));
+		b43_register_led(dev, &dev->led_tx, name,
+				 ieee80211_get_tx_led_name(hw),
+				 led_index, activelow);
+		snprintf(name, sizeof(name),
+			 "b43-%s:rx", wiphy_name(hw->wiphy));
+		b43_register_led(dev, &dev->led_rx, name,
+				 ieee80211_get_rx_led_name(hw),
+				 led_index, activelow);
+		break;
+	/*FIXME: We need another trigger for the "radio-on" LEDs below.
+	 *       Wiggle that somehow into the rfkill subsystem. */
+	case B43_LED_RADIO_ALL:
+	case B43_LED_RADIO_A:
+	case B43_LED_RADIO_B:
+	case B43_LED_MODE_BG:
+	case B43_LED_WEIRD:
+	case B43_LED_ASSOC:
+		snprintf(name, sizeof(name),
+			 "b43-%s:assoc", wiphy_name(hw->wiphy));
+		b43_register_led(dev, &dev->led_assoc, name,
+				 ieee80211_get_assoc_led_name(hw),
+				 led_index, activelow);
 		break;
 	default:
-		B43_WARN_ON(1);
+		b43warn(dev->wl, "LEDs: Unknown behaviour 0x%02X\n",
+			behaviour);
+		break;
 	}
 }
 
-int b43_leds_init(struct b43_wldev *dev)
+void b43_leds_init(struct b43_wldev *dev)
 {
-	struct b43_led *led;
+	struct ssb_bus *bus = dev->dev->bus;
 	u8 sprom[4];
 	int i;
+	enum b43_led_behaviour behaviour;
+	bool activelow;
 
-	sprom[0] = dev->dev->bus->sprom.r1.gpio0;
-	sprom[1] = dev->dev->bus->sprom.r1.gpio1;
-	sprom[2] = dev->dev->bus->sprom.r1.gpio2;
-	sprom[3] = dev->dev->bus->sprom.r1.gpio3;
-
-	for (i = 0; i < B43_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-		led->index = i;
-		led->dev = dev;
-		setup_timer(&led->blink_timer,
-			    b43_led_blink, (unsigned long)led);
+	sprom[0] = bus->sprom.r1.gpio0;
+	sprom[1] = bus->sprom.r1.gpio1;
+	sprom[2] = bus->sprom.r1.gpio2;
+	sprom[3] = bus->sprom.r1.gpio3;
 
+	for (i = 0; i < 4; i++) {
 		if (sprom[i] == 0xFF) {
-			b43_led_init_hardcoded(dev, led, i);
+			/* There is no LED information in the SPROM
+			 * for this LED. Hardcode it here. */
+			activelow = 0;
+			switch (i) {
+			case 0:
+				behaviour = B43_LED_ACTIVITY;
+				activelow = 1;
+				if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
+					behaviour = B43_LED_RADIO_ALL;
+				break;
+			case 1:
+				behaviour = B43_LED_RADIO_B;
+				if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
+					behaviour = B43_LED_ASSOC;
+				break;
+			case 2:
+				behaviour = B43_LED_RADIO_A;
+				break;
+			case 3:
+				behaviour = B43_LED_OFF;
+				break;
+			default:
+				B43_WARN_ON(1);
+				return;
+			}
 		} else {
-			led->behaviour = sprom[i] & B43_LED_BEHAVIOUR;
-			led->activelow = !!(sprom[i] & B43_LED_ACTIVELOW);
+			behaviour = sprom[i] & B43_LED_BEHAVIOUR;
+			activelow = !!(sprom[i] & B43_LED_ACTIVELOW);
 		}
+		b43_map_led(dev, i, behaviour, activelow);
 	}
-
-	return 0;
 }
 
 void b43_leds_exit(struct b43_wldev *dev)
 {
-	struct b43_led *led;
-	int i;
-
-	for (i = 0; i < B43_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-		b43_led_blink_stop(led, 1);
-	}
-	b43_leds_switch_all(dev, 0);
-}
-
-void b43_leds_update(struct b43_wldev *dev, int activity)
-{
-	struct b43_led *led;
-	struct b43_phy *phy = &dev->phy;
-	const int transferring =
-	    (jiffies - dev->stats.last_tx) < B43_LED_XFER_THRES;
-	int i, turn_on;
-	unsigned long interval = 0;
-	u16 ledctl;
-	unsigned long flags;
-	bool radio_enabled = (phy->radio_on && dev->radio_hw_enable);
-
-	spin_lock_irqsave(&dev->wl->leds_lock, flags);
-	ledctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
-	for (i = 0; i < B43_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-
-		turn_on = 0;
-		switch (led->behaviour) {
-		case B43_LED_INACTIVE:
-			continue;
-		case B43_LED_OFF:
-			break;
-		case B43_LED_ON:
-			turn_on = 1;
-			break;
-		case B43_LED_ACTIVITY:
-			turn_on = activity;
-			break;
-		case B43_LED_RADIO_ALL:
-			turn_on = radio_enabled;
-			break;
-		case B43_LED_RADIO_A:
-			turn_on = (radio_enabled && phy->type == B43_PHYTYPE_A);
-			break;
-		case B43_LED_RADIO_B:
-			turn_on = (radio_enabled &&
-				   (phy->type == B43_PHYTYPE_B
-				    || phy->type == B43_PHYTYPE_G));
-			break;
-		case B43_LED_MODE_BG:
-			if (phy->type == B43_PHYTYPE_G
-			    && radio_enabled)
-				turn_on = 1;
-			break;
-		case B43_LED_TRANSFER:
-			if (transferring)
-				b43_led_blink_start(led, B43_LEDBLINK_MEDIUM);
-			else
-				b43_led_blink_stop(led, 0);
-			continue;
-		case B43_LED_APTRANSFER:
-			if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP)) {
-				if (transferring) {
-					interval = B43_LEDBLINK_FAST;
-					turn_on = 1;
-				}
-			} else {
-				turn_on = 1;
-				if (0 /*TODO: not assoc */ )
-					interval = B43_LEDBLINK_SLOW;
-				else if (transferring)
-					interval = B43_LEDBLINK_FAST;
-				else
-					turn_on = 0;
-			}
-			if (turn_on)
-				b43_led_blink_start(led, interval);
-			else
-				b43_led_blink_stop(led, 0);
-			continue;
-		case B43_LED_WEIRD:
-			//TODO
-			break;
-		case B43_LED_ASSOC:
-			if (1 /*dev->softmac->associated */ )
-				turn_on = 1;
-			break;
-#ifdef CONFIG_B43_DEBUG
-		case B43_LED_TEST_BLINKSLOW:
-			b43_led_blink_start(led, B43_LEDBLINK_SLOW);
-			continue;
-		case B43_LED_TEST_BLINKMEDIUM:
-			b43_led_blink_start(led, B43_LEDBLINK_MEDIUM);
-			continue;
-		case B43_LED_TEST_BLINKFAST:
-			b43_led_blink_start(led, B43_LEDBLINK_FAST);
-			continue;
-#endif /* CONFIG_B43_DEBUG */
-		default:
-			B43_WARN_ON(1);
-		};
-
-		if (led->activelow)
-			turn_on = !turn_on;
-		if (turn_on)
-			ledctl |= (1 << i);
-		else
-			ledctl &= ~(1 << i);
-	}
-	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ledctl);
-	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
-}
-
-void b43_leds_switch_all(struct b43_wldev *dev, int on)
-{
-	struct b43_led *led;
-	u16 ledctl;
-	int i;
-	int bit_on;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->wl->leds_lock, flags);
-	ledctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
-	for (i = 0; i < B43_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-		if (led->behaviour == B43_LED_INACTIVE)
-			continue;
-		if (on)
-			bit_on = led->activelow ? 0 : 1;
-		else
-			bit_on = led->activelow ? 1 : 0;
-		if (bit_on)
-			ledctl |= (1 << i);
-		else
-			ledctl &= ~(1 << i);
-	}
-	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ledctl);
-	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
+	b43_unregister_led(&dev->led_tx);
+	b43_unregister_led(&dev->led_rx);
+	b43_unregister_led(&dev->led_assoc);
 }
Index: wireless-2.6/drivers/net/wireless/b43/leds.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.h	2007-09-27 15:00:12.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/leds.h	2007-09-27 15:26:36.000000000 +0200
@@ -1,29 +1,33 @@
 #ifndef B43_LEDS_H_
 #define B43_LEDS_H_
 
+struct b43_wldev;
+
+#ifdef CONFIG_B43_LEDS
+
 #include <linux/types.h>
-#include <linux/timer.h>
+#include <linux/leds.h>
+
+
+#define B43_LED_MAX_NAME_LEN	31
 
 struct b43_led {
-	u8 behaviour;
-	bool activelow;
-	/* Index in the "leds" array in b43_wldev */
-	u8 index;
 	struct b43_wldev *dev;
-	struct timer_list blink_timer;
-	unsigned long blink_interval;
+	/* The LED class device */
+	struct led_classdev led_dev;
+	/* The index number of the LED. */
+	u8 index;
+	/* If activelow is true, the LED is ON if the
+	 * bit is switched off. */
+	bool activelow;
+	/* The unique name string for this LED device. */
+	char name[B43_LED_MAX_NAME_LEN + 1];
 };
 
-/* Delay between state changes when blinking in jiffies */
-#define B43_LEDBLINK_SLOW		(HZ / 1)
-#define B43_LEDBLINK_MEDIUM		(HZ / 4)
-#define B43_LEDBLINK_FAST		(HZ / 8)
-
-#define B43_LED_XFER_THRES		(HZ / 100)
-
 #define B43_LED_BEHAVIOUR		0x7F
 #define B43_LED_ACTIVELOW		0x80
-enum {				/* LED behaviour values */
+/* LED behaviour values */
+enum b43_led_behaviour {
 	B43_LED_OFF,
 	B43_LED_ON,
 	B43_LED_ACTIVITY,
@@ -36,20 +40,25 @@ enum {				/* LED behaviour values */
 	B43_LED_WEIRD,		//FIXME
 	B43_LED_ASSOC,
 	B43_LED_INACTIVE,
-
-	/* Behaviour values for testing.
-	 * With these values it is easier to figure out
-	 * the real behaviour of leds, in case the SPROM
-	 * is missing information.
-	 */
-	B43_LED_TEST_BLINKSLOW,
-	B43_LED_TEST_BLINKMEDIUM,
-	B43_LED_TEST_BLINKFAST,
 };
 
-int b43_leds_init(struct b43_wldev *dev);
+void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
-void b43_leds_update(struct b43_wldev *dev, int activity);
-void b43_leds_switch_all(struct b43_wldev *dev, int on);
+
+
+#else /* CONFIG_B43_LEDS */
+/* LED support disabled */
+
+struct b43_led {
+	/* empty */
+};
+
+static inline void b43_leds_init(struct b43_wldev *dev)
+{
+}
+static inline void b43_leds_exit(struct b43_wldev *dev)
+{
+}
+#endif /* CONFIG_B43_LEDS */
 
 #endif /* B43_LEDS_H_ */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-09-27 15:00:12.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-09-27 15:06:23.000000000 +0200
@@ -84,10 +84,6 @@ static int modparam_long_retry = B43_DEF
 module_param_named(long_retry, modparam_long_retry, int, 0444);
 MODULE_PARM_DESC(long_retry, "Long-Retry-Limit (0 - 15)");
 
-static int modparam_noleds;
-module_param_named(noleds, modparam_noleds, int, 0444);
-MODULE_PARM_DESC(noleds, "Turn off all LED activity");
-
 static char modparam_fwpostfix[16];
 module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the .fw files to load.");
@@ -1423,7 +1419,7 @@ static void b43_interrupt_tasklet(struct
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
-	int i, activity = 0;
+	int i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
@@ -1476,8 +1472,9 @@ static void b43_interrupt_tasklet(struct
 		handle_irq_beacon(dev);
 	if (reason & B43_IRQ_PMQ)
 		handle_irq_pmq(dev);
-	if (reason & B43_IRQ_TXFIFO_FLUSH_OK) ;
-	/*TODO*/ if (reason & B43_IRQ_NOISESAMPLE_OK)
+	if (reason & B43_IRQ_TXFIFO_FLUSH_OK)
+		;/* TODO */
+	if (reason & B43_IRQ_NOISESAMPLE_OK)
 		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
@@ -1486,7 +1483,6 @@ static void b43_interrupt_tasklet(struct
 			b43_pio_rx(dev->pio.queue0);
 		else
 			b43_dma_rx(dev->dma.rx_ring0);
-		/* We intentionally don't set "activity" to 1, here. */
 	}
 	B43_WARN_ON(dma_reason[1] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[2] & B43_DMAIRQ_RX_DONE);
@@ -1495,19 +1491,13 @@ static void b43_interrupt_tasklet(struct
 			b43_pio_rx(dev->pio.queue3);
 		else
 			b43_dma_rx(dev->dma.rx_ring3);
-		activity = 1;
 	}
 	B43_WARN_ON(dma_reason[4] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[5] & B43_DMAIRQ_RX_DONE);
 
-	if (reason & B43_IRQ_TX_OK) {
+	if (reason & B43_IRQ_TX_OK)
 		handle_irq_transmit_status(dev);
-		activity = 1;
-		//TODO: In AP mode, this also causes sending of powersave responses.
-	}
 
-	if (!modparam_noleds)
-		b43_leds_update(dev, activity);
 	b43_interrupt_enable(dev, dev->irq_savedstate);
 	mmiowb();
 	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
@@ -1959,7 +1949,6 @@ static int b43_gpio_init(struct b43_wlde
 	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
 		    & ~B43_MACCTL_GPOUTSMSK);
 
-	b43_leds_switch_all(dev, 0);
 	b43_write16(dev, B43_MMIO_GPIO_MASK, b43_read16(dev, B43_MMIO_GPIO_MASK)
 		    | 0x000F);
 
@@ -2213,8 +2202,7 @@ static bool b43_is_hw_radio_enabled(stru
 static void b43_chip_exit(struct b43_wldev *dev)
 {
 	b43_radio_turn_off(dev);
-	if (!modparam_noleds)
-		b43_leds_exit(dev);
+	b43_leds_exit(dev);
 	b43_gpio_cleanup(dev);
 	/* firmware is released later */
 }
@@ -2242,9 +2230,11 @@ static int b43_chip_init(struct b43_wlde
 	err = b43_gpio_init(dev);
 	if (err)
 		goto out;	/* firmware is released later */
+	b43_leds_init(dev);
+
 	err = b43_upload_initvals(dev);
 	if (err)
-		goto err_gpio_cleanup;
+		goto err_leds_exit;
 	b43_radio_turn_on(dev);
 
 	b43_write16(dev, 0x03E6, 0x0000);
@@ -2318,14 +2308,15 @@ static int b43_chip_init(struct b43_wlde
 
 	err = 0;
 	b43dbg(dev->wl, "Chip initialized\n");
-      out:
+out:
 	return err;
 
-      err_radio_off:
+err_radio_off:
 	b43_radio_turn_off(dev);
-      err_gpio_cleanup:
+err_leds_exit:
+	b43_leds_exit(dev);
 	b43_gpio_cleanup(dev);
-	goto out;
+	return err;
 }
 
 static void b43_periodic_every120sec(struct b43_wldev *dev)
@@ -2412,7 +2403,6 @@ static void b43_periodic_every1sec(struc
 		dev->radio_hw_enable = radio_hw_enable;
 		b43info(dev->wl, "Radio hardware status changed to %s\n",
 			radio_hw_enable ? "ENABLED" : "DISABLED");
-		b43_leds_update(dev, 0);
 	}
 }
 
@@ -3768,18 +3758,13 @@ static int b43_wireless_core_attach(stru
 	} else
 		have_bphy = 1;
 
-	/* Initialize LEDs structs. */
-	err = b43_leds_init(dev);
-	if (err)
-		goto err_powerdown;
-
 	dev->phy.gmode = (have_gphy || have_bphy);
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
 	err = b43_phy_versioning(dev);
 	if (err)
-		goto err_leds_exit;
+		goto err_powerdown;
 	/* Check if this device supports multiband. */
 	if (!pdev ||
 	    (pdev->device != 0x4312 &&
@@ -3808,10 +3793,10 @@ static int b43_wireless_core_attach(stru
 
 	err = b43_validate_chipaccess(dev);
 	if (err)
-		goto err_leds_exit;
+		goto err_powerdown;
 	err = b43_setup_modes(dev, have_aphy, have_bphy, have_gphy);
 	if (err)
-		goto err_leds_exit;
+		goto err_powerdown;
 
 	/* Now set some default "current_dev" */
 	if (!wl->current_dev)
@@ -3826,8 +3811,6 @@ static int b43_wireless_core_attach(stru
 out:
 	return err;
 
-err_leds_exit:
-	b43_leds_exit(dev);
 err_powerdown:
 	ssb_bus_may_powerdown(bus);
 	return err;
