Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51770 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3KKVX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:23:59 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/3] ath9k: use a timer to put hardware into full sleep
Date: Mon, 11 Nov 2013 22:23:33 +0100
Message-Id: <1384205015-68622-1-git-send-email-nbd@openwrt.org> (sfid-20131111_222406_805671_F8F0D9A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in client mode, the short period of time between scanning
and associating is often enough to put the hardware through several
FULL-SLEEP <-> AWAKE transitions, each wakeup requiring a reset to fully
recover the hardware.
This is completely unnecessary and can easily be avoided by deferring
the switch to full sleep.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 ++
 drivers/net/wireless/ath/ath9k/init.c  |  2 ++
 drivers/net/wireless/ath/ath9k/main.c  | 27 ++++++++++++++++++++++-----
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4c3bbe4..48aca2f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -459,6 +459,7 @@ void ath_check_ani(struct ath_softc *sc);
 int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
+void ath_ps_full_sleep(unsigned long data);
 
 /**********/
 /* BTCOEX */
@@ -759,6 +760,7 @@ struct ath_softc {
 	struct delayed_work tx_complete_work;
 	struct delayed_work hw_pll_work;
 	struct timer_list rx_poll_timer;
+	struct timer_list sleep_timer;
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex btcoex;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d8643eb..0d0820b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -730,6 +730,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
 		     (unsigned long)sc);
 
+	setup_timer(&sc->sleep_timer, ath_ps_full_sleep, (unsigned long)sc);
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
 	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
@@ -1059,6 +1060,7 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
+	del_timer_sync(&sc->sleep_timer);
 	ath9k_hw_deinit(sc->sc_ah);
 	if (sc->dfs_detector != NULL)
 		sc->dfs_detector->exit(sc->dfs_detector);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 74f452c..a85738d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -82,6 +82,22 @@ static bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
 	return ret;
 }
 
+void ath_ps_full_sleep(unsigned long data)
+{
+	struct ath_softc *sc = (struct ath_softc *) data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	bool reset;
+
+	spin_lock(&common->cc_lock);
+	ath_hw_cycle_counters_update(common);
+	spin_unlock(&common->cc_lock);
+
+	ath9k_hw_setrxabort(sc->sc_ah, 1);
+	ath9k_hw_stopdmarecv(sc->sc_ah, &reset);
+
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+}
+
 void ath9k_ps_wakeup(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -92,6 +108,7 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	if (++sc->ps_usecount != 1)
 		goto unlock;
 
+	del_timer_sync(&sc->sleep_timer);
 	power_mode = sc->sc_ah->power_mode;
 	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 
@@ -117,17 +134,17 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	enum ath9k_power_mode mode;
 	unsigned long flags;
-	bool reset;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
 	if (sc->ps_idle) {
-		ath9k_hw_setrxabort(sc->sc_ah, 1);
-		ath9k_hw_stopdmarecv(sc->sc_ah, &reset);
-		mode = ATH9K_PM_FULL_SLEEP;
-	} else if (sc->ps_enabled &&
+		mod_timer(&sc->sleep_timer, jiffies + HZ / 10);
+		goto unlock;
+	}
+
+	if (sc->ps_enabled &&
 		   !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 				     PS_WAIT_FOR_CAB |
 				     PS_WAIT_FOR_PSPOLL_DATA |
-- 
1.8.3.4 (Apple Git-47)

