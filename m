Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758617AbdKPICR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 03:02:17 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: kvalo@codeaurora.org
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, nicolas.dechesne@linaro.org,
        Eyal Ilsar <eilsar@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH v4] wcn36xx: Set default BTLE coexistence config
Date: Thu, 16 Nov 2017 10:01:26 +0200
Message-Id: <20171116080126.17239-1-rfried@codeaurora.org> (sfid-20171116_090223_085858_434142DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Ilsar <eilsar@codeaurora.org>

If the value for the firmware configuration parameters
BTC_STATIC_LEN_LE_BT and BTC_STATIC_LEN_LE_WLAN are not set the duty
cycle between BT and WLAN is such that if BT (including BLE) is active
WLAN gets 0 bandwidth. When tuning these parameters having a too high
value for WLAN means that BLE performance degrades.
The "sweet" point of roughly half of the maximal values was empirically
found to achieve a balance between BLE and Wi-Fi coexistence
performance.

Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 9c6590d5348a..6f1e741acf3e 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -73,6 +73,8 @@ static struct wcn36xx_cfg_val wcn36xx_cfg_vals[] = {
 	WCN36XX_CFG_VAL(TX_PWR_CTRL_ENABLE, 1),
 	WCN36XX_CFG_VAL(ENABLE_CLOSE_LOOP, 1),
 	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
+	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_BT, 120000),
+	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_WLAN, 30000),
 	WCN36XX_CFG_VAL(MAX_ASSOC_LIMIT, 10),
 	WCN36XX_CFG_VAL(ENABLE_MCC_ADAPTIVE_SCHEDULER, 0),
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
