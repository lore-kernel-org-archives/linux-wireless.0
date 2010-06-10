Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:11 -0400
Message-Id: <20100610082230.576358639@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/23] mac80211: use RCU for RX aggregation
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently we allocate some memory for each RX
aggregation session and additionally keep a
flag indicating whether or not it is valid.
By using RCU to protect the pointer and making
sure that the memory is fully set up before it
becomes visible to the RX path, we can remove
the need for the bool that indicates validity,
as well as for locking on the RX path since it
is always synchronised against itself, and we
can guarantee that all other modifications are
done when the structure is not visible to the
RX path.

The net result is that since we remove locking
requirements from the RX path, we can in the
future use any kind of lock for the setup and
teardown code paths.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      |   70 ++++++++++++++++++++-------------------------
 net/mac80211/debugfs_sta.c |    6 +--
 net/mac80211/rx.c          |   34 +++++++++------------
 net/mac80211/sta_info.h    |   14 +++++++--
 4 files changed, 61 insertions(+), 63 deletions(-)

--- wireless-testing.orig/net/mac80211/sta_info.h	2010-06-09 17:21:05.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-06-09 17:21:11.000000000 +0200
@@ -102,8 +102,18 @@ struct tid_ampdu_tx {
  * @buf_size: buffer size for incoming A-MPDUs
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
+ * @rcu_head: RCU head used for freeing this struct
+ *
+ * This structure is protected by RCU and the per-station
+ * spinlock. Assignments to the array holding it must hold
+ * the spinlock, only the RX path can access it under RCU
+ * lock-free. The RX path, since it is single-threaded,
+ * can even modify the structure without locking since the
+ * only other modifications to it are done when the struct
+ * can not yet or no longer be found by the RX path.
  */
 struct tid_ampdu_rx {
+	struct rcu_head rcu_head;
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
@@ -118,8 +128,7 @@ struct tid_ampdu_rx {
 /**
  * struct sta_ampdu_mlme - STA aggregation information.
  *
- * @tid_active_rx: TID's state in Rx session state machine.
- * @tid_rx: aggregation info for Rx per TID
+ * @tid_rx: aggregation info for Rx per TID -- RCU protected
  * @tid_state_tx: TID's state in Tx session state machine.
  * @tid_tx: aggregation info for Tx per TID
  * @addba_req_num: number of times addBA request has been sent.
@@ -127,7 +136,6 @@ struct tid_ampdu_rx {
  */
 struct sta_ampdu_mlme {
 	/* rx */
-	bool tid_active_rx[STA_TID_NUM];
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
 	/* tx */
 	u8 tid_state_tx[STA_TID_NUM];
--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-09 17:20:49.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-09 17:21:11.000000000 +0200
@@ -19,25 +19,36 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
+static void ieee80211_free_tid_rx(struct rcu_head *h)
+{
+	struct tid_ampdu_rx *tid_rx =
+		container_of(h, struct tid_ampdu_rx, rcu_head);
+	int i;
+
+	for (i = 0; i < tid_rx->buf_size; i++)
+		dev_kfree_skb(tid_rx->reorder_buf[i]);
+	kfree(tid_rx->reorder_buf);
+	kfree(tid_rx->reorder_time);
+	kfree(tid_rx);
+}
+
 static void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 					    u16 initiator, u16 reason,
 					    bool from_timer)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
-	int i;
 
 	spin_lock_bh(&sta->lock);
 
-	/* check if TID is in operational state */
-	if (!sta->ampdu_mlme.tid_active_rx[tid]) {
+	tid_rx = sta->ampdu_mlme.tid_rx[tid];
+
+	if (!tid_rx) {
 		spin_unlock_bh(&sta->lock);
 		return;
 	}
 
-	sta->ampdu_mlme.tid_active_rx[tid] = false;
-
-	tid_rx = sta->ampdu_mlme.tid_rx[tid];
+	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], NULL);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
@@ -54,26 +65,12 @@ static void ___ieee80211_stop_rx_ba_sess
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
 				     tid, 0, reason);
 
-	/* free the reordering buffer */
-	for (i = 0; i < tid_rx->buf_size; i++) {
-		if (tid_rx->reorder_buf[i]) {
-			/* release the reordered frames */
-			dev_kfree_skb(tid_rx->reorder_buf[i]);
-			tid_rx->stored_mpdu_num--;
-			tid_rx->reorder_buf[i] = NULL;
-		}
-	}
-
-	/* free resources */
-	kfree(tid_rx->reorder_buf);
-	kfree(tid_rx->reorder_time);
-	sta->ampdu_mlme.tid_rx[tid] = NULL;
-
 	spin_unlock_bh(&sta->lock);
 
 	if (!from_timer)
 		del_timer_sync(&tid_rx->session_timer);
-	kfree(tid_rx);
+
+	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
 
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
@@ -214,7 +211,7 @@ void ieee80211_process_addba_request(str
 	/* examine state machine */
 	spin_lock_bh(&sta->lock);
 
-	if (sta->ampdu_mlme.tid_active_rx[tid]) {
+	if (sta->ampdu_mlme.tid_rx[tid]) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "unexpected AddBA Req from "
@@ -225,9 +222,8 @@ void ieee80211_process_addba_request(str
 	}
 
 	/* prepare A-MPDU MLME for Rx aggregation */
-	sta->ampdu_mlme.tid_rx[tid] =
-			kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
-	if (!sta->ampdu_mlme.tid_rx[tid]) {
+	tid_agg_rx = kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
+	if (!tid_agg_rx) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_ERR "allocate rx mlme to tid %d failed\n",
@@ -235,14 +231,11 @@ void ieee80211_process_addba_request(str
 #endif
 		goto end;
 	}
-	/* rx timer */
-	sta->ampdu_mlme.tid_rx[tid]->session_timer.function =
-				sta_rx_agg_session_timer_expired;
-	sta->ampdu_mlme.tid_rx[tid]->session_timer.data =
-				(unsigned long)&sta->timer_to_tid[tid];
-	init_timer(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
 
-	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
+	/* rx timer */
+	tid_agg_rx->session_timer.function = sta_rx_agg_session_timer_expired;
+	tid_agg_rx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&tid_agg_rx->session_timer);
 
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
@@ -257,8 +250,7 @@ void ieee80211_process_addba_request(str
 #endif
 		kfree(tid_agg_rx->reorder_buf);
 		kfree(tid_agg_rx->reorder_time);
-		kfree(sta->ampdu_mlme.tid_rx[tid]);
-		sta->ampdu_mlme.tid_rx[tid] = NULL;
+		kfree(tid_agg_rx);
 		goto end;
 	}
 
@@ -270,13 +262,12 @@ void ieee80211_process_addba_request(str
 
 	if (ret) {
 		kfree(tid_agg_rx->reorder_buf);
+		kfree(tid_agg_rx->reorder_time);
 		kfree(tid_agg_rx);
-		sta->ampdu_mlme.tid_rx[tid] = NULL;
 		goto end;
 	}
 
-	/* change state and send addba resp */
-	sta->ampdu_mlme.tid_active_rx[tid] = true;
+	/* update data */
 	tid_agg_rx->dialog_token = dialog_token;
 	tid_agg_rx->ssn = start_seq_num;
 	tid_agg_rx->head_seq_num = start_seq_num;
@@ -284,6 +275,9 @@ void ieee80211_process_addba_request(str
 	tid_agg_rx->timeout = timeout;
 	tid_agg_rx->stored_mpdu_num = 0;
 	status = WLAN_STATUS_SUCCESS;
+
+	/* activate it for RX */
+	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
 end:
 	spin_unlock_bh(&sta->lock);
 
--- wireless-testing.orig/net/mac80211/rx.c	2010-06-09 17:21:10.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-06-09 17:21:11.000000000 +0200
@@ -719,16 +719,13 @@ static void ieee80211_rx_reorder_ampdu(s
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
-	spin_lock(&sta->lock);
-
-	if (!sta->ampdu_mlme.tid_active_rx[tid])
-		goto dont_reorder_unlock;
-
-	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
+	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
+	if (!tid_agg_rx)
+		goto dont_reorder;
 
 	/* qos null data frames are excluded */
 	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
-		goto dont_reorder_unlock;
+		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
 
@@ -740,20 +737,22 @@ static void ieee80211_rx_reorder_ampdu(s
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		spin_unlock(&sta->lock);
 		skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
 		skb_queue_tail(&rx->sdata->skb_queue, skb);
 		ieee80211_queue_work(&local->hw, &rx->sdata->work);
 		return;
 	}
 
-	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames)) {
-		spin_unlock(&sta->lock);
+	/*
+	 * No locking needed -- we will only ever process one
+	 * RX packet at a time, and thus own tid_agg_rx. All
+	 * other code manipulating it needs to (and does) make
+	 * sure that we cannot get to it any more before doing
+	 * anything with it.
+	 */
+	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames))
 		return;
-	}
 
- dont_reorder_unlock:
-	spin_unlock(&sta->lock);
  dont_reorder:
 	__skb_queue_tail(frames, skb);
 }
@@ -1830,13 +1829,11 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 				  &bar_data, sizeof(bar_data)))
 			return RX_DROP_MONITOR;
 
-		spin_lock(&rx->sta->lock);
 		tid = le16_to_cpu(bar_data.control) >> 12;
-		if (!rx->sta->ampdu_mlme.tid_active_rx[tid]) {
-			spin_unlock(&rx->sta->lock);
+
+		tid_agg_rx = rcu_dereference(rx->sta->ampdu_mlme.tid_rx[tid]);
+		if (!tid_agg_rx)
 			return RX_DROP_MONITOR;
-		}
-		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
 		start_seq_num = le16_to_cpu(bar_data.start_seq_num) >> 4;
 
@@ -1849,7 +1846,6 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num,
 						 frames);
 		kfree_skb(skb);
-		spin_unlock(&rx->sta->lock);
 		return RX_QUEUED;
 	}
 
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-06-09 17:20:49.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-06-09 17:21:11.000000000 +0200
@@ -125,12 +125,12 @@ static ssize_t sta_agg_status_read(struc
 	for (i = 0; i < STA_TID_NUM; i++) {
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
-				sta->ampdu_mlme.tid_active_rx[i]);
+				!!sta->ampdu_mlme.tid_rx[i]);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
-				sta->ampdu_mlme.tid_active_rx[i] ?
+				sta->ampdu_mlme.tid_rx[i] ?
 				sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
-				sta->ampdu_mlme.tid_active_rx[i] ?
+				sta->ampdu_mlme.tid_rx[i] ?
 				sta->ampdu_mlme.tid_rx[i]->ssn : 0);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",


