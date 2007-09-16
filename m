Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXIPMIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:40 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 22/24] rt2x00: Add start/stop handlers
Date: Sun, 16 Sep 2007 14:19:39 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.40841.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the patch by Johannes Berg, mandatory start and stop handlers
will be added to the mac80211 ops structure.
The patch has not yet been applied to wireless-dev, but this
patch will already create the handlers and will temporarily
be called from add_interface and remove_interface.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |   73 ++--------------------------
 drivers/net/wireless/rt2x00/rt2x00lib.h |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |   80 +++++++++++++++++++++++++++++--
 4 files changed, 84 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c18875b..1681749 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -776,6 +776,8 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
  */
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ieee80211_tx_control *control);
+int rt2x00mac_start(struct ieee80211_hw *hw);
+void rt2x00mac_stop(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf);
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c0bdf63..cd82eef 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -821,7 +821,7 @@ static void rt2x00lib_free_ring_entries(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
+void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	if (!__test_and_clear_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
 		return;
@@ -842,7 +842,7 @@ static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_free_ring_entries(rt2x00dev);
 }
 
-static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
+int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
 
@@ -885,70 +885,6 @@ exit:
 	return status;
 }
 
-int rt2x00lib_init_interface(struct rt2x00_dev *rt2x00dev)
-{
-	struct interface *intf = &rt2x00dev->interface;
-	int status;
-
-	/*
-	 * If this is the first interface which is added,
-	 * we should load the firmware now.
-	 */
-	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags) &&
-	    test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
-		status = rt2x00lib_load_firmware(rt2x00dev);
-		if (status)
-			return status;
-	}
-
-	/*
-	 * We should configure the MAC address before
-	 * the initialization starts.
-	 */
-	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
-
-	/*
-	 * Initialize interface and enable the radio.
-	 */
-	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags)) {
-		/*
-		 * Initialize the device.
-		 */
-		status = rt2x00lib_initialize(rt2x00dev);
-		if (status)
-			return status;
-
-		/*
-		 * Enable radio.
-		 */
-		status = rt2x00lib_enable_radio(rt2x00dev);
-		if (status) {
-			rt2x00lib_uninitialize(rt2x00dev);
-			return status;
-		}
-	}
-
-	return 0;
-}
-
-void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev)
-{
-	struct interface *intf = &rt2x00dev->interface;
-
-	/*
-	 * If no interfaces are present, we should disable the radio
-	 * Otherwise configure the mac_address and bssid and check
-	 * which interface needs to be initialized.
-	 */
-	if (!is_monitor_present(intf) && !is_interface_present(intf))
-		rt2x00lib_disable_radio(rt2x00dev);
-	else if (is_monitor_present(intf) ^ is_interface_present(intf)) {
-		rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
-		rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
-		rt2x00lib_config_type(rt2x00dev, intf->type);
-	}
-}
-
 /*
  * driver allocation handlers.
  */
@@ -1148,7 +1084,7 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reinitialize device and all active interfaces.
 	 */
-	retval = rt2x00lib_init_interface(rt2x00dev);
+	retval = rt2x00mac_start(rt2x00dev->hw);
 	if (retval)
 		goto exit;
 
@@ -1159,9 +1095,10 @@ int rt2x00lib_resume(struct rt2x00_dev *rt2x00dev)
 	if (retval)
 		goto exit;
 
+	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
+	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 	rt2x00lib_config_type(rt2x00dev, intf->type);
 	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
-	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
 
 	/*
 	 * When in Master or Ad-hoc mode,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 454e022..3324090 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -43,8 +43,8 @@ void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev);
 /*
  * Initialization handlers.
  */
-int rt2x00lib_init_interface(struct rt2x00_dev *rt2x00dev);
-void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev);
+int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Configuration handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 006154c..778ed41 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -121,6 +121,56 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
 
+int rt2x00mac_start(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	int status;
+
+	if (test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+		return 0;
+
+	/*
+	 * If this is the first interface which is added,
+	 * we should load the firmware now.
+	 */
+	if (test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
+		status = rt2x00lib_load_firmware(rt2x00dev);
+		if (status)
+			return status;
+	}
+
+	/*
+	 * Initialize the device.
+	 */
+	status = rt2x00lib_initialize(rt2x00dev);
+	if (status)
+		return status;
+
+	/*
+	 * Enable radio.
+	 */
+	status = rt2x00lib_enable_radio(rt2x00dev);
+	if (status) {
+		rt2x00lib_uninitialize(rt2x00dev);
+		return status;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_start);
+
+void rt2x00mac_stop(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Perhaps we can add something smarter here,
+	 * but for now just disabling the radio should do.
+	 */
+	rt2x00lib_disable_radio(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_stop);
+
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf)
 {
@@ -135,6 +185,14 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		return -ENOBUFS;
 
 	/*
+	 * HACK: Placeholder until start/stop handler has been
+	 * added to the mac80211 callback functions structure.
+	 */
+	retval = rt2x00mac_start(hw);
+	if (retval)
+		return retval;
+
+	/*
 	 * We support muliple monitor mode interfaces.
 	 * All we need to do is increase the monitor_count.
 	 */
@@ -149,13 +207,13 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		intf->filter = 0;
 	}
 
-	retval = rt2x00lib_init_interface(rt2x00dev);
-	if (retval)
-		return retval;
-
 	/*
 	 * Configure interface.
+	 * The MAC adddress must be configured after the device
+	 * has been initialized. Else the device can reset the
+	 * MAC registers.
 	 */
+	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
 	rt2x00lib_config_type(rt2x00dev, conf->type);
 	rt2x00lib_config_packet_filter(rt2x00dev, intf->filter);
 
@@ -189,7 +247,19 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 		intf->filter = 0;
 	}
 
-	rt2x00lib_deinit_interface(rt2x00dev);
+	/*
+	 * Make sure the bssid and mac address registers
+	 * are cleared to prevent false ACKing of frames.
+	 */
+	rt2x00lib_config_mac_addr(rt2x00dev, intf->mac);
+	rt2x00lib_config_bssid(rt2x00dev, intf->bssid);
+	rt2x00lib_config_type(rt2x00dev, intf->type);
+
+	/*
+	 * HACK: Placeholder untill start/stop handler has been
+	 * added to the mac80211 callback functions structure.
+	 */
+	rt2x00mac_stop(hw);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_remove_interface);
 
-- 
1.5.3
