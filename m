Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:60789 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaBLTFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:09 -0500
Received: by mail-we0-f179.google.com with SMTP id q58so6279175wes.24
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:08 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 8/9] wcn36xx: Track dpu signature per sta
Date: Wed, 12 Feb 2014 19:04:47 +0000
Message-Id: <1392231888-2191-8-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200552_975887_638A07D6)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

This fixes problems seen with multiple softap clients and reconnecting
softap clients.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c     | 5 +++--
 drivers/net/wireless/ath/wcn36xx/txrx.c    | 4 ++--
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index c7da55c..7bf0ef8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -902,11 +902,12 @@ static int wcn36xx_smd_config_sta_rsp(struct wcn36xx *wcn,
 
 	sta_priv->sta_index = params->sta_index;
 	sta_priv->dpu_desc_index = params->dpu_index;
+	sta_priv->ucast_dpu_sign = params->uc_ucast_sig;
 
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
-		    "hal config sta rsp status %d sta_index %d bssid_index %d p2p %d\n",
+		    "hal config sta rsp status %d sta_index %d bssid_index %d uc_ucast_sig %d p2p %d\n",
 		    params->status, params->sta_index, params->bssid_index,
-		    params->p2p);
+		    params->uc_ucast_sig, params->p2p);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 2dbed20..be0dda0 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -132,6 +132,7 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 				   struct ieee80211_vif,
 				   drv_priv);
 
+		bd->dpu_sign = sta_priv->ucast_dpu_sign;
 		if (vif->type == NL80211_IFTYPE_STATION) {
 			bd->sta_index = sta_priv->bss_sta_index;
 			bd->dpu_desc_idx = sta_priv->bss_dpu_desc_index;
@@ -145,10 +146,9 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 		__vif_priv = get_vif_by_addr(wcn, hdr->addr2);
 		bd->sta_index = __vif_priv->self_sta_index;
 		bd->dpu_desc_idx = __vif_priv->self_dpu_desc_index;
+		bd->dpu_sign = __vif_priv->self_ucast_dpu_sign;
 	}
 
-	bd->dpu_sign = __vif_priv->self_ucast_dpu_sign;
-
 	if (ieee80211_is_nullfunc(hdr->frame_control) ||
 	   (sta_priv && !sta_priv->is_data_encrypted))
 		bd->dpu_ne = 1;
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 6447105..f0fb81d 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -159,6 +159,7 @@ struct wcn36xx_sta {
 	u16 tid;
 	u8 sta_index;
 	u8 dpu_desc_index;
+	u8 ucast_dpu_sign;
 	u8 bss_sta_index;
 	u8 bss_dpu_desc_index;
 	bool is_data_encrypted;
-- 
1.8.3.2

