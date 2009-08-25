Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58557 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575AbZHYXi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 19:38:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 16:38:29 -0700
Date: Tue, 25 Aug 2009 16:38:27 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
Message-ID: <20090825233827.GA10998@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
 <20090825185842.GA7357@mosca>
 <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 12:22:55PM -0700, Bob Copeland wrote:
> On Tue, Aug 25, 2009 at 2:58 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
> > OK how about the band info, think that's useful?
> 
> Yeah, band is useful.  We don't have to pretty print it though
> (unless you really feel like it), %d would work just as well.
> 
> Also WARN_ON_ONCE might be a good idea.

Alright, first let me see if I can reproduce after cleaning
curband crap a little.

> >> which could indicate some
> >> race condition with flushing the rx queue on channel changes.
> >
> > I'll see if I can reproduce somehow.
> >
> >> I haven't yet seen a hw rate we didn't know about.
> >
> > So you've seen this lately as well?
> 
> I saw it some time ago, but then changed the order of how the
> curchan/curband variables were set when we change channels and
> haven't seen since.  But kerneloops says a lot of other people
> are still hitting it as well :(

OK that's good to know too.

> Hmm, ath5k_rx_stop probably wants an equivalent to txq_drainq in
> there somewhere.

True.

First thing I saw upon a quick review was we were relying on our own
curband for RX instead of the cfg80211 hw->conf band. Now granted
that *may* be updated properly, and it seems that may be the case,
but since do not tend to trust drivers here's a removal of all that
crap first. I'll test this first to see if I run into the same warning.
If this doesn't cure it then we are indeed processing old frames on RX
and need to flush 'em out prior to a channel change first.

Good thing is after a few hours I can reproduce at least.

  Luis

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] ath5k: remove curband, curchan, curmode

It still possible for ath5k tasklet to trigger and the
curband to be off. There seems to be some race against it
somewhere. To help aid with this review we simplify the
notion of current band and current channel assumptions
ath5k and only rely on cfg80211's as it already does the
book keeping for us.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   87 +++++++++++++++------------------
 drivers/net/wireless/ath/ath5k/base.h |    6 --
 2 files changed, 39 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5056410..feffc92 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -220,7 +220,8 @@ static struct pci_driver ath5k_pci_driver = {
 static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		struct ath5k_txq *txq);
-static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
+static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+		       bool chan_change);
 static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
 static void ath5k_stop(struct ieee80211_hw *hw);
@@ -293,8 +294,6 @@ static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
 static int 	ath5k_setup_bands(struct ieee80211_hw *hw);
 static int 	ath5k_chan_set(struct ath5k_softc *sc,
 				struct ieee80211_channel *chan);
-static void	ath5k_setcurmode(struct ath5k_softc *sc,
-				unsigned int mode);
 static void	ath5k_mode_setup(struct ath5k_softc *sc);
 
 /* Descriptor setup */
@@ -759,12 +758,6 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err;
 	}
 
-	/* NB: setup here so ath5k_rate_update is happy */
-	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
-		ath5k_setcurmode(sc, AR5K_MODE_11A);
-	else
-		ath5k_setcurmode(sc, AR5K_MODE_11B);
-
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
 	 */
@@ -1084,7 +1077,7 @@ static int
 ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 {
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
-		sc->curchan->center_freq, chan->center_freq);
+		sc->hw->conf.channel->center_freq, chan->center_freq);
 
 	/*
 	 * To switch channels clear any pending DMA operations;
@@ -1092,19 +1085,12 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	 * hardware at the new frequency, and then re-enable
 	 * the relevant bits of the h/w.
 	 */
-	return ath5k_reset(sc, chan);
-}
 
-static void
-ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
-{
-	sc->curmode = mode;
+	ath5k_hw_set_imr(sc->ah, 0);
+	ath5k_txq_cleanup(sc);
+	ath5k_rx_stop(sc);
 
-	if (mode == AR5K_MODE_11A) {
-		sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
-	} else {
-		sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
-	}
+	return ath5k_reset(sc, chan, true);
 }
 
 static void
@@ -1136,11 +1122,15 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 
 	/* return base rate on errors */
 	if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
-			"hw_rix out of bounds: %x\n", hw_rix))
+		 "hardware rate index out of bounds: %x"
+		 "on freq: %d\n", hw_rix,
+		 sc->hw->conf.channel->center_freq))
 		return 0;
 
-	rix = sc->rate_idx[sc->curband->band][hw_rix];
-	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
+	rix = sc->rate_idx[sc->hw->conf.channel->band][hw_rix];
+	if (WARN(rix < 0, "invalid driver rate index mapped for "
+		 "hw_rix: %x on freq: %d\n", hw_rix,
+		 sc->hw->conf.channel->center_freq))
 		rix = 0;
 
 	return rix;
@@ -1742,6 +1732,8 @@ static void
 ath5k_tasklet_rx(unsigned long data)
 {
 	struct ieee80211_rx_status rxs = {};
+	struct ieee80211_rate *bitrate;
+	struct ieee80211_supported_band *sband;
 	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
@@ -1751,6 +1743,7 @@ ath5k_tasklet_rx(unsigned long data)
 	int ret;
 	int hdrlen;
 	int padsize;
+	int cur_band;
 
 	spin_lock(&sc->rxbuflock);
 	if (list_empty(&sc->rxbuf)) {
@@ -1864,8 +1857,8 @@ accept:
 		rxs.mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
 		rxs.flag |= RX_FLAG_TSFT;
 
-		rxs.freq = sc->curchan->center_freq;
-		rxs.band = sc->curband->band;
+		rxs.freq = sc->hw->conf.channel->center_freq;
+		rxs.band = sc->hw->conf.channel->band;
 
 		rxs.noise = sc->ah->ah_noise_floor;
 		rxs.signal = rxs.noise + rs.rs_rssi;
@@ -1885,8 +1878,11 @@ accept:
 		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
 		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
 
-		if (rxs.rate_idx >= 0 && rs.rs_rate ==
-		    sc->curband->bitrates[rxs.rate_idx].hw_value_short)
+		cur_band = sc->hw->conf.channel->band;
+		sband = sc->hw->wiphy->bands[cur_band];
+		bitrate = &sband->bitrates[rxs.rate_idx];
+
+		if (rxs.rate_idx >= 0 && rs.rs_rate == bitrate->hw_value_short)
 			rxs.flag |= RX_FLAG_SHORTPRE;
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
@@ -2328,6 +2324,11 @@ static void ath5k_tasklet_beacon(unsigned long data)
 	}
 }
 
+static int
+ath5k_reset_init(struct ath5k_softc *sc)
+{
+	return ath5k_reset(sc, sc->hw->conf.channel, false);
+}
 
 /********************\
 * Interrupt handling *
@@ -2356,12 +2357,10 @@ ath5k_init(struct ath5k_softc *sc)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	sc->curchan = sc->hw->conf.channel;
-	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
 		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_SWI;
-	ret = ath5k_reset(sc, NULL);
+	ret = ath5k_reset_init(sc);
 	if (ret)
 		goto done;
 
@@ -2581,8 +2580,8 @@ ath5k_tasklet_calibrate(unsigned long data)
 	ieee80211_stop_queues(sc->hw);
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
-		ieee80211_frequency_to_channel(sc->curchan->center_freq),
-		sc->curchan->hw_value);
+		ieee80211_frequency_to_channel(sc->hw->conf.channel->center_freq),
+		sc->hw->conf.channel->hw_value);
 
 	if (ath5k_hw_gainf_calibrate(ah) == AR5K_RFGAIN_NEED_CHANGE) {
 		/*
@@ -2592,10 +2591,10 @@ ath5k_tasklet_calibrate(unsigned long data)
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
 		ath5k_reset_wake(sc);
 	}
-	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
+	if (ath5k_hw_phy_calibrate(ah, sc->hw->conf.channel))
 		ATH5K_ERR(sc, "calibration of channel %u failed\n",
 			ieee80211_frequency_to_channel(
-				sc->curchan->center_freq));
+				sc->hw->conf.channel->center_freq));
 
 	ah->ah_swi_mask = 0;
 
@@ -2680,26 +2679,18 @@ drop_packet:
 }
 
 /*
- * Reset the hardware.  If chan is not NULL, then also pause rx/tx
- * and change to the given channel.
+ * Reset the hardware.
  */
 static int
-ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
+ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+	    bool chan_change)
 {
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
-	if (chan) {
-		ath5k_hw_set_imr(ah, 0);
-		ath5k_txq_cleanup(sc);
-		ath5k_rx_stop(sc);
-
-		sc->curchan = chan;
-		sc->curband = &sc->sbands[chan->band];
-	}
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
+	ret = ath5k_hw_reset(ah, sc->opmode, chan, chan_change);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
@@ -2735,7 +2726,7 @@ ath5k_reset_wake(struct ath5k_softc *sc)
 {
 	int ret;
 
-	ret = ath5k_reset(sc, sc->curchan);
+	ret = ath5k_reset_init(sc);
 	if (!ret)
 		ieee80211_wake_queues(sc->hw);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index a28c42f..1b88814 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -128,8 +128,6 @@ struct ath5k_softc {
 	enum nl80211_iftype	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
-	struct ieee80211_supported_band		*curband;
-
 #ifdef CONFIG_ATH5K_DEBUG
 	struct ath5k_dbg_info	debug;		/* debug info */
 #endif /* CONFIG_ATH5K_DEBUG */
@@ -147,11 +145,7 @@ struct ath5k_softc {
 #define ATH_STAT_STARTED	4		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
-	unsigned int		curmode;	/* current phy mode */
-	struct ieee80211_channel *curchan;	/* current h/w channel */
-
 	struct ieee80211_vif *vif;
-
 	enum ath5k_int		imask;		/* interrupt mask copy */
 
 	DECLARE_BITMAP(keymap, AR5K_KEYCACHE_SIZE); /* key use bit map */
-- 
1.6.3.3

