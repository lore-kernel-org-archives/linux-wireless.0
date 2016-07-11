Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35637 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbcGKNEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 09:04:11 -0400
From: Felix Fietkau <nbd@nbd.name>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath9k-txq-work 1/2] ath9k: fix powersave wakeup
Date: Mon, 11 Jul 2016 15:04:04 +0200
Message-Id: <20160711130405.77451-1-nbd@nbd.name> (sfid-20160711_150415_101092_222D982B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drv_wake_tx_queue will only call into the driver if there are frames
pending in the mac80211 queue. the driver needs to take care of its own
queued frames

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b0a6fd2..b3521c3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1582,6 +1582,10 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 
 		ath_txq_lock(sc, txq);
 		tid->clear_ps_filter = true;
+		if (ath_tid_has_buffered(tid)) {
+			ath_tx_queue_tid(sc, txq, tid);
+			ath_txq_schedule(sc, txq);
+		}
 		ath_txq_unlock_complete(sc, txq);
 	}
 }
-- 
2.8.4

