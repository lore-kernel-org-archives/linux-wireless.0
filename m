Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:8076 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXIYSor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:47 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2123530fkz
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:46 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/12] rt2x00: Reorganize rt2x00dev->flags
Date: Tue, 25 Sep 2007 20:55:39 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252055.40003.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2x00dev->flags has become a chaos over time,
this will reorganize the flags by renaming, deleting, adding
and properly implement the flags.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c    |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |   31 +++++++---------
 drivers/net/wireless/rt2x00/rt2x00config.c |   27 ++++----------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   55 ++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   55 +++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   12 +++---
 drivers/net/wireless/rt2x00/rt61pci.c      |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |    2 +-
 11 files changed, 115 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 03a94a3..faa4711 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1374,7 +1374,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Detect if this device has an hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
-		__set_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
 
 	/*
 	 * Check if the BBP tuning should be enabled.
@@ -1469,7 +1469,7 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires the beacon ring
 	 */
-	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 892baa9..929257d 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1545,7 +1545,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Detect if this device has an hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
-		__set_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
 
 	/*
 	 * Check if the BBP tuning should be enabled.
@@ -1801,7 +1801,7 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires the beacon ring
 	 */
-	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f4e6f6e..7aacc7b 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1573,7 +1573,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires the beacon ring
 	 */
-	__set_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5f05c7e..ea20f3a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -493,24 +493,21 @@ struct rt2x00_dev {
 	 * of the device capabilities are stored.
 	 */
 	unsigned long flags;
-#define DEVICE_ENABLED_RADIO		1
-#define DEVICE_ENABLED_RADIO_HW		2
+#define DEVICE_PRESENT			1
+#define DEVICE_REGISTERED_HW		2
 #define DEVICE_INITIALIZED		3
-#define DEVICE_INITIALIZED_HW		4
-#define REQUIRE_FIRMWARE		5
-/* Hole: Add new Flag here */
-#define INTERFACE_RESUME		8
-#define INTERFACE_ENABLED		9
-/* Hole: Add new Flag here */
-#define REQUIRE_BEACON_RING		11
-#define DEVICE_SUPPORT_HW_BUTTON	12
-#define CONFIG_FRAME_TYPE		13
-#define CONFIG_RF_SEQUENCE		14
-/* Hole: Add new Flag here */
-#define CONFIG_EXTERNAL_LNA_A		16
-#define CONFIG_EXTERNAL_LNA_BG		17
-#define CONFIG_DOUBLE_ANTENNA		18
-#define CONFIG_DISABLE_LINK_TUNING	19
+#define DEVICE_STARTED			4
+#define DEVICE_ENABLED_RADIO		5
+#define DEVICE_ENABLED_RADIO_HW		6
+#define DRIVER_REQUIRE_FIRMWARE		7
+#define DRIVER_REQUIRE_BEACON_RING	8
+#define CONFIG_SUPPORT_HW_BUTTON	9
+#define CONFIG_FRAME_TYPE		10
+#define CONFIG_RF_SEQUENCE		11
+#define CONFIG_EXTERNAL_LNA_A		12
+#define CONFIG_EXTERNAL_LNA_BG		13
+#define CONFIG_DOUBLE_ANTENNA		14
+#define CONFIG_DISABLE_LINK_TUNING	15
 
 	/*
 	 * Chipset identification.
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index f962ce4..13b5106 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -48,33 +48,20 @@ void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type)
 {
-	struct interface *intf = &rt2x00dev->interface;
-
-	if (!test_bit(INTERFACE_RESUME, &rt2x00dev->flags) &&
-	    (!!test_bit(INTERFACE_ENABLED, &rt2x00dev->flags) ==
-	     !!is_interface_present(intf)))
-		return;
-
-	rt2x00dev->ops->lib->config_type(rt2x00dev, type);
-
-	/*
-	 * Update the configuration flags.
-	 */
-	if (is_interface_present(intf))
-		__set_bit(INTERFACE_ENABLED, &rt2x00dev->flags);
-	else
-		__clear_bit(INTERFACE_ENABLED, &rt2x00dev->flags);
+	if (type != INVALID_INTERFACE)
+		rt2x00dev->ops->lib->config_type(rt2x00dev, type);
 }
 
-void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf)
+void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
+		      struct ieee80211_conf *conf, const int force_config)
 {
 	int flags = 0;
 
 	/*
-	 * If we are in RESUME state we should
-	 * force all configuration options.
+	 * In some situations we want to force all configurations
+	 * to be reloaded (When resuming for instance).
 	 */
-	if (test_bit(INTERFACE_RESUME, &rt2x00dev->flags)) {
+	if (force_config) {
 		flags = CONFIG_UPDATE_ALL;
 		goto config;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 4f66adc..f8f7e6e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -40,7 +40,7 @@
 struct data_ring *rt2x00lib_get_ring(struct rt2x00_dev *rt2x00dev,
 				     const unsigned int queue)
 {
-	int beacon = test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags);
+	int beacon = test_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags);
 
 	/*
 	 * Check if we are requesting a reqular TX ring,
@@ -102,7 +102,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * And check if the hardware button has been disabled.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    (test_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags) &&
+	    (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) &&
 	     !test_bit(DEVICE_ENABLED_RADIO_HW, &rt2x00dev->flags)))
 		return 0;
 
@@ -162,6 +162,9 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 {
 	enum dev_state state = enable ? STATE_RADIO_RX_ON : STATE_RADIO_RX_OFF;
 
+	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
 	/*
 	 * When we are disabling the RX, we should also stop the link tuner.
 	 */
@@ -721,7 +724,7 @@ exit:
 
 static void rt2x00lib_remove_hw(struct rt2x00_dev *rt2x00dev)
 {
-	if (test_bit(DEVICE_INITIALIZED_HW, &rt2x00dev->flags))
+	if (test_bit(DEVICE_REGISTERED_HW, &rt2x00dev->flags))
 		ieee80211_unregister_hw(rt2x00dev->hw);
 
 	if (likely(rt2x00dev->hwmodes)) {
@@ -753,7 +756,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return status;
 	}
 
-	__set_bit(DEVICE_INITIALIZED_HW, &rt2x00dev->flags);
+	__set_bit(DEVICE_REGISTERED_HW, &rt2x00dev->flags);
 
 	return 0;
 }
@@ -810,7 +813,7 @@ static int rt2x00lib_alloc_ring_entries(struct rt2x00_dev *rt2x00dev)
 			return -ENOMEM;
 	}
 
-	if (!test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags))
+	if (!test_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags))
 		return 0;
 
 	/*
@@ -919,7 +922,7 @@ static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 	 * Atim: 1 (if required)
 	 */
 	rt2x00dev->data_rings = 1 + rt2x00dev->hw->queues +
-	    (2 * test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags));
+	    (2 * test_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags));
 
 	ring = kzalloc(rt2x00dev->data_rings * sizeof(*ring), GFP_KERNEL);
 	if (!ring) {
@@ -932,7 +935,7 @@ static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->rx = ring;
 	rt2x00dev->tx = &rt2x00dev->rx[1];
-	if (test_bit(REQUIRE_BEACON_RING, &rt2x00dev->flags))
+	if (test_bit(DRIVER_REQUIRE_BEACON_RING, &rt2x00dev->flags))
 		rt2x00dev->bcn = &rt2x00dev->tx[rt2x00dev->hw->queues];
 
 	/*
@@ -1011,6 +1014,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00debug_register(rt2x00dev);
 
+	__set_bit(DEVICE_PRESENT, &rt2x00dev->flags);
+
 	return 0;
 
 exit:
@@ -1022,6 +1027,8 @@ EXPORT_SYMBOL_GPL(rt2x00lib_probe_dev);
 
 void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 {
+	__clear_bit(DEVICE_PRESENT, &rt2x00dev->flags);
+
 	/*
 	 * Disable radio.
 	 */
@@ -1068,6 +1075,13 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	int retval;
 
 	NOTICE(rt2x00dev, "Going to sleep.\n");
+	__clear_bit(DEVICE_PRESENT, &rt2x00dev->flags);
+
+	/*
+	 * Only continue if mac80211 has open interfaces.
+	 */
+	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
+		goto exit;
 
 	/*
 	 * Disable radio and unitialize all items
@@ -1077,6 +1091,7 @@ int rt2x00lib_suspend(struct rt2x00_dev *rt2x00dev, pm_message_t state)
 	rt2x00lib_uninitialize(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
+exit:
 	/*
 	 * Set device mode to sleep for power management.
 	 */
@@ -1094,7 +1109,7 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	int retval;
 
 	NOTICE(rt2x00dev, "Waking up.\n");
-	__set_bit(INTERFACE_RESUME, &rt2x00dev->flags);
+	__set_bit(DEVICE_PRESENT, &rt2x00dev->flags);
 
 	/*
 	 * Open the debugfs entry.
@@ -1102,6 +1117,12 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	rt2x00debug_register(rt2x00dev);
 
 	/*
+	 * Only continue if mac80211 has open interfaces.
+	 */
+	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
+		return 0;
+
+	/*
 	 * Reinitialize device and all active interfaces.
 	 */
 	retval = rt2x00mac_start(rt2x00dev->hw);
@@ -1111,15 +1132,23 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reconfigure device.
 	 */
-	retval = rt2x00mac_config(rt2x00dev->hw, &rt2x00dev->hw->conf);
-	if (retval)
-		goto exit;
+	rt2x00lib_config(rt2x00dev, &rt2x00dev->hw->conf, 1);
+	if (!rt2x00dev->hw->conf.radio_enabled)
+		rt2x00lib_disable_radio(rt2x00dev);
 
 	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
 	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 	rt2x00lib_config_type(rt2x00dev, intf->type);
 
 	/*
+	 * It is possible that during that mac80211 has attempted
+	 * to send frames while we were suspending or resuming.
+	 * In that case we have disabled the TX queue and should
+	 * now enable it again
+	 */
+	ieee80211_start_queues(rt2x00dev->hw);
+
+	/*
 	 * When in Master or Ad-hoc mode,
 	 * restart Beacon transmitting by faking a beacondone event.
 	 */
@@ -1127,8 +1156,6 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	    intf->type == IEEE80211_IF_TYPE_IBSS)
 		rt2x00lib_beacondone(rt2x00dev);
 
-	__clear_bit(INTERFACE_RESUME, &rt2x00dev->flags);
-
 	return 0;
 
 exit:
@@ -1136,8 +1163,6 @@ exit:
 	rt2x00lib_uninitialize(rt2x00dev);
 	rt2x00debug_deregister(rt2x00dev);
 
-	__clear_bit(INTERFACE_RESUME, &rt2x00dev->flags);
-
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index fcc2ffd..6dd92eb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -52,7 +52,8 @@ void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac);
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid);
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type);
-void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf);
+void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
+		      struct ieee80211_conf *conf, const int force_config);
 
 /*
  * Firmware handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 17802f6..e98d013 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -82,6 +82,17 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	u16 frame_control;
 
 	/*
+	 * Mac80211 might be calling this function while we are trying
+	 * to remove the device or perhaps suspending it.
+	 * Note that we can only stop the TX queues inside the TX path
+	 * due to possible race conditions in mac80211.
+	 */
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags)) {
+		ieee80211_stop_queues(hw);
+		return 0;
+	}
+
+	/*
 	 * Determine which ring to put packet on.
 	 */
 	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
@@ -126,14 +137,15 @@ int rt2x00mac_start(struct ieee80211_hw *hw)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	int status;
 
-	if (test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags) ||
+	    test_bit(DEVICE_STARTED, &rt2x00dev->flags))
 		return 0;
 
 	/*
 	 * If this is the first interface which is added,
 	 * we should load the firmware now.
 	 */
-	if (test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
+	if (test_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
 		status = rt2x00lib_load_firmware(rt2x00dev);
 		if (status)
 			return status;
@@ -155,6 +167,8 @@ int rt2x00mac_start(struct ieee80211_hw *hw)
 		return status;
 	}
 
+	__set_bit(DEVICE_STARTED, &rt2x00dev->flags);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_start);
@@ -163,11 +177,16 @@ void rt2x00mac_stop(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags))
+		return;
+
 	/*
 	 * Perhaps we can add something smarter here,
 	 * but for now just disabling the radio should do.
 	 */
 	rt2x00lib_disable_radio(rt2x00dev);
+
+	__clear_bit(DEVICE_STARTED, &rt2x00dev->flags);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_stop);
 
@@ -178,9 +197,12 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	struct interface *intf = &rt2x00dev->interface;
 
 	/*
-	 * We only support 1 non-monitor interface.
+	 * Don't allow interfaces to be added while
+	 * either the device has disappeared or when
+	 * another interface is already present.
 	 */
-	if (is_interface_present(intf))
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags) ||
+	    is_interface_present(intf))
 		return -ENOBUFS;
 
 	intf->id = conf->if_id;
@@ -208,9 +230,12 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 	struct interface *intf = &rt2x00dev->interface;
 
 	/*
-	 * We only support 1 non-monitor interface.
+	 * Don't allow interfaces to be remove while
+	 * either the device has disappeared or when
+	 * no interface is present.
 	 */
-	if (!is_interface_present(intf))
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags) ||
+	    !is_interface_present(intf))
 		return;
 
 	intf->id = 0;
@@ -233,12 +258,10 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	/*
-	 * If the device is not initialized we shouldn't accept
-	 * any configuration changes. Mac80211 might be calling
-	 * this function while we are trying to remove the device
-	 * or perhaps suspending it.
+	 * Mac80211 might be calling this function while we are trying
+	 * to remove the device or perhaps suspending it.
 	 */
-	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags))
 		return 0;
 
 	/*
@@ -252,7 +275,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 			rt2x00lib_toggle_rx(rt2x00dev, 0);
 	}
 
-	rt2x00lib_config(rt2x00dev, conf);
+	rt2x00lib_config(rt2x00dev, conf, 0);
 
 	/*
 	 * Reenable RX only if the radio should be on.
@@ -274,12 +297,10 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
 	int status;
 
 	/*
-	 * If the device is not initialized we shouldn't accept
-	 * any configuration changes. Mac80211 might be calling
-	 * this function while we are trying to remove the device
-	 * or perhaps suspending it.
+	 * Mac80211 might be calling this function while we are trying
+	 * to remove the device or perhaps suspending it.
 	 */
-	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags))
 		return 0;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index b54457c..06af014 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -45,9 +45,9 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
 		return 0;
 
 	/*
-	 * Only continue if we have an active interface.
+	 * Only continue if there are enabled interfaces.
 	 */
-	if (!is_interface_present(&rt2x00dev->interface))
+	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
 		return 0;
 
 	if (state == RFKILL_STATE_ON) {
@@ -76,7 +76,7 @@ int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	if (!test_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return 0;
 
 	retval = rfkill_register(rt2x00dev->rfkill);
@@ -97,7 +97,7 @@ int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
 	input_unregister_polled_device(rt2x00dev->poll_dev);
@@ -108,7 +108,7 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 {
 	struct device *device = wiphy_dev(rt2x00dev->hw->wiphy);
 
-	if (!test_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return 0;
 
 	rt2x00dev->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
@@ -138,7 +138,7 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
 	input_free_polled_device(rt2x00dev->poll_dev);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3edcd74..4c5e317 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2105,7 +2105,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Detect if this device has an hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
-		__set_bit(DEVICE_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
+		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
 
 	/*
 	 * Read frequency offset and RF programming sequence.
@@ -2360,7 +2360,7 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires firmware
 	 */
-	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b18cc93..ffed3ec 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1827,7 +1827,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires firmware
 	 */
-	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.5.3.2

