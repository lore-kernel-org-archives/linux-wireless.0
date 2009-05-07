Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4478 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbZEGI5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 04:57:05 -0400
Date: Thu, 7 May 2009 04:56:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops
	on 802.11a capable card
Message-ID: <20090507085626.GA4562@hash.localnet>
References: <1241626486.30590.13.camel@mj> <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com> <20090506172513.GB30070@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090506172513.GB30070@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 06, 2009 at 01:25:13PM -0400, John W. Linville wrote:
> On Wed, May 06, 2009 at 12:36:13PM -0400, Bob Copeland wrote:
> > Agreed... Also I think the same thing happens for rx for ath5k,
> > explaining the 'unknown rate index' warnings (sc->curband changes
> > during scan but we process a beacon from 2ghz band, that one at
> > least just needs some synchronization in the driver).
> 
> Ah, that could be -- I sure am tired of reading bug reports about
> that...

It's not conceptually hard to fix but I can't think of an easy 1-liner
patch.

Here are the races in the rx path (note TX status processing has a
similar race with hw_to_driver_rix, which is separate from Pavel's
get_tx_rate report).  It should be pretty easy to reproduce by setting
up scans of one channel in each band and running them continuously under
load.

Race 1 (single cpu, unfortunately placed interrupt):

CPU 1:
drv_config 
 sc->curchan = xxx
 sc->curband = yyy
 [intr]
  rx_tasklet
   rxs.rate = hw_to_driver_rix [now reports wrong band/channel]
  [end tasklet]
 reset [changes channel]

The following (untested!) patch fixes this race in a cheesy way for both
RX and TX.  However, it doesn't fix the following, smaller race caused by
deferred processing on a separate CPU.  A proper fix, as indicated,
would both rework the reset order and flush out any unprocessed data under
the appropriate spinlocks, forcing that stuff to run after the tasklets
are completed.

CPU 1:                                CPU 2:
drv_config
 next_chan = xxx
 next_band = yyy
 reset 
                                      [intr]
  disable intr                         rx_tasklet
  stop dma             
  [flush should go here]
  curchan = next_chan
  curband = next_chan
                                       rxs.rate = hw_to_driver_rix

Cheesy untested patch (actually, I know it is broken for ath5k_init, 
but you get the idea):

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6789c5d..6264d49 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1076,8 +1076,8 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	if (chan->center_freq != sc->curchan->center_freq ||
 		chan->hw_value != sc->curchan->hw_value) {
 
-		sc->curchan = chan;
-		sc->curband = &sc->sbands[chan->band];
+		sc->nextchan = chan;
+		sc->nextband = &sc->sbands[chan->band];
 
 		/*
 		 * To switch channels clear any pending DMA operations;
@@ -2648,6 +2648,8 @@ ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel)
 		ath5k_txq_cleanup(sc);
 		ath5k_rx_stop(sc);
 	}
+	sc->curchan = sc->nextchan;
+	sc->curband = sc->nextband;
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 852b2c1..ce8a5d4 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -116,6 +116,7 @@ struct ath5k_softc {
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
 	struct ieee80211_supported_band		*curband;
+	struct ieee80211_supported_band		*nextband;
 
 #ifdef CONFIG_ATH5K_DEBUG
 	struct ath5k_dbg_info	debug;		/* debug info */
@@ -137,6 +138,7 @@ struct ath5k_softc {
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
+	struct ieee80211_channel *nextchan;	/* next h/w channel */
 
 	struct ieee80211_vif *vif;
 
-- 
Bob Copeland %% www.bobcopeland.com

