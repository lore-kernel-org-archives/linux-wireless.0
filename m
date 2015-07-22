Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:40680
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933841AbbGVLGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 07:06:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/3] ath9k: remove the sched field in struct ath_atx_tid
Date: Wed, 22 Jul 2015 13:06:14 +0200
Message-Id: <1437563174-94761-3-git-send-email-nbd@openwrt.org> (sfid-20150722_130621_903145_055642EC)
In-Reply-To: <1437563174-94761-1-git-send-email-nbd@openwrt.org>
References: <1437563174-94761-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_empty(&tid->list) instead

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/xmit.c  | 23 ++++++++---------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 14e0ecc..7ef1be6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -245,7 +245,6 @@ struct ath_atx_tid {
 	int baw_tail;   /* next unused tx buffer slot */
 
 	s8 bar_index;
-	bool sched;
 	bool active;
 	bool clear_ps_filter;
 };
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f7d6a85..3e3dac3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -113,12 +113,9 @@ static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
 	if (!ctx)
 		return;
 
-	if (tid->sched)
-		return;
-
-	tid->sched = true;
 	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
-	list_add_tail(&tid->list, list);
+	if (list_empty(&tid->list))
+		list_add_tail(&tid->list, list);
 }
 
 static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
@@ -1541,15 +1538,14 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 
 		ath_txq_lock(sc, txq);
 
-		if (!tid->sched) {
+		if (list_empty(&tid->list)) {
 			ath_txq_unlock(sc, txq);
 			continue;
 		}
 
 		buffered = ath_tid_has_buffered(tid);
 
-		tid->sched = false;
-		list_del(&tid->list);
+		list_del_init(&tid->list);
 
 		ath_txq_unlock(sc, txq);
 
@@ -1929,8 +1925,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 			break;
 
 		tid = list_first_entry(tid_list, struct ath_atx_tid, list);
-		list_del(&tid->list);
-		tid->sched = false;
+		list_del_init(&tid->list);
 
 		if (ath_tx_sched_aggr(sc, txq, tid, &stop))
 			sent = true;
@@ -2848,11 +2843,11 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->seq_start = tid->seq_next = 0;
 		tid->baw_size  = WME_MAX_BA;
 		tid->baw_head  = tid->baw_tail = 0;
-		tid->sched     = false;
 		tid->active	   = false;
 		tid->clear_ps_filter = true;
 		__skb_queue_head_init(&tid->buf_q);
 		__skb_queue_head_init(&tid->retry_q);
+		INIT_LIST_HEAD(&tid->list);
 		acno = TID_TO_WME_AC(tidno);
 		tid->txq = sc->tx.txq_map[acno];
 	}
@@ -2871,10 +2866,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 
 		ath_txq_lock(sc, txq);
 
-		if (tid->sched) {
-			list_del(&tid->list);
-			tid->sched = false;
-		}
+		if (!list_empty(&tid->list))
+			list_del_init(&tid->list);
 
 		ath_tid_drain(sc, txq, tid);
 		tid->active = false;
-- 
2.2.2

