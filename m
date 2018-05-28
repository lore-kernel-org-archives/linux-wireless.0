Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53327 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938132AbeE1L3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 07:29:24 -0400
Received: by mail-wm0-f66.google.com with SMTP id a67-v6so31163749wmf.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 04:29:24 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 1/3] wcn36xx: Fix WEP104 encryption type
Date: Mon, 28 May 2018 13:29:18 +0200
Message-Id: <1527506960-13358-1-git-send-email-loic.poulain@linaro.org> (sfid-20180528_132946_532504_1358BA38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index aeb5e6e..4648a78 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -512,7 +512,7 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP40;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
-		vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP40;
+		vif_priv->encrypt_type = WCN36XX_HAL_ED_WEP104;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		vif_priv->encrypt_type = WCN36XX_HAL_ED_CCMP;
-- 
2.7.4
