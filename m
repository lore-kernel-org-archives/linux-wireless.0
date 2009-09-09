Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZIIXo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 19:44:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/15] ath9k: split bluetooth hardware coex init into two helpers
Date: Wed,  9 Sep 2009 19:44:50 -0400
Message-Id: <1252539901-20679-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
References: <1252539901-20679-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a helper for 2-wire and another for 3-wire.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   75 ++++++++++++++++++-------------
 1 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index dfbcbd0..be69924 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -225,48 +225,61 @@ static int ath_init_btcoex_info(struct ath_hw *ah,
 	return 0;
 }
 
-int ath9k_hw_btcoex_init(struct ath_hw *ah)
+static void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
-	int ret = 0;
 
-	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE) {
-		/* connect bt_active to baseband */
-		REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-				(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
-				 AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
+	/* connect bt_active to baseband */
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    (AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
+		     AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
 
-		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-				AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
 
-		/* Set input mux for bt_active to gpio pin */
-		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-				AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-				btcoex_info->btactive_gpio);
+	/* Set input mux for bt_active to gpio pin */
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+		      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+		      btcoex_info->btactive_gpio);
 
-		/* Configure the desired gpio port for input */
-		ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
-	} else {
-		/* btcoex 3-wire */
-		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-				(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
-				 AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB));
+	/* Configure the desired gpio port for input */
+	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
+}
+
+static void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
 
-		/* Set input mux for bt_prority_async and
-		 *                  bt_active_async to GPIO pins */
-		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-				AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-				btcoex_info->btactive_gpio);
+	/* btcoex 3-wire */
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
+			 AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB));
 
-		REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-				AR_GPIO_INPUT_MUX1_BT_PRIORITY,
-				btcoex_info->btpriority_gpio);
+	/* Set input mux for bt_prority_async and
+	 *                  bt_active_async to GPIO pins */
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+			btcoex_info->btactive_gpio);
 
-		/* Configure the desired GPIO ports for input */
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			AR_GPIO_INPUT_MUX1_BT_PRIORITY,
+			btcoex_info->btpriority_gpio);
 
-		ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
-		ath9k_hw_cfg_gpio_input(ah, btcoex_info->btpriority_gpio);
+	/* Configure the desired GPIO ports for input */
+
+	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
+	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btpriority_gpio);
+}
+
+int ath9k_hw_btcoex_init(struct ath_hw *ah)
+{
+	struct ath_btcoex_info *btcoex_info = &ah->btcoex_info;
+	int ret = 0;
 
+	if (btcoex_info->btcoex_scheme == ATH_BTCOEX_CFG_2WIRE)
+		ath9k_hw_btcoex_init_2wire(ah);
+	else {
+		ath9k_hw_btcoex_init_3wire(ah);
 		ret = ath_init_btcoex_info(ah, btcoex_info);
 	}
 
-- 
1.6.3.3

