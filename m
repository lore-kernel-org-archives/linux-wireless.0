Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39432
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbXEFSjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2007 14:39:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: Allow sleeping in set_key op
Date: Sun, 6 May 2007 20:37:34 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705062037.35037.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow drivers to sleep in the setkey function, as it's rather
complicated to defer set_key to a workqueue in the driver
(error code is lost, keyconf->hw_key_idx is possibly hard
to get right.)

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: bu3sch-wireless-dev/net/mac80211/ieee80211_i.h
===================================================================
--- bu3sch-wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-05-06 01:50:54.000000000 +0200
+++ bu3sch-wireless-dev/net/mac80211/ieee80211_i.h	2007-05-06 19:59:13.000000000 +0200
@@ -420,7 +420,6 @@ struct ieee80211_local {
 	spinlock_t sta_lock; /* mutex for STA data structures */
 	int num_sta; /* number of stations in sta_list */
 	struct list_head sta_list;
-	struct list_head deleted_sta_list;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
Index: bu3sch-wireless-dev/net/mac80211/sta_info.c
===================================================================
--- bu3sch-wireless-dev.orig/net/mac80211/sta_info.c	2007-05-06 01:50:54.000000000 +0200
+++ bu3sch-wireless-dev/net/mac80211/sta_info.c	2007-05-06 20:22:20.000000000 +0200
@@ -193,9 +193,42 @@ struct sta_info * sta_info_add(struct ie
 	return sta;
 }
 
+
+static void sta_info_key_disable(struct ieee80211_local *local,
+				 struct sta_info *sta)
+{
+	might_sleep();
+	if (sta->key) {
+		if (local->ops->set_key) {
+			struct ieee80211_key_conf *key;
+			key = ieee80211_key_data2conf(local, sta->key);
+			if (key) {
+				local->ops->set_key(local_to_hw(local),
+						   DISABLE_KEY,
+						   sta->addr, key, sta->aid);
+				kfree(key);
+			}
+		}
+	} else if (sta->key_idx_compression != HW_KEY_IDX_INVALID) {
+		struct ieee80211_key_conf conf;
+		memset(&conf, 0, sizeof(conf));
+		conf.hw_key_idx = sta->key_idx_compression;
+		conf.alg = ALG_NULL;
+		conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+		if (local->ops->set_key) {
+			local->ops->set_key(local_to_hw(local), DISABLE_KEY,
+					    sta->addr, &conf, sta->aid);
+		}
+		sta->key_idx_compression = HW_KEY_IDX_INVALID;
+	}
+}
+
+
 static void finish_sta_info_free(struct ieee80211_local *local,
 				 struct sta_info *sta)
 {
+	sta_info_key_disable(local, sta);
+
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
 	       local->mdev->name, MAC_ARG(sta->addr));
@@ -213,6 +246,16 @@ static void finish_sta_info_free(struct 
 	sta_info_put(sta);
 }
 
+
+static void finish_sta_info_free_work(struct work_struct *work)
+{
+	struct sta_info *sta =
+		container_of(work, struct sta_info, finish_free_work);
+
+	finish_sta_info_free(sta->local, sta);
+}
+
+
 static void sta_info_remove(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
@@ -230,6 +273,7 @@ static void sta_info_remove(struct sta_i
 	sta_info_remove_aid_ptr(sta);
 }
 
+
 void sta_info_free(struct sta_info *sta, int locked)
 {
 	struct sk_buff *skb;
@@ -254,34 +298,11 @@ void sta_info_free(struct sta_info *sta,
 		dev_kfree_skb_any(skb);
 	}
 
-	if (sta->key) {
-		if (local->ops->set_key) {
-			struct ieee80211_key_conf *key;
-			key = ieee80211_key_data2conf(local, sta->key);
-			if (key) {
-				local->ops->set_key(local_to_hw(local),
-						   DISABLE_KEY,
-						   sta->addr, key, sta->aid);
-				kfree(key);
-			}
-		}
-	} else if (sta->key_idx_compression != HW_KEY_IDX_INVALID) {
-		struct ieee80211_key_conf conf;
-		memset(&conf, 0, sizeof(conf));
-		conf.hw_key_idx = sta->key_idx_compression;
-		conf.alg = ALG_NULL;
-		conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-		local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-				   sta->addr, &conf, sta->aid);
-		sta->key_idx_compression = HW_KEY_IDX_INVALID;
-	}
-
-#ifdef CONFIG_MAC80211_DEBUGFS
 	if (in_atomic()) {
-		list_add(&sta->list, &local->deleted_sta_list);
-		queue_work(local->hw.workqueue, &local->sta_debugfs_add);
+		/* Schedule the finishing to be able to sleep. */
+		INIT_WORK(&sta->finish_free_work, finish_sta_info_free_work);
+		queue_work(local->hw.workqueue, &sta->finish_free_work);
 	} else
-#endif
 		finish_sta_info_free(local, sta);
 }
 
@@ -363,20 +384,6 @@ static void sta_info_debugfs_add_task(st
 	struct sta_info *sta, *tmp;
 
 	while (1) {
-		spin_lock_bh(&local->sta_lock);
-		if (!list_empty(&local->deleted_sta_list)) {
-			sta = list_entry(local->deleted_sta_list.next,
-					 struct sta_info, list);
-			list_del(local->deleted_sta_list.next);
-		} else
-			sta = NULL;
-		spin_unlock_bh(&local->sta_lock);
-		if (!sta)
-			break;
-		finish_sta_info_free(local, sta);
-	}
-
-	while (1) {
 		sta = NULL;
 		spin_lock_bh(&local->sta_lock);
 		list_for_each_entry(tmp, &local->sta_list, list) {
@@ -403,7 +410,6 @@ void sta_info_init(struct ieee80211_loca
 {
 	spin_lock_init(&local->sta_lock);
 	INIT_LIST_HEAD(&local->sta_list);
-	INIT_LIST_HEAD(&local->deleted_sta_list);
 
 	init_timer(&local->sta_cleanup);
 	local->sta_cleanup.expires = jiffies + STA_INFO_CLEANUP_INTERVAL;
Index: bu3sch-wireless-dev/net/mac80211/sta_info.h
===================================================================
--- bu3sch-wireless-dev.orig/net/mac80211/sta_info.h	2007-05-06 01:50:54.000000000 +0200
+++ bu3sch-wireless-dev/net/mac80211/sta_info.h	2007-05-06 19:58:58.000000000 +0200
@@ -133,6 +133,8 @@ struct sta_info {
 #endif
 	} debugfs;
 #endif
+
+	struct work_struct finish_free_work;
 };
 
 
Index: bu3sch-wireless-dev/include/net/mac80211.h
===================================================================
--- bu3sch-wireless-dev.orig/include/net/mac80211.h	2007-05-01 22:32:36.000000000 +0200
+++ bu3sch-wireless-dev/include/net/mac80211.h	2007-05-06 20:29:26.000000000 +0200
@@ -620,8 +620,7 @@ struct ieee80211_ops {
 	 * station hwaddr for individual keys. aid of the station is given
 	 * to help low-level driver in selecting which key->hw_key_idx to use
 	 * for this key. TX control data will use the hw_key_idx selected by
-	 * the low-level driver.
-	 * Must be atomic. */
+	 * the low-level driver. */
 	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
 		       u8 *addr, struct ieee80211_key_conf *key, int aid);
 

-- 
Greetings Michael.
