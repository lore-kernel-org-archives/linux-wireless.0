Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:43664 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaGMKSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:18:33 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so2899306wes.7
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 03:18:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [RFCv2 06/10] ath9k: add sampling methods for (tx|rx) timestamp
Date: Sun, 13 Jul 2014 12:18:20 +0200
Message-Id: <1405246704-7489-7-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140713_121847_910951_867F2021)
In-Reply-To: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sampling methods for ack RX timestamp in ath_rx_tasklet() and for TX frame
timestamp in ath_tx_complete_aggr() and in ath_tx_process_buffer()

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 5 +++++
 drivers/net/wireless/ath/ath9k/xmit.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 74ab1d0..ad317a4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -991,6 +991,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	unsigned long flags;
 	dma_addr_t new_buf_addr;
 	unsigned int budget = 512;
+	struct ieee80211_hdr *hdr;
 
 	if (edma)
 		dma_type = DMA_BIDIRECTIONAL;
@@ -1120,6 +1121,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 		ath_debug_rate_stats(sc, &rs, skb);
 
+		hdr = (struct ieee80211_hdr *)skb->data;
+		if (ieee80211_is_ack(hdr->frame_control))
+			ath_dynack_sample_ack_ts(sc->sc_ah, skb, rs.rs_tstamp);
+
 		ieee80211_rx(hw, skb);
 
 requeue_drop_frag:
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d4927c9..9497ed7 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -588,6 +588,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				memcpy(tx_info->control.rates, rates, sizeof(rates));
 				ath_tx_rc_status(sc, bf, ts, nframes, nbad, txok);
 				rc_update = false;
+				if (bf == bf->bf_lastbf)
+					ath_dynack_sample_tx_ts(sc->sc_ah,
+								bf->bf_mpdu,
+								ts);
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
@@ -688,6 +692,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 			memcpy(info->control.rates, bf->rates,
 			       sizeof(info->control.rates));
 			ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
+			ath_dynack_sample_tx_ts(sc->sc_ah, bf->bf_mpdu, ts);
 		}
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
-- 
1.9.1

