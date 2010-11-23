Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46096 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0KWTjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:39:39 -0500
Received: by ewy5 with SMTP id 5so2678674ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:39:37 -0800 (PST)
Date: Tue, 23 Nov 2010 21:39:28 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 23/30] ath5k: Support synth-only channel change for
 AR2413/AR5413
Message-ID: <20101123193928.GW4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add synth-only channel change for AR2413/5413. When we call
 ath5k_reset with a channel ath5k_hw_reset will first try to
 set channel on PHY while PHY is running instead of doing a normal
 full reset. To do this phy_init has to change to implement this
 functionality.

 * Clean up change_channel flag, what it really did was skip PCU
 registers when setting initvals. This is done because on reset
 PCU registers are not affected (except the registers we set
 in pcu init and -due to hw problems- TSF). Use a new skip_pcu
 flag that's not misleading instead. In the future we might use
 that to also skip PCU reset and save us the TSF etc problems
 (needs testing because standard practice is to reset everything).

 * Use fast channel change only when setting channel, and set skip_pcu
 to false only on init. When we reset the card due to DMA or PHY
 problems skip pcu but never do a fast channel change.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    4 +-
 drivers/net/wireless/ath/ath5k/base.c  |   17 ++-
 drivers/net/wireless/ath/ath5k/phy.c   |   64 ++++++--
 drivers/net/wireless/ath/ath5k/reset.c |  271 +++++++++++++++++++-------------
 4 files changed, 220 insertions(+), 136 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index e258830..385b919 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1183,7 +1183,7 @@ void ath5k_unregister_leds(struct ath5k_softc *sc);
 int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
 int ath5k_hw_on_hold(struct ath5k_hw *ah);
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
-		   struct ieee80211_channel *channel, bool change_channel);
+	   struct ieee80211_channel *channel, bool fast, bool skip_pcu);
 int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 			      bool is_set);
 /* Power management functions */
@@ -1324,7 +1324,7 @@ void ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode);
 int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
 /* Init function */
 int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-						u8 mode, u8 ee_mode, u8 freq);
+				u8 mode, u8 ee_mode, u8 freq, bool fast);
 
 /*
  * Functions used internaly
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 526d8bc..33cd1bc 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -80,7 +80,8 @@ MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
 
-static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
+static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+								bool skip_pcu);
 static int ath5k_beacon_update(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif);
 static void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
@@ -496,7 +497,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	 * hardware at the new frequency, and then re-enable
 	 * the relevant bits of the h/w.
 	 */
-	return ath5k_reset(sc, chan);
+	return ath5k_reset(sc, chan, true);
 }
 
 static void
@@ -2327,7 +2328,7 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
 			  "TX queues stuck, resetting\n");
-		ath5k_reset(sc, sc->curchan);
+		ath5k_reset(sc, NULL, true);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
@@ -2407,7 +2408,7 @@ ath5k_init(struct ath5k_softc *sc)
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
 		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
 
-	ret = ath5k_reset(sc, NULL);
+	ret = ath5k_reset(sc, NULL, false);
 	if (ret)
 		goto done;
 
@@ -2506,7 +2507,8 @@ ath5k_stop_hw(struct ath5k_softc *sc)
  * This should be called with sc->lock.
  */
 static int
-ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
+ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+							bool skip_pcu)
 {
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
@@ -2523,7 +2525,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		sc->curchan = chan;
 		sc->curband = &sc->sbands[chan->band];
 	}
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
+	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL,
+								skip_pcu);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
@@ -2569,7 +2572,7 @@ static void ath5k_reset_work(struct work_struct *work)
 		reset_work);
 
 	mutex_lock(&sc->lock);
-	ath5k_reset(sc, sc->curchan);
+	ath5k_reset(sc, NULL, true);
 	mutex_unlock(&sc->lock);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 9392320..1b6fcf9 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3223,7 +3223,7 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 \*************/
 
 int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
-						u8 mode, u8 ee_mode, u8 freq)
+				u8 mode, u8 ee_mode, u8 freq, bool fast)
 {
 	struct ieee80211_channel *curr_channel;
 	int ret, i;
@@ -3232,11 +3232,37 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	ret = 0;
 
 	/*
+	 * Sanity check for fast flag
+	 * Don't try fast channel change when changing modulation
+	 * mode/band. We check for chip compatibility on
+	 * ath5k_hw_reset.
+	 */
+	curr_channel = ah->ah_current_channel;
+	if (fast && (channel->hw_value != curr_channel->hw_value))
+		return -EINVAL;
+
+	/*
+	 * On fast channel change we only set the synth parameters
+	 * while PHY is running, enable calibration and skip the rest.
+	 */
+	if (fast) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_RFBUS_REQ,
+				    AR5K_PHY_RFBUS_REQ_REQUEST);
+		for (i = 0; i < 100; i++) {
+			if (ath5k_hw_reg_read(ah, AR5K_PHY_RFBUS_GRANT))
+				break;
+			udelay(5);
+		}
+		/* Failed */
+		if (i >= 100)
+			return -EIO;
+	}
+
+	/*
 	 * If we don't change channel/mode skip
 	 * tx powertable calculation and use the
 	 * cached one.
 	 */
-	curr_channel = ah->ah_current_channel;
 	if ((channel->hw_value == curr_channel->hw_value) &&
 	(channel->center_freq == curr_channel->center_freq))
 		fast_txp = true;
@@ -3262,7 +3288,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	 * any settings (5210 also only supports
 	 * a/aturbo modes)
 	 */
-	if (ah->ah_version != AR5K_AR5210) {
+	if ((ah->ah_version != AR5K_AR5210) && !fast) {
 
 		/*
 		 * Write initial RF gain settings
@@ -3308,7 +3334,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 				    AR5K_TXCFG_B_MODE);
 		}
 
-	} else {
+	} else if (ah->ah_version == AR5K_AR5210) {
 		mdelay(1);
 		/* Disable phy and wait */
 		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
@@ -3345,18 +3371,26 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		mdelay(1);
 	}
 
-	/*
-	 * Perform ADC test to see if baseband is ready
-	 * Set TX hold and check ADC test register
-	 */
-	phy_tst1 = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
-	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
-	for (i = 0; i <= 20; i++) {
-		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
-			break;
-		udelay(200);
+	if (fast)
+		/*
+		 * Release RF Bus grant
+		 */
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_RFBUS_REQ,
+				    AR5K_PHY_RFBUS_REQ_REQUEST);
+	else {
+		/*
+		 * Perform ADC test to see if baseband is ready
+		 * Set tx hold and check adc test register
+		 */
+		phy_tst1 = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
+		ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
+		for (i = 0; i <= 20; i++) {
+			if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
+				break;
+			udelay(200);
+		}
+		ath5k_hw_reg_write(ah, phy_tst1, AR5K_PHY_TST1);
 	}
-	ath5k_hw_reg_write(ah, phy_tst1, AR5K_PHY_TST1);
 
 	/*
 	 * Start automatic gain control calibration
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index ef57bce..f92f7bb 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -938,7 +938,7 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 \*********************/
 
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
-	struct ieee80211_channel *channel, bool change_channel)
+		struct ieee80211_channel *channel, bool fast, bool skip_pcu)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 s_seq[10], s_led[3], staid1_flags, tsf_up, tsf_lo;
@@ -952,6 +952,20 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	freq = 0;
 	mode = 0;
 
+	/*
+	 * Sanity check for fast flag
+	 * Fast channel change only available
+	 * on AR2413/AR5413.
+	 */
+	if (fast && (ah->ah_radio != AR5K_RF2413) &&
+	(ah->ah_radio != AR5K_RF5413))
+		fast = 0;
+
+	/* Disable sleep clock operation
+	 * to avoid register access delay on certain
+	 * PHY registers */
+	if (ah->ah_version == AR5K_AR5212)
+		ath5k_hw_set_sleep_clock(ah, false);
 
 	/*
 	 * Stop PCU
@@ -964,111 +978,137 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * Mote: If DMA didn't stop continue
 	 * since only a reset will fix it.
 	 */
-	ath5k_hw_dma_stop(ah);
+	ret = ath5k_hw_dma_stop(ah);
+
+	/* RF Bus grant won't work if we have pending
+	 * frames */
+	if (ret && fast) {
+		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+			"DMA didn't stop, falling back to normal reset\n");
+		fast = 0;
+		/* Non fatal, just continue with
+		 * normal reset */
+		ret = 0;
+	}
+
+	switch (channel->hw_value & CHANNEL_MODES) {
+	case CHANNEL_A:
+		mode = AR5K_MODE_11A;
+		freq = AR5K_INI_RFGAIN_5GHZ;
+		ee_mode = AR5K_EEPROM_MODE_11A;
+		break;
+	case CHANNEL_G:
+
+		if (ah->ah_version <= AR5K_AR5211) {
+			ATH5K_ERR(ah->ah_sc,
+				"G mode not available on 5210/5211");
+			return -EINVAL;
+		}
+
+		mode = AR5K_MODE_11G;
+		freq = AR5K_INI_RFGAIN_2GHZ;
+		ee_mode = AR5K_EEPROM_MODE_11G;
+		break;
+	case CHANNEL_B:
+
+		if (ah->ah_version < AR5K_AR5211) {
+			ATH5K_ERR(ah->ah_sc,
+				"B mode not available on 5210");
+			return -EINVAL;
+		}
+
+		mode = AR5K_MODE_11B;
+		freq = AR5K_INI_RFGAIN_2GHZ;
+		ee_mode = AR5K_EEPROM_MODE_11B;
+		break;
+	case CHANNEL_T:
+		mode = AR5K_MODE_11A_TURBO;
+		freq = AR5K_INI_RFGAIN_5GHZ;
+		ee_mode = AR5K_EEPROM_MODE_11A;
+		break;
+	case CHANNEL_TG:
+		if (ah->ah_version == AR5K_AR5211) {
+			ATH5K_ERR(ah->ah_sc,
+				"TurboG mode not available on 5211");
+			return -EINVAL;
+		}
+		mode = AR5K_MODE_11G_TURBO;
+		freq = AR5K_INI_RFGAIN_2GHZ;
+		ee_mode = AR5K_EEPROM_MODE_11G;
+		break;
+	case CHANNEL_XR:
+		if (ah->ah_version == AR5K_AR5211) {
+			ATH5K_ERR(ah->ah_sc,
+				"XR mode not available on 5211");
+			return -EINVAL;
+		}
+		mode = AR5K_MODE_XR;
+		freq = AR5K_INI_RFGAIN_5GHZ;
+		ee_mode = AR5K_EEPROM_MODE_11A;
+		break;
+	default:
+		ATH5K_ERR(ah->ah_sc,
+			"invalid channel: %d\n", channel->center_freq);
+		return -EINVAL;
+	}
+
+	/*
+	 * If driver requested fast channel change and DMA has stopped
+	 * go on. If it fails continue with a normal reset.
+	 */
+	if (fast) {
+		ret = ath5k_hw_phy_init(ah, channel, mode,
+					ee_mode, freq, true);
+		if (ret) {
+			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+				"fast chan change failed, falling back to normal reset\n");
+			/* Non fatal, can happen eg.
+			 * on mode change */
+			ret = 0;
+		} else
+			return 0;
+	}
 
 	/*
 	 * Save some registers before a reset
 	 */
-	/*DCU/Antenna selection not available on 5210*/
 	if (ah->ah_version != AR5K_AR5210) {
+		/*
+		 * Save frame sequence count
+		 * For revs. after Oahu, only save
+		 * seq num for DCU 0 (Global seq num)
+		 */
+		if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
 
-		switch (channel->hw_value & CHANNEL_MODES) {
-		case CHANNEL_A:
-			mode = AR5K_MODE_11A;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		case CHANNEL_G:
-			mode = AR5K_MODE_11G;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11G;
-			break;
-		case CHANNEL_B:
-			mode = AR5K_MODE_11B;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11B;
-			break;
-		case CHANNEL_T:
-			mode = AR5K_MODE_11A_TURBO;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		case CHANNEL_TG:
-			if (ah->ah_version == AR5K_AR5211) {
-				ATH5K_ERR(ah->ah_sc,
-					"TurboG mode not available on 5211");
-				return -EINVAL;
-			}
-			mode = AR5K_MODE_11G_TURBO;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11G;
-			break;
-		case CHANNEL_XR:
-			if (ah->ah_version == AR5K_AR5211) {
-				ATH5K_ERR(ah->ah_sc,
-					"XR mode not available on 5211");
-				return -EINVAL;
-			}
-			mode = AR5K_MODE_XR;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		default:
-			ATH5K_ERR(ah->ah_sc,
-				"invalid channel: %d\n", channel->center_freq);
-			return -EINVAL;
-		}
-
-		if (change_channel) {
-			/*
-			 * Save frame sequence count
-			 * For revs. after Oahu, only save
-			 * seq num for DCU 0 (Global seq num)
-			 */
-			if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
-
-				for (i = 0; i < 10; i++)
-					s_seq[i] = ath5k_hw_reg_read(ah,
-						AR5K_QUEUE_DCU_SEQNUM(i));
+			for (i = 0; i < 10; i++)
+				s_seq[i] = ath5k_hw_reg_read(ah,
+					AR5K_QUEUE_DCU_SEQNUM(i));
 
-			} else {
-				s_seq[0] = ath5k_hw_reg_read(ah,
-						AR5K_QUEUE_DCU_SEQNUM(0));
-			}
-
-			/* TSF accelerates on AR5211 during reset
-			 * As a workaround save it here and restore
-			 * it later so that it's back in time after
-			 * reset. This way it'll get re-synced on the
-			 * next beacon without breaking ad-hoc.
-			 *
-			 * On AR5212 TSF is almost preserved across a
-			 * reset so it stays back in time anyway and
-			 * we don't have to save/restore it.
-			 *
-			 * XXX: Since this breaks power saving we have
-			 * to disable power saving until we receive the
-			 * next beacon, so we can resync beacon timers */
-			if (ah->ah_version == AR5K_AR5211) {
-				tsf_up = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
-				tsf_lo = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
-			}
+		} else {
+			s_seq[0] = ath5k_hw_reg_read(ah,
+					AR5K_QUEUE_DCU_SEQNUM(0));
 		}
 
-		if (ah->ah_version == AR5K_AR5212) {
-			/* Restore normal 32/40MHz clock operation
-			 * to avoid register access delay on certain
-			 * PHY registers */
-			ath5k_hw_set_sleep_clock(ah, false);
-
-			/* Since we are going to write rf buffer
-			 * check if we have any pending gain_F
-			 * optimization settings */
-			if (change_channel && ah->ah_rf_banks != NULL)
-				ath5k_hw_gainf_calibrate(ah);
+		/* TSF accelerates on AR5211 during reset
+		 * As a workaround save it here and restore
+		 * it later so that it's back in time after
+		 * reset. This way it'll get re-synced on the
+		 * next beacon without breaking ad-hoc.
+		 *
+		 * On AR5212 TSF is almost preserved across a
+		 * reset so it stays back in time anyway and
+		 * we don't have to save/restore it.
+		 *
+		 * XXX: Since this breaks power saving we have
+		 * to disable power saving until we receive the
+		 * next beacon, so we can resync beacon timers */
+		if (ah->ah_version == AR5K_AR5211) {
+			tsf_up = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
+			tsf_lo = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
 		}
 	}
 
+
 	/*GPIOs*/
 	s_led[0] = ath5k_hw_reg_read(ah, AR5K_PCICFG) &
 					AR5K_PCICFG_LEDSTATE;
@@ -1085,6 +1125,17 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			AR5K_STA_ID1_BASE_RATE_11B |
 			AR5K_STA_ID1_SELFGEN_DEF_ANT);
 
+	/*
+	 * Since we are going to write rf buffer
+	 * check if we have any pending gain_F
+	 * optimization settings
+	 */
+	if (ah->ah_version == AR5K_AR5212 &&
+	(ah->ah_radio <= AR5K_RF5112)) {
+		if (!fast && ah->ah_rf_banks != NULL)
+				ath5k_hw_gainf_calibrate(ah);
+	}
+
 	/* Wakeup the device */
 	ret = ath5k_hw_nic_wakeup(ah, channel->hw_value, false);
 	if (ret)
@@ -1098,7 +1149,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 							AR5K_PHY(0));
 
 	/* Write initial settings */
-	ret = ath5k_hw_write_initvals(ah, mode, change_channel);
+	ret = ath5k_hw_write_initvals(ah, mode, skip_pcu);
 	if (ret)
 		return ret;
 
@@ -1120,24 +1171,20 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * Restore saved values
 	 */
 
-	/*DCU/Antenna selection not available on 5210*/
+	/* Seqnum, TSF */
 	if (ah->ah_version != AR5K_AR5210) {
+		if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
+			for (i = 0; i < 10; i++)
+				ath5k_hw_reg_write(ah, s_seq[i],
+					AR5K_QUEUE_DCU_SEQNUM(i));
+		} else {
+			ath5k_hw_reg_write(ah, s_seq[0],
+				AR5K_QUEUE_DCU_SEQNUM(0));
+		}
 
-		if (change_channel) {
-			if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
-				for (i = 0; i < 10; i++)
-					ath5k_hw_reg_write(ah, s_seq[i],
-						AR5K_QUEUE_DCU_SEQNUM(i));
-			} else {
-				ath5k_hw_reg_write(ah, s_seq[0],
-					AR5K_QUEUE_DCU_SEQNUM(0));
-			}
-
-
-			if (ah->ah_version == AR5K_AR5211) {
-				ath5k_hw_reg_write(ah, tsf_up, AR5K_TSF_U32);
-				ath5k_hw_reg_write(ah, tsf_lo, AR5K_TSF_L32);
-			}
+		if (ah->ah_version == AR5K_AR5211) {
+			ath5k_hw_reg_write(ah, tsf_up, AR5K_TSF_U32);
+			ath5k_hw_reg_write(ah, tsf_lo, AR5K_TSF_L32);
 		}
 	}
 
@@ -1165,7 +1212,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/*
 	 * Initialize PHY
 	 */
-	ret = ath5k_hw_phy_init(ah, channel, mode, ee_mode, freq);
+	ret = ath5k_hw_phy_init(ah, channel, mode, ee_mode, freq, false);
 	if (ret) {
 		ATH5K_ERR(ah->ah_sc,
 			"failed to initialize PHY (%i) !\n", ret);
