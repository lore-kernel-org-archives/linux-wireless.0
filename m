Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36349 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbbKZK5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/8] mac80211: move off-channel/mgmt-tx code to offchannel.oc
Date: Thu, 26 Nov 2015 11:57:45 +0100
Message-Id: <1448535468-12237-5-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115839_312775_99947A8C)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is quite a bit of code that logically depends here since
it has to deal with all the remain-on-channel logic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 500 ++-------------------------------------------
 net/mac80211/ieee80211_i.h |  19 +-
 net/mac80211/offchannel.c  | 470 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 498 insertions(+), 491 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 25199e2d9b50..ae1b92a58e23 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2509,294 +2509,6 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	return 0;
 }
 
-static bool ieee80211_coalesce_started_roc(struct ieee80211_local *local,
-					   struct ieee80211_roc_work *new_roc,
-					   struct ieee80211_roc_work *cur_roc)
-{
-	unsigned long now = jiffies;
-	unsigned long remaining = cur_roc->hw_start_time +
-				  msecs_to_jiffies(cur_roc->duration) -
-				  now;
-
-	if (WARN_ON(!cur_roc->started || !cur_roc->hw_begun))
-		return false;
-
-	/* if it doesn't fit entirely, schedule a new one */
-	if (new_roc->duration > jiffies_to_msecs(remaining))
-		return false;
-
-	ieee80211_handle_roc_started(new_roc);
-
-	/* add to dependents so we send the expired event properly */
-	list_add_tail(&new_roc->list, &cur_roc->dependents);
-	return true;
-}
-
-static u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local)
-{
-	lockdep_assert_held(&local->mtx);
-
-	local->roc_cookie_counter++;
-
-	/* wow, you wrapped 64 bits ... more likely a bug */
-	if (WARN_ON(local->roc_cookie_counter == 0))
-		local->roc_cookie_counter++;
-
-	return local->roc_cookie_counter;
-}
-
-static int ieee80211_start_roc_work(struct ieee80211_local *local,
-				    struct ieee80211_sub_if_data *sdata,
-				    struct ieee80211_channel *channel,
-				    unsigned int duration, u64 *cookie,
-				    struct sk_buff *txskb,
-				    enum ieee80211_roc_type type)
-{
-	struct ieee80211_roc_work *roc, *tmp;
-	bool queued = false;
-	int ret;
-
-	lockdep_assert_held(&local->mtx);
-
-	if (local->use_chanctx && !local->ops->remain_on_channel)
-		return -EOPNOTSUPP;
-
-	roc = kzalloc(sizeof(*roc), GFP_KERNEL);
-	if (!roc)
-		return -ENOMEM;
-
-	/*
-	 * If the duration is zero, then the driver
-	 * wouldn't actually do anything. Set it to
-	 * 10 for now.
-	 *
-	 * TODO: cancel the off-channel operation
-	 *       when we get the SKB's TX status and
-	 *       the wait time was zero before.
-	 */
-	if (!duration)
-		duration = 10;
-
-	roc->chan = channel;
-	roc->duration = duration;
-	roc->req_duration = duration;
-	roc->frame = txskb;
-	roc->type = type;
-	roc->sdata = sdata;
-	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
-	INIT_LIST_HEAD(&roc->dependents);
-
-	/*
-	 * cookie is either the roc cookie (for normal roc)
-	 * or the SKB (for mgmt TX)
-	 */
-	if (!txskb) {
-		roc->cookie = ieee80211_mgmt_tx_cookie(local);
-		*cookie = roc->cookie;
-	} else {
-		roc->mgmt_tx_cookie = *cookie;
-	}
-
-	/* if there's one pending or we're scanning, queue this one */
-	if (!list_empty(&local->roc_list) ||
-	    local->scanning || ieee80211_is_radar_required(local))
-		goto out_check_combine;
-
-	/* if not HW assist, just queue & schedule work */
-	if (!local->ops->remain_on_channel) {
-		ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
-		goto out_queue;
-	}
-
-	/* otherwise actually kick it off here (for error handling) */
-
-	ret = drv_remain_on_channel(local, sdata, channel, duration, type);
-	if (ret) {
-		kfree(roc);
-		return ret;
-	}
-
-	roc->started = true;
-	goto out_queue;
-
- out_check_combine:
-	list_for_each_entry(tmp, &local->roc_list, list) {
-		if (tmp->chan != channel || tmp->sdata != sdata)
-			continue;
-
-		/*
-		 * Extend this ROC if possible:
-		 *
-		 * If it hasn't started yet, just increase the duration
-		 * and add the new one to the list of dependents.
-		 * If the type of the new ROC has higher priority, modify the
-		 * type of the previous one to match that of the new one.
-		 */
-		if (!tmp->started) {
-			list_add_tail(&roc->list, &tmp->dependents);
-			tmp->duration = max(tmp->duration, roc->duration);
-			tmp->type = max(tmp->type, roc->type);
-			queued = true;
-			break;
-		}
-
-		/* If it has already started, it's more difficult ... */
-		if (local->ops->remain_on_channel) {
-			/*
-			 * In the offloaded ROC case, if it hasn't begun, add
-			 * this new one to the dependent list to be handled
-			 * when the master one begins. If it has begun,
-			 * check if it fits entirely within the existing one,
-			 * in which case it will just be dependent as well.
-			 * Otherwise, schedule it by itself.
-			 */
-			if (!tmp->hw_begun) {
-				list_add_tail(&roc->list, &tmp->dependents);
-				queued = true;
-				break;
-			}
-
-			if (ieee80211_coalesce_started_roc(local, roc, tmp))
-				queued = true;
-		} else if (del_timer_sync(&tmp->work.timer)) {
-			unsigned long new_end;
-
-			/*
-			 * In the software ROC case, cancel the timer, if
-			 * that fails then the finish work is already
-			 * queued/pending and thus we queue the new ROC
-			 * normally, if that succeeds then we can extend
-			 * the timer duration and TX the frame (if any.)
-			 */
-
-			list_add_tail(&roc->list, &tmp->dependents);
-			queued = true;
-
-			new_end = jiffies + msecs_to_jiffies(roc->duration);
-
-			/* ok, it was started & we canceled timer */
-			if (time_after(new_end, tmp->work.timer.expires))
-				mod_timer(&tmp->work.timer, new_end);
-			else
-				add_timer(&tmp->work.timer);
-
-			ieee80211_handle_roc_started(roc);
-		}
-		break;
-	}
-
- out_queue:
-	if (!queued)
-		list_add_tail(&roc->list, &local->roc_list);
-
-	return 0;
-}
-
-static int ieee80211_remain_on_channel(struct wiphy *wiphy,
-				       struct wireless_dev *wdev,
-				       struct ieee80211_channel *chan,
-				       unsigned int duration,
-				       u64 *cookie)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	struct ieee80211_local *local = sdata->local;
-	int ret;
-
-	mutex_lock(&local->mtx);
-	ret = ieee80211_start_roc_work(local, sdata, chan,
-				       duration, cookie, NULL,
-				       IEEE80211_ROC_TYPE_NORMAL);
-	mutex_unlock(&local->mtx);
-
-	return ret;
-}
-
-static int ieee80211_cancel_roc(struct ieee80211_local *local,
-				u64 cookie, bool mgmt_tx)
-{
-	struct ieee80211_roc_work *roc, *tmp, *found = NULL;
-	int ret;
-
-	mutex_lock(&local->mtx);
-	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
-		struct ieee80211_roc_work *dep, *tmp2;
-
-		list_for_each_entry_safe(dep, tmp2, &roc->dependents, list) {
-			if (!mgmt_tx && dep->cookie != cookie)
-				continue;
-			else if (mgmt_tx && dep->mgmt_tx_cookie != cookie)
-				continue;
-			/* found dependent item -- just remove it */
-			list_del(&dep->list);
-			mutex_unlock(&local->mtx);
-
-			ieee80211_roc_notify_destroy(dep, true);
-			return 0;
-		}
-
-		if (!mgmt_tx && roc->cookie != cookie)
-			continue;
-		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
-			continue;
-
-		found = roc;
-		break;
-	}
-
-	if (!found) {
-		mutex_unlock(&local->mtx);
-		return -ENOENT;
-	}
-
-	/*
-	 * We found the item to cancel, so do that. Note that it
-	 * may have dependents, which we also cancel (and send
-	 * the expired signal for.) Not doing so would be quite
-	 * tricky here, but we may need to fix it later.
-	 */
-
-	if (local->ops->remain_on_channel) {
-		if (found->started) {
-			ret = drv_cancel_remain_on_channel(local);
-			if (WARN_ON_ONCE(ret)) {
-				mutex_unlock(&local->mtx);
-				return ret;
-			}
-		}
-
-		list_del(&found->list);
-
-		if (found->started)
-			ieee80211_start_next_roc(local);
-		mutex_unlock(&local->mtx);
-
-		ieee80211_roc_notify_destroy(found, true);
-	} else {
-		/* work may be pending so use it all the time */
-		found->abort = true;
-		ieee80211_queue_delayed_work(&local->hw, &found->work, 0);
-
-		mutex_unlock(&local->mtx);
-
-		/* work will clean up etc */
-		flush_delayed_work(&found->work);
-		WARN_ON(!found->to_be_freed);
-		kfree(found);
-	}
-
-	return 0;
-}
-
-static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
-					      struct wireless_dev *wdev,
-					      u64 cookie)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	struct ieee80211_local *local = sdata->local;
-
-	return ieee80211_cancel_roc(local, cookie, false);
-}
-
 static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 					   struct net_device *dev,
 					   struct cfg80211_chan_def *chandef,
@@ -3267,9 +2979,22 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
-static struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
-					      struct sk_buff *skb, u64 *cookie,
-					      gfp_t gfp)
+u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local)
+{
+	lockdep_assert_held(&local->mtx);
+
+	local->roc_cookie_counter++;
+
+	/* wow, you wrapped 64 bits ... more likely a bug */
+	if (WARN_ON(local->roc_cookie_counter == 0))
+		local->roc_cookie_counter++;
+
+	return local->roc_cookie_counter;
+}
+
+struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
+				       struct sk_buff *skb, u64 *cookie,
+				       gfp_t gfp)
 {
 	unsigned long spin_flags;
 	struct sk_buff *ack_skb;
@@ -3297,199 +3022,6 @@ static struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
 	return ack_skb;
 }
 
-static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-			     struct cfg80211_mgmt_tx_params *params,
-			     u64 *cookie)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb, *ack_skb;
-	struct sta_info *sta;
-	const struct ieee80211_mgmt *mgmt = (void *)params->buf;
-	bool need_offchan = false;
-	u32 flags;
-	int ret;
-	u8 *data;
-
-	if (params->dont_wait_for_ack)
-		flags = IEEE80211_TX_CTL_NO_ACK;
-	else
-		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-			IEEE80211_TX_CTL_REQ_TX_STATUS;
-
-	if (params->no_cck)
-		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_ADHOC:
-		if (!sdata->vif.bss_conf.ibss_joined)
-			need_offchan = true;
-		/* fall through */
-#ifdef CONFIG_MAC80211_MESH
-	case NL80211_IFTYPE_MESH_POINT:
-		if (ieee80211_vif_is_mesh(&sdata->vif) &&
-		    !sdata->u.mesh.mesh_id_len)
-			need_offchan = true;
-		/* fall through */
-#endif
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_P2P_GO:
-		if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-		    !ieee80211_vif_is_mesh(&sdata->vif) &&
-		    !rcu_access_pointer(sdata->bss->beacon))
-			need_offchan = true;
-		if (!ieee80211_is_action(mgmt->frame_control) ||
-		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
-		    mgmt->u.action.category == WLAN_CATEGORY_SELF_PROTECTED ||
-		    mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT)
-			break;
-		rcu_read_lock();
-		sta = sta_info_get(sdata, mgmt->da);
-		rcu_read_unlock();
-		if (!sta)
-			return -ENOLINK;
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_P2P_CLIENT:
-		sdata_lock(sdata);
-		if (!sdata->u.mgd.associated ||
-		    (params->offchan && params->wait &&
-		     local->ops->remain_on_channel &&
-		     memcmp(sdata->u.mgd.associated->bssid,
-			    mgmt->bssid, ETH_ALEN)))
-			need_offchan = true;
-		sdata_unlock(sdata);
-		break;
-	case NL80211_IFTYPE_P2P_DEVICE:
-		need_offchan = true;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	/* configurations requiring offchan cannot work if no channel has been
-	 * specified
-	 */
-	if (need_offchan && !params->chan)
-		return -EINVAL;
-
-	mutex_lock(&local->mtx);
-
-	/* Check if the operating channel is the requested channel */
-	if (!need_offchan) {
-		struct ieee80211_chanctx_conf *chanctx_conf;
-
-		rcu_read_lock();
-		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-
-		if (chanctx_conf) {
-			need_offchan = params->chan &&
-				       (params->chan !=
-					chanctx_conf->def.chan);
-		} else if (!params->chan) {
-			ret = -EINVAL;
-			rcu_read_unlock();
-			goto out_unlock;
-		} else {
-			need_offchan = true;
-		}
-		rcu_read_unlock();
-	}
-
-	if (need_offchan && !params->offchan) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + params->len);
-	if (!skb) {
-		ret = -ENOMEM;
-		goto out_unlock;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	data = skb_put(skb, params->len);
-	memcpy(data, params->buf, params->len);
-
-	/* Update CSA counters */
-	if (sdata->vif.csa_active &&
-	    (sdata->vif.type == NL80211_IFTYPE_AP ||
-	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
-	    params->n_csa_offsets) {
-		int i;
-		struct beacon_data *beacon = NULL;
-
-		rcu_read_lock();
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			beacon = rcu_dereference(sdata->u.ap.beacon);
-		else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-			beacon = rcu_dereference(sdata->u.ibss.presp);
-		else if (ieee80211_vif_is_mesh(&sdata->vif))
-			beacon = rcu_dereference(sdata->u.mesh.beacon);
-
-		if (beacon)
-			for (i = 0; i < params->n_csa_offsets; i++)
-				data[params->csa_offsets[i]] =
-					beacon->csa_current_counter;
-
-		rcu_read_unlock();
-	}
-
-	IEEE80211_SKB_CB(skb)->flags = flags;
-
-	skb->dev = sdata->dev;
-
-	if (!params->dont_wait_for_ack) {
-		/* make a copy to preserve the frame contents
-		 * in case of encryption.
-		 */
-		ack_skb = ieee80211_make_ack_skb(local, skb, cookie,
-						 GFP_KERNEL);
-		if (IS_ERR(ack_skb)) {
-			ret = PTR_ERR(ack_skb);
-			kfree_skb(skb);
-			goto out_unlock;
-		}
-	} else {
-		/* for cookie below */
-		ack_skb = skb;
-	}
-
-	if (!need_offchan) {
-		ieee80211_tx_skb(sdata, skb);
-		ret = 0;
-		goto out_unlock;
-	}
-
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN |
-					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
-	if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
-		IEEE80211_SKB_CB(skb)->hw_queue =
-			local->hw.offchannel_tx_hw_queue;
-
-	/* This will handle all kinds of coalescing and immediate TX */
-	ret = ieee80211_start_roc_work(local, sdata, params->chan,
-				       params->wait, cookie, skb,
-				       IEEE80211_ROC_TYPE_MGMT_TX);
-	if (ret)
-		ieee80211_free_txskb(&local->hw, skb);
- out_unlock:
-	mutex_unlock(&local->mtx);
-	return ret;
-}
-
-static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
-					 struct wireless_dev *wdev,
-					 u64 cookie)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-
-	return ieee80211_cancel_roc(local, cookie, true);
-}
-
 static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 					  struct wireless_dev *wdev,
 					  u16 frame_type, bool reg)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d832bd59236b..b03d5410a2e9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1483,6 +1483,11 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
+u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local);
+struct sk_buff *ieee80211_make_ack_skb(struct ieee80211_local *local,
+				       struct sk_buff *skb, u64 *cookie,
+				       gfp_t gfp);
+
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
@@ -1577,16 +1582,22 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_local *local);
 void ieee80211_sched_scan_end(struct ieee80211_local *local);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
-/* off-channel helpers */
+/* off-channel/mgmt-tx */
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
 void ieee80211_roc_purge(struct ieee80211_local *local,
 			 struct ieee80211_sub_if_data *sdata);
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
-void ieee80211_sw_roc_work(struct work_struct *work);
-void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
+int ieee80211_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+				struct ieee80211_channel *chan,
+				unsigned int duration, u64 *cookie);
+int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
+				       struct wireless_dev *wdev, u64 cookie);
+int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+		      struct cfg80211_mgmt_tx_params *params, u64 *cookie);
+int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
+				  struct wireless_dev *wdev, u64 cookie);
 
 /* channel switch handling */
 void ieee80211_csa_finalize_work(struct work_struct *work);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 0fe9f746cd7e..bf21301dfa4b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -187,7 +187,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 					false);
 }
 
-void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
+static void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
 {
 	if (roc->notified)
 		return;
@@ -299,7 +299,8 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 	}
 }
 
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free)
+static void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc,
+					 bool free)
 {
 	struct ieee80211_roc_work *dep, *tmp;
 
@@ -328,7 +329,7 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free)
 		roc->to_be_freed = true;
 }
 
-void ieee80211_sw_roc_work(struct work_struct *work)
+static void ieee80211_sw_roc_work(struct work_struct *work)
 {
 	struct ieee80211_roc_work *roc =
 		container_of(work, struct ieee80211_roc_work, work.work);
@@ -455,6 +456,469 @@ void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(ieee80211_remain_on_channel_expired);
 
+static bool ieee80211_coalesce_started_roc(struct ieee80211_local *local,
+					   struct ieee80211_roc_work *new_roc,
+					   struct ieee80211_roc_work *cur_roc)
+{
+	unsigned long now = jiffies;
+	unsigned long remaining = cur_roc->hw_start_time +
+				  msecs_to_jiffies(cur_roc->duration) -
+				  now;
+
+	if (WARN_ON(!cur_roc->started || !cur_roc->hw_begun))
+		return false;
+
+	/* if it doesn't fit entirely, schedule a new one */
+	if (new_roc->duration > jiffies_to_msecs(remaining))
+		return false;
+
+	ieee80211_handle_roc_started(new_roc);
+
+	/* add to dependents so we send the expired event properly */
+	list_add_tail(&new_roc->list, &cur_roc->dependents);
+	return true;
+}
+
+static int ieee80211_start_roc_work(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_channel *channel,
+				    unsigned int duration, u64 *cookie,
+				    struct sk_buff *txskb,
+				    enum ieee80211_roc_type type)
+{
+	struct ieee80211_roc_work *roc, *tmp;
+	bool queued = false;
+	int ret;
+
+	lockdep_assert_held(&local->mtx);
+
+	if (local->use_chanctx && !local->ops->remain_on_channel)
+		return -EOPNOTSUPP;
+
+	roc = kzalloc(sizeof(*roc), GFP_KERNEL);
+	if (!roc)
+		return -ENOMEM;
+
+	/*
+	 * If the duration is zero, then the driver
+	 * wouldn't actually do anything. Set it to
+	 * 10 for now.
+	 *
+	 * TODO: cancel the off-channel operation
+	 *       when we get the SKB's TX status and
+	 *       the wait time was zero before.
+	 */
+	if (!duration)
+		duration = 10;
+
+	roc->chan = channel;
+	roc->duration = duration;
+	roc->req_duration = duration;
+	roc->frame = txskb;
+	roc->type = type;
+	roc->sdata = sdata;
+	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
+	INIT_LIST_HEAD(&roc->dependents);
+
+	/*
+	 * cookie is either the roc cookie (for normal roc)
+	 * or the SKB (for mgmt TX)
+	 */
+	if (!txskb) {
+		roc->cookie = ieee80211_mgmt_tx_cookie(local);
+		*cookie = roc->cookie;
+	} else {
+		roc->mgmt_tx_cookie = *cookie;
+	}
+
+	/* if there's one pending or we're scanning, queue this one */
+	if (!list_empty(&local->roc_list) ||
+	    local->scanning || ieee80211_is_radar_required(local))
+		goto out_check_combine;
+
+	/* if not HW assist, just queue & schedule work */
+	if (!local->ops->remain_on_channel) {
+		ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
+		goto out_queue;
+	}
+
+	/* otherwise actually kick it off here (for error handling) */
+
+	ret = drv_remain_on_channel(local, sdata, channel, duration, type);
+	if (ret) {
+		kfree(roc);
+		return ret;
+	}
+
+	roc->started = true;
+	goto out_queue;
+
+ out_check_combine:
+	list_for_each_entry(tmp, &local->roc_list, list) {
+		if (tmp->chan != channel || tmp->sdata != sdata)
+			continue;
+
+		/*
+		 * Extend this ROC if possible:
+		 *
+		 * If it hasn't started yet, just increase the duration
+		 * and add the new one to the list of dependents.
+		 * If the type of the new ROC has higher priority, modify the
+		 * type of the previous one to match that of the new one.
+		 */
+		if (!tmp->started) {
+			list_add_tail(&roc->list, &tmp->dependents);
+			tmp->duration = max(tmp->duration, roc->duration);
+			tmp->type = max(tmp->type, roc->type);
+			queued = true;
+			break;
+		}
+
+		/* If it has already started, it's more difficult ... */
+		if (local->ops->remain_on_channel) {
+			/*
+			 * In the offloaded ROC case, if it hasn't begun, add
+			 * this new one to the dependent list to be handled
+			 * when the master one begins. If it has begun,
+			 * check if it fits entirely within the existing one,
+			 * in which case it will just be dependent as well.
+			 * Otherwise, schedule it by itself.
+			 */
+			if (!tmp->hw_begun) {
+				list_add_tail(&roc->list, &tmp->dependents);
+				queued = true;
+				break;
+			}
+
+			if (ieee80211_coalesce_started_roc(local, roc, tmp))
+				queued = true;
+		} else if (del_timer_sync(&tmp->work.timer)) {
+			unsigned long new_end;
+
+			/*
+			 * In the software ROC case, cancel the timer, if
+			 * that fails then the finish work is already
+			 * queued/pending and thus we queue the new ROC
+			 * normally, if that succeeds then we can extend
+			 * the timer duration and TX the frame (if any.)
+			 */
+
+			list_add_tail(&roc->list, &tmp->dependents);
+			queued = true;
+
+			new_end = jiffies + msecs_to_jiffies(roc->duration);
+
+			/* ok, it was started & we canceled timer */
+			if (time_after(new_end, tmp->work.timer.expires))
+				mod_timer(&tmp->work.timer, new_end);
+			else
+				add_timer(&tmp->work.timer);
+
+			ieee80211_handle_roc_started(roc);
+		}
+		break;
+	}
+
+ out_queue:
+	if (!queued)
+		list_add_tail(&roc->list, &local->roc_list);
+
+	return 0;
+}
+
+int ieee80211_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+				struct ieee80211_channel *chan,
+				unsigned int duration, u64 *cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+
+	mutex_lock(&local->mtx);
+	ret = ieee80211_start_roc_work(local, sdata, chan,
+				       duration, cookie, NULL,
+				       IEEE80211_ROC_TYPE_NORMAL);
+	mutex_unlock(&local->mtx);
+
+	return ret;
+}
+
+static int ieee80211_cancel_roc(struct ieee80211_local *local,
+				u64 cookie, bool mgmt_tx)
+{
+	struct ieee80211_roc_work *roc, *tmp, *found = NULL;
+	int ret;
+
+	mutex_lock(&local->mtx);
+	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
+		struct ieee80211_roc_work *dep, *tmp2;
+
+		list_for_each_entry_safe(dep, tmp2, &roc->dependents, list) {
+			if (!mgmt_tx && dep->cookie != cookie)
+				continue;
+			else if (mgmt_tx && dep->mgmt_tx_cookie != cookie)
+				continue;
+			/* found dependent item -- just remove it */
+			list_del(&dep->list);
+			mutex_unlock(&local->mtx);
+
+			ieee80211_roc_notify_destroy(dep, true);
+			return 0;
+		}
+
+		if (!mgmt_tx && roc->cookie != cookie)
+			continue;
+		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
+			continue;
+
+		found = roc;
+		break;
+	}
+
+	if (!found) {
+		mutex_unlock(&local->mtx);
+		return -ENOENT;
+	}
+
+	/*
+	 * We found the item to cancel, so do that. Note that it
+	 * may have dependents, which we also cancel (and send
+	 * the expired signal for.) Not doing so would be quite
+	 * tricky here, but we may need to fix it later.
+	 */
+
+	if (local->ops->remain_on_channel) {
+		if (found->started) {
+			ret = drv_cancel_remain_on_channel(local);
+			if (WARN_ON_ONCE(ret)) {
+				mutex_unlock(&local->mtx);
+				return ret;
+			}
+		}
+
+		list_del(&found->list);
+
+		if (found->started)
+			ieee80211_start_next_roc(local);
+		mutex_unlock(&local->mtx);
+
+		ieee80211_roc_notify_destroy(found, true);
+	} else {
+		/* work may be pending so use it all the time */
+		found->abort = true;
+		ieee80211_queue_delayed_work(&local->hw, &found->work, 0);
+
+		mutex_unlock(&local->mtx);
+
+		/* work will clean up etc */
+		flush_delayed_work(&found->work);
+		WARN_ON(!found->to_be_freed);
+		kfree(found);
+	}
+
+	return 0;
+}
+
+int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
+				       struct wireless_dev *wdev, u64 cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_local *local = sdata->local;
+
+	return ieee80211_cancel_roc(local, cookie, false);
+}
+
+int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+		      struct cfg80211_mgmt_tx_params *params, u64 *cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb, *ack_skb;
+	struct sta_info *sta;
+	const struct ieee80211_mgmt *mgmt = (void *)params->buf;
+	bool need_offchan = false;
+	u32 flags;
+	int ret;
+	u8 *data;
+
+	if (params->dont_wait_for_ack)
+		flags = IEEE80211_TX_CTL_NO_ACK;
+	else
+		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
+			IEEE80211_TX_CTL_REQ_TX_STATUS;
+
+	if (params->no_cck)
+		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+		if (!sdata->vif.bss_conf.ibss_joined)
+			need_offchan = true;
+		/* fall through */
+#ifdef CONFIG_MAC80211_MESH
+	case NL80211_IFTYPE_MESH_POINT:
+		if (ieee80211_vif_is_mesh(&sdata->vif) &&
+		    !sdata->u.mesh.mesh_id_len)
+			need_offchan = true;
+		/* fall through */
+#endif
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
+		if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		    !ieee80211_vif_is_mesh(&sdata->vif) &&
+		    !rcu_access_pointer(sdata->bss->beacon))
+			need_offchan = true;
+		if (!ieee80211_is_action(mgmt->frame_control) ||
+		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
+		    mgmt->u.action.category == WLAN_CATEGORY_SELF_PROTECTED ||
+		    mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT)
+			break;
+		rcu_read_lock();
+		sta = sta_info_get(sdata, mgmt->da);
+		rcu_read_unlock();
+		if (!sta)
+			return -ENOLINK;
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		sdata_lock(sdata);
+		if (!sdata->u.mgd.associated ||
+		    (params->offchan && params->wait &&
+		     local->ops->remain_on_channel &&
+		     memcmp(sdata->u.mgd.associated->bssid,
+			    mgmt->bssid, ETH_ALEN)))
+			need_offchan = true;
+		sdata_unlock(sdata);
+		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		need_offchan = true;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* configurations requiring offchan cannot work if no channel has been
+	 * specified
+	 */
+	if (need_offchan && !params->chan)
+		return -EINVAL;
+
+	mutex_lock(&local->mtx);
+
+	/* Check if the operating channel is the requested channel */
+	if (!need_offchan) {
+		struct ieee80211_chanctx_conf *chanctx_conf;
+
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+
+		if (chanctx_conf) {
+			need_offchan = params->chan &&
+				       (params->chan !=
+					chanctx_conf->def.chan);
+		} else if (!params->chan) {
+			ret = -EINVAL;
+			rcu_read_unlock();
+			goto out_unlock;
+		} else {
+			need_offchan = true;
+		}
+		rcu_read_unlock();
+	}
+
+	if (need_offchan && !params->offchan) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + params->len);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	data = skb_put(skb, params->len);
+	memcpy(data, params->buf, params->len);
+
+	/* Update CSA counters */
+	if (sdata->vif.csa_active &&
+	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
+	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
+	    params->n_csa_offsets) {
+		int i;
+		struct beacon_data *beacon = NULL;
+
+		rcu_read_lock();
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
+			beacon = rcu_dereference(sdata->u.ap.beacon);
+		else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+			beacon = rcu_dereference(sdata->u.ibss.presp);
+		else if (ieee80211_vif_is_mesh(&sdata->vif))
+			beacon = rcu_dereference(sdata->u.mesh.beacon);
+
+		if (beacon)
+			for (i = 0; i < params->n_csa_offsets; i++)
+				data[params->csa_offsets[i]] =
+					beacon->csa_current_counter;
+
+		rcu_read_unlock();
+	}
+
+	IEEE80211_SKB_CB(skb)->flags = flags;
+
+	skb->dev = sdata->dev;
+
+	if (!params->dont_wait_for_ack) {
+		/* make a copy to preserve the frame contents
+		 * in case of encryption.
+		 */
+		ack_skb = ieee80211_make_ack_skb(local, skb, cookie,
+						 GFP_KERNEL);
+		if (IS_ERR(ack_skb)) {
+			ret = PTR_ERR(ack_skb);
+			kfree_skb(skb);
+			goto out_unlock;
+		}
+	} else {
+		/* for cookie below */
+		ack_skb = skb;
+	}
+
+	if (!need_offchan) {
+		ieee80211_tx_skb(sdata, skb);
+		ret = 0;
+		goto out_unlock;
+	}
+
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN |
+					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
+	if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+		IEEE80211_SKB_CB(skb)->hw_queue =
+			local->hw.offchannel_tx_hw_queue;
+
+	/* This will handle all kinds of coalescing and immediate TX */
+	ret = ieee80211_start_roc_work(local, sdata, params->chan,
+				       params->wait, cookie, skb,
+				       IEEE80211_ROC_TYPE_MGMT_TX);
+	if (ret)
+		ieee80211_free_txskb(&local->hw, skb);
+ out_unlock:
+	mutex_unlock(&local->mtx);
+	return ret;
+}
+
+int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
+				  struct wireless_dev *wdev, u64 cookie)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return ieee80211_cancel_roc(local, cookie, true);
+}
+
 void ieee80211_roc_setup(struct ieee80211_local *local)
 {
 	INIT_WORK(&local->hw_roc_start, ieee80211_hw_roc_start);
-- 
2.6.2

