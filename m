Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55287 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab1H2Kmk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 06:42:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: [PATCH v5 2/3] ath9k: merge reset related functions
Date: Mon, 29 Aug 2011 12:42:33 +0200
Message-Id: <1314614554-3701-2-git-send-email-nbd@openwrt.org> (sfid-20110829_124245_772608_E6F37C11)
In-Reply-To: <1314614554-3701-1-git-send-email-nbd@openwrt.org>
References: <1314614554-3701-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reduces unnecessary code duplication

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |  257 +++++++++++++--------------------
 1 files changed, 100 insertions(+), 157 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 085ec20..f11b2c0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -212,83 +212,46 @@ static int ath_update_survey_stats(struct ath_softc *sc)
 	return ret;
 }
 
-/*
- * Set/change channels.  If the channel is really being changed, it's done
- * by reseting the chip.  To accomplish this we must first cleanup any pending
- * DMA, then restart stuff.
-*/
-static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
-		    struct ath9k_channel *hchan)
+static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
-	bool fastcc = true, stopped;
-	struct ieee80211_channel *channel = hw->conf.channel;
-	struct ath9k_hw_cal_data *caldata = NULL;
-	int r;
+	bool ret;
 
-	if (sc->sc_flags & SC_OP_INVALID)
-		return -EIO;
+	ieee80211_stop_queues(sc->hw);
 
 	sc->hw_busy_count = 0;
-
 	del_timer_sync(&common->ani.timer);
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
-	ath9k_ps_wakeup(sc);
-
-	spin_lock_bh(&sc->sc_pcu_lock);
-
-	/*
-	 * This is only performed if the channel settings have
-	 * actually changed.
-	 *
-	 * To switch channels clear any pending DMA operations;
-	 * wait long enough for the RX fifo to drain, reset the
-	 * hardware at the new frequency, and then re-enable
-	 * the relevant bits of the h/w.
-	 */
 	ath9k_hw_disable_interrupts(ah);
-	stopped = ath_drain_all_txq(sc, false);
 
-	if (!ath_stoprecv(sc))
-		stopped = false;
-
-	if (!ath9k_hw_check_alive(ah))
-		stopped = false;
-
-	/* XXX: do not flush receive queue here. We don't want
-	 * to flush data frames already in queue because of
-	 * changing channel. */
+	ret = ath_drain_all_txq(sc, retry_tx);
 
-	if (!stopped || !(sc->sc_flags & SC_OP_OFFCHANNEL))
-		fastcc = false;
+	if (!ath_stoprecv(sc))
+		ret = false;
 
-	if (!(sc->sc_flags & SC_OP_OFFCHANNEL))
-		caldata = &sc->caldata;
+	if (!flush) {
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+			ath_rx_tasklet(sc, 0, true);
+		ath_rx_tasklet(sc, 0, false);
+	} else {
+		ath_flushrecv(sc);
+	}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"(%u MHz) -> (%u MHz), conf_is_ht40: %d fastcc: %d\n",
-		sc->sc_ah->curchan->channel,
-		channel->center_freq, conf_is_ht40(conf),
-		fastcc);
+	return ret;
+}
 
-	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
-	if (r) {
-		ath_err(common,
-			"Unable to reset channel (%u MHz), reset status %d\n",
-			channel->center_freq, r);
-		goto ps_restore;
-	}
+static bool ath_complete_reset(struct ath_softc *sc, bool start)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
-		r = -EIO;
-		goto ps_restore;
+		return false;
 	}
 
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
@@ -296,21 +259,89 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 	ath9k_hw_enable_interrupts(ah);
 
-	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
+	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) && start) {
 		if (sc->sc_flags & SC_OP_BEACONS)
 			ath_set_beacon(sc);
+
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
 		if (!common->disable_ani)
 			ath_start_ani(common);
 	}
 
- ps_restore:
-	ieee80211_wake_queues(hw);
+	ieee80211_wake_queues(sc->hw);
+
+	return true;
+}
+
+static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
+			      bool retry_tx)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_cal_data *caldata = NULL;
+	bool fastcc = true;
+	bool flush = false;
+	int r;
+
+	if (!(sc->sc_flags & SC_OP_OFFCHANNEL)) {
+		fastcc = false;
+		caldata = &sc->caldata;
+	}
+
+	if (!hchan) {
+		fastcc = false;
+		flush = true;
+		hchan = ah->curchan;
+	}
+
+	if (fastcc && !ath9k_hw_check_alive(ah))
+		fastcc = false;
+
+	if (!ath_prepare_reset(sc, retry_tx, flush))
+		fastcc = false;
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Reset to %u MHz, HT40: %d fastcc: %d\n",
+		hchan->channel, !!(hchan->channelFlags & (CHANNEL_HT40MINUS |
+							  CHANNEL_HT40PLUS)),
+		fastcc);
+
+	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
+	if (r) {
+		ath_err(common,
+			"Unable to reset channel, reset status %d\n", r);
+		return r;
+	}
+
+	if (!ath_complete_reset(sc, true))
+		return -EIO;
+
+	return 0;
+}
+
 
+/*
+ * Set/change channels.  If the channel is really being changed, it's done
+ * by reseting the chip.  To accomplish this we must first cleanup any pending
+ * DMA, then restart stuff.
+*/
+static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
+		    struct ath9k_channel *hchan)
+{
+	int r;
+
+	if (sc->sc_flags & SC_OP_INVALID)
+		return -EIO;
+
+	ath9k_ps_wakeup(sc);
+
+	spin_lock_bh(&sc->sc_pcu_lock);
+	r = ath_reset_internal(sc, hchan, false);
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_ps_restore(sc);
+
 	return r;
 }
 
@@ -893,28 +924,13 @@ static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 			channel->center_freq, r);
 	}
 
-	ath9k_cmn_update_txpow(ah, sc->curtxpow,
-			       sc->config.txpowlimit, &sc->curtxpow);
-	if (ath_startrecv(sc) != 0) {
-		ath_err(common, "Unable to restart recv logic\n");
-		goto out;
-	}
-	if (sc->sc_flags & SC_OP_BEACONS)
-		ath_set_beacon(sc);	/* restart beacons */
-
-	/* Re-Enable  interrupts */
-	ath9k_hw_set_interrupts(ah, ah->imask);
-	ath9k_hw_enable_interrupts(ah);
+	ath_complete_reset(sc, true);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(ah, ah->led_pin,
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
-	ieee80211_wake_queues(hw);
-	ieee80211_queue_delayed_work(hw, &sc->hw_pll_work, HZ/2);
-
-out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_ps_restore(sc);
@@ -927,12 +943,8 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	int r;
 
 	ath9k_ps_wakeup(sc);
-	cancel_delayed_work_sync(&sc->hw_pll_work);
-
 	spin_lock_bh(&sc->sc_pcu_lock);
 
-	ieee80211_stop_queues(hw);
-
 	/*
 	 * Keep the LED on when the radio is disabled
 	 * during idle unassociated state.
@@ -942,13 +954,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
-	/* Disable interrupts */
-	ath9k_hw_disable_interrupts(ah);
-
-	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
-
-	ath_stoprecv(sc);		/* turn off frame recv */
-	ath_flushrecv(sc);		/* flush recv queue */
+	ath_prepare_reset(sc, false, true);
 
 	if (!ah->curchan)
 		ah->curchan = ath9k_cmn_get_curchannel(hw, ah);
@@ -970,48 +976,11 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
-	sc->hw_busy_count = 0;
-
-	/* Stop ANI */
-
-	del_timer_sync(&common->ani.timer);
-
 	ath9k_ps_wakeup(sc);
 
-	ieee80211_stop_queues(hw);
-
-	ath9k_hw_disable_interrupts(ah);
-	ath_drain_all_txq(sc, retry_tx);
-
-	ath_stoprecv(sc);
-	ath_flushrecv(sc);
-
-	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
-	if (r)
-		ath_err(common,
-			"Unable to reset hardware; reset status %d\n", r);
-
-	if (ath_startrecv(sc) != 0)
-		ath_err(common, "Unable to start recv logic\n");
-
-	/*
-	 * We may be doing a reset in response to a request
-	 * that changes the channel so update any state that
-	 * might change as a result.
-	 */
-	ath9k_cmn_update_txpow(ah, sc->curtxpow,
-			       sc->config.txpowlimit, &sc->curtxpow);
-
-	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
-		ath_set_beacon(sc);	/* restart beacons */
-
-	ath9k_hw_set_interrupts(ah, ah->imask);
-	ath9k_hw_enable_interrupts(ah);
+	r = ath_reset_internal(sc, NULL, retry_tx);
 
 	if (retry_tx) {
 		int i;
@@ -1024,12 +993,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		}
 	}
 
-	ieee80211_wake_queues(hw);
-
-	/* Start ANI */
-	if (!common->disable_ani)
-		ath_start_ani(common);
-
 	ath9k_ps_restore(sc);
 
 	return r;
@@ -1081,28 +1044,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		goto mutex_unlock;
 	}
 
-	/*
-	 * This is needed only to setup initial state
-	 * but it's best done after a reset.
-	 */
-	ath9k_cmn_update_txpow(ah, sc->curtxpow,
-			sc->config.txpowlimit, &sc->curtxpow);
-
-	/*
-	 * Setup the hardware after reset:
-	 * The receive engine is set going.
-	 * Frame transmit is handled entirely
-	 * in the frame output path; there's nothing to do
-	 * here except setup the interrupt mask.
-	 */
-	if (ath_startrecv(sc) != 0) {
-		ath_err(common, "Unable to start recv logic\n");
-		r = -EIO;
-		spin_unlock_bh(&sc->sc_pcu_lock);
-		goto mutex_unlock;
-	}
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
 	/* Setup our intr mask. */
 	ah->imask = ATH9K_INT_TX | ATH9K_INT_RXEOL |
 		    ATH9K_INT_RXORN | ATH9K_INT_FATAL |
@@ -1125,12 +1066,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	/* Disable BMISS interrupt when we're not associated */
 	ah->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	ath9k_hw_set_interrupts(ah, ah->imask);
-	ath9k_hw_enable_interrupts(ah);
 
-	ieee80211_wake_queues(hw);
+	if (!ath_complete_reset(sc, false)) {
+		r = -EIO;
+		spin_unlock_bh(&sc->sc_pcu_lock);
+		goto mutex_unlock;
+	}
 
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	if ((ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) &&
 	    !ah->btcoex_hw.enabled) {
-- 
1.7.3.2

