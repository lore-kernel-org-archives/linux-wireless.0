Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbXJFMEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:05 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:04 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/16] rt2x00: Move TSF sync values into rt2x00config
Date: Sat, 6 Oct 2007 14:14:29 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061414.30195.IvDoorn@gmail.com> (sfid-20071006_130410_482539_4E293629)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All drivers use the same values for TSF sync,
this will move the value determination into rt2x00config.c,
and the definition for the values to rt2x00reg.h

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   12 +++---------
 drivers/net/wireless/rt2x00/rt2500pci.c    |   12 +++---------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   14 ++++----------
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c |   20 +++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h    |    9 +++++++++
 drivers/net/wireless/rt2x00/rt61pci.c      |   12 +++---------
 drivers/net/wireless/rt2x00/rt73usb.c      |   12 +++---------
 9 files changed, 45 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 7f2db6d..5f8df7a 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -265,9 +265,9 @@ static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev,
 				      (2 * sizeof(__le32)));
 }
 
-static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
+static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
+				  const int tsf_sync)
 {
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	rt2x00pci_register_write(rt2x00dev, CSR14, 0);
@@ -287,13 +287,7 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
-	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 2);
-	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 1);
-	else
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, tsf_sync);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1f70917..cac9430 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -265,9 +265,9 @@ static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev,
 				      (2 * sizeof(__le32)));
 }
 
-static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
+static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
+				  const int tsf_sync)
 {
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	rt2x00pci_register_write(rt2x00dev, CSR14, 0);
@@ -291,13 +291,7 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 	rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
-	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 2);
-	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 1);
-	else
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, tsf_sync);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index e7530ae..234b34e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -268,9 +268,9 @@ static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev,
 				      (3 * sizeof(__le16)));
 }
 
-static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
+static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
+				  const int tsf_sync)
 {
-	struct interface *intf = &rt2x00dev->interface;
 	u16 reg;
 
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, 0);
@@ -281,7 +281,7 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR20, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR20_OFFSET,
 			   (PREAMBLE + get_duration(IEEE80211_HEADER, 2)) >> 6);
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
+	if (type == IEEE80211_IF_TYPE_STA)
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW, 0);
 	else
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW, 2);
@@ -298,13 +298,7 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
 	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
 	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
-	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 2);
-	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 1);
-	else
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, tsf_sync);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 235e5ad..27bec6e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -410,7 +410,8 @@ struct rt2x00lib_ops {
 	 */
 	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, __le32 *mac);
 	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, __le32 *bssid);
-	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type);
+	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type,
+							   const int tsf_sync);
 	void (*config) (struct rt2x00_dev *rt2x00dev, const unsigned int flags,
 			struct ieee80211_conf *conf);
 #define CONFIG_UPDATE_PHYMODE		( 1 << 1 )
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index aeeaa0c..f8e87aa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -74,10 +74,24 @@ void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 	rt2x00dev->ops->lib->config_bssid(rt2x00dev, &reg[0]);
 }
 
-void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type)
+void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 {
-	if (type != INVALID_INTERFACE)
-		rt2x00dev->ops->lib->config_type(rt2x00dev, type);
+	int tsf_sync;
+
+	switch (type) {
+	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_AP:
+		tsf_sync = TSF_SYNC_BEACON;
+		break;
+	case IEEE80211_IF_TYPE_STA:
+		tsf_sync = TSF_SYNC_INFRA;
+		break;
+	default:
+		tsf_sync = TSF_SYNC_NONE;
+		break;
+	}
+
+	rt2x00dev->ops->lib->config_type(rt2x00dev, type, tsf_sync);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 0ab39ca..29ca932 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -52,7 +52,7 @@ void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
  */
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac);
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid);
-void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, int type);
+void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, const int type);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf, const int force_config);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7927d5f..8384212 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -59,6 +59,15 @@ enum led_mode {
 };
 
 /*
+ * TSF sync values
+ */
+enum tsf_sync {
+	TSF_SYNC_NONE = 0,
+	TSF_SYNC_INFRA = 1,
+	TSF_SYNC_BEACON = 2,
+};
+
+/*
  * Device states
  */
 enum dev_state {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ba6153a..62f1297 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -300,9 +300,9 @@ static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, __le32 *bssid)
 				      (2 * sizeof(__le32)));
 }
 
-static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
+static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
+				const int tsf_sync)
 {
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -324,13 +324,7 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
-	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 2);
-	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 1);
-	else
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, tsf_sync);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f48e5fb..e7887c3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -279,9 +279,9 @@ static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, __le32 *bssid)
 				    (2 * sizeof(__le32)));
 }
 
-static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
+static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
+				const int tsf_sync)
 {
-	struct interface *intf = &rt2x00dev->interface;
 	u32 reg;
 
 	/*
@@ -303,13 +303,7 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	if (is_interface_type(intf, IEEE80211_IF_TYPE_IBSS) ||
-	    is_interface_type(intf, IEEE80211_IF_TYPE_AP))
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 2);
-	else if (is_interface_type(intf, IEEE80211_IF_TYPE_STA))
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 1);
-	else
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, tsf_sync);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-- 
1.5.3.4

