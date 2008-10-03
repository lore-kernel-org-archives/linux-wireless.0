Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42654 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYJDEWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 00:22:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 21:22:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, Steven Noonan <steven@uplinklabs.net>,
	<linville@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: [RFC] ath9k: enable ANI to help with noisy environments
Date: Fri, 3 Oct 2008 14:22:06 -0700
Message-ID: <1223068926-14318-1-git-send-email-lrodriguez@atheros.com> (sfid-20081004_062236_062135_7037CE65)
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

This patch is for 2.6.27, I don't really expect it to be merged
but I can see distributions picking this up as its very useful
to enhance throughput in noisy environments. Your call, of course.

Steven, can you try this patch on your system. This re-enables
the MIB interrupts but also makes use of ANI. This is the correct
solution to the interrupt storm.

 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath9k/core.c  |  129 ++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath9k/core.h  |   25 +++++++
 drivers/net/wireless/ath9k/hw.c    |   35 ++++++++--
 drivers/net/wireless/ath9k/main.c  |   17 +++++-
 drivers/net/wireless/ath9k/recv.c  |   13 +---
 6 files changed, 196 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d1b0fba..81d1b28 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -871,7 +871,7 @@ bool ath9k_hw_calibrate(struct ath_hal *ah,
 			u8 rxchainmask,
 			bool longcal,
 			bool *isCalDone);
-int16_t ath9k_hw_getchan_noise(struct ath_hal *ah,
+s16 ath9k_hw_getchan_noise(struct ath_hal *ah,
 			       struct ath9k_channel *chan);
 void ath9k_hw_write_associd(struct ath_hal *ah, const u8 *bssid,
 			    u16 assocId);
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 87e37bc..ffcd7cf 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -548,6 +548,122 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
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
+	if (sc->sc_scanning)
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
@@ -795,12 +911,6 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
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
@@ -808,7 +918,6 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
-#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
@@ -1131,6 +1240,10 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	}
 	sc->sc_ah = ah;
 
+	/* Initializes the noise floor to a reasonable default value.
+	 * Later on this will be updated during ANI processing. */
+	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
+
 	/* Get the chipset-specific aggr limit. */
 	sc->sc_rtsaggrlimit = ah->ah_caps.rts_aggr_limit;
 
@@ -1243,6 +1356,8 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
+	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
+
 	sc->sc_rc = ath_rate_attach(ah);
 	if (sc->sc_rc == NULL) {
 		error = EIO;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 88f4cc3..76a1ec9 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -829,6 +829,28 @@ void ath_slow_ant_div(struct ath_antdiv *antdiv,
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
 /* Main driver core */
 /********************/
@@ -1023,6 +1045,9 @@ struct ath_softc {
 	spinlock_t sc_txbuflock;
 	spinlock_t sc_resetlock;
 	spinlock_t node_lock;
+
+	/* ANI */
+	struct ath_ani sc_ani;
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 6dbfed0..4080973 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -352,7 +352,7 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 	ah->ah_config.ofdm_trig_high = 500;
 	ah->ah_config.cck_trig_high = 200;
 	ah->ah_config.cck_trig_low = 100;
-	ah->ah_config.enable_ani = 0;
+	ah->ah_config.enable_ani = 1;
 	ah->ah_config.noise_immunity_level = 4;
 	ah->ah_config.ofdm_weaksignal_det = 1;
 	ah->ah_config.cck_weaksignal_thr = 0;
@@ -8439,23 +8439,48 @@ u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags)
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
index acebdf1..41e98ed 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -281,10 +281,12 @@ static void ath9k_rx_prepare(struct ath_softc *sc,
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
@@ -458,6 +460,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
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
 
@@ -480,6 +489,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 #ifdef CONFIG_SLOW_ANT_DIV
 	ath_slow_ant_div_stop(&sc->sc_antdiv);
 #endif
+	/* Stop ANI */
+	del_timer_sync(&sc->sc_ani.timer);
 
 	/* Update ratectrl */
 	ath_rate_newstate(sc, avp);
@@ -888,6 +899,10 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_rate_newstate(sc, avp);
 		/* Update ratectrl about the new state */
 		ath_rc_node_update(hw, avp->rc_node);
+
+		/* Start ANI */
+		mod_timer(&sc->sc_ani.timer,
+			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG,
 		"%s: Bss Info DISSOC\n", __func__);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 20ddb7a..4010378 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -994,20 +994,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
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
1.5.6.3

