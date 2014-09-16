Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53316 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbaIPANY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:24 -0400
Received: by mail-wi0-f172.google.com with SMTP id e4so5291200wiv.5
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:23 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 06/10] ath9k: add sampling methods for (tx|rx) timestamp
Date: Tue, 16 Sep 2014 02:13:12 +0200
Message-Id: <1410826396-15544-7-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021331_125539_66972095)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sampling methods for ACK RX timestamp in ath_rx_tasklet() and for TX frame
timestamp in ath_tx_complete_aggr() and in ath_tx_process_buffer(). These
samples will be used in dynack processing for ACK timeout estimation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 5 +++++
 drivers/net/wireless/ath/ath9k/xmit.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0b53b74..66c5fe8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1007,6 +1007,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	unsigned long flags;
 	dma_addr_t new_buf_addr;
 	unsigned int budget = 512;
+	struct ieee80211_hdr *hdr;
 
 	if (edma)
 		dma_type = DMA_BIDIRECTIONAL;
@@ -1136,6 +1137,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 		ath_debug_rate_stats(sc, &rs, skb);
 
+		hdr = (struct ieee80211_hdr *)skb->data;
+		if (ieee80211_is_ack(hdr->frame_control))
+			ath_dynack_sample_ack_ts(sc->sc_ah, skb, rs.rs_tstamp);
+
 		ieee80211_rx(hw, skb);
 
 requeue_drop_frag:
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2819866..93ad31b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -587,6 +587,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				memcpy(tx_info->control.rates, rates, sizeof(rates));
 				ath_tx_rc_status(sc, bf, ts, nframes, nbad, txok);
 				rc_update = false;
+				if (bf == bf->bf_lastbf)
+					ath_dynack_sample_tx_ts(sc->sc_ah,
+								bf->bf_mpdu,
+								ts);
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
@@ -687,6 +691,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 			memcpy(info->control.rates, bf->rates,
 			       sizeof(info->control.rates));
 			ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
+			ath_dynack_sample_tx_ts(sc->sc_ah, bf->bf_mpdu, ts);
 		}
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
-- 
1.9.1

