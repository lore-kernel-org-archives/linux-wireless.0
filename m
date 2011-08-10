Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37649 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab1HJVXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 17:23:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: avoid sending a-mpdu packets to sleeping stations
Date: Wed, 10 Aug 2011 15:23:35 -0600
Message-Id: <1313011415-95547-1-git-send-email-nbd@openwrt.org> (sfid-20110810_232351_193574_5DF0506C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver gets a tx status report for an A-MPDU sent to a station that
just went to sleep, that leaves a race condition where this tx status can
trigger another A-MPDU transmission.
To fix this, check if the station is sleeping before queueing the tid.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e815e82..e1d1e90 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -551,7 +551,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		if (clear_filter)
 			tid->ac->clear_ps_filter = true;
 		list_splice(&bf_pending, &tid->buf_q);
-		ath_tx_queue_tid(txq, tid);
+		if (!an->sleeping)
+			ath_tx_queue_tid(txq, tid);
 		spin_unlock_bh(&txq->axq_lock);
 	}
 
@@ -1413,7 +1414,8 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		 */
 		TX_STAT_INC(txctl->txq->axq_qnum, a_queued_sw);
 		list_add_tail(&bf->list, &tid->buf_q);
-		ath_tx_queue_tid(txctl->txq, tid);
+		if (!txctl->an || !txctl->an->sleeping)
+			ath_tx_queue_tid(txctl->txq, tid);
 		return;
 	}
 
-- 
1.7.3.2

