Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46977 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939AbZAPQ27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:28:59 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:28:59 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.46332.994023.755266@gargle.gargle.HOWL> (sfid-20090116_172906_625360_E9A26EF9)
Date: Fri, 16 Jan 2009 21:55:32 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/9] ath9k: Remove ath_tx_stopdma and call ath9k_hw_stoptxdma directly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 5e6e5cf..c9ead1b 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -877,12 +877,6 @@ static u32 ath_txq_depth(struct ath_softc *sc, int qnum)
 	return sc->tx.txq[qnum].axq_depth;
 }
 
-static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	(void) ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-}
-
 static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
 				 struct ath_beacon_config *conf)
 {
@@ -899,15 +893,17 @@ static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
 static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
+	struct ath_txq *txq;
 	int i, npend = 0;
 
-	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (ATH_TXQ_SETUP(sc, i)) {
-				ath_tx_stopdma(sc, &sc->tx.txq[i]);
-				npend += ath9k_hw_numtxpending(ah,
-						       sc->tx.txq[i].axq_qnum);
-			}
+	if (sc->sc_flags & SC_OP_INVALID)
+		return;
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (ATH_TXQ_SETUP(sc, i)) {
+			txq = &sc->tx.txq[i];
+			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
+			npend += ath9k_hw_numtxpending(ah, txq->axq_qnum);
 		}
 	}
 
-- 
1.6.0.3

