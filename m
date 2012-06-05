Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab2FEMbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 08:31:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SbsvH-0008HZ-4H
	for linux-wireless@vger.kernel.org; Tue, 05 Jun 2012 14:31:43 +0200
Message-Id: <20120605123058.524950694@sipsolutions.net> (sfid-20120605_143152_658584_9D7A7989)
Date: Tue, 05 Jun 2012 14:28:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: unify SW/offload remain-on-channel
References: <20120605122839.664762975@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Redesign all the off-channel code, getting rid of
the generic off-channel work concept, replacing
it with a simple remain-on-channel list.

This fixes a number of small issues with the ROC
implementation:
 * offloaded remain-on-channel couldn't be queued,
   now we can queue it as well, if needed
 * in iwlwifi (the only user) offloaded ROC is
   mutually exclusive with scanning, use the new
   queue to handle that case -- I expect that it
   will later depend on a HW flag

The bigger issue though is that there's a bad bug
in the current implementation: if we get a mgmt
TX request while HW roc is active, and this new
request has a wait time, we actually schedule a
software ROC instead since we can't guarantee the
existing offloaded ROC will still be that long.
To fix this, the queuing mechanism was needed.

The queuing mechanism for offloaded ROC isn't yet
optimal, ideally we should add API to have the HW
extend the ROC if needed. We could add that later
but for now use a software implementation.

Overall, this unifies the behaviour between the
offloaded and software-implemented case as much
as possible.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix locking & use ieee80211_queue_delayed_work (Eliad)

 include/net/mac80211.h     |    3 
 net/mac80211/Makefile      |    1 
 net/mac80211/cfg.c         |  472 ++++++++++++++++++++++++---------------------
 net/mac80211/ieee80211_i.h |   89 ++------
 net/mac80211/iface.c       |   23 --
 net/mac80211/main.c        |   10 
 net/mac80211/offchannel.c  |  284 ++++++++++++++++++++++-----
 net/mac80211/scan.c        |    4 
 net/mac80211/status.c      |   28 --
 net/mac80211/work.c        |  370 -----------------------------------
 10 files changed, 532 insertions(+), 752 deletions(-)

--- a/net/mac80211/Makefile	2012-06-04 15:43:02.000000000 +0200
+++ b/net/mac80211/Makefile	2012-06-04 15:46:35.000000000 +0200
@@ -9,7 +9,6 @@ mac80211-y := \
 	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
 	ibss.o \
-	work.o \
 	iface.o \
 	rate.o \
 	michael.o \
--- a/net/mac80211/ieee80211_i.h	2012-06-04 15:43:02.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-06-04 15:46:35.000000000 +0200
@@ -319,55 +319,30 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-enum ieee80211_work_type {
-	IEEE80211_WORK_ABORT,
-	IEEE80211_WORK_REMAIN_ON_CHANNEL,
-	IEEE80211_WORK_OFFCHANNEL_TX,
-};
-
-/**
- * enum work_done_result - indicates what to do after work was done
- *
- * @WORK_DONE_DESTROY: This work item is no longer needed, destroy.
- * @WORK_DONE_REQUEUE: This work item was reset to be reused, and
- *	should be requeued.
- */
-enum work_done_result {
-	WORK_DONE_DESTROY,
-	WORK_DONE_REQUEUE,
-};
+#if HZ/100 == 0
+#define IEEE80211_ROC_MIN_LEFT	1
+#else
+#define IEEE80211_ROC_MIN_LEFT	(HZ/100)
+#endif
 
-struct ieee80211_work {
+struct ieee80211_roc_work {
 	struct list_head list;
+	struct list_head dependents;
 
-	struct rcu_head rcu_head;
+	struct delayed_work work;
 
 	struct ieee80211_sub_if_data *sdata;
 
-	enum work_done_result (*done)(struct ieee80211_work *wk,
-				      struct sk_buff *skb);
-
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type chan_type;
 
-	unsigned long timeout;
-	enum ieee80211_work_type type;
+	bool started, abort, hw_begun, notified;
 
-	bool started;
-
-	union {
-		struct {
-			u32 duration;
-		} remain;
-		struct {
-			struct sk_buff *frame;
-			u32 wait;
-			bool status;
-		} offchan_tx;
-	};
+	unsigned long hw_start_time;
 
-	size_t data_len;
-	u8 data[];
+	u32 duration, req_duration;
+	struct sk_buff *frame;
+	u64 mgmt_tx_cookie;
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
@@ -850,13 +825,6 @@ struct ieee80211_local {
 	const struct ieee80211_ops *ops;
 
 	/*
-	 * work stuff, potentially off-channel (in the future)
-	 */
-	struct list_head work_list;
-	struct timer_list work_timer;
-	struct work_struct work_work;
-
-	/*
 	 * private workqueue to mac80211. mac80211 makes this accessible
 	 * via ieee80211_queue_work()
 	 */
@@ -1090,14 +1058,12 @@ struct ieee80211_local {
 	} debugfs;
 #endif
 
-	struct ieee80211_channel *hw_roc_channel;
-	struct net_device *hw_roc_dev;
-	struct sk_buff *hw_roc_skb, *hw_roc_skb_for_status;
+	/*
+	 * Remain-on-channel support
+	 */
+	struct list_head roc_list;
 	struct work_struct hw_roc_start, hw_roc_done;
-	enum nl80211_channel_type hw_roc_channel_type;
-	unsigned int hw_roc_duration;
-	u32 hw_roc_cookie;
-	bool hw_roc_for_tx;
+	unsigned long hw_roc_start_time;
 
 	struct idr ack_status_frames;
 	spinlock_t ack_status_lock;
@@ -1293,7 +1259,12 @@ void ieee80211_offchannel_stop_vifs(stru
 				    bool offchannel_ps_enable);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
 				 bool offchannel_ps_disable);
-void ieee80211_hw_roc_setup(struct ieee80211_local *local);
+void ieee80211_roc_setup(struct ieee80211_local *local);
+void ieee80211_start_next_roc(struct ieee80211_local *local);
+void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc);
+void ieee80211_sw_roc_work(struct work_struct *work);
+void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
 /* interface handling */
 int ieee80211_iface_init(void);
@@ -1503,18 +1474,6 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos,
 			       enum nl80211_channel_type channel_type,
 			       u16 prot_mode);
 
-/* internal work items */
-void ieee80211_work_init(struct ieee80211_local *local);
-void ieee80211_add_work(struct ieee80211_work *wk);
-void free_work(struct ieee80211_work *wk);
-void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata);
-int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_channel *chan,
-				   enum nl80211_channel_type channel_type,
-				   unsigned int duration, u64 *cookie);
-int ieee80211_wk_cancel_remain_on_channel(
-	struct ieee80211_sub_if_data *sdata, u64 cookie);
-
 /* channel management */
 enum ieee80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
--- a/net/mac80211/iface.c	2012-06-04 15:45:51.000000000 +0200
+++ b/net/mac80211/iface.c	2012-06-04 15:46:35.000000000 +0200
@@ -528,10 +528,7 @@ static void ieee80211_do_stop(struct iee
 	 */
 	netif_tx_stop_all_queues(sdata->dev);
 
-	/*
-	 * Purge work for this interface.
-	 */
-	ieee80211_work_purge(sdata);
+	ieee80211_roc_purge(sdata);
 
 	/*
 	 * Remove all stations associated with this interface.
@@ -637,18 +634,6 @@ static void ieee80211_do_stop(struct iee
 		ieee80211_configure_filter(local);
 		break;
 	default:
-		mutex_lock(&local->mtx);
-		if (local->hw_roc_dev == sdata->dev &&
-		    local->hw_roc_channel) {
-			/* ignore return value since this is racy */
-			drv_cancel_remain_on_channel(local);
-			ieee80211_queue_work(&local->hw, &local->hw_roc_done);
-		}
-		mutex_unlock(&local->mtx);
-
-		flush_work(&local->hw_roc_start);
-		flush_work(&local->hw_roc_done);
-
 		flush_work(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
@@ -1455,8 +1440,8 @@ u32 __ieee80211_recalc_idle(struct ieee8
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
 	bool working = false, scanning = false;
-	struct ieee80211_work *wk;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
+	struct ieee80211_roc_work *roc;
 
 #ifdef CONFIG_PROVE_LOCKING
 	WARN_ON(debug_locks && !lockdep_rtnl_is_held() &&
@@ -1492,9 +1477,9 @@ u32 __ieee80211_recalc_idle(struct ieee8
 	}
 
 	if (!local->ops->remain_on_channel) {
-		list_for_each_entry(wk, &local->work_list, list) {
+		list_for_each_entry(roc, &local->roc_list, list) {
 			working = true;
-			wk->sdata->vif.bss_conf.idle = false;
+			roc->sdata->vif.bss_conf.idle = false;
 		}
 	}
 
--- a/net/mac80211/main.c	2012-06-04 15:43:02.000000000 +0200
+++ b/net/mac80211/main.c	2012-06-04 15:46:35.000000000 +0200
@@ -625,8 +625,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
-	ieee80211_work_init(local);
-
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
 	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
@@ -669,7 +667,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	ieee80211_led_names(local);
 
-	ieee80211_hw_roc_setup(local);
+	ieee80211_roc_setup(local);
 
 	return &local->hw;
 }
@@ -1009,12 +1007,6 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
-	/*
-	 * Now all work items will be gone, but the
-	 * timer might still be armed, so delete it
-	 */
-	del_timer_sync(&local->work_timer);
-
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
 
--- a/net/mac80211/scan.c	2012-06-04 15:43:02.000000000 +0200
+++ b/net/mac80211/scan.c	2012-06-04 15:46:35.000000000 +0200
@@ -324,7 +324,7 @@ static void __ieee80211_scan_completed(s
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
-	ieee80211_queue_work(&local->hw, &local->work_work);
+	ieee80211_start_next_roc(local);
 }
 
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
@@ -377,7 +377,7 @@ static int ieee80211_start_sw_scan(struc
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
-	if (!list_empty(&local->work_list))
+	if (!list_empty(&local->roc_list))
 		return false;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
--- a/net/mac80211/status.c	2012-06-04 15:43:02.000000000 +0200
+++ b/net/mac80211/status.c	2012-06-04 15:46:35.000000000 +0200
@@ -520,36 +520,16 @@ void ieee80211_tx_status(struct ieee8021
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
 		u64 cookie = (unsigned long)skb;
+		acked = info->flags & IEEE80211_TX_STAT_ACK;
 
 		if (ieee80211_is_nullfunc(hdr->frame_control) ||
-		    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-			acked = info->flags & IEEE80211_TX_STAT_ACK;
-
+		    ieee80211_is_qos_nullfunc(hdr->frame_control))
 			cfg80211_probe_status(skb->dev, hdr->addr1,
 					      cookie, acked, GFP_ATOMIC);
-		} else {
-			struct ieee80211_work *wk;
-
-			rcu_read_lock();
-			list_for_each_entry_rcu(wk, &local->work_list, list) {
-				if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
-					continue;
-				if (wk->offchan_tx.frame != skb)
-					continue;
-				wk->offchan_tx.status = true;
-				break;
-			}
-			rcu_read_unlock();
-			if (local->hw_roc_skb_for_status == skb) {
-				cookie = local->hw_roc_cookie ^ 2;
-				local->hw_roc_skb_for_status = NULL;
-			}
-
+		else
 			cfg80211_mgmt_tx_status(
 				skb->dev, cookie, skb->data, skb->len,
-				!!(info->flags & IEEE80211_TX_STAT_ACK),
-				GFP_ATOMIC);
-		}
+				acked, GFP_ATOMIC);
 	}
 
 	if (unlikely(info->ack_frame_id)) {
--- a/net/mac80211/work.c	2012-06-04 15:43:02.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,370 +0,0 @@
-/*
- * mac80211 work implementation
- *
- * Copyright 2003-2008, Jouni Malinen <j@w1.fi>
- * Copyright 2004, Instant802 Networks, Inc.
- * Copyright 2005, Devicescape Software, Inc.
- * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
- * Copyright 2009, Johannes Berg <johannes@sipsolutions.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/delay.h>
-#include <linux/if_ether.h>
-#include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/etherdevice.h>
-#include <linux/crc32.h>
-#include <linux/slab.h>
-#include <net/mac80211.h>
-#include <asm/unaligned.h>
-
-#include "ieee80211_i.h"
-#include "rate.h"
-#include "driver-ops.h"
-
-enum work_action {
-	WORK_ACT_NONE,
-	WORK_ACT_TIMEOUT,
-};
-
-
-/* utils */
-static inline void ASSERT_WORK_MTX(struct ieee80211_local *local)
-{
-	lockdep_assert_held(&local->mtx);
-}
-
-/*
- * We can have multiple work items (and connection probing)
- * scheduling this timer, but we need to take care to only
- * reschedule it when it should fire _earlier_ than it was
- * asked for before, or if it's not pending right now. This
- * function ensures that. Note that it then is required to
- * run this function for all timeouts after the first one
- * has happened -- the work that runs from this timer will
- * do that.
- */
-static void run_again(struct ieee80211_local *local,
-		      unsigned long timeout)
-{
-	ASSERT_WORK_MTX(local);
-
-	if (!timer_pending(&local->work_timer) ||
-	    time_before(timeout, local->work_timer.expires))
-		mod_timer(&local->work_timer, timeout);
-}
-
-void free_work(struct ieee80211_work *wk)
-{
-	kfree_rcu(wk, rcu_head);
-}
-
-static enum work_action __must_check
-ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
-{
-	/*
-	 * First time we run, do nothing -- the generic code will
-	 * have switched to the right channel etc.
-	 */
-	if (!wk->started) {
-		wk->timeout = jiffies + msecs_to_jiffies(wk->remain.duration);
-
-		cfg80211_ready_on_channel(wk->sdata->dev, (unsigned long) wk,
-					  wk->chan, wk->chan_type,
-					  wk->remain.duration, GFP_KERNEL);
-
-		return WORK_ACT_NONE;
-	}
-
-	return WORK_ACT_TIMEOUT;
-}
-
-static enum work_action __must_check
-ieee80211_offchannel_tx(struct ieee80211_work *wk)
-{
-	if (!wk->started) {
-		wk->timeout = jiffies + msecs_to_jiffies(wk->offchan_tx.wait);
-
-		/*
-		 * After this, offchan_tx.frame remains but now is no
-		 * longer a valid pointer -- we still need it as the
-		 * cookie for canceling this work/status matching.
-		 */
-		ieee80211_tx_skb(wk->sdata, wk->offchan_tx.frame);
-
-		return WORK_ACT_NONE;
-	}
-
-	return WORK_ACT_TIMEOUT;
-}
-
-static void ieee80211_work_timer(unsigned long data)
-{
-	struct ieee80211_local *local = (void *) data;
-
-	if (local->quiescing)
-		return;
-
-	ieee80211_queue_work(&local->hw, &local->work_work);
-}
-
-static void ieee80211_work_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, work_work);
-	struct ieee80211_work *wk, *tmp;
-	LIST_HEAD(free_work);
-	enum work_action rma;
-	bool remain_off_channel = false;
-
-	/*
-	 * ieee80211_queue_work() should have picked up most cases,
-	 * here we'll pick the rest.
-	 */
-	if (WARN(local->suspended, "work scheduled while going to suspend\n"))
-		return;
-
-	mutex_lock(&local->mtx);
-
-	if (local->scanning) {
-		mutex_unlock(&local->mtx);
-		return;
-	}
-
-	ieee80211_recalc_idle(local);
-
-	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
-		bool started = wk->started;
-
-		/* mark work as started if it's on the current off-channel */
-		if (!started && local->tmp_channel &&
-		    wk->chan == local->tmp_channel &&
-		    wk->chan_type == local->tmp_channel_type) {
-			started = true;
-			wk->timeout = jiffies;
-		}
-
-		if (!started && !local->tmp_channel) {
-			ieee80211_offchannel_stop_vifs(local, true);
-
-			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
-
-			ieee80211_hw_config(local, 0);
-
-			started = true;
-			wk->timeout = jiffies;
-		}
-
-		/* don't try to work with items that aren't started */
-		if (!started)
-			continue;
-
-		if (time_is_after_jiffies(wk->timeout)) {
-			/*
-			 * This work item isn't supposed to be worked on
-			 * right now, but take care to adjust the timer
-			 * properly.
-			 */
-			run_again(local, wk->timeout);
-			continue;
-		}
-
-		switch (wk->type) {
-		default:
-			WARN_ON(1);
-			/* nothing */
-			rma = WORK_ACT_NONE;
-			break;
-		case IEEE80211_WORK_ABORT:
-			rma = WORK_ACT_TIMEOUT;
-			break;
-		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
-			rma = ieee80211_remain_on_channel_timeout(wk);
-			break;
-		case IEEE80211_WORK_OFFCHANNEL_TX:
-			rma = ieee80211_offchannel_tx(wk);
-			break;
-		}
-
-		wk->started = started;
-
-		switch (rma) {
-		case WORK_ACT_NONE:
-			/* might have changed the timeout */
-			run_again(local, wk->timeout);
-			break;
-		case WORK_ACT_TIMEOUT:
-			list_del_rcu(&wk->list);
-			synchronize_rcu();
-			list_add(&wk->list, &free_work);
-			break;
-		default:
-			WARN(1, "unexpected: %d", rma);
-		}
-	}
-
-	list_for_each_entry(wk, &local->work_list, list) {
-		if (!wk->started)
-			continue;
-		if (wk->chan != local->tmp_channel ||
-		    wk->chan_type != local->tmp_channel_type)
-			continue;
-		remain_off_channel = true;
-	}
-
-	if (!remain_off_channel && local->tmp_channel) {
-		local->tmp_channel = NULL;
-		ieee80211_hw_config(local, 0);
-
-		ieee80211_offchannel_return(local, true);
-
-		/* give connection some time to breathe */
-		run_again(local, jiffies + HZ/2);
-	}
-
-	ieee80211_recalc_idle(local);
-	ieee80211_run_deferred_scan(local);
-
-	mutex_unlock(&local->mtx);
-
-	list_for_each_entry_safe(wk, tmp, &free_work, list) {
-		wk->done(wk, NULL);
-		list_del(&wk->list);
-		kfree(wk);
-	}
-}
-
-void ieee80211_add_work(struct ieee80211_work *wk)
-{
-	struct ieee80211_local *local;
-
-	if (WARN_ON(!wk->chan))
-		return;
-
-	if (WARN_ON(!wk->sdata))
-		return;
-
-	if (WARN_ON(!wk->done))
-		return;
-
-	if (WARN_ON(!ieee80211_sdata_running(wk->sdata)))
-		return;
-
-	wk->started = false;
-
-	local = wk->sdata->local;
-	mutex_lock(&local->mtx);
-	list_add_tail(&wk->list, &local->work_list);
-	mutex_unlock(&local->mtx);
-
-	ieee80211_queue_work(&local->hw, &local->work_work);
-}
-
-void ieee80211_work_init(struct ieee80211_local *local)
-{
-	INIT_LIST_HEAD(&local->work_list);
-	setup_timer(&local->work_timer, ieee80211_work_timer,
-		    (unsigned long)local);
-	INIT_WORK(&local->work_work, ieee80211_work_work);
-}
-
-void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_work *wk;
-	bool cleanup = false;
-
-	mutex_lock(&local->mtx);
-	list_for_each_entry(wk, &local->work_list, list) {
-		if (wk->sdata != sdata)
-			continue;
-		cleanup = true;
-		wk->type = IEEE80211_WORK_ABORT;
-		wk->started = true;
-		wk->timeout = jiffies;
-	}
-	mutex_unlock(&local->mtx);
-
-	/* run cleanups etc. */
-	if (cleanup)
-		ieee80211_work_work(&local->work_work);
-
-	mutex_lock(&local->mtx);
-	list_for_each_entry(wk, &local->work_list, list) {
-		if (wk->sdata != sdata)
-			continue;
-		WARN_ON(1);
-		break;
-	}
-	mutex_unlock(&local->mtx);
-}
-
-static enum work_done_result ieee80211_remain_done(struct ieee80211_work *wk,
-						   struct sk_buff *skb)
-{
-	/*
-	 * We are done serving the remain-on-channel command.
-	 */
-	cfg80211_remain_on_channel_expired(wk->sdata->dev, (unsigned long) wk,
-					   wk->chan, wk->chan_type,
-					   GFP_KERNEL);
-
-	return WORK_DONE_DESTROY;
-}
-
-int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_channel *chan,
-				   enum nl80211_channel_type channel_type,
-				   unsigned int duration, u64 *cookie)
-{
-	struct ieee80211_work *wk;
-
-	wk = kzalloc(sizeof(*wk), GFP_KERNEL);
-	if (!wk)
-		return -ENOMEM;
-
-	wk->type = IEEE80211_WORK_REMAIN_ON_CHANNEL;
-	wk->chan = chan;
-	wk->chan_type = channel_type;
-	wk->sdata = sdata;
-	wk->done = ieee80211_remain_done;
-
-	wk->remain.duration = duration;
-
-	*cookie = (unsigned long) wk;
-
-	ieee80211_add_work(wk);
-
-	return 0;
-}
-
-int ieee80211_wk_cancel_remain_on_channel(struct ieee80211_sub_if_data *sdata,
-					  u64 cookie)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_work *wk, *tmp;
-	bool found = false;
-
-	mutex_lock(&local->mtx);
-	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
-		if ((unsigned long) wk == cookie) {
-			wk->timeout = jiffies;
-			found = true;
-			break;
-		}
-	}
-	mutex_unlock(&local->mtx);
-
-	if (!found)
-		return -ENOENT;
-
-	ieee80211_queue_work(&local->hw, &local->work_work);
-
-	return 0;
-}
--- a/net/mac80211/cfg.c	2012-06-04 15:45:51.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-06-04 16:53:48.000000000 +0200
@@ -2112,35 +2112,171 @@ static int ieee80211_set_bitrate_mask(st
 	return 0;
 }
 
-static int ieee80211_remain_on_channel_hw(struct ieee80211_local *local,
-					  struct net_device *dev,
-					  struct ieee80211_channel *chan,
-					  enum nl80211_channel_type chantype,
-					  unsigned int duration, u64 *cookie)
+static int ieee80211_start_roc_work(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_channel *channel,
+				    enum nl80211_channel_type channel_type,
+				    unsigned int duration, u64 *cookie,
+				    struct sk_buff *txskb)
 {
+	struct ieee80211_roc_work *roc, *tmp;
+	bool queued = false;
 	int ret;
-	u32 random_cookie;
 
 	lockdep_assert_held(&local->mtx);
 
-	if (local->hw_roc_cookie)
-		return -EBUSY;
-	/* must be nonzero */
-	random_cookie = random32() | 1;
-
-	*cookie = random_cookie;
-	local->hw_roc_dev = dev;
-	local->hw_roc_cookie = random_cookie;
-	local->hw_roc_channel = chan;
-	local->hw_roc_channel_type = chantype;
-	local->hw_roc_duration = duration;
-	ret = drv_remain_on_channel(local, chan, chantype, duration);
+	roc = kzalloc(sizeof(*roc), GFP_KERNEL);
+	if (!roc)
+		return -ENOMEM;
+
+	roc->chan = channel;
+	roc->chan_type = channel_type;
+	roc->duration = duration;
+	roc->req_duration = duration;
+	roc->frame = txskb;
+	roc->mgmt_tx_cookie = (unsigned long)txskb;
+	roc->sdata = sdata;
+	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
+	INIT_LIST_HEAD(&roc->dependents);
+
+	/* if there's one pending or we're scanning, queue this one */
+	if (!list_empty(&local->roc_list) || local->scanning)
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
+	ret = drv_remain_on_channel(local, channel, channel_type, duration);
 	if (ret) {
-		local->hw_roc_channel = NULL;
-		local->hw_roc_cookie = 0;
+		kfree(roc);
+		return ret;
 	}
 
-	return ret;
+	roc->started = true;
+	goto out_queue;
+
+ out_check_combine:
+	list_for_each_entry(tmp, &local->roc_list, list) {
+		if (tmp->chan != channel || tmp->chan_type != channel_type)
+			continue;
+
+		/*
+		 * Extend this ROC if possible:
+		 *
+		 * If it hasn't started yet, just increase the duration
+		 * and add the new one to the list of dependents.
+		 */
+		if (!tmp->started) {
+			list_add_tail(&roc->list, &tmp->dependents);
+			tmp->duration = max(tmp->duration, roc->duration);
+			queued = true;
+			break;
+		}
+
+		/* If it has already started, it's more difficult ... */
+		if (local->ops->remain_on_channel) {
+			unsigned long j = jiffies;
+
+			/*
+			 * In the offloaded ROC case, if it hasn't begun, add
+			 * this new one to the dependent list to be handled
+			 * when the the master one begins. If it has begun,
+			 * check that there's still a minimum time left and
+			 * if so, start this one, transmitting the frame, but
+			 * add it to the list directly after this one with a
+			 * a reduced time so we'll ask the driver to execute
+			 * it right after finishing the previous one, in the
+			 * hope that it'll also be executed right afterwards,
+			 * effectively extending the old one.
+			 * If there's no minimum time left, just add it to the
+			 * normal list.
+			 */
+			if (!tmp->hw_begun) {
+				list_add_tail(&roc->list, &tmp->dependents);
+				queued = true;
+				break;
+			}
+
+			if (time_before(j + IEEE80211_ROC_MIN_LEFT,
+					tmp->hw_start_time +
+					msecs_to_jiffies(tmp->duration))) {
+				int new_dur;
+
+				ieee80211_handle_roc_started(roc);
+
+				new_dur = roc->duration -
+					  jiffies_to_msecs(tmp->hw_start_time +
+							   msecs_to_jiffies(
+								tmp->duration) -
+							   j);
+
+				if (new_dur > 0) {
+					/* add right after tmp */
+					list_add(&roc->list, &tmp->list);
+				} else {
+					list_add_tail(&roc->list,
+						      &tmp->dependents);
+				}
+				queued = true;
+			}
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
+	/*
+	 * cookie is either the roc (for normal roc)
+	 * or the SKB (for mgmt TX)
+	 */
+	if (txskb)
+		*cookie = (unsigned long)txskb;
+	else
+		*cookie = (unsigned long)roc;
+
+	return 0;
 }
 
 static int ieee80211_remain_on_channel(struct wiphy *wiphy,
@@ -2152,84 +2288,76 @@ static int ieee80211_remain_on_channel(s
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	int ret;
 
-	if (local->ops->remain_on_channel) {
-		int ret;
-
-		mutex_lock(&local->mtx);
-		ret = ieee80211_remain_on_channel_hw(local, dev,
-						     chan, channel_type,
-						     duration, cookie);
-		local->hw_roc_for_tx = false;
-		mutex_unlock(&local->mtx);
-
-		return ret;
-	}
+	mutex_lock(&local->mtx);
+	ret = ieee80211_start_roc_work(local, sdata, chan, channel_type,
+				       duration, cookie, NULL);
+	mutex_unlock(&local->mtx);
 
-	return ieee80211_wk_remain_on_channel(sdata, chan, channel_type,
-					      duration, cookie);
+	return ret;
 }
 
-static int ieee80211_cancel_remain_on_channel_hw(struct ieee80211_local *local,
-						 u64 cookie)
+static int ieee80211_cancel_roc(struct ieee80211_local *local,
+				u64 cookie, bool mgmt_tx)
 {
+	struct ieee80211_roc_work *roc, *tmp, *found = NULL;
 	int ret;
 
-	lockdep_assert_held(&local->mtx);
+	mutex_lock(&local->mtx);
+	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
+		if (!mgmt_tx && (unsigned long)roc != cookie)
+			continue;
+		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
+			continue;
 
-	if (local->hw_roc_cookie != cookie)
-		return -ENOENT;
+		found = roc;
+		break;
+	}
 
-	ret = drv_cancel_remain_on_channel(local);
-	if (ret)
-		return ret;
+	if (!found) {
+		mutex_unlock(&local->mtx);
+		return -ENOENT;
+	}
 
-	local->hw_roc_cookie = 0;
-	local->hw_roc_channel = NULL;
+	if (local->ops->remain_on_channel) {
+		if (found->started) {
+			ret = drv_cancel_remain_on_channel(local);
+			if (WARN_ON_ONCE(ret)) {
+				mutex_unlock(&local->mtx);
+				return ret;
+			}
+		}
 
-	return 0;
-}
+		list_del(&found->list);
 
-static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
-					      struct net_device *dev,
-					      u64 cookie)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+		ieee80211_run_deferred_scan(local);
+		ieee80211_start_next_roc(local);
+		mutex_unlock(&local->mtx);
 
-	if (local->ops->cancel_remain_on_channel) {
-		int ret;
+		ieee80211_roc_notify_destroy(found);
+	} else {
+		/* work may be pending so use it all the time */
+		found->abort = true;
+		ieee80211_queue_delayed_work(&local->hw, &found->work, 0);
 
-		mutex_lock(&local->mtx);
-		ret = ieee80211_cancel_remain_on_channel_hw(local, cookie);
 		mutex_unlock(&local->mtx);
 
-		return ret;
+		/* work will clean up etc */
+		flush_delayed_work(&found->work);
 	}
 
-	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
+	return 0;
 }
 
-static enum work_done_result
-ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
+static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
+					      struct net_device *dev,
+					      u64 cookie)
 {
-	/*
-	 * Use the data embedded in the work struct for reporting
-	 * here so if the driver mangled the SKB before dropping
-	 * it (which is the only way we really should get here)
-	 * then we don't report mangled data.
-	 *
-	 * If there was no wait time, then by the time we get here
-	 * the driver will likely not have reported the status yet,
-	 * so in that case userspace will have to deal with it.
-	 */
-
-	if (wk->offchan_tx.wait && !wk->offchan_tx.status)
-		cfg80211_mgmt_tx_status(wk->sdata->dev,
-					(unsigned long) wk->offchan_tx.frame,
-					wk->data, wk->data_len, false, GFP_KERNEL);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 
-	return WORK_DONE_DESTROY;
+	return ieee80211_cancel_roc(local, cookie, false);
 }
 
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
@@ -2243,10 +2371,10 @@ static int ieee80211_mgmt_tx(struct wiph
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
-	struct ieee80211_work *wk;
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
+	bool need_offchan = false;
 	u32 flags;
-	bool is_offchan = false, in_hw_roc = false;
+	int ret;
 
 	if (dont_wait_for_ack)
 		flags = IEEE80211_TX_CTL_NO_ACK;
@@ -2254,34 +2382,28 @@ static int ieee80211_mgmt_tx(struct wiph
 		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 			IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	/* Check that we are on the requested channel for transmission */
-	if (chan != local->tmp_channel &&
-	    chan != local->oper_channel)
-		is_offchan = true;
-	if (channel_type_valid &&
-	    (channel_type != local->tmp_channel_type &&
-	     channel_type != local->_oper_channel_type))
-		is_offchan = true;
-
-	if (chan == local->hw_roc_channel) {
-		/* TODO: check channel type? */
-		is_offchan = false;
-		in_hw_roc = true;
-		flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
-	}
-
 	if (no_cck)
 		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
 
-	if (is_offchan && !offchan)
-		return -EBUSY;
-
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_ADHOC:
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
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_MESH_POINT:
+		if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		    !ieee80211_vif_is_mesh(&sdata->vif) &&
+		    !rcu_access_pointer(sdata->bss->beacon))
+			need_offchan = true;
 		if (!ieee80211_is_action(mgmt->frame_control) ||
 		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
 			break;
@@ -2293,103 +2415,60 @@ static int ieee80211_mgmt_tx(struct wiph
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
+		if (!sdata->u.mgd.associated)
+			need_offchan = true;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
+	mutex_lock(&local->mtx);
+
+	/* Check if the operating channel is the requested channel */
+	if (!need_offchan) {
+		need_offchan = chan != local->oper_channel;
+		if (channel_type_valid &&
+		    channel_type != local->_oper_channel_type)
+			need_offchan = true;
+	}
+
+	if (need_offchan && !offchan) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
-	if (!skb)
-		return -ENOMEM;
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
 	memcpy(skb_put(skb, len), buf, len);
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
 
-	if (flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		IEEE80211_SKB_CB(skb)->hw_queue =
-			local->hw.offchannel_tx_hw_queue;
-
 	skb->dev = sdata->dev;
 
-	*cookie = (unsigned long) skb;
-
-	if (is_offchan && local->ops->remain_on_channel) {
-		unsigned int duration;
-		int ret;
-
-		mutex_lock(&local->mtx);
-		/*
-		 * If the duration is zero, then the driver
-		 * wouldn't actually do anything. Set it to
-		 * 100 for now.
-		 *
-		 * TODO: cancel the off-channel operation
-		 *       when we get the SKB's TX status and
-		 *       the wait time was zero before.
-		 */
-		duration = 100;
-		if (wait)
-			duration = wait;
-		ret = ieee80211_remain_on_channel_hw(local, dev, chan,
-						     channel_type,
-						     duration, cookie);
-		if (ret) {
-			kfree_skb(skb);
-			mutex_unlock(&local->mtx);
-			return ret;
-		}
-
-		local->hw_roc_for_tx = true;
-		local->hw_roc_duration = wait;
-
-		/*
-		 * queue up frame for transmission after
-		 * ieee80211_ready_on_channel call
-		 */
+	if (!need_offchan) {
+		ieee80211_tx_skb(sdata, skb);
+		ret = 0;
+		goto out_unlock;
+	}
 
-		/* modify cookie to prevent API mismatches */
-		*cookie ^= 2;
-		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
+	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;
-		local->hw_roc_skb = skb;
-		local->hw_roc_skb_for_status = skb;
-		mutex_unlock(&local->mtx);
-
-		return 0;
-	}
 
-	/*
-	 * Can transmit right away if the channel was the
-	 * right one and there's no wait involved... If a
-	 * wait is involved, we might otherwise not be on
-	 * the right channel for long enough!
-	 */
-	if (!is_offchan && !wait && (in_hw_roc || !sdata->vif.bss_conf.idle)) {
-		ieee80211_tx_skb(sdata, skb);
-		return 0;
-	}
-
-	wk = kzalloc(sizeof(*wk) + len, GFP_KERNEL);
-	if (!wk) {
+	/* This will handle all kinds of coalescing and immediate TX */
+	ret = ieee80211_start_roc_work(local, sdata, chan, channel_type,
+				       wait, cookie, skb);
+	if (ret)
 		kfree_skb(skb);
-		return -ENOMEM;
-	}
-
-	wk->type = IEEE80211_WORK_OFFCHANNEL_TX;
-	wk->chan = chan;
-	wk->chan_type = channel_type;
-	wk->sdata = sdata;
-	wk->done = ieee80211_offchan_tx_done;
-	wk->offchan_tx.frame = skb;
-	wk->offchan_tx.wait = wait;
-	wk->data_len = len;
-	memcpy(wk->data, buf, len);
-
-	ieee80211_add_work(wk);
-	return 0;
+ out_unlock:
+	mutex_unlock(&local->mtx);
+	return ret;
 }
 
 static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
@@ -2398,45 +2477,8 @@ static int ieee80211_mgmt_tx_cancel_wait
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_work *wk;
-	int ret = -ENOENT;
 
-	mutex_lock(&local->mtx);
-
-	if (local->ops->cancel_remain_on_channel) {
-		cookie ^= 2;
-		ret = ieee80211_cancel_remain_on_channel_hw(local, cookie);
-
-		if (ret == 0) {
-			kfree_skb(local->hw_roc_skb);
-			local->hw_roc_skb = NULL;
-			local->hw_roc_skb_for_status = NULL;
-		}
-
-		mutex_unlock(&local->mtx);
-
-		return ret;
-	}
-
-	list_for_each_entry(wk, &local->work_list, list) {
-		if (wk->sdata != sdata)
-			continue;
-
-		if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
-			continue;
-
-		if (cookie != (unsigned long) wk->offchan_tx.frame)
-			continue;
-
-		wk->timeout = jiffies;
-
-		ieee80211_queue_work(&local->hw, &local->work_work);
-		ret = 0;
-		break;
-	}
-	mutex_unlock(&local->mtx);
-
-	return ret;
+	return ieee80211_cancel_roc(local, cookie, true);
 }
 
 static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
--- a/net/mac80211/offchannel.c	2012-06-04 15:45:51.000000000 +0200
+++ b/net/mac80211/offchannel.c	2012-06-04 15:46:35.000000000 +0200
@@ -16,6 +16,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "driver-trace.h"
+#include "driver-ops.h"
 
 /*
  * Tell our hardware to disable PS.
@@ -181,32 +182,58 @@ void ieee80211_offchannel_return(struct
 	mutex_unlock(&local->iflist_mtx);
 }
 
+void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
+{
+	if (roc->notified)
+		return;
+
+	if (roc->mgmt_tx_cookie) {
+		if (!WARN_ON(!roc->frame)) {
+			ieee80211_tx_skb(roc->sdata, roc->frame);
+			roc->frame = NULL;
+		}
+	} else {
+		cfg80211_ready_on_channel(roc->sdata->dev, (unsigned long)roc,
+					  roc->chan, roc->chan_type,
+					  roc->req_duration, GFP_KERNEL);
+	}
+
+	roc->notified = true;
+}
+
 static void ieee80211_hw_roc_start(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, hw_roc_start);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_roc_work *roc, *dep, *tmp;
 
 	mutex_lock(&local->mtx);
 
-	if (!local->hw_roc_channel) {
-		mutex_unlock(&local->mtx);
-		return;
-	}
+	if (list_empty(&local->roc_list))
+		goto out_unlock;
 
-	if (local->hw_roc_skb) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(local->hw_roc_dev);
-		ieee80211_tx_skb(sdata, local->hw_roc_skb);
-		local->hw_roc_skb = NULL;
-	} else {
-		cfg80211_ready_on_channel(local->hw_roc_dev,
-					  local->hw_roc_cookie,
-					  local->hw_roc_channel,
-					  local->hw_roc_channel_type,
-					  local->hw_roc_duration,
-					  GFP_KERNEL);
-	}
+	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
+			       list);
+
+	if (!roc->started)
+		goto out_unlock;
 
+	roc->hw_begun = true;
+	roc->hw_start_time = local->hw_roc_start_time;
+
+	ieee80211_handle_roc_started(roc);
+	list_for_each_entry_safe(dep, tmp, &roc->dependents, list) {
+		ieee80211_handle_roc_started(dep);
+
+		if (dep->duration > roc->duration) {
+			u32 dur = dep->duration;
+			dep->duration = dur - roc->duration;
+			roc->duration = dur;
+			list_del(&dep->list);
+			list_add(&dep->list, &roc->list);
+		}
+	}
+ out_unlock:
 	mutex_unlock(&local->mtx);
 }
 
@@ -214,50 +241,179 @@ void ieee80211_ready_on_channel(struct i
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	local->hw_roc_start_time = jiffies;
+
 	trace_api_ready_on_channel(local);
 
 	ieee80211_queue_work(hw, &local->hw_roc_start);
 }
 EXPORT_SYMBOL_GPL(ieee80211_ready_on_channel);
 
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
+	if (local->ops->remain_on_channel) {
+		int ret, duration = roc->duration;
+
+		/* XXX: duplicated, see ieee80211_start_roc_work() */
+		if (!duration)
+			duration = 10;
+
+		ret = drv_remain_on_channel(local, roc->chan,
+					    roc->chan_type,
+					    duration);
+
+		roc->started = true;
+
+		if (ret) {
+			wiphy_warn(local->hw.wiphy,
+				   "failed to start next HW ROC (%d)\n", ret);
+			/*
+			 * queue the work struct again to avoid recursion
+			 * when multiple failures occur
+			 */
+			ieee80211_remain_on_channel_expired(&local->hw);
+		}
+	} else {
+		/* delay it a bit */
+		ieee80211_queue_delayed_work(&local->hw, &roc->work,
+					     round_jiffies_relative(HZ/2));
+	}
+}
+
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
+{
+	struct ieee80211_roc_work *dep, *tmp;
+
+	/* was never transmitted */
+	if (roc->frame) {
+		cfg80211_mgmt_tx_status(roc->sdata->dev,
+					(unsigned long)roc->frame,
+					roc->frame->data, roc->frame->len,
+					false, GFP_KERNEL);
+		kfree_skb(roc->frame);
+	}
+
+	if (!roc->mgmt_tx_cookie)
+		cfg80211_remain_on_channel_expired(roc->sdata->dev,
+						   (unsigned long)roc,
+						   roc->chan, roc->chan_type,
+						   GFP_KERNEL);
+
+	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
+		ieee80211_roc_notify_destroy(dep);
+
+	kfree(roc);
+}
+
+void ieee80211_sw_roc_work(struct work_struct *work)
+{
+	struct ieee80211_roc_work *roc =
+		container_of(work, struct ieee80211_roc_work, work.work);
+	struct ieee80211_sub_if_data *sdata = roc->sdata;
+	struct ieee80211_local *local = sdata->local;
+
+	mutex_lock(&local->mtx);
+
+	if (roc->abort)
+		goto finish;
+
+	if (WARN_ON(list_empty(&local->roc_list)))
+		goto out_unlock;
+
+	if (WARN_ON(roc != list_first_entry(&local->roc_list,
+					    struct ieee80211_roc_work,
+					    list)))
+		goto out_unlock;
+
+	if (!roc->started) {
+		struct ieee80211_roc_work *dep;
+
+		/* start this ROC */
+
+		/* switch channel etc */
+		ieee80211_recalc_idle(local);
+
+		local->tmp_channel = roc->chan;
+		local->tmp_channel_type = roc->chan_type;
+		ieee80211_hw_config(local, 0);
+
+		/* tell userspace or send frame */
+		ieee80211_handle_roc_started(roc);
+		list_for_each_entry(dep, &roc->dependents, list)
+			ieee80211_handle_roc_started(dep);
+
+		/* if it was pure TX, just finish right away */
+		if (!roc->duration)
+			goto finish;
+
+		roc->started = true;
+		ieee80211_queue_delayed_work(&local->hw, &roc->work,
+					     msecs_to_jiffies(roc->duration));
+	} else {
+		/* finish this ROC */
+ finish:
+		list_del(&roc->list);
+		ieee80211_roc_notify_destroy(roc);
+
+		if (roc->started) {
+			drv_flush(local, false);
+
+			local->tmp_channel = NULL;
+			ieee80211_hw_config(local, 0);
+
+			ieee80211_offchannel_return(local, true);
+		}
+
+		ieee80211_recalc_idle(local);
+
+		ieee80211_start_next_roc(local);
+		ieee80211_run_deferred_scan(local);
+	}
+
+ out_unlock:
+	mutex_unlock(&local->mtx);
+}
+
 static void ieee80211_hw_roc_done(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, hw_roc_done);
+	struct ieee80211_roc_work *roc;
 
 	mutex_lock(&local->mtx);
 
-	if (!local->hw_roc_channel) {
-		mutex_unlock(&local->mtx);
-		return;
-	}
+	if (list_empty(&local->roc_list))
+		goto out_unlock;
 
-	/* was never transmitted */
-	if (local->hw_roc_skb) {
-		u64 cookie;
+	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
+			       list);
 
-		cookie = local->hw_roc_cookie ^ 2;
+	if (!roc->started)
+		goto out_unlock;
 
-		cfg80211_mgmt_tx_status(local->hw_roc_dev, cookie,
-					local->hw_roc_skb->data,
-					local->hw_roc_skb->len, false,
-					GFP_KERNEL);
-
-		kfree_skb(local->hw_roc_skb);
-		local->hw_roc_skb = NULL;
-		local->hw_roc_skb_for_status = NULL;
-	}
-
-	if (!local->hw_roc_for_tx)
-		cfg80211_remain_on_channel_expired(local->hw_roc_dev,
-						   local->hw_roc_cookie,
-						   local->hw_roc_channel,
-						   local->hw_roc_channel_type,
-						   GFP_KERNEL);
+	list_del(&roc->list);
+
+	ieee80211_roc_notify_destroy(roc);
+
+	/* if there's another roc, start it now */
+	ieee80211_start_next_roc(local);
 
-	local->hw_roc_channel = NULL;
-	local->hw_roc_cookie = 0;
+	/* or scan maybe */
+	ieee80211_run_deferred_scan(local);
 
+ out_unlock:
 	mutex_unlock(&local->mtx);
 }
 
@@ -271,8 +427,48 @@ void ieee80211_remain_on_channel_expired
 }
 EXPORT_SYMBOL_GPL(ieee80211_remain_on_channel_expired);
 
-void ieee80211_hw_roc_setup(struct ieee80211_local *local)
+void ieee80211_roc_setup(struct ieee80211_local *local)
 {
 	INIT_WORK(&local->hw_roc_start, ieee80211_hw_roc_start);
 	INIT_WORK(&local->hw_roc_done, ieee80211_hw_roc_done);
+	INIT_LIST_HEAD(&local->roc_list);
+}
+
+void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_roc_work *roc, *tmp;
+	LIST_HEAD(tmp_list);
+
+	mutex_lock(&local->mtx);
+	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
+		if (roc->sdata != sdata)
+			continue;
+
+		if (roc->started && local->ops->remain_on_channel) {
+			/* can race, so ignore return value */
+			drv_cancel_remain_on_channel(local);
+		}
+
+		list_move_tail(&roc->list, &tmp_list);
+		roc->abort = true;
+	}
+
+	ieee80211_start_next_roc(local);
+	ieee80211_run_deferred_scan(local);
+	mutex_unlock(&local->mtx);
+
+	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
+		if (local->ops->remain_on_channel) {
+			list_del(&roc->list);
+			ieee80211_roc_notify_destroy(roc);
+		} else {
+			ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
+
+			/* work will clean up etc */
+			flush_delayed_work(&roc->work);
+		}
+	}
+
+	WARN_ON_ONCE(!list_empty(&tmp_list));
 }
--- a/include/net/mac80211.h	2012-06-04 15:45:51.000000000 +0200
+++ b/include/net/mac80211.h	2012-06-04 15:46:35.000000000 +0200
@@ -2184,9 +2184,6 @@ enum ieee80211_rate_control_changed {
  *	normally except for the %IEEE80211_TX_CTL_TX_OFFCHAN flag. When the
  *	duration (which will always be non-zero) expires, the driver must call
  *	ieee80211_remain_on_channel_expired().
- *	The driver must not call ieee80211_remain_on_channel_expired() before
- *	the TX status for a frame that was sent off-channel, otherwise the TX
- *	status is reported to userspace in an invalid way.
  *	Note that this callback may be called while the device is in IDLE and
  *	must be accepted in this case.
  *	This callback may sleep.


