Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdKLOWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Nov 2017 09:22:12 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: kvalo@codeaurora.org
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, Eyal Ilsar <eilsar@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH] wcn36xx: Set BTLE coexistence related configuration values to defaults
Date: Sun, 12 Nov 2017 16:21:46 +0200
Message-Id: <1510496506-4428-1-git-send-email-rfried@codeaurora.org> (sfid-20171112_152233_093861_7EC6D19C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Ilsar <eilsar@codeaurora.org>

If the value for the firmware configuration parameters BTC_STATIC_LEN_LE_BT
and BTC_STATIC_LEN_LE_WLAN are not set the duty cycle between BT and WLAN
is such that if BT (including BLE) is active WLAN gets 0 bandwidth.
When tuning these parameters having a too high value for WLAN means that BLE performance degrades.
The "sweet" point of roughly half of the maximal values was empirically found to achieve
a balance between BLE and Wi-Fi coexistence performance.

Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 9c6590d..1c75987 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -72,8 +72,10 @@ struct wcn36xx_cfg_val {
 	WCN36XX_CFG_VAL(DYNAMIC_PS_POLL_VALUE, 0),
 	WCN36XX_CFG_VAL(TX_PWR_CTRL_ENABLE, 1),
 	WCN36XX_CFG_VAL(ENABLE_CLOSE_LOOP, 1),
-	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
+	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_BT, 120000),
+	WCN36XX_CFG_VAL(BTC_STATIC_LEN_LE_WLAN, 30000),
 	WCN36XX_CFG_VAL(MAX_ASSOC_LIMIT, 10),
+	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
 	WCN36XX_CFG_VAL(ENABLE_MCC_ADAPTIVE_SCHEDULER, 0),
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
