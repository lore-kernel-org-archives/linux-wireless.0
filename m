Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35906 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbcDSFBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 01:01:06 -0400
Received: by mail-pa0-f45.google.com with SMTP id er2so2646635pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 22:01:05 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/18] wcn36xx: Use define for invalid index and fix typo
Date: Mon, 18 Apr 2016 22:00:43 -0700
Message-Id: <1461042056-10607-6-git-send-email-bjorn.andersson@linaro.org> (sfid-20160419_070506_140836_6AC84775)
In-Reply-To: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
References: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h  | 2 +-
 drivers/net/wireless/ath/wcn36xx/main.c | 4 ++--
 drivers/net/wireless/ath/wcn36xx/smd.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 3af16cba3d12..433d9801a0ae 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -48,7 +48,7 @@
 
 #define WCN36XX_HAL_IPV4_ADDR_LEN       4
 
-#define WALN_HAL_STA_INVALID_IDX 0xFF
+#define WCN36XX_HAL_STA_INVALID_IDX 0xFF
 #define WCN36XX_HAL_BSS_INVALID_IDX 0xFF
 
 /* Default Beacon template size */
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 62cb9ffd854c..4781b5e8deb3 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -618,7 +618,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (!is_zero_ether_addr(bss_conf->bssid)) {
 			vif_priv->is_joining = true;
-			vif_priv->bss_index = 0xff;
+			vif_priv->bss_index = WCN36XX_HAL_BSS_INVALID_IDX;
 			wcn36xx_smd_join(wcn, bss_conf->bssid,
 					 vif->addr, WCN36XX_HW_CHANNEL(wcn));
 			wcn36xx_smd_config_bss(wcn, vif, NULL,
@@ -711,7 +711,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (bss_conf->enable_beacon) {
 			vif_priv->dtim_period = bss_conf->dtim_period;
-			vif_priv->bss_index = 0xff;
+			vif_priv->bss_index = WCN36XX_HAL_BSS_INVALID_IDX;
 			wcn36xx_smd_config_bss(wcn, vif, NULL,
 					       vif->addr, false);
 			skb = ieee80211_beacon_get_tim(hw, vif, &tim_off,
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 170440ed5d85..6d4aa9250ca8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -197,7 +197,7 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 	    vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_MESH_POINT) {
 		sta_params->type = 1;
-		sta_params->sta_index = 0xFF;
+		sta_params->sta_index = WCN36XX_HAL_STA_INVALID_IDX;
 	} else {
 		sta_params->type = 0;
 		sta_params->sta_index = 1;
-- 
2.5.0

