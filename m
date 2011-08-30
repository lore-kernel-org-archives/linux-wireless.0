Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25390 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3TD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:03:59 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH v2 18/22] ath6kl: Fix default key installation in AP mode
Date: Tue, 30 Aug 2011 21:58:07 +0300
Message-ID: <1314730691-12089-19-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210402_632560_F3126509)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Edward Lu <elu@qca.qualcomm.com>

Signed-off-by: Edward Lu <elu@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index af8e9cc..a3aa150 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1025,6 +1025,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	struct ath6kl_key *key = NULL;
 	int status = 0;
 	u8 key_usage;
+	enum crypto_type key_type = NONE_CRYPT;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: index %d\n", __func__, key_index);
 
@@ -1049,12 +1050,16 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	key_usage = GROUP_USAGE;
 	if (ar->prwise_crypto == WEP_CRYPT)
 		key_usage |= TX_USAGE;
+	if (unicast)
+		key_type = ar->prwise_crypto;
+	if (multicast)
+		key_type = ar->grp_crypto;
 
 	if (ar->nw_type == AP_NETWORK && !test_bit(CONNECTED, &ar->flag))
 		return 0; /* Delay until AP mode has been started */
 
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
-				       ar->prwise_crypto, key_usage,
+				       key_type, key_usage,
 				       key->key_len, key->seq, key->key,
 				       KEY_OP_INIT_VAL, NULL,
 				       SYNC_BOTH_WMIFLAG);
@@ -1617,8 +1622,11 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 			break;
 		}
 	}
-	if (p.prwise_crypto_type == 0)
+	if (p.prwise_crypto_type == 0) {
 		p.prwise_crypto_type = NONE_CRYPT;
+		ath6kl_set_cipher(ar, 0, true);
+	} else if (info->crypto.n_ciphers_pairwise == 1)
+		ath6kl_set_cipher(ar, info->crypto.ciphers_pairwise[0], true);
 
 	switch (info->crypto.cipher_group) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -1635,6 +1643,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 		p.grp_crypto_type = NONE_CRYPT;
 		break;
 	}
+	ath6kl_set_cipher(ar, info->crypto.cipher_group, false);
 
 	p.nw_type = AP_NETWORK;
 	ar->nw_type = ar->next_mode;
-- 
1.7.4.1

