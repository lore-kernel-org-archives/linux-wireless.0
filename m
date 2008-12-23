Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22668 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYLWX7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:13 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 05/16] ath9k: consolidate arguments on hw reset
Date: Tue, 23 Dec 2008 15:58:40 -0800
Message-ID: <1230076731-22946-6-git-send-email-lrodriguez@atheros.com> (sfid-20081224_005917_986195_899A4AC5)
In-Reply-To: <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW reset calls pass the same variables or structs
which we can obtain easily from ah. Although this also applies
during channel changes as we will keep around the ath9k_channel
passed as an argument for now.

We now also now propagate the hw reset errors down.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    7 +--
 drivers/net/wireless/ath9k/hw.c    |   68 ++++++++--------------
 drivers/net/wireless/ath9k/main.c  |  110 ++++++++++++++----------------------
 drivers/net/wireless/ath9k/xmit.c  |   16 ++---
 4 files changed, 74 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d278135..0f6a99a 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -843,11 +843,8 @@ void ath9k_hw_rfdetach(struct ath_hal *ah);
 
 /* HW Reset */
 
-bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
-		    enum ath9k_ht_macmode macmode,
-		    u8 txchainmask, u8 rxchainmask,
-		    enum ath9k_ht_extprotspacing extprotspacing,
-		    bool bChannelChange, int *status);
+int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+		    bool bChannelChange);
 
 /* Key Cache Management */
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index d2b0ecf..85da799 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2223,23 +2223,20 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *cha
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
-		    enum ath9k_ht_macmode macmode,
-		    u8 txchainmask, u8 rxchainmask,
-		    enum ath9k_ht_extprotspacing extprotspacing,
-		    bool bChannelChange, int *status)
+int ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+		    bool bChannelChange)
 {
 	u32 saveLedState;
+	struct ath_softc *sc = ah->ah_sc;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *curchan = ah->ah_curchan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
-	int ecode;
-	int i, rx_chainmask;
+	int i, rx_chainmask, r;
 
-	ahp->ah_extprotspacing = extprotspacing;
-	ahp->ah_txchainmask = txchainmask;
-	ahp->ah_rxchainmask = rxchainmask;
+	ahp->ah_extprotspacing = sc->sc_ht_extprotspacing;
+	ahp->ah_txchainmask = sc->sc_tx_chainmask;
+	ahp->ah_rxchainmask = sc->sc_rx_chainmask;
 
 	if (AR_SREV_9280(ah)) {
 		ahp->ah_txchainmask &= 0x3;
@@ -2250,14 +2247,11 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			"invalid channel %u/0x%x; no mapping\n",
 			chan->channel, chan->channelFlags);
-		ecode = -EINVAL;
-		goto bad;
+		return -EINVAL;
 	}
 
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		ecode = -EIO;
-		goto bad;
-	}
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+		return -EIO;
 
 	if (curchan)
 		ath9k_hw_getnf(ah, curchan);
@@ -2271,10 +2265,10 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
 				   !IS_CHAN_A_5MHZ_SPACED(ah->ah_curchan)))) {
 
-		if (ath9k_hw_channel_change(ah, chan, macmode)) {
+		if (ath9k_hw_channel_change(ah, chan, sc->tx_chan_width)) {
 			ath9k_hw_loadnf(ah, ah->ah_curchan);
 			ath9k_hw_start_nfcal(ah);
-			return true;
+			return 0;
 		}
 	}
 
@@ -2292,8 +2286,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "chip reset failed\n");
-		ecode = -EINVAL;
-		goto bad;
+		return -EINVAL;
 	}
 
 	if (AR_SREV_9280(ah)) {
@@ -2309,11 +2302,9 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 		ath9k_hw_cfg_output(ah, 9, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	}
 
-	ecode = ath9k_hw_process_ini(ah, chan, macmode);
-	if (ecode != 0) {
-		ecode = -EINVAL;
-		goto bad;
-	}
+	r = ath9k_hw_process_ini(ah, chan, sc->tx_chan_width);
+	if (r)
+		return r;
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
@@ -2326,8 +2317,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"error setting board options\n");
-		ecode = -EIO;
-		goto bad;
+		return -EIO;
 	}
 
 	ath9k_hw_decrease_chain_power(ah, chan);
@@ -2355,15 +2345,11 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		if (!(ath9k_hw_ar9280_set_channel(ah, chan))) {
-			ecode = -EIO;
-			goto bad;
-		}
+		if (!(ath9k_hw_ar9280_set_channel(ah, chan)))
+			return -EIO;
 	} else {
-		if (!(ath9k_hw_set_channel(ah, chan))) {
-			ecode = -EIO;
-			goto bad;
-		}
+		if (!(ath9k_hw_set_channel(ah, chan)))
+			return -EIO;
 	}
 
 	for (i = 0; i < AR_NUM_DCU; i++)
@@ -2397,10 +2383,8 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_bb(ah, chan);
 
-	if (!ath9k_hw_init_cal(ah, chan)){
-		ecode = -EIO;;
-		goto bad;
-	}
+	if (!ath9k_hw_init_cal(ah, chan))
+		return -EIO;;
 
 	rx_chainmask = ahp->ah_rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
@@ -2429,11 +2413,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 #endif
 	}
 
-	return true;
-bad:
-	if (status)
-		*status = ecode;
-	return false;
+	return 0;
 }
 
 /************************/
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8127257..bbd7d06 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -260,6 +260,8 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
 	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_channel *channel = hw->conf.channel;
+	int r;
 
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
@@ -268,7 +270,6 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
 	    (sc->sc_flags & SC_OP_FULL_RESET)) {
-		int status;
 		/*
 		 * This is only performed if the channel settings have
 		 * actually changed.
@@ -290,22 +291,20 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			fastcc = false;
 
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"(%u MHz) -> (%u MHz), cflags:%x, chanwidth: %d\n",
+			"(%u MHz) -> (%u MHz), chanwidth: %d\n",
 			sc->sc_ah->ah_curchan->channel,
-			hchan->channel, hchan->channelFlags, sc->tx_chan_width);
+			channel->center_freq, sc->tx_chan_width);
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, hchan, sc->tx_chan_width,
-				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-				    sc->sc_ht_extprotspacing, fastcc, &status)) {
+
+		r = ath9k_hw_reset(ah, hchan, fastcc);
+		if (r) {
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset channel %u (%uMhz) "
-				"flags 0x%x hal status %u\n",
-				ath9k_hw_mhz2ieee(ah, hchan->channel,
-						  hchan->channelFlags),
-				hchan->channel, hchan->channelFlags, status);
+				"Unable to reset channel (%u Mhz) "
+				"reset status %u\n",
+				channel->center_freq, r);
 			spin_unlock_bh(&sc->sc_resetlock);
-			return -EIO;
+			return r;
 		}
 		spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1071,23 +1070,18 @@ fail:
 static void ath_radio_enable(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	int status;
+	struct ieee80211_channel *channel = sc->hw->conf.channel;
+	int r;
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, ah->ah_curchan,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask,
-			    sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing,
-			    false, &status)) {
+
+	r = ath9k_hw_reset(ah, ah->ah_curchan, false);
+
+	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to reset channel %u (%uMhz) "
-			"flags 0x%x hal status %u\n",
-			ath9k_hw_mhz2ieee(ah,
-					  ah->ah_curchan->channel,
-					  ah->ah_curchan->channelFlags),
-			ah->ah_curchan->channel,
-			ah->ah_curchan->channelFlags, status);
+			"Unable to reset channel %u (%uMhz) ",
+			"reset status %u\n",
+			channel->center_freq, r);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1115,8 +1109,8 @@ static void ath_radio_enable(struct ath_softc *sc)
 static void ath_radio_disable(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	int status;
-
+	struct ieee80211_channel *channel = sc->hw->conf.channel;
+	int r;
 
 	ieee80211_stop_queues(sc->hw);
 
@@ -1132,20 +1126,12 @@ static void ath_radio_disable(struct ath_softc *sc)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, ah->ah_curchan,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask,
-			    sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing,
-			    false, &status)) {
+	r = ath9k_hw_reset(ah, ah->ah_curchan, false);
+	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
-			"flags 0x%x hal status %u\n",
-			ath9k_hw_mhz2ieee(ah,
-				ah->ah_curchan->channel,
-				ah->ah_curchan->channelFlags),
-			ah->ah_curchan->channel,
-			ah->ah_curchan->channelFlags, status);
+			"reset status %u\n",
+			channel->center_freq, r);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1624,8 +1610,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ieee80211_hw *hw = sc->hw;
-	int status;
-	int error = 0;
+	int r;
 
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_draintxq(sc, retry_tx);
@@ -1633,14 +1618,10 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	ath_flushrecv(sc);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing, false, &status)) {
+	r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, false);
+	if (r)
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to reset hardware; hal status %u\n", status);
-		error = -EIO;
-	}
+			"Unable to reset hardware; reset status %u\n", r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
@@ -1671,7 +1652,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		}
 	}
 
-	return error;
+	return r;
 }
 
 /*
@@ -1854,7 +1835,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
-	int error = 0, pos, status;
+	int r, pos;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
@@ -1864,8 +1845,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	pos = ath_get_channel(sc, curchan);
 	if (pos == -1) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n", curchan->center_freq);
-		error = -EINVAL;
-		goto error;
+		return -EINVAL;
 	}
 
 	sc->tx_chan_width = ATH9K_HT_MACMODE_20;
@@ -1884,17 +1864,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(sc->sc_ah, init_channel,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing, false, &status)) {
+	r = ath9k_hw_reset(sc->sc_ah, init_channel, false);
+	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to reset hardware; hal status %u "
-			"(freq %u flags 0x%x)\n", status,
-			init_channel->channel, init_channel->channelFlags);
-		error = -EIO;
+			"Unable to reset hardware; reset status %u "
+			"(freq %u MHz)\n", r,
+			curchan->center_freq);
 		spin_unlock_bh(&sc->sc_resetlock);
-		goto error;
+		return r;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1914,8 +1891,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to start recv logic\n");
-		error = -EIO;
-		goto error;
+		return -EIO;
 	}
 
 	/* Setup our intr mask. */
@@ -1959,11 +1935,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ieee80211_wake_queues(sc->hw);
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	error = ath_start_rfkill_poll(sc);
+	r = ath_start_rfkill_poll(sc);
 #endif
-
-error:
-	return error;
+	return r;
 }
 
 static int ath9k_tx(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3e192fd..e28889b 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1140,7 +1140,7 @@ static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	int i, status, npend = 0;
+	int i, npend = 0;
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
@@ -1155,20 +1155,16 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 	}
 
 	if (npend) {
+		int r;
 		/* TxDMA not stopped, reset the hal */
 		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah,
-				    sc->sc_ah->ah_curchan,
-				    sc->tx_chan_width,
-				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-				    sc->sc_ht_extprotspacing, true, &status)) {
-
+		r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, true);
+		if (r)
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset hardware; hal status %u\n",
-				status);
-		}
+				"Unable to reset hardware; reset status %u\n",
+				r);
 		spin_unlock_bh(&sc->sc_resetlock);
 	}
 
-- 
1.6.1.rc3.51.g5832d

