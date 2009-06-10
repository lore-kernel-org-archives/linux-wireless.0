Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43290 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbZFJQ0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:26:20 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:26:24 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 7/7] ath9k: schedule aggregation regardless of queue depth
Date: Wed, 10 Jun 2009 21:55:32 +0530
Message-ID: <1244651133-6537-8-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1244651133-6537-7-git-send-email-senthilkumar@atheros.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-2-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-3-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-4-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-5-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-6-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-7-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

schedule aggregation regardless of queue depth. Also we shouldn't
remove holding descriptor from AC queue if it happens to be the
only descriptor.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 328391e..eda2458 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1113,8 +1113,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		if (tid->paused)
 			continue;
 
-		if ((txq->axq_depth % 2) == 0)
-			ath_tx_sched_aggr(sc, txq, tid);
+		ath_tx_sched_aggr(sc, txq, tid);
 
 		/*
 		 * add tid to round-robin queue if more frames
@@ -1957,19 +1956,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (bf->bf_stale) {
 			bf_held = bf;
 			if (list_is_last(&bf_held->list, &txq->axq_q)) {
-				txq->axq_link = NULL;
-				txq->axq_linkbuf = NULL;
 				spin_unlock_bh(&txq->axq_lock);
-
-				/*
-				 * The holding descriptor is the last
-				 * descriptor in queue. It's safe to remove
-				 * the last holding descriptor in BH context.
-				 */
-				spin_lock_bh(&sc->tx.txbuflock);
-				list_move_tail(&bf_held->list, &sc->tx.txbuf);
-				spin_unlock_bh(&sc->tx.txbuflock);
-
 				break;
 			} else {
 				bf = list_entry(bf_held->list.next,
-- 
1.6.0.4

