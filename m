Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbZLWMXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:23:23 -0500
Message-Id: <20091223121617.571697600@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 14/18] mac80211: make off-channel work generic
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes mac80211 to allow being off-channel for
any type of work, not just the 'remain-on-channel'
work. This also helps fast transition to a BSS on a
different channel.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    7 +-
 net/mac80211/mlme.c        |   14 ----
 net/mac80211/work.c        |  137 ++++++++++++++++++++++++++-------------------
 3 files changed, 89 insertions(+), 69 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-23 13:11:26.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-23 13:11:26.000000000 +0100
@@ -255,13 +255,15 @@ struct ieee80211_work {
 				      struct sk_buff *skb);
 
 	struct ieee80211_channel *chan;
-	/* XXX: chan type? -- right now not really needed */
+	enum nl80211_channel_type chan_type;
 
 	unsigned long timeout;
 	enum ieee80211_work_type type;
 
 	u8 filter_ta[ETH_ALEN];
 
+	bool started;
+
 	union {
 		struct {
 			int tries;
@@ -286,7 +288,8 @@ struct ieee80211_work {
 			bool wmm_used, use_11n;
 		} assoc;
 		struct {
-			unsigned long timeout;
+			u32 duration;
+			bool started;
 		} remain;
 	};
 
--- wireless-testing.orig/net/mac80211/work.c	2009-12-23 13:11:26.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-23 13:11:26.000000000 +0100
@@ -541,39 +541,22 @@ ieee80211_associate(struct ieee80211_wor
 static enum work_action __must_check
 ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-
 	/*
 	 * First time we run, do nothing -- the generic code will
 	 * have switched to the right channel etc.
 	 */
-	if (wk->timeout != wk->remain.timeout) {
-		wk->timeout = wk->remain.timeout;
-		return WORK_ACT_NONE;
-	}
+	if (!wk->remain.started) {
+		wk->remain.started = true;
+		wk->timeout = jiffies + msecs_to_jiffies(wk->remain.duration);
+
+		cfg80211_ready_on_channel(wk->sdata->dev, (u64)wk, wk->chan,
+					  wk->chan_type, wk->remain.duration,
+					  GFP_KERNEL);
 
-	/*
-	 * We are done serving the remain-on-channel command; kill the work
-	 * item to allow idle state to be entered again. In addition, clear the
-	 * temporary channel information to allow operational channel to be
-	 * used.
-	 */
-	list_del(&wk->list);
-	free_work(wk);
-
-	if (local->tmp_channel) {
-		cfg80211_remain_on_channel_expired(sdata->dev, (u64)wk,
-						   local->tmp_channel,
-						   local->tmp_channel_type,
-						   GFP_KERNEL);
-
-		local->tmp_channel = NULL;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-		ieee80211_offchannel_return(local, true);
+		return WORK_ACT_NONE;
 	}
 
-	return WORK_ACT_NONE;
+	return WORK_ACT_TIMEOUT;
 }
 
 static void ieee80211_auth_challenge(struct ieee80211_work *wk,
@@ -799,7 +782,7 @@ static void ieee80211_work_rx_queued_mgm
 		break;
 	case WORK_DONE_REQUEUE:
 		synchronize_rcu();
-		wk->timeout = jiffies; /* run again directly */
+		wk->started = false; /* restart */
 		mutex_lock(&local->work_mtx);
 		list_add_tail(&wk->list, &local->work_list);
 		mutex_unlock(&local->work_mtx);
@@ -827,6 +810,7 @@ static void ieee80211_work_work(struct w
 	struct ieee80211_work *wk, *tmp;
 	LIST_HEAD(free_work);
 	enum work_action rma;
+	bool remain_off_channel = false;
 
 	if (local->scanning)
 		return;
@@ -847,6 +831,34 @@ static void ieee80211_work_work(struct w
 	mutex_lock(&local->work_mtx);
 
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
+		/* mark work as started if it's on the current off-channel */
+		if (!wk->started && local->tmp_channel &&
+		    wk->chan == local->tmp_channel &&
+		    wk->chan_type == local->tmp_channel_type) {
+			wk->started = true;
+		}
+
+		if (!wk->started && !local->tmp_channel) {
+			/*
+			 * TODO: could optimize this by leaving the
+			 *	 station vifs in awake mode if they
+			 *	 happen to be on the same channel as
+			 *	 the requested channel
+			 */
+			ieee80211_offchannel_stop_beaconing(local);
+			ieee80211_offchannel_stop_station(local);
+
+			local->tmp_channel = wk->chan;
+			local->tmp_channel_type = wk->chan_type;
+			ieee80211_hw_config(local, 0);
+			wk->started = true;
+			wk->timeout = jiffies;
+		}
+
+		/* don't try to work with items that aren't started */
+		if (!wk->started)
+			continue;
+
 		if (time_is_after_jiffies(wk->timeout)) {
 			/*
 			 * This work item isn't supposed to be worked on
@@ -881,7 +893,8 @@ static void ieee80211_work_work(struct w
 
 		switch (rma) {
 		case WORK_ACT_NONE:
-			/* no action required */
+			/* might have changed the timeout */
+			run_again(local, wk->timeout);
 			break;
 		case WORK_ACT_TIMEOUT:
 			list_del_rcu(&wk->list);
@@ -893,6 +906,24 @@ static void ieee80211_work_work(struct w
 		}
 	}
 
+	list_for_each_entry(wk, &local->work_list, list) {
+		if (!wk->started)
+			continue;
+		if (wk->chan != local->tmp_channel)
+			continue;
+		if (wk->chan_type != local->tmp_channel_type)
+			continue;
+		remain_off_channel = true;
+	}
+
+	if (!remain_off_channel && local->tmp_channel) {
+		local->tmp_channel = NULL;
+		ieee80211_hw_config(local, 0);
+		ieee80211_offchannel_return(local, true);
+		/* give connection some time to breathe */
+		run_again(local, jiffies + HZ/2);
+	}
+
 	if (list_empty(&local->work_list) && local->scan_req)
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
@@ -900,6 +931,8 @@ static void ieee80211_work_work(struct w
 
 	mutex_unlock(&local->work_mtx);
 
+	ieee80211_recalc_idle(local);
+
 	list_for_each_entry_safe(wk, tmp, &free_work, list) {
 		wk->done(wk, NULL);
 		list_del(&wk->list);
@@ -920,7 +953,7 @@ void ieee80211_add_work(struct ieee80211
 	if (WARN_ON(!wk->done))
 		return;
 
-	wk->timeout = jiffies;
+	wk->started = false;
 
 	local = wk->sdata->local;
 	mutex_lock(&local->work_mtx);
@@ -950,6 +983,8 @@ void ieee80211_work_purge(struct ieee802
 		if (wk->sdata != sdata)
 			continue;
 		wk->type = IEEE80211_WORK_ABORT;
+		wk->started = true;
+		wk->timeout = jiffies;
 	}
 	mutex_unlock(&local->work_mtx);
 
@@ -1004,12 +1039,24 @@ ieee80211_rx_result ieee80211_work_rx_mg
 	return RX_CONTINUE;
 }
 
+static enum work_done_result ieee80211_remain_done(struct ieee80211_work *wk,
+						   struct sk_buff *skb)
+{
+	/*
+	 * We are done serving the remain-on-channel command.
+	 */
+	cfg80211_remain_on_channel_expired(wk->sdata->dev, (u64)wk,
+					   wk->chan, wk->chan_type,
+					   GFP_KERNEL);
+
+	return WORK_DONE_DESTROY;
+}
+
 int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_channel *chan,
 				   enum nl80211_channel_type channel_type,
 				   unsigned int duration, u64 *cookie)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_work *wk;
 
 	wk = kzalloc(sizeof(*wk), GFP_KERNEL);
@@ -1018,28 +1065,16 @@ int ieee80211_wk_remain_on_channel(struc
 
 	wk->type = IEEE80211_WORK_REMAIN_ON_CHANNEL;
 	wk->chan = chan;
+	wk->chan_type = channel_type;
 	wk->sdata = sdata;
+	wk->done = ieee80211_remain_done;
 
-	wk->remain.timeout = jiffies + msecs_to_jiffies(duration);
+	wk->remain.duration = duration;
 
 	*cookie = (u64)wk;
 
 	ieee80211_add_work(wk);
 
-	/*
-	 * TODO: could optimize this by leaving the station vifs in awake mode
-	 * if they happen to be on the same channel as the requested channel
-	 */
-	ieee80211_offchannel_stop_beaconing(local);
-	ieee80211_offchannel_stop_station(local);
-
-	sdata->local->tmp_channel = chan;
-	sdata->local->tmp_channel_type = channel_type;
-	ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	cfg80211_ready_on_channel(sdata->dev, (u64)wk, chan, channel_type,
-				  duration, GFP_KERNEL);
-
 	return 0;
 }
 
@@ -1053,9 +1088,8 @@ int ieee80211_wk_cancel_remain_on_channe
 	mutex_lock(&local->work_mtx);
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
 		if ((u64)wk == cookie) {
+			wk->timeout = jiffies;
 			found = true;
-			list_del(&wk->list);
-			free_work(wk);
 			break;
 		}
 	}
@@ -1064,14 +1098,7 @@ int ieee80211_wk_cancel_remain_on_channe
 	if (!found)
 		return -ENOENT;
 
-	if (sdata->local->tmp_channel) {
-		sdata->local->tmp_channel = NULL;
-		ieee80211_hw_config(sdata->local,
-				    IEEE80211_CONF_CHANGE_CHANNEL);
-		ieee80211_offchannel_return(sdata->local, true);
-	}
-
-	ieee80211_recalc_idle(local);
+	ieee80211_queue_work(&local->hw, &local->work_work);
 
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:11:26.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:26.000000000 +0100
@@ -1113,6 +1113,8 @@ static bool ieee80211_assoc_success(stru
 	else
 		ieee80211_set_wmm_default(sdata);
 
+	local->oper_channel = wk->chan;
+
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (sdata->local->hw.queues >= 4) &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
@@ -1805,15 +1807,6 @@ int ieee80211_mgd_auth(struct ieee80211_
 	wk->sdata = sdata;
 	wk->done = ieee80211_probe_auth_done;
 
-	/*
-	 * XXX: if still associated need to tell AP that we're going
-	 *	to sleep and then change channel etc.
-	 *	For now switch channel here, later will be handled
-	 *	by submitting this as an off-channel work item.
-	 */
-	sdata->local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(sdata->local, 0);
-
 	ieee80211_add_work(wk);
 	return 0;
 }
@@ -1937,9 +1930,6 @@ int ieee80211_mgd_assoc(struct ieee80211
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
-	sdata->local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(sdata->local, 0);
-
 	ieee80211_add_work(wk);
 	return 0;
 }


