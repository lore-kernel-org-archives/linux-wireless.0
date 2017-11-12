Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdKLMs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Nov 2017 07:48:56 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: kvalo@codeaurora.org
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, Eyal Ilsar <eilsar@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH] wcn36xx: Set BTLE coexistence related configuration values to defaults
Date: Sun, 12 Nov 2017 14:48:24 +0200
Message-Id: <1510490904-21255-1-git-send-email-rfried@codeaurora.org> (sfid-20171112_134916_518203_78F2A7CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Ilsar <eilsar@codeaurora.org>

Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c  | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index b83f01d..0d4ed41 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -27,7 +27,7 @@
 #include <linux/soc/qcom/wcnss_ctrl.h>
 #include "wcn36xx.h"
 
-unsigned int wcn36xx_dbg_mask;
+unsigned int wcn36xx_dbg_mask = WCN36XX_DBG_NONE;
 module_param_named(debug_mask, wcn36xx_dbg_mask, uint, 0644);
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 
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
