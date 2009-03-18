Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63092 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZCRO4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 10:56:03 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 07:56:02 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix rate control update for aggregated frames
Date: Wed, 18 Mar 2009 20:22:00 +0530
Message-ID: <1237387920-10000-1-git-send-email-vasanth@atheros.com> (sfid-20090318_155605_702682_37FE764D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will miss rate control update if first A-MPDU of an
aggregation is not Block Acked as we always tell if the
rate control needs to updated through update_rc of first
A-MPDU. This patch does rate control update for the first
A-MPDU which notifies it's tx status (which is not
necessarily the first A-MPDU of an aggregation) to mac80211.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 8968abe..f287719 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -64,6 +64,10 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head);
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf);
+static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
+			      int txok);
+static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
+			     int nbad, int txok);
 
 /*********************/
 /* Aggregation logic */
@@ -274,9 +278,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
 	struct list_head bf_head, bf_pending;
-	u16 seq_st = 0;
+	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
-	int isaggr, txfail, txpending, sendbar = 0, needreset = 0;
+	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
+	bool rc_update = true;
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -316,6 +321,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	INIT_LIST_HEAD(&bf_pending);
 	INIT_LIST_HEAD(&bf_head);
 
+	nbad = ath_tx_num_badfrms(sc, bf, txok);
 	while (bf) {
 		txfail = txpending = 0;
 		bf_next = bf->bf_next;
@@ -323,8 +329,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf->bf_seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
+			acked_cnt++;
 		} else if (!isaggr && txok) {
 			/* transmit completion */
+			acked_cnt++;
 		} else {
 			if (!(tid->state & AGGR_CLEANUP) &&
 			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
@@ -335,6 +343,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 					bf->bf_state.bf_type |= BUF_XRETRY;
 					txfail = 1;
 					sendbar = 1;
+					txfail_cnt++;
 				}
 			} else {
 				/*
@@ -361,6 +370,11 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 			spin_unlock_bh(&txq->axq_lock);
 
+			if (rc_update)
+				if (acked_cnt == 1 || txfail_cnt == 1) {
+					ath_tx_rc_status(bf, ds, nbad, txok);
+					rc_update = false;
+				}
 			ath_tx_complete_buf(sc, bf, &bf_head, !txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
@@ -1901,7 +1915,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_buf *bf, *lastbf, *bf_held = NULL;
 	struct list_head bf_head;
 	struct ath_desc *ds;
-	int txok, nbad = 0;
+	int txok;
 	int status;
 
 	DPRINTF(sc, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
@@ -1995,13 +2009,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			bf->bf_retries = ds->ds_txstat.ts_longretry;
 			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-			nbad = 0;
-		} else {
-			nbad = ath_tx_num_badfrms(sc, bf, txok);
+			ath_tx_rc_status(bf, ds, 0, txok);
 		}
 
-		ath_tx_rc_status(bf, ds, nbad, txok);
-
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, txok);
 		else
-- 
1.5.5.1

