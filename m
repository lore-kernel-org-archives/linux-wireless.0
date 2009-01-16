Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46736 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbZAPQMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:12:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:12:08 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45329.521660.482423@gargle.gargle.HOWL> (sfid-20090116_171215_841030_3A4054D2)
Date: Fri, 16 Jan 2009 21:38:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/9] ath9k: Add a helper function to wake mac80211 queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index a29b998..841bd9c 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2031,6 +2031,22 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
 	}
 }
 
+static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
+{
+	int qnum;
+
+	spin_lock_bh(&txq->axq_lock);
+	if (txq->stopped &&
+	    ath_txq_depth(sc, txq->axq_qnum) <= (ATH_TXBUF - 20)) {
+		qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
+		if (qnum != -1) {
+			ieee80211_wake_queue(sc->hw, qnum);
+			txq->stopped = 0;
+		}
+	}
+	spin_unlock_bh(&txq->axq_lock);
+}
+
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hal *ah = sc->sc_ah;
@@ -2140,18 +2156,9 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
 
-		spin_lock_bh(&txq->axq_lock);
-		if (txq->stopped && ath_txq_depth(sc, txq->axq_qnum) <=
-				(ATH_TXBUF - 20)) {
-			int qnum;
-			qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
-			if (qnum != -1) {
-				ieee80211_wake_queue(sc->hw, qnum);
-				txq->stopped = 0;
-			}
-
-		}
+		ath_wake_mac80211_queue(sc, txq);
 
+		spin_lock_bh(&txq->axq_lock);
 		if (sc->sc_flags & SC_OP_TXAGGR)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
-- 
1.6.0.3

