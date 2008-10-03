Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36090 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYJDFpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 01:45:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 22:45:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: [PATCH 3/3] ath9k: enable ANI to help with noisy environments
Date: Fri, 3 Oct 2008 15:45:27 -0700
Message-ID: <1223073927-16266-4-git-send-email-lrodriguez@atheros.com> (sfid-20081004_074555_826463_786CA51C)
In-Reply-To: <1223073927-16266-3-git-send-email-lrodriguez@atheros.com>
References: <1223073927-16266-1-git-send-email-lrodriguez@atheros.com>
 <1223073927-16266-2-git-send-email-lrodriguez@atheros.com>
 <1223073927-16266-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables Adaptive Noise Immunity (ANI) on ath9k.
ANI is as algorithm designed to minimize the detrimental
effects of time-varying interferences. This should
help with throughput in noisy environments. To use
ANI we re-enable the MIB interrupt. Since ANI works
on a timer and updates the noise floor we take
advantage of this and also report a non-static noise
floor now to mac80211.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: Jouni Malinen <Jouni.Malinen@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I've tested this on x86 and x86_64

 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath9k/core.c  |  129 ++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath9k/core.h  |   25 +++++++
 drivers/net/wireless/ath9k/hw.c    |   35 ++++++++--
 drivers/net/wireless/ath9k/main.c  |   18 +++++-
 drivers/net/wireless/ath9k/recv.c  |   13 +---
 6 files changed, 197 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 0e897c2..accace5 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -854,7 +854,7 @@ bool ath9k_hw_calibrate(struct ath_hal *ah,
 			u8 rxchainmask,
 			bool longcal,
 			bool *isCalDone);
-int16_t ath9k_hw_getchan_noise(struct ath_hal *ah,
+s16 ath9k_hw_getchan_noise(struct ath_hal *ah,
 			       struct ath9k_channel *chan);
 void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid,
 			    u16 assocId);
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 5af7dfb..c5033f6 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -490,6 +490,122 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 		__func__, sc->sc_tx_chainmask, sc->sc_rx_chainmask);
 }
 
+/*******/
+/* ANI */
+/*******/
+
+/*
+ *  This routine performs the periodic noise floor calibration function
+ *  that is used to adjust and optimize the chip performance.  This
+ *  takes environmental changes (location, temperature) into account.
+ *  When the task is complete, it reschedules itself depending on the
+ *  appropriate interval that was calculated.
+ */
+
+static void ath_ani_calibrate(unsigned long data)
+{
+	struct ath_softc *sc;
+	struct ath_hal *ah;
+	bool longcal = false;
+	bool shortcal = false;
+	bool aniflag = false;
+	unsigned int timestamp = jiffies_to_msecs(jiffies);
+	u32 cal_interval;
+
+	sc = (struct ath_softc *)data;
+	ah = sc->sc_ah;
+
+	/*
+	* don't calibrate when we're scanning.
+	* we are most likely not on our home channel.
+	*/
+	if (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)
+		return;
+
+	/* Long calibration runs independently of short calibration. */
+	if ((timestamp - sc->sc_ani.sc_longcal_timer) >= ATH_LONG_CALINTERVAL) {
+		longcal = true;
+		DPRINTF(sc, ATH_DBG_ANI, "%s: longcal @%lu\n",
+			__func__, jiffies);
+		sc->sc_ani.sc_longcal_timer = timestamp;
+	}
+
+	/* Short calibration applies only while sc_caldone is false */
+	if (!sc->sc_ani.sc_caldone) {
+		if ((timestamp - sc->sc_ani.sc_shortcal_timer) >=
+		    ATH_SHORT_CALINTERVAL) {
+			shortcal = true;
+			DPRINTF(sc, ATH_DBG_ANI, "%s: shortcal @%lu\n",
+			       __func__, jiffies);
+			sc->sc_ani.sc_shortcal_timer = timestamp;
+			sc->sc_ani.sc_resetcal_timer = timestamp;
+		}
+	} else {
+		if ((timestamp - sc->sc_ani.sc_resetcal_timer) >=
+		    ATH_RESTART_CALINTERVAL) {
+			ath9k_hw_reset_calvalid(ah, ah->ah_curchan,
+						&sc->sc_ani.sc_caldone);
+			if (sc->sc_ani.sc_caldone)
+				sc->sc_ani.sc_resetcal_timer = timestamp;
+		}
+	}
+
+	/* Verify whether we must check ANI */
+	if ((timestamp - sc->sc_ani.sc_checkani_timer) >=
+	   ATH_ANI_POLLINTERVAL) {
+		aniflag = true;
+		sc->sc_ani.sc_checkani_timer = timestamp;
+	}
+
+	/* Skip all processing if there's nothing to do. */
+	if (longcal || shortcal || aniflag) {
+		/* Call ANI routine if necessary */
+		if (aniflag)
+			ath9k_hw_ani_monitor(ah, &sc->sc_halstats,
+					     ah->ah_curchan);
+
+		/* Perform calibration if necessary */
+		if (longcal || shortcal) {
+			bool iscaldone = false;
+
+			if (ath9k_hw_calibrate(ah, ah->ah_curchan,
+					       sc->sc_rx_chainmask, longcal,
+					       &iscaldone)) {
+				if (longcal)
+					sc->sc_ani.sc_noise_floor =
+						ath9k_hw_getchan_noise(ah,
+							       ah->ah_curchan);
+
+				DPRINTF(sc, ATH_DBG_ANI,
+					"%s: calibrate chan %u/%x nf: %d\n",
+					 __func__,
+					ah->ah_curchan->channel,
+					ah->ah_curchan->channelFlags,
+					sc->sc_ani.sc_noise_floor);
+			} else {
+				DPRINTF(sc, ATH_DBG_ANY,
+					"%s: calibrate chan %u/%x failed\n",
+					 __func__,
+					ah->ah_curchan->channel,
+					ah->ah_curchan->channelFlags);
+			}
+			sc->sc_ani.sc_caldone = iscaldone;
+		}
+	}
+
+	/*
+	* Set timer interval based on previous results.
+	* The interval must be the shortest necessary to satisfy ANI,
+	* short calibration and long calibration.
+	*/
+
+	cal_interval = ATH_ANI_POLLINTERVAL;
+	if (!sc->sc_ani.sc_caldone)
+		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
+
+	mod_timer(&sc->sc_ani.timer, jiffies + msecs_to_jiffies(cal_interval));
+}
+
 /******************/
 /* VAP management */
 /******************/
@@ -676,12 +792,6 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->sc_imask |= ATH9K_INT_CST;
 
-	/* Note: We disable MIB interrupts for now as we don't yet
-	 * handle processing ANI, otherwise you will get an interrupt
-	 * storm after about 7 hours of usage making the system unusable
-	 * with huge latency. Once we do have ANI processing included
-	 * we can re-enable this interrupt. */
-#if 0
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
@@ -690,7 +800,6 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
 	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
-#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
@@ -991,6 +1100,10 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	}
 	sc->sc_ah = ah;
 
+	/* Initializes the noise floor to a reasonable default value.
+	 * Later on this will be updated during ANI processing. */
+	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
+
 	/* Get the hardware key cache size. */
 	sc->sc_keymax = ah->ah_caps.keycache_size;
 	if (sc->sc_keymax > ATH_KEYMAX) {
@@ -1098,6 +1211,8 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
+	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
+
 	sc->sc_rc = ath_rate_attach(ah);
 	if (sc->sc_rc == NULL) {
 		error = -EIO;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 5b4f1c4..cb3e61e 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -800,6 +800,28 @@ void ath_slow_ant_div(struct ath_antdiv *antdiv,
 		      struct ath_rx_status *rx_stats);
 void ath_setdefantenna(void *sc, u32 antenna);
 
+/*******/
+/* ANI */
+/*******/
+
+/* ANI values for STA only.
+   FIXME: Add appropriate values for AP later */
+
+#define ATH_ANI_POLLINTERVAL    100     /* 100 milliseconds between ANI poll */
+#define ATH_SHORT_CALINTERVAL   1000    /* 1 second between calibrations */
+#define ATH_LONG_CALINTERVAL    30000   /* 30 seconds between calibrations */
+#define ATH_RESTART_CALINTERVAL 1200000 /* 20 minutes between calibrations */
+
+struct ath_ani {
+	bool sc_caldone;
+	int16_t sc_noise_floor;
+	unsigned int sc_longcal_timer;
+	unsigned int sc_shortcal_timer;
+	unsigned int sc_resetcal_timer;
+	unsigned int sc_checkani_timer;
+	struct timer_list timer;
+};
+
 /********************/
 /*   LED Control    */
 /********************/
@@ -1028,6 +1050,9 @@ struct ath_softc {
 
 	/* Rfkill */
 	struct ath_rfkill rf_kill;
+
+	/* ANI */
+	struct ath_ani sc_ani;
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 272c758..62e44a0 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -329,7 +329,7 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 	ah->ah_config.ofdm_trig_high = 500;
 	ah->ah_config.cck_trig_high = 200;
 	ah->ah_config.cck_trig_low = 100;
-	ah->ah_config.enable_ani = 0;
+	ah->ah_config.enable_ani = 1;
 	ah->ah_config.noise_immunity_level = 4;
 	ah->ah_config.ofdm_weaksignal_det = 1;
 	ah->ah_config.cck_weaksignal_thr = 0;
@@ -8405,23 +8405,48 @@ u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags)
 	}
 }
 
-int16_t
+/* We can tune this as we go by monitoring really low values */
+#define ATH9K_NF_TOO_LOW	-60
+
+/* AR5416 may return very high value (like -31 dBm), in those cases the nf
+ * is incorrect and we should use the static NF value. Later we can try to
+ * find out why they are reporting these values */
+static bool ath9k_hw_nf_in_range(struct ath_hal *ah, s16 nf)
+{
+	if (nf > ATH9K_NF_TOO_LOW) {
+		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
+			 "%s: noise floor value detected (%d) is "
+			"lower than what we think is a "
+			"reasonable value (%d)\n",
+			 __func__, nf, ATH9K_NF_TOO_LOW);
+		return false;
+	}
+	return true;
+}
+
+s16
 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	struct ath9k_channel *ichan;
+	s16 nf;
 
 	ichan = ath9k_regd_check_channel(ah, chan);
 	if (ichan == NULL) {
 		DPRINTF(ah->ah_sc, ATH_DBG_NF_CAL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
-		return 0;
+		return ATH_DEFAULT_NOISE_FLOOR;
 	}
 	if (ichan->rawNoiseFloor == 0) {
 		enum wireless_mode mode = ath9k_hw_chan2wmode(ah, chan);
-		return NOISE_FLOOR[mode];
+		nf = NOISE_FLOOR[mode];
 	} else
-		return ichan->rawNoiseFloor;
+		nf = ichan->rawNoiseFloor;
+
+	if (!ath9k_hw_nf_in_range(ah, nf))
+		nf = ATH_DEFAULT_NOISE_FLOOR;
+
+	return nf;
 }
 
 bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u32 setting)
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2caba44..7472699 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -274,10 +274,12 @@ static void ath9k_rx_prepare(struct ath_softc *sc,
 	rx_status->mactime = status->tsf;
 	rx_status->band = curchan->band;
 	rx_status->freq =  curchan->center_freq;
-	rx_status->noise = ATH_DEFAULT_NOISE_FLOOR;
+	rx_status->noise = sc->sc_ani.sc_noise_floor;
 	rx_status->signal = rx_status->noise + status->rssi;
 	rx_status->rate_idx = ath_rate2idx(sc, (status->rateKbps / 100));
 	rx_status->antenna = status->antenna;
+
+	/* XXX Fix me, 64 cannot be the max rssi value, rigure it out */
 	rx_status->qual = status->rssi * 100 / 64;
 
 	if (status->flags & ATH_RX_MIC_ERROR)
@@ -427,6 +429,11 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_rate_newstate(sc, avp);
 		/* Update ratectrl about the new state */
 		ath_rc_node_update(hw, avp->rc_node);
+
+		/* Start ANI */
+		mod_timer(&sc->sc_ani.timer,
+			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: Bss Info DISSOC\n", __func__);
@@ -1173,6 +1180,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		return error;
 	}
 
+	if (conf->type == NL80211_IFTYPE_AP) {
+		/* TODO: is this a suitable place to start ANI for AP mode? */
+		/* Start ANI */
+		mod_timer(&sc->sc_ani.timer,
+			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+	}
+
 	return 0;
 }
 
@@ -1195,6 +1209,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 #ifdef CONFIG_SLOW_ANT_DIV
 	ath_slow_ant_div_stop(&sc->sc_antdiv);
 #endif
+	/* Stop ANI */
+	del_timer_sync(&sc->sc_ani.timer);
 
 	/* Update ratectrl */
 	ath_rate_newstate(sc, avp);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index f4be5d1..4983402 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -999,20 +999,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				rx_status.flags |= ATH_RX_SHORT_GI;
 		}
 
-		/* sc->sc_noise_floor is only available when the station
+		/* sc_noise_floor is only available when the station
 		   attaches to an AP, so we use a default value
 		   if we are not yet attached. */
-
-		/* XXX we should use either sc->sc_noise_floor or
-		 * ath_hal_getChanNoise(ah, &sc->sc_curchan)
-		 * to calculate the noise floor.
-		 * However, the value returned by ath_hal_getChanNoise
-		 * seems to be incorrect (-31dBm on the last test),
-		 * so we will use a hard-coded value until we
-		 * figure out what is going on.
-		 */
 		rx_status.abs_rssi =
-			ds->ds_rxstat.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
+			ds->ds_rxstat.rs_rssi + sc->sc_ani.sc_noise_floor;
 
 		pci_dma_sync_single_for_cpu(sc->pdev,
 					    bf->bf_buf_addr,
-- 
1.5.6.rc2.15.g457bb.dirty

