Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXJMEE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 00:04:59 -0400
Date: Fri, 12 Oct 2007 23:04:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43legacy: LED triggers support
Message-ID: <471043e3.nbgnVprY8Ddg68MT%Larry.Finger@lwfinger.net> (sfid-20071013_050510_971362_99F7E31E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drive the LEDs through the generic LED triggers.

The patch to b43 by Michael Buesch <mb@bu3sch.de> has been ported to b43legacy.

Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
---

John,

This patch is to be applied to the 'everything' branch of wireless-2.6.
The previous version missed some b43 => b43legacy renaming.

Larry
---

 drivers/net/wireless/b43legacy/Kconfig     |    6
 drivers/net/wireless/b43legacy/Makefile    |   27 +
 drivers/net/wireless/b43legacy/b43legacy.h |    6
 drivers/net/wireless/b43legacy/leds.c      |  411 ++++++++++++-----------------
 drivers/net/wireless/b43legacy/leds.h      |   61 ++--
 drivers/net/wireless/b43legacy/main.c      |   40 --
 drivers/net/wireless/b43legacy/radio.c     |    2
 7 files changed, 242 insertions(+), 311 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
@@ -34,6 +34,12 @@ config B43LEGACY_PCICORE_AUTOSELECT
 	select SSB_DRIVER_PCICORE
 	default y
 
+# LED support
+config B43LEGACY_LEDS
+	bool
+	depends on MAC80211_LEDS
+	default y
+
 config B43LEGACY_DEBUG
 	bool "Broadcom 43xx-legacy debugging"
 	depends on B43LEGACY
Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -663,8 +663,10 @@ struct b43legacy_wldev {
 	/* Various statistics about the physical device. */
 	struct b43legacy_stats stats;
 
-#define B43legacy_NR_LEDS		4
-	struct b43legacy_led leds[B43legacy_NR_LEDS];
+	/* The device LEDs. */
+	struct b43legacy_led led_tx;
+	struct b43legacy_led led_rx;
+	struct b43legacy_led led_assoc;
 
 	/* Reason code of the last interrupt. */
 	u32 irq_reason;
Index: wireless-2.6/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/leds.c
@@ -1,13 +1,13 @@
 /*
 
-  Broadcom B43legacy wireless driver
+  Broadcom B43 wireless driver
+  LED control
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-		     Stefano Brivio <st3@riseup.net>
-		     Michael Buesch <mb@bu3sch.de>
-		     Danny van Dyk <kugelfang@gentoo.org>
-		     Andreas Jaggi <andreas.jaggi@waterwave.ch>
-  Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
+  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
+  Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -26,273 +26,208 @@
 
 */
 
-#include "leds.h"
 #include "b43legacy.h"
-#include "main.h"
-
-static void b43legacy_led_changestate(struct b43legacy_led *led)
-{
-	struct b43legacy_wldev *dev = led->dev;
-	const int index = led->index;
-	u16 ledctl;
+#include "leds.h"
 
-	B43legacy_WARN_ON(!(index >= 0 && index < B43legacy_NR_LEDS));
-	B43legacy_WARN_ON(!led->blink_interval);
-	ledctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
-	ledctl ^= (1 << index);
-	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ledctl);
-}
 
-static void b43legacy_led_blink(unsigned long d)
+static void b43legacy_led_turn_on(struct b43legacy_wldev *dev, u8 led_index,
+			    bool activelow)
 {
-	struct b43legacy_led *led = (struct b43legacy_led *)d;
-	struct b43legacy_wldev *dev = led->dev;
+	struct b43legacy_wl *wl = dev->wl;
 	unsigned long flags;
+	u16 ctl;
 
-	spin_lock_irqsave(&dev->wl->leds_lock, flags);
-	if (led->blink_interval) {
-		b43legacy_led_changestate(led);
-		mod_timer(&led->blink_timer, jiffies + led->blink_interval);
-	}
-	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
+	spin_lock_irqsave(&wl->leds_lock, flags);
+	ctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
+	if (activelow)
+		ctl &= ~(1 << led_index);
+	else
+		ctl |= (1 << led_index);
+	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ctl);
+	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
-static void b43legacy_led_blink_start(struct b43legacy_led *led,
-				      unsigned long interval)
+static void b43legacy_led_turn_off(struct b43legacy_wldev *dev, u8 led_index,
+			     bool activelow)
 {
-	if (led->blink_interval)
-		return;
-	led->blink_interval = interval;
-	b43legacy_led_changestate(led);
-	led->blink_timer.expires = jiffies + interval;
-	add_timer(&led->blink_timer);
+	struct b43legacy_wl *wl = dev->wl;
+	unsigned long flags;
+	u16 ctl;
+
+	spin_lock_irqsave(&wl->leds_lock, flags);
+	ctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
+	if (activelow)
+		ctl |= (1 << led_index);
+	else
+		ctl &= ~(1 << led_index);
+	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ctl);
+	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
-static void b43legacy_led_blink_stop(struct b43legacy_led *led, int sync)
+/* Callback from the LED subsystem. */
+static void b43legacy_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
 {
+	struct b43legacy_led *led = container_of(led_dev, struct b43legacy_led,
+				    led_dev);
 	struct b43legacy_wldev *dev = led->dev;
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
-	B43legacy_WARN_ON(!(index >= 0 && index < B43legacy_NR_LEDS));
-	ledctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
-	if (led->activelow)
-		ledctl |= (1 << index);
+	if (brightness == LED_OFF || !radio_enabled)
+		b43legacy_led_turn_off(dev, led->index, led->activelow);
 	else
-		ledctl &= ~(1 << index);
-	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ledctl);
+		b43legacy_led_turn_on(dev, led->index, led->activelow);
 }
 
-static void b43legacy_led_init_hardcoded(struct b43legacy_wldev *dev,
-					 struct b43legacy_led *led,
-					 int led_index)
-{
-	struct ssb_bus *bus = dev->dev->bus;
+static int b43legacy_register_led(struct b43legacy_wldev *dev,
+				  struct b43legacy_led *led,
+				  const char *name, char *default_trigger,
+				  u8 led_index, bool activelow)
+{
+	int err;
+
+	b43legacy_led_turn_off(dev, led_index, activelow);
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
+	led->led_dev.brightness_set = b43legacy_led_brightness_set;
+
+	err = led_classdev_register(dev->dev->dev, &led->led_dev);
+	if (err) {
+		b43legacywarn(dev->wl, "LEDs: Failed to register %s\n", name);
+		led->dev = NULL;
+		return err;
+	}
+	return 0;
+}
 
-	/* This function is called, if the behaviour (and activelow)
-	 * information for a LED is missing in the SPROM.
-	 * We hardcode the behaviour values for various devices here.
-	 * Note that the B43legacy_LED_TEST_XXX behaviour values can
-	 * be used to figure out which led is mapped to which index.
-	 */
-
-	switch (led_index) {
-	case 0:
-		led->behaviour = B43legacy_LED_ACTIVITY;
-		led->activelow = 1;
-		if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
-			led->behaviour = B43legacy_LED_RADIO_ALL;
+static void b43legacy_unregister_led(struct b43legacy_led *led)
+{
+	if (!led->dev)
+		return;
+	led_classdev_unregister(&led->led_dev);
+	b43legacy_led_turn_off(led->dev, led->index, led->activelow);
+	led->dev = NULL;
+}
+
+static void b43legacy_map_led(struct b43legacy_wldev *dev,
+			u8 led_index,
+			enum b43legacy_led_behaviour behaviour,
+			bool activelow)
+{
+	struct ieee80211_hw *hw = dev->wl->hw;
+	char name[B43legacy_LED_MAX_NAME_LEN + 1];
+
+	/* Map the b43 specific LED behaviour value to the
+	 * generic LED triggers. */
+	switch (behaviour) {
+	case B43legacy_LED_INACTIVE:
+		break;
+	case B43legacy_LED_OFF:
+		b43legacy_led_turn_off(dev, led_index, activelow);
 		break;
-	case 1:
-		led->behaviour = B43legacy_LED_RADIO_B;
-		if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
-			led->behaviour = B43legacy_LED_ASSOC;
+	case B43legacy_LED_ON:
+		b43legacy_led_turn_on(dev, led_index, activelow);
 		break;
-	case 2:
-		led->behaviour = B43legacy_LED_RADIO_A;
+	case B43legacy_LED_ACTIVITY:
+	case B43legacy_LED_TRANSFER:
+	case B43legacy_LED_APTRANSFER:
+		snprintf(name, sizeof(name),
+			 "b43legacy-%s:tx", wiphy_name(hw->wiphy));
+		b43legacy_register_led(dev, &dev->led_tx, name,
+				 ieee80211_get_tx_led_name(hw),
+				 led_index, activelow);
+		snprintf(name, sizeof(name),
+			 "b43legacy-%s:rx", wiphy_name(hw->wiphy));
+		b43legacy_register_led(dev, &dev->led_rx, name,
+				 ieee80211_get_rx_led_name(hw),
+				 led_index, activelow);
 		break;
-	case 3:
-		led->behaviour = B43legacy_LED_OFF;
+	/*FIXME: We need another trigger for the "radio-on" LEDs below.
+	 *       Wiggle that somehow into the rfkill subsystem. */
+	case B43legacy_LED_RADIO_ALL:
+	case B43legacy_LED_RADIO_A:
+	case B43legacy_LED_RADIO_B:
+	case B43legacy_LED_MODE_BG:
+	case B43legacy_LED_WEIRD:
+	case B43legacy_LED_ASSOC:
+		snprintf(name, sizeof(name),
+			 "b43legacy-%s:assoc", wiphy_name(hw->wiphy));
+		b43legacy_register_led(dev, &dev->led_assoc, name,
+				 ieee80211_get_assoc_led_name(hw),
+				 led_index, activelow);
 		break;
 	default:
-		B43legacy_BUG_ON(1);
+		b43legacywarn(dev->wl, "LEDs: Unknown behaviour 0x%02X\n",
+			behaviour);
+		break;
 	}
 }
 
-int b43legacy_leds_init(struct b43legacy_wldev *dev)
+void b43legacy_leds_init(struct b43legacy_wldev *dev)
 {
-	struct b43legacy_led *led;
+	struct ssb_bus *bus = dev->dev->bus;
 	u8 sprom[4];
 	int i;
+	enum b43legacy_led_behaviour behaviour;
+	bool activelow;
 
-	sprom[0] = dev->dev->bus->sprom.r1.gpio0;
-	sprom[1] = dev->dev->bus->sprom.r1.gpio1;
-	sprom[2] = dev->dev->bus->sprom.r1.gpio2;
-	sprom[3] = dev->dev->bus->sprom.r1.gpio3;
-
-	for (i = 0; i < B43legacy_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-		led->index = i;
-		led->dev = dev;
-		setup_timer(&led->blink_timer,
-			    b43legacy_led_blink,
-			    (unsigned long)led);
-
-		if (sprom[i] == 0xFF)
-			b43legacy_led_init_hardcoded(dev, led, i);
-		else {
-			led->behaviour = sprom[i] & B43legacy_LED_BEHAVIOUR;
-			led->activelow = !!(sprom[i] &
-					   B43legacy_LED_ACTIVELOW);
+	sprom[0] = bus->sprom.r1.gpio0;
+	sprom[1] = bus->sprom.r1.gpio1;
+	sprom[2] = bus->sprom.r1.gpio2;
+	sprom[3] = bus->sprom.r1.gpio3;
+
+	for (i = 0; i < 4; i++) {
+		if (sprom[i] == 0xFF) {
+			/* There is no LED information in the SPROM
+			 * for this LED. Hardcode it here. */
+			activelow = 0;
+			switch (i) {
+			case 0:
+				behaviour = B43legacy_LED_ACTIVITY;
+				activelow = 1;
+				if (bus->boardinfo.vendor == PCI_VENDOR_ID_COMPAQ)
+					behaviour = B43legacy_LED_RADIO_ALL;
+				break;
+			case 1:
+				behaviour = B43legacy_LED_RADIO_B;
+				if (bus->boardinfo.vendor == PCI_VENDOR_ID_ASUSTEK)
+					behaviour = B43legacy_LED_ASSOC;
+				break;
+			case 2:
+				behaviour = B43legacy_LED_RADIO_A;
+				break;
+			case 3:
+				behaviour = B43legacy_LED_OFF;
+				break;
+			default:
+				B43legacy_WARN_ON(1);
+				return;
+			}
+		} else {
+			behaviour = sprom[i] & B43legacy_LED_BEHAVIOUR;
+			activelow = !!(sprom[i] & B43legacy_LED_ACTIVELOW);
 		}
+		b43legacy_map_led(dev, i, behaviour, activelow);
 	}
-
-	return 0;
 }
 
 void b43legacy_leds_exit(struct b43legacy_wldev *dev)
 {
-	struct b43legacy_led *led;
-	int i;
-
-	for (i = 0; i < B43legacy_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-		b43legacy_led_blink_stop(led, 1);
-	}
-	b43legacy_leds_switch_all(dev, 0);
-}
-
-void b43legacy_leds_update(struct b43legacy_wldev *dev, int activity)
-{
-	struct b43legacy_led *led;
-	struct b43legacy_phy *phy = &dev->phy;
-	const int transferring = (jiffies - dev->stats.last_tx)
-				  < B43legacy_LED_XFER_THRES;
-	int i;
-	int turn_on;
-	unsigned long interval = 0;
-	u16 ledctl;
-	unsigned long flags;
-	bool radio_enabled = (phy->radio_on && dev->radio_hw_enable);
-
-	spin_lock_irqsave(&dev->wl->leds_lock, flags);
-	ledctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
-	for (i = 0; i < B43legacy_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-
-		turn_on = 0;
-		switch (led->behaviour) {
-		case B43legacy_LED_INACTIVE:
-			continue;
-		case B43legacy_LED_OFF:
-			break;
-		case B43legacy_LED_ON:
-			turn_on = 1;
-			break;
-		case B43legacy_LED_ACTIVITY:
-			turn_on = activity;
-			break;
-		case B43legacy_LED_RADIO_ALL:
-			turn_on = radio_enabled;
-			break;
-		case B43legacy_LED_RADIO_A:
-			break;
-		case B43legacy_LED_RADIO_B:
-			turn_on = radio_enabled;
-			break;
-		case B43legacy_LED_MODE_BG:
-			if (phy->type == B43legacy_PHYTYPE_G && radio_enabled)
-				turn_on = 1;
-			break;
-		case B43legacy_LED_TRANSFER:
-			if (transferring)
-				b43legacy_led_blink_start(led,
-						B43legacy_LEDBLINK_MEDIUM);
-			else
-				b43legacy_led_blink_stop(led, 0);
-			continue;
-		case B43legacy_LED_APTRANSFER:
-			if (b43legacy_is_mode(dev->wl,
-						IEEE80211_IF_TYPE_AP)) {
-				if (transferring) {
-					interval = B43legacy_LEDBLINK_FAST;
-					turn_on = 1;
-				}
-			} else {
-				turn_on = 1;
-				if (transferring)
-					interval = B43legacy_LEDBLINK_FAST;
-				else
-					turn_on = 0;
-			}
-			if (turn_on)
-				b43legacy_led_blink_start(led, interval);
-			else
-				b43legacy_led_blink_stop(led, 0);
-			continue;
-		case B43legacy_LED_WEIRD:
-			break;
-		case B43legacy_LED_ASSOC:
-			turn_on = 1;
-#ifdef CONFIG_B43LEGACY_DEBUG
-		case B43legacy_LED_TEST_BLINKSLOW:
-			b43legacy_led_blink_start(led, B43legacy_LEDBLINK_SLOW);
-			continue;
-		case B43legacy_LED_TEST_BLINKMEDIUM:
-			b43legacy_led_blink_start(led,
-						   B43legacy_LEDBLINK_MEDIUM);
-			continue;
-		case B43legacy_LED_TEST_BLINKFAST:
-			b43legacy_led_blink_start(led, B43legacy_LEDBLINK_FAST);
-			continue;
-#endif /* CONFIG_B43LEGACY_DEBUG */
-		default:
-			B43legacy_BUG_ON(1);
-		};
-
-		if (led->activelow)
-			turn_on = !turn_on;
-		if (turn_on)
-			ledctl |= (1 << i);
-		else
-			ledctl &= ~(1 << i);
-	}
-	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ledctl);
-	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
-}
-
-void b43legacy_leds_switch_all(struct b43legacy_wldev *dev, int on)
-{
-	struct b43legacy_led *led;
-	u16 ledctl;
-	int i;
-	int bit_on;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->wl->leds_lock, flags);
-	ledctl = b43legacy_read16(dev, B43legacy_MMIO_GPIO_CONTROL);
-	for (i = 0; i < B43legacy_NR_LEDS; i++) {
-		led = &(dev->leds[i]);
-		if (led->behaviour == B43legacy_LED_INACTIVE)
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
-	b43legacy_write16(dev, B43legacy_MMIO_GPIO_CONTROL, ledctl);
-	spin_unlock_irqrestore(&dev->wl->leds_lock, flags);
+	b43legacy_unregister_led(&dev->led_tx);
+	b43legacy_unregister_led(&dev->led_rx);
+	b43legacy_unregister_led(&dev->led_assoc);
 }
Index: wireless-2.6/drivers/net/wireless/b43legacy/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/Makefile
+++ wireless-2.6/drivers/net/wireless/b43legacy/Makefile
@@ -1,14 +1,17 @@
-obj-$(CONFIG_B43LEGACY) += b43legacy.o
-b43legacy-obj-$(CONFIG_B43LEGACY_DEBUG) += debugfs.o
+# b43legacy core
+b43legacy-y				+= main.o
+b43legacy-y				+= ilt.o
+b43legacy-y				+= phy.o
+b43legacy-y				+= radio.o
+b43legacy-y				+= sysfs.o
+b43legacy-y				+= xmit.o
+# b43legacy LED support
+b43legacy-$(CONFIG_B43LEGACY_LEDS)	+= leds.o
+# b43legacy debugging
+b43legacy-$(CONFIG_B43LEGACY_DEBUG)	+= debugfs.o
+# b43legacy DMA and PIO
+b43legacy-$(CONFIG_B43LEGACY_DMA)	+= dma.o
+b43legacy-$(CONFIG_B43LEGACY_PIO)	+= pio.o
 
-b43legacy-obj-$(CONFIG_B43LEGACY_DMA) += dma.o
-b43legacy-obj-$(CONFIG_B43LEGACY_PIO) += pio.o
+obj-$(CONFIG_B43LEGACY)			+= b43legacy.o
 
-b43legacy-objs := main.o \
-		ilt.o \
-		leds.o \
-		phy.o \
-		radio.o \
-		sysfs.o \
-		xmit.o \
-		$(b43legacy-obj-y)
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -83,10 +83,6 @@ static int modparam_long_retry = B43lega
 module_param_named(long_retry, modparam_long_retry, int, 0444);
 MODULE_PARM_DESC(long_retry, "Long-Retry-Limit (0 - 15)");
 
-static int modparam_noleds;
-module_param_named(noleds, modparam_noleds, int, 0444);
-MODULE_PARM_DESC(noleds, "Turn off all LED activity");
-
 static char modparam_fwpostfix[16];
 module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the firmware files to load.");
@@ -1217,7 +1213,6 @@ static void b43legacy_interrupt_tasklet(
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
 	int i;
-	int activity = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
@@ -1281,7 +1276,6 @@ static void b43legacy_interrupt_tasklet(
 			b43legacy_pio_rx(dev->pio.queue0);
 		else
 			b43legacy_dma_rx(dev->dma.rx_ring0);
-		/* We intentionally don't set "activity" to 1, here. */
 	}
 	B43legacy_WARN_ON(dma_reason[1] & B43legacy_DMAIRQ_RX_DONE);
 	B43legacy_WARN_ON(dma_reason[2] & B43legacy_DMAIRQ_RX_DONE);
@@ -1290,20 +1284,13 @@ static void b43legacy_interrupt_tasklet(
 			b43legacy_pio_rx(dev->pio.queue3);
 		else
 			b43legacy_dma_rx(dev->dma.rx_ring3);
-		activity = 1;
 	}
 	B43legacy_WARN_ON(dma_reason[4] & B43legacy_DMAIRQ_RX_DONE);
 	B43legacy_WARN_ON(dma_reason[5] & B43legacy_DMAIRQ_RX_DONE);
 
-	if (reason & B43legacy_IRQ_TX_OK) {
+	if (reason & B43legacy_IRQ_TX_OK)
 		handle_irq_transmit_status(dev);
-		activity = 1;
-		/* TODO: In AP mode, this also causes sending of powersave
-			 responses. */
-	}
 
-	if (!modparam_noleds)
-		b43legacy_leds_update(dev, activity);
 	b43legacy_interrupt_enable(dev, dev->irq_savedstate);
 	mmiowb();
 	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
@@ -1755,7 +1742,6 @@ static int b43legacy_gpio_init(struct b4
 			  B43legacy_MMIO_STATUS_BITFIELD)
 			  & 0xFFFF3FFF);
 
-	b43legacy_leds_switch_all(dev, 0);
 	b43legacy_write16(dev, B43legacy_MMIO_GPIO_MASK,
 			  b43legacy_read16(dev,
 			  B43legacy_MMIO_GPIO_MASK)
@@ -2008,8 +1994,7 @@ static bool b43legacy_is_hw_radio_enable
 static void b43legacy_chip_exit(struct b43legacy_wldev *dev)
 {
 	b43legacy_radio_turn_off(dev);
-	if (!modparam_noleds)
-		b43legacy_leds_exit(dev);
+	b43legacy_leds_exit(dev);
 	b43legacy_gpio_cleanup(dev);
 	/* firmware is released later */
 }
@@ -2039,9 +2024,11 @@ static int b43legacy_chip_init(struct b4
 	err = b43legacy_gpio_init(dev);
 	if (err)
 		goto out; /* firmware is released later */
+	b43legacy_leds_init(dev);
+
 	err = b43legacy_upload_initvals(dev);
 	if (err)
-		goto err_gpio_cleanup;
+		goto err_leds_exit;
 	b43legacy_radio_turn_on(dev);
 
 	b43legacy_write16(dev, 0x03E6, 0x0000);
@@ -2120,7 +2107,8 @@ out:
 
 err_radio_off:
 	b43legacy_radio_turn_off(dev);
-err_gpio_cleanup:
+err_leds_exit:
+	b43legacy_leds_exit(dev);
 	b43legacy_gpio_cleanup(dev);
 	goto out;
 }
@@ -2168,7 +2156,6 @@ static void b43legacy_periodic_every1sec
 		dev->radio_hw_enable = radio_hw_enable;
 		b43legacyinfo(dev->wl, "Radio hardware status changed to %s\n",
 		       (radio_hw_enable) ? "enabled" : "disabled");
-		b43legacy_leds_update(dev, 0);
 	}
 }
 
@@ -3494,18 +3481,13 @@ static int b43legacy_wireless_core_attac
 	else
 		have_bphy = 1;
 
-	/* Initialize LEDs structs. */
-	err = b43legacy_leds_init(dev);
-	if (err)
-		goto err_powerdown;
-
 	dev->phy.gmode = (have_gphy || have_bphy);
 	tmp = dev->phy.gmode ? B43legacy_TMSLOW_GMODE : 0;
 	b43legacy_wireless_core_reset(dev, tmp);
 
 	err = b43legacy_phy_versioning(dev);
 	if (err)
-		goto err_leds_exit;
+		goto err_powerdown;
 	/* Check if this device supports multiband. */
 	if (!pdev ||
 	    (pdev->device != 0x4312 &&
@@ -3531,10 +3513,10 @@ static int b43legacy_wireless_core_attac
 
 	err = b43legacy_validate_chipaccess(dev);
 	if (err)
-		goto err_leds_exit;
+		goto err_powerdown;
 	err = b43legacy_setup_modes(dev, have_bphy, have_gphy);
 	if (err)
-		goto err_leds_exit;
+		goto err_powerdown;
 
 	/* Now set some default "current_dev" */
 	if (!wl->current_dev)
@@ -3549,8 +3531,6 @@ static int b43legacy_wireless_core_attac
 out:
 	return err;
 
-err_leds_exit:
-	b43legacy_leds_exit(dev);
 err_powerdown:
 	ssb_bus_may_powerdown(bus);
 	return err;
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.c
@@ -2113,7 +2113,6 @@ void b43legacy_radio_turn_on(struct b43l
 		B43legacy_BUG_ON(1);
 	}
 	phy->radio_on = 1;
-	b43legacy_leds_update(dev, 0);
 }
 
 void b43legacy_radio_turn_off(struct b43legacy_wldev *dev)
@@ -2135,7 +2134,6 @@ void b43legacy_radio_turn_off(struct b43
 		b43legacy_phy_write(dev, 0x0015, 0xAA00);
 	phy->radio_on = 0;
 	b43legacydbg(dev->wl, "Radio initialized\n");
-	b43legacy_leds_update(dev, 0);
 }
 
 void b43legacy_radio_clear_tssi(struct b43legacy_wldev *dev)
Index: wireless-2.6/drivers/net/wireless/b43legacy/leds.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/leds.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/leds.h
@@ -1,30 +1,33 @@
 #ifndef B43legacy_LEDS_H_
 #define B43legacy_LEDS_H_
 
+struct b43legacy_wldev;
+
+#ifdef CONFIG_B43LEGACY_LEDS
+
 #include <linux/types.h>
-#include <linux/timer.h>
+#include <linux/leds.h>
 
 
+#define B43legacy_LED_MAX_NAME_LEN	31
+
 struct b43legacy_led {
-	u8 behaviour;
-	bool activelow;
-	/* Index in the "leds" array in b43legacy_wldev */
-	u8 index;
 	struct b43legacy_wldev *dev;
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
+	char name[B43legacy_LED_MAX_NAME_LEN + 1];
 };
 
-/* Delay between state changes when blinking in jiffies */
-#define B43legacy_LEDBLINK_SLOW		(HZ / 1)
-#define B43legacy_LEDBLINK_MEDIUM	(HZ / 4)
-#define B43legacy_LEDBLINK_FAST		(HZ / 8)
-
-#define B43legacy_LED_XFER_THRES	(HZ / 100)
-
 #define B43legacy_LED_BEHAVIOUR		0x7F
 #define B43legacy_LED_ACTIVELOW		0x80
-enum { /* LED behaviour values */
+/* LED behaviour values */
+enum b43legacy_led_behaviour {
 	B43legacy_LED_OFF,
 	B43legacy_LED_ON,
 	B43legacy_LED_ACTIVITY,
@@ -37,20 +40,24 @@ enum { /* LED behaviour values */
 	B43legacy_LED_WEIRD,
 	B43legacy_LED_ASSOC,
 	B43legacy_LED_INACTIVE,
-
-	/* Behaviour values for testing.
-	 * With these values it is easier to figure out
-	 * the real behaviour of leds, in case the SPROM
-	 * is missing information.
-	 */
-	B43legacy_LED_TEST_BLINKSLOW,
-	B43legacy_LED_TEST_BLINKMEDIUM,
-	B43legacy_LED_TEST_BLINKFAST,
 };
 
-int b43legacy_leds_init(struct b43legacy_wldev *dev);
+void b43legacy_leds_init(struct b43legacy_wldev *dev);
 void b43legacy_leds_exit(struct b43legacy_wldev *dev);
-void b43legacy_leds_update(struct b43legacy_wldev *dev, int activity);
-void b43legacy_leds_switch_all(struct b43legacy_wldev *dev, int on);
+
+#else /* CONFIG_B43EGACY_LEDS */
+/* LED support disabled */
+
+struct b43legacy_led {
+	/* empty */
+};
+
+static inline void b43legacy_leds_init(struct b43legacy_wldev *dev)
+{
+}
+static inline void b43legacy_leds_exit(struct b43legacy_wldev *dev)
+{
+}
+#endif /* CONFIG_B43LEGACY_LEDS */
 
 #endif /* B43legacy_LEDS_H_ */
