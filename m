Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbYCZSgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 14:36:10 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: A-MPDU MLME use dynamic allocation
Date: Wed, 26 Mar 2008 20:36:03 +0200
Message-Id: <1206556563-17390-1-git-send-email-tomas.winkler@intel.com> (sfid-20080326_183617_117214_CBFCB193)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch alters the A-MPDU MLME in sta_info to use dynamic allocation,
thus drastically improving memory usage - from a constant ~2 Kbyte in
the previous (static) allocation to a lower limit of ~200 Byte and an upper
limit of ~2 Kbyte.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 +-
 net/mac80211/debugfs_sta.c                 |   17 +++--
 net/mac80211/ieee80211.c                   |   64 ++++++++++++++-------
 net/mac80211/ieee80211_sta.c               |   84 +++++++++++++++++----------
 net/mac80211/rx.c                          |   10 ++-
 net/mac80211/sta_info.c                    |   30 +++++-----
 net/mac80211/sta_info.h                    |   44 ++++++++-------
 7 files changed, 151 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 7d7ce74..735eadd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -397,7 +397,7 @@ static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 	DECLARE_MAC_BUF(mac);
 
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
-	state = sta->ampdu_mlme.tid_tx[tid].state;
+	state = sta->ampdu_mlme.tid_state_tx[tid];
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 
 	if (state == HT_AGG_STATE_IDLE &&
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 62354de..256ea88 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -169,27 +169,30 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n RX  :");
 	for (i = 0; i < STA_TID_NUM; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-	sta->ampdu_mlme.tid_rx[i].state);
+			sta->ampdu_mlme.tid_state_rx[i]);
 
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n DTKN:");
 	for (i = 0; i < STA_TID_NUM; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_rx[i].dialog_token);
+			sta->ampdu_mlme.tid_state_rx[i]?
+			sta->ampdu_mlme.tid_rx[i]->dialog_token : 0);
 
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n TX  :");
 	for (i = 0; i < STA_TID_NUM; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_tx[i].state);
+			sta->ampdu_mlme.tid_state_tx[i]);
 
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n DTKN:");
 	for (i = 0; i < STA_TID_NUM; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_tx[i].dialog_token);
+			sta->ampdu_mlme.tid_state_tx[i]?
+			sta->ampdu_mlme.tid_tx[i]->dialog_token : 0);
 
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n SSN :");
 	for (i = 0; i < STA_TID_NUM; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
-			sta->ampdu_mlme.tid_tx[i].ssn);
+			sta->ampdu_mlme.tid_state_tx[i]?
+			sta->ampdu_mlme.tid_tx[i]->ssn : 0);
 
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
 
@@ -230,12 +233,12 @@ static ssize_t sta_agg_status_write(struct file *file,
 			strcpy(state, "off ");
 			ieee80211_sta_stop_rx_ba_session(dev, da, tid_num, 0,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
-			sta->ampdu_mlme.tid_rx[tid_num].state |=
+			sta->ampdu_mlme.tid_state_rx[tid_num] |=
 					HT_AGG_STATE_DEBUGFS_CTL;
 			tid_static_rx[tid_num] = 0;
 		} else {
 			strcpy(state, "on ");
-			sta->ampdu_mlme.tid_rx[tid_num].state &=
+			sta->ampdu_mlme.tid_state_rx[tid_num] &=
 					~HT_AGG_STATE_DEBUGFS_CTL;
 			tid_static_rx[tid_num] = 1;
 		}
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 616ce10..8c0f782 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -569,12 +569,12 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 
 	/* we have tried too many times, receiver does not want A-MPDU */
-	if (sta->ampdu_mlme.tid_tx[tid].addba_req_num >	HT_AGG_MAX_RETRIES) {
+	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
 		ret = -EBUSY;
 		goto start_ba_exit;
 	}
 
-	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	/* check if the TID is not in aggregation flow already */
 	if (*state != HT_AGG_STATE_IDLE) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -585,6 +585,23 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		goto start_ba_exit;
 	}
 
+	/* prepare A-MPDU MLME for Tx aggregation */
+	sta->ampdu_mlme.tid_tx[tid] =
+			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
+	if (!sta->ampdu_mlme.tid_tx[tid]) {
+		if (net_ratelimit())
+			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
+					tid);
+		ret = -ENOMEM;
+		goto start_ba_exit;
+	}
+	/* Tx timer */
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
+			sta_addba_resp_timer_expired;
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.data =
+			(unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+
 	/* ensure that TX flow won't interrupt us
 	 * until the end of the call to requeue function */
 	spin_lock_bh(&local->mdev->queue_lock);
@@ -596,11 +613,10 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	 * don't switch to aggregation */
 	if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - no queue available for"
+		printk(KERN_DEBUG "BA request denied - queue unavailable for"
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		spin_unlock_bh(&local->mdev->queue_lock);
-		goto start_ba_exit;
+		goto start_ba_err;
 	}
 	sdata = sta->sdata;
 
@@ -618,38 +634,40 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		 * allocated queue */
 		 ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - HW or queue unavailable"
-				" for tid %d\n", tid);
+		printk(KERN_DEBUG "BA request denied - HW unavailable for"
+					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		spin_unlock_bh(&local->mdev->queue_lock);
 		*state = HT_AGG_STATE_IDLE;
-		goto start_ba_exit;
+		goto start_ba_err;
 	}
 
 	/* Will put all the packets in the new SW queue */
 	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&local->mdev->queue_lock);
 
-	/* We have most probably almost emptied the legacy queue */
-	/* ieee80211_wake_queue(local_to_hw(local), ieee802_1d_to_ac[tid]); */
-
 	/* send an addBA request */
 	sta->ampdu_mlme.dialog_token_allocator++;
-	sta->ampdu_mlme.tid_tx[tid].dialog_token =
+	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
 			sta->ampdu_mlme.dialog_token_allocator;
-	sta->ampdu_mlme.tid_tx[tid].ssn = start_seq_num;
+	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
 
 	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
-			 sta->ampdu_mlme.tid_tx[tid].dialog_token,
-			 sta->ampdu_mlme.tid_tx[tid].ssn,
+			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
+			 sta->ampdu_mlme.tid_tx[tid]->ssn,
 			 0x40, 5000);
 
 	/* activate the timer for the recipient's addBA response */
-	sta->ampdu_mlme.tid_tx[tid].addba_resp_timer.expires =
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
 				jiffies + ADDBA_RESP_INTERVAL;
-	add_timer(&sta->ampdu_mlme.tid_tx[tid].addba_resp_timer);
+	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+	goto start_ba_exit;
 
+start_ba_err:
+	kfree(sta->ampdu_mlme.tid_tx[tid]);
+	sta->ampdu_mlme.tid_tx[tid] = NULL;
+	spin_unlock_bh(&local->mdev->queue_lock);
+	ret = -EBUSY;
 start_ba_exit:
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 	rcu_read_unlock();
@@ -683,7 +701,7 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 	}
 
 	/* check if the TID is in aggregation */
-	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 
 	if (*state != HT_AGG_STATE_OPERATIONAL) {
@@ -741,7 +759,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		return;
 	}
 
-	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
@@ -790,7 +808,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 		rcu_read_unlock();
 		return;
 	}
-	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
@@ -819,7 +837,9 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	 * necessarily stopped */
 	netif_schedule(local->mdev);
 	*state = HT_AGG_STATE_IDLE;
-	sta->ampdu_mlme.tid_tx[tid].addba_req_num = 0;
+	sta->ampdu_mlme.addba_req_num[tid] = 0;
+	kfree(sta->ampdu_mlme.tid_tx[tid]);
+	sta->ampdu_mlme.tid_tx[tid] = NULL;
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 
 	rcu_read_unlock();
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 1e9650e..f7183a3 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1161,12 +1161,11 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 		buf_size = buf_size << sband->ht_info.ampdu_factor;
 	}
 
-	tid_agg_rx = &sta->ampdu_mlme.tid_rx[tid];
 
 	/* examine state machine */
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
 
-	if (tid_agg_rx->state != HT_AGG_STATE_IDLE) {
+	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_IDLE) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "unexpected AddBA Req from "
@@ -1176,6 +1175,24 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 		goto end;
 	}
 
+	/* prepare A-MPDU MLME for Rx aggregation */
+	sta->ampdu_mlme.tid_rx[tid] =
+			kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
+	if (!sta->ampdu_mlme.tid_rx[tid]) {
+		if (net_ratelimit())
+			printk(KERN_ERR "allocate rx mlme to tid %d failed\n",
+					tid);
+		goto end;
+	}
+	/* rx timer */
+	sta->ampdu_mlme.tid_rx[tid]->session_timer.function =
+				sta_rx_agg_session_timer_expired;
+	sta->ampdu_mlme.tid_rx[tid]->session_timer.data =
+				(unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
+
+	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
+
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
@@ -1183,6 +1200,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 		if (net_ratelimit())
 			printk(KERN_ERR "can not allocate reordering buffer "
 			       "to tid %d\n", tid);
+		kfree(sta->ampdu_mlme.tid_rx[tid]);
 		goto end;
 	}
 	memset(tid_agg_rx->reorder_buf, 0,
@@ -1197,11 +1215,13 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 
 	if (ret) {
 		kfree(tid_agg_rx->reorder_buf);
+		kfree(tid_agg_rx);
+		sta->ampdu_mlme.tid_rx[tid] = NULL;
 		goto end;
 	}
 
 	/* change state and send addba resp */
-	tid_agg_rx->state = HT_AGG_STATE_OPERATIONAL;
+	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_OPERATIONAL;
 	tid_agg_rx->dialog_token = dialog_token;
 	tid_agg_rx->ssn = start_seq_num;
 	tid_agg_rx->head_seq_num = start_seq_num;
@@ -1240,39 +1260,37 @@ static void ieee80211_sta_process_addba_resp(struct net_device *dev,
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 
-	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
+			"%d\n", *state);
+		goto addba_resp_exit;
+	}
+
 	if (mgmt->u.action.u.addba_resp.dialog_token !=
-		sta->ampdu_mlme.tid_tx[tid].dialog_token) {
+		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		rcu_read_unlock();
-		return;
+		goto addba_resp_exit;
 	}
 
-	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid].addba_resp_timer);
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
-		if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-			spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-			printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
-				"%d\n", *state);
-			rcu_read_unlock();
-			return;
-		}
-
 		if (*state & HT_ADDBA_RECEIVED_MSK)
 			printk(KERN_DEBUG "double addBA response\n");
 
 		*state |= HT_ADDBA_RECEIVED_MSK;
-		sta->ampdu_mlme.tid_tx[tid].addba_req_num = 0;
+		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
 		if (*state == HT_AGG_STATE_OPERATIONAL) {
 			printk(KERN_DEBUG "Aggregation on for tid %d \n", tid);
@@ -1284,13 +1302,15 @@ static void ieee80211_sta_process_addba_resp(struct net_device *dev,
 	} else {
 		printk(KERN_DEBUG "recipient rejected agg: tid %d \n", tid);
 
-		sta->ampdu_mlme.tid_tx[tid].addba_req_num++;
+		sta->ampdu_mlme.addba_req_num[tid]++;
 		/* this will allow the state check in stop_BA_session */
 		*state = HT_AGG_STATE_OPERATIONAL;
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
 					     WLAN_BACK_INITIATOR);
 	}
+
+addba_resp_exit:
 	rcu_read_unlock();
 }
 
@@ -1356,13 +1376,13 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 
 	/* check if TID is in operational state */
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
-	if (sta->ampdu_mlme.tid_rx[tid].state
+	if (sta->ampdu_mlme.tid_state_rx[tid]
 				!= HT_AGG_STATE_OPERATIONAL) {
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
 		rcu_read_unlock();
 		return;
 	}
-	sta->ampdu_mlme.tid_rx[tid].state =
+	sta->ampdu_mlme.tid_state_rx[tid] =
 		HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
@@ -1379,25 +1399,27 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 
 	/* shutdown timer has not expired */
 	if (initiator != WLAN_BACK_TIMER)
-		del_timer_sync(&sta->ampdu_mlme.tid_rx[tid].
-					session_timer);
+		del_timer_sync(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
 
 	/* check if this is a self generated aggregation halt */
 	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
 		ieee80211_send_delba(dev, ra, tid, 0, reason);
 
 	/* free the reordering buffer */
-	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
-		if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
+	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid]->buf_size; i++) {
+		if (sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]) {
 			/* release the reordered frames */
-			dev_kfree_skb(sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]);
-			sta->ampdu_mlme.tid_rx[tid].stored_mpdu_num--;
-			sta->ampdu_mlme.tid_rx[tid].reorder_buf[i] = NULL;
+			dev_kfree_skb(sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]);
+			sta->ampdu_mlme.tid_rx[tid]->stored_mpdu_num--;
+			sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i] = NULL;
 		}
 	}
-	kfree(sta->ampdu_mlme.tid_rx[tid].reorder_buf);
+	/* free resources */
+	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
+	kfree(sta->ampdu_mlme.tid_rx[tid]);
+	sta->ampdu_mlme.tid_rx[tid] = NULL;
+	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
 
-	sta->ampdu_mlme.tid_rx[tid].state = HT_AGG_STATE_IDLE;
 	rcu_read_unlock();
 }
 
@@ -1436,7 +1458,7 @@ static void ieee80211_sta_process_delba(struct net_device *dev,
 						 WLAN_BACK_INITIATOR, 0);
 	else { /* WLAN_BACK_RECIPIENT */
 		spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
-		sta->ampdu_mlme.tid_tx[tid].state =
+		sta->ampdu_mlme.tid_state_tx[tid] =
 				HT_AGG_STATE_OPERATIONAL;
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
@@ -1473,7 +1495,7 @@ void sta_addba_resp_timer_expired(unsigned long data)
 		return;
 	}
 
-	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	/* check if the TID waits for addBA response */
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 644d277..d9c6ed5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1514,9 +1514,10 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 		if (!rx->sta)
 			return RX_CONTINUE;
 		tid = le16_to_cpu(bar->control) >> 12;
-		tid_agg_rx = &(rx->sta->ampdu_mlme.tid_rx[tid]);
-		if (tid_agg_rx->state != HT_AGG_STATE_OPERATIONAL)
+		if (rx->sta->ampdu_mlme.tid_state_rx[tid]
+					!= HT_AGG_STATE_OPERATIONAL)
 			return RX_CONTINUE;
+		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
 		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
 
@@ -2123,11 +2124,12 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 
 	qc = skb->data + ieee80211_get_hdrlen(fc) - QOS_CONTROL_LEN;
 	tid = qc[0] & QOS_CONTROL_TID_MASK;
-	tid_agg_rx = &(sta->ampdu_mlme.tid_rx[tid]);
 
-	if (tid_agg_rx->state != HT_AGG_STATE_OPERATIONAL)
+	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
 		goto end_reorder;
 
+	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
+
 	/* null data frames are excluded */
 	if (unlikely(fc & IEEE80211_STYPE_NULLFUNC))
 		goto end_reorder;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3b84c16..f708367 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -170,9 +170,16 @@ void sta_info_destroy(struct sta_info *sta)
 		dev_kfree_skb_any(skb);
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
-		del_timer_sync(&sta->ampdu_mlme.tid_rx[i].session_timer);
-		del_timer_sync(&sta->ampdu_mlme.tid_tx[i].addba_resp_timer);
+		spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
+		if (sta->ampdu_mlme.tid_rx[i])
+		  del_timer_sync(&sta->ampdu_mlme.tid_rx[i]->session_timer);
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+		spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+		if (sta->ampdu_mlme.tid_tx[i])
+		  del_timer_sync(&sta->ampdu_mlme.tid_tx[i]->addba_resp_timer);
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 	}
+
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
 
@@ -227,18 +234,13 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		sta->timer_to_tid[i] = i;
 		/* tid to tx queue: initialize according to HW (0 is valid) */
 		sta->tid_to_tx_q[i] = local->hw.queues;
-		/* rx timers */
-		sta->ampdu_mlme.tid_rx[i].session_timer.function =
-			sta_rx_agg_session_timer_expired;
-		sta->ampdu_mlme.tid_rx[i].session_timer.data =
-			(unsigned long)&sta->timer_to_tid[i];
-		init_timer(&sta->ampdu_mlme.tid_rx[i].session_timer);
-		/* tx timers */
-		sta->ampdu_mlme.tid_tx[i].addba_resp_timer.function =
-			sta_addba_resp_timer_expired;
-		sta->ampdu_mlme.tid_tx[i].addba_resp_timer.data =
-			(unsigned long)&sta->timer_to_tid[i];
-		init_timer(&sta->ampdu_mlme.tid_tx[i].addba_resp_timer);
+		/* rx */
+		sta->ampdu_mlme.tid_state_rx[i] = HT_AGG_STATE_IDLE;
+		sta->ampdu_mlme.tid_rx[i] = NULL;
+		/* tx */
+		sta->ampdu_mlme.tid_state_tx[i] = HT_AGG_STATE_IDLE;
+		sta->ampdu_mlme.tid_tx[i] = NULL;
+		sta->ampdu_mlme.addba_req_num[i] = 0;
 	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5d6b436..af5a791 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -68,43 +68,37 @@ enum ieee80211_sta_info_flags {
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
- * @state: TID's state in session state machine.
- * @dialog_token: dialog token for aggregation session
- * @ssn: Starting Sequence Number expected to be aggregated.
  * @addba_resp_timer: timer for peer's response to addba request
- * @addba_req_num: number of times addBA request has been sent.
+ * @ssn: Starting Sequence Number expected to be aggregated.
+ * @dialog_token: dialog token for aggregation session
  */
 struct tid_ampdu_tx {
-	u8 state;
-	u8 dialog_token;
-	u16 ssn;
 	struct timer_list addba_resp_timer;
-	u8 addba_req_num;
+	u16 ssn;
+	u8 dialog_token;
 };
 
 /**
  * struct tid_ampdu_rx - TID aggregation information (Rx).
  *
- * @state: TID's state in session state machine.
- * @dialog_token: dialog token for aggregation session
- * @ssn: Starting Sequence Number expected to be aggregated.
- * @buf_size: buffer size for incoming A-MPDUs
- * @timeout: reset timer value.
  * @head_seq_num: head sequence number in reordering buffer.
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @reorder_buf: buffer to reorder incoming aggregated MPDUs
  * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
+ * @ssn: Starting Sequence Number expected to be aggregated.
+ * @buf_size: buffer size for incoming A-MPDUs
+ * @timeout: reset timer value.
+ * @dialog_token: dialog token for aggregation session
  */
 struct tid_ampdu_rx {
-	u8 state;
-	u8 dialog_token;
-	u16 ssn;
-	u16 buf_size;
-	u16 timeout;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	struct sk_buff **reorder_buf;
 	struct timer_list session_timer;
+	u16 ssn;
+	u16 buf_size;
+	u16 timeout;
+	u8 dialog_token;
 };
 
 /**
@@ -133,16 +127,24 @@ enum plink_state {
 /**
  * struct sta_ampdu_mlme - STA aggregation information.
  *
+ * @tid_state_rx: TID's state in Rx session state machine.
  * @tid_rx: aggregation info for Rx per TID
- * @tid_tx: aggregation info for Tx per TID
  * @ampdu_rx: for locking sections in aggregation Rx flow
+ * @tid_state_tx: TID's state in Tx session state machine.
+ * @tid_tx: aggregation info for Tx per TID
+ * @addba_req_num: number of times addBA request has been sent.
  * @ampdu_tx: for locking sectionsi in aggregation Tx flow
  * @dialog_token_allocator: dialog token enumerator for each new session;
  */
 struct sta_ampdu_mlme {
-	struct tid_ampdu_rx tid_rx[STA_TID_NUM];
-	struct tid_ampdu_tx tid_tx[STA_TID_NUM];
+	/* rx */
+	u8 tid_state_rx[STA_TID_NUM];
+	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
 	spinlock_t ampdu_rx;
+	/* tx */
+	u8 tid_state_tx[STA_TID_NUM];
+	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
+	u8 addba_req_num[STA_TID_NUM];
 	spinlock_t ampdu_tx;
 	u8 dialog_token_allocator;
 };
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

