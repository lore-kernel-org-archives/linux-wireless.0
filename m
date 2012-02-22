Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39247 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:12:02 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38200.953531.598399@gargle.gargle.HOWL> (sfid-20120222_081207_915294_E686A385)
Date: Wed, 22 Feb 2012 12:41:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 20/26] ath9k: Remove ATH_BTCOEX_CFG_NONE checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since BTCOEX code can be compiled out cleanly now,
remove these checks.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c       |   21 ---------------------
 drivers/net/wireless/ath/ath9k/gpio.c         |    9 ---------
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |   11 -----------
 drivers/net/wireless/ath/ath9k/hw.h           |    2 +-
 4 files changed, 1 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 5365959..ec32719 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -68,9 +68,6 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 	u32 i, idx;
 	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		rxclear_polarity = !ath_bt_config.bt_rxclear_polarity;
 
@@ -136,9 +133,6 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	/* connect bt_active to baseband */
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 		    (AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
@@ -161,9 +155,6 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	/* btcoex 3-wire */
 	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
@@ -214,9 +205,6 @@ static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	/* Configure the desired GPIO port for TX_FRAME output */
 	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
@@ -228,9 +216,6 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
@@ -319,9 +304,6 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 	int i;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	btcoex_hw->enabled = false;
 	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_MCI) {
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
@@ -370,9 +352,6 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
 			      enum ath_stomp_type stomp_type)
 {
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_btcoex_bt_stomp(ah, stomp_type);
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4da486b..1f1a5c6 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -251,9 +251,6 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	if (ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_NONE)
-		return 0;
-
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD * 1000;
 	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
 		btcoex->btcoex_period / 100;
@@ -286,9 +283,6 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 
 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btcoex->hw_timer_enabled)
 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
@@ -309,9 +303,6 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_hw *ah = sc->sc_ah;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	del_timer_sync(&btcoex->period_timer);
 
 	if (btcoex->hw_timer_enabled)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 6aa7674..1c10e2e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -119,9 +119,6 @@ static void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
 {
 	struct ath_btcoex *btcoex = &priv->btcoex;
 
-	if (ath9k_hw_get_btcoex_scheme(priv->ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD;
 	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
 		btcoex->btcoex_period / 100;
@@ -140,9 +137,6 @@ static void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
 	struct ath_btcoex *btcoex = &priv->btcoex;
 	struct ath_hw *ah = priv->ah;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex work\n");
 
 	btcoex->bt_priority_cnt = 0;
@@ -157,9 +151,6 @@ static void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
  */
 static void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
 {
-	if (ath9k_hw_get_btcoex_scheme(priv->ah) == ATH_BTCOEX_CFG_NONE)
-		return;
-
 	cancel_delayed_work_sync(&priv->coex_period_work);
 	cancel_delayed_work_sync(&priv->duty_cycle_work);
 }
@@ -195,8 +186,6 @@ void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
 
 	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
 		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
-		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
-			return;
 	}
 
 	switch (ath9k_hw_get_btcoex_scheme(priv->ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d627399..5e4d8dc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1075,7 +1075,7 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 {
 	return ATH_BTCOEX_CFG_NONE;
 }
-#endif
+#endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
-- 
1.7.9.1

