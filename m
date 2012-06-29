Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:55686 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753178Ab2F2DbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/6] mwifiex: pass cfg80211_beacon_data to mwifiex_set_mgmt_ie()
Date: Thu, 28 Jun 2012 20:30:25 -0700
Message-Id: <1340940630-27172-2-git-send-email-bzhao@marvell.com> (sfid-20120629_053133_764414_0DD099C8)
In-Reply-To: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
References: <1340940630-27172-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Pass cfg80211_beacon_data pointer instead of cfg80211_ap_settings.
While setting management IEs we only need cfg80211_beacon_data of
cfg80211_ap_settings which has Tail IE, Head IE and other IE elements.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
 drivers/net/wireless/mwifiex/ie.c       |   37 +++++++++++++-----------------
 drivers/net/wireless/mwifiex/main.h     |    2 +-
 3 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e241f8d..fce8155 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -947,7 +947,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP)
 		return -1;
-	if (mwifiex_set_mgmt_ies(priv, params))
+	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
 		return -1;
 
 	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 8374e33..4a38fd8 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -222,7 +222,7 @@ mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
  * to FW.
  */
 int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
-			 struct cfg80211_ap_settings *params)
+			 struct cfg80211_beacon_data *data)
 {
 	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL;
 	struct mwifiex_ie *ar_ie = NULL, *gen_ie = NULL;
@@ -233,7 +233,7 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 	const u8 *vendor_ie;
 	int ret = 0;
 
-	if (params->beacon.tail && params->beacon.tail_len) {
+	if (data->tail && data->tail_len) {
 		gen_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
 		if (!gen_ie)
 			return -ENOMEM;
@@ -243,8 +243,7 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 		gen_ie->mgmt_subtype_mask = cpu_to_le16(mask);
 
 		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
-						  params->beacon.tail,
-						  params->beacon.tail_len);
+						  data->tail, data->tail_len);
 		if (rsn_ie) {
 			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
 			ie_len = rsn_ie->len + 2;
@@ -253,8 +252,7 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 
 		vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
 						    WLAN_OUI_TYPE_MICROSOFT_WPA,
-						    params->beacon.tail,
-						    params->beacon.tail_len);
+						    data->tail, data->tail_len);
 		if (vendor_ie) {
 			wpa_ie = (struct ieee_types_header *)vendor_ie;
 			memcpy(gen_ie->ie_buffer + ie_len,
@@ -275,7 +273,7 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 		}
 	}
 
-	if (params->beacon.beacon_ies && params->beacon.beacon_ies_len) {
+	if (data->beacon_ies && data->beacon_ies_len) {
 		beacon_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
 		if (!beacon_ie) {
 			ret = -ENOMEM;
@@ -284,13 +282,12 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 
 		beacon_ie->ie_index = cpu_to_le16(beacon_idx);
 		beacon_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON);
-		beacon_ie->ie_length =
-				cpu_to_le16(params->beacon.beacon_ies_len);
-		memcpy(beacon_ie->ie_buffer, params->beacon.beacon_ies,
-		       params->beacon.beacon_ies_len);
+		beacon_ie->ie_length = cpu_to_le16(data->beacon_ies_len);
+		memcpy(beacon_ie->ie_buffer, data->beacon_ies,
+		       data->beacon_ies_len);
 	}
 
-	if (params->beacon.proberesp_ies && params->beacon.proberesp_ies_len) {
+	if (data->proberesp_ies && data->proberesp_ies_len) {
 		pr_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
 		if (!pr_ie) {
 			ret = -ENOMEM;
@@ -299,13 +296,12 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 
 		pr_ie->ie_index = cpu_to_le16(pr_idx);
 		pr_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_PROBE_RESP);
-		pr_ie->ie_length =
-				cpu_to_le16(params->beacon.proberesp_ies_len);
-		memcpy(pr_ie->ie_buffer, params->beacon.proberesp_ies,
-		       params->beacon.proberesp_ies_len);
+		pr_ie->ie_length = cpu_to_le16(data->proberesp_ies_len);
+		memcpy(pr_ie->ie_buffer, data->proberesp_ies,
+		       data->proberesp_ies_len);
 	}
 
-	if (params->beacon.assocresp_ies && params->beacon.assocresp_ies_len) {
+	if (data->assocresp_ies && data->assocresp_ies_len) {
 		ar_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
 		if (!ar_ie) {
 			ret = -ENOMEM;
@@ -315,10 +311,9 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 		ar_ie->ie_index = cpu_to_le16(ar_idx);
 		mask = MGMT_MASK_ASSOC_RESP | MGMT_MASK_REASSOC_RESP;
 		ar_ie->mgmt_subtype_mask = cpu_to_le16(mask);
-		ar_ie->ie_length =
-				cpu_to_le16(params->beacon.assocresp_ies_len);
-		memcpy(ar_ie->ie_buffer, params->beacon.assocresp_ies,
-		       params->beacon.assocresp_ies_len);
+		ar_ie->ie_length = cpu_to_le16(data->assocresp_ies_len);
+		memcpy(ar_ie->ie_buffer, data->assocresp_ies,
+		       data->assocresp_ies_len);
 	}
 
 	if (beacon_ie || pr_ie || ar_ie) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 7cd95cc..9e63653 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1013,7 +1013,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev);
 void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config);
 
 int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
-			 struct cfg80211_ap_settings *params);
+			 struct cfg80211_beacon_data *data);
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv);
 u8 *mwifiex_11d_code_2_region(u8 code);
 
-- 
1.7.0.2

