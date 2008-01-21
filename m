Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420AbYAULwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:52:24 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 03/12] mac80211: A-MPDU Tx adding basic functionality
Date: Mon, 21 Jan 2008 13:52:03 +0200
Message-Id: <12009163393182-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115252_871583_36F9B240)
In-Reply-To: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the following abilities to mac80211:
 - start A-MPDU Tx session
 - stop A-MPDU Tx session
 - call backs to start/stop A-MPDU Tx session
 - sending addBA request
 - processing addBA response

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211.c     |  336 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |   14 ++
 net/mac80211/ieee80211_sta.c |  181 ++++++++++++++++++++++-
 3 files changed, 529 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 5dcc2d6..fdb845b 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -411,6 +411,329 @@ static int ieee80211_stop(struct net_device *dev)
 	return 0;
 }
 
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
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		printk(KERN_DEBUG "Could not find the station\n");
+		return -ENOENT;
+	}
+
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+
+	/* we have tried too many times, receiver does not want A-MPDU */
+	if (sta->ampdu_mlme.tid_tx[tid].addba_req_num >	HT_AGG_MAX_RETRIES) {
+		ret = -EBUSY;
+		goto start_ba_exit;
+	}
+
+	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	/* check if the TID is not in aggregation flow already */
+	if (*state != HT_AGG_STATE_IDLE) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - session is not "
+				 "idle on tid %u\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ret = -EAGAIN;
+		goto start_ba_exit;
+	}
+
+	/* FIXME: need a better way to ensure that TX flow won't interrupt us*/
+	/* until the end of the call to requeue function */
+	spin_lock_bh(&local->mdev->queue_lock);
+
+	/* create a new queue for this aggregation */
+	/* ret = ieee80211_ht_agg_queue_add(local, sta, tid); */
+
+	/* case no queue is available to aggregation */
+	/* don't switch to aggregation */
+	if (ret) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - no queue available for"
+					" tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		spin_unlock_bh(&local->mdev->queue_lock);
+		goto start_ba_exit;
+	}
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
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
+		/* ieee80211_ht_agg_queue_remove(local, sta, tid, 0); */
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - HW or queue unavailable"
+				" for tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		spin_unlock_bh(&local->mdev->queue_lock);
+		*state = HT_AGG_STATE_IDLE;
+		goto start_ba_exit;
+	}
+
+	/* Will put all the packets in the new SW queue */
+	/* ieee80211_requeue(local, ieee802_1d_to_ac[tid]); */
+	spin_unlock_bh(&local->mdev->queue_lock);
+
+	/* We have most probably almost emptied the legacy queue */
+	/* ieee80211_wake_queue(local_to_hw(local), ieee802_1d_to_ac[tid]); */
+
+	/* send an addBA request */
+	sta->ampdu_mlme.dialog_token_allocator++;
+	sta->ampdu_mlme.tid_tx[tid].dialog_token =
+			sta->ampdu_mlme.dialog_token_allocator;
+	sta->ampdu_mlme.tid_tx[tid].ssn = start_seq_num;
+
+	ieee80211_send_addba_request(sta->dev, ra, tid,
+			 sta->ampdu_mlme.tid_tx[tid].dialog_token,
+			 sta->ampdu_mlme.tid_tx[tid].ssn,
+			 0x40, 5000);
+
+	/* activate the timer for the recipient's addBA response */
+	sta->ampdu_mlme.tid_tx[tid].addba_resp_timer.expires =
+				jiffies + ADDBA_RESP_INTERVAL;
+	add_timer(&sta->ampdu_mlme.tid_tx[tid].addba_resp_timer);
+	printk(KERN_DEBUG "activated addBA response timer on tid %d\n", tid);
+
+start_ba_exit:
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	sta_info_put(sta);
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
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Stop a BA session requested for %s tid %u\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	sta = sta_info_get(local, ra);
+	if (!sta)
+		return -ENOENT;
+
+	/* check if the TID is in aggregation */
+	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+
+	if (*state != HT_AGG_STATE_OPERATIONAL) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "Try to stop Tx aggregation on"
+				" non active TID\n");
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ret = -ENOENT;
+		goto stop_BA_exit;
+	}
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
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	sta_info_put(sta);
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
+		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
+				tid, STA_TID_NUM);
+		return;
+	}
+
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		printk(KERN_DEBUG "Could not find station: %s\n",
+				print_mac(mac, ra));
+		return;
+	}
+
+	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
+				*state);
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		sta_info_put(sta);
+		return;
+	}
+
+	WARN_ON_ONCE(*state & HT_ADDBA_DRV_READY_MSK);
+
+	*state |= HT_ADDBA_DRV_READY_MSK;
+
+	if (*state == HT_AGG_STATE_OPERATIONAL) {
+		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
+		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+	}
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	sta_info_put(sta);
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
+		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
+				tid, STA_TID_NUM);
+		return;
+	}
+
+	printk(KERN_DEBUG "Stop a BA session requested on DA %s tid %d\n",
+				print_mac(mac, ra), tid);
+
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		printk(KERN_DEBUG "Could not find station: %s\n",
+				print_mac(mac, ra));
+		return;
+	}
+	state = &sta->ampdu_mlme.tid_tx[tid].state;
+
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
+		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
+		sta_info_put(sta);
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		return;
+	}
+
+	if (*state & HT_AGG_STATE_INITIATOR_MSK)
+		ieee80211_send_delba(sta->dev, ra, tid,
+			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
+
+	agg_queue = sta->tid_to_tx_q[tid];
+
+	/* avoid ordering issues: we are the only one that can modify
+	 * the content of the qdiscs */
+	spin_lock_bh(&local->mdev->queue_lock);
+	/* remove the queue for this aggregation */
+	/* ieee80211_ht_agg_queue_remove(local, sta, tid, 1); */
+	spin_unlock_bh(&local->mdev->queue_lock);
+
+	/* we just requeued the all the frames that were in the removed
+	 * queue, and since we might miss a softirq we do netif_schedule.
+	 * ieee80211_wake_queue is not used here as this queue is not
+	 * necessarily stopped */
+	netif_schedule(local->mdev);
+	*state = HT_AGG_STATE_IDLE;
+	sta->ampdu_mlme.tid_tx[tid].addba_req_num = 0;
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+
+	sta_info_put(sta);
+}
+EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
+
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+				      u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_ra_tid *ra_tid;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb)) {
+		if (net_ratelimit())
+			printk(KERN_WARNING "%s: Not enough memory, "
+			       "dropping start BA session", skb->dev->name);
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
+				     u8 *ra, u16 tid)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_ra_tid *ra_tid;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb)) {
+		if (net_ratelimit())
+			printk(KERN_WARNING "%s: Not enough memory, "
+			       "dropping stop BA session", skb->dev->name);
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
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -710,6 +1033,7 @@ static void ieee80211_tasklet_handler(unsigned long data)
 	struct sk_buff *skb;
 	struct ieee80211_rx_status rx_status;
 	struct ieee80211_tx_status *tx_status;
+	struct ieee80211_ra_tid *ra_tid;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
@@ -730,6 +1054,18 @@ static void ieee80211_tasklet_handler(unsigned long data)
 					    skb, tx_status);
 			kfree(tx_status);
 			break;
+		case IEEE80211_DELBA_MSG:
+			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
+			ieee80211_stop_tx_ba_cb(local_to_hw(local),
+						ra_tid->ra, ra_tid->tid);
+			dev_kfree_skb(skb);
+			break;
+		case IEEE80211_ADDBA_MSG:
+			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
+			ieee80211_start_tx_ba_cb(local_to_hw(local),
+						 ra_tid->ra, ra_tid->tid);
+			dev_kfree_skb(skb);
+			break ;
 		default: /* should never get here! */
 			printk(KERN_ERR "%s: Unknown message type (%d)\n",
 			       wiphy_name(local->hw.wiphy), skb->pkt_type);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 72ecbf7..8a24c2c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -407,6 +407,8 @@ struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
+	IEEE80211_DELBA_MSG	= 3,
+	IEEE80211_ADDBA_MSG	= 4,
 };
 
 struct ieee80211_local {
@@ -627,6 +629,12 @@ struct ieee80211_local {
 #endif
 };
 
+/* this struct represents 802.11n's RA/TID combination */
+struct ieee80211_ra_tid {
+	u8 ra[ETH_ALEN];
+	u16 tid;
+};
+
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
@@ -782,9 +790,15 @@ int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 int ieee80211_ht_addt_info_ie_to_ht_bss_info(
 			struct ieee80211_ht_addt_info *ht_add_info_ie,
 			struct ieee80211_ht_bss_info *bss_info);
+void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
+				  u16 tid, u8 dialog_token, u16 start_seq_num,
+				  u16 agg_size, u16 timeout);
+void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
+				u16 initiator, u16 reason_code);
 void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
 void sta_rx_agg_session_timer_expired(unsigned long data);
+void sta_addba_resp_timer_expired(unsigned long data);
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
 		     struct net_device **new_dev, int type);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 514c7f2..74fecac 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1044,6 +1044,58 @@ static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da, u16 tid,
 	return;
 }
 
+void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
+				u16 tid, u8 dialog_token, u16 start_seq_num,
+				u16 agg_size, u16 timeout)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 capab;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
+				sizeof(mgmt->u.action.u.addba_req));
+
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+				"for addba request frame\n", dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_req));
+
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
+
+	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
+	capab = (u16)(1 << 1);		/* bit 1 aggregation policy */
+	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
+	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
+
+	mgmt->u.action.u.addba_req.capab = cpu_to_le16(capab);
+
+	mgmt->u.action.u.addba_req.timeout = cpu_to_le16(timeout);
+	mgmt->u.action.u.addba_req.start_seq_num =
+					cpu_to_le16(start_seq_num << 4);
+
+	ieee80211_sta_tx(dev, skb, 0);
+}
+
 static void ieee80211_sta_process_addba_request(struct net_device *dev,
 						struct ieee80211_mgmt *mgmt,
 						size_t len)
@@ -1154,8 +1206,79 @@ end_no_lock:
 	sta_info_put(sta);
 }
 
-static void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
-				 u16 initiator, u16 reason_code)
+static void ieee80211_sta_process_addba_resp(struct net_device *dev,
+					     struct ieee80211_mgmt *mgmt,
+					     size_t len)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	u16 capab;
+	u16 tid;
+	u8 *state;
+
+	sta = sta_info_get(local, mgmt->sa);
+	if (!sta)
+		return;
+
+	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
+	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+
+	state = &sta->ampdu_mlme.tid_tx[tid].state;
+
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+
+	if (mgmt->u.action.u.addba_resp.dialog_token !=
+		sta->ampdu_mlme.tid_tx[tid].dialog_token) {
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		sta_info_put(sta);
+		return;
+	}
+
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid].addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
+			== WLAN_STATUS_SUCCESS) {
+		if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+			spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+			printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
+				"%d\n", *state);
+			sta_info_put(sta);
+			return;
+		}
+
+		if (*state & HT_ADDBA_RECEIVED_MSK)
+			printk(KERN_DEBUG "double addBA response\n");
+
+		*state |= HT_ADDBA_RECEIVED_MSK;
+		sta->ampdu_mlme.tid_tx[tid].addba_req_num = 0;
+
+		if (*state == HT_AGG_STATE_OPERATIONAL) {
+			printk(KERN_DEBUG "Aggregation on for tid %d \n", tid);
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+		}
+
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		printk(KERN_DEBUG "recipient accepted agg: tid %d \n", tid);
+	} else {
+		printk(KERN_DEBUG "recipient rejected agg: tid %d \n", tid);
+
+		sta->ampdu_mlme.tid_tx[tid].addba_req_num++;
+		/* this will allow the state check in stop_BA_session */
+		*state = HT_AGG_STATE_OPERATIONAL;
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
+					     WLAN_BACK_INITIATOR);
+	}
+	sta_info_put(sta);
+}
+void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
+			  u16 initiator, u16 reason_code)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1257,6 +1380,7 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 	sta_info_put(sta);
 }
 
+
 static void ieee80211_sta_process_delba(struct net_device *dev,
 			struct ieee80211_mgmt *mgmt, size_t len)
 {
@@ -1288,6 +1412,53 @@ static void ieee80211_sta_process_delba(struct net_device *dev,
 }
 
 /*
+ * After sending add Block Ack request we activated a timer until
+ * add Block Ack response will arrive from the recipient.
+ * If this timer expires sta_addba_resp_timer_expired will be executed.
+ */
+void sta_addba_resp_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and both sta_info and TID are needed, so init
+	 * flow in sta_info_add gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u16 tid = *(int *)data;
+	struct sta_info *temp_sta = container_of((void *)data,
+		struct sta_info, timer_to_tid[tid]);
+
+	struct ieee80211_local *local = temp_sta->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	u8 *state;
+
+	sta = sta_info_get(local, temp_sta->addr);
+	if (!sta)
+		return;
+
+	state = &sta->ampdu_mlme.tid_tx[tid].state;
+	/* check if the TID waits for addBA response */
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		*state = HT_AGG_STATE_IDLE;
+		printk(KERN_DEBUG "timer expired on tid %d but we are not "
+				"expecting addBA response there", tid);
+		goto timer_expired_exit;
+	}
+
+	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
+
+	/* go through the state check in stop_BA_session */
+	*state = HT_AGG_STATE_OPERATIONAL;
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
+				     WLAN_BACK_INITIATOR);
+
+timer_expired_exit:
+	sta_info_put(sta);
+}
+
+/*
  * After receiving Block Ack Request (BAR) we activated a
  * timer after each frame arrives from the originator.
  * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
@@ -2234,6 +2405,12 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
 				break;
 			ieee80211_sta_process_addba_request(dev, mgmt, len);
 			break;
+		case WLAN_ACTION_ADDBA_RESP:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.addba_resp)))
+				break;
+			ieee80211_sta_process_addba_resp(dev, mgmt, len);
+			break;
 		case WLAN_ACTION_DELBA:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.delba)))
-- 
1.5.3.7

