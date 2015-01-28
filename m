Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56384 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965040AbbA1Ez2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:55:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4tSBu027951
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:55:28 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s50eqxb5p-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:55:27 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 05/10] mwifiex: separate function for parsing head and tail IEs
Date: Wed, 28 Jan 2015 15:54:20 +0530
Message-ID: <1422440665-3940-6-git-send-email-patila@marvell.com> (sfid-20150128_055536_131786_F949853D)
In-Reply-To: <1422440665-3940-1-git-send-email-patila@marvell.com>
References: <1422440665-3940-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Head & Tail IEs are supposed to be added to beacon and probe response.
This patch adds separate function for parsing head and tail IEs from
cfg80211_beacon_data and sets them to FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c   | 81 +++++++++++++++++++++----------------
 drivers/net/wireless/mwifiex/main.c |  2 +-
 drivers/net/wireless/mwifiex/main.h |  2 +-
 3 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index b933794..a6af7b8 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -317,27 +317,26 @@ done:
 	return ret;
 }
 
-/* This function parses different IEs-tail IEs, beacon IEs, probe response IEs,
- * association response IEs from cfg80211_ap_settings function and sets these IE
- * to FW.
+/* This function parses  head and tail IEs, from cfg80211_beacon_data and sets
+ * these IE to FW.
  */
-int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
-			 struct cfg80211_beacon_data *info)
+static int mwifiex_uap_set_head_tail_ies(struct mwifiex_private *priv,
+					 struct cfg80211_beacon_data *info)
 {
 	struct mwifiex_ie *gen_ie;
-	struct ieee_types_header *rsn_ie, *wpa_ie = NULL;
-	u16 rsn_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
+	struct ieee_types_header *rsn_ie = NULL, *wpa_ie = NULL;
+	u16 gen_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
 	const u8 *vendor_ie;
 
-	if (info->tail && info->tail_len) {
-		gen_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!gen_ie)
-			return -ENOMEM;
-		gen_ie->ie_index = cpu_to_le16(rsn_idx);
-		gen_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON |
-							MGMT_MASK_PROBE_RESP |
-							MGMT_MASK_ASSOC_RESP);
+	gen_ie = kzalloc(sizeof(*gen_ie), GFP_KERNEL);
+	if (!gen_ie)
+		return -ENOMEM;
+	gen_ie->ie_index = cpu_to_le16(gen_idx);
+	gen_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON |
+						MGMT_MASK_PROBE_RESP |
+						MGMT_MASK_ASSOC_RESP);
 
+	if (info->tail && info->tail_len) {
 		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
 						  info->tail, info->tail_len);
 		if (rsn_ie) {
@@ -357,20 +356,33 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			ie_len += wpa_ie->len + 2;
 			gen_ie->ie_length = cpu_to_le16(ie_len);
 		}
+	}
 
-		if (rsn_ie || wpa_ie) {
-			if (mwifiex_update_uap_custom_ie(priv, gen_ie, &rsn_idx,
-							 NULL, NULL,
-							 NULL, NULL)) {
-				kfree(gen_ie);
-				return -1;
-			}
-			priv->rsn_idx = rsn_idx;
+	if (rsn_ie || wpa_ie) {
+		if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL,
+						 NULL, NULL, NULL)) {
+			kfree(gen_ie);
+			return -1;
 		}
-
-		kfree(gen_ie);
+		priv->gen_idx = gen_idx;
 	}
 
+	kfree(gen_ie);
+	return 0;
+}
+
+/* This function parses different IEs-head & tail IEs, beacon IEs,
+ * probe response IEs, association response IEs from cfg80211_ap_settings
+ * function and sets these IE to FW.
+ */
+int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
+			 struct cfg80211_beacon_data *info)
+{
+	int ret;
+
+	ret = mwifiex_uap_set_head_tail_ies(priv, info);
+		return ret;
+
 	return mwifiex_set_mgmt_beacon_data_ies(priv, info);
 }
 
@@ -378,25 +390,25 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv)
 {
 	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL;
-	struct mwifiex_ie *ar_ie = NULL, *rsn_ie = NULL;
+	struct mwifiex_ie *ar_ie = NULL, *gen_ie = NULL;
 	int ret = 0;
 
-	if (priv->rsn_idx != MWIFIEX_AUTO_IDX_MASK) {
-		rsn_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!rsn_ie)
+	if (priv->gen_idx != MWIFIEX_AUTO_IDX_MASK) {
+		gen_ie = kmalloc(sizeof(*gen_ie), GFP_KERNEL);
+		if (!gen_ie)
 			return -ENOMEM;
 
-		rsn_ie->ie_index = cpu_to_le16(priv->rsn_idx);
-		rsn_ie->mgmt_subtype_mask = cpu_to_le16(MWIFIEX_DELETE_MASK);
-		rsn_ie->ie_length = 0;
-		if (mwifiex_update_uap_custom_ie(priv, rsn_ie, &priv->rsn_idx,
+		gen_ie->ie_index = cpu_to_le16(priv->gen_idx);
+		gen_ie->mgmt_subtype_mask = cpu_to_le16(MWIFIEX_DELETE_MASK);
+		gen_ie->ie_length = 0;
+		if (mwifiex_update_uap_custom_ie(priv, gen_ie, &priv->gen_idx,
 						 NULL, &priv->proberesp_idx,
 						 NULL, &priv->assocresp_idx)) {
 			ret = -1;
 			goto done;
 		}
 
-		priv->rsn_idx = MWIFIEX_AUTO_IDX_MASK;
+		priv->gen_idx = MWIFIEX_AUTO_IDX_MASK;
 	}
 
 	if (priv->beacon_idx != MWIFIEX_AUTO_IDX_MASK) {
@@ -440,7 +452,6 @@ done:
 	kfree(beacon_ie);
 	kfree(pr_ie);
 	kfree(ar_ie);
-	kfree(rsn_ie);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 30e5193..7e74b4f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -973,7 +973,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->beacon_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->proberesp_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->assocresp_idx = MWIFIEX_AUTO_IDX_MASK;
-	priv->rsn_idx = MWIFIEX_AUTO_IDX_MASK;
+	priv->gen_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->num_tx_timeout = 0;
 	ether_addr_copy(priv->curr_addr, priv->adapter->perm_addr);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0c75eff..c5ac20d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -567,7 +567,7 @@ struct mwifiex_private {
 	u16 beacon_idx;
 	u16 proberesp_idx;
 	u16 assocresp_idx;
-	u16 rsn_idx;
+	u16 gen_idx;
 	u8 ap_11n_enabled;
 	u8 ap_11ac_enabled;
 	u32 mgmt_frame_mask;
-- 
1.8.1.4

