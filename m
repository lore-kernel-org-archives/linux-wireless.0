Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:41666 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754235AbeFTJBh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 05:01:37 -0400
Received: by mail-wr0-f193.google.com with SMTP id h10-v6so2413690wrq.8
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 02:01:37 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 1/3] wcn36xx: Fix WEP104 encryption type
Date: Wed, 20 Jun 2018 09:57:58 +0200
Message-Id: <1529481480-13247-1-git-send-email-loic.poulain@linaro.org> (sfid-20180620_110141_954923_C6E359F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an obvious copy & paste bug.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: non-empty commit message.

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
