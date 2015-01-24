Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3378 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbbAXRwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:52:40 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] cfg80211: Add new GCMP, CCMP-256, BIP-GMAC, BIP-CMAC-256 ciphers
Date: Sat, 24 Jan 2015 19:52:05 +0200
Message-ID: <1422121929-18238-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20150124_185243_190365_DBD84190)
In-Reply-To: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes cfg80211 aware of the GCMP, GCMP-256, CCMP-256, BIP-GMAC-128,
BIP-GMAC-256, and BIP-CMAC-256 cipher suites. These new cipher suites
were defined in IEEE Std 802.11ac-2013.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h | 18 ++++++++++++++++++
 net/wireless/util.c       | 41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4f4eea8..dbf417b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1994,9 +1994,15 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_WEP40 = 5,
 	WLAN_KEY_LEN_WEP104 = 13,
 	WLAN_KEY_LEN_CCMP = 16,
+	WLAN_KEY_LEN_CCMP_256 = 32,
 	WLAN_KEY_LEN_TKIP = 32,
 	WLAN_KEY_LEN_AES_CMAC = 16,
 	WLAN_KEY_LEN_SMS4 = 32,
+	WLAN_KEY_LEN_GCMP = 16,
+	WLAN_KEY_LEN_GCMP_256 = 32,
+	WLAN_KEY_LEN_BIP_CMAC_256 = 32,
+	WLAN_KEY_LEN_BIP_GMAC_128 = 16,
+	WLAN_KEY_LEN_BIP_GMAC_256 = 32,
 };
 
 #define IEEE80211_WEP_IV_LEN		4
@@ -2004,9 +2010,16 @@ enum ieee80211_key_len {
 #define IEEE80211_CCMP_HDR_LEN		8
 #define IEEE80211_CCMP_MIC_LEN		8
 #define IEEE80211_CCMP_PN_LEN		6
+#define IEEE80211_CCMP_256_HDR_LEN	8
+#define IEEE80211_CCMP_256_MIC_LEN	16
+#define IEEE80211_CCMP_256_PN_LEN	6
 #define IEEE80211_TKIP_IV_LEN		8
 #define IEEE80211_TKIP_ICV_LEN		4
 #define IEEE80211_CMAC_PN_LEN		6
+#define IEEE80211_GMAC_PN_LEN		6
+#define IEEE80211_GCMP_HDR_LEN		8
+#define IEEE80211_GCMP_MIC_LEN		16
+#define IEEE80211_GCMP_PN_LEN		6
 
 /* Public action codes */
 enum ieee80211_pub_actioncode {
@@ -2230,6 +2243,11 @@ enum ieee80211_sa_query_action {
 #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
 #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
 #define WLAN_CIPHER_SUITE_GCMP		0x000FAC08
+#define WLAN_CIPHER_SUITE_GCMP_256	0x000FAC09
+#define WLAN_CIPHER_SUITE_CCMP_256	0x000FAC0A
+#define WLAN_CIPHER_SUITE_BIP_GMAC_128	0x000FAC0B
+#define WLAN_CIPHER_SUITE_BIP_GMAC_256	0x000FAC0C
+#define WLAN_CIPHER_SUITE_BIP_CMAC_256	0x000FAC0D
 
 #define WLAN_CIPHER_SUITE_SMS4		0x00147201
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f608ba0..c42202a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -236,11 +236,18 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 	 */
 	if (pairwise && key_idx &&
 	    ((params->cipher == WLAN_CIPHER_SUITE_TKIP) ||
-	     (params->cipher == WLAN_CIPHER_SUITE_CCMP)))
+	     (params->cipher == WLAN_CIPHER_SUITE_CCMP) ||
+	     (params->cipher == WLAN_CIPHER_SUITE_CCMP_256) ||
+	     (params->cipher == WLAN_CIPHER_SUITE_GCMP) ||
+	     (params->cipher == WLAN_CIPHER_SUITE_GCMP_256)))
 		return -EINVAL;
 
 	/* Disallow BIP (group-only) cipher as pairwise cipher */
-	if (pairwise && params->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+	if (pairwise &&
+	    (params->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
+	     params->cipher == WLAN_CIPHER_SUITE_BIP_CMAC_256 ||
+	     params->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
+	     params->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256))
 		return -EINVAL;
 
 	switch (params->cipher) {
@@ -256,6 +263,18 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		if (params->key_len != WLAN_KEY_LEN_CCMP)
 			return -EINVAL;
 		break;
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		if (params->key_len != WLAN_KEY_LEN_CCMP_256)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_GCMP:
+		if (params->key_len != WLAN_KEY_LEN_GCMP)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		if (params->key_len != WLAN_KEY_LEN_GCMP_256)
+			return -EINVAL;
+		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (params->key_len != WLAN_KEY_LEN_WEP104)
 			return -EINVAL;
@@ -264,6 +283,18 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		if (params->key_len != WLAN_KEY_LEN_AES_CMAC)
 			return -EINVAL;
 		break;
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		if (params->key_len != WLAN_KEY_LEN_BIP_CMAC_256)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+		if (params->key_len != WLAN_KEY_LEN_BIP_GMAC_128)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		if (params->key_len != WLAN_KEY_LEN_BIP_GMAC_256)
+			return -EINVAL;
+		break;
 	default:
 		/*
 		 * We don't know anything about this algorithm,
@@ -283,7 +314,13 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 		case WLAN_CIPHER_SUITE_TKIP:
 		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP_256:
+		case WLAN_CIPHER_SUITE_GCMP:
+		case WLAN_CIPHER_SUITE_GCMP_256:
 		case WLAN_CIPHER_SUITE_AES_CMAC:
+		case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_256:
 			if (params->seq_len != 6)
 				return -EINVAL;
 			break;
-- 
1.9.1

