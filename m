Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36355 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbbKZK5z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/8] mac80211: rewrite remain-on-channel logic
Date: Thu, 26 Nov 2015 11:57:48 +0100
Message-Id: <1448535468-12237-8-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115837_668615_27C0F44B)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Jouni found a bug in the remain-on-channel logic: when a short item
is queued, a long item is combined with it extending the original
one, and then the long item is deleted, the timeout doesn't go back
to the short one, and the short item ends up taking a long time. In
this case, this showed as blocking scan when running two test cases
back to back - the scan from the second was delayed even though all
the remain-on-channel items should long have been gone.

Fixing this with the current data structures turns out to be a bit
complicated, we just remove the long item from the dependents list
right now and don't recalculate the timeouts.

There's a somewhat similar bug where we delete the short item and
all the dependents go with it; to fix this we'd have to move them
from the dependents to the real list.

Instead of trying to do that, rewrite the code to not have all this
complexity in the data structures: use a single list and allow more
than one entry in it being marked as started. This makes the code a
bit more complex, the worker needs to understand that it might need
to just remove one of the started items, while keeping the device
off-channel, but that's not more complicated than the nested data
structures.

This then fixes both issues described, and makes it easier to also
limit the overall off-channel time when combining.

TODO: as before, with hardware remain-on-channel, deleting an item
after combining results in cancelling them all - we can keep track
of the time elapsed and only cancel after that to fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   7 +-
 net/mac80211/main.c        |   1 +
 net/mac80211/offchannel.c  | 599 +++++++++++++++++++++++----------------------
 3 files changed, 316 insertions(+), 291 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0c50031fadac..c30b6842ed9f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -325,19 +325,15 @@ struct mesh_preq_queue {
 
 struct ieee80211_roc_work {
 	struct list_head list;
-	struct list_head dependents;
-
-	struct delayed_work work;
 
 	struct ieee80211_sub_if_data *sdata;
 
 	struct ieee80211_channel *chan;
 
 	bool started, abort, hw_begun, notified;
-	bool to_be_freed;
 	bool on_channel;
 
-	unsigned long hw_start_time;
+	unsigned long start_time;
 
 	u32 duration, req_duration;
 	struct sk_buff *frame;
@@ -1335,6 +1331,7 @@ struct ieee80211_local {
 	/*
 	 * Remain-on-channel support
 	 */
+	struct delayed_work roc_work;
 	struct list_head roc_list;
 	struct work_struct hw_roc_start, hw_roc_done;
 	unsigned long hw_roc_start_time;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 858f6b1cb149..6bcf0faa4a89 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1149,6 +1149,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
+	cancel_delayed_work_sync(&local->roc_work);
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
 	cancel_work_sync(&local->tdls_chsw_work);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index d616ce34fea7..ce8e1a6c7281 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -187,11 +187,76 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 					false);
 }
 
-static void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
+static void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 {
-	if (roc->notified)
+	/* was never transmitted */
+	if (roc->frame) {
+		cfg80211_mgmt_tx_status(&roc->sdata->wdev, roc->mgmt_tx_cookie,
+					roc->frame->data, roc->frame->len,
+					false, GFP_KERNEL);
+		ieee80211_free_txskb(&roc->sdata->local->hw, roc->frame);
+	}
+
+	if (!roc->mgmt_tx_cookie)
+		cfg80211_remain_on_channel_expired(&roc->sdata->wdev,
+						   roc->cookie, roc->chan,
+						   GFP_KERNEL);
+
+	list_del(&roc->list);
+	kfree(roc);
+}
+
+static unsigned long ieee80211_end_finished_rocs(struct ieee80211_local *local,
+						 unsigned long now)
+{
+	struct ieee80211_roc_work *roc, *tmp;
+	long remaining_dur_min = LONG_MAX;
+
+	lockdep_assert_held(&local->mtx);
+
+	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
+		long remaining;
+
+		if (!roc->started)
+			break;
+
+		remaining = roc->start_time +
+			    msecs_to_jiffies(roc->duration) -
+			    now;
+
+		if (roc->abort || remaining <= 0)
+			ieee80211_roc_notify_destroy(roc);
+		else
+			remaining_dur_min = min(remaining_dur_min, remaining);
+	}
+
+	return remaining_dur_min;
+}
+
+static bool ieee80211_recalc_sw_work(struct ieee80211_local *local,
+				     unsigned long now)
+{
+	long dur = ieee80211_end_finished_rocs(local, now);
+
+	if (dur == LONG_MAX)
+		return false;
+
+	mod_delayed_work(local->workqueue, &local->roc_work, dur);
+	return true;
+}
+
+static void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc,
+					 unsigned long start_time)
+{
+	struct ieee80211_local *local = roc->sdata->local;
+
+	if (WARN_ON(roc->notified))
 		return;
 
+	roc->start_time = start_time;
+	roc->started = true;
+	roc->hw_begun = true;
+
 	if (roc->mgmt_tx_cookie) {
 		if (!WARN_ON(!roc->frame)) {
 			ieee80211_tx_skb_tid_band(roc->sdata, roc->frame, 7,
@@ -205,40 +270,26 @@ static void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
 	}
 
 	roc->notified = true;
+
+	if (!local->ops->remain_on_channel)
+		ieee80211_recalc_sw_work(local, start_time);
 }
 
 static void ieee80211_hw_roc_start(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, hw_roc_start);
-	struct ieee80211_roc_work *roc, *dep, *tmp;
+	struct ieee80211_roc_work *roc;
 
 	mutex_lock(&local->mtx);
 
-	if (list_empty(&local->roc_list))
-		goto out_unlock;
-
-	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
-			       list);
-
-	if (!roc->started)
-		goto out_unlock;
-
-	roc->hw_begun = true;
-	roc->hw_start_time = local->hw_roc_start_time;
-
-	ieee80211_handle_roc_started(roc);
-	list_for_each_entry_safe(dep, tmp, &roc->dependents, list) {
-		ieee80211_handle_roc_started(dep);
+	list_for_each_entry(roc, &local->roc_list, list) {
+		if (!roc->started)
+			break;
 
-		if (dep->duration > roc->duration) {
-			u32 dur = dep->duration;
-			dep->duration = dur - roc->duration;
-			roc->duration = dur;
-			list_move(&dep->list, &roc->list);
-		}
+		ieee80211_handle_roc_started(roc, local->hw_roc_start_time);
 	}
- out_unlock:
+
 	mutex_unlock(&local->mtx);
 }
 
@@ -254,34 +305,40 @@ void ieee80211_ready_on_channel(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(ieee80211_ready_on_channel);
 
-void ieee80211_start_next_roc(struct ieee80211_local *local)
+static void _ieee80211_start_next_roc(struct ieee80211_local *local)
 {
-	struct ieee80211_roc_work *roc;
+	struct ieee80211_roc_work *roc, *tmp;
+	enum ieee80211_roc_type type;
+	u32 min_dur, max_dur;
 
 	lockdep_assert_held(&local->mtx);
 
-	if (list_empty(&local->roc_list)) {
-		ieee80211_run_deferred_scan(local);
+	if (WARN_ON(list_empty(&local->roc_list)))
 		return;
-	}
 
 	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
 			       list);
 
-	if (WARN_ON_ONCE(roc->started))
+	if (WARN_ON(roc->started))
 		return;
 
-	if (local->ops->remain_on_channel) {
-		int ret, duration = roc->duration;
-
-		/* XXX: duplicated, see ieee80211_start_roc_work() */
-		if (!duration)
-			duration = 10;
+	min_dur = roc->duration;
+	max_dur = roc->duration;
+	type = roc->type;
 
-		ret = drv_remain_on_channel(local, roc->sdata, roc->chan,
-					    duration, roc->type);
+	list_for_each_entry(tmp, &local->roc_list, list) {
+		if (tmp == roc)
+			continue;
+		if (tmp->sdata != roc->sdata || tmp->chan != roc->chan)
+			break;
+		max_dur = max(tmp->duration, max_dur);
+		min_dur = min(tmp->duration, min_dur);
+		type = max(tmp->type, type);
+	}
 
-		roc->started = true;
+	if (local->ops->remain_on_channel) {
+		int ret = drv_remain_on_channel(local, roc->sdata, roc->chan,
+						max_dur, type);
 
 		if (ret) {
 			wiphy_warn(local->hw.wiphy,
@@ -290,74 +347,24 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 			 * queue the work struct again to avoid recursion
 			 * when multiple failures occur
 			 */
-			ieee80211_remain_on_channel_expired(&local->hw);
+			list_for_each_entry(tmp, &local->roc_list, list) {
+				if (tmp->sdata != roc->sdata ||
+				    tmp->chan != roc->chan)
+					break;
+				tmp->started = true;
+				tmp->abort = true;
+			}
+			ieee80211_queue_work(&local->hw, &local->hw_roc_done);
+			return;
 		}
-	} else {
-		/* delay it a bit */
-		ieee80211_queue_delayed_work(&local->hw, &roc->work,
-					     round_jiffies_relative(HZ/2));
-	}
-}
-
-static void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc,
-					 bool free)
-{
-	struct ieee80211_roc_work *dep, *tmp;
-
-	if (WARN_ON(roc->to_be_freed))
-		return;
-
-	/* was never transmitted */
-	if (roc->frame) {
-		cfg80211_mgmt_tx_status(&roc->sdata->wdev, roc->mgmt_tx_cookie,
-					roc->frame->data, roc->frame->len,
-					false, GFP_KERNEL);
-		ieee80211_free_txskb(&roc->sdata->local->hw, roc->frame);
-	}
-
-	if (!roc->mgmt_tx_cookie)
-		cfg80211_remain_on_channel_expired(&roc->sdata->wdev,
-						   roc->cookie, roc->chan,
-						   GFP_KERNEL);
-
-	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
-		ieee80211_roc_notify_destroy(dep, true);
-
-	if (free)
-		kfree(roc);
-	else
-		roc->to_be_freed = true;
-}
-
-static void ieee80211_sw_roc_work(struct work_struct *work)
-{
-	struct ieee80211_roc_work *roc =
-		container_of(work, struct ieee80211_roc_work, work.work);
-	struct ieee80211_sub_if_data *sdata = roc->sdata;
-	struct ieee80211_local *local = sdata->local;
-	bool started, on_channel;
-
-	mutex_lock(&local->mtx);
-
-	if (roc->to_be_freed)
-		goto out_unlock;
-
-	if (roc->abort)
-		goto finish;
-
-	if (WARN_ON(list_empty(&local->roc_list)))
-		goto out_unlock;
-
-	if (WARN_ON(roc != list_first_entry(&local->roc_list,
-					    struct ieee80211_roc_work,
-					    list)))
-		goto out_unlock;
-
-	if (!roc->started) {
-		struct ieee80211_roc_work *dep;
-
-		WARN_ON(local->use_chanctx);
 
+		/* we'll notify about the start once the HW calls back */
+		list_for_each_entry(tmp, &local->roc_list, list) {
+			if (tmp->sdata != roc->sdata || tmp->chan != roc->chan)
+				break;
+			tmp->started = true;
+		}
+	} else {
 		/* If actually operating on the desired channel (with at least
 		 * 20 MHz channel width) don't stop all the operations but still
 		 * treat it as though the ROC operation started properly, so
@@ -377,27 +384,72 @@ static void ieee80211_sw_roc_work(struct work_struct *work)
 			ieee80211_hw_config(local, 0);
 		}
 
-		/* tell userspace or send frame */
-		ieee80211_handle_roc_started(roc);
-		list_for_each_entry(dep, &roc->dependents, list)
-			ieee80211_handle_roc_started(dep);
+		ieee80211_queue_delayed_work(&local->hw, &local->roc_work,
+					     msecs_to_jiffies(min_dur));
+
+		/* tell userspace or send frame(s) */
+		list_for_each_entry(tmp, &local->roc_list, list) {
+			if (tmp->sdata != roc->sdata || tmp->chan != roc->chan)
+				break;
+
+			tmp->on_channel = roc->on_channel;
+			ieee80211_handle_roc_started(tmp, jiffies);
+		}
+	}
+}
+
+void ieee80211_start_next_roc(struct ieee80211_local *local)
+{
+	struct ieee80211_roc_work *roc;
+
+	lockdep_assert_held(&local->mtx);
+
+	if (list_empty(&local->roc_list)) {
+		ieee80211_run_deferred_scan(local);
+		return;
+	}
+
+	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
+			       list);
+
+	if (WARN_ON_ONCE(roc->started))
+		return;
+
+	if (local->ops->remain_on_channel) {
+		_ieee80211_start_next_roc(local);
+	} else {
+		/* delay it a bit */
+		ieee80211_queue_delayed_work(&local->hw, &local->roc_work,
+					     round_jiffies_relative(HZ/2));
+	}
+}
+
+static void __ieee80211_roc_work(struct ieee80211_local *local)
+{
+	struct ieee80211_roc_work *roc;
+	bool on_channel;
+
+	lockdep_assert_held(&local->mtx);
+
+	if (WARN_ON(local->ops->remain_on_channel))
+		return;
 
-		/* if it was pure TX, just finish right away */
-		if (!roc->duration)
-			goto finish;
+	roc = list_first_entry_or_null(&local->roc_list,
+				       struct ieee80211_roc_work, list);
+	if (!roc)
+		return;
 
-		roc->started = true;
-		ieee80211_queue_delayed_work(&local->hw, &roc->work,
-					     msecs_to_jiffies(roc->duration));
+	if (!roc->started) {
+		WARN_ON(local->use_chanctx);
+		_ieee80211_start_next_roc(local);
 	} else {
-		/* finish this ROC */
- finish:
-		list_del(&roc->list);
-		started = roc->started;
 		on_channel = roc->on_channel;
-		ieee80211_roc_notify_destroy(roc, !roc->abort);
+		if (ieee80211_recalc_sw_work(local, jiffies))
+			return;
 
-		if (started && !on_channel) {
+		/* careful - roc pointer became invalid during recalc */
+
+		if (!on_channel) {
 			ieee80211_flush_queues(local, NULL, false);
 
 			local->tmp_channel = NULL;
@@ -407,14 +459,17 @@ static void ieee80211_sw_roc_work(struct work_struct *work)
 		}
 
 		ieee80211_recalc_idle(local);
-
-		if (started)
-			ieee80211_start_next_roc(local);
-		else if (list_empty(&local->roc_list))
-			ieee80211_run_deferred_scan(local);
+		ieee80211_start_next_roc(local);
 	}
+}
 
- out_unlock:
+static void ieee80211_roc_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, roc_work.work);
+
+	mutex_lock(&local->mtx);
+	__ieee80211_roc_work(local);
 	mutex_unlock(&local->mtx);
 }
 
@@ -422,27 +477,14 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, hw_roc_done);
-	struct ieee80211_roc_work *roc;
 
 	mutex_lock(&local->mtx);
 
-	if (list_empty(&local->roc_list))
-		goto out_unlock;
-
-	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
-			       list);
-
-	if (!roc->started)
-		goto out_unlock;
-
-	list_del(&roc->list);
-
-	ieee80211_roc_notify_destroy(roc, true);
+	ieee80211_end_finished_rocs(local, jiffies);
 
 	/* if there's another roc, start it now */
 	ieee80211_start_next_roc(local);
 
- out_unlock:
 	mutex_unlock(&local->mtx);
 }
 
@@ -456,26 +498,41 @@ void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(ieee80211_remain_on_channel_expired);
 
-static bool ieee80211_coalesce_started_roc(struct ieee80211_local *local,
-					   struct ieee80211_roc_work *new_roc,
-					   struct ieee80211_roc_work *cur_roc)
+static bool
+ieee80211_coalesce_hw_started_roc(struct ieee80211_local *local,
+				  struct ieee80211_roc_work *new_roc,
+				  struct ieee80211_roc_work *cur_roc)
 {
 	unsigned long now = jiffies;
-	unsigned long remaining = cur_roc->hw_start_time +
-				  msecs_to_jiffies(cur_roc->duration) -
-				  now;
+	unsigned long remaining;
+
+	if (WARN_ON(!cur_roc->started))
+		return false;
 
-	if (WARN_ON(!cur_roc->started || !cur_roc->hw_begun))
+	/* if it was scheduled in the hardware, but not started yet,
+	 * we can only combine if the older one had a longer duration
+	 */
+	if (!cur_roc->hw_begun && new_roc->duration > cur_roc->duration)
 		return false;
 
+	remaining = cur_roc->start_time +
+		    msecs_to_jiffies(cur_roc->duration) -
+		    now;
+
 	/* if it doesn't fit entirely, schedule a new one */
 	if (new_roc->duration > jiffies_to_msecs(remaining))
 		return false;
 
-	ieee80211_handle_roc_started(new_roc);
+	/* add just after the current one so we combine their finish later */
+	list_add(&new_roc->list, &cur_roc->list);
+
+	/* if the existing one has already begun then let this one also
+	 * begin, otherwise they'll both be marked properly by the work
+	 * struct that runs once the driver notifies us of the beginning
+	 */
+	if (cur_roc->hw_begun)
+		ieee80211_handle_roc_started(new_roc, now);
 
-	/* add to dependents so we send the expired event properly */
-	list_add_tail(&new_roc->list, &cur_roc->dependents);
 	return true;
 }
 
@@ -487,7 +544,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 				    enum ieee80211_roc_type type)
 {
 	struct ieee80211_roc_work *roc, *tmp;
-	bool queued = false;
+	bool queued = false, combine_started = true;
 	int ret;
 
 	lockdep_assert_held(&local->mtx);
@@ -517,8 +574,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	roc->frame = txskb;
 	roc->type = type;
 	roc->sdata = sdata;
-	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
-	INIT_LIST_HEAD(&roc->dependents);
 
 	/*
 	 * cookie is either the roc cookie (for normal roc)
@@ -531,95 +586,88 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 		roc->mgmt_tx_cookie = *cookie;
 	}
 
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
+	/* if there's no need to queue, handle it immediately */
+	if (list_empty(&local->roc_list) &&
+	    !local->scanning && !ieee80211_is_radar_required(local)) {
+		/* if not HW assist, just queue & schedule work */
+		if (!local->ops->remain_on_channel) {
+			list_add_tail(&roc->list, &local->roc_list);
+			ieee80211_queue_delayed_work(&local->hw,
+						     &local->roc_work, 0);
+		} else {
+			/* otherwise actually kick it off here
+			 * (for error handling)
+			 */
+			ret = drv_remain_on_channel(local, sdata, channel,
+						    duration, type);
+			if (ret) {
+				kfree(roc);
+				return ret;
+			}
+			roc->started = true;
+			list_add_tail(&roc->list, &local->roc_list);
+		}
 
-	ret = drv_remain_on_channel(local, sdata, channel, duration, type);
-	if (ret) {
-		kfree(roc);
-		return ret;
+		return 0;
 	}
 
-	roc->started = true;
-	goto out_queue;
+	/* otherwise handle queueing */
 
- out_check_combine:
 	list_for_each_entry(tmp, &local->roc_list, list) {
 		if (tmp->chan != channel || tmp->sdata != sdata)
 			continue;
 
 		/*
-		 * Extend this ROC if possible:
-		 *
-		 * If it hasn't started yet, just increase the duration
-		 * and add the new one to the list of dependents.
-		 * If the type of the new ROC has higher priority, modify the
-		 * type of the previous one to match that of the new one.
+		 * Extend this ROC if possible: If it hasn't started, add
+		 * just after the new one to combine.
 		 */
 		if (!tmp->started) {
-			list_add_tail(&roc->list, &tmp->dependents);
-			tmp->duration = max(tmp->duration, roc->duration);
-			tmp->type = max(tmp->type, roc->type);
+			list_add(&roc->list, &tmp->list);
 			queued = true;
 			break;
 		}
 
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
+		if (!combine_started)
+			continue;
 
-			/*
-			 * In the software ROC case, cancel the timer, if
-			 * that fails then the finish work is already
-			 * queued/pending and thus we queue the new ROC
-			 * normally, if that succeeds then we can extend
-			 * the timer duration and TX the frame (if any.)
+		if (!local->ops->remain_on_channel) {
+			/* If there's no hardware remain-on-channel, and
+			 * doing so won't push us over the maximum r-o-c
+			 * we allow, then we can just add the new one to
+			 * the list and mark it as having started now.
+			 * If it would push over the limit, don't try to
+			 * combine with other started ones (that haven't
+			 * been running as long) but potentially sort it
+			 * with others that had the same fate.
 			 */
+			unsigned long now = jiffies;
+			u32 elapsed = jiffies_to_msecs(now - tmp->start_time);
+			struct wiphy *wiphy = local->hw.wiphy;
+			u32 max_roc = wiphy->max_remain_on_channel_duration;
 
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
+			if (elapsed + roc->duration > max_roc) {
+				combine_started = false;
+				continue;
+			}
 
-			ieee80211_handle_roc_started(roc);
+			list_add(&roc->list, &tmp->list);
+			queued = true;
+			roc->on_channel = tmp->on_channel;
+			ieee80211_handle_roc_started(roc, now);
+			break;
 		}
-		break;
+
+		queued = ieee80211_coalesce_hw_started_roc(local, roc, tmp);
+		if (queued)
+			break;
+		/* if it wasn't queued, perhaps it can be combined with
+		 * another that also couldn't get combined previously,
+		 * but no need to check for already started ones, since
+		 * that can't work.
+		 */
+		combine_started = false;
 	}
 
- out_queue:
 	if (!queued)
 		list_add_tail(&roc->list, &local->roc_list);
 
@@ -651,21 +699,6 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
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
 		if (!mgmt_tx && roc->cookie != cookie)
 			continue;
 		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
@@ -680,42 +713,44 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 		return -ENOENT;
 	}
 
-	/*
-	 * We found the item to cancel, so do that. Note that it
-	 * may have dependents, which we also cancel (and send
-	 * the expired signal for.) Not doing so would be quite
-	 * tricky here, but we may need to fix it later.
-	 */
+	if (!found->started) {
+		ieee80211_roc_notify_destroy(found);
+		goto out_unlock;
+	}
 
 	if (local->ops->remain_on_channel) {
-		if (found->started) {
-			ret = drv_cancel_remain_on_channel(local);
-			if (WARN_ON_ONCE(ret)) {
-				mutex_unlock(&local->mtx);
-				return ret;
-			}
+		ret = drv_cancel_remain_on_channel(local);
+		if (WARN_ON_ONCE(ret)) {
+			mutex_unlock(&local->mtx);
+			return ret;
 		}
 
-		list_del(&found->list);
+		/* TODO:
+		 * if multiple items were combined here then we really shouldn't
+		 * cancel them all - we should wait for as much time as needed
+		 * for the longest remaining one, and only then cancel ...
+		 */
+		list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
+			if (!roc->started)
+				break;
+			if (roc == found)
+				found = NULL;
+			ieee80211_roc_notify_destroy(roc);
+		}
 
-		if (found->started)
-			ieee80211_start_next_roc(local);
-		mutex_unlock(&local->mtx);
+		/* that really must not happen - it was started */
+		WARN_ON(found);
 
-		ieee80211_roc_notify_destroy(found, true);
+		ieee80211_start_next_roc(local);
 	} else {
-		/* work may be pending so use it all the time */
+		/* go through work struct to return to the operating channel */
 		found->abort = true;
-		ieee80211_queue_delayed_work(&local->hw, &found->work, 0);
-
-		mutex_unlock(&local->mtx);
-
-		/* work will clean up etc */
-		flush_delayed_work(&found->work);
-		WARN_ON(!found->to_be_freed);
-		kfree(found);
+		mod_delayed_work(local->workqueue, &local->roc_work, 0);
 	}
 
+ out_unlock:
+	mutex_unlock(&local->mtx);
+
 	return 0;
 }
 
@@ -918,6 +953,7 @@ void ieee80211_roc_setup(struct ieee80211_local *local)
 {
 	INIT_WORK(&local->hw_roc_start, ieee80211_hw_roc_start);
 	INIT_WORK(&local->hw_roc_done, ieee80211_hw_roc_done);
+	INIT_DELAYED_WORK(&local->roc_work, ieee80211_roc_work);
 	INIT_LIST_HEAD(&local->roc_list);
 }
 
@@ -925,36 +961,27 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 			 struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_roc_work *roc, *tmp;
-	LIST_HEAD(tmp_list);
+	bool work_to_do = false;
 
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
 		if (sdata && roc->sdata != sdata)
 			continue;
 
-		if (roc->started && local->ops->remain_on_channel) {
-			/* can race, so ignore return value */
-			drv_cancel_remain_on_channel(local);
-		}
-
-		list_move_tail(&roc->list, &tmp_list);
-		roc->abort = true;
-	}
-	mutex_unlock(&local->mtx);
-
-	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
-		if (local->ops->remain_on_channel) {
-			list_del(&roc->list);
-			ieee80211_roc_notify_destroy(roc, true);
+		if (roc->started) {
+			if (local->ops->remain_on_channel) {
+				/* can race, so ignore return value */
+				drv_cancel_remain_on_channel(local);
+				ieee80211_roc_notify_destroy(roc);
+			} else {
+				roc->abort = true;
+				work_to_do = true;
+			}
 		} else {
-			ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
-
-			/* work will clean up etc */
-			flush_delayed_work(&roc->work);
-			WARN_ON(!roc->to_be_freed);
-			kfree(roc);
+			ieee80211_roc_notify_destroy(roc);
 		}
 	}
-
-	WARN_ON_ONCE(!list_empty(&tmp_list));
+	if (work_to_do)
+		__ieee80211_roc_work(local);
+	mutex_unlock(&local->mtx);
 }
-- 
2.6.2

