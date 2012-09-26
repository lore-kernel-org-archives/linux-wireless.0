Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:52182 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab2IZDbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:31:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 13/15] mwifiex: parse P2P IEs from beacon_data
Date: Tue, 25 Sep 2012 20:23:43 -0700
Message-Id: <1348629825-12001-14-git-send-email-bzhao@marvell.com> (sfid-20120926_053134_813777_FDE60D28)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Parse P2P IEs and set them to FW with related masks.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c |   86 +++++++++++++++++++++++--------------
 1 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index fa3a80f..e38342f 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -114,9 +114,6 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 							cpu_to_le16(mask);
 
 			ie->ie_index = cpu_to_le16(index);
-			ie->ie_length = priv->mgmt_ie[index].ie_length;
-			memcpy(&ie->ie_buffer, &priv->mgmt_ie[index].ie_buffer,
-			       le16_to_cpu(priv->mgmt_ie[index].ie_length));
 		} else {
 			if (mask != MWIFIEX_DELETE_MASK)
 				return -1;
@@ -214,30 +211,35 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
 	return ret;
 }
 
-/* This function checks if WPS IE is present in passed buffer and copies it to
- * mwifiex_ie structure.
+/* This function checks if the vendor specified IE is present in passed buffer
+ * and copies it to mwifiex_ie structure.
  * Function takes pointer to struct mwifiex_ie pointer as argument.
- * If WPS IE is present memory is allocated for mwifiex_ie pointer and filled
- * in with WPS IE. Caller should take care of freeing this memory.
+ * If the vendor specified IE is present then memory is allocated for
+ * mwifiex_ie pointer and filled in with IE. Caller should take care of freeing
+ * this memory.
  */
-static int mwifiex_update_wps_ie(const u8 *ies, int ies_len,
-				 struct mwifiex_ie **ie_ptr, u16 mask)
+static int mwifiex_update_vs_ie(const u8 *ies, int ies_len,
+				struct mwifiex_ie **ie_ptr, u16 mask,
+				unsigned int oui, u8 oui_type)
 {
-	struct ieee_types_header *wps_ie;
-	struct mwifiex_ie *ie = NULL;
+	struct ieee_types_header *vs_ie;
+	struct mwifiex_ie *ie = *ie_ptr;
 	const u8 *vendor_ie;
 
-	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
-					    WLAN_OUI_TYPE_MICROSOFT_WPS,
-					    ies, ies_len);
+	vendor_ie = cfg80211_find_vendor_ie(oui, oui_type, ies, ies_len);
 	if (vendor_ie) {
-		ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!ie)
-			return -ENOMEM;
+		if (!*ie_ptr) {
+			*ie_ptr = kzalloc(sizeof(struct mwifiex_ie),
+					  GFP_KERNEL);
+			if (!*ie_ptr)
+				return -ENOMEM;
+			ie = *ie_ptr;
+		}
 
-		wps_ie = (struct ieee_types_header *)vendor_ie;
-		memcpy(ie->ie_buffer, wps_ie, wps_ie->len + 2);
-		ie->ie_length = cpu_to_le16(wps_ie->len + 2);
+		vs_ie = (struct ieee_types_header *)vendor_ie;
+		memcpy(ie->ie_buffer + le16_to_cpu(ie->ie_length),
+		       vs_ie, vs_ie->len + 2);
+		le16_add_cpu(&ie->ie_length, vs_ie->len + 2);
 		ie->mgmt_subtype_mask = cpu_to_le16(mask);
 		ie->ie_index = cpu_to_le16(MWIFIEX_AUTO_IDX_MASK);
 	}
@@ -257,20 +259,40 @@ static int mwifiex_set_mgmt_beacon_data_ies(struct mwifiex_private *priv,
 	u16 ar_idx = MWIFIEX_AUTO_IDX_MASK;
 	int ret = 0;
 
-	if (data->beacon_ies && data->beacon_ies_len)
-		mwifiex_update_wps_ie(data->beacon_ies, data->beacon_ies_len,
-				      &beacon_ie, MGMT_MASK_BEACON);
+	if (data->beacon_ies && data->beacon_ies_len) {
+		mwifiex_update_vs_ie(data->beacon_ies, data->beacon_ies_len,
+				     &beacon_ie, MGMT_MASK_BEACON,
+				     WLAN_OUI_MICROSOFT,
+				     WLAN_OUI_TYPE_MICROSOFT_WPS);
+		mwifiex_update_vs_ie(data->beacon_ies, data->beacon_ies_len,
+				     &beacon_ie, MGMT_MASK_BEACON,
+				     WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P);
+	}
 
-	if (data->proberesp_ies && data->proberesp_ies_len)
-		mwifiex_update_wps_ie(data->proberesp_ies,
-				      data->proberesp_ies_len, &pr_ie,
-				      MGMT_MASK_PROBE_RESP);
+	if (data->proberesp_ies && data->proberesp_ies_len) {
+		mwifiex_update_vs_ie(data->proberesp_ies,
+				     data->proberesp_ies_len, &pr_ie,
+				     MGMT_MASK_PROBE_RESP, WLAN_OUI_MICROSOFT,
+				     WLAN_OUI_TYPE_MICROSOFT_WPS);
+		mwifiex_update_vs_ie(data->proberesp_ies,
+				     data->proberesp_ies_len, &pr_ie,
+				     MGMT_MASK_PROBE_RESP,
+				     WLAN_OUI_WFA, WLAN_OUI_TYPE_WFA_P2P);
+	}
 
-	if (data->assocresp_ies && data->assocresp_ies_len)
-		mwifiex_update_wps_ie(data->assocresp_ies,
-				      data->assocresp_ies_len, &ar_ie,
-				      MGMT_MASK_ASSOC_RESP |
-				      MGMT_MASK_REASSOC_RESP);
+	if (data->assocresp_ies && data->assocresp_ies_len) {
+		mwifiex_update_vs_ie(data->assocresp_ies,
+				     data->assocresp_ies_len, &ar_ie,
+				     MGMT_MASK_ASSOC_RESP |
+				     MGMT_MASK_REASSOC_RESP,
+				     WLAN_OUI_MICROSOFT,
+				     WLAN_OUI_TYPE_MICROSOFT_WPS);
+		mwifiex_update_vs_ie(data->assocresp_ies,
+				     data->assocresp_ies_len, &ar_ie,
+				     MGMT_MASK_ASSOC_RESP |
+				     MGMT_MASK_REASSOC_RESP, WLAN_OUI_WFA,
+				     WLAN_OUI_TYPE_WFA_P2P);
+	}
 
 	if (beacon_ie || pr_ie || ar_ie) {
 		ret = mwifiex_update_uap_custom_ie(priv, beacon_ie,
-- 
1.7.0.2

