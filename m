Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:60753 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751853Ab2FLWIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 18:08:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4 RESEND] mwifiex: parse WPA IE and support WPA/WPA2 mixed mode for uAP
Date: Tue, 12 Jun 2012 15:02:25 -0700
Message-Id: <1339538547-14558-2-git-send-email-bzhao@marvell.com> (sfid-20120613_000838_479252_622FCA3E)
In-Reply-To: <1339538547-14558-1-git-send-email-bzhao@marvell.com>
References: <1339538547-14558-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Add support for parsing WPA IE from beacon parameter of
cfg80211_ap_settings and set it to FW.

WPA/WPA2 mixed mode is supported with this patch.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch depends on:
[PATCH] ieee80211: definitions for Microsoft Vendor OUI and WPA OUI type
(mac80211-next.git)

 drivers/net/wireless/mwifiex/ie.c      |   55 +++++++++++++++++++++-----------
 drivers/net/wireless/mwifiex/uap_cmd.c |   17 +++++++--
 2 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index ceb82cd..328fb14 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -224,29 +224,46 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			 struct cfg80211_ap_settings *params)
 {
 	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL;
-	struct mwifiex_ie *ar_ie = NULL, *rsn_ie = NULL;
-	struct ieee_types_header *ie = NULL;
+	struct mwifiex_ie *ar_ie = NULL, *gen_ie = NULL;
+	struct ieee_types_header *rsn_ie = NULL, *wpa_ie = NULL;
 	u16 beacon_idx = MWIFIEX_AUTO_IDX_MASK, pr_idx = MWIFIEX_AUTO_IDX_MASK;
 	u16 ar_idx = MWIFIEX_AUTO_IDX_MASK, rsn_idx = MWIFIEX_AUTO_IDX_MASK;
-	u16 mask;
+	u16 mask, ie_len = 0;
+	const u8 *vendor_ie;
 	int ret = 0;
 
 	if (params->beacon.tail && params->beacon.tail_len) {
-		ie = (void *)cfg80211_find_ie(WLAN_EID_RSN, params->beacon.tail,
-					      params->beacon.tail_len);
-		if (ie) {
-			rsn_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
-			if (!rsn_ie)
-				return -ENOMEM;
-
-			rsn_ie->ie_index = cpu_to_le16(rsn_idx);
-			mask = MGMT_MASK_BEACON | MGMT_MASK_PROBE_RESP |
-			       MGMT_MASK_ASSOC_RESP;
-			rsn_ie->mgmt_subtype_mask = cpu_to_le16(mask);
-			rsn_ie->ie_length = cpu_to_le16(ie->len + 2);
-			memcpy(rsn_ie->ie_buffer, ie, ie->len + 2);
-
-			if (mwifiex_update_uap_custom_ie(priv, rsn_ie, &rsn_idx,
+		gen_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!gen_ie)
+			return -ENOMEM;
+		gen_ie->ie_index = cpu_to_le16(rsn_idx);
+		mask = MGMT_MASK_BEACON | MGMT_MASK_PROBE_RESP |
+		       MGMT_MASK_ASSOC_RESP;
+		gen_ie->mgmt_subtype_mask = cpu_to_le16(mask);
+
+		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
+						  params->beacon.tail,
+						  params->beacon.tail_len);
+		if (rsn_ie) {
+			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
+			ie_len = rsn_ie->len + 2;
+			gen_ie->ie_length = cpu_to_le16(ie_len);
+		}
+
+		vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+						    WLAN_OUI_TYPE_MICROSOFT_WPA,
+						    params->beacon.tail,
+						    params->beacon.tail_len);
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
 							 NULL, NULL,
 							 NULL, NULL)) {
 				ret = -1;
@@ -319,7 +336,7 @@ done:
 	kfree(beacon_ie);
 	kfree(pr_ie);
 	kfree(ar_ie);
-	kfree(rsn_ie);
+	kfree(gen_ie);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index fb0c6cb..38a49a1 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -65,7 +65,7 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			}
 			if (params->crypto.wpa_versions &
 			    NL80211_WPA_VERSION_2) {
-				bss_config->protocol = PROTOCOL_WPA2;
+				bss_config->protocol |= PROTOCOL_WPA2;
 				bss_config->key_mgmt = KEY_MGMT_EAP;
 			}
 			break;
@@ -77,7 +77,7 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			}
 			if (params->crypto.wpa_versions &
 			    NL80211_WPA_VERSION_2) {
-				bss_config->protocol = PROTOCOL_WPA2;
+				bss_config->protocol |= PROTOCOL_WPA2;
 				bss_config->key_mgmt = KEY_MGMT_PSK;
 			}
 			break;
@@ -91,10 +91,19 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 		case WLAN_CIPHER_SUITE_WEP104:
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
-			bss_config->wpa_cfg.pairwise_cipher_wpa = CIPHER_TKIP;
+			if (params->crypto.wpa_versions & NL80211_WPA_VERSION_1)
+				bss_config->wpa_cfg.pairwise_cipher_wpa |=
+								CIPHER_TKIP;
+			if (params->crypto.wpa_versions & NL80211_WPA_VERSION_2)
+				bss_config->wpa_cfg.pairwise_cipher_wpa2 |=
+								CIPHER_TKIP;
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
-			bss_config->wpa_cfg.pairwise_cipher_wpa2 =
+			if (params->crypto.wpa_versions & NL80211_WPA_VERSION_1)
+				bss_config->wpa_cfg.pairwise_cipher_wpa |=
+								CIPHER_AES_CCMP;
+			if (params->crypto.wpa_versions & NL80211_WPA_VERSION_2)
+				bss_config->wpa_cfg.pairwise_cipher_wpa2 |=
 								CIPHER_AES_CCMP;
 		default:
 			break;
-- 
1.7.0.2

