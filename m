Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYLVSVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:21:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:21:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 07/18] ath9k: consolidate arguments on hw reset
Date: Mon, 22 Dec 2008 10:20:28 -0800
Message-ID: <1229970039-10561-8-git-send-email-lrodriguez@atheros.com> (sfid-20081222_192109_652869_F7009887)
In-Reply-To: <1229970039-10561-7-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-4-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-6-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW reset calls pass the same variables or structs
which we can obtain easily from ah, this also applies
during channel changes as we always follow the ieee80211_conf
channel so consolidate the arguments.

We now also now propagate the hw reset errors down.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    7 +---
 drivers/net/wireless/ath9k/hw.c    |   76 +++++++++++++----------------------
 drivers/net/wireless/ath9k/main.c  |   78 +++++++++++++-----------------------
 drivers/net/wireless/ath9k/xmit.c  |   14 ++-----
 4 files changed, 61 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index cd11eaf..823f1d6 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -842,12 +842,7 @@ void ath9k_hw_rfdetach(struct ath_hal *ah);
 
 
 /* HW Reset */
-
-bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
-		    enum ath9k_ht_macmode macmode,
-		    u8 txchainmask, u8 rxchainmask,
-		    enum ath9k_ht_extprotspacing extprotspacing,
-		    bool bChannelChange, int *status);
+int ath9k_hw_reset(struct ath_hal *ah, bool bChannelChange);
 
 /* Key Cache Management */
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index d9f810a..60cc0ba 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2183,31 +2183,28 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *cha
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
-		    enum ath9k_ht_macmode macmode,
-		    u8 txchainmask, u8 rxchainmask,
-		    enum ath9k_ht_extprotspacing extprotspacing,
-		    bool bChannelChange, int *status)
+int ath9k_hw_reset(struct ath_hal *ah, bool bChannelChange)
 {
 	u32 saveLedState;
+	struct ath_softc *sc = ah->ah_sc;
 	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ieee80211_channel *channel;
 	struct ath9k_channel *curchan = ah->ah_curchan;
 	struct ath9k_channel *chan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
-	int ecode;
-	int i, rx_chainmask;
+	int i, rx_chainmask, r;
 
-	if (!channel->priv) {
-		ecode = -EINVAL;
-		goto bad;
-	}
+	channel = sc->hw->conf.channel;
+
+	if (!channel->priv)
+		return -EINVAL;
 
 	chan = (struct ath9k_channel *) channel->priv;
 
-	ahp->ah_extprotspacing = extprotspacing;
-	ahp->ah_txchainmask = txchainmask;
-	ahp->ah_rxchainmask = rxchainmask;
+	ahp->ah_extprotspacing = sc->sc_ht_extprotspacing;
+	ahp->ah_txchainmask = sc->sc_tx_chainmask;
+	ahp->ah_rxchainmask = sc->sc_rx_chainmask;
 
 	if (AR_SREV_9280(ah)) {
 		ahp->ah_txchainmask &= 0x3;
@@ -2218,14 +2215,11 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
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
@@ -2239,10 +2233,10 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
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
 
@@ -2260,8 +2254,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
 
 	if (!ath9k_hw_chip_reset(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "chip reset failed\n");
-		ecode = -EINVAL;
-		goto bad;
+		return -EINVAL;
 	}
 
 	if (AR_SREV_9280(ah)) {
@@ -2277,11 +2270,9 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
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
@@ -2294,8 +2285,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
 	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"error setting board options\n");
-		ecode = -EIO;
-		goto bad;
+		return -EIO;
 	}
 
 	ath9k_hw_decrease_chain_power(ah, chan);
@@ -2323,15 +2313,11 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
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
@@ -2365,10 +2351,8 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
 
 	ath9k_hw_init_bb(ah, chan);
 
-	if (!ath9k_hw_init_cal(ah, chan)){
-		ecode = -EIO;;
-		goto bad;
-	}
+	if (!ath9k_hw_init_cal(ah, chan))
+		return -EIO;;
 
 	rx_chainmask = ahp->ah_rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
@@ -2397,11 +2381,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
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
index bffd181..f7302a5 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -261,6 +261,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_channel *c)
 	bool fastcc = true, stopped;
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath9k_channel *hchan;
+	int r;
 
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
@@ -274,7 +275,6 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_channel *c)
 	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
 	    (sc->sc_flags & SC_OP_FULL_RESET)) {
-		int status;
 		/*
 		 * This is only performed if the channel settings have
 		 * actually changed.
@@ -301,17 +301,17 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_channel *c)
 			c->center_freq, sc->tx_chan_width);
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, c, sc->tx_chan_width,
-				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-				    sc->sc_ht_extprotspacing, fastcc, &status)) {
+
+		r = ath9k_hw_reset(ah, fastcc);
+		if (r) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"Unable to reset channel %u (%uMhz) "
 				"hal status %u\n",
 				ieee80211_frequency_to_channel(c->center_freq),
 				c->center_freq,
-				status);
+				r);
 			spin_unlock_bh(&sc->sc_resetlock);
-			return -EIO;
+			return r;
 		}
 		spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1065,22 +1065,17 @@ static void ath_radio_enable(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ieee80211_channel *c = sc->hw->conf.channel;
-	int status;
+	int r;
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, c,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask,
-			    sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing,
-			    false, &status)) {
+	r = ath9k_hw_reset(ah, false);
+	if (r)
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
 			"hal status %u\n",
 			ieee80211_frequency_to_channel(c->center_freq),
 			c->center_freq,
-			status);
-	}
+			r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath_update_txpow(sc);
@@ -1109,7 +1104,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 	struct ath_hal *ah = sc->sc_ah;
 	struct ieee80211_conf *conf = &sc->hw->conf;
 	struct ieee80211_channel *c = conf->channel;
-	int status;
+	int r;
 
 	ieee80211_stop_queues(sc->hw);
 
@@ -1125,19 +1120,14 @@ static void ath_radio_disable(struct ath_softc *sc)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, c,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask,
-			    sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing,
-			    false, &status)) {
+	r = ath9k_hw_reset(ah, false);
+	if (r)
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
 			"hal status %u\n",
 			ieee80211_frequency_to_channel(c->center_freq),
 			c->center_freq,
-			status);
-	}
+			r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
@@ -1615,8 +1605,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ieee80211_hw *hw = sc->hw;
-	int status;
-	int error = 0;
+	int r = 0;
 
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_draintxq(sc, retry_tx);
@@ -1624,14 +1613,10 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	ath_flushrecv(sc);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, hw->conf.channel,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing, false, &status)) {
+	r = ath9k_hw_reset(ah, false);
+	if (r)
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to reset hardware; hal status %u\n", status);
-		error = -EIO;
-	}
+			"Unable to reset hardware; hal status %u\n", r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
@@ -1662,7 +1647,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		}
 	}
 
-	return error;
+	return r;
 }
 
 /*
@@ -1845,7 +1830,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
-	int error = 0, status;
+	int r;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
@@ -1854,8 +1839,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	if (!curchan->priv) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n", curchan->center_freq);
-		error = -EINVAL;
-		goto error;
+		return -EINVAL;
 	}
 
 	sc->tx_chan_width = ATH9K_HT_MACMODE_20;
@@ -1874,17 +1858,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(sc->sc_ah, curchan,
-			    sc->tx_chan_width,
-			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			    sc->sc_ht_extprotspacing, false, &status)) {
+	r = ath9k_hw_reset(sc->sc_ah, false);
+	if (r) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset hardware; hal status %u "
-			"(freq %u)\n", status,
+			"(freq %u)\n", r,
 			curchan->center_freq);
-		error = -EIO;
 		spin_unlock_bh(&sc->sc_resetlock);
-		goto error;
+		return r;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1904,8 +1885,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to start recv logic\n");
-		error = -EIO;
-		goto error;
+		return -EIO;
 	}
 
 	/* Setup our intr mask. */
@@ -1949,11 +1929,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
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
index 249a8e5..16456dc 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1151,7 +1151,7 @@ static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	int i, status, npend = 0;
+	int i, r, npend = 0;
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
@@ -1170,16 +1170,10 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah,
-				    sc->hw->conf.channel,
-				    sc->tx_chan_width,
-				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-				    sc->sc_ht_extprotspacing, true, &status)) {
-
+		r = ath9k_hw_reset(ah, true);
+		if (r)
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset hardware; hal status %u\n",
-				status);
-		}
+				"Unable to reset hardware; hal status %u\n", r);
 		spin_unlock_bh(&sc->sc_resetlock);
 	}
 
-- 
1.6.1.rc3.51.g5832d

