Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55716 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbcCAGai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 01:30:38 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v2 7/8] ath9k: fix BTCoex access invalid registers for SOC chips
Date: Tue,  1 Mar 2016 14:29:43 +0800
Message-Id: <1456813784-21218-8-git-send-email-miaoqing@codeaurora.org> (sfid-20160301_073040_933816_346FFC2B)
In-Reply-To: <1456813784-21218-1-git-send-email-miaoqing@codeaurora.org>
References: <1456813784-21218-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

The registers of AR_GPIO_INPUT_MUX1 and AR_GPIO_PDPU were removed
from SOC chips, fix invalid accessing

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 5a9ecf7..a754f6d 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -162,9 +162,10 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 		    AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
 
 	/* Set input mux for bt_active to gpio pin */
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-		      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-		      btcoex_hw->btactive_gpio);
+	if (!AR_SREV_SOC(ah))
+		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+			      btcoex_hw->btactive_gpio);
 
 	/* Configure the desired gpio port for input */
 	ath9k_hw_gpio_request_in(ah, btcoex_hw->btactive_gpio,
@@ -183,13 +184,14 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 
 	/* Set input mux for bt_prority_async and
 	 *                  bt_active_async to GPIO pins */
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			btcoex_hw->btactive_gpio);
-
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-			AR_GPIO_INPUT_MUX1_BT_PRIORITY,
-			btcoex_hw->btpriority_gpio);
+	if (!AR_SREV_SOC(ah)) {
+		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+			      btcoex_hw->btactive_gpio);
+		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			      AR_GPIO_INPUT_MUX1_BT_PRIORITY,
+			      btcoex_hw->btpriority_gpio);
+	}
 
 	/* Configure the desired GPIO ports for input */
 	ath9k_hw_gpio_request_in(ah, btcoex_hw->btactive_gpio,
@@ -285,13 +287,13 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 				 txprio_shift[i-1]);
 		}
 	}
+
 	/* Last WLAN weight has to be adjusted wrt tx priority */
 	if (concur_tx) {
 		btcoex_hw->wlan_weight[i-1] &= ~(0xff << txprio_shift[i-1]);
 		btcoex_hw->wlan_weight[i-1] |= (btcoex_hw->tx_prio[stomp_type]
 						      << txprio_shift[i-1]);
 	}
-
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 
@@ -375,7 +377,8 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 		break;
 	}
 
-	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_MCI) {
+	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_MCI &&
+	    !AR_SREV_SOC(ah)) {
 		REG_RMW(ah, AR_GPIO_PDPU,
 			(0x2 << (btcoex_hw->btactive_gpio * 2)),
 			(0x3 << (btcoex_hw->btactive_gpio * 2)));
-- 
1.9.1

