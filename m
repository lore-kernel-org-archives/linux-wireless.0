Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40686 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755912Ab2F2DbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/6] mwifiex: parse WPS IEs from beacon_data
Date: Thu, 28 Jun 2012 20:30:30 -0700
Message-Id: <1340940630-27172-7-git-send-email-bzhao@marvell.com> (sfid-20120629_053129_694125_5C694B9F)
In-Reply-To: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
References: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Parse WPS IEs from start_ap as well as change_beacon handlers
and set them to FW. Beacon IEs, Probe Response IEs and Assoc
Response IEs are parsed from beacon_data and set to FW with
related masks.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c |   84 +++++++++++++++++++-----------------
 1 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 1f2d4b9..1d8dd00 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -214,6 +214,38 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
 	return ret;
 }
 
+/* This function checks if WPS IE is present in passed buffer and copies it to
+ * mwifiex_ie structure.
+ * Function takes pointer to struct mwifiex_ie pointer as argument.
+ * If WPS IE is present memory is allocated for mwifiex_ie pointer and filled
+ * in with WPS IE. Caller should take care of freeing this memory.
+ */
+static int mwifiex_update_wps_ie(const u8 *ies, int ies_len,
+				 struct mwifiex_ie **ie_ptr, u16 mask)
+{
+	struct ieee_types_header *wps_ie;
+	struct mwifiex_ie *ie = NULL;
+	const u8 *vendor_ie;
+
+	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+					    WLAN_OUI_TYPE_MICROSOFT_WPS,
+					    ies, ies_len);
+	if (vendor_ie) {
+		ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!ie)
+			return -ENOMEM;
+
+		wps_ie = (struct ieee_types_header *)vendor_ie;
+		memcpy(ie->ie_buffer, wps_ie, wps_ie->len + 2);
+		ie->ie_length = cpu_to_le16(wps_ie->len + 2);
+		ie->mgmt_subtype_mask = cpu_to_le16(mask);
+		ie->ie_index = cpu_to_le16(MWIFIEX_AUTO_IDX_MASK);
+	}
+
+	*ie_ptr = ie;
+	return 0;
+}
+
 /* This function parses beacon IEs, probe response IEs, association response IEs
  * from cfg80211_ap_settings->beacon and sets these IE to FW.
  */
@@ -225,48 +257,20 @@ static int mwifiex_set_mgmt_beacon_data_ies(struct mwifiex_private *priv,
 	u16 ar_idx = MWIFIEX_AUTO_IDX_MASK;
 	int ret = 0;
 
-	if (data->beacon_ies && data->beacon_ies_len) {
-		beacon_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!beacon_ie) {
-			ret = -ENOMEM;
-			goto done;
-		}
-
-		beacon_ie->ie_index = cpu_to_le16(beacon_idx);
-		beacon_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON);
-		beacon_ie->ie_length = cpu_to_le16(data->beacon_ies_len);
-		memcpy(beacon_ie->ie_buffer, data->beacon_ies,
-		       data->beacon_ies_len);
-	}
-
-	if (data->proberesp_ies && data->proberesp_ies_len) {
-		pr_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!pr_ie) {
-			ret = -ENOMEM;
-			goto done;
-		}
-
-		pr_ie->ie_index = cpu_to_le16(pr_idx);
-		pr_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_PROBE_RESP);
-		pr_ie->ie_length = cpu_to_le16(data->proberesp_ies_len);
-		memcpy(pr_ie->ie_buffer, data->proberesp_ies,
-		       data->proberesp_ies_len);
-	}
+	if (data->beacon_ies && data->beacon_ies_len)
+		mwifiex_update_wps_ie(data->beacon_ies, data->beacon_ies_len,
+				      &beacon_ie, MGMT_MASK_BEACON);
 
-	if (data->assocresp_ies && data->assocresp_ies_len) {
-		ar_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-		if (!ar_ie) {
-			ret = -ENOMEM;
-			goto done;
-		}
+	if (data->proberesp_ies && data->proberesp_ies_len)
+		mwifiex_update_wps_ie(data->proberesp_ies,
+				      data->proberesp_ies_len, &pr_ie,
+				      MGMT_MASK_PROBE_RESP);
 
-		ar_ie->ie_index = cpu_to_le16(ar_idx);
-		ar_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_ASSOC_RESP |
-						       MGMT_MASK_REASSOC_RESP);
-		ar_ie->ie_length = cpu_to_le16(data->assocresp_ies_len);
-		memcpy(ar_ie->ie_buffer, data->assocresp_ies,
-		       data->assocresp_ies_len);
-	}
+	if (data->assocresp_ies && data->assocresp_ies_len)
+		mwifiex_update_wps_ie(data->assocresp_ies,
+				      data->assocresp_ies_len, &ar_ie,
+				      MGMT_MASK_ASSOC_RESP |
+				      MGMT_MASK_REASSOC_RESP);
 
 	if (beacon_ie || pr_ie || ar_ie) {
 		ret = mwifiex_update_uap_custom_ie(priv, beacon_ie,
-- 
1.7.0.2

