Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25290 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3TDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:03:49 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH v2 17/22] ath6kl: Fix a typo in ath6k context
Date: Tue, 30 Aug 2011 21:58:06 +0300
Message-ID: <1314730691-12089-18-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210353_246742_5399B9B6)
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
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   13 +++++++------
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 72735ee..af8e9cc 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -168,7 +168,8 @@ static int ath6kl_set_auth_type(struct ath6kl *ar,
 static int ath6kl_set_cipher(struct ath6kl *ar, u32 cipher, bool ucast)
 {
 	u8 *ar_cipher = ucast ? &ar->prwise_crypto : &ar->grp_crypto;
-	u8 *ar_cipher_len = ucast ? &ar->prwise_crypto_len : &ar->grp_crpto_len;
+	u8 *ar_cipher_len = ucast ? &ar->prwise_crypto_len :
+		&ar->grp_crypto_len;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: cipher 0x%x, ucast %u\n",
 		   __func__, cipher, ucast);
@@ -371,14 +372,14 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		   __func__,
 		   ar->auth_mode, ar->dot11_auth_mode, ar->prwise_crypto,
 		   ar->prwise_crypto_len, ar->grp_crypto,
-		   ar->grp_crpto_len, ar->ch_hint);
+		   ar->grp_crypto_len, ar->ch_hint);
 
 	ar->reconnect_flag = 0;
 	status = ath6kl_wmi_connect_cmd(ar->wmi, ar->nw_type,
 					ar->dot11_auth_mode, ar->auth_mode,
 					ar->prwise_crypto,
 					ar->prwise_crypto_len,
-					ar->grp_crypto, ar->grp_crpto_len,
+					ar->grp_crypto, ar->grp_crypto_len,
 					ar->ssid_len, ar->ssid,
 					ar->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
@@ -688,7 +689,7 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 					ar->prwise_crypto,
 					ar->prwise_crypto_len,
 					ar->grp_crypto,
-					ar->grp_crpto_len,
+					ar->grp_crypto_len,
 					ar->ssid_len,
 					ar->ssid,
 					ar->req_bssid,
@@ -1277,13 +1278,13 @@ static int ath6kl_cfg80211_join_ibss(struct wiphy *wiphy,
 		   __func__,
 		   ar->auth_mode, ar->dot11_auth_mode, ar->prwise_crypto,
 		   ar->prwise_crypto_len, ar->grp_crypto,
-		   ar->grp_crpto_len, ar->ch_hint);
+		   ar->grp_crypto_len, ar->ch_hint);
 
 	status = ath6kl_wmi_connect_cmd(ar->wmi, ar->nw_type,
 					ar->dot11_auth_mode, ar->auth_mode,
 					ar->prwise_crypto,
 					ar->prwise_crypto_len,
-					ar->grp_crypto, ar->grp_crpto_len,
+					ar->grp_crypto, ar->grp_crypto_len,
 					ar->ssid_len, ar->ssid,
 					ar->req_bssid, ar->ch_hint,
 					ar->connect_ctrl_flags);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 99cabd2..60e2291 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -380,7 +380,7 @@ struct ath6kl {
 	u8 prwise_crypto;
 	u8 prwise_crypto_len;
 	u8 grp_crypto;
-	u8 grp_crpto_len;
+	u8 grp_crypto_len;
 	u8 def_txkey_index;
 	struct ath6kl_wep_key wep_key_list[WMI_MAX_KEY_INDEX + 1];
 	u8 bssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 3b99ae2..32b7ef5 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -85,7 +85,7 @@ void ath6kl_init_profile_info(struct ath6kl *ar)
 	ar->prwise_crypto = NONE_CRYPT;
 	ar->prwise_crypto_len = 0;
 	ar->grp_crypto = NONE_CRYPT;
-	ar->grp_crpto_len = 0;
+	ar->grp_crypto_len = 0;
 	memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
 	memset(ar->req_bssid, 0, sizeof(ar->req_bssid));
 	memset(ar->bssid, 0, sizeof(ar->bssid));
-- 
1.7.4.1

