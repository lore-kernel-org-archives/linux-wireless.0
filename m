Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37296 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358AbaD1QcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 12:32:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.15] ath9k: remove tid->paused flag
Date: Mon, 28 Apr 2014 18:32:12 +0200
Message-Id: <1398702732-77789-1-git-send-email-nbd@openwrt.org> (sfid-20140428_183228_311486_17B63379)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some corner cases where the driver could get stuck with a full
tid queue that is paused, leading to a software tx queue hang.

Since the tx queueing rework, pausing per-tid queues on aggregation
session setup is no longer necessary. The driver will assign sequence
numbers to buffered frames when a new session is established, in order
to get the correct starting sequence number.

mac80211 prevents new frames from entering the queue during setup.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/xmit.c  | 14 +-------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 05935f6..33a2ae7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -254,7 +254,6 @@ struct ath_atx_tid {
 
 	s8 bar_index;
 	bool sched;
-	bool paused;
 	bool active;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 87cbec4..66acb2c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -107,9 +107,6 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 {
 	struct ath_atx_ac *ac = tid->ac;
 
-	if (tid->paused)
-		return;
-
 	if (tid->sched)
 		return;
 
@@ -1407,7 +1404,6 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	ath_tx_tid_change_state(sc, txtid);
 
 	txtid->active = true;
-	txtid->paused = true;
 	*ssn = txtid->seq_start = txtid->seq_next;
 	txtid->bar_index = -1;
 
@@ -1427,7 +1423,6 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 
 	ath_txq_lock(sc, txq);
 	txtid->active = false;
-	txtid->paused = false;
 	ath_tx_flush_tid(sc, txtid);
 	ath_tx_tid_change_state(sc, txtid);
 	ath_txq_unlock_complete(sc, txq);
@@ -1487,7 +1482,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 		ath_txq_lock(sc, txq);
 		ac->clear_ps_filter = true;
 
-		if (!tid->paused && ath_tid_has_buffered(tid)) {
+		if (ath_tid_has_buffered(tid)) {
 			ath_tx_queue_tid(txq, tid);
 			ath_txq_schedule(sc, txq);
 		}
@@ -1510,7 +1505,6 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta,
 	ath_txq_lock(sc, txq);
 
 	tid->baw_size = IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
-	tid->paused = false;
 
 	if (ath_tid_has_buffered(tid)) {
 		ath_tx_queue_tid(txq, tid);
@@ -1544,8 +1538,6 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			continue;
 
 		tid = ATH_AN_2_TID(an, i);
-		if (tid->paused)
-			continue;
 
 		ath_txq_lock(sc, tid->ac->txq);
 		while (nframes > 0) {
@@ -1844,9 +1836,6 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 			list_del(&tid->list);
 			tid->sched = false;
 
-			if (tid->paused)
-				continue;
-
 			if (ath_tx_sched_aggr(sc, txq, tid, &stop))
 				sent = true;
 
@@ -2698,7 +2687,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_size  = WME_MAX_BA;
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->sched     = false;
-		tid->paused    = false;
 		tid->active	   = false;
 		__skb_queue_head_init(&tid->buf_q);
 		__skb_queue_head_init(&tid->retry_q);
-- 
1.8.5.2 (Apple Git-48)

