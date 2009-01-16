Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46737 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbZAPQMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:12:10 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:12:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45331.603420.153148@gargle.gargle.HOWL> (sfid-20090116_171218_128875_306098E5)
Date: Fri, 16 Jan 2009 21:38:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 7/9] ath9k: Handle holding descriptor in TX completion properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the current holding descriptor is the last one in the TX queue,
*and* it has been marked as STALE, then move it to the free list
and bail out, as it has already been processed.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 841bd9c..d7cec0f 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2082,16 +2082,23 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
 			bf_held = bf;
 			if (list_is_last(&bf_held->list, &txq->axq_q)) {
-				/* FIXME:
+				txq->axq_link = NULL;
+				txq->axq_linkbuf = NULL;
+				spin_unlock_bh(&txq->axq_lock);
+
+				/*
 				 * The holding descriptor is the last
 				 * descriptor in queue. It's safe to remove
 				 * the last holding descriptor in BH context.
 				 */
-				spin_unlock_bh(&txq->axq_lock);
+				spin_lock_bh(&sc->tx.txbuflock);
+				list_move_tail(&bf_held->list, &sc->tx.txbuf);
+				spin_unlock_bh(&sc->tx.txbuflock);
+
 				break;
 			} else {
 				bf = list_entry(bf_held->list.next,
-					struct ath_buf, list);
+						struct ath_buf, list);
 			}
 		}
 
@@ -2115,24 +2122,20 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 */
 		lastbf->bf_status |= ATH_BUFSTATUS_STALE;
 		INIT_LIST_HEAD(&bf_head);
-
 		if (!list_is_singular(&lastbf->list))
 			list_cut_position(&bf_head,
 				&txq->axq_q, lastbf->list.prev);
 
 		txq->axq_depth--;
-
 		if (bf_isaggr(bf))
 			txq->axq_aggr_depth--;
 
 		txok = (ds->ds_txstat.ts_status == 0);
-
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_held) {
-			list_del(&bf_held->list);
 			spin_lock_bh(&sc->tx.txbuflock);
-			list_add_tail(&bf_held->list, &sc->tx.txbuf);
+			list_move_tail(&bf_held->list, &sc->tx.txbuf);
 			spin_unlock_bh(&sc->tx.txbuflock);
 		}
 
-- 
1.6.0.3

