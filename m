Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44389 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab2EYJzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 05:55:48 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Fix race in aggregation reorder logic
Date: Fri, 25 May 2012 15:25:52 +0530
Message-ID: <1337939753-14491-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120525_115552_373171_63B3B9CA)
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
 drivers/net/wireless/ath/ath6kl/txrx.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 67206ae..60723be 100644
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
@@ -1188,6 +1189,7 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 		rxtid->progress = true;
 	else
 		for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
+			spin_lock_bh(&rxtid->lock);
 			if (rxtid->hold_q[idx].skb) {
 				/*
 				 * There is a frame in the queue and no
@@ -1201,8 +1203,10 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 					   HZ * (AGGR_RX_TIMEOUT) / 1000));
 				rxtid->progress = false;
 				rxtid->timer_mon = true;
+				spin_unlock_bh(&rxtid->lock);
 				break;
 			}
+			spin_unlock_bh(&rxtid->lock);
 		}
 
 	return is_queued;
@@ -1627,12 +1631,15 @@ static void aggr_timeout(unsigned long arg)
 
 		if (rxtid->aggr && rxtid->hold_q) {
 			for (j = 0; j < rxtid->hold_q_sz; j++) {
+				spin_lock_bh(&rxtid->lock);
 				if (rxtid->hold_q[j].skb) {
 					aggr_conn->timer_scheduled = true;
 					rxtid->timer_mon = true;
 					rxtid->progress = false;
+					spin_unlock_bh(&rxtid->lock);
 					break;
 				}
+				spin_unlock_bh(&rxtid->lock);
 			}
 
 			if (j >= rxtid->hold_q_sz)
-- 
1.7.0.4

