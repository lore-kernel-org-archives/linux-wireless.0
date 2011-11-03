Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KCJk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:40:27 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Dai Shuibing <shuibing@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 1/3] ath6kl: Add support for configuring SMS4 keys
Date: Thu, 3 Nov 2011 11:39:37 +0200
Message-ID: <1320313179-9259-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20111103_104030_151808_F590A81E)
In-Reply-To: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
References: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dai Shuibing <shuibing@qca.qualcomm.com>

Indicate support for WPI-SMS4 cipher and allow SMS4 keys to be
configured.

Signed-off-by: Dai Shuibing <shuibing@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   18 ++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/common.h   |    1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 04d24d4..42eeed1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -203,6 +203,10 @@ static int ath6kl_set_cipher(struct ath6kl_vif *vif, u32 cipher, bool ucast)
 		*ar_cipher = AES_CRYPT;
 		*ar_cipher_len = 0;
 		break;
+	case WLAN_CIPHER_SUITE_SMS4:
+		*ar_cipher = WAPI_CRYPT;
+		*ar_cipher_len = 0;
+		break;
 	default:
 		ath6kl_err("cipher 0x%x not supported\n", cipher);
 		return -ENOTSUPP;
@@ -935,13 +939,19 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		key_usage = GROUP_USAGE;
 
 	if (params) {
+		int seq_len = params->seq_len;
+		if (params->cipher == WLAN_CIPHER_SUITE_SMS4 &&
+		    seq_len > ATH6KL_KEY_SEQ_LEN) {
+			/* Only first half of the WPI PN is configured */
+			seq_len = ATH6KL_KEY_SEQ_LEN;
+		}
 		if (params->key_len > WLAN_MAX_KEY_LEN ||
-		    params->seq_len > sizeof(key->seq))
+		    seq_len > sizeof(key->seq))
 			return -EINVAL;
 
 		key->key_len = params->key_len;
 		memcpy(key->key, params->key, key->key_len);
-		key->seq_len = params->seq_len;
+		key->seq_len = seq_len;
 		memcpy(key->seq, params->seq, key->seq_len);
 		key->cipher = params->cipher;
 	}
@@ -959,6 +969,9 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = AES_CRYPT;
 		break;
+	case WLAN_CIPHER_SUITE_SMS4:
+		key_type = WAPI_CRYPT;
+		break;
 
 	default:
 		return -ENOTSUPP;
@@ -1451,6 +1464,7 @@ static const u32 cipher_suites[] = {
 	WLAN_CIPHER_SUITE_TKIP,
 	WLAN_CIPHER_SUITE_CCMP,
 	CCKM_KRK_CIPHER_SUITE,
+	WLAN_CIPHER_SUITE_SMS4,
 };
 
 static bool is_rate_legacy(s32 rate)
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index 41e465f..bfd6597 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -71,6 +71,7 @@ enum crypto_type {
 	WEP_CRYPT           = 0x02,
 	TKIP_CRYPT          = 0x04,
 	AES_CRYPT           = 0x08,
+	WAPI_CRYPT          = 0x10,
 };
 
 struct htc_endpoint_credit_dist;
-- 
1.7.4.1

