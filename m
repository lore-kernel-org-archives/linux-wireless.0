Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18317 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYLTF4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:56:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:56:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 15/16] ath9k: remove superfluous check on changing channel
Date: Fri, 19 Dec 2008 21:55:21 -0800
Message-ID: <1229752522-1917-16-git-send-email-lrodriguez@atheros.com> (sfid-20081220_070900_970544_CE734DE8)
In-Reply-To: <1229752522-1917-15-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-10-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-11-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-12-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-13-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-14-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-15-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we try to change the channel in ath9k its because
either the configuration indicates we *have* changed
channels or HT configuration has changed. In both cases
we want to do a reset. Either way mac80211 will inform us
when we want to actually change the channel so trust those
calls.

Although in the patch it may seem as I am doing more code
changes I am not, all I am doing is removing the initial
branch conditional and shifting the code to the left.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |  101 +++++++++++++++++-------------------
 1 files changed, 48 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 1385343..1f58d4b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -270,63 +270,58 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_channel *c)
 
 	hchan = (struct ath9k_channel *) c->priv;
 
-	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
-	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
-	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
-	    (sc->sc_flags & SC_OP_FULL_RESET)) {
-		/*
-		 * This is only performed if the channel settings have
-		 * actually changed.
-		 *
-		 * To switch channels clear any pending DMA operations;
-		 * wait long enough for the RX fifo to drain, reset the
-		 * hardware at the new frequency, and then re-enable
-		 * the relevant bits of the h/w.
-		 */
-		ath9k_hw_set_interrupts(ah, 0);
-		ath_draintxq(sc, false);
-		stopped = ath_stoprecv(sc);
+	/*
+	 * This is only performed if the channel settings have
+	 * actually changed.
+	 *
+	 * To switch channels clear any pending DMA operations;
+	 * wait long enough for the RX fifo to drain, reset the
+	 * hardware at the new frequency, and then re-enable
+	 * the relevant bits of the h/w.
+	 */
+	ath9k_hw_set_interrupts(ah, 0);
+	ath_draintxq(sc, false);
+	stopped = ath_stoprecv(sc);
 
-		/* XXX: do not flush receive queue here. We don't want
-		 * to flush data frames already in queue because of
-		 * changing channel. */
+	/* XXX: do not flush receive queue here. We don't want
+	 * to flush data frames already in queue because of
+	 * changing channel. */
 
-		if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
-			fastcc = false;
+	if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
+		fastcc = false;
 
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"(%u MHz) -> (%u MHz), chanwidth: %d\n",
-			sc->sc_ah->ah_curchan->channel,
-			c->center_freq, sc->tx_chan_width);
+	DPRINTF(sc, ATH_DBG_CONFIG,
+		"(%u MHz) -> (%u MHz), chanwidth: %d\n",
+		sc->sc_ah->ah_curchan->channel,
+		c->center_freq, sc->tx_chan_width);
 
-		spin_lock_bh(&sc->sc_resetlock);
+	spin_lock_bh(&sc->sc_resetlock);
 
-		r = ath9k_hw_reset(ah, fastcc);
-		if (r) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset channel %u (%uMhz) "
-				"hal status %u\n",
-				ieee80211_frequency_to_channel(c->center_freq),
-				c->center_freq,
-				r);
-			spin_unlock_bh(&sc->sc_resetlock);
-			return r;
-		}
+	r = ath9k_hw_reset(ah, fastcc);
+	if (r) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+		  "Unable to reset channel %u (%uMhz) "
+		  "hal status %u\n",
+		  ieee80211_frequency_to_channel(c->center_freq),
+		  c->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
+		return r;
+	}
+	spin_unlock_bh(&sc->sc_resetlock);
 
-		sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
-		sc->sc_flags &= ~SC_OP_FULL_RESET;
-
-		if (ath_startrecv(sc) != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to restart recv logic\n");
-			return -EIO;
-		}
+	sc->sc_flags &= ~SC_OP_CHAINMASK_UPDATE;
+	sc->sc_flags &= ~SC_OP_FULL_RESET;
 
-		ath_cache_conf_rate(sc, &hw->conf);
-		ath_update_txpow(sc);
-		ath9k_hw_set_interrupts(ah, sc->sc_imask);
+	if (ath_startrecv(sc) != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Unable to restart recv logic\n");
+		return -EIO;
 	}
+
+	ath_cache_conf_rate(sc, &hw->conf);
+	ath_update_txpow(sc);
+	ath9k_hw_set_interrupts(ah, sc->sc_imask);
+
 	return 0;
 }
 
-- 
1.5.6.rc2.15.g457bb.dirty

