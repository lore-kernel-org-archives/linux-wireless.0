Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41463 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab1IASBW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 14:01:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Subject: [PATCH v12 4/5] ath9k: merge reset related functions
Date: Thu,  1 Sep 2011 20:01:06 +0200
Message-Id: <1314900067-85242-4-git-send-email-nbd@openwrt.org> (sfid-20110901_200127_028913_3902D7CE)
In-Reply-To: <1314900067-85242-3-git-send-email-nbd@openwrt.org>
References: <1314900067-85242-1-git-send-email-nbd@openwrt.org>
 <1314900067-85242-2-git-send-email-nbd@openwrt.org>
 <1314900067-85242-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reduces unnecessary code duplication. Also takes the sc_pcu_lock within
ath_reset instead of callsites, which makes it possible to always cancel
all queued work items before the reset, possibly fixing a few race
conditions (work items vs reset) along with it.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |  306 ++++++++++++++-------------------
 1 files changed, 129 insertions(+), 177 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 36ae12a..f072e11 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -212,84 +212,58 @@ static int ath_update_survey_stats(struct ath_softc *sc)
 	return ret;
 }
 
-/*
- * Set/change channels.  If the channel is really being changed, it's done
- * by reseting the chip.  To accomplish this we must first cleanup any pending
- * DMA, then restart stuff.
-*/
-static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
-		    struct ath9k_channel *hchan)
+static void __ath_cancel_work(struct ath_softc *sc)
 {
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
-	bool fastcc = true, stopped;
-	struct ieee80211_channel *channel = hw->conf.channel;
-	struct ath9k_hw_cal_data *caldata = NULL;
-	int r;
-
-	if (sc->sc_flags & SC_OP_INVALID)
-		return -EIO;
-
-	sc->hw_busy_count = 0;
-
-	del_timer_sync(&common->ani.timer);
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
-	cancel_work_sync(&sc->hw_reset_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
+}
 
-	ath9k_ps_wakeup(sc);
+static void ath_cancel_work(struct ath_softc *sc)
+{
+	__ath_cancel_work(sc);
+	cancel_work_sync(&sc->hw_reset_work);
+}
 
-	spin_lock_bh(&sc->sc_pcu_lock);
+static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	bool ret;
 
-	/*
-	 * This is only performed if the channel settings have
-	 * actually changed.
-	 *
-	 * To switch channels clear any pending DMA operations;
-	 * wait long enough for the RX fifo to drain, reset the
-	 * hardware at the new frequency, and then re-enable
-	 * the relevant bits of the h/w.
-	 */
-	ath9k_hw_disable_interrupts(ah);
-	stopped = ath_drain_all_txq(sc, false);
+	ieee80211_stop_queues(sc->hw);
 
-	if (!ath_stoprecv(sc))
-		stopped = false;
+	sc->hw_busy_count = 0;
+	del_timer_sync(&common->ani.timer);
 
-	if (!ath9k_hw_check_alive(ah))
-		stopped = false;
+	ath9k_debug_samp_bb_mac(sc);
+	ath9k_hw_disable_interrupts(ah);
 
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
@@ -297,21 +271,95 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
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
+	__ath_cancel_work(sc);
+
+	spin_lock_bh(&sc->sc_pcu_lock);
+
+	sc->sc_flags &= ~SC_OP_HW_RESET;
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
+		goto out;
+	}
+
+	if (!ath_complete_reset(sc, true))
+		r = -EIO;
+
+out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
+	return r;
+}
+
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
+	r = ath_reset_internal(sc, hchan, false);
 
 	ath9k_ps_restore(sc);
+
 	return r;
 }
 
@@ -825,28 +873,13 @@ static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
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
@@ -859,11 +892,10 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	int r;
 
 	ath9k_ps_wakeup(sc);
-	cancel_delayed_work_sync(&sc->hw_pll_work);
 
-	spin_lock_bh(&sc->sc_pcu_lock);
+	ath_cancel_work(sc);
 
-	ieee80211_stop_queues(hw);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	/*
 	 * Keep the LED on when the radio is disabled
@@ -874,13 +906,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
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
@@ -902,50 +928,11 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 static int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
-	sc->sc_flags &= ~SC_OP_HW_RESET;
-	sc->hw_busy_count = 0;
-
-	ath9k_debug_samp_bb_mac(sc);
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
@@ -958,12 +945,6 @@ static int ath_reset(struct ath_softc *sc, bool retry_tx)
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
@@ -973,9 +954,7 @@ void ath_reset_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
 
-	spin_lock_bh(&sc->sc_pcu_lock);
 	ath_reset(sc, true);
-	spin_unlock_bh(&sc->sc_pcu_lock);
 }
 
 void ath_hw_check(struct work_struct *work)
@@ -996,11 +975,8 @@ void ath_hw_check(struct work_struct *work)
 	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
 		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
 	if (busy >= 99) {
-		if (++sc->hw_busy_count >= 3) {
-			spin_lock_bh(&sc->sc_pcu_lock);
-			ath_reset(sc, true);
-			spin_unlock_bh(&sc->sc_pcu_lock);
-		}
+		if (++sc->hw_busy_count >= 3)
+			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 
 	} else if (busy >= 0)
 		sc->hw_busy_count = 0;
@@ -1020,9 +996,7 @@ static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
 			/* Rx is hung for more than 500ms. Reset it */
 			ath_dbg(common, ATH_DBG_RESET,
 				"Possible RX hang, resetting");
-			spin_lock_bh(&sc->sc_pcu_lock);
-			ath_reset(sc, true);
-			spin_unlock_bh(&sc->sc_pcu_lock);
+			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 			count = 0;
 		}
 	} else
@@ -1093,28 +1067,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
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
@@ -1137,12 +1089,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
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
@@ -1235,11 +1189,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 
-	cancel_delayed_work_sync(&sc->tx_complete_work);
-	cancel_delayed_work_sync(&sc->hw_pll_work);
-	cancel_work_sync(&sc->paprd_work);
-	cancel_work_sync(&sc->hw_check_work);
-	cancel_work_sync(&sc->hw_reset_work);
+	ath_cancel_work(sc);
 
 	if (sc->sc_flags & SC_OP_INVALID) {
 		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
@@ -2354,9 +2304,11 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 	drain_txq = ath_drain_all_txq(sc, false);
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
 	if (!drain_txq)
 		ath_reset(sc, false);
-	spin_unlock_bh(&sc->sc_pcu_lock);
+
 	ath9k_ps_restore(sc);
 	ieee80211_wake_queues(hw);
 
-- 
1.7.3.2

