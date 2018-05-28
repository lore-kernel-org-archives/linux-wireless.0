Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:41547 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938294AbeE1L31 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 07:29:27 -0400
Received: by mail-wr0-f196.google.com with SMTP id u12-v6so19713270wrn.8
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 04:29:26 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 2/3] wcn36xx: Track associated stations
Date: Mon, 28 May 2018 13:29:19 +0200
Message-Id: <1527506960-13358-2-git-send-email-loic.poulain@linaro.org> (sfid-20180528_132947_186037_6336DE3A)
In-Reply-To: <1527506960-13358-1-git-send-email-loic.poulain@linaro.org>
References: <1527506960-13358-1-git-send-email-loic.poulain@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add list of associated stations(STA, AP, peer...) per vif.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 5 +++++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 4648a78..6fd0bf6 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -567,6 +567,7 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 				key_conf->keyidx,
 				key_conf->keylen,
 				key);
+
 			if ((WLAN_CIPHER_SUITE_WEP40 == key_conf->cipher) ||
 			    (WLAN_CIPHER_SUITE_WEP104 == key_conf->cipher)) {
 				sta_priv->is_data_encrypted = true;
@@ -984,6 +985,7 @@ static int wcn36xx_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&wcn->conf_mutex);
 
 	vif_priv->bss_index = WCN36XX_HAL_BSS_INVALID_IDX;
+	INIT_LIST_HEAD(&vif_priv->sta_list);
 	list_add(&vif_priv->list, &wcn->vif_list);
 	wcn36xx_smd_add_sta_self(wcn, vif);
 
@@ -1005,6 +1007,8 @@ static int wcn36xx_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	spin_lock_init(&sta_priv->ampdu_lock);
 	sta_priv->vif = vif_priv;
+	list_add(&sta_priv->list, &vif_priv->sta_list);
+
 	/*
 	 * For STA mode HW will be configured on BSS_CHANGED_ASSOC because
 	 * at this stage AID is not available yet.
@@ -1032,6 +1036,7 @@ static int wcn36xx_sta_remove(struct ieee80211_hw *hw,
 
 	mutex_lock(&wcn->conf_mutex);
 
+	list_del(&sta_priv->list);
 	wcn36xx_smd_delete_sta(wcn, sta_priv->sta_index);
 	sta_priv->vif = NULL;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 11e7401..a58f313 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -129,6 +129,8 @@ struct wcn36xx_vif {
 	u8 self_sta_index;
 	u8 self_dpu_desc_index;
 	u8 self_ucast_dpu_sign;
+
+	struct list_head sta_list;
 };
 
 /**
@@ -154,6 +156,7 @@ struct wcn36xx_vif {
  * |______________|_____________|_______________|
  */
 struct wcn36xx_sta {
+	struct list_head list;
 	struct wcn36xx_vif *vif;
 	u16 aid;
 	u16 tid;
-- 
2.7.4
