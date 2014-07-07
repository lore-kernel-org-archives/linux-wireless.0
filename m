Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46799 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaGGJbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:55 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so1367755wgh.6
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:53 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 06/10] ath9k: add sampling methods for (tx|rx) timestamp
Date: Mon,  7 Jul 2014 11:31:42 +0200
Message-Id: <1404725506-9571-7-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113201_989602_6FCA880B)
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
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

