Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:21756 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758387Ab0FPKMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:10 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0578563129
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:09 +0900 (JST)
Subject: [PATCH 08/17] ath5k: split descriptor handling and frame receive
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:51 +0900
Message-ID: <20100616101151.10067.15949.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move frame reception into it's own function to have a clearer separation
between buffer and descriptor handling and things that are done when we
actually receive a frame.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |  149 +++++++++++++++++----------------
 1 files changed, 78 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d9df114..c54d1fd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -357,7 +357,6 @@ static void 	ath5k_txq_release(struct ath5k_softc *sc);
 static int 	ath5k_rx_start(struct ath5k_softc *sc);
 static void 	ath5k_rx_stop(struct ath5k_softc *sc);
 static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
-					struct ath5k_desc *ds,
 					struct sk_buff *skb,
 					struct ath5k_rx_status *rs);
 static void 	ath5k_tasklet_rx(unsigned long data);
@@ -1732,8 +1731,8 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 }
 
 static unsigned int
-ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
-		struct sk_buff *skb, struct ath5k_rx_status *rs)
+ath5k_rx_decrypted(struct ath5k_softc *sc, struct sk_buff *skb,
+		   struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
@@ -1900,9 +1899,83 @@ static int ath5k_remove_padding(struct sk_buff *skb)
 }
 
 static void
-ath5k_tasklet_rx(unsigned long data)
+ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
+		    struct ath5k_rx_status *rs)
 {
 	struct ieee80211_rx_status *rxs;
+
+	/* The MAC header is padded to have 32-bit boundary if the
+	 * packet payload is non-zero. The general calculation for
+	 * padsize would take into account odd header lengths:
+	 * padsize = (4 - hdrlen % 4) % 4; However, since only
+	 * even-length headers are used, padding can only be 0 or 2
+	 * bytes and we can optimize this a bit. In addition, we must
+	 * not try to remove padding from short control frames that do
+	 * not have payload. */
+	ath5k_remove_padding(skb);
+
+	rxs = IEEE80211_SKB_RXCB(skb);
+
+	rxs->flag = 0;
+	if (unlikely(rs->rs_status & AR5K_RXERR_MIC))
+		rxs->flag |= RX_FLAG_MMIC_ERROR;
+
+	/*
+	 * always extend the mac timestamp, since this information is
+	 * also needed for proper IBSS merging.
+	 *
+	 * XXX: it might be too late to do it here, since rs_tstamp is
+	 * 15bit only. that means TSF extension has to be done within
+	 * 32768usec (about 32ms). it might be necessary to move this to
+	 * the interrupt handler, like it is done in madwifi.
+	 *
+	 * Unfortunately we don't know when the hardware takes the rx
+	 * timestamp (beginning of phy frame, data frame, end of rx?).
+	 * The only thing we know is that it is hardware specific...
+	 * On AR5213 it seems the rx timestamp is at the end of the
+	 * frame, but i'm not sure.
+	 *
+	 * NOTE: mac80211 defines mactime at the beginning of the first
+	 * data symbol. Since we don't have any time references it's
+	 * impossible to comply to that. This affects IBSS merge only
+	 * right now, so it's not too bad...
+	 */
+	rxs->mactime = ath5k_extend_tsf(sc->ah, rs->rs_tstamp);
+	rxs->flag |= RX_FLAG_TSFT;
+
+	rxs->freq = sc->curchan->center_freq;
+	rxs->band = sc->curband->band;
+
+	rxs->signal = sc->ah->ah_noise_floor + rs->rs_rssi;
+
+	rxs->antenna = rs->rs_antenna;
+
+	if (rs->rs_antenna > 0 && rs->rs_antenna < 5)
+		sc->stats.antenna_rx[rs->rs_antenna]++;
+	else
+		sc->stats.antenna_rx[0]++; /* invalid */
+
+	rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs->rs_rate);
+	rxs->flag |= ath5k_rx_decrypted(sc, skb, rs);
+
+	if (rxs->rate_idx >= 0 && rs->rs_rate ==
+	    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
+		rxs->flag |= RX_FLAG_SHORTPRE;
+
+	ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
+
+	ath5k_update_beacon_rssi(sc, skb, rs->rs_rssi);
+
+	/* check beacons in IBSS mode */
+	if (sc->opmode == NL80211_IFTYPE_ADHOC)
+		ath5k_check_ibss_tsf(sc, skb, rxs);
+
+	ieee80211_rx(sc->hw, skb);
+}
+
+static void
+ath5k_tasklet_rx(unsigned long data)
+{
 	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
@@ -1912,7 +1985,6 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
-	int rx_flag;
 
 	spin_lock(&sc->rxbuflock);
 	if (list_empty(&sc->rxbuf)) {
@@ -1920,8 +1992,6 @@ ath5k_tasklet_rx(unsigned long data)
 		goto unlock;
 	}
 	do {
-		rx_flag = 0;
-
 		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
 		BUG_ON(bf->skb == NULL);
 		skb = bf->skb;
@@ -1970,7 +2040,6 @@ ath5k_tasklet_rx(unsigned long data)
 					goto accept;
 			}
 			if (rs.rs_status & AR5K_RXERR_MIC) {
-				rx_flag |= RX_FLAG_MMIC_ERROR;
 				sc->stats.rxerr_mic++;
 				goto accept;
 			}
@@ -2001,69 +2070,7 @@ accept:
 				PCI_DMA_FROMDEVICE);
 		skb_put(skb, rs.rs_datalen);
 
-		/* The MAC header is padded to have 32-bit boundary if the
-		 * packet payload is non-zero. The general calculation for
-		 * padsize would take into account odd header lengths:
-		 * padsize = (4 - hdrlen % 4) % 4; However, since only
-		 * even-length headers are used, padding can only be 0 or 2
-		 * bytes and we can optimize this a bit. In addition, we must
-		 * not try to remove padding from short control frames that do
-		 * not have payload. */
-		ath5k_remove_padding(skb);
-
-		rxs = IEEE80211_SKB_RXCB(skb);
-
-		/*
-		 * always extend the mac timestamp, since this information is
-		 * also needed for proper IBSS merging.
-		 *
-		 * XXX: it might be too late to do it here, since rs_tstamp is
-		 * 15bit only. that means TSF extension has to be done within
-		 * 32768usec (about 32ms). it might be necessary to move this to
-		 * the interrupt handler, like it is done in madwifi.
-		 *
-		 * Unfortunately we don't know when the hardware takes the rx
-		 * timestamp (beginning of phy frame, data frame, end of rx?).
-		 * The only thing we know is that it is hardware specific...
-		 * On AR5213 it seems the rx timestamp is at the end of the
-		 * frame, but i'm not sure.
-		 *
-		 * NOTE: mac80211 defines mactime at the beginning of the first
-		 * data symbol. Since we don't have any time references it's
-		 * impossible to comply to that. This affects IBSS merge only
-		 * right now, so it's not too bad...
-		 */
-		rxs->mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
-		rxs->flag = rx_flag | RX_FLAG_TSFT;
-
-		rxs->freq = sc->curchan->center_freq;
-		rxs->band = sc->curband->band;
-
-		rxs->signal = sc->ah->ah_noise_floor + rs.rs_rssi;
-
-		rxs->antenna = rs.rs_antenna;
-
-		if (rs.rs_antenna > 0 && rs.rs_antenna < 5)
-			sc->stats.antenna_rx[rs.rs_antenna]++;
-		else
-			sc->stats.antenna_rx[0]++; /* invalid */
-
-		rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
-		rxs->flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
-
-		if (rxs->rate_idx >= 0 && rs.rs_rate ==
-		    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
-			rxs->flag |= RX_FLAG_SHORTPRE;
-
-		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
-
-		ath5k_update_beacon_rssi(sc, skb, rs.rs_rssi);
-
-		/* check beacons in IBSS mode */
-		if (sc->opmode == NL80211_IFTYPE_ADHOC)
-			ath5k_check_ibss_tsf(sc, skb, rxs);
-
-		ieee80211_rx(sc->hw, skb);
+		ath5k_receive_frame(sc, skb, &rs);
 
 		bf->skb = next_skb;
 		bf->skbaddr = next_skb_addr;

