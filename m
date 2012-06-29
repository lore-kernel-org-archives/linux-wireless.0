Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35722 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754360Ab2F2DbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/6] mwifiex: separate IE parsing for Head/Tail IEs and beacon_ies etc
Date: Thu, 28 Jun 2012 20:30:26 -0700
Message-Id: <1340940630-27172-3-git-send-email-bzhao@marvell.com> (sfid-20120629_053119_848728_E3DEE265)
In-Reply-To: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
References: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

While Head/Tail IEs may contain RSN/WPA IEs which needs to be set
for all mgmt subtypes, beacon_ies, probe_resp_ies, assoc_resp_ies
are for specific mgmt subtypes. Move them to separate function.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c |  119 ++++++++++++++++++++-----------------
 1 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 4a38fd8..018ae4a 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -217,62 +217,17 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
 	return ret;
 }
 
-/* This function parses different IEs- Tail IEs, beacon IEs, probe response IEs,
- * association response IEs from cfg80211_ap_settings function and sets these IE
- * to FW.
+/* This function parses beacon IEs, probe response IEs, association response IEs
+ * from cfg80211_ap_settings->beacon and sets these IE to FW.
  */
-int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
-			 struct cfg80211_beacon_data *data)
+static int mwifiex_set_mgmt_beacon_data_ies(struct mwifiex_private *priv,
+					    struct cfg80211_beacon_data *data)
 {
-	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL;
-	struct mwifiex_ie *ar_ie = NULL, *gen_ie = NULL;
-	struct ieee_types_header *rsn_ie = NULL, *wpa_ie = NULL;
+	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL, *ar_ie = NULL;
 	u16 beacon_idx = MWIFIEX_AUTO_IDX_MASK, pr_idx = MWIFIEX_AUTO_IDX_MASK;
-	u16 ar_idx = MWIFIEX_AUTO_IDX_MASK, rsn_idx = MWIFIEX_AUTO_IDX_MASK;
-	u16 mask, ie_len = 0;
-	const u8 *vendor_ie;
+	u16 ar_idx = MWIFIEX_AUTO_IDX_MASK;
 	int ret = 0;
 
-	if (data->tail && data->tail_len) {
-		gen_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!gen_ie)
-			return -ENOMEM;
-		gen_ie->ie_index = cpu_to_le16(rsn_idx);
-		mask = MGMT_MASK_BEACON | MGMT_MASK_PROBE_RESP |
-		       MGMT_MASK_ASSOC_RESP;
-		gen_ie->mgmt_subtype_mask = cpu_to_le16(mask);
-
-		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
-						  data->tail, data->tail_len);
-		if (rsn_ie) {
-			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
-			ie_len = rsn_ie->len + 2;
-			gen_ie->ie_length = cpu_to_le16(ie_len);
-		}
-
-		vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
-						    WLAN_OUI_TYPE_MICROSOFT_WPA,
-						    data->tail, data->tail_len);
-		if (vendor_ie) {
-			wpa_ie = (struct ieee_types_header *)vendor_ie;
-			memcpy(gen_ie->ie_buffer + ie_len,
-			       wpa_ie, wpa_ie->len + 2);
-			ie_len += wpa_ie->len + 2;
-			gen_ie->ie_length = cpu_to_le16(ie_len);
-		}
-
-		if (rsn_ie || wpa_ie) {
-			if (mwifiex_update_uap_custom_ie(priv, gen_ie, &rsn_idx,
-							 NULL, NULL,
-							 NULL, NULL)) {
-				ret = -1;
-				goto done;
-			}
-
-			priv->rsn_idx = rsn_idx;
-		}
-	}
-
 	if (data->beacon_ies && data->beacon_ies_len) {
 		beacon_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
 		if (!beacon_ie) {
@@ -309,8 +264,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 		}
 
 		ar_ie->ie_index = cpu_to_le16(ar_idx);
-		mask = MGMT_MASK_ASSOC_RESP | MGMT_MASK_REASSOC_RESP;
-		ar_ie->mgmt_subtype_mask = cpu_to_le16(mask);
+		ar_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_ASSOC_RESP |
+						       MGMT_MASK_REASSOC_RESP);
 		ar_ie->ie_length = cpu_to_le16(data->assocresp_ies_len);
 		memcpy(ar_ie->ie_buffer, data->assocresp_ies,
 		       data->assocresp_ies_len);
@@ -332,11 +287,67 @@ done:
 	kfree(beacon_ie);
 	kfree(pr_ie);
 	kfree(ar_ie);
-	kfree(gen_ie);
 
 	return ret;
 }
 
+/* This function parses different IEs-tail IEs, beacon IEs, probe response IEs,
+ * association response IEs from cfg80211_ap_settings function and sets these IE
+ * to FW.
+ */
+int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
+			 struct cfg80211_beacon_data *info)
+{
+	struct mwifiex_ie *gen_ie;
+	struct ieee_types_header *rsn_ie, *wpa_ie = NULL;
+	u16 rsn_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
+	const u8 *vendor_ie;
+
+	if (info->tail && info->tail_len) {
+		gen_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!gen_ie)
+			return -ENOMEM;
+		gen_ie->ie_index = cpu_to_le16(rsn_idx);
+		gen_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON |
+							MGMT_MASK_PROBE_RESP |
+							MGMT_MASK_ASSOC_RESP);
+
+		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
+						  info->tail, info->tail_len);
+		if (rsn_ie) {
+			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
+			ie_len = rsn_ie->len + 2;
+			gen_ie->ie_length = cpu_to_le16(ie_len);
+		}
+
+		vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+						    WLAN_OUI_TYPE_MICROSOFT_WPA,
+						    info->tail,
+						    info->tail_len);
+		if (vendor_ie) {
+			wpa_ie = (struct ieee_types_header *)vendor_ie;
+			memcpy(gen_ie->ie_buffer + ie_len,
+			       wpa_ie, wpa_ie->len + 2);
+			ie_len += wpa_ie->len + 2;
+			gen_ie->ie_length = cpu_to_le16(ie_len);
+		}
+
+		if (rsn_ie || wpa_ie) {
+			if (mwifiex_update_uap_custom_ie(priv, gen_ie, &rsn_idx,
+							 NULL, NULL,
+							 NULL, NULL)) {
+				kfree(gen_ie);
+				return -1;
+			}
+			priv->rsn_idx = rsn_idx;
+		}
+
+		kfree(gen_ie);
+	}
+
+	return mwifiex_set_mgmt_beacon_data_ies(priv, info);
+}
+
 /* This function removes management IE set */
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv)
 {
-- 
1.7.0.2

