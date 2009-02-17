Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26076 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZBQKKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 05:10:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 02:10:20 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18842.35881.598326.462081@gargle.gargle.HOWL> (sfid-20090217_111028_453823_5EE3373C)
Date: Tue, 17 Feb 2009 15:36:33 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/4] ath9k: Remove ath_txq_depth and get the queue depth directly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3f70b1e..84fd3ee 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -772,11 +772,6 @@ bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 /* Queue Management */
 /********************/
 
-static u32 ath_txq_depth(struct ath_softc *sc, int qnum)
-{
-	return sc->tx.txq[qnum].axq_depth;
-}
-
 static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
 				 struct ath_beacon_config *conf)
 {
@@ -1657,7 +1652,7 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		 * we will at least have to run TX completionon one buffer
 		 * on the queue */
 		spin_lock_bh(&txq->axq_lock);
-		if (ath_txq_depth(sc, txq->axq_qnum) > 1) {
+		if (sc->tx.txq[txq->axq_qnum].axq_depth > 1) {
 			ieee80211_stop_queue(sc->hw,
 				skb_get_queue_mapping(skb));
 			txq->stopped = 1;
@@ -1867,7 +1862,7 @@ static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&txq->axq_lock);
 	if (txq->stopped &&
-	    ath_txq_depth(sc, txq->axq_qnum) <= (ATH_TXBUF - 20)) {
+	    sc->tx.txq[txq->axq_qnum].axq_depth <= (ATH_TXBUF - 20)) {
 		qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
 		if (qnum != -1) {
 			ieee80211_wake_queue(sc->hw, qnum);
-- 
1.6.1

