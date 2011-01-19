Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:1478 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753795Ab1ASJUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:48 -0500
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0122248846
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:46 +0900 (JST)
Subject: [PATCH 8/8] ath5k: Remove redundant sc->curband
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:21:13 +0900
Message-ID: <20110119092113.19628.33322.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove sc->curband because the band is already stored in the current channel.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   11 ++++-------
 drivers/net/wireless/ath/ath5k/base.h |    2 --
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a00cc11..0e39ee8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -551,7 +551,7 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 			"hw_rix out of bounds: %x\n", hw_rix))
 		return 0;
 
-	rix = sc->rate_idx[sc->curband->band][hw_rix];
+	rix = sc->rate_idx[sc->curchan->band][hw_rix];
 	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
 		rix = 0;
 
@@ -1361,7 +1361,7 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 	rxs->flag |= RX_FLAG_TSFT;
 
 	rxs->freq = sc->curchan->center_freq;
-	rxs->band = sc->curband->band;
+	rxs->band = sc->curchan->band;
 
 	rxs->signal = sc->ah->ah_noise_floor + rs->rs_rssi;
 
@@ -1376,7 +1376,7 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 	rxs->flag |= ath5k_rx_decrypted(sc, skb, rs);
 
 	if (rxs->rate_idx >= 0 && rs->rs_rate ==
-	    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
+	    sc->sbands[sc->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
 		rxs->flag |= RX_FLAG_SHORTPRE;
 
 	ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
@@ -2536,7 +2536,6 @@ ath5k_init_hw(struct ath5k_softc *sc)
 	 * and then setup of the interrupt mask.
 	 */
 	sc->curchan = sc->hw->conf.channel;
-	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
 		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
@@ -2663,10 +2662,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	 * so we should also free any remaining
 	 * tx buffers */
 	ath5k_drain_tx_buffs(sc);
-	if (chan) {
+	if (chan)
 		sc->curchan = chan;
-		sc->curband = &sc->sbands[chan->band];
-	}
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL,
 								skip_pcu);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 58660e4..8f919dc 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -183,8 +183,6 @@ struct ath5k_softc {
 	enum nl80211_iftype	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
-	struct ieee80211_supported_band		*curband;
-
 #ifdef CONFIG_ATH5K_DEBUG
 	struct ath5k_dbg_info	debug;		/* debug info */
 #endif /* CONFIG_ATH5K_DEBUG */

