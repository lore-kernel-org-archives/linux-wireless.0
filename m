Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0FAIS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 04:18:57 -0400
Subject: [PATCH] mac80211: simplify key locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 10:19:19 +0200
Message-ID: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since I recently made station management able
to sleep, I can now rework key management as
well; since it will no longer need a spinlock
and can also use a mutex instead, a bunch of
code to allow drivers' set_key to sleep while
key management is protected by a spinlock can
now be removed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   18 +-
 net/mac80211/ieee80211_i.h |    4 
 net/mac80211/iface.c       |    5 
 net/mac80211/key.c         |  288 ++++++++++-----------------------------------
 net/mac80211/key.h         |   22 ---
 net/mac80211/main.c        |    2 
 net/mac80211/sta_info.c    |    8 -
 7 files changed, 80 insertions(+), 267 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-05-31 20:51:37.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-06-01 10:07:00.000000000 +0200
@@ -120,6 +120,9 @@ static int ieee80211_add_key(struct wiph
 	struct ieee80211_key *key;
 	int err;
 
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (params->cipher) {
@@ -145,7 +148,7 @@ static int ieee80211_add_key(struct wiph
 	if (!key)
 		return -ENOMEM;
 
-	rcu_read_lock();
+	mutex_lock(&sdata->local->sta_mtx);
 
 	if (mac_addr) {
 		sta = sta_info_get_bss(sdata, mac_addr);
@@ -160,7 +163,7 @@ static int ieee80211_add_key(struct wiph
 
 	err = 0;
  out_unlock:
-	rcu_read_unlock();
+	mutex_unlock(&sdata->local->sta_mtx);
 
 	return err;
 }
@@ -174,7 +177,7 @@ static int ieee80211_del_key(struct wiph
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	rcu_read_lock();
+	mutex_lock(&sdata->local->sta_mtx);
 
 	if (mac_addr) {
 		ret = -ENOENT;
@@ -202,7 +205,7 @@ static int ieee80211_del_key(struct wiph
 
 	ret = 0;
  out_unlock:
-	rcu_read_unlock();
+	mutex_unlock(&sdata->local->sta_mtx);
 
 	return ret;
 }
@@ -305,15 +308,10 @@ static int ieee80211_config_default_key(
 					struct net_device *dev,
 					u8 key_idx)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	rcu_read_lock();
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ieee80211_set_default_key(sdata, key_idx);
 
-	rcu_read_unlock();
-
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-31 21:20:18.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-01 09:51:50.000000000 +0200
@@ -746,10 +746,10 @@ struct ieee80211_local {
 	struct mutex iflist_mtx;
 
 	/*
-	 * Key lock, protects sdata's key_list and sta_info's
+	 * Key mutex, protects sdata's key_list and sta_info's
 	 * key pointers (write access, they're RCU.)
 	 */
-	spinlock_t key_lock;
+	struct mutex key_mtx;
 
 
 	/* Scanning and BSS list */
--- wireless-testing.orig/net/mac80211/key.c	2010-05-31 15:48:26.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2010-06-01 10:15:41.000000000 +0200
@@ -36,80 +36,20 @@
  * There is currently no way of knowing this except by looking into
  * debugfs.
  *
- * All key operations are protected internally so you can call them at
- * any time.
+ * All key operations are protected internally.
  *
  * Within mac80211, key references are, just as STA structure references,
  * protected by RCU. Note, however, that some things are unprotected,
  * namely the key->sta dereferences within the hardware acceleration
- * functions. This means that sta_info_destroy() must flush the key todo
- * list.
- *
- * All the direct key list manipulation functions must not sleep because
- * they can operate on STA info structs that are protected by RCU.
+ * functions. This means that sta_info_destroy() must remove the key
+ * which waits for an RCU grace period.
  */
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-/* key mutex: used to synchronise todo runners */
-static DEFINE_MUTEX(key_mutex);
-static DEFINE_SPINLOCK(todo_lock);
-static LIST_HEAD(todo_list);
-
-static void key_todo(struct work_struct *work)
-{
-	ieee80211_key_todo();
-}
-
-static DECLARE_WORK(todo_work, key_todo);
-
-/**
- * add_todo - add todo item for a key
- *
- * @key: key to add to do item for
- * @flag: todo flag(s)
- *
- * Must be called with IRQs or softirqs disabled.
- */
-static void add_todo(struct ieee80211_key *key, u32 flag)
-{
-	if (!key)
-		return;
-
-	spin_lock(&todo_lock);
-	key->flags |= flag;
-	/*
-	 * Remove again if already on the list so that we move it to the end.
-	 */
-	if (!list_empty(&key->todo))
-		list_del(&key->todo);
-	list_add_tail(&key->todo, &todo_list);
-	schedule_work(&todo_work);
-	spin_unlock(&todo_lock);
-}
-
-/**
- * ieee80211_key_lock - lock the mac80211 key operation lock
- *
- * This locks the (global) mac80211 key operation lock, all
- * key operations must be done under this lock.
- */
-static void ieee80211_key_lock(void)
-{
-	mutex_lock(&key_mutex);
-}
-
-/**
- * ieee80211_key_unlock - unlock the mac80211 key operation lock
- */
-static void ieee80211_key_unlock(void)
-{
-	mutex_unlock(&key_mutex);
-}
-
-static void assert_key_lock(void)
+static void assert_key_lock(struct ieee80211_local *local)
 {
-	WARN_ON(!mutex_is_locked(&key_mutex));
+	WARN_ON(!mutex_is_locked(&local->key_mtx));
 }
 
 static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
@@ -126,12 +66,13 @@ static void ieee80211_key_enable_hw_acce
 	struct ieee80211_sta *sta;
 	int ret;
 
-	assert_key_lock();
 	might_sleep();
 
 	if (!key->local->ops->set_key)
 		return;
 
+	assert_key_lock(key->local);
+
 	sta = get_sta_for_key(key);
 
 	sdata = key->sdata;
@@ -142,11 +83,8 @@ static void ieee80211_key_enable_hw_acce
 
 	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
 
-	if (!ret) {
-		spin_lock_bh(&todo_lock);
+	if (!ret)
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-		spin_unlock_bh(&todo_lock);
-	}
 
 	if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
 		printk(KERN_ERR "mac80211-%s: failed to set key "
@@ -161,18 +99,15 @@ static void ieee80211_key_disable_hw_acc
 	struct ieee80211_sta *sta;
 	int ret;
 
-	assert_key_lock();
 	might_sleep();
 
 	if (!key || !key->local->ops->set_key)
 		return;
 
-	spin_lock_bh(&todo_lock);
-	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		spin_unlock_bh(&todo_lock);
+	assert_key_lock(key->local);
+
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		return;
-	}
-	spin_unlock_bh(&todo_lock);
 
 	sta = get_sta_for_key(key);
 	sdata = key->sdata;
@@ -191,9 +126,7 @@ static void ieee80211_key_disable_hw_acc
 		       wiphy_name(key->local->hw.wiphy),
 		       key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
-	spin_lock_bh(&todo_lock);
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	spin_unlock_bh(&todo_lock);
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -201,22 +134,24 @@ static void __ieee80211_set_default_key(
 {
 	struct ieee80211_key *key = NULL;
 
+	assert_key_lock(sdata->local);
+
 	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
 		key = sdata->keys[idx];
 
 	rcu_assign_pointer(sdata->default_key, key);
 
-	if (key)
-		add_todo(key, KEY_FLAG_TODO_DEFKEY);
+	if (key) {
+		ieee80211_debugfs_key_remove_default(key->sdata);
+		ieee80211_debugfs_key_add_default(key->sdata);
+	}
 }
 
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	mutex_lock(&sdata->local->key_mtx);
 	__ieee80211_set_default_key(sdata, idx);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	mutex_unlock(&sdata->local->key_mtx);
 }
 
 static void
@@ -224,24 +159,26 @@ __ieee80211_set_default_mgmt_key(struct
 {
 	struct ieee80211_key *key = NULL;
 
+	assert_key_lock(sdata->local);
+
 	if (idx >= NUM_DEFAULT_KEYS &&
 	    idx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
 		key = sdata->keys[idx];
 
 	rcu_assign_pointer(sdata->default_mgmt_key, key);
 
-	if (key)
-		add_todo(key, KEY_FLAG_TODO_DEFMGMTKEY);
+	if (key) {
+		ieee80211_debugfs_key_remove_mgmt_default(key->sdata);
+		ieee80211_debugfs_key_add_mgmt_default(key->sdata);
+	}
 }
 
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	mutex_lock(&sdata->local->key_mtx);
 	__ieee80211_set_default_mgmt_key(sdata, idx);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	mutex_unlock(&sdata->local->key_mtx);
 }
 
 
@@ -352,7 +289,6 @@ struct ieee80211_key *ieee80211_key_allo
 	}
 	memcpy(key->conf.key, key_data, key_len);
 	INIT_LIST_HEAD(&key->list);
-	INIT_LIST_HEAD(&key->todo);
 
 	if (alg == ALG_CCMP) {
 		/*
@@ -382,12 +318,27 @@ struct ieee80211_key *ieee80211_key_allo
 	return key;
 }
 
+static void __ieee80211_key_destroy(struct ieee80211_key *key)
+{
+	if (!key)
+		return;
+
+	ieee80211_key_disable_hw_accel(key);
+
+	if (key->conf.alg == ALG_CCMP)
+		ieee80211_aes_key_free(key->u.ccmp.tfm);
+	if (key->conf.alg == ALG_AES_CMAC)
+		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
+	ieee80211_debugfs_key_remove(key);
+
+	kfree(key);
+}
+
 void ieee80211_key_link(struct ieee80211_key *key,
 			struct ieee80211_sub_if_data *sdata,
 			struct sta_info *sta)
 {
 	struct ieee80211_key *old_key;
-	unsigned long flags;
 	int idx;
 
 	BUG_ON(!sdata);
@@ -431,7 +382,7 @@ void ieee80211_key_link(struct ieee80211
 		}
 	}
 
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
+	mutex_lock(&sdata->local->key_mtx);
 
 	if (sta)
 		old_key = sta->key;
@@ -439,15 +390,13 @@ void ieee80211_key_link(struct ieee80211
 		old_key = sdata->keys[idx];
 
 	__ieee80211_key_replace(sdata, sta, old_key, key);
+	__ieee80211_key_destroy(old_key);
 
-	/* free old key later */
-	add_todo(old_key, KEY_FLAG_TODO_DELETE);
+	ieee80211_debugfs_key_add(key);
 
-	add_todo(key, KEY_FLAG_TODO_ADD_DEBUGFS);
-	if (ieee80211_sdata_running(sdata))
-		add_todo(key, KEY_FLAG_TODO_HWACCEL_ADD);
+	ieee80211_key_enable_hw_accel(key);
 
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
+	mutex_unlock(&sdata->local->key_mtx);
 }
 
 static void __ieee80211_key_free(struct ieee80211_key *key)
@@ -458,170 +407,65 @@ static void __ieee80211_key_free(struct
 	if (key->sdata)
 		__ieee80211_key_replace(key->sdata, key->sta,
 					key, NULL);
-
-	add_todo(key, KEY_FLAG_TODO_DELETE);
+	__ieee80211_key_destroy(key);
 }
 
 void ieee80211_key_free(struct ieee80211_key *key)
 {
-	unsigned long flags;
+	struct ieee80211_local *local;
 
 	if (!key)
 		return;
 
-	if (!key->sdata) {
-		/* The key has not been linked yet, simply free it
-		 * and don't Oops */
-		if (key->conf.alg == ALG_CCMP)
-			ieee80211_aes_key_free(key->u.ccmp.tfm);
-		kfree(key);
-		return;
-	}
+	local = key->sdata->local;
 
-	spin_lock_irqsave(&key->sdata->local->key_lock, flags);
+	mutex_lock(&local->key_mtx);
 	__ieee80211_key_free(key);
-	spin_unlock_irqrestore(&key->sdata->local->key_lock, flags);
+	mutex_unlock(&local->key_mtx);
 }
 
-/*
- * To be safe against concurrent manipulations of the list (which shouldn't
- * actually happen) we need to hold the spinlock. But under the spinlock we
- * can't actually do much, so we defer processing to the todo list. Then run
- * the todo list to be sure the operation and possibly previously pending
- * operations are completed.
- */
-static void ieee80211_todo_for_each_key(struct ieee80211_sub_if_data *sdata,
-					u32 todo_flags)
+void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;
-	unsigned long flags;
 
-	might_sleep();
-
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
-	list_for_each_entry(key, &sdata->key_list, list)
-		add_todo(key, todo_flags);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
-
-	ieee80211_key_todo();
-}
-
-void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
-{
 	ASSERT_RTNL();
 
 	if (WARN_ON(!ieee80211_sdata_running(sdata)))
 		return;
 
-	ieee80211_todo_for_each_key(sdata, KEY_FLAG_TODO_HWACCEL_ADD);
-}
-
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
-{
-	ASSERT_RTNL();
-
-	ieee80211_todo_for_each_key(sdata, KEY_FLAG_TODO_HWACCEL_REMOVE);
-}
-
-static void __ieee80211_key_destroy(struct ieee80211_key *key)
-{
-	if (!key)
-		return;
+	mutex_lock(&sdata->local->key_mtx);
 
-	ieee80211_key_disable_hw_accel(key);
-
-	if (key->conf.alg == ALG_CCMP)
-		ieee80211_aes_key_free(key->u.ccmp.tfm);
-	if (key->conf.alg == ALG_AES_CMAC)
-		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
-	ieee80211_debugfs_key_remove(key);
+	list_for_each_entry(key, &sdata->key_list, list)
+		ieee80211_key_enable_hw_accel(key);
 
-	kfree(key);
+	mutex_unlock(&sdata->local->key_mtx);
 }
 
-static void __ieee80211_key_todo(void)
+void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;
-	bool work_done;
-	u32 todoflags;
-
-	/*
-	 * NB: sta_info_destroy relies on this!
-	 */
-	synchronize_rcu();
 
-	spin_lock_bh(&todo_lock);
-	while (!list_empty(&todo_list)) {
-		key = list_first_entry(&todo_list, struct ieee80211_key, todo);
-		list_del_init(&key->todo);
-		todoflags = key->flags & (KEY_FLAG_TODO_ADD_DEBUGFS |
-					  KEY_FLAG_TODO_DEFKEY |
-					  KEY_FLAG_TODO_DEFMGMTKEY |
-					  KEY_FLAG_TODO_HWACCEL_ADD |
-					  KEY_FLAG_TODO_HWACCEL_REMOVE |
-					  KEY_FLAG_TODO_DELETE);
-		key->flags &= ~todoflags;
-		spin_unlock_bh(&todo_lock);
-
-		work_done = false;
-
-		if (todoflags & KEY_FLAG_TODO_ADD_DEBUGFS) {
-			ieee80211_debugfs_key_add(key);
-			work_done = true;
-		}
-		if (todoflags & KEY_FLAG_TODO_DEFKEY) {
-			ieee80211_debugfs_key_remove_default(key->sdata);
-			ieee80211_debugfs_key_add_default(key->sdata);
-			work_done = true;
-		}
-		if (todoflags & KEY_FLAG_TODO_DEFMGMTKEY) {
-			ieee80211_debugfs_key_remove_mgmt_default(key->sdata);
-			ieee80211_debugfs_key_add_mgmt_default(key->sdata);
-			work_done = true;
-		}
-		if (todoflags & KEY_FLAG_TODO_HWACCEL_ADD) {
-			ieee80211_key_enable_hw_accel(key);
-			work_done = true;
-		}
-		if (todoflags & KEY_FLAG_TODO_HWACCEL_REMOVE) {
-			ieee80211_key_disable_hw_accel(key);
-			work_done = true;
-		}
-		if (todoflags & KEY_FLAG_TODO_DELETE) {
-			__ieee80211_key_destroy(key);
-			work_done = true;
-		}
+	ASSERT_RTNL();
 
-		WARN_ON(!work_done);
+	mutex_lock(&sdata->local->key_mtx);
 
-		spin_lock_bh(&todo_lock);
-	}
-	spin_unlock_bh(&todo_lock);
-}
+	list_for_each_entry(key, &sdata->key_list, list)
+		ieee80211_key_disable_hw_accel(key);
 
-void ieee80211_key_todo(void)
-{
-	ieee80211_key_lock();
-	__ieee80211_key_todo();
-	ieee80211_key_unlock();
+	mutex_unlock(&sdata->local->key_mtx);
 }
 
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
-	unsigned long flags;
 
-	ieee80211_key_lock();
+	mutex_lock(&sdata->local->key_mtx);
 
 	ieee80211_debugfs_key_remove_default(sdata);
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
-	spin_lock_irqsave(&sdata->local->key_lock, flags);
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 		__ieee80211_key_free(key);
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
-
-	__ieee80211_key_todo();
 
-	ieee80211_key_unlock();
+	mutex_unlock(&sdata->local->key_mtx);
 }
--- wireless-testing.orig/net/mac80211/main.c	2010-05-31 21:20:16.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-06-01 09:51:50.000000000 +0200
@@ -396,7 +396,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	mutex_init(&local->iflist_mtx);
 	mutex_init(&local->scan_mtx);
 
-	spin_lock_init(&local->key_lock);
+	mutex_init(&local->key_mtx);
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
--- wireless-testing.orig/net/mac80211/key.h	2010-05-31 15:48:26.000000000 +0200
+++ wireless-testing/net/mac80211/key.h	2010-06-01 09:51:50.000000000 +0200
@@ -38,25 +38,9 @@ struct sta_info;
  *
  * @KEY_FLAG_UPLOADED_TO_HARDWARE: Indicates that this key is present
  *	in the hardware for TX crypto hardware acceleration.
- * @KEY_FLAG_TODO_DELETE: Key is marked for deletion and will, after an
- *	RCU grace period, no longer be reachable other than from the
- *	todo list.
- * @KEY_FLAG_TODO_HWACCEL_ADD: Key needs to be added to hardware acceleration.
- * @KEY_FLAG_TODO_HWACCEL_REMOVE: Key needs to be removed from hardware
- *	acceleration.
- * @KEY_FLAG_TODO_DEFKEY: Key is default key and debugfs needs to be updated.
- * @KEY_FLAG_TODO_ADD_DEBUGFS: Key needs to be added to debugfs.
- * @KEY_FLAG_TODO_DEFMGMTKEY: Key is default management key and debugfs needs
- *	to be updated.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
-	KEY_FLAG_TODO_DELETE		= BIT(1),
-	KEY_FLAG_TODO_HWACCEL_ADD	= BIT(2),
-	KEY_FLAG_TODO_HWACCEL_REMOVE	= BIT(3),
-	KEY_FLAG_TODO_DEFKEY		= BIT(4),
-	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(5),
-	KEY_FLAG_TODO_DEFMGMTKEY	= BIT(6),
 };
 
 enum ieee80211_internal_tkip_state {
@@ -79,10 +63,8 @@ struct ieee80211_key {
 
 	/* for sdata list */
 	struct list_head list;
-	/* for todo list */
-	struct list_head todo;
 
-	/* protected by todo lock! */
+	/* protected by key mutex */
 	unsigned int flags;
 
 	union {
@@ -155,6 +137,4 @@ void ieee80211_free_keys(struct ieee8021
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
 
-void ieee80211_key_todo(void);
-
 #endif /* IEEE80211_KEY_H */
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-05-31 21:20:15.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-06-01 10:15:45.000000000 +0200
@@ -648,14 +648,6 @@ static int __must_check __sta_info_destr
 
 	if (sta->key) {
 		ieee80211_key_free(sta->key);
-		/*
-		 * We have only unlinked the key, and actually destroying it
-		 * may mean it is removed from hardware which requires that
-		 * the key->sta pointer is still valid, so flush the key todo
-		 * list here.
-		 */
-		ieee80211_key_todo();
-
 		WARN_ON(sta->key);
 	}
 
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-01 09:51:49.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-01 09:51:50.000000000 +0200
@@ -268,7 +268,6 @@ static int ieee80211_open(struct net_dev
 
 		changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
-		ieee80211_enable_keys(sdata);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION)
 			netif_carrier_off(dev);
@@ -522,8 +521,8 @@ static int ieee80211_stop(struct net_dev
 				BSS_CHANGED_BEACON_ENABLED);
 		}
 
-		/* disable all keys for as long as this netdev is down */
-		ieee80211_disable_keys(sdata);
+		/* free all remaining keys, there shouldn't be any */
+		ieee80211_free_keys(sdata);
 		drv_remove_interface(local, &sdata->vif);
 	}
 


