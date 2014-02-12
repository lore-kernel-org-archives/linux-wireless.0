Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:43521 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaBLTFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:08 -0500
Received: by mail-we0-f176.google.com with SMTP id q58so6299916wes.21
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:07 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 7/9] wcn36xx: Rename wcn36xx_vif.ucast_dpu_signature to self_ucast_dpu_sign
Date: Wed, 12 Feb 2014 19:04:46 +0000
Message-Id: <1392231888-2191-7-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200520_572839_37CE1CEA)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

This is more line with the names of the other members

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c     | 2 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c    | 2 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index ae36409..c7da55c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1121,7 +1121,7 @@ static int wcn36xx_smd_config_bss_rsp(struct wcn36xx *wcn,
 		priv_vif->sta->bss_dpu_desc_index = params->dpu_desc_index;
 	}
 
-	priv_vif->ucast_dpu_signature = params->ucast_dpu_signature;
+	priv_vif->self_ucast_dpu_sign = params->ucast_dpu_signature;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index b2b60e3..2dbed20 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -147,7 +147,7 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 		bd->dpu_desc_idx = __vif_priv->self_dpu_desc_index;
 	}
 
-	bd->dpu_sign = __vif_priv->ucast_dpu_signature;
+	bd->dpu_sign = __vif_priv->self_ucast_dpu_sign;
 
 	if (ieee80211_is_nullfunc(hdr->frame_control) ||
 	   (sta_priv && !sta_priv->is_data_encrypted))
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index b4dc85b..6447105 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -125,10 +125,10 @@ struct wcn36xx_vif {
 	enum wcn36xx_power_state pw_state;
 
 	u8 bss_index;
-	u8 ucast_dpu_signature;
 	/* Returned from WCN36XX_HAL_ADD_STA_SELF_RSP */
 	u8 self_sta_index;
 	u8 self_dpu_desc_index;
+	u8 self_ucast_dpu_sign;
 };
 
 /**
-- 
1.8.3.2

