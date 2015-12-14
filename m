Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37979 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752405AbbLNMRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECH9YL027538
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:09 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng01e-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:09 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 02/14] mwifiex: multiple bss support
Date: Mon, 14 Dec 2015 04:15:03 -0800
Message-ID: <1450095315-19927-3-git-send-email-akarwar@marvell.com> (sfid-20151214_131713_350844_E22F226C)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

This patch fixes issues observed while starting 3 different
bss simultaneously, eg, 2 AP + 1 STA or 3 AP

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 20 ++++++++----
 drivers/net/wireless/marvell/mwifiex/decl.h     |  6 ++--
 drivers/net/wireless/marvell/mwifiex/main.h     | 42 ++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 47d8afd..ab0ba6a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -825,18 +825,26 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
+			 MWIFIEX_BSS_TYPE_STA);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
 		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
+		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
+			 MWIFIEX_BSS_TYPE_P2P);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
 		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
+		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
+			 MWIFIEX_BSS_TYPE_P2P);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_UAP;
 		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_AP:
+		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
+			 MWIFIEX_BSS_TYPE_UAP);
 		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		break;
@@ -2606,7 +2614,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			return ERR_PTR(-EINVAL);
 		}
 
-		priv = mwifiex_get_unused_priv(adapter);
+		priv = mwifiex_get_unused_priv_by_bss_type(
+						adapter, MWIFIEX_BSS_TYPE_STA);
 		if (!priv) {
 			mwifiex_dbg(adapter, ERROR,
 				    "could not get free private struct\n");
@@ -2625,7 +2634,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
 		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
-		priv->bss_num = adapter->curr_iface_comb.sta_intf;
 
 		break;
 	case NL80211_IFTYPE_AP:
@@ -2636,7 +2644,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			return ERR_PTR(-EINVAL);
 		}
 
-		priv = mwifiex_get_unused_priv(adapter);
+		priv = mwifiex_get_unused_priv_by_bss_type(
+						adapter, MWIFIEX_BSS_TYPE_UAP);
 		if (!priv) {
 			mwifiex_dbg(adapter, ERROR,
 				    "could not get free private struct\n");
@@ -2651,7 +2660,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		priv->bss_started = 0;
-		priv->bss_num = adapter->curr_iface_comb.uap_intf;
 		priv->bss_mode = type;
 
 		break;
@@ -2663,7 +2671,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 			return ERR_PTR(-EINVAL);
 		}
 
-		priv = mwifiex_get_unused_priv(adapter);
+		priv = mwifiex_get_unused_priv_by_bss_type(
+						adapter, MWIFIEX_BSS_TYPE_P2P);
 		if (!priv) {
 			mwifiex_dbg(adapter, ERROR,
 				    "could not get free private struct\n");
@@ -2687,7 +2696,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_priority = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_started = 0;
-		priv->bss_num = adapter->curr_iface_comb.p2p_intf;
 
 		if (mwifiex_cfg80211_init_p2p_client(priv)) {
 			memset(&priv->wdev, 0, sizeof(priv->wdev));
diff --git a/drivers/net/wireless/marvell/mwifiex/decl.h b/drivers/net/wireless/marvell/mwifiex/decl.h
index 098e1f1..d9c15cd 100644
--- a/drivers/net/wireless/marvell/mwifiex/decl.h
+++ b/drivers/net/wireless/marvell/mwifiex/decl.h
@@ -111,9 +111,9 @@
 /* Rate index for OFDM 0 */
 #define MWIFIEX_RATE_INDEX_OFDM0   4
 
-#define MWIFIEX_MAX_STA_NUM		1
-#define MWIFIEX_MAX_UAP_NUM		1
-#define MWIFIEX_MAX_P2P_NUM		1
+#define MWIFIEX_MAX_STA_NUM		3
+#define MWIFIEX_MAX_UAP_NUM		3
+#define MWIFIEX_MAX_P2P_NUM		3
 
 #define MWIFIEX_A_BAND_START_FREQ	5000
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index a86e2ae..10e614e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1273,20 +1273,46 @@ mwifiex_get_priv(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function checks available bss_num when adding new interface or
+ * changing interface type.
+ */
+static inline u8
+mwifiex_get_unused_bss_num(struct mwifiex_adapter *adapter, u8 bss_type)
+{
+	u8 i, j;
+	int index[MWIFIEX_MAX_BSS_NUM];
+
+	memset(index, 0, sizeof(index));
+	for (i = 0; i < adapter->priv_num; i++)
+		if (adapter->priv[i]) {
+			if (adapter->priv[i]->bss_type == bss_type &&
+			    !(adapter->priv[i]->bss_mode ==
+			      NL80211_IFTYPE_UNSPECIFIED)) {
+				index[adapter->priv[i]->bss_num] = 1;
+			}
+		}
+	for (j = 0; j < MWIFIEX_MAX_BSS_NUM; j++)
+		if (!index[j])
+			return j;
+	return -1;
+}
+
+/*
  * This function returns the first available unused private structure pointer.
  */
 static inline struct mwifiex_private *
-mwifiex_get_unused_priv(struct mwifiex_adapter *adapter)
+mwifiex_get_unused_priv_by_bss_type(struct mwifiex_adapter *adapter,
+				    u8 bss_type)
 {
-	int i;
+	u8 i;
 
-	for (i = 0; i < adapter->priv_num; i++) {
-		if (adapter->priv[i]) {
-			if (adapter->priv[i]->bss_mode ==
-			    NL80211_IFTYPE_UNSPECIFIED)
-				break;
+	for (i = 0; i < adapter->priv_num; i++)
+		if (adapter->priv[i]->bss_mode ==
+		   NL80211_IFTYPE_UNSPECIFIED) {
+			adapter->priv[i]->bss_num =
+			mwifiex_get_unused_bss_num(adapter, bss_type);
+			break;
 		}
-	}
 
 	return ((i < adapter->priv_num) ? adapter->priv[i] : NULL);
 }
-- 
1.8.1.4

