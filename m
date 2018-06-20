Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:35409 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754690AbeFTIrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:47:12 -0400
Received: by mail-wr0-f182.google.com with SMTP id l8-v6so825152wrr.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 01:47:11 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 3/3] wcn36xx: Fix WEP encryption
Date: Wed, 20 Jun 2018 09:58:00 +0200
Message-Id: <1529481480-13247-3-git-send-email-loic.poulain@linaro.org> (sfid-20180620_104718_833179_64E14F18)
In-Reply-To: <1529481480-13247-1-git-send-email-loic.poulain@linaro.org>
References: <1529481480-13247-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of WEP encryption, driver has to configure shared key for
associated station(s). Note that sta pointer is NULL in case of non
pairwise key, causing NULL pointer dereference with existing code
(sta_priv->is_data_encrypted). Fix this by using associated sta list
instead. This enables WEP support as client, WEP AP is non-functional.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: Commit reword, clarify Client/AP WEP status

 drivers/net/wireless/ath/wcn36xx/main.c | 19 +++++++++++--------
 drivers/net/wireless/ath/wcn36xx/smd.c  | 20 ++++++++++++++------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 6fd0bf6..e38443e 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -493,7 +493,7 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct wcn36xx *wcn = hw->priv;
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
-	struct wcn36xx_sta *sta_priv = wcn36xx_sta_to_priv(sta);
+	struct wcn36xx_sta *sta_priv = sta ? wcn36xx_sta_to_priv(sta) : NULL;
 	int ret = 0;
 	u8 key[WLAN_MAX_KEY_LEN];
 
@@ -570,13 +570,16 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 			if ((WLAN_CIPHER_SUITE_WEP40 == key_conf->cipher) ||
 			    (WLAN_CIPHER_SUITE_WEP104 == key_conf->cipher)) {
-				sta_priv->is_data_encrypted = true;
-				wcn36xx_smd_set_stakey(wcn,
-					vif_priv->encrypt_type,
-					key_conf->keyidx,
-					key_conf->keylen,
-					key,
-					get_sta_index(vif, sta_priv));
+				list_for_each_entry(sta_priv,
+						    &vif_priv->sta_list, list) {
+					sta_priv->is_data_encrypted = true;
+					wcn36xx_smd_set_stakey(wcn,
+						vif_priv->encrypt_type,
+						key_conf->keyidx,
+						key_conf->keylen,
+						key,
+						get_sta_index(vif, sta_priv));
+				}
 			}
 		}
 		break;
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index b4dadf7..304a86c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1708,12 +1708,20 @@ int wcn36xx_smd_set_stakey(struct wcn36xx *wcn,
 	msg_body.set_sta_key_params.sta_index = sta_index;
 	msg_body.set_sta_key_params.enc_type = enc_type;
 
-	msg_body.set_sta_key_params.key[0].id = keyidx;
-	msg_body.set_sta_key_params.key[0].unicast = 1;
-	msg_body.set_sta_key_params.key[0].direction = WCN36XX_HAL_TX_RX;
-	msg_body.set_sta_key_params.key[0].pae_role = 0;
-	msg_body.set_sta_key_params.key[0].length = keylen;
-	memcpy(msg_body.set_sta_key_params.key[0].key, key, keylen);
+	if (enc_type == WCN36XX_HAL_ED_WEP104 ||
+	    enc_type == WCN36XX_HAL_ED_WEP40) {
+		/* Use bss key for wep (static) */
+		msg_body.set_sta_key_params.def_wep_idx = keyidx;
+		msg_body.set_sta_key_params.wep_type = 0;
+	} else {
+		msg_body.set_sta_key_params.key[0].id = keyidx;
+		msg_body.set_sta_key_params.key[0].unicast = 1;
+		msg_body.set_sta_key_params.key[0].direction = WCN36XX_HAL_TX_RX;
+		msg_body.set_sta_key_params.key[0].pae_role = 0;
+		msg_body.set_sta_key_params.key[0].length = keylen;
+		memcpy(msg_body.set_sta_key_params.key[0].key, key, keylen);
+	}
+
 	msg_body.set_sta_key_params.single_tid_rc = 1;
 
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
-- 
2.7.4
