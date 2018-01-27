Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37976 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbeA0BKH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 20:10:07 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Print has_queued in debugfs.
Date: Fri, 26 Jan 2018 17:09:57 -0800
Message-Id: <1517015397-30957-1-git-send-email-greearb@candelatech.com> (sfid-20180127_021043_479335_9367C989)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The PAUSED field was never printed per tid.  Replace that
with has_queued, which might help someone track down strange
bugs related to aqm.

And, make tx-queue debug info show peer BSSID as well as vdev
MAC to aid debugging with multiple stations connected to the
same peer.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/debug_sta.c | 10 ++++++----
 drivers/net/wireless/ath/ath9k/xmit.c      |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index efc692e..a45f1f5 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -48,9 +48,10 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 			 an->mpdudensity);
 
 	len += scnprintf(buf + len, size - len,
-			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
+			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%9s\n",
 			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
-			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
+			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED",
+			 "HAS-QUED");
 
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
@@ -58,7 +59,7 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 		ath_txq_lock(sc, txq);
 		if (tid->active) {
 			len += scnprintf(buf + len, size - len,
-					 "%3d%11d%10d%10d%10d%10d%9d%6d\n",
+					 "%3d%11d%10d%10d%10d%10d%9d%6d%9d\n",
 					 tid->tidno,
 					 tid->seq_start,
 					 tid->seq_next,
@@ -66,7 +67,8 @@ static ssize_t read_file_node_aggr(struct file *file, char __user *user_buf,
 					 tid->baw_head,
 					 tid->baw_tail,
 					 tid->bar_index,
-					 !list_empty(&tid->list));
+					 !list_empty(&tid->list),
+					 tid->has_queued);
 		}
 		ath_txq_unlock(sc, txq);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 26bf9d4..c28f62f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -157,8 +157,9 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 	struct ath_atx_tid *tid = (struct ath_atx_tid *) queue->drv_priv;
 	struct ath_txq *txq = tid->txq;
 
-	ath_dbg(common, QUEUE, "Waking TX queue: %pM (%d)\n",
-		queue->sta ? queue->sta->addr : queue->vif->addr,
+	ath_dbg(common, QUEUE,
+		"Waking TX queue: sta-addr %pM vif: %pM (tid %d)\n",
+		queue->sta ? queue->sta->addr : NULL, queue->vif->addr,
 		tid->tidno);
 
 	ath_txq_lock(sc, txq);
-- 
2.4.11
