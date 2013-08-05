Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53692 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3HEJmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 05:42:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k: Remove ath_ant_comb_update()
Date: Mon,  5 Aug 2013 15:08:26 +0530
Message-Id: <1375695508-1997-1-git-send-email-sujith@msujith.org> (sfid-20130805_114209_887143_D2B4E3EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

During a HW reset, the diversity config is programmed
in the set_board_values() eeprom callback, there is no
need to do it again by calling ath_ant_comb_update().

Fixed antenna support is not fully handled for 1-stream
cards, it can be done later.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 23 -----------------------
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 -
 drivers/net/wireless/ath/ath9k/debug.c   |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    |  3 ---
 4 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 85391e6..dd1cc73 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -867,26 +867,3 @@ div_comb_done:
 	antcomb->main_recv_cnt = 0;
 	antcomb->alt_recv_cnt = 0;
 }
-
-void ath_ant_comb_update(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_hw_antcomb_conf div_ant_conf;
-	u8 lna_conf;
-
-	ath9k_hw_antdiv_comb_conf_get(ah, &div_ant_conf);
-
-	if (sc->ant_rx == 1)
-		lna_conf = ATH_ANT_DIV_COMB_LNA1;
-	else
-		lna_conf = ATH_ANT_DIV_COMB_LNA2;
-
-	div_ant_conf.main_lna_conf = lna_conf;
-	div_ant_conf.alt_lna_conf = lna_conf;
-
-	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
-
-	if (common->bt_ant_diversity)
-		ath9k_hw_set_bt_ant_diversity(ah, true);
-}
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 18898ab..c497d52 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -628,7 +628,6 @@ struct ath_ant_comb {
 };
 
 void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
-void ath_ant_comb_update(struct ath_softc *sc);
 
 /********************/
 /* Main driver core */
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index daa316b..a155190 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -307,7 +307,7 @@ static ssize_t write_file_bt_ant_diversity(struct file *file,
 
 	common->bt_ant_diversity = !!bt_ant_diversity;
 	ath9k_ps_wakeup(sc);
-	ath_ant_comb_update(sc);
+	ath9k_hw_set_bt_ant_diversity(sc->sc_ah, common->bt_ant_diversity);
 	ath_dbg(common, CONFIG, "Enable WLAN/BT RX Antenna diversity: %d\n",
 		common->bt_ant_diversity);
 	ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1adb803..afeab3c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -238,9 +238,6 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		ath_restart_work(sc);
 	}
 
-	if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx != 3)
-		ath_ant_comb_update(sc);
-
 	ieee80211_wake_queues(sc->hw);
 
 	return true;
-- 
1.8.3.4

