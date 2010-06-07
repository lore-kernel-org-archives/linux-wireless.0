Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0FGLDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6x-0007CY-An
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:19 +0200
Message-Id: <20100607110201.616037360@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 14/21] mac80211: make TX aggregation start/stop request async
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver or rate control requests starting
or stopping an aggregation session, that currently
causes a direct callback into the driver, which
could potentially cause locking problems. Also,
the functions need to be callable from contexts
that cannot sleep, and thus will interfere with
making the ampdu_action callback sleeping.

To address these issues, add a new work item for
each station that will process any start or stop
requests out of line.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c      |  177 +++++++++++++++++++++++++++++++--------------
 net/mac80211/debugfs_sta.c |    5 -
 net/mac80211/ht.c          |    2 
 net/mac80211/ieee80211_i.h |    1 
 net/mac80211/sta_info.c    |    1 
 net/mac80211/sta_info.h    |    6 +
 net/mac80211/tx.c          |    5 +
 7 files changed, 139 insertions(+), 58 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-06 15:45:05.000000000 +0200
@@ -146,6 +146,13 @@ static int ___ieee80211_stop_tx_ba_sessi
 	if (WARN_ON(!tid_tx))
 		return -ENOENT;
 
+	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
+		/* not even started yet! */
+		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+		return 0;
+	}
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
 	       sta->sta.addr, tid);
@@ -255,6 +262,94 @@ ieee80211_wake_queue_agg(struct ieee8021
 	__release(agg_queue);
 }
 
+static void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
+{
+	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u16 start_seq_num;
+	int ret;
+
+	/*
+	 * While we're asking the driver about the aggregation,
+	 * stop the AC queue so that we don't have to worry
+	 * about frames that came in while we were doing that,
+	 * which would require us to put them to the AC pending
+	 * afterwards which just makes the code more complex.
+	 */
+	ieee80211_stop_queue_agg(local, tid);
+
+	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
+
+	/*
+	 * This might be off by one due to a race that we can't
+	 * really prevent here without synchronize_net() which
+	 * can't be called now.
+	 */
+	start_seq_num = sta->tid_seq[tid] >> 4;
+
+	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
+			       &sta->sta, tid, &start_seq_num);
+	if (ret) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - HW unavailable for"
+					" tid %d\n", tid);
+#endif
+		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
+		ieee80211_wake_queue_agg(local, tid);
+		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
+		return;
+	}
+
+	/* we can take packets again now */
+	ieee80211_wake_queue_agg(local, tid);
+
+	/* activate the timer for the recipient's addBA response */
+	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+#endif
+
+	sta->ampdu_mlme.addba_req_num[tid]++;
+
+	/* send AddBA request */
+	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
+				     tid_tx->dialog_token, start_seq_num,
+				     0x40, 5000);
+}
+
+void ieee80211_tx_ba_session_work(struct work_struct *work)
+{
+	struct sta_info *sta =
+		container_of(work, struct sta_info, ampdu_mlme.work);
+	struct tid_ampdu_tx *tid_tx;
+	int tid;
+
+	/*
+	 * When this flag is set, new sessions should be
+	 * blocked, and existing sessions will be torn
+	 * down by the code that set the flag, so this
+	 * need not run.
+	 */
+	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA))
+		return;
+
+	spin_lock_bh(&sta->lock);
+	for (tid = 0; tid < STA_TID_NUM; tid++) {
+		tid_tx = sta->ampdu_mlme.tid_tx[tid];
+		if (!tid_tx)
+			continue;
+
+		if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state))
+			ieee80211_tx_ba_session_handle_start(sta, tid);
+		else if (test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
+					    &tid_tx->state))
+			___ieee80211_stop_tx_ba_session(sta, tid,
+							WLAN_BACK_INITIATOR);
+	}
+	spin_unlock_bh(&sta->lock);
+}
+
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
@@ -262,7 +357,6 @@ int ieee80211_start_tx_ba_session(struct
 	struct ieee80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
-	u16 start_seq_num;
 
 	trace_api_start_tx_ba_session(pubsta, tid);
 
@@ -316,15 +410,6 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_unlock_sta;
 	}
 
-	/*
-	 * While we're asking the driver about the aggregation,
-	 * stop the AC queue so that we don't have to worry
-	 * about frames that came in while we were doing that,
-	 * which would require us to put them to the AC pending
-	 * afterwards which just makes the code more complex.
-	 */
-	ieee80211_stop_queue_agg(local, tid);
-
 	/* prepare A-MPDU MLME for Tx aggregation */
 	tid_tx = kzalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
 	if (!tid_tx) {
@@ -334,59 +419,27 @@ int ieee80211_start_tx_ba_session(struct
 					tid);
 #endif
 		ret = -ENOMEM;
-		goto err_wake_queue;
+		goto err_unlock_sta;
 	}
 
 	skb_queue_head_init(&tid_tx->pending);
+	__set_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
 	/* Tx timer */
 	tid_tx->addba_resp_timer.function = sta_addba_resp_timer_expired;
 	tid_tx->addba_resp_timer.data = (unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&tid_tx->addba_resp_timer);
 
-	start_seq_num = sta->tid_seq[tid] >> 4;
-
-	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       pubsta, tid, &start_seq_num);
-	if (ret) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - HW unavailable for"
-					" tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto err_free;
-	}
-
-	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
-
-	/* Driver vetoed or OKed, but we can take packets again now */
-	ieee80211_wake_queue_agg(local, tid);
-
-	/* activate the timer for the recipient's addBA response */
-	tid_tx->addba_resp_timer.expires = jiffies + ADDBA_RESP_INTERVAL;
-	add_timer(&tid_tx->addba_resp_timer);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
-#endif
-
-	/* prepare tid data */
+	/* assign a dialog token */
 	sta->ampdu_mlme.dialog_token_allocator++;
 	tid_tx->dialog_token = sta->ampdu_mlme.dialog_token_allocator;
-	tid_tx->ssn = start_seq_num;
 
-	sta->ampdu_mlme.addba_req_num[tid]++;
+	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
 
-	spin_unlock_bh(&sta->lock);
+	/* finally, assign it to the array */
+	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
 
-	/* send AddBA request */
-	ieee80211_send_addba_request(sdata, pubsta->addr, tid,
-			 tid_tx->dialog_token, tid_tx->ssn,
-			 0x40, 5000);
-	return 0;
-
- err_free:
-	kfree(tid_tx);
- err_wake_queue:
-	ieee80211_wake_queue_agg(local, tid);
+	/* this flow continues off the work */
  err_unlock_sta:
 	spin_unlock_bh(&sta->lock);
 	return ret;
@@ -534,8 +587,7 @@ int __ieee80211_stop_tx_ba_session(struc
 	spin_lock_bh(&sta->lock);
 	tid_tx = sta->ampdu_mlme.tid_tx[tid];
 
-	/* check if the TID is in aggregation */
-	if (!tid_tx || !test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+	if (!tid_tx) {
 		ret = -ENOENT;
 		goto unlock;
 	}
@@ -552,6 +604,8 @@ int ieee80211_stop_tx_ba_session(struct
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct tid_ampdu_tx *tid_tx;
+	int ret = 0;
 
 	trace_api_stop_tx_ba_session(pubsta, tid);
 
@@ -561,7 +615,26 @@ int ieee80211_stop_tx_ba_session(struct
 	if (tid >= STA_TID_NUM)
 		return -EINVAL;
 
-	return __ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
+	spin_lock_bh(&sta->lock);
+	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+
+	if (!tid_tx) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+
+	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+		/* already in progress stopping it */
+		ret = 0;
+		goto unlock;
+	}
+
+	set_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state);
+	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
+
+ unlock:
+	spin_unlock_bh(&sta->lock);
+	return ret;
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-06-06 15:45:34.000000000 +0200
@@ -67,6 +67,8 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_RESPONSE_RECEIVED	1
 #define HT_AGG_STATE_OPERATIONAL	2
 #define HT_AGG_STATE_STOPPING		3
+#define HT_AGG_STATE_WANT_START		4
+#define HT_AGG_STATE_WANT_STOP		5
 
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
@@ -74,7 +76,6 @@ enum ieee80211_sta_info_flags {
  * @rcu_head: rcu head for freeing structure
  * @addba_resp_timer: timer for peer's response to addba request
  * @pending: pending frames queue -- use sta's spinlock to protect
- * @ssn: Starting Sequence Number expected to be aggregated.
  * @dialog_token: dialog token for aggregation session
  * @state: session state (see above)
  * @stop_initiator: initiator of a session stop
@@ -92,7 +93,6 @@ struct tid_ampdu_tx {
 	struct timer_list addba_resp_timer;
 	struct sk_buff_head pending;
 	unsigned long state;
-	u16 ssn;
 	u8 dialog_token;
 	u8 stop_initiator;
 };
@@ -138,11 +138,13 @@ struct tid_ampdu_rx {
  * @tid_tx: aggregation info for Tx per TID
  * @addba_req_num: number of times addBA request has been sent.
  * @dialog_token_allocator: dialog token enumerator for each new session;
+ * @work: work struct for starting/stopping aggregation
  */
 struct sta_ampdu_mlme {
 	/* rx */
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
 	/* tx */
+	struct work_struct work;
 	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
 	u8 dialog_token_allocator;
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-06-06 15:30:23.000000000 +0200
@@ -121,7 +121,7 @@ static ssize_t sta_agg_status_read(struc
 	p += scnprintf(p, sizeof(buf) + buf - p, "next dialog_token: %#02x\n",
 			sta->ampdu_mlme.dialog_token_allocator + 1);
 	p += scnprintf(p, sizeof(buf) + buf - p,
-		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tSSN\tpending\n");
+		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
 	for (i = 0; i < STA_TID_NUM; i++) {
 		p += scnprintf(p, sizeof(buf) + buf - p, "%02d", i);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t\t%x",
@@ -138,9 +138,6 @@ static ssize_t sta_agg_status_read(struc
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
 				sta->ampdu_mlme.tid_tx[i] ?
 				sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
-		p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.3x",
-				sta->ampdu_mlme.tid_tx[i] ?
-				sta->ampdu_mlme.tid_tx[i]->ssn : 0);
 		p += scnprintf(p, sizeof(buf) + buf - p, "\t%03d",
 				sta->ampdu_mlme.tid_tx[i] ?
 				skb_queue_len(&sta->ampdu_mlme.tid_tx[i]->pending) : 0);
--- wireless-testing.orig/net/mac80211/tx.c	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-06-06 15:43:46.000000000 +0200
@@ -1102,6 +1102,11 @@ static bool ieee80211_tx_prep_agg(struct
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
+	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
+		/*
+		 * nothing -- this aggregation session is being started
+		 * but that might still fail with the driver
+		 */
 	} else {
 		spin_lock(&tx->sta->lock);
 		/*
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-06 15:45:05.000000000 +0200
@@ -1120,6 +1120,7 @@ int __ieee80211_stop_tx_ba_session(struc
 				   enum ieee80211_back_parties initiator);
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
+void ieee80211_tx_ba_session_work(struct work_struct *work);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-06-06 15:45:05.000000000 +0200
@@ -235,6 +235,7 @@ struct sta_info *sta_info_alloc(struct i
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->flaglock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
+	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_tx_ba_session_work);
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
--- wireless-testing.orig/net/mac80211/ht.c	2010-06-06 15:30:23.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-06-06 15:45:05.000000000 +0200
@@ -105,6 +105,8 @@ void ieee80211_sta_tear_down_BA_sessions
 {
 	int i;
 
+	cancel_work_sync(&sta->ampdu_mlme.work);
+
 	for (i = 0; i <  STA_TID_NUM; i++) {
 		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR);
 		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,


