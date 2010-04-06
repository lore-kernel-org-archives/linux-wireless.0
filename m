Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0DFJWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:47 -0400
Message-Id: <20100406092141.913254265@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] mac80211: clean up/fix aggregation code
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The aggregation code has a number of quirks, like
inventing an unneeded WLAN_BACK_TIMER value and
leaking memory under certain circumstances during
station destruction. Fix these issues by using
the regular aggregation session teardown code and
blocking new aggregation sessions, all before the
station is really destructed.

As a side effect, this gets rid of the long code
block to destroy aggregation safely.

Additionally, rename tid_state_rx which can only
have the values IDLE and OPERATIONAL to
tid_active_rx to make it easier to understand
that there is no bitwise stuff going on on the
RX side -- the TX side remains because it needs
to keep track of the driver and peer states.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h  |    1 
 net/mac80211/agg-rx.c      |   48 ++++++++++++++++---------------------
 net/mac80211/debugfs_sta.c |   10 +++----
 net/mac80211/rx.c          |    5 +--
 net/mac80211/sta_info.c    |   58 +++++++--------------------------------------
 net/mac80211/sta_info.h    |    6 +---
 6 files changed, 40 insertions(+), 88 deletions(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2010-04-06 09:07:29.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2010-04-06 09:13:05.000000000 +0200
@@ -1324,7 +1324,6 @@ enum ieee80211_back_actioncode {
 enum ieee80211_back_parties {
 	WLAN_BACK_RECIPIENT = 0,
 	WLAN_BACK_INITIATOR = 1,
-	WLAN_BACK_TIMER = 2,
 };
 
 /* SA Query action */
--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-04-06 09:12:15.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-04-06 09:16:07.000000000 +0200
@@ -22,19 +22,20 @@ void __ieee80211_stop_rx_ba_session(stru
 				    u16 initiator, u16 reason)
 {
 	struct ieee80211_local *local = sta->local;
+	struct tid_ampdu_rx *tid_rx;
 	int i;
 
-	/* check if TID is in operational state */
 	spin_lock_bh(&sta->lock);
-	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL) {
+
+	/* check if TID is in operational state */
+	if (!sta->ampdu_mlme.tid_active_rx[tid]) {
 		spin_unlock_bh(&sta->lock);
 		return;
 	}
 
-	sta->ampdu_mlme.tid_state_rx[tid] =
-		HT_AGG_STATE_REQ_STOP_BA_MSK |
-		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
-	spin_unlock_bh(&sta->lock);
+	sta->ampdu_mlme.tid_active_rx[tid] = false;
+
+	tid_rx = sta->ampdu_mlme.tid_rx[tid];
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
@@ -46,37 +47,30 @@ void __ieee80211_stop_rx_ba_session(stru
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
-	/* shutdown timer has not expired */
-	if (initiator != WLAN_BACK_TIMER)
-		del_timer_sync(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
-
 	/* check if this is a self generated aggregation halt */
-	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
+	if (initiator == WLAN_BACK_RECIPIENT)
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
 				     tid, 0, reason);
 
 	/* free the reordering buffer */
-	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid]->buf_size; i++) {
-		if (sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]) {
+	for (i = 0; i < tid_rx->buf_size; i++) {
+		if (tid_rx->reorder_buf[i]) {
 			/* release the reordered frames */
-			dev_kfree_skb(sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]);
-			sta->ampdu_mlme.tid_rx[tid]->stored_mpdu_num--;
-			sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i] = NULL;
+			dev_kfree_skb(tid_rx->reorder_buf[i]);
+			tid_rx->stored_mpdu_num--;
+			tid_rx->reorder_buf[i] = NULL;
 		}
 	}
 
-	spin_lock_bh(&sta->lock);
 	/* free resources */
-	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
-	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_time);
-
-	if (!sta->ampdu_mlme.tid_rx[tid]->shutdown) {
-		kfree(sta->ampdu_mlme.tid_rx[tid]);
-		sta->ampdu_mlme.tid_rx[tid] = NULL;
-	}
+	kfree(tid_rx->reorder_buf);
+	kfree(tid_rx->reorder_time);
+	sta->ampdu_mlme.tid_rx[tid] = NULL;
 
-	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
 	spin_unlock_bh(&sta->lock);
+
+	del_timer_sync(&tid_rx->session_timer);
+	kfree(tid_rx);
 }
 
 /*
@@ -211,7 +205,7 @@ void ieee80211_process_addba_request(str
 	/* examine state machine */
 	spin_lock_bh(&sta->lock);
 
-	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_IDLE) {
+	if (sta->ampdu_mlme.tid_active_rx[tid]) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "unexpected AddBA Req from "
@@ -273,7 +267,7 @@ void ieee80211_process_addba_request(str
 	}
 
 	/* change state and send addba resp */
-	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_OPERATIONAL;
+	sta->ampdu_mlme.tid_active_rx[tid] = true;
 	tid_agg_rx->dialog_token = dialog_token;
 	tid_agg_rx->ssn = start_seq_num;
 	tid_agg_rx->head_seq_num = start_seq_num;
--- wireless-testing.orig/net/mac80211/rx.c	2010-04-06 09:12:15.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-04-06 09:19:08.000000000 +0200
@@ -720,7 +720,7 @@ static void ieee80211_rx_reorder_ampdu(s
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
-	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
+	if (!sta->ampdu_mlme.tid_active_rx[tid])
 		goto dont_reorder;
 
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
@@ -1804,8 +1804,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		if (!rx->sta)
 			return RX_DROP_MONITOR;
 		tid = le16_to_cpu(bar->control) >> 12;
-		if (rx->sta->ampdu_mlme.tid_state_rx[tid]
-					!= HT_AGG_STATE_OPERATIONAL)
+		if (!rx->sta->ampdu_mlme.tid_active_rx[tid])
 			return RX_DROP_MONITOR;
 		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-04-06 09:08:15.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-04-06 09:13:05.000000000 +0200
@@ -250,9 +250,6 @@ struct sta_info *sta_info_alloc(struct i
 		 * enable session_timer's data differentiation. refer to
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
-		/* rx */
-		sta->ampdu_mlme.tid_state_rx[i] = HT_AGG_STATE_IDLE;
-		sta->ampdu_mlme.tid_rx[i] = NULL;
 		/* tx */
 		sta->ampdu_mlme.tid_state_tx[i] = HT_AGG_STATE_IDLE;
 		sta->ampdu_mlme.tid_tx[i] = NULL;
@@ -619,7 +616,7 @@ static int __must_check __sta_info_destr
 	struct ieee80211_sub_if_data *sdata;
 	struct sk_buff *skb;
 	unsigned long flags;
-	int ret, i;
+	int ret;
 
 	might_sleep();
 
@@ -629,6 +626,15 @@ static int __must_check __sta_info_destr
 	local = sta->local;
 	sdata = sta->sdata;
 
+	/*
+	 * Before removing the station from the driver and
+	 * rate control, it might still start new aggregation
+	 * sessions -- block that to make sure the tear-down
+	 * will be sufficient.
+	 */
+	set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+	ieee80211_sta_tear_down_BA_sessions(sta);
+
 	spin_lock_irqsave(&local->sta_lock, flags);
 	ret = sta_info_hash_del(local, sta);
 	/* this might still be the pending list ... which is fine */
@@ -713,50 +719,6 @@ static int __must_check __sta_info_destr
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL)
 		dev_kfree_skb_any(skb);
 
-	for (i = 0; i <  STA_TID_NUM; i++) {
-		struct tid_ampdu_rx *tid_rx;
-		struct tid_ampdu_tx *tid_tx;
-
-		spin_lock_bh(&sta->lock);
-		tid_rx = sta->ampdu_mlme.tid_rx[i];
-		/* Make sure timer won't free the tid_rx struct, see below */
-		if (tid_rx)
-			tid_rx->shutdown = true;
-
-		spin_unlock_bh(&sta->lock);
-
-		/*
-		 * Outside spinlock - shutdown is true now so that the timer
-		 * won't free tid_rx, we have to do that now. Can't let the
-		 * timer do it because we have to sync the timer outside the
-		 * lock that it takes itself.
-		 */
-		if (tid_rx) {
-			del_timer_sync(&tid_rx->session_timer);
-			kfree(tid_rx);
-		}
-
-		/*
-		 * No need to do such complications for TX agg sessions, the
-		 * path leading to freeing the tid_tx struct goes via a call
-		 * from the driver, and thus needs to look up the sta struct
-		 * again, which cannot be found when we get here. Hence, we
-		 * just need to delete the timer and free the aggregation
-		 * info; we won't be telling the peer about it then but that
-		 * doesn't matter if we're not talking to it again anyway.
-		 */
-		tid_tx = sta->ampdu_mlme.tid_tx[i];
-		if (tid_tx) {
-			del_timer_sync(&tid_tx->addba_resp_timer);
-			/*
-			 * STA removed while aggregation session being
-			 * started? Bit odd, but purge frames anyway.
-			 */
-			skb_queue_purge(&tid_tx->pending);
-			kfree(tid_tx);
-		}
-	}
-
 	__sta_info_free(local, sta);
 
 	return 0;
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-04-06 09:09:49.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-04-06 09:13:05.000000000 +0200
@@ -36,7 +36,7 @@
  *	frame to this station is transmitted.
  * @WLAN_STA_MFP: Management frame protection is used with this STA.
  * @WLAN_STA_BLOCK_BA: Used to deny ADDBA requests (both TX and RX)
- *	during suspend/resume.
+ *	during suspend/resume and station removal.
  * @WLAN_STA_PS_DRIVER: driver requires keeping this station in
  *	power-save mode logically to flush frames that might still
  *	be in the queues
@@ -106,7 +106,6 @@ struct tid_ampdu_tx {
  * @buf_size: buffer size for incoming A-MPDUs
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
- * @shutdown: this session is being shut down due to STA removal
  */
 struct tid_ampdu_rx {
 	struct sk_buff **reorder_buf;
@@ -118,7 +117,6 @@ struct tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u8 dialog_token;
-	bool shutdown;
 };
 
 /**
@@ -156,7 +154,7 @@ enum plink_state {
  */
 struct sta_ampdu_mlme {
 	/* rx */
-	u8 tid_state_rx[STA_TID_NUM];
+	bool tid_active_rx[STA_TID_NUM];
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
 	/* tx */
 	u8 tid_state_tx[STA_TID_NUM];
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-04-06 09:07:29.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-04-06 09:13:05.000000000 +0200
@@ -119,7 +119,7 @@ STA_OPS(last_seq_ctrl);
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
-	char buf[64 + STA_TID_NUM * 40], *p = buf;
+	char buf[71 + STA_TID_NUM * 40], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
 
@@ -127,16 +127,16 @@ static ssize_t sta_agg_status_read(struc
 	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, sizeof(buf) + buf - p,
-		       "TID\t\tRX\tDTKN\tSSN\t\tTX\tDTKN\tSSN\tpending\n");
+		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tSSN\tpending\n");
 	for (i = 0; i < STA_TID_NUM; i++) {
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
-				sta->ampdu_mlme.tid_state_rx[i]);
+				sta->ampdu_mlme.tid_active_rx[i]);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
-				sta->ampdu_mlme.tid_state_rx[i] ?
+				sta->ampdu_mlme.tid_active_rx[i] ?
 				sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
-				sta->ampdu_mlme.tid_state_rx[i] ?
+				sta->ampdu_mlme.tid_active_rx[i] ?
 				sta->ampdu_mlme.tid_rx[i]->ssn : 0);
 
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",


