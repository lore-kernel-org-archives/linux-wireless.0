Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37705 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0CaWFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 18:05:32 -0400
Subject: [PATCH 2/3] ath9k: move imask from sc to ah
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 31 Mar 2010 18:05:31 -0400
Message-ID: <20100331220531.2920.94355.stgit@mj.roinet.com>
In-Reply-To: <20100331220525.2920.14907.stgit@mj.roinet.com>
References: <20100331220525.2920.14907.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ah variable in the functions that didn't have it and used sc->imask.
Replace sc->sc_ah with ah in those functions.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   35 ++++++++++--------
 drivers/net/wireless/ath/ath9k/gpio.c   |   15 +++-----
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |   60 ++++++++++++++++---------------
 5 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a581c36..bdcd257 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -480,7 +480,6 @@ struct ath_softc {
 	bool ps_enabled;
 	bool ps_idle;
 	unsigned long ps_usecount;
-	enum ath9k_int imask;
 
 	struct ath_config config;
 	struct ath_rx rx;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b4a31a4..22375a7 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -524,6 +524,7 @@ static void ath9k_beacon_init(struct ath_softc *sc,
 static void ath_beacon_config_ap(struct ath_softc *sc,
 				 struct ath_beacon_config *conf)
 {
+	struct ath_hw *ah = sc->sc_ah;
 	u32 nexttbtt, intval;
 
 	/* NB: the beacon interval is kept internally in TU's */
@@ -539,15 +540,15 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	 * prepare beacon frames.
 	 */
 	intval |= ATH9K_BEACON_ENA;
-	sc->imask |= ATH9K_INT_SWBA;
+	ah->imask |= ATH9K_INT_SWBA;
 	ath_beaconq_config(sc);
 
 	/* Set the computed AP beacon timers */
 
-	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+	ath9k_hw_set_interrupts(ah, 0);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	/* Clear the reset TSF flag, so that subsequent beacon updation
 	   will not reset the HW TSF. */
@@ -566,7 +567,8 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 static void ath_beacon_config_sta(struct ath_softc *sc,
 				  struct ath_beacon_config *conf)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_beacon_state bs;
 	int dtimperiod, dtimcount, sleepduration;
 	int cfpperiod, cfpcount;
@@ -605,7 +607,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	 * Pull nexttbtt forward to reflect the current
 	 * TSF and calculate dtim+cfp state for the result.
 	 */
-	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
 
 	num_beacons = tsftu / intval + 1;
@@ -678,17 +680,18 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 
 	/* Set the computed STA beacon timers */
 
-	ath9k_hw_set_interrupts(sc->sc_ah, 0);
-	ath9k_hw_set_sta_beacon_timers(sc->sc_ah, &bs);
-	sc->imask |= ATH9K_INT_BMISS;
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_set_sta_beacon_timers(ah, &bs);
+	ah->imask |= ATH9K_INT_BMISS;
+	ath9k_hw_set_interrupts(ah, ah->imask);
 }
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
 				    struct ath_beacon_config *conf,
 				    struct ieee80211_vif *vif)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u64 tsf;
 	u32 tsftu, intval, nexttbtt;
 
@@ -703,7 +706,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
         else if (intval)
                 nexttbtt = roundup(nexttbtt, intval);
 
-	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU((u32)(tsf>>32), (u32)tsf) + FUDGE;
 	do {
 		nexttbtt += intval;
@@ -719,20 +722,20 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	 * self-linked tx descriptor and let the hardware deal with things.
 	 */
 	intval |= ATH9K_BEACON_ENA;
-	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
-		sc->imask |= ATH9K_INT_SWBA;
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
+		ah->imask |= ATH9K_INT_SWBA;
 
 	ath_beaconq_config(sc);
 
 	/* Set the computed ADHOC beacon timers */
 
-	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+	ath9k_hw_set_interrupts(ah, 0);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	/* FIXME: Handle properly when vif is NULL */
-	if (vif && sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)
+	if (vif && ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)
 		ath_beacon_start_adhoc(sc, vif);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index deab8be..1e4578d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -283,22 +283,17 @@ static void ath9k_gen_timer_start(struct ath_hw *ah,
 				  u32 timer_next,
 				  u32 timer_period)
 {
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-
 	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
 
-	if ((sc->imask & ATH9K_INT_GENTIMER) == 0) {
+	if ((ah->imask & ATH9K_INT_GENTIMER) == 0) {
 		ath9k_hw_set_interrupts(ah, 0);
-		sc->imask |= ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, sc->imask);
+		ah->imask |= ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
 }
 
 static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 
 	ath9k_hw_gen_timer_stop(ah, timer);
@@ -306,8 +301,8 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 	/* if no timer is enabled, turn off interrupt mask */
 	if (timer_table->timer_mask.val == 0) {
 		ath9k_hw_set_interrupts(ah, 0);
-		sc->imask &= ~ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, sc->imask);
+		ah->imask &= ~ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6b03e16..0ac7a80 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -478,6 +478,7 @@ struct ath_hw {
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
 
 	int16_t curchan_rad_index;
+	enum ath9k_int imask;
 	u32 mask_reg;
 	u32 imrs2_reg;
 	u32 txok_interrupt_mask;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 67ca4e5..c25216b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -225,7 +225,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	ath_cache_conf_rate(sc, &hw->conf);
 	ath_update_txpow(sc);
-	ath9k_hw_set_interrupts(ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
  ps_restore:
 	ath9k_ps_restore(sc);
@@ -434,7 +434,7 @@ void ath9k_tasklet(unsigned long data)
 			ath_gen_timer_isr(sc->sc_ah);
 
 	/* re-enable hardware interrupt */
-	ath9k_hw_set_interrupts(ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 	ath9k_ps_restore(sc);
 }
 
@@ -477,7 +477,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * value to insure we only process bits we requested.
 	 */
 	ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
-	status &= sc->imask;	/* discard unasked-for bits */
+	status &= ah->imask;	/* discard unasked-for bits */
 
 	/*
 	 * If there are no status bits set, then this interrupt was not
@@ -518,7 +518,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 * the interrupt.
 		 */
 		ath9k_hw_procmibevent(ah);
-		ath9k_hw_set_interrupts(ah, sc->imask);
+		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
 
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
@@ -536,7 +536,7 @@ chip_reset:
 
 	if (sched) {
 		/* turn off every interrupt except SWBA */
-		ath9k_hw_set_interrupts(ah, (sc->imask & ATH9K_INT_SWBA));
+		ath9k_hw_set_interrupts(ah, (ah->imask & ATH9K_INT_SWBA));
 		tasklet_schedule(&sc->intr_tq);
 	}
 
@@ -887,7 +887,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
 
 	/* Re-Enable  interrupts */
-	ath9k_hw_set_interrupts(ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(ah, ah->led_pin,
@@ -977,7 +977,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
 
-	ath9k_hw_set_interrupts(ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (retry_tx) {
 		int i;
@@ -1162,23 +1162,23 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	}
 
 	/* Setup our intr mask. */
-	sc->imask = ATH9K_INT_RX | ATH9K_INT_TX
+	ah->imask = ATH9K_INT_RX | ATH9K_INT_TX
 		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
 		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_GTT)
-		sc->imask |= ATH9K_INT_GTT;
+		ah->imask |= ATH9K_INT_GTT;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-		sc->imask |= ATH9K_INT_CST;
+		ah->imask |= ATH9K_INT_CST;
 
 	ath_cache_conf_rate(sc, &hw->conf);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
 
 	/* Disable BMISS interrupt when we're not associated */
-	sc->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	ath9k_hw_set_interrupts(ah, sc->imask);
+	ah->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	ieee80211_wake_queues(hw);
 
@@ -1372,14 +1372,15 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
 	int ret = 0;
 
 	mutex_lock(&sc->mutex);
 
-	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) &&
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) &&
 	    sc->nvifs > 0) {
 		ret = -ENOBUFS;
 		goto out;
@@ -1414,19 +1415,19 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs++;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		ath9k_set_bssid_mask(hw);
 
 	if (sc->nvifs > 1)
 		goto out; /* skip global settings for secondary vif */
 
 	if (ic_opmode == NL80211_IFTYPE_AP) {
-		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
+		ath9k_hw_set_tsfadjust(ah, 1);
 		sc->sc_flags |= SC_OP_TSF_RESET;
 	}
 
 	/* Set the device opmode */
-	sc->sc_ah->opmode = ic_opmode;
+	ah->opmode = ic_opmode;
 
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
@@ -1435,11 +1436,11 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if ((vif->type == NL80211_IFTYPE_STATION) ||
 	    (vif->type == NL80211_IFTYPE_ADHOC) ||
 	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
-		sc->imask |= ATH9K_INT_MIB;
-		sc->imask |= ATH9K_INT_TSFOOR;
+		ah->imask |= ATH9K_INT_MIB;
+		ah->imask |= ATH9K_INT_TSFOOR;
 	}
 
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (vif->type == NL80211_IFTYPE_AP    ||
 	    vif->type == NL80211_IFTYPE_ADHOC ||
@@ -1495,15 +1496,16 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 void ath9k_enable_ps(struct ath_softc *sc)
 {
+	struct ath_hw *ah = sc->sc_ah;
+
 	sc->ps_enabled = true;
-	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-		if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
-			sc->imask |= ATH9K_INT_TIM_TIMER;
-			ath9k_hw_set_interrupts(sc->sc_ah,
-					sc->imask);
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+		if ((ah->imask & ATH9K_INT_TIM_TIMER) == 0) {
+			ah->imask |= ATH9K_INT_TIM_TIMER;
+			ath9k_hw_set_interrupts(ah, ah->imask);
 		}
 	}
-	ath9k_hw_setrxabort(sc->sc_ah, 1);
+	ath9k_hw_setrxabort(ah, 1);
 }
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
@@ -1580,10 +1582,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 						  PS_WAIT_FOR_CAB |
 						  PS_WAIT_FOR_PSPOLL_DATA |
 						  PS_WAIT_FOR_TX_ACK);
-				if (sc->imask & ATH9K_INT_TIM_TIMER) {
-					sc->imask &= ~ATH9K_INT_TIM_TIMER;
+				if (ah->imask & ATH9K_INT_TIM_TIMER) {
+					ah->imask &= ~ATH9K_INT_TIM_TIMER;
 					ath9k_hw_set_interrupts(sc->sc_ah,
-							sc->imask);
+							ah->imask);
 				}
 			}
 		}
