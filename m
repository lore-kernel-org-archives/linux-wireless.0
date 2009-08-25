Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3182 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZHYDBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 23:01:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/4] ath5k: use the skb->cb directly for RX status
Date: Mon, 24 Aug 2009 23:00:32 -0400
Message-Id: <1251169233-24169-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Save a memcpy by just storing updates directly in the skb
control block.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   41 +++++++++++++++++----------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c4adf98..10bf015 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1741,7 +1741,7 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
-	struct ieee80211_rx_status rxs = {};
+	struct ieee80211_rx_status *rxs;
 	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
@@ -1751,6 +1751,7 @@ ath5k_tasklet_rx(unsigned long data)
 	int ret;
 	int hdrlen;
 	int padsize;
+	int rx_flag;
 
 	spin_lock(&sc->rxbuflock);
 	if (list_empty(&sc->rxbuf)) {
@@ -1758,7 +1759,7 @@ ath5k_tasklet_rx(unsigned long data)
 		goto unlock;
 	}
 	do {
-		rxs.flag = 0;
+		rx_flag = 0;
 
 		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
 		BUG_ON(bf->skb == NULL);
@@ -1802,7 +1803,7 @@ ath5k_tasklet_rx(unsigned long data)
 					goto accept;
 			}
 			if (rs.rs_status & AR5K_RXERR_MIC) {
-				rxs.flag |= RX_FLAG_MMIC_ERROR;
+				rx_flag |= RX_FLAG_MMIC_ERROR;
 				goto accept;
 			}
 
@@ -1840,6 +1841,7 @@ accept:
 			memmove(skb->data + padsize, skb->data, hdrlen);
 			skb_pull(skb, padsize);
 		}
+		rxs = IEEE80211_SKB_RXCB(skb);
 
 		/*
 		 * always extend the mac timestamp, since this information is
@@ -1861,41 +1863,40 @@ accept:
 		 * impossible to comply to that. This affects IBSS merge only
 		 * right now, so it's not too bad...
 		 */
-		rxs.mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
-		rxs.flag |= RX_FLAG_TSFT;
+		rxs->mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
+		rxs->flag = rx_flag | RX_FLAG_TSFT;
 
-		rxs.freq = sc->curchan->center_freq;
-		rxs.band = sc->curband->band;
+		rxs->freq = sc->curchan->center_freq;
+		rxs->band = sc->curband->band;
 
-		rxs.noise = sc->ah->ah_noise_floor;
-		rxs.signal = rxs.noise + rs.rs_rssi;
+		rxs->noise = sc->ah->ah_noise_floor;
+		rxs->signal = rxs->noise + rs.rs_rssi;
 
 		/* An rssi of 35 indicates you should be able use
 		 * 54 Mbps reliably. A more elaborate scheme can be used
 		 * here but it requires a map of SNR/throughput for each
 		 * possible mode used */
-		rxs.qual = rs.rs_rssi * 100 / 35;
+		rxs->qual = rs.rs_rssi * 100 / 35;
 
 		/* rssi can be more than 35 though, anything above that
 		 * should be considered at 100% */
-		if (rxs.qual > 100)
-			rxs.qual = 100;
+		if (rxs->qual > 100)
+			rxs->qual = 100;
 
-		rxs.antenna = rs.rs_antenna;
-		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
-		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
+		rxs->antenna = rs.rs_antenna;
+		rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
+		rxs->flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
 
-		if (rxs.rate_idx >= 0 && rs.rs_rate ==
-		    sc->curband->bitrates[rxs.rate_idx].hw_value_short)
-			rxs.flag |= RX_FLAG_SHORTPRE;
+		if (rxs->rate_idx >= 0 && rs.rs_rate ==
+		    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
+			rxs->flag |= RX_FLAG_SHORTPRE;
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
 		/* check beacons in IBSS mode */
 		if (sc->opmode == NL80211_IFTYPE_ADHOC)
-			ath5k_check_ibss_tsf(sc, skb, &rxs);
+			ath5k_check_ibss_tsf(sc, skb, rxs);
 
-		memcpy(IEEE80211_SKB_RXCB(skb), &rxs, sizeof(rxs));
 		ieee80211_rx(sc->hw, skb);
 
 		bf->skb = next_skb;
-- 
1.6.2.5


