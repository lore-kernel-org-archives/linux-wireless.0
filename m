Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbXGaSeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:16 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:15 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/24] rt2x00: Move interface init/deinit into rt2x00dev
Date: Tue, 31 Jul 2007 20:37:23 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.23346.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From cab2bdf51680ec25521369fdb45e672842403abd Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 15:58:53 +0200
Subject: [PATCH 13/24] rt2x00: Move interface init/deinit into rt2x00dev

Move interface init/deinit into rt2x00dev.c,
this groups the initialization of the device together
into a single function.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00.h    |    9 ++++-
 drivers/net/wireless/rt2x00dev.c |   65 +++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00dev.h |    5 ++-
 drivers/net/wireless/rt2x00mac.c |   59 ++--------------------------------
 4 files changed, 78 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 9d07e80..5566c7a 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -629,6 +629,11 @@ struct interface {
 	int type;
 
 	/*
+	 * MAC of the device.
+	 */
+	u8 *mac;
+
+	/*
 	 * BBSID of the AP to associate with.
 	 */
 	u8 bssid[ETH_ALEN];
@@ -638,13 +643,13 @@ struct interface {
 	 * monitor mode always forces promisc mode to be enabled,
 	 * so we need to store the promisc mode seperately.
 	 */
-	short promisc;
+	char promisc;
 
 	/*
 	 * Monitor mode count, the number of interfaces
 	 * in monitor mode that that have been added.
 	 */
-	short monitor_count;
+	char monitor_count;
 };
 
 static inline int is_interface_present(struct interface *intf)
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 6d369cf..10221bb 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -761,7 +761,7 @@ static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_free_ring_entries(rt2x00dev);
 }
 
-int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
+static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
 
@@ -804,6 +804,69 @@ exit:
 	return status;
 }
 
+int rt2x00lib_init_interface(struct rt2x00_dev *rt2x00dev)
+{
+	struct interface *intf = &rt2x00dev->interface;
+	int status;
+
+	/*
+	 * If this is the first interface which is added,
+	 * we should load the firmware now.
+	 */
+	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags) &&
+	    test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
+		status = rt2x00lib_load_firmware(rt2x00dev);
+		if (status)
+			return status;
+	}
+
+	/*
+	 * We should configure the MAC address before
+	 * the initialization starts. Note that the mac_addr
+	 * field is NULL when adding a monitor interface.
+	 */
+	if (intf->mac)
+		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev, intf->mac);
+
+	/*
+	 * Initialize interface and enable the radio.
+	 */
+	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags)) {
+		/*
+		 * Initialize the device.
+		 */
+		status = rt2x00lib_initialize(rt2x00dev);
+		if (status)
+			return status;
+
+		/*
+		 * Enable radio.
+		 */
+		status = rt2x00lib_enable_radio(rt2x00dev);
+		if (status) {
+			rt2x00lib_uninitialize(rt2x00dev);
+			return status;
+		}
+	}
+
+	return 0;
+}
+
+void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev)
+{
+	struct interface *intf = &rt2x00dev->interface;
+
+	/*
+	 * If no interfaces are present, we should disable the radio,
+	 * Otherwise check which interface needs to be initialized.
+	 */
+	if (!is_monitor_present(intf) && !is_interface_present(intf))
+		rt2x00lib_disable_radio(rt2x00dev);
+	else if (is_monitor_present(intf) ^ is_interface_present(intf))
+		rt2x00lib_config_type(rt2x00dev,
+			is_interface_present(intf) ?
+				intf->type : IEEE80211_IF_TYPE_MNTR);
+}
 
 /*
  * driver allocation handlers.
diff --git a/drivers/net/wireless/rt2x00dev.h b/drivers/net/wireless/rt2x00dev.h
index c6feee3..b2b43fd 100644
--- a/drivers/net/wireless/rt2x00dev.h
+++ b/drivers/net/wireless/rt2x00dev.h
@@ -40,9 +40,10 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable);
 
 /*
- * Initialization/uninitialization handlers.
+ * Interface initialization/deinitialization.
  */
-int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev);
+int rt2x00lib_init_interface(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_deinit_interface(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Config handlers.
diff --git a/drivers/net/wireless/rt2x00mac.c b/drivers/net/wireless/rt2x00mac.c
index c39c1f2..9955815 100644
--- a/drivers/net/wireless/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00mac.c
@@ -135,7 +135,6 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct interface *intf = &rt2x00dev->interface;
-	int status;
 
 	/*
 	 * We only support 1 non-monitor interface.
@@ -145,17 +144,6 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 		return -ENOBUFS;
 
 	/*
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
 	 * We support muliple monitor mode interfaces.
 	 * All we need to do is increase the monitor_count.
 	 */
@@ -166,39 +154,11 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 		intf->type = conf->type;
 		if (conf->type == IEEE80211_IF_TYPE_AP)
 			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
+		intf->mac = conf->mac_addr;
 		intf->promisc = 0;
-
-		/*
-		 * We should configure the MAC address before
-		 * the initialization starts. Note that the mac_addr
-		 * field is NULL when adding a monitor interface,
-		 * so we can only set the mac address here.
-		 */
-		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev,
-			conf->mac_addr);
 	}
 
-	/*
-	 * Initialize interface, and enable the radio when this
-	 * is the first interface that is brought up.
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
-		if (status)
-			return status;
-	}
-
-	return 0;
+	return rt2x00lib_init_interface(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_add_interface);
 
@@ -225,22 +185,11 @@ void rt2x00lib_remove_interface(struct ieee80211_hw *hw,
 		intf->id = 0;
 		intf->type = -EINVAL;
 		memset(&intf->bssid, 0x00, ETH_ALEN);
+		intf->mac = NULL;
 		intf->promisc = 0;
 	}
 
-	/*
-	 * If this was the last interface,
-	 * this is the time to disable the radio.
-	 * If this is not the last interface, then we should
-	 * check if we should switch completely to monitor
-	 * mode or completely switch to the non-monitor mode.
-	 */
-	if (!is_monitor_present(intf) && !is_interface_present(intf))
-		rt2x00lib_disable_radio(rt2x00dev);
-	else if (is_monitor_present(intf) ^ is_interface_present(intf))
-		rt2x00lib_config_type(rt2x00dev,
-			is_interface_present(intf) ?
-				intf->type : IEEE80211_IF_TYPE_MNTR);
+	rt2x00lib_deinit_interface(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_remove_interface);
 
-- 
1.5.2.4

