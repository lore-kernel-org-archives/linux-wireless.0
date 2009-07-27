Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZG0Vqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 17:46:43 -0400
Subject: [PATCH] mac80211: do not use irq locks where not necessary
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 23:46:09 +0200
Message-Id: <1248731169.3134.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Except for places where we take locks that we need in
functions exported to drivers (which might call them
in interrupt context) we don't need to ever disable
IRQs in mac80211, just softirqs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Nobody objected (or probably tested, for that matter...), and it's been
working fine for me, albeit only with USB hardware. However, things
really related to calls that drivers can make from interrupts should be
ok -- just not sure I really got all the lock dependencies right. Let's
put it into wireless-testing to see :)

Point is that by not disabling IRQs we can improve latency for IRQs, of
course.

 net/mac80211/key.c                 |   33 +++++++++---------------
 net/mac80211/pm.c                  |    5 +--
 net/mac80211/rc80211_pid_debugfs.c |   15 ++++-------
 net/mac80211/sta_info.c            |   49 ++++++++++++++-----------------------
 net/mac80211/sta_info.h            |   27 +++++++-------------
 net/mac80211/tx.c                  |   11 +++-----
 net/mac80211/util.c                |    9 +++---
 7 files changed, 57 insertions(+), 92 deletions(-)

--- wireless-testing.orig/net/mac80211/key.c	2009-07-25 10:45:14.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2009-07-27 11:43:40.000000000 +0200
@@ -211,11 +211,9 @@ static void __ieee80211_set_default_key(
 
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	spin_lock_bh(&sdata->local->key_lock);
 	__ieee80211_set_default_key(sdata, idx);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	spin_unlock_bh(&sdata->local->key_lock);
 }
 
 static void
@@ -236,11 +234,9 @@ __ieee80211_set_default_mgmt_key(struct 
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	spin_lock_bh(&sdata->local->key_lock);
 	__ieee80211_set_default_mgmt_key(sdata, idx);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	spin_unlock_bh(&sdata->local->key_lock);
 }
 
 
@@ -386,7 +382,6 @@ void ieee80211_key_link(struct ieee80211
 			struct sta_info *sta)
 {
 	struct ieee80211_key *old_key;
-	unsigned long flags;
 	int idx;
 
 	BUG_ON(!sdata);
@@ -430,7 +425,7 @@ void ieee80211_key_link(struct ieee80211
 		}
 	}
 
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	spin_lock_bh(&sdata->local->key_lock);
 
 	if (sta)
 		old_key = sta->key;
@@ -446,7 +441,7 @@ void ieee80211_key_link(struct ieee80211
 	if (netif_running(sdata->dev))
 		add_todo(key, KEY_FLAG_TODO_HWACCEL_ADD);
 
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	spin_unlock_bh(&sdata->local->key_lock);
 }
 
 static void __ieee80211_key_free(struct ieee80211_key *key)
@@ -463,8 +458,6 @@ static void __ieee80211_key_free(struct 
 
 void ieee80211_key_free(struct ieee80211_key *key)
 {
-	unsigned long flags;
-
 	if (!key)
 		return;
 
@@ -477,9 +470,9 @@ void ieee80211_key_free(struct ieee80211
 		return;
 	}
 
-	spin_lock_irqsave(&key->sdata->local->key_lock, flags);
+	spin_lock_bh(&key->sdata->local->key_lock);
 	__ieee80211_key_free(key);
-	spin_unlock_irqrestore(&key->sdata->local->key_lock, flags);
+	spin_unlock_bh(&key->sdata->local->key_lock);
 }
 
 /*
@@ -493,14 +486,13 @@ static void ieee80211_todo_for_each_key(
 					u32 todo_flags)
 {
 	struct ieee80211_key *key;
-	unsigned long flags;
 
 	might_sleep();
 
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	spin_lock_bh(&sdata->local->key_lock);
 	list_for_each_entry(key, &sdata->key_list, list)
 		add_todo(key, todo_flags);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	spin_unlock_bh(&sdata->local->key_lock);
 
 	ieee80211_key_todo();
 }
@@ -608,17 +600,16 @@ void ieee80211_key_todo(void)
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
-	unsigned long flags;
 
 	ieee80211_key_lock();
 
 	ieee80211_debugfs_key_remove_default(sdata);
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	spin_lock_bh(&sdata->local->key_lock);
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 		__ieee80211_key_free(key);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	spin_unlock_bh(&sdata->local->key_lock);
 
 	__ieee80211_key_todo();
 
--- wireless-testing.orig/net/mac80211/pm.c	2009-07-25 10:45:14.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-07-27 11:43:40.000000000 +0200
@@ -12,7 +12,6 @@ int __ieee80211_suspend(struct ieee80211
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
-	unsigned long flags;
 
 	ieee80211_scan_cancel(local);
 
@@ -65,7 +64,7 @@ int __ieee80211_suspend(struct ieee80211
 	}
 
 	/* remove STAs */
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
 		if (local->ops->sta_notify) {
 			sdata = sta->sdata;
@@ -80,7 +79,7 @@ int __ieee80211_suspend(struct ieee80211
 
 		mesh_plink_quiesce(sta);
 	}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_bh(&local->sta_lock);
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
--- wireless-testing.orig/net/mac80211/rc80211_pid_debugfs.c	2009-07-25 10:45:14.000000000 +0200
+++ wireless-testing/net/mac80211/rc80211_pid_debugfs.c	2009-07-27 11:43:40.000000000 +0200
@@ -22,9 +22,8 @@ static void rate_control_pid_event(struc
 				   union rc_pid_event_data *data)
 {
 	struct rc_pid_event *ev;
-	unsigned long status;
 
-	spin_lock_irqsave(&buf->lock, status);
+	spin_lock_bh(&buf->lock);
 	ev = &(buf->ring[buf->next_entry]);
 	buf->next_entry = (buf->next_entry + 1) % RC_PID_EVENT_RING_SIZE;
 
@@ -33,7 +32,7 @@ static void rate_control_pid_event(struc
 	ev->type = type;
 	ev->data = *data;
 
-	spin_unlock_irqrestore(&buf->lock, status);
+	spin_unlock_bh(&buf->lock);
 
 	wake_up_all(&buf->waitqueue);
 }
@@ -86,19 +85,18 @@ static int rate_control_pid_events_open(
 	struct rc_pid_sta_info *sinfo = inode->i_private;
 	struct rc_pid_event_buffer *events = &sinfo->events;
 	struct rc_pid_events_file_info *file_info;
-	unsigned long status;
 
 	/* Allocate a state struct */
 	file_info = kmalloc(sizeof(*file_info), GFP_KERNEL);
 	if (file_info == NULL)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&events->lock, status);
+	spin_lock_bh(&events->lock);
 
 	file_info->next_entry = events->next_entry;
 	file_info->events = events;
 
-	spin_unlock_irqrestore(&events->lock, status);
+	spin_unlock_bh(&events->lock);
 
 	file->private_data = file_info;
 
@@ -136,7 +134,6 @@ static ssize_t rate_control_pid_events_r
 	char pb[RC_PID_PRINT_BUF_SIZE];
 	int ret;
 	int p;
-	unsigned long status;
 
 	/* Check if there is something to read. */
 	if (events->next_entry == file_info->next_entry) {
@@ -153,7 +150,7 @@ static ssize_t rate_control_pid_events_r
 
 	/* Write out one event per call. I don't care whether it's a little
 	 * inefficient, this is debugging code anyway. */
-	spin_lock_irqsave(&events->lock, status);
+	spin_lock_bh(&events->lock);
 
 	/* Get an event */
 	ev = &(events->ring[file_info->next_entry]);
@@ -188,7 +185,7 @@ static ssize_t rate_control_pid_events_r
 	}
 	p += snprintf(pb + p, length - p, "\n");
 
-	spin_unlock_irqrestore(&events->lock, status);
+	spin_unlock_bh(&events->lock);
 
 	if (copy_to_user(buf, pb, p))
 		return -EFAULT;
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-07-25 10:45:14.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2009-07-27 11:43:40.000000000 +0200
@@ -322,7 +322,6 @@ int sta_info_insert(struct sta_info *sta
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	unsigned long flags;
 	int err = 0;
 
 	/*
@@ -341,10 +340,10 @@ int sta_info_insert(struct sta_info *sta
 		goto out_free;
 	}
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_bh(&local->sta_lock);
 	/* check if STA exists already */
 	if (sta_info_get(local, sta->sta.addr)) {
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+		spin_unlock_bh(&local->sta_lock);
 		err = -EEXIST;
 		goto out_free;
 	}
@@ -367,7 +366,7 @@ int sta_info_insert(struct sta_info *sta
 	       wiphy_name(local->hw.wiphy), sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_bh(&local->sta_lock);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/*
@@ -424,13 +423,11 @@ static void __sta_info_set_tim_bit(struc
 
 void sta_info_set_tim_bit(struct sta_info *sta)
 {
-	unsigned long flags;
-
 	BUG_ON(!sta->sdata->bss);
 
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	spin_lock_bh(&sta->local->sta_lock);
 	__sta_info_set_tim_bit(sta->sdata->bss, sta);
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+	spin_unlock_bh(&sta->local->sta_lock);
 }
 
 static void __sta_info_clear_tim_bit(struct ieee80211_if_ap *bss,
@@ -449,13 +446,11 @@ static void __sta_info_clear_tim_bit(str
 
 void sta_info_clear_tim_bit(struct sta_info *sta)
 {
-	unsigned long flags;
-
 	BUG_ON(!sta->sdata->bss);
 
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	spin_lock_bh(&sta->local->sta_lock);
 	__sta_info_clear_tim_bit(sta->sdata->bss, sta);
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+	spin_unlock_bh(&sta->local->sta_lock);
 }
 
 static void __sta_info_unlink(struct sta_info **sta)
@@ -546,11 +541,10 @@ static void __sta_info_unlink(struct sta
 void sta_info_unlink(struct sta_info **sta)
 {
 	struct ieee80211_local *local = (*sta)->local;
-	unsigned long flags;
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_bh(&local->sta_lock);
 	__sta_info_unlink(sta);
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_bh(&local->sta_lock);
 }
 
 static int sta_info_buffer_expired(struct sta_info *sta,
@@ -577,7 +571,6 @@ static int sta_info_buffer_expired(struc
 static void sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 					     struct sta_info *sta)
 {
-	unsigned long flags;
 	struct sk_buff *skb;
 	struct ieee80211_sub_if_data *sdata;
 
@@ -585,13 +578,13 @@ static void sta_info_cleanup_expire_buff
 		return;
 
 	for (;;) {
-		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
+		spin_lock_bh(&sta->ps_tx_buf.lock);
 		skb = skb_peek(&sta->ps_tx_buf);
 		if (sta_info_buffer_expired(sta, skb))
 			skb = __skb_dequeue(&sta->ps_tx_buf);
 		else
 			skb = NULL;
-		spin_unlock_irqrestore(&sta->ps_tx_buf.lock, flags);
+		spin_unlock_bh(&sta->ps_tx_buf.lock);
 
 		if (!skb)
 			break;
@@ -646,15 +639,14 @@ static void __sta_info_pin(struct sta_in
 static struct sta_info *__sta_info_unpin(struct sta_info *sta)
 {
 	struct sta_info *ret = NULL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	spin_lock_bh(&sta->local->sta_lock);
 	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_DESTROY &&
 		sta->pin_status != STA_INFO_PIN_STAT_PINNED);
 	if (sta->pin_status == STA_INFO_PIN_STAT_DESTROY)
 		ret = sta;
 	sta->pin_status = STA_INFO_PIN_STAT_NORMAL;
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+	spin_unlock_bh(&sta->local->sta_lock);
 
 	return ret;
 }
@@ -664,14 +656,13 @@ static void sta_info_debugfs_add_work(st
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, sta_debugfs_add);
 	struct sta_info *sta, *tmp;
-	unsigned long flags;
 
 	/* We need to keep the RTNL across the whole pinned status. */
 	rtnl_lock();
 	while (1) {
 		sta = NULL;
 
-		spin_lock_irqsave(&local->sta_lock, flags);
+		spin_lock_bh(&local->sta_lock);
 		list_for_each_entry(tmp, &local->sta_list, list) {
 			/*
 			 * debugfs.add_has_run will be set by
@@ -684,7 +675,7 @@ static void sta_info_debugfs_add_work(st
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+		spin_unlock_bh(&local->sta_lock);
 
 		if (!sta)
 			break;
@@ -750,11 +741,10 @@ int sta_info_flush(struct ieee80211_loca
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
 	int ret = 0;
-	unsigned long flags;
 
 	might_sleep();
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (!sdata || sdata == sta->sdata) {
 			__sta_info_unlink(&sta);
@@ -764,7 +754,7 @@ int sta_info_flush(struct ieee80211_loca
 			}
 		}
 	}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_bh(&local->sta_lock);
 
 	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
 		sta_info_destroy(sta);
@@ -778,9 +768,8 @@ void ieee80211_sta_expire(struct ieee802
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
-	unsigned long flags;
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
@@ -791,7 +780,7 @@ void ieee80211_sta_expire(struct ieee802
 			if (sta)
 				list_add(&sta->list, &tmp_list);
 		}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_bh(&local->sta_lock);
 
 	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
 		sta_info_destroy(sta);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-07-25 10:45:14.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-07-27 11:43:40.000000000 +0200
@@ -341,30 +341,25 @@ static inline enum plink_state sta_plink
 
 static inline void set_sta_flags(struct sta_info *sta, const u32 flags)
 {
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
+	spin_lock_bh(&sta->flaglock);
 	sta->flags |= flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	spin_unlock_bh(&sta->flaglock);
 }
 
 static inline void clear_sta_flags(struct sta_info *sta, const u32 flags)
 {
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
+	spin_lock_bh(&sta->flaglock);
 	sta->flags &= ~flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	spin_unlock_bh(&sta->flaglock);
 }
 
 static inline u32 test_sta_flags(struct sta_info *sta, const u32 flags)
 {
 	u32 ret;
-	unsigned long irqfl;
 
-	spin_lock_irqsave(&sta->flaglock, irqfl);
+	spin_lock_bh(&sta->flaglock);
 	ret = sta->flags & flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	spin_unlock_bh(&sta->flaglock);
 
 	return ret;
 }
@@ -373,12 +368,11 @@ static inline u32 test_and_clear_sta_fla
 					   const u32 flags)
 {
 	u32 ret;
-	unsigned long irqfl;
 
-	spin_lock_irqsave(&sta->flaglock, irqfl);
+	spin_lock_bh(&sta->flaglock);
 	ret = sta->flags & flags;
 	sta->flags &= ~flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	spin_unlock_bh(&sta->flaglock);
 
 	return ret;
 }
@@ -386,11 +380,10 @@ static inline u32 test_and_clear_sta_fla
 static inline u32 get_sta_flags(struct sta_info *sta)
 {
 	u32 ret;
-	unsigned long irqfl;
 
-	spin_lock_irqsave(&sta->flaglock, irqfl);
+	spin_lock_bh(&sta->flaglock);
 	ret = sta->flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	spin_unlock_bh(&sta->flaglock);
 
 	return ret;
 }
--- wireless-testing.orig/net/mac80211/tx.c	2009-07-27 11:42:03.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-07-27 11:43:40.000000000 +0200
@@ -1049,13 +1049,12 @@ ieee80211_tx_prepare(struct ieee80211_su
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
-		unsigned long flags;
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 
-		spin_lock_irqsave(&tx->sta->lock, flags);
+		spin_lock_bh(&tx->sta->lock);
 		/*
 		 * XXX: This spinlock could be fairly expensive, but see the
 		 *	comment in agg-tx.c:ieee80211_agg_tx_operational().
@@ -1080,7 +1079,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			__skb_queue_tail(&tid_tx->pending, skb);
 		}
-		spin_unlock_irqrestore(&tx->sta->lock, flags);
+		spin_unlock_bh(&tx->sta->lock);
 
 		if (unlikely(queued))
 			return TX_QUEUED;
@@ -2024,11 +2023,9 @@ struct sk_buff *ieee80211_beacon_get(str
 			if (local->tim_in_locked_section) {
 				ieee80211_beacon_add_tim(ap, skb, beacon);
 			} else {
-				unsigned long flags;
-
-				spin_lock_irqsave(&local->sta_lock, flags);
+				spin_lock_bh(&local->sta_lock);
 				ieee80211_beacon_add_tim(ap, skb, beacon);
-				spin_unlock_irqrestore(&local->sta_lock, flags);
+				spin_unlock_bh(&local->sta_lock);
 			}
 
 			if (beacon->tail)
--- wireless-testing.orig/net/mac80211/util.c	2009-07-27 11:42:03.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-07-27 11:43:40.000000000 +0200
@@ -973,7 +973,6 @@ int ieee80211_reconfig(struct ieee80211_
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
-	unsigned long flags;
 	int res;
 	bool from_suspend = local->suspended;
 
@@ -1004,7 +1003,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* add STAs back */
 	if (local->ops->sta_notify) {
-		spin_lock_irqsave(&local->sta_lock, flags);
+		spin_lock_bh(&local->sta_lock);
 		list_for_each_entry(sta, &local->sta_list, list) {
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1015,7 +1014,7 @@ int ieee80211_reconfig(struct ieee80211_
 			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD,
 				       &sta->sta);
 		}
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+		spin_unlock_bh(&local->sta_lock);
 	}
 
 	/* Clear Suspend state so that ADDBA requests can be processed */
@@ -1105,10 +1104,10 @@ int ieee80211_reconfig(struct ieee80211_
 
 	add_timer(&local->sta_cleanup);
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list)
 		mesh_plink_restart(sta);
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_bh(&local->sta_lock);
 #else
 	WARN_ON(1);
 #endif


