Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51231 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2EYKTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 06:19:24 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 2/2] ath6kl: Fix unstable downlink throughput
Date: Fri, 25 May 2012 15:49:18 +0530
Message-ID: <1337941158-14895-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120525_121926_639722_D639838E)
In-Reply-To: <1337941158-14895-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1337941158-14895-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is frequent downlink throughput drop to 0 when operating
at the signal level between -42dBm to -53dBm. This has been root
caused to the delay in releasing pending a-mpdu subframes in
reorder buffer. Right now the timeout value is 400ms, there
is also a race condition where timeout handler can be delayed
to run at an extra timeout interval. This patch reduces the
timout interval to reasonable 100ms and makes sure releasing
pending frames are not skipped in the timeout handler by removing
the flag (rxtid->progress) which can delay the timeout logic.

Reported-by: Yu Yanzhi <yanzhiy@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 - Fix code alignment

 drivers/net/wireless/ath/ath6kl/core.h |    3 +-
 drivers/net/wireless/ath/ath6kl/txrx.c |   43 ++++++++++++++-----------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b1bc6bc..a827bd7 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -215,7 +215,7 @@ enum ath6kl_hw_flags {
 
 #define AGGR_NUM_OF_FREE_NETBUFS    16
 
-#define AGGR_RX_TIMEOUT     400	/* in ms */
+#define AGGR_RX_TIMEOUT     100	/* in ms */
 
 #define WMI_TIMEOUT (2 * HZ)
 
@@ -264,7 +264,6 @@ struct skb_hold_q {
 
 struct rxtid {
 	bool aggr;
-	bool progress;
 	bool timer_mon;
 	u16 win_sz;
 	u16 seq_next;
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 60723be..a6ff890 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1186,28 +1186,26 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 	aggr_deque_frms(agg_conn, tid, 0, 1);
 
 	if (agg_conn->timer_scheduled)
-		rxtid->progress = true;
-	else
-		for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
-			spin_lock_bh(&rxtid->lock);
-			if (rxtid->hold_q[idx].skb) {
-				/*
-				 * There is a frame in the queue and no
-				 * timer so start a timer to ensure that
-				 * the frame doesn't remain stuck
-				 * forever.
-				 */
-				agg_conn->timer_scheduled = true;
-				mod_timer(&agg_conn->timer,
-					  (jiffies +
-					   HZ * (AGGR_RX_TIMEOUT) / 1000));
-				rxtid->progress = false;
-				rxtid->timer_mon = true;
-				spin_unlock_bh(&rxtid->lock);
-				break;
-			}
+		return is_queued;
+
+	for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
+		spin_lock_bh(&rxtid->lock);
+		if (rxtid->hold_q[idx].skb) {
+			/*
+			 * There is a frame in the queue and no
+			 * timer so start a timer to ensure that
+			 * the frame doesn't remain stuck
+			 * forever.
+			 */
+			agg_conn->timer_scheduled = true;
+			mod_timer(&agg_conn->timer,
+				  (jiffies + HZ * (AGGR_RX_TIMEOUT) / 1000));
+			rxtid->timer_mon = true;
 			spin_unlock_bh(&rxtid->lock);
+			break;
 		}
+		spin_unlock_bh(&rxtid->lock);
+	}
 
 	return is_queued;
 }
@@ -1612,7 +1610,7 @@ static void aggr_timeout(unsigned long arg)
 		rxtid = &aggr_conn->rx_tid[i];
 		stats = &aggr_conn->stat[i];
 
-		if (!rxtid->aggr || !rxtid->timer_mon || rxtid->progress)
+		if (!rxtid->aggr || !rxtid->timer_mon)
 			continue;
 
 		stats->num_timeouts++;
@@ -1635,7 +1633,6 @@ static void aggr_timeout(unsigned long arg)
 				if (rxtid->hold_q[j].skb) {
 					aggr_conn->timer_scheduled = true;
 					rxtid->timer_mon = true;
-					rxtid->progress = false;
 					spin_unlock_bh(&rxtid->lock);
 					break;
 				}
@@ -1667,7 +1664,6 @@ static void aggr_delete_tid_state(struct aggr_info_conn *aggr_conn, u8 tid)
 		aggr_deque_frms(aggr_conn, tid, 0, 0);
 
 	rxtid->aggr = false;
-	rxtid->progress = false;
 	rxtid->timer_mon = false;
 	rxtid->win_sz = 0;
 	rxtid->seq_next = 0;
@@ -1746,7 +1742,6 @@ void aggr_conn_init(struct ath6kl_vif *vif, struct aggr_info *aggr_info,
 	for (i = 0; i < NUM_OF_TIDS; i++) {
 		rxtid = &aggr_conn->rx_tid[i];
 		rxtid->aggr = false;
-		rxtid->progress = false;
 		rxtid->timer_mon = false;
 		skb_queue_head_init(&rxtid->q);
 		spin_lock_init(&rxtid->lock);
-- 
1.7.0.4

