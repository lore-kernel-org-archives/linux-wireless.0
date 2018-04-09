Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750759AbeDIHon (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 03:44:43 -0400
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: parse key management suite from RSN IE
Date: Mon, 9 Apr 2018 15:44:14 +0800
Message-ID: <1523259854-23131-1-git-send-email-huxm@marvell.com> (sfid-20180409_094447_926239_A6390C35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Association failed when using wpa_supplicant with
configuration key_mgmt=WPA-PSK-SHA256, and it is noticed
that wpa_supplicant set WLAN_AKM_SUITE_PSK_SHA256 in
RSN IE, but miss it in start_ap parameters.

This patch parse key management suite from RSN IE, in
case it is missed.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/main.h    | 12 ++++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 86 ++++++++++++++++++--------
 3 files changed, 72 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 13cd58e9..2be3ce1 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -413,6 +413,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define KEY_MGMT_NONE               0x04
 #define KEY_MGMT_PSK                0x02
 #define KEY_MGMT_EAP                0x01
+#define KEY_MGMT_PSK_SHA256         0x100
 #define CIPHER_TKIP                 0x04
 #define CIPHER_AES_CCMP             0x08
 #define VALID_CIPHER_BITMAP         0x0c
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 598e58b..db20132 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -364,6 +364,18 @@ struct ieee_types_generic {
 	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_header)];
 } __packed;
 
+struct ieee_types_rsn {
+	struct ieee_types_header ieee_hdr;
+	u8  element_id;
+	u8  element_len;
+	u16 rsn_version;
+	u32 cipher_group;
+	u16 n_ciphers_pairwise;
+	u32 ciphers_pairwise[];
+//	u16 n_akm_suites;
+//	u32 *akm_suites;
+} __packed;
+
 struct ieee_types_bss_co_2040 {
 	struct ieee_types_header ieee_hdr;
 	u8 bss_2040co;
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index 18f7d9b..0a27717 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -26,9 +26,14 @@
  */
 int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			      struct mwifiex_uap_bss_param *bss_config,
-			      struct cfg80211_ap_settings *params) {
+			      struct cfg80211_ap_settings *params)
+{
 	int i;
 	struct mwifiex_wep_key wep_key;
+	const struct ieee_types_rsn *rsn_ie = NULL;
+	const u8 *ie = NULL;
+	u16 n_akm_suites;
+	u32 *akm_suites;
 
 	if (!params->privacy) {
 		bss_config->protocol = PROTOCOL_NO_SECURITY;
@@ -58,36 +63,63 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 
 	bss_config->key_mgmt_operation |= KEY_MGMT_ON_HOST;
 
-	for (i = 0; i < params->crypto.n_akm_suites; i++) {
-		switch (params->crypto.akm_suites[i]) {
-		case WLAN_AKM_SUITE_8021X:
-			if (params->crypto.wpa_versions &
-			    NL80211_WPA_VERSION_1) {
-				bss_config->protocol = PROTOCOL_WPA;
-				bss_config->key_mgmt = KEY_MGMT_EAP;
-			}
-			if (params->crypto.wpa_versions &
-			    NL80211_WPA_VERSION_2) {
-				bss_config->protocol |= PROTOCOL_WPA2;
-				bss_config->key_mgmt = KEY_MGMT_EAP;
+	if (params->crypto.wpa_versions & NL80211_WPA_VERSION_1)
+		bss_config->protocol = PROTOCOL_WPA;
+
+	if (params->crypto.wpa_versions & NL80211_WPA_VERSION_2)
+		bss_config->protocol |= PROTOCOL_WPA2;
+
+	if (params->crypto.wpa_versions &
+	    (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2)) {
+		for (i = 0; i < params->crypto.n_akm_suites; i++) {
+			switch (params->crypto.akm_suites[i]) {
+			case WLAN_AKM_SUITE_8021X:
+					bss_config->key_mgmt = KEY_MGMT_EAP;
+				break;
+			case WLAN_AKM_SUITE_PSK:
+					bss_config->key_mgmt = KEY_MGMT_PSK;
+				break;
+			case WLAN_AKM_SUITE_PSK_SHA256:
+					bss_config->key_mgmt =
+							KEY_MGMT_PSK_SHA256;
+				break;
+			default:
+				break;
 			}
-			break;
-		case WLAN_AKM_SUITE_PSK:
-			if (params->crypto.wpa_versions &
-			    NL80211_WPA_VERSION_1) {
-				bss_config->protocol = PROTOCOL_WPA;
-				bss_config->key_mgmt = KEY_MGMT_PSK;
-			}
-			if (params->crypto.wpa_versions &
-			    NL80211_WPA_VERSION_2) {
-				bss_config->protocol |= PROTOCOL_WPA2;
-				bss_config->key_mgmt = KEY_MGMT_PSK;
+		}
+
+		ie = cfg80211_find_ie(WLAN_EID_RSN, params->beacon.tail,
+				      params->beacon.tail_len);
+
+		/* Try to get key management suites from RSN IE */
+		if (!bss_config->key_mgmt && ie) {
+			rsn_ie = (struct ieee_types_rsn *)ie;
+			ie = (u8 *)(rsn_ie->ciphers_pairwise +
+				    rsn_ie->n_ciphers_pairwise);
+			n_akm_suites = *((u16 *)ie);
+			akm_suites = (u32 *)(ie + sizeof(n_akm_suites));
+
+			for (i = 0; i < n_akm_suites; i++) {
+				switch (akm_suites[i]) {
+				case WLAN_AKM_SUITE_8021X:
+						bss_config->key_mgmt =
+								KEY_MGMT_EAP;
+					break;
+				case WLAN_AKM_SUITE_PSK:
+						bss_config->key_mgmt =
+								KEY_MGMT_PSK;
+					break;
+				case WLAN_AKM_SUITE_PSK_SHA256:
+						bss_config->key_mgmt =
+							KEY_MGMT_PSK_SHA256;
+					break;
+				default:
+					break;
+				}
 			}
-			break;
-		default:
-			break;
 		}
 	}
+
 	for (i = 0; i < params->crypto.n_ciphers_pairwise; i++) {
 		switch (params->crypto.ciphers_pairwise[i]) {
 		case WLAN_CIPHER_SUITE_WEP40:
-- 
1.9.1
