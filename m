Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbXB1OHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:17 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:16 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/28] rt2x00: Fix TSF_SYNC selection
Date: Wed, 28 Feb 2007 15:07:08 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.08936.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename TSF_SYNC_MODE to TSF_SYNC. Also set the value correctly
to allow master mode functionality.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index fa1437c..3b6f503 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -411,20 +411,15 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	}
 
-	if (type == IEEE80211_IF_TYPE_IBSS) {
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 2);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-	} else if (type == IEEE80211_IF_TYPE_STA) {
+	else if (type == IEEE80211_IF_TYPE_STA)
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 1);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	} else if (type == IEEE80211_IF_TYPE_AP) {
+	else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+		 !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-	} else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
-		   !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	}
+
 	rt2x00_register_write(rt2x00dev, CSR14, reg);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index 1f891ae..585c5aa 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -191,7 +191,7 @@
 /*
  * CSR14: Synchronization control register.
  * TSF_COUNT: Enable tsf auto counting.
- * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc mode.
+ * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc/master mode.
  * TBCN: Enable tbcn with reload value.
  * TCFP: Enable tcfp & cfp / cp switching.
  * TATIMW: Enable tatimw & atim window switching.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 8ad17ba..59faa33 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -416,20 +416,15 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 	}
 
-	if (type == IEEE80211_IF_TYPE_IBSS) {
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 2);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-	} else if (type == IEEE80211_IF_TYPE_STA) {
+	else if (type == IEEE80211_IF_TYPE_STA)
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 1);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	} else if (type == IEEE80211_IF_TYPE_AP) {
+	else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+		 !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-	} else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
-		   !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
-		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	}
+
 	rt2x00_register_write(rt2x00dev, CSR14, reg);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index 9b4e217..fd7cd1a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -268,7 +268,7 @@
 /*
  * CSR14: Synchronization control register.
  * TSF_COUNT: Enable tsf auto counting.
- * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc mode.
+ * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc/master mode.
  * TBCN: Enable tbcn with reload value.
  * TCFP: Enable tcfp & cfp / cp switching.
  * TATIMW: Enable tatimw & atim window switching.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 4244e9d..f451ae6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -443,30 +443,15 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, int type)
 		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
 	}
 
-	if (type == IEEE80211_IF_TYPE_IBSS) {
+	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
+	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 2);
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
-	} else if (type == IEEE80211_IF_TYPE_STA) {
+	else if (type == IEEE80211_IF_TYPE_STA)
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
-	} else if (type == IEEE80211_IF_TYPE_AP) {
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
-	} else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
-		   !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
+	else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+		 !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
-	}
 
-	/*
-	 * Beacon generation will fail initially.
-	 * To prevent this we need to register the TXRX_CSR19
-	 * register several times.
-	 */
-	rt2x00_register_write(rt2x00dev, TXRX_CSR19, reg);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR19, 0);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR19, reg);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR19, 0);
 	rt2x00_register_write(rt2x00dev, TXRX_CSR19, reg);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 1a4b675..ffedfee 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -297,7 +297,7 @@
 /*
  * TXRX_CSR19: Synchronization control register.
  * TSF_COUNT: Enable TSF auto counting.
- * TSF_SYNC: TSF sync, 0: disable, 1: infra mode, 2: ad-hoc mode.
+ * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc/master mode.
  * TBCN: Enable Tbcn with reload value.
  * BEACON_GEN: Enable beacon generator.
  */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 53dedcb..5718005 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -440,20 +440,16 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	}
-	if (type == IEEE80211_IF_TYPE_IBSS) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 2);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	} else if (type == IEEE80211_IF_TYPE_STA) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	} else if (type == IEEE80211_IF_TYPE_AP) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	} else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
-		   !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	}
+
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 2);
+	else if (type == IEEE80211_IF_TYPE_STA)
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 1);
+	else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+		 !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
+
 	rt2x00_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index 1d0b72a..4c97ba8 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -437,13 +437,13 @@ struct hw_pairwise_ta_entry {
  * TXRX_CSR9: Synchronization control register.
  * BEACON_INTERVAL: In unit of 1/16 TU.
  * TSF_TICKING: Enable TSF auto counting.
- * TSF_SYNC_MODE: Enable TSF sync, 0: disable, 1: infra mode, 2: ad-hoc mode.
+ * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc/master mode.
  * BEACON_GEN: Enable beacon generator.
  */
 #define TXRX_CSR9			0x3064
 #define TXRX_CSR9_BEACON_INTERVAL	FIELD32(0x0000ffff)
 #define TXRX_CSR9_TSF_TICKING		FIELD32(0x00010000)
-#define TXRX_CSR9_TSF_SYNC_MODE		FIELD32(0x00060000)
+#define TXRX_CSR9_TSF_SYNC		FIELD32(0x00060000)
 #define TXRX_CSR9_TBTT_ENABLE		FIELD32(0x00080000)
 #define TXRX_CSR9_BEACON_GEN		FIELD32(0x00100000)
 #define TXRX_CSR9_TIMESTAMP_COMPENSATE	FIELD32(0xff000000)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index e628d43..a991be4 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -433,20 +433,15 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, int type)
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 	}
 
-	if (type == IEEE80211_IF_TYPE_IBSS) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 2);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	} else if (type == IEEE80211_IF_TYPE_STA) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	} else if (type == IEEE80211_IF_TYPE_AP) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	} else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
-		   !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC_MODE, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	}
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	if (type == IEEE80211_IF_TYPE_IBSS || type == IEEE80211_IF_TYPE_AP)
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 2);
+	else if (type == IEEE80211_IF_TYPE_STA)
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 1);
+	else if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+		 !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
+
 	rt2x00_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index a752ab9..7394185 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -340,13 +340,13 @@ struct hw_pairwise_ta_entry {
  * TXRX_CSR9: Synchronization control register.
  * BEACON_INTERVAL: In unit of 1/16 TU.
  * TSF_TICKING: Enable TSF auto counting.
- * TSF_SYNC_MODE: Enable TSF sync, 0: disable, 1: infra mode, 2: ad-hoc mode.
+ * TSF_SYNC: Tsf sync, 0: disable, 1: infra, 2: ad-hoc/master mode.
  * BEACON_GEN: Enable beacon generator.
  */
 #define TXRX_CSR9			0x3064
 #define TXRX_CSR9_BEACON_INTERVAL	FIELD32(0x0000ffff)
 #define TXRX_CSR9_TSF_TICKING		FIELD32(0x00010000)
-#define TXRX_CSR9_TSF_SYNC_MODE		FIELD32(0x00060000)
+#define TXRX_CSR9_TSF_SYNC		FIELD32(0x00060000)
 #define TXRX_CSR9_TBTT_ENABLE		FIELD32(0x00080000)
 #define TXRX_CSR9_BEACON_GEN		FIELD32(0x00100000)
 #define TXRX_CSR9_TIMESTAMP_COMPENSATE	FIELD32(0xff000000)
