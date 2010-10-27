Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36019 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0J0APJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 20:15:09 -0400
Message-ID: <4CC76F09.3010509@openwrt.org>
Date: Wed, 27 Oct 2010 02:15:05 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: fix tx aggregation flush on AR9003
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Completing aggregate frames can lead to new buffers being pushed into
the tid queues due to software retransmission.
When the tx queues are being drained, all pending aggregates must be
completed before the tid queues get drained, otherwise buffers might be
leaked.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1089,15 +1089,6 @@ void ath_draintxq(struct ath_softc *sc, 
 	txq->axq_tx_inprogress = false;
 	spin_unlock_bh(&txq->axq_lock);
 
-	/* flush any pending frames if aggregation is enabled */
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		if (!retry_tx) {
-			spin_lock_bh(&txq->axq_lock);
-			ath_txq_drain_pending_buffers(sc, txq);
-			spin_unlock_bh(&txq->axq_lock);
-		}
-	}
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		spin_lock_bh(&txq->axq_lock);
 		while (!list_empty(&txq->txq_fifo_pending)) {
@@ -1118,6 +1109,15 @@ void ath_draintxq(struct ath_softc *sc, 
 		}
 		spin_unlock_bh(&txq->axq_lock);
 	}
+
+	/* flush any pending frames if aggregation is enabled */
+	if (sc->sc_flags & SC_OP_TXAGGR) {
+		if (!retry_tx) {
+			spin_lock_bh(&txq->axq_lock);
+			ath_txq_drain_pending_buffers(sc, txq);
+			spin_unlock_bh(&txq->axq_lock);
+		}
+	}
 }
 
 void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
