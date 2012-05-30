Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35725 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2E3G5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 02:57:31 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3 1/2] ath6kl: Fix race in aggregation reorder logic
Date: Wed, 30 May 2012 12:27:11 +0530
Message-ID: <1338361032-6098-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120530_085743_387500_207ADCC5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are many places where tid data are accessed without
the lock (rxtid->lock), this can lead to a race condition
when the timeout handler for aggregatin reorder and the
receive function are getting executed at the same time.
Fix this race, but still there are races which can not
be fixed without rewriting the whole aggregation reorder
logic, for now fix the obvious ones.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V3 - Move lock outside of the loop, this looks simple and harmless
   - Fix FIXME on rxtid->lock, add comment on this lock.

 drivers/net/wireless/ath/ath6kl/core.h |   12 +++++++++---
 drivers/net/wireless/ath/ath6kl/txrx.c |   12 +++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b1bc6bc..d6005bd 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -273,9 +273,15 @@ struct rxtid {
 	struct sk_buff_head q;
 
 	/*
-	 * FIXME: No clue what this should protect. Apparently it should
-	 * protect some of the fields above but they are also accessed
-	 * without taking the lock.
+	 * lock mainly protects seq_next and hold_q. Movement of seq_next
+	 * needs to be protected between aggr_timeout() and
+	 * aggr_process_recv_frm(). hold_q will be holding the pending
+	 * reorder frames and it's access should also be protected.
+	 * Some of the other fields like hold_q_sz, win_sz and aggr are
+	 * initialized/reset when receiving addba/delba req, also while
+	 * deleting aggr state all the pending buffers are flushed before
+	 * resetting these fields, so there should not be any race in accessing
+	 * these fields.
 	 */
 	spinlock_t lock;
 };
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 67206ae..974c510 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1036,6 +1036,7 @@ static void aggr_deque_frms(struct aggr_info_conn *agg_conn, u8 tid,
 	rxtid = &agg_conn->rx_tid[tid];
 	stats = &agg_conn->stat[tid];
 
+	spin_lock_bh(&rxtid->lock);
 	idx = AGGR_WIN_IDX(rxtid->seq_next, rxtid->hold_q_sz);
 
 	/*
@@ -1054,8 +1055,6 @@ static void aggr_deque_frms(struct aggr_info_conn *agg_conn, u8 tid,
 	seq_end = seq_no ? seq_no : rxtid->seq_next;
 	idx_end = AGGR_WIN_IDX(seq_end, rxtid->hold_q_sz);
 
-	spin_lock_bh(&rxtid->lock);
-
 	do {
 		node = &rxtid->hold_q[idx];
 		if ((order == 1) && (!node->skb))
@@ -1127,11 +1126,13 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 		    ((end > extended_end) && (cur > extended_end) &&
 		     (cur < end))) {
 			aggr_deque_frms(agg_conn, tid, 0, 0);
+			spin_lock_bh(&rxtid->lock);
 			if (cur >= rxtid->hold_q_sz - 1)
 				rxtid->seq_next = cur - (rxtid->hold_q_sz - 1);
 			else
 				rxtid->seq_next = ATH6KL_MAX_SEQ_NO -
 						  (rxtid->hold_q_sz - 2 - cur);
+			spin_unlock_bh(&rxtid->lock);
 		} else {
 			/*
 			 * Dequeue only those frames that are outside the
@@ -1186,7 +1187,8 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 
 	if (agg_conn->timer_scheduled)
 		rxtid->progress = true;
-	else
+	else {
+		spin_lock_bh(&rxtid->lock);
 		for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
 			if (rxtid->hold_q[idx].skb) {
 				/*
@@ -1204,6 +1206,8 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 				break;
 			}
 		}
+		spin_unlock_bh(&rxtid->lock);
+	}
 
 	return is_queued;
 }
@@ -1626,6 +1630,7 @@ static void aggr_timeout(unsigned long arg)
 		rxtid = &aggr_conn->rx_tid[i];
 
 		if (rxtid->aggr && rxtid->hold_q) {
+			spin_lock_bh(&rxtid->lock);
 			for (j = 0; j < rxtid->hold_q_sz; j++) {
 				if (rxtid->hold_q[j].skb) {
 					aggr_conn->timer_scheduled = true;
@@ -1634,6 +1639,7 @@ static void aggr_timeout(unsigned long arg)
 					break;
 				}
 			}
+			spin_unlock_bh(&rxtid->lock);
 
 			if (j >= rxtid->hold_q_sz)
 				rxtid->timer_mon = false;
-- 
1.7.0.4

