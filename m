Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34894 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYLVLCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 06:02:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 03:02:08 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: Fix incorrect sequence numbering for unaggregated QoS Frame.
Date: Mon, 22 Dec 2008 16:31:58 +0530
Message-ID: <1229943718-5461-1-git-send-email-senthilkumar@atheros.com> (sfid-20081222_120214_000416_9AD78048)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an issue with the sequence numbers of unaggregated
QoS frames, because of which the frames are handled in a different order
at the AP and resulted in MLME REPLAYFAILURE.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   38 ++++++++++++++++--------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3bfc3b9..1ea9428 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -264,25 +264,22 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	}
 
 	/* Get seqno */
-
-	if (ieee80211_is_data(fc) && !is_pae(skb)) {
-		/* For HT capable stations, we save tidno for later use.
-		 * We also override seqno set by upper layer with the one
-		 * in tx aggregation state.
-		 *
-		 * If fragmentation is on, the sequence number is
-		 * not overridden, since it has been
-		 * incremented by the fragmentation routine.
-		 *
-		 * FIXME: check if the fragmentation threshold exceeds
-		 * IEEE80211 max.
-		 */
-		tid = ATH_AN_2_TID(an, bf->bf_tidno);
-		hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
-					    IEEE80211_SEQ_SEQ_SHIFT);
-		bf->bf_seqno = tid->seq_next;
-		INCR(tid->seq_next, IEEE80211_SEQ_MAX);
-	}
+	/* For HT capable stations, we save tidno for later use.
+	 * We also override seqno set by upper layer with the one
+	 * in tx aggregation state.
+	 *
+	 * If fragmentation is on, the sequence number is
+	 * not overridden, since it has been
+	 * incremented by the fragmentation routine.
+	 *
+	 * FIXME: check if the fragmentation threshold exceeds
+	 * IEEE80211 max.
+	 */
+	tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
+			IEEE80211_SEQ_SEQ_SHIFT);
+	bf->bf_seqno = tid->seq_next;
+	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
 
 static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
@@ -1718,11 +1715,10 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 
 	/* Assign seqno, tidno */
 
-	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR))
+	if (ieee80211_is_data_qos(fc) && (sc->sc_flags & SC_OP_TXAGGR))
 		assign_aggr_tid_seqno(skb, bf);
 
 	/* DMA setup */
-
 	bf->bf_mpdu = skb;
 
 	bf->bf_dmacontext = pci_map_single(sc->pdev, skb->data,
-- 
1.6.0.4

