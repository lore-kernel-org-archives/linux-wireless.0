Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 9/9] ath9k: do not pass the entire descriptor to ath_rx_prepare()
Date: Mon,  2 Nov 2009 22:08:01 -0500
Message-Id: <1257217681-27180-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
References: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Its not needed, so just pass the hardware RX status.
We'll be simplfying ath_rx_prepare() with code we can share
between ath9k and ath9k_htc. This will help make that code
easier to read and manage.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   70 +++++++++++++++++----------------
 1 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 10decfa..b36ecb2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -106,7 +106,7 @@ static u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
  * decryption key or real decryption error. This let us keep statistics there.
  */
 static int ath_rx_prepare(struct ieee80211_hw *hw,
-			  struct sk_buff *skb, struct ath_desc *ds,
+			  struct sk_buff *skb, struct ath_rx_status *rxstats,
 			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
 			  struct ath_softc *sc)
 {
@@ -121,7 +121,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	fc = hdr->frame_control;
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
-	if (ds->ds_rxstat.rs_more) {
+	if (rxstats->rs_more) {
 		/*
 		 * Frame spans multiple descriptors; this cannot happen yet
 		 * as we don't support jumbograms. If not in monitor mode,
@@ -130,22 +130,22 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 		 */
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_MONITOR)
 			goto rx_next;
-	} else if (ds->ds_rxstat.rs_status != 0) {
-		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
+	} else if (rxstats->rs_status != 0) {
+		if (rxstats->rs_status & ATH9K_RXERR_CRC)
 			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_PHY)
+		if (rxstats->rs_status & ATH9K_RXERR_PHY)
 			goto rx_next;
 
-		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_DECRYPT) {
+		if (rxstats->rs_status & ATH9K_RXERR_DECRYPT) {
 			*decrypt_error = true;
-		} else if (ds->ds_rxstat.rs_status & ATH9K_RXERR_MIC) {
+		} else if (rxstats->rs_status & ATH9K_RXERR_MIC) {
 			if (ieee80211_is_ctl(fc))
 				/*
 				 * Sometimes, we get invalid
 				 * MIC failures on valid control frames.
 				 * Remove these mic errors.
 				 */
-				ds->ds_rxstat.rs_status &= ~ATH9K_RXERR_MIC;
+				rxstats->rs_status &= ~ATH9K_RXERR_MIC;
 			else
 				rx_status->flag |= RX_FLAG_MMIC_ERROR;
 		}
@@ -155,26 +155,26 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 		 * we also ignore the CRC error.
 		 */
 		if (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR) {
-			if (ds->ds_rxstat.rs_status &
+			if (rxstats->rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_CRC))
 				goto rx_next;
 		} else {
-			if (ds->ds_rxstat.rs_status &
+			if (rxstats->rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
 				goto rx_next;
 			}
 		}
 	}
 
-	ratecode = ds->ds_rxstat.rs_rate;
+	ratecode = rxstats->rs_rate;
 
 	if (ratecode & 0x80) {
 		/* HT rate */
 		rx_status->flag |= RX_FLAG_HT;
-		if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040)
+		if (rxstats->rs_flags & ATH9K_RX_2040)
 			rx_status->flag |= RX_FLAG_40MHZ;
-		if (ds->ds_rxstat.rs_flags & ATH9K_RX_GI)
+		if (rxstats->rs_flags & ATH9K_RX_GI)
 			rx_status->flag |= RX_FLAG_SHORT_GI;
 		rx_status->rate_idx = ratecode & 0x7f;
 	} else {
@@ -203,31 +203,31 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	sta = ieee80211_find_sta(hw, hdr->addr2);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
-		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
-		   !ds->ds_rxstat.rs_moreaggr)
-			ATH_RSSI_LPF(an->last_rssi, ds->ds_rxstat.rs_rssi);
+		if (rxstats->rs_rssi != ATH9K_RSSI_BAD &&
+		   !rxstats->rs_moreaggr)
+			ATH_RSSI_LPF(an->last_rssi, rxstats->rs_rssi);
 		last_rssi = an->last_rssi;
 	}
 	rcu_read_unlock();
 
 	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		ds->ds_rxstat.rs_rssi = ATH_EP_RND(last_rssi,
-					ATH_RSSI_EP_MULTIPLIER);
-	if (ds->ds_rxstat.rs_rssi < 0)
-		ds->ds_rxstat.rs_rssi = 0;
-	else if (ds->ds_rxstat.rs_rssi > 127)
-		ds->ds_rxstat.rs_rssi = 127;
+		rxstats->rs_rssi = ATH_EP_RND(last_rssi,
+					      ATH_RSSI_EP_MULTIPLIER);
+	if (rxstats->rs_rssi < 0)
+		rxstats->rs_rssi = 0;
+	else if (rxstats->rs_rssi > 127)
+		rxstats->rs_rssi = 127;
 
 	/* Update Beacon RSSI, this is used by ANI. */
 	if (ieee80211_is_beacon(fc))
-		sc->sc_ah->stats.avgbrssi = ds->ds_rxstat.rs_rssi;
+		sc->sc_ah->stats.avgbrssi = rxstats->rs_rssi;
 
-	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
+	rx_status->mactime = ath_extend_tsf(sc, rxstats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->noise = sc->ani.noise_floor;
-	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + ds->ds_rxstat.rs_rssi;
-	rx_status->antenna = ds->ds_rxstat.rs_antenna;
+	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rxstats->rs_rssi;
+	rx_status->antenna = rxstats->rs_antenna;
 
 	/*
 	 * Theory for reporting quality:
@@ -251,9 +251,9 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	 *
 	 */
 	if (conf_is_ht(&hw->conf))
-		rx_status->qual =  ds->ds_rxstat.rs_rssi * 100 / 45;
+		rx_status->qual =  rxstats->rs_rssi * 100 / 45;
 	else
-		rx_status->qual =  ds->ds_rxstat.rs_rssi * 100 / 35;
+		rx_status->qual =  rxstats->rs_rssi * 100 / 35;
 
 	/* rssi can be more than 45 though, anything above that
 	 * should be considered at 100% */
@@ -658,6 +658,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 	struct ath_buf *bf;
 	struct ath_desc *ds;
+	struct ath_rx_status *rxstats;
 	struct sk_buff *skb = NULL, *requeue_skb;
 	struct ieee80211_rx_status rx_status;
 	struct ath_hw *ah = sc->sc_ah;
@@ -749,6 +750,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		hdr = (struct ieee80211_hdr *) skb->data;
 		hw = ath_get_virt_hw(sc, hdr);
+		rxstats = &ds->ds_rxstat;
 
 		/*
 		 * If we're asked to flush receive queue, directly
@@ -757,14 +759,14 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (flush)
 			goto requeue;
 
-		if (!ds->ds_rxstat.rs_datalen)
+		if (!rxstats->rs_datalen)
 			goto requeue;
 
 		/* The status portion of the descriptor could get corrupted. */
-		if (sc->rx.bufsize < ds->ds_rxstat.rs_datalen)
+		if (sc->rx.bufsize < rxstats->rs_datalen)
 			goto requeue;
 
-		if (!ath_rx_prepare(hw, skb, ds,
+		if (!ath_rx_prepare(hw, skb, rxstats,
 				    &rx_status, &decrypt_error, sc))
 			goto requeue;
 
@@ -784,7 +786,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				 sc->rx.bufsize,
 				 DMA_FROM_DEVICE);
 
-		skb_put(skb, ds->ds_rxstat.rs_datalen);
+		skb_put(skb, rxstats->rs_datalen);
 
 		/* see if any padding is done by the hw and remove it */
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -804,7 +806,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			skb_pull(skb, padsize);
 		}
 
-		keyix = ds->ds_rxstat.rs_keyix;
+		keyix = rxstats->rs_keyix;
 
 		if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
 			rx_status.flag |= RX_FLAG_DECRYPTED;
@@ -844,7 +846,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 */
 		if (sc->rx.defant != ds->ds_rxstat.rs_antenna) {
 			if (++sc->rx.rxotherant >= 3)
-				ath_setdefantenna(sc, ds->ds_rxstat.rs_antenna);
+				ath_setdefantenna(sc, rxstats->rs_antenna);
 		} else {
 			sc->rx.rxotherant = 0;
 		}
-- 
1.6.5.2.143.g8cc62

