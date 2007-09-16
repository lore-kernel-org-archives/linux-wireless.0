Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbXIPMIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:11 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:11 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/24] rt2x00: Remove rt2x00mac_reset()
Date: Sun, 16 Sep 2007 14:18:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.44822.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00mac_reset() only had a single caller which
didn't require the shutdown part of the function.
This means the time has come to remove the function
completely and have the resume handler perform all
tasks itself.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 +-
 drivers/net/wireless/rt2x00/rt2x00config.c |   12 +++---
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   49 ++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   47 --------------------------
 4 files changed, 47 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5ecabc8..b5f408c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -513,7 +513,7 @@ struct rt2x00_dev {
 #define REQUIRE_FIRMWARE		5
 #define PACKET_FILTER_SCHEDULED		6
 #define PACKET_FILTER_PENDING		7
-#define INTERFACE_RESET			8
+#define INTERFACE_RESUME		8
 #define INTERFACE_ENABLED		9
 #define INTERFACE_ENABLED_MONITOR	10
 #define REQUIRE_BEACON_RING		11
@@ -776,7 +776,6 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  */
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ieee80211_tx_control *control);
-int rt2x00mac_reset(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf);
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index b5075b5..de890a1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -50,10 +50,10 @@ void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter)
 {
 	/*
 	 * Only configure the device when something has changed,
-	 * or if we are in RESET state in which case all configuration
+	 * or if we are in RESUME state in which case all configuration
 	 * will be forced upon the device.
 	 */
-	if (!test_bit(INTERFACE_RESET, &rt2x00dev->flags) &&
+	if (!test_bit(INTERFACE_RESUME, &rt2x00dev->flags) &&
 	    !test_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags))
 		return;
 
@@ -82,10 +82,10 @@ void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type)
 
 	/*
 	 * Only configure the device when something has changed,
-	 * or if we are in RESET state in which case all configuration
+	 * or if we are in RESUME state in which case all configuration
 	 * will be forced upon the device.
 	 */
-	if (!test_bit(INTERFACE_RESET, &rt2x00dev->flags) &&
+	if (!test_bit(INTERFACE_RESUME, &rt2x00dev->flags) &&
 	    (!(is_interface_present(intf) ^
 	       test_bit(INTERFACE_ENABLED, &rt2x00dev->flags)) &&
 	     !(is_monitor_present(intf) ^
@@ -119,10 +119,10 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev, struct ieee80211_conf *conf)
 	int flags = 0;
 
 	/*
-	 * If we are in RESET state we should
+	 * If we are in RESUME state we should
 	 * force all configuration options.
 	 */
-	if (test_bit(INTERFACE_RESET, &rt2x00dev->flags)) {
+	if (test_bit(INTERFACE_RESUME, &rt2x00dev->flags)) {
 		flags = CONFIG_UPDATE_ALL;
 		goto config;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 81458bf..7730d9d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -944,12 +944,6 @@ void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev)
 		rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 		rt2x00lib_config_type(rt2x00dev, intf->type);
 	}
-
-	/*
-	 * If we are in reset mode, the device must be deinitialized.
-	 */
-	if (test_bit(INTERFACE_RESET, &rt2x00dev->flags))
-		rt2x00lib_uninitialize(rt2x00dev);
 }
 
 /*
@@ -1136,7 +1130,11 @@ EXPORT_SYMBOL_GPL(rt2x00lib_suspend);
 
 int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 {
+	struct interface *intf = &rt2x00dev->interface;
+	int retval;
+
 	NOTICE(rt2x00dev, "Waking up.\n");
+	__set_bit(INTERFACE_RESUME, &rt2x00dev->flags);
 
 	/*
 	 * Open the debugfs entry.
@@ -1144,10 +1142,43 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	rt2x00debug_register(rt2x00dev);
 
 	/*
-	 * The reset handler can take care of bringing the
-	 * device back into a workable state.
+	 * Reinitialize device and all active interfaces.
+	 */
+	retval = rt2x00lib_init_interface(rt2x00dev);
+	if (retval)
+		goto exit;
+
+	/*
+	 * Reconfigure device.
+	 */
+	retval = rt2x00mac_config(rt2x00dev->hw, &rt2x00dev->hw->conf);
+	if (retval)
+		goto exit;
+
+	rt2x00lib_config_type(rt2x00dev, intf->type);
+	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
+	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
+
+	/*
+	 * When in Master or Ad-hoc mode,
+	 * restart Beacon transmitting by faking a beacondone event.
 	 */
-	return rt2x00mac_reset(rt2x00dev->hw);
+	if (intf->type == IEEE80211_IF_TYPE_AP ||
+	    intf->type == IEEE80211_IF_TYPE_IBSS)
+		rt2x00lib_beacondone(rt2x00dev);
+
+	__clear_bit(INTERFACE_RESUME, &rt2x00dev->flags);
+
+	return 0;
+
+exit:
+	rt2x00lib_disable_radio(rt2x00dev);
+	rt2x00lib_uninitialize(rt2x00dev);
+	rt2x00debug_deregister(rt2x00dev);
+
+	__clear_bit(INTERFACE_RESUME, &rt2x00dev->flags);
+
+	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_resume);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 0001b79..006154c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -121,53 +121,6 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
 
-int rt2x00mac_reset(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
-	int retval;
-
-	NOTICE(rt2x00dev, "Entering reset state.\n");
-	__set_bit(INTERFACE_RESET, &rt2x00dev->flags);
-
-	/*
-	 * Disable radio and unitialize all items
-	 * that we will recreate to reset the device.
-	 */
-	rt2x00lib_disable_radio(rt2x00dev);
-	rt2x00lib_deinit_interface(rt2x00dev);
-
-	/*
-	 * Reinitialize device and all active interfaces.
-	 */
-	retval = rt2x00lib_init_interface(rt2x00dev);
-	if (retval)
-		goto exit;
-
-	/*
-	 * Reconfigure device.
-	 */
-	rt2x00lib_config(rt2x00dev, &hw->conf);
-	rt2x00lib_config_type(rt2x00dev, intf->type);
-	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
-	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
-
-	/*
-	 * When in Master or Ad-hoc mode,
-	 * restart Beacon transmitting by faking a beacondone event.
-	 */
-	if (intf->type == IEEE80211_IF_TYPE_AP ||
-	    intf->type == IEEE80211_IF_TYPE_IBSS)
-		rt2x00lib_beacondone(rt2x00dev);
-
-exit:
-	__clear_bit(INTERFACE_RESET, &rt2x00dev->flags);
-	NOTICE(rt2x00dev, "Device reset %s.\n",
-	       retval ? "failed" : "succeeded");
-
-	return retval;
-}
-
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf)
 {
-- 
1.5.3
