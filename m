Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46675 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWHTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 02:19:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 9/9] ath9k: Remove RX Poll
Date: Mon, 23 Dec 2013 12:44:26 +0530
Message-Id: <1387782866-19847-10-git-send-email-sujith@msujith.org> (sfid-20131223_081946_547696_6E53A234)
In-Reply-To: <1387782866-19847-1-git-send-email-sujith@msujith.org>
References: <1387782866-19847-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch removes the convoluted and hacky method of
monitoring for connectivity. We rely on mac80211's connection
loss logic and doing it in the driver is not necessary.

The HW check for MAC/BB hangs is also simplified, there
is no need to have a separate work instance for it.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  7 +---
 drivers/net/wireless/ath/ath9k/beacon.c | 10 ++++--
 drivers/net/wireless/ath/ath9k/init.c   |  2 --
 drivers/net/wireless/ath/ath9k/link.c   | 63 +++++----------------------------
 drivers/net/wireless/ath/ath9k/main.c   |  7 ----
 drivers/net/wireless/ath/ath9k/recv.c   |  4 ---
 drivers/net/wireless/ath/ath9k/wow.c    |  1 -
 7 files changed, 17 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f2202e7..f622a98 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -455,10 +455,8 @@ bool ath9k_csa_is_finished(struct ath_softc *sc);
 
 void ath_tx_complete_poll_work(struct work_struct *work);
 void ath_reset_work(struct work_struct *work);
-void ath_hw_check(struct work_struct *work);
+bool ath_hw_check(struct ath_softc *sc);
 void ath_hw_pll_work(struct work_struct *work);
-void ath_rx_poll(unsigned long data);
-void ath_start_rx_poll(struct ath_softc *sc, u8 nbeacon);
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
 void ath_start_ani(struct ath_softc *sc);
@@ -722,12 +720,10 @@ struct ath_softc {
 	spinlock_t sc_pcu_lock;
 	struct mutex mutex;
 	struct work_struct paprd_work;
-	struct work_struct hw_check_work;
 	struct work_struct hw_reset_work;
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
-	unsigned int hw_busy_count;
 	unsigned long sc_flags;
 	unsigned long driver_data;
 
@@ -761,7 +757,6 @@ struct ath_softc {
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct delayed_work hw_pll_work;
-	struct timer_list rx_poll_timer;
 	struct timer_list sleep_timer;
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 112aff7..2e8bba0 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -337,8 +337,14 @@ void ath9k_beacon_tasklet(unsigned long data)
 
 		ath9k_hw_check_nav(ah);
 
-		if (!ath9k_hw_check_alive(ah))
-			ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+		/*
+		 * If the previous beacon has not been transmitted
+		 * and a MAC/BB hang has been identified, return
+		 * here because a chip reset would have been
+		 * initiated.
+		 */
+		if (!ath_hw_check(sc))
+			return;
 
 		if (sc->beacon.bmisscnt < BSTUCK_THRESH * sc->nbcnvifs) {
 			ath_dbg(common, BSTUCK,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e63465b7..f2a17fc 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -763,10 +763,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	setup_timer(&sc->sleep_timer, ath_ps_full_sleep, (unsigned long)sc);
 	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
-	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
 	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
-	setup_timer(&sc->rx_poll_timer, ath_rx_poll, (unsigned long)sc);
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index aed7e29..c92ca81 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -65,50 +65,26 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 /*
  * Checks if the BB/MAC is hung.
  */
-void ath_hw_check(struct work_struct *work)
+bool ath_hw_check(struct ath_softc *sc)
 {
-	struct ath_softc *sc = container_of(work, struct ath_softc, hw_check_work);
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long flags;
-	int busy;
-	u8 is_alive, nbeacon = 1;
 	enum ath_reset_type type;
+	bool is_alive;
 
 	ath9k_ps_wakeup(sc);
+
 	is_alive = ath9k_hw_check_alive(sc->sc_ah);
 
-	if ((is_alive && !AR_SREV_9300(sc->sc_ah)) || sc->tx99_state)
-		goto out;
-	else if (!is_alive && AR_SREV_9300(sc->sc_ah)) {
+	if (!is_alive) {
 		ath_dbg(common, RESET,
-			"DCU stuck is detected. Schedule chip reset\n");
+			"HW hang detected, schedule chip reset\n");
 		type = RESET_TYPE_MAC_HANG;
-		goto sched_reset;
-	}
-
-	spin_lock_irqsave(&common->cc_lock, flags);
-	busy = ath_update_survey_stats(sc);
-	spin_unlock_irqrestore(&common->cc_lock, flags);
-
-	ath_dbg(common, RESET, "Possible baseband hang, busy=%d (try %d)\n",
-		busy, sc->hw_busy_count + 1);
-	if (busy >= 99) {
-		if (++sc->hw_busy_count >= 3) {
-			type = RESET_TYPE_BB_HANG;
-			goto sched_reset;
-		}
-	} else if (busy >= 0) {
-		sc->hw_busy_count = 0;
-		nbeacon = 3;
+		ath9k_queue_reset(sc, type);
 	}
 
-	ath_start_rx_poll(sc, nbeacon);
-	goto out;
-
-sched_reset:
-	ath9k_queue_reset(sc, type);
-out:
 	ath9k_ps_restore(sc);
+
+	return is_alive;
 }
 
 /*
@@ -162,29 +138,6 @@ void ath_hw_pll_work(struct work_struct *work)
 }
 
 /*
- * RX Polling - monitors baseband hangs.
- */
-void ath_start_rx_poll(struct ath_softc *sc, u8 nbeacon)
-{
-	if (!AR_SREV_9300(sc->sc_ah))
-		return;
-
-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
-		return;
-
-	mod_timer(&sc->rx_poll_timer, jiffies + msecs_to_jiffies
-		  (nbeacon * sc->cur_beacon_conf.beacon_interval));
-}
-
-void ath_rx_poll(unsigned long data)
-{
-	struct ath_softc *sc = (struct ath_softc *)data;
-
-	if (!test_bit(SC_OP_INVALID, &sc->sc_flags))
-		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
-}
-
-/*
  * PA Pre-distortion.
  */
 static void ath_paprd_activate(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 24e2654..212652f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -170,7 +170,6 @@ void ath9k_ps_restore(struct ath_softc *sc)
 static void __ath_cancel_work(struct ath_softc *sc)
 {
 	cancel_work_sync(&sc->paprd_work);
-	cancel_work_sync(&sc->hw_check_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
@@ -194,7 +193,6 @@ void ath_restart_work(struct ath_softc *sc)
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work,
 				     msecs_to_jiffies(ATH_PLL_WORK_INTERVAL));
 
-	ath_start_rx_poll(sc, 3);
 	ath_start_ani(sc);
 }
 
@@ -204,11 +202,7 @@ static bool ath_prepare_reset(struct ath_softc *sc)
 	bool ret = true;
 
 	ieee80211_stop_queues(sc->hw);
-
-	sc->hw_busy_count = 0;
 	ath_stop_ani(sc);
-	del_timer_sync(&sc->rx_poll_timer);
-
 	ath9k_hw_disable_interrupts(ah);
 
 	if (!ath_drain_all_txq(sc))
@@ -867,7 +861,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
-	del_timer_sync(&sc->rx_poll_timer);
 
 	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3692b2a..470e1c0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1077,10 +1077,6 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	}
 
 	rx_stats->is_mybeacon = ath9k_is_mybeacon(sc, hdr);
-	if (rx_stats->is_mybeacon) {
-		sc->hw_busy_count = 0;
-		ath_start_rx_poll(sc, 3);
-	}
 
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status)) {
 		ret =-EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index f1cde81..1b3230f 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -197,7 +197,6 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 
 	ath_cancel_work(sc);
 	ath_stop_ani(sc);
-	del_timer_sync(&sc->rx_poll_timer);
 
 	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
 		ath_dbg(common, ANY, "Device not present\n");
-- 
1.8.5.2

