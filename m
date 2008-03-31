Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYDALs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:56 -0400
Message-Id: <20080331172436.345610000@sipsolutions.net> (sfid-20080401_124931_797277_B7076B46)
References: <20080331172258.541914000@sipsolutions.net>
Date: Mon, 31 Mar 2008 19:23:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] mac80211: sta_info_flush() fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the IBSS code tries to flush the STA list, it does so in
an atomic context. Flushing isn't safe there, however, and
requires the RTNL, so we need to defer it to a workqueue.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h   |    2 +
 net/mac80211/ieee80211_sta.c |    2 -
 net/mac80211/key.c           |    9 +++++
 net/mac80211/sta_info.c      |   70 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h      |    2 +
 5 files changed, 84 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-03-31 18:25:36.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-03-31 19:13:37.000000000 +0200
@@ -602,6 +602,8 @@ struct ieee80211_local {
 	spinlock_t sta_lock;
 	unsigned long num_sta;
 	struct list_head sta_list;
+	struct list_head sta_flush_list;
+	struct work_struct sta_flush_work;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
--- everything.orig/net/mac80211/sta_info.c	2008-03-31 18:25:59.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-03-31 19:19:28.000000000 +0200
@@ -643,10 +643,41 @@ static void sta_info_debugfs_add_work(st
 }
 #endif
 
+void __ieee80211_run_pending_flush(struct ieee80211_local *local)
+{
+	struct sta_info *sta;
+	unsigned long flags;
+
+	ASSERT_RTNL();
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	while (!list_empty(&local->sta_flush_list)) {
+		sta = list_first_entry(&local->sta_flush_list,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_irqrestore(&local->sta_lock, flags);
+		sta_info_destroy(sta);
+		spin_lock_irqsave(&local->sta_lock, flags);
+	}
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+}
+
+static void ieee80211_sta_flush_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, sta_flush_work);
+
+	rtnl_lock();
+	__ieee80211_run_pending_flush(local);
+	rtnl_unlock();
+}
+
 void sta_info_init(struct ieee80211_local *local)
 {
 	spin_lock_init(&local->sta_lock);
 	INIT_LIST_HEAD(&local->sta_list);
+	INIT_LIST_HEAD(&local->sta_flush_list);
+	INIT_WORK(&local->sta_flush_work, ieee80211_sta_flush_work);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
@@ -667,7 +698,12 @@ int sta_info_start(struct ieee80211_loca
 void sta_info_stop(struct ieee80211_local *local)
 {
 	del_timer(&local->sta_cleanup);
+	cancel_work_sync(&local->sta_flush_work);
+
+	rtnl_lock();
 	sta_info_flush(local, NULL);
+	__ieee80211_run_pending_flush(local);
+	rtnl_unlock();
 }
 
 /**
@@ -687,6 +723,7 @@ int sta_info_flush(struct ieee80211_loca
 	unsigned long flags;
 
 	might_sleep();
+	ASSERT_RTNL();
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
@@ -705,3 +742,36 @@ int sta_info_flush(struct ieee80211_loca
 
 	return ret;
 }
+
+/**
+ * sta_info_flush_delayed - flush matching STA entries from the STA table
+ *
+ * This function unlinks all stations for a given interface and queues
+ * them for freeing. Note that the workqueue function scheduled here has
+ * to run before any new keys can be added to the system to avoid set_key()
+ * callback ordering issues.
+ *
+ * @sdata: the interface
+ */
+void sta_info_flush_delayed(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta, *tmp;
+	unsigned long flags;
+	bool work = false;
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
+		if (sdata == sta->sdata) {
+			__sta_info_unlink(&sta);
+			if (sta) {
+				list_add_tail(&sta->list,
+					      &local->sta_flush_list);
+				work = true;
+			}
+		}
+	}
+	if (work)
+		schedule_work(&local->sta_flush_work);
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+}
--- everything.orig/net/mac80211/sta_info.h	2008-03-31 18:25:35.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-03-31 19:19:48.000000000 +0200
@@ -354,5 +354,7 @@ int sta_info_start(struct ieee80211_loca
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush(struct ieee80211_local *local,
 		    struct ieee80211_sub_if_data *sdata);
+void sta_info_flush_delayed(struct ieee80211_sub_if_data *sdata);
+void __ieee80211_run_pending_flush(struct ieee80211_local *local);
 
 #endif /* STA_INFO_H */
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-31 18:25:59.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-31 19:13:38.000000000 +0200
@@ -2232,7 +2232,7 @@ static int ieee80211_sta_join_ibss(struc
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	/* Remove possible STA entries from other IBSS networks. */
-	sta_info_flush(local, sdata);
+	sta_info_flush_delayed(sdata);
 
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
--- everything.orig/net/mac80211/key.c	2008-03-31 19:18:04.000000000 +0200
+++ everything/net/mac80211/key.c	2008-03-31 19:21:10.000000000 +0200
@@ -73,6 +73,15 @@ static void ieee80211_key_enable_hw_acce
 	if (!key->local->ops->set_key)
 		return;
 
+	/*
+	 * This makes sure that all pending flushes have
+	 * actually completed prior to uploading new key
+	 * material to the hardware. That is necessary to
+	 * avoid races between flushing STAs and adding
+	 * new keys for them.
+	 */
+	__ieee80211_run_pending_flush(key->local);
+
 	addr = get_mac_for_key(key);
 
 	ret = key->local->ops->set_key(local_to_hw(key->local), SET_KEY,

-- 

