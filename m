Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYIHPpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:45:46 -0400
Message-Id: <20080908154444.635370000@sipsolutions.net> (sfid-20080908_174552_176220_C57B9093)
References: <20080908154421.216772000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:44:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] mac80211: move some HT code out of main.c
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that I've created ht.c, I can move the aggregation
code from main.c into it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c   |  377 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/main.c |  373 ---------------------------------------------------
 2 files changed, 375 insertions(+), 375 deletions(-)

--- everything.orig/net/mac80211/ht.c	2008-09-08 16:10:05.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-09-08 16:10:07.000000000 +0200
@@ -2,8 +2,8 @@
  * HT handling
  *
  * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
- * Copyright 2004, Instant802 Networks, Inc.
- * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2008, Intel Corporation
@@ -18,6 +18,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
+#include "wme.h"
 
 int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 				   struct ieee80211_ht_info *ht_info)
@@ -326,3 +327,375 @@ void ieee80211_sta_tear_down_BA_sessions
 	}
 }
 
+int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata;
+	u16 start_seq_num;
+	u8 *state;
+	int ret;
+	DECLARE_MAC_BUF(mac);
+
+	if (tid >= STA_TID_NUM)
+		return -EINVAL;
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Open BA session requested for %s tid %u\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Could not find the station\n");
+#endif
+		ret = -ENOENT;
+		goto exit;
+	}
+
+	spin_lock_bh(&sta->lock);
+
+	/* we have tried too many times, receiver does not want A-MPDU */
+	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
+		ret = -EBUSY;
+		goto err_unlock_sta;
+	}
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	/* check if the TID is not in aggregation flow already */
+	if (*state != HT_AGG_STATE_IDLE) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - session is not "
+				 "idle on tid %u\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ret = -EAGAIN;
+		goto err_unlock_sta;
+	}
+
+	/* prepare A-MPDU MLME for Tx aggregation */
+	sta->ampdu_mlme.tid_tx[tid] =
+			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
+	if (!sta->ampdu_mlme.tid_tx[tid]) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
+					tid);
+#endif
+		ret = -ENOMEM;
+		goto err_unlock_sta;
+	}
+	/* Tx timer */
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
+			sta_addba_resp_timer_expired;
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.data =
+			(unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+
+	/* create a new queue for this aggregation */
+	ret = ieee80211_ht_agg_queue_add(local, sta, tid);
+
+	/* case no queue is available to aggregation
+	 * don't switch to aggregation */
+	if (ret) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - queue unavailable for"
+					" tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		goto err_unlock_queue;
+	}
+	sdata = sta->sdata;
+
+	/* Ok, the Addba frame hasn't been sent yet, but if the driver calls the
+	 * call back right away, it must see that the flow has begun */
+	*state |= HT_ADDBA_REQUESTED_MSK;
+
+	/* This is slightly racy because the queue isn't stopped */
+	start_seq_num = sta->tid_seq[tid];
+
+	if (local->ops->ampdu_action)
+		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
+						ra, tid, &start_seq_num);
+
+	if (ret) {
+		/* No need to requeue the packets in the agg queue, since we
+		 * held the tx lock: no packet could be enqueued to the newly
+		 * allocated queue */
+		ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - HW unavailable for"
+					" tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		*state = HT_AGG_STATE_IDLE;
+		goto err_unlock_queue;
+	}
+
+	/* Will put all the packets in the new SW queue */
+	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
+	spin_unlock_bh(&sta->lock);
+
+	/* send an addBA request */
+	sta->ampdu_mlme.dialog_token_allocator++;
+	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
+			sta->ampdu_mlme.dialog_token_allocator;
+	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
+
+
+	ieee80211_send_addba_request(sta->sdata, ra, tid,
+			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
+			 sta->ampdu_mlme.tid_tx[tid]->ssn,
+			 0x40, 5000);
+	/* activate the timer for the recipient's addBA response */
+	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
+				jiffies + ADDBA_RESP_INTERVAL;
+	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+#endif
+	goto exit;
+
+err_unlock_queue:
+	kfree(sta->ampdu_mlme.tid_tx[tid]);
+	sta->ampdu_mlme.tid_tx[tid] = NULL;
+	ret = -EBUSY;
+err_unlock_sta:
+	spin_unlock_bh(&sta->lock);
+exit:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
+
+int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
+				 u8 *ra, u16 tid,
+				 enum ieee80211_back_parties initiator)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	u8 *state;
+	int ret = 0;
+	DECLARE_MAC_BUF(mac);
+
+	if (tid >= STA_TID_NUM)
+		return -EINVAL;
+
+	rcu_read_lock();
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+
+	/* check if the TID is in aggregation */
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	spin_lock_bh(&sta->lock);
+
+	if (*state != HT_AGG_STATE_OPERATIONAL) {
+		ret = -ENOENT;
+		goto stop_BA_exit;
+	}
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Tx BA session stop requested for %s tid %u\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
+
+	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
+		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
+
+	if (local->ops->ampdu_action)
+		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
+						ra, tid, NULL);
+
+	/* case HW denied going back to legacy */
+	if (ret) {
+		WARN_ON(ret != -EBUSY);
+		*state = HT_AGG_STATE_OPERATIONAL;
+		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		goto stop_BA_exit;
+	}
+
+stop_BA_exit:
+	spin_unlock_bh(&sta->lock);
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
+
+void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	u8 *state;
+	DECLARE_MAC_BUF(mac);
+
+	if (tid >= STA_TID_NUM) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
+				tid, STA_TID_NUM);
+#endif
+		return;
+	}
+
+	rcu_read_lock();
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		rcu_read_unlock();
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Could not find station: %s\n",
+				print_mac(mac, ra));
+#endif
+		return;
+	}
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	spin_lock_bh(&sta->lock);
+
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
+				*state);
+#endif
+		spin_unlock_bh(&sta->lock);
+		rcu_read_unlock();
+		return;
+	}
+
+	WARN_ON_ONCE(*state & HT_ADDBA_DRV_READY_MSK);
+
+	*state |= HT_ADDBA_DRV_READY_MSK;
+
+	if (*state == HT_AGG_STATE_OPERATIONAL) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
+#endif
+		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+	}
+	spin_unlock_bh(&sta->lock);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
+
+void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	u8 *state;
+	int agg_queue;
+	DECLARE_MAC_BUF(mac);
+
+	if (tid >= STA_TID_NUM) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
+				tid, STA_TID_NUM);
+#endif
+		return;
+	}
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Stopping Tx BA session for %s tid %d\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	rcu_read_lock();
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Could not find station: %s\n",
+				print_mac(mac, ra));
+#endif
+		rcu_read_unlock();
+		return;
+	}
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+
+	/* NOTE: no need to use sta->lock in this state check, as
+	 * ieee80211_stop_tx_ba_session will let only one stop call to
+	 * pass through per sta/tid
+	 */
+	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
+#endif
+		rcu_read_unlock();
+		return;
+	}
+
+	if (*state & HT_AGG_STATE_INITIATOR_MSK)
+		ieee80211_send_delba(sta->sdata, ra, tid,
+			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
+
+	agg_queue = sta->tid_to_tx_q[tid];
+
+	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
+
+	/* We just requeued the all the frames that were in the
+	 * removed queue, and since we might miss a softirq we do
+	 * netif_schedule_queue.  ieee80211_wake_queue is not used
+	 * here as this queue is not necessarily stopped
+	 */
+	netif_schedule_queue(netdev_get_tx_queue(local->mdev, agg_queue));
+	spin_lock_bh(&sta->lock);
+	*state = HT_AGG_STATE_IDLE;
+	sta->ampdu_mlme.addba_req_num[tid] = 0;
+	kfree(sta->ampdu_mlme.tid_tx[tid]);
+	sta->ampdu_mlme.tid_tx[tid] = NULL;
+	spin_unlock_bh(&sta->lock);
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
+
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+				      const u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_ra_tid *ra_tid;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_WARNING "%s: Not enough memory, "
+			       "dropping start BA session", skb->dev->name);
+#endif
+		return;
+	}
+	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
+	memcpy(&ra_tid->ra, ra, ETH_ALEN);
+	ra_tid->tid = tid;
+
+	skb->pkt_type = IEEE80211_ADDBA_MSG;
+	skb_queue_tail(&local->skb_queue, skb);
+	tasklet_schedule(&local->tasklet);
+}
+EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
+
+void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+				     const u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_ra_tid *ra_tid;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_WARNING "%s: Not enough memory, "
+			       "dropping stop BA session", skb->dev->name);
+#endif
+		return;
+	}
+	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
+	memcpy(&ra_tid->ra, ra, ETH_ALEN);
+	ra_tid->tid = tid;
+
+	skb->pkt_type = IEEE80211_DELBA_MSG;
+	skb_queue_tail(&local->skb_queue, skb);
+	tasklet_schedule(&local->tasklet);
+}
+EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
--- everything.orig/net/mac80211/main.c	2008-09-08 16:09:52.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-08 16:10:07.000000000 +0200
@@ -593,379 +593,6 @@ static int ieee80211_stop(struct net_dev
 	return 0;
 }
 
-int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
-	u16 start_seq_num;
-	u8 *state;
-	int ret;
-	DECLARE_MAC_BUF(mac);
-
-	if (tid >= STA_TID_NUM)
-		return -EINVAL;
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Open BA session requested for %s tid %u\n",
-				print_mac(mac, ra), tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Could not find the station\n");
-#endif
-		ret = -ENOENT;
-		goto exit;
-	}
-
-	spin_lock_bh(&sta->lock);
-
-	/* we have tried too many times, receiver does not want A-MPDU */
-	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
-		ret = -EBUSY;
-		goto err_unlock_sta;
-	}
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-	/* check if the TID is not in aggregation flow already */
-	if (*state != HT_AGG_STATE_IDLE) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - session is not "
-				 "idle on tid %u\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		ret = -EAGAIN;
-		goto err_unlock_sta;
-	}
-
-	/* prepare A-MPDU MLME for Tx aggregation */
-	sta->ampdu_mlme.tid_tx[tid] =
-			kmalloc(sizeof(struct tid_ampdu_tx), GFP_ATOMIC);
-	if (!sta->ampdu_mlme.tid_tx[tid]) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_ERR "allocate tx mlme to tid %d failed\n",
-					tid);
-#endif
-		ret = -ENOMEM;
-		goto err_unlock_sta;
-	}
-	/* Tx timer */
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.function =
-			sta_addba_resp_timer_expired;
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.data =
-			(unsigned long)&sta->timer_to_tid[tid];
-	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-
-	/* create a new queue for this aggregation */
-	ret = ieee80211_ht_agg_queue_add(local, sta, tid);
-
-	/* case no queue is available to aggregation
-	 * don't switch to aggregation */
-	if (ret) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - queue unavailable for"
-					" tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto err_unlock_queue;
-	}
-	sdata = sta->sdata;
-
-	/* Ok, the Addba frame hasn't been sent yet, but if the driver calls the
-	 * call back right away, it must see that the flow has begun */
-	*state |= HT_ADDBA_REQUESTED_MSK;
-
-	/* This is slightly racy because the queue isn't stopped */
-	start_seq_num = sta->tid_seq[tid];
-
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
-						ra, tid, &start_seq_num);
-
-	if (ret) {
-		/* No need to requeue the packets in the agg queue, since we
-		 * held the tx lock: no packet could be enqueued to the newly
-		 * allocated queue */
-		ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - HW unavailable for"
-					" tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		*state = HT_AGG_STATE_IDLE;
-		goto err_unlock_queue;
-	}
-
-	/* Will put all the packets in the new SW queue */
-	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
-	spin_unlock_bh(&sta->lock);
-
-	/* send an addBA request */
-	sta->ampdu_mlme.dialog_token_allocator++;
-	sta->ampdu_mlme.tid_tx[tid]->dialog_token =
-			sta->ampdu_mlme.dialog_token_allocator;
-	sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
-
-
-	ieee80211_send_addba_request(sta->sdata, ra, tid,
-			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
-			 sta->ampdu_mlme.tid_tx[tid]->ssn,
-			 0x40, 5000);
-	/* activate the timer for the recipient's addBA response */
-	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
-				jiffies + ADDBA_RESP_INTERVAL;
-	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
-#endif
-	goto exit;
-
-err_unlock_queue:
-	kfree(sta->ampdu_mlme.tid_tx[tid]);
-	sta->ampdu_mlme.tid_tx[tid] = NULL;
-	ret = -EBUSY;
-err_unlock_sta:
-	spin_unlock_bh(&sta->lock);
-exit:
-	rcu_read_unlock();
-	return ret;
-}
-EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
-
-int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
-				 u8 *ra, u16 tid,
-				 enum ieee80211_back_parties initiator)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	u8 *state;
-	int ret = 0;
-	DECLARE_MAC_BUF(mac);
-
-	if (tid >= STA_TID_NUM)
-		return -EINVAL;
-
-	rcu_read_lock();
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-		rcu_read_unlock();
-		return -ENOENT;
-	}
-
-	/* check if the TID is in aggregation */
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-	spin_lock_bh(&sta->lock);
-
-	if (*state != HT_AGG_STATE_OPERATIONAL) {
-		ret = -ENOENT;
-		goto stop_BA_exit;
-	}
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Tx BA session stop requested for %s tid %u\n",
-				print_mac(mac, ra), tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
-
-	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
-		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
-
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
-						ra, tid, NULL);
-
-	/* case HW denied going back to legacy */
-	if (ret) {
-		WARN_ON(ret != -EBUSY);
-		*state = HT_AGG_STATE_OPERATIONAL;
-		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
-		goto stop_BA_exit;
-	}
-
-stop_BA_exit:
-	spin_unlock_bh(&sta->lock);
-	rcu_read_unlock();
-	return ret;
-}
-EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
-
-void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	u8 *state;
-	DECLARE_MAC_BUF(mac);
-
-	if (tid >= STA_TID_NUM) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
-				tid, STA_TID_NUM);
-#endif
-		return;
-	}
-
-	rcu_read_lock();
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-		rcu_read_unlock();
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Could not find station: %s\n",
-				print_mac(mac, ra));
-#endif
-		return;
-	}
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-	spin_lock_bh(&sta->lock);
-
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
-				*state);
-#endif
-		spin_unlock_bh(&sta->lock);
-		rcu_read_unlock();
-		return;
-	}
-
-	WARN_ON_ONCE(*state & HT_ADDBA_DRV_READY_MSK);
-
-	*state |= HT_ADDBA_DRV_READY_MSK;
-
-	if (*state == HT_AGG_STATE_OPERATIONAL) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
-#endif
-		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
-	}
-	spin_unlock_bh(&sta->lock);
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
-
-void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	u8 *state;
-	int agg_queue;
-	DECLARE_MAC_BUF(mac);
-
-	if (tid >= STA_TID_NUM) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
-				tid, STA_TID_NUM);
-#endif
-		return;
-	}
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Stopping Tx BA session for %s tid %d\n",
-				print_mac(mac, ra), tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	rcu_read_lock();
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Could not find station: %s\n",
-				print_mac(mac, ra));
-#endif
-		rcu_read_unlock();
-		return;
-	}
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-
-	/* NOTE: no need to use sta->lock in this state check, as
-	 * ieee80211_stop_tx_ba_session will let only one stop call to
-	 * pass through per sta/tid
-	 */
-	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
-#endif
-		rcu_read_unlock();
-		return;
-	}
-
-	if (*state & HT_AGG_STATE_INITIATOR_MSK)
-		ieee80211_send_delba(sta->sdata, ra, tid,
-			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
-
-	agg_queue = sta->tid_to_tx_q[tid];
-
-	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
-
-	/* We just requeued the all the frames that were in the
-	 * removed queue, and since we might miss a softirq we do
-	 * netif_schedule_queue.  ieee80211_wake_queue is not used
-	 * here as this queue is not necessarily stopped
-	 */
-	netif_schedule_queue(netdev_get_tx_queue(local->mdev, agg_queue));
-	spin_lock_bh(&sta->lock);
-	*state = HT_AGG_STATE_IDLE;
-	sta->ampdu_mlme.addba_req_num[tid] = 0;
-	kfree(sta->ampdu_mlme.tid_tx[tid]);
-	sta->ampdu_mlme.tid_tx[tid] = NULL;
-	spin_unlock_bh(&sta->lock);
-
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
-
-void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
-				      const u8 *ra, u16 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
-
-	if (unlikely(!skb)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping start BA session", skb->dev->name);
-#endif
-		return;
-	}
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
-
-	skb->pkt_type = IEEE80211_ADDBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
-}
-EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
-
-void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
-				     const u8 *ra, u16 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
-
-	if (unlikely(!skb)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping stop BA session", skb->dev->name);
-#endif
-		return;
-	}
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
-
-	skb->pkt_type = IEEE80211_DELBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
-}
-EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
-
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);

-- 

