Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbYHFTkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 15:40:46 -0400
Subject: [PATCH] mac80211: split out aggregation code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 21:40:03 +0200
Message-Id: <1218051603.23048.63.camel@johannes.berg> (sfid-20080806_214053_630328_E7D04330)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's more manageable that way. Also move some constants to
include/linux/ieee80211.h.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h  |   16 +
 net/mac80211/Makefile      |    1 
 net/mac80211/ht.c          |  508 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    5 
 net/mac80211/main.c        |  370 --------------------------------
 net/mac80211/mlme.c        |  137 ------------
 6 files changed, 530 insertions(+), 507 deletions(-)

--- everything.orig/net/mac80211/Makefile	2008-08-06 21:38:22.000000000 +0200
+++ everything/net/mac80211/Makefile	2008-08-06 21:38:25.000000000 +0200
@@ -19,6 +19,7 @@ mac80211-y := \
 	key.o \
 	util.o \
 	wme.o \
+	ht.o \
 	event.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/mac80211/ht.c	2008-08-06 21:38:25.000000000 +0200
@@ -0,0 +1,508 @@
+/*
+ * mac80211 - aggregation handling
+ *
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005-2006, Devicescape Software, Inc.
+ * Copyright 2006-2007  Jiri Benc <jbenc@suse.cz>
+ * Copyright 2008       Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ieee80211.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "wme.h"
+
+/* TX aggregation handling */
+
+/*
+ * After sending add Block Ack request we activated a timer until
+ * add Block Ack response will arrive from the recipient.
+ * If this timer expires sta_addba_resp_timer_expired will be executed.
+ */
+static void sta_addba_resp_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and both sta_info and TID are needed, so init
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u16 tid = *(u8 *)data;
+	struct sta_info *temp_sta = container_of((void *)data,
+		struct sta_info, timer_to_tid[tid]);
+
+	struct ieee80211_local *local = temp_sta->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	u8 *state;
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, temp_sta->addr);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	/* check if the TID waits for addBA response */
+	spin_lock_bh(&sta->lock);
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		spin_unlock_bh(&sta->lock);
+		*state = HT_AGG_STATE_IDLE;
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "timer expired on tid %d but we are not "
+				"expecting addBA response there", tid);
+#endif
+		goto unlock;
+	}
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
+#endif
+
+	/* go through the state check in stop_BA_session */
+	*state = HT_AGG_STATE_OPERATIONAL;
+	spin_unlock_bh(&sta->lock);
+	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
+				     WLAN_BACK_INITIATOR);
+
+ unlock:
+	rcu_read_unlock();
+}
+
+int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata;
+	u16 start_seq_num = 0;
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
+	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
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
+		ieee80211_send_delba(sta->sdata->dev, ra, tid,
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
+
+void ieee80211_sta_process_addba_resp(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_mgmt *mgmt,
+				      size_t len)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	u16 capab;
+	u16 tid;
+	u8 *state;
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, mgmt->sa);
+	if (!sta)
+		goto unlock;
+
+	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
+	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+
+	spin_lock_bh(&sta->lock);
+
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		spin_unlock_bh(&sta->lock);
+		goto unlock;
+	}
+
+	if (mgmt->u.action.u.addba_resp.dialog_token !=
+		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
+		spin_unlock_bh(&sta->lock);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		goto unlock;
+	}
+
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
+			== WLAN_STATUS_SUCCESS) {
+		*state |= HT_ADDBA_RECEIVED_MSK;
+		sta->ampdu_mlme.addba_req_num[tid] = 0;
+
+		if (*state == HT_AGG_STATE_OPERATIONAL)
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+
+		spin_unlock_bh(&sta->lock);
+	} else {
+		sta->ampdu_mlme.addba_req_num[tid]++;
+		/* this will allow the state check in stop_BA_session */
+		*state = HT_AGG_STATE_OPERATIONAL;
+		spin_unlock_bh(&sta->lock);
+		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
+					     WLAN_BACK_INITIATOR);
+	}
+
+ unlock:
+	rcu_read_unlock();
+}
--- everything.orig/net/mac80211/main.c	2008-08-06 21:36:55.000000000 +0200
+++ everything/net/mac80211/main.c	2008-08-06 21:38:25.000000000 +0200
@@ -551,376 +551,6 @@ static int ieee80211_stop(struct net_dev
 	return 0;
 }
 
-int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
-	u16 start_seq_num = 0;
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
-	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
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
-		ieee80211_send_delba(sta->sdata->dev, ra, tid,
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
--- everything.orig/net/mac80211/mlme.c	2008-08-06 21:36:55.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-08-06 21:38:25.000000000 +0200
@@ -59,20 +59,6 @@
 
 #define ERP_INFO_USE_PROTECTION BIT(1)
 
-/* mgmt header + 1 byte action code */
-#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
-
-#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
-#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
-#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
-#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
-
-/* next values represent the buffer size for A-MPDU frame.
- * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2) */
-#define IEEE80211_MIN_AMPDU_BUF 0x8
-#define IEEE80211_MAX_AMPDU_BUF 0x40
-
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
@@ -1431,72 +1417,6 @@ end_no_lock:
 	rcu_read_unlock();
 }
 
-static void ieee80211_sta_process_addba_resp(struct net_device *dev,
-					     struct ieee80211_mgmt *mgmt,
-					     size_t len)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
-	u16 capab;
-	u16 tid;
-	u8 *state;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, mgmt->sa);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
-	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-
-	spin_lock_bh(&sta->lock);
-
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->lock);
-		goto addba_resp_exit;
-	}
-
-	if (mgmt->u.action.u.addba_resp.dialog_token !=
-		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
-		spin_unlock_bh(&sta->lock);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto addba_resp_exit;
-	}
-
-	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
-			== WLAN_STATUS_SUCCESS) {
-		*state |= HT_ADDBA_RECEIVED_MSK;
-		sta->ampdu_mlme.addba_req_num[tid] = 0;
-
-		if (*state == HT_AGG_STATE_OPERATIONAL)
-			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
-
-		spin_unlock_bh(&sta->lock);
-	} else {
-		sta->ampdu_mlme.addba_req_num[tid]++;
-		/* this will allow the state check in stop_BA_session */
-		*state = HT_AGG_STATE_OPERATIONAL;
-		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
-					     WLAN_BACK_INITIATOR);
-	}
-
-addba_resp_exit:
-	rcu_read_unlock();
-}
-
 void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code)
 {
@@ -1685,61 +1605,6 @@ static void ieee80211_sta_process_delba(
 }
 
 /*
- * After sending add Block Ack request we activated a timer until
- * add Block Ack response will arrive from the recipient.
- * If this timer expires sta_addba_resp_timer_expired will be executed.
- */
-void sta_addba_resp_timer_expired(unsigned long data)
-{
-	/* not an elegant detour, but there is no choice as the timer passes
-	 * only one argument, and both sta_info and TID are needed, so init
-	 * flow in sta_info_create gives the TID as data, while the timer_to_id
-	 * array gives the sta through container_of */
-	u16 tid = *(u8 *)data;
-	struct sta_info *temp_sta = container_of((void *)data,
-		struct sta_info, timer_to_tid[tid]);
-
-	struct ieee80211_local *local = temp_sta->local;
-	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
-	u8 *state;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, temp_sta->addr);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-	/* check if the TID waits for addBA response */
-	spin_lock_bh(&sta->lock);
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->lock);
-		*state = HT_AGG_STATE_IDLE;
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "timer expired on tid %d but we are not "
-				"expecting addBA response there", tid);
-#endif
-		goto timer_expired_exit;
-	}
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
-#endif
-
-	/* go through the state check in stop_BA_session */
-	*state = HT_AGG_STATE_OPERATIONAL;
-	spin_unlock_bh(&sta->lock);
-	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
-				     WLAN_BACK_INITIATOR);
-
-timer_expired_exit:
-	rcu_read_unlock();
-}
-
-/*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
  * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
@@ -3075,7 +2940,7 @@ static void ieee80211_rx_mgmt_action(str
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.addba_resp)))
 				break;
-			ieee80211_sta_process_addba_resp(dev, mgmt, len);
+			ieee80211_sta_process_addba_resp(sdata, mgmt, len);
 			break;
 		case WLAN_ACTION_DELBA:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
--- everything.orig/net/mac80211/ieee80211_i.h	2008-08-06 21:36:55.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-08-06 21:38:25.000000000 +0200
@@ -904,7 +904,6 @@ void ieee80211_send_bar(struct net_devic
 
 void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
-void sta_addba_resp_timer_expired(unsigned long data);
 void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8 *addr);
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
@@ -955,4 +954,8 @@ void mac80211_ev_michael_mic_failure(str
 #define debug_noinline
 #endif
 
+void ieee80211_sta_process_addba_resp(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_mgmt *mgmt,
+				      size_t len);
+
 #endif /* IEEE80211_I_H */
--- everything.orig/include/linux/ieee80211.h	2008-08-06 21:36:55.000000000 +0200
+++ everything/include/linux/ieee80211.h	2008-08-06 21:38:25.000000000 +0200
@@ -736,6 +736,19 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
+/* add-block-ack parameters */
+#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
+#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
+#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
+
+/* next values represent the buffer size for A-MPDU frame.
+ * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2) */
+#define IEEE80211_MIN_AMPDU_BUF 0x8
+#define IEEE80211_MAX_AMPDU_BUF 0x40
+
+
 /* MIMO Power Save Modes */
 #define WLAN_HT_CAP_MIMO_PS_STATIC	0
 #define WLAN_HT_CAP_MIMO_PS_DYNAMIC	1
@@ -934,6 +947,9 @@ enum ieee80211_eid {
 	WLAN_EID_QOS_PARAMETER = 222
 };
 
+/* mgmt header + 1 byte action code */
+#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
+
 /* Action category code */
 enum ieee80211_category {
 	WLAN_CATEGORY_SPECTRUM_MGMT = 0,


