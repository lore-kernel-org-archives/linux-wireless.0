Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.145]:34061 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZGANRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 09:17:36 -0400
Received: by ey-out-1920.google.com with SMTP id 3so200164eyh.36
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 06:17:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: use wiphy rfkill interface
Date: Wed, 1 Jul 2009 15:17:35 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907011517.35638.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the input_polldev from rt2x00 and replace it with
the rfkill interface offered by the wiphy structure. This
simplifies the entire rfkill handling in rt2x00 and allows
us to remove the CONFIG_RT2X00_LIB_RFKILL option and always
enables rfkill capabilities.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig        |    8 --
 drivers/net/wireless/rt2x00/Makefile       |    1 -
 drivers/net/wireless/rt2x00/rt2400pci.c    |    7 +--
 drivers/net/wireless/rt2x00/rt2500pci.c    |    7 +--
 drivers/net/wireless/rt2x00/rt2500usb.c    |    7 +--
 drivers/net/wireless/rt2x00/rt2800usb.c    |    7 +--
 drivers/net/wireless/rt2x00/rt2x00.h       |   13 +---
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    2 -
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   21 +----
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    9 ++
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |  127 ----------------------------
 drivers/net/wireless/rt2x00/rt61pci.c      |    7 +--
 drivers/net/wireless/rt2x00/rt73usb.c      |    7 +--
 13 files changed, 20 insertions(+), 203 deletions(-)
 delete mode 100644 drivers/net/wireless/rt2x00/rt2x00rfkill.c

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index b6e8fb4..96f9d61 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -142,14 +142,6 @@ config RT2X00_LIB_FIRMWARE
 config RT2X00_LIB_CRYPTO
 	boolean
 
-config RT2X00_LIB_RFKILL
-	boolean
-	default y if (RT2X00_LIB=y && INPUT=y) || (RT2X00_LIB=m && INPUT!=n)
-	select INPUT_POLLDEV
-
-comment "rt2x00 rfkill support disabled due to modularized INPUT and built-in rt2x00"
-	depends on RT2X00_LIB=y && INPUT=m
-
 config RT2X00_LIB_LEDS
 	boolean
 	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index 2d1be47..912f5f6 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -5,7 +5,6 @@ rt2x00lib-y				+= rt2x00queue.o
 rt2x00lib-y				+= rt2x00link.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_DEBUGFS)	+= rt2x00debug.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_CRYPTO)	+= rt2x00crypto.o
-rt2x00lib-$(CONFIG_RT2X00_LIB_RFKILL)	+= rt2x00rfkill.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_FIRMWARE)	+= rt2x00firmware.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_LEDS)	+= rt2x00leds.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_HT)	+= rt2x00ht.o
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 435f945..d8035e3 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -199,7 +199,6 @@ static const struct rt2x00debug rt2400pci_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -207,9 +206,6 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
 }
-#else
-#define rt2400pci_rfkill_poll	NULL
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2400pci_brightness_set(struct led_classdev *led_cdev,
@@ -1391,10 +1387,8 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be enabled.
@@ -1573,6 +1567,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2400pci_get_tsf,
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
 static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 08b30d0..c123e28 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -199,7 +199,6 @@ static const struct rt2x00debug rt2500pci_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -207,9 +206,6 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
 }
-#else
-#define rt2500pci_rfkill_poll	NULL
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2500pci_brightness_set(struct led_classdev *led_cdev,
@@ -1548,10 +1544,8 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be enabled.
@@ -1872,6 +1866,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2500pci_get_tsf,
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
 static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 66daf68..795706d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -277,7 +277,6 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u16 reg;
@@ -285,9 +284,6 @@ static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
 	return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
 }
-#else
-#define rt2500usb_rfkill_poll	NULL
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2500usb_brightness_set(struct led_classdev *led_cdev,
@@ -1601,10 +1597,8 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be disabled.
@@ -1905,6 +1899,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
 static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3756166..a204e66 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -264,7 +264,6 @@ static const struct rt2x00debug rt2800usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt2800usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -272,9 +271,6 @@ static int rt2800usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
 	return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
 }
-#else
-#define rt2800usb_rfkill_poll	NULL
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt2800usb_brightness_set(struct led_classdev *led_cdev,
@@ -2385,10 +2381,8 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_HW_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Store led settings, for correct led behaviour.
@@ -2800,6 +2794,7 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.conf_tx		= rt2800usb_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2800usb_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 509ab90..de3f13a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -657,18 +657,6 @@ struct rt2x00_dev {
 	enum ieee80211_band curr_band;
 
 	/*
-	 * rfkill structure for RF state switching support.
-	 * This will only be compiled in when required.
-	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
-	unsigned long rfkill_state;
-#define RFKILL_STATE_ALLOCATED		1
-#define RFKILL_STATE_REGISTERED		2
-#define RFKILL_STATE_BLOCKED		3
-	struct input_polled_dev *rfkill_poll_dev;
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
-
-	/*
 	 * If enabled, the debugfs interface structures
 	 * required for deregistration of debugfs.
 	 */
@@ -998,6 +986,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				u32 changes);
 int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
+void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
 
 /*
  * Driver allocation handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 41e3379..4fff3a8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -871,7 +871,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00link_register(rt2x00dev);
 	rt2x00leds_register(rt2x00dev);
-	rt2x00rfkill_allocate(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
 
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
@@ -903,7 +902,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free extra components
 	 */
 	rt2x00debug_deregister(rt2x00dev);
-	rt2x00rfkill_free(rt2x00dev);
 	rt2x00leds_unregister(rt2x00dev);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 39e00b3..2c3c239 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -30,10 +30,8 @@
 
 /*
  * Interval defines
- * Both the link tuner as the rfkill will be called once per second.
  */
 #define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
-#define RFKILL_POLL_INTERVAL	1000
 
 /*
  * rt2x00_rate: Per rate device information
@@ -386,29 +384,18 @@ static inline void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 /*
  * RFkill handlers.
  */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
-void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
-#else
 static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
+	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+		wiphy_rfkill_start_polling(rt2x00dev->hw->wiphy);
 }
 
 static inline void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
+	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+		wiphy_rfkill_stop_polling(rt2x00dev->hw->wiphy);
 }
 
-static inline void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
-{
-}
-
-static inline void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
-{
-}
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
-
 /*
  * LED handlers
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 475a3ed..b7e0ddd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -688,3 +688,12 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_conf_tx);
+
+void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	bool blocked = !!rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
+
+	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_rfkill_poll);
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
deleted file mode 100644
index b6d4c67..0000000
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ /dev/null
@@ -1,127 +0,0 @@
-/*
-	Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
-	<http://rt2x00.serialmonkey.com>
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the
-	Free Software Foundation, Inc.,
-	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-/*
-	Module: rt2x00rfkill
-	Abstract: rt2x00 rfkill routines.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include "rt2x00.h"
-#include "rt2x00lib.h"
-
-static void rt2x00rfkill_poll(struct input_polled_dev *poll_dev)
-{
-	struct rt2x00_dev *rt2x00dev = poll_dev->private;
-	int state, old_state;
-
-	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state) ||
-	    !test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
-		return;
-
-	/*
-	 * Poll latest state, if the state is different then the previous state,
-	 * we should generate an input event.
-	 */
-	state = !!rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
-	old_state = !!test_bit(RFKILL_STATE_BLOCKED, &rt2x00dev->rfkill_state);
-
-	if (old_state != state) {
-		input_report_switch(poll_dev->input, SW_RFKILL_ALL, state);
-		change_bit(RFKILL_STATE_BLOCKED, &rt2x00dev->rfkill_state);
-	}
-}
-
-void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
-	    test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
-		return;
-
-	if (input_register_polled_device(rt2x00dev->rfkill_poll_dev)) {
-		ERROR(rt2x00dev, "Failed to register polled device.\n");
-		return;
-	}
-
-	__set_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
-
-	/*
-	 * Force initial poll which will detect the initial device state,
-	 * and correctly sends the signal to the input layer about this
-	 * state.
-	 */
-	rt2x00rfkill_poll(rt2x00dev->rfkill_poll_dev);
-}
-
-void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
-	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
-		return;
-
-	input_unregister_polled_device(rt2x00dev->rfkill_poll_dev);
-
-	__clear_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
-}
-
-void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
-{
-	struct input_polled_dev *poll_dev;
-
-	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
-	    !test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
-		return;
-
-	poll_dev = input_allocate_polled_device();
-	if (!poll_dev) {
-		ERROR(rt2x00dev, "Failed to allocate polled device.\n");
-		return;
-	}
-
-	poll_dev->private = rt2x00dev;
-	poll_dev->poll = rt2x00rfkill_poll;
-	poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
-
-	poll_dev->input->name = rt2x00dev->ops->name;
-	poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
-	poll_dev->input->id.bustype = BUS_HOST;
-	poll_dev->input->id.vendor = 0x1814;
-	poll_dev->input->id.product = rt2x00dev->chip.rt;
-	poll_dev->input->id.version = rt2x00dev->chip.rev;
-	poll_dev->input->dev.parent = wiphy_dev(rt2x00dev->hw->wiphy);
-	poll_dev->input->evbit[0] = BIT(EV_SW);
-	poll_dev->input->swbit[0] = BIT(SW_RFKILL_ALL);
-
-	rt2x00dev->rfkill_poll_dev = poll_dev;
-
-	__set_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state);
-}
-
-void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
-{
-	if (!__test_and_clear_bit(RFKILL_STATE_ALLOCATED,
-				  &rt2x00dev->rfkill_state))
-		return;
-
-	input_free_polled_device(rt2x00dev->rfkill_poll_dev);
-	rt2x00dev->rfkill_poll_dev = NULL;
-}
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 49b29ff..8a49d99 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -237,7 +237,6 @@ static const struct rt2x00debug rt61pci_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -245,9 +244,6 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
 	return rt2x00_get_field32(reg, MAC_CSR13_BIT5);
 }
-#else
-#define rt61pci_rfkill_poll	NULL
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt61pci_brightness_set(struct led_classdev *led_cdev,
@@ -2338,10 +2334,8 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Read frequency offset and RF programming sequence.
@@ -2728,6 +2722,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.conf_tx		= rt61pci_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index c188488..ad2898c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -183,7 +183,6 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt73usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -191,9 +190,6 @@ static int rt73usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
 	return rt2x00_get_field32(reg, MAC_CSR13_BIT7);
 }
-#else
-#define rt73usb_rfkill_poll	NULL
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
 static void rt73usb_brightness_set(struct led_classdev *led_cdev,
@@ -1863,10 +1859,8 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Read frequency offset.
@@ -2253,6 +2247,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.conf_tx		= rt73usb_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt73usb_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
-- 
1.6.3.1

