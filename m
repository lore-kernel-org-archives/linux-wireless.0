Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbcKXGxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 01:53:30 -0500
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 1/3] ath9k: Add a module parameter to set btcoex duty cycle
Date: Thu, 24 Nov 2016 14:53:20 +0800
Message-Id: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org> (sfid-20161124_075334_704169_283EAC5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

btcoex duty cyle allows user to balance the performance
between WLAN and BT.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/gpio.c |  4 +---
 drivers/net/wireless/ath/ath9k/init.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index ddb2886..782a2f2 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -278,7 +278,7 @@ static void ath_init_btcoex_timer(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD;
-	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+	btcoex->btcoex_no_stomp = (100 - btcoex->duty_cycle) *
 		btcoex->btcoex_period / 100;
 	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) *
 				   btcoex->btcoex_period / 100;
@@ -433,8 +433,6 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 		break;
 	case ATH_BTCOEX_CFG_MCI:
 		ath_init_btcoex_timer(sc);
-
-		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
 		INIT_LIST_HEAD(&sc->btcoex.mci.info);
 		ath9k_hw_btcoex_init_mci(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 368d9b3..8edd78b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -73,6 +73,12 @@ struct ath9k_eeprom_ctx {
 
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+static int ath9k_btcoex_duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
+module_param_named(btcoex_duty_cycle, ath9k_btcoex_duty_cycle, int, 0444);
+MODULE_PARM_DESC(btcoex_duty_cycle, "BT coexistence duty cycle");
+#endif
+
 bool is_ath9k_unloaded;
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -587,6 +593,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
 	sc->tx99_power = MAX_RATE_POWER + 1;
+
 	init_waitqueue_head(&sc->tx_wait);
 	sc->cur_chan = &sc->chanctx[0];
 	if (!ath9k_is_chanctx_enabled())
@@ -602,6 +609,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
 	common->disable_ani = false;
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	sc->btcoex.duty_cycle = ath9k_btcoex_duty_cycle;
+#endif
 	/*
 	 * Platform quirks.
 	 */
-- 
1.9.1
