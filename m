Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48978 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab3LNRD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:58 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 03/11] ath9k_hw: use a software timer for btcoex no_stomp_timer
Date: Sat, 14 Dec 2013 18:03:37 +0100
Message-Id: <1387040625-38114-3-git-send-email-nbd@openwrt.org> (sfid-20131214_180417_399327_BF2F6935)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TSF accuracy is not needed here, and there is only one usable generic
timer that is supported by all chips and uses the primary TSF counter.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  7 ++---
 drivers/net/wireless/ath/ath9k/gpio.c  | 53 +++++++---------------------------
 drivers/net/wireless/ath/ath9k/mci.c   |  2 +-
 3 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5e5d5cb..dbf2a97 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -477,20 +477,19 @@ enum bt_op_flags {
 };
 
 struct ath_btcoex {
-	bool hw_timer_enabled;
 	spinlock_t btcoex_lock;
 	struct timer_list period_timer; /* Timer for BT period */
+	struct timer_list no_stomp_timer;
 	u32 bt_priority_cnt;
 	unsigned long bt_priority_time;
 	unsigned long op_flags;
 	int bt_stomp_type; /* Types of BT stomping */
-	u32 btcoex_no_stomp; /* in usec */
+	u32 btcoex_no_stomp; /* in msec */
 	u32 btcoex_period; /* in msec */
-	u32 btscan_no_stomp; /* in usec */
+	u32 btscan_no_stomp; /* in msec */
 	u32 duty_cycle;
 	u32 bt_wait_time;
 	int rssi_count;
-	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
 	struct ath_mci_profile mci;
 	u8 stomp_audio;
 };
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index c34f212..a85e220 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -257,19 +257,9 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
-	/*
-	 * btcoex_period is in msec while (btocex/btscan_)no_stomp are in usec,
-	 * ensure that we properly convert btcoex_period to usec
-	 * for any comparision with (btcoex/btscan_)no_stomp.
-	 */
-	if (btcoex->btcoex_period * 1000 != btcoex->btcoex_no_stomp) {
-		if (btcoex->hw_timer_enabled)
-			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
-
-		ath9k_gen_timer_start(ah, btcoex->no_stomp_timer, timer_period,
-				      timer_period * 10);
-		btcoex->hw_timer_enabled = true;
-	}
+	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp)
+		mod_timer(&btcoex->no_stomp_timer,
+			 jiffies + msecs_to_jiffies(timer_period));
 
 	ath9k_ps_restore(sc);
 
@@ -282,7 +272,7 @@ skip_hw_wakeup:
  * Generic tsf based hw timer which configures weight
  * registers to time slice between wlan and bt traffic
  */
-static void ath_btcoex_no_stomp_timer(void *arg)
+static void ath_btcoex_no_stomp_timer(unsigned long arg)
 {
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_hw *ah = sc->sc_ah;
@@ -311,24 +301,18 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
 	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD;
-	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) * 1000 *
+	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
 		btcoex->btcoex_period / 100;
-	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) * 1000 *
+	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) *
 				   btcoex->btcoex_period / 100;
 
 	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
 			(unsigned long) sc);
+	setup_timer(&btcoex->no_stomp_timer, ath_btcoex_no_stomp_timer,
+			(unsigned long) sc);
 
 	spin_lock_init(&btcoex->btcoex_lock);
 
-	btcoex->no_stomp_timer = ath_gen_timer_alloc(sc->sc_ah,
-			ath_btcoex_no_stomp_timer,
-			ath_btcoex_no_stomp_timer,
-			(void *) sc, AR_FIRST_NDP_TIMER);
-
-	if (!btcoex->no_stomp_timer)
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -343,10 +327,7 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
 
 	/* make sure duty cycle timer is also stopped when resuming */
-	if (btcoex->hw_timer_enabled) {
-		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
-		btcoex->hw_timer_enabled = false;
-	}
+	del_timer_sync(&btcoex->no_stomp_timer);
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
@@ -363,24 +344,16 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_hw *ah = sc->sc_ah;
 
 	del_timer_sync(&btcoex->period_timer);
-
-	if (btcoex->hw_timer_enabled) {
-		ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
-		btcoex->hw_timer_enabled = false;
-	}
+	del_timer_sync(&btcoex->no_stomp_timer);
 }
 
 void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
-	if (btcoex->hw_timer_enabled) {
-		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
-		btcoex->hw_timer_enabled = false;
-	}
+	del_timer_sync(&btcoex->no_stomp_timer);
 }
 
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
@@ -447,10 +420,6 @@ void ath9k_deinit_btcoex(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-        if ((sc->btcoex.no_stomp_timer) &&
-	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
-		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
-
 	if (ath9k_hw_mci_is_enabled(ah))
 		ath_mci_cleanup(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 0ac1b5f..71799fc 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -200,7 +200,7 @@ skip_tuning:
 	if (btcoex->duty_cycle > ATH_MCI_MAX_DUTY_CYCLE)
 		btcoex->duty_cycle = ATH_MCI_MAX_DUTY_CYCLE;
 
-	btcoex->btcoex_no_stomp =  btcoex->btcoex_period * 1000 *
+	btcoex->btcoex_no_stomp =  btcoex->btcoex_period *
 		(100 - btcoex->duty_cycle) / 100;
 
 	ath9k_hw_btcoex_enable(sc->sc_ah);
-- 
1.8.3.4 (Apple Git-47)

