Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYDHP5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 11:57:04 -0400
Subject: [PATCH v2] mac80211: fix key vs. sta locking problems
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1207652975.14253.7.camel@johannes.berg> (sfid-20080408_153208_486174_0F26D65C)
References: <1207652975.14253.7.camel@johannes.berg>
	 (sfid-20080408_153208_486174_0F26D65C)
Content-Type: text/plain
Date: Tue, 08 Apr 2008 17:56:52 +0200
Message-Id: <1207670212.5550.0.camel@johannes.berg> (sfid-20080408_165742_434728_B84D6D1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Up to now, key manipulation is supposed to run under RTNL to
avoid concurrent manipulations and also allow the set_key()
hardware callback to sleep. This is not feasible because STA
structs are rcu-protected and thus a lot of operations there
cannot take the RTNL. Also, key references are rcu-protected
so we cannot do things atomically.

This patch changes key locking completely:
 * key operations are now atomic
 * hardware crypto offload is enabled and disabled from
   a workqueue, due to that key freeing is also delayed
 * debugfs code is also run from a workqueue
 * keys reference STAs (and vice versa!) so during STA
   unlink the STAs key reference is removed but not the
   keys STA reference, to avoid races key todo work is
   run before STA destruction.
 * fewer STA operations now need the RTNL which was
   required due to key operations

This fixes the locking problems lockdep pointed out and also
makes things more light-weight because the rtnl isn't required
as much.

Note that the key todo lock/key mutex are global locks, this
is not required, of course, they could be per-hardware instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Tested in AP mode (with WPA), STA mode (with WPA) and IBSS
mode (unencrypted); first time I actually used IBSS :)

Oddly, IBSS mode on the same machine between two wireless NICs
didn't quite work, ARP never resolved.

v2: fix small bug with hw accel enabling

 net/mac80211/cfg.c             |   44 +++-
 net/mac80211/debugfs_key.c     |   38 ++-
 net/mac80211/debugfs_key.h     |   11 -
 net/mac80211/ieee80211.c       |    6 
 net/mac80211/ieee80211_i.h     |    4 
 net/mac80211/ieee80211_ioctl.c |   26 ++
 net/mac80211/ieee80211_key.h   |   20 +-
 net/mac80211/ieee80211_sta.c   |    9 
 net/mac80211/key.c             |  406 ++++++++++++++++++++++++++---------------
 net/mac80211/sta_info.c        |   48 ++--
 net/mac80211/sta_info.h        |    1 
 11 files changed, 386 insertions(+), 227 deletions(-)

--- everything.orig/net/mac80211/key.c	2008-04-08 17:06:51.000000000 +0200
+++ everything/net/mac80211/key.c	2008-04-08 17:54:23.000000000 +0200
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -33,17 +33,78 @@
  * There is currently no way of knowing this except by looking into
  * debugfs.
  *
- * All operations here are called under RTNL so no extra locking is
- * required.
+ * All key operations are protected internally so you can call them at
+ * any time.
  *
- * NOTE: This code requires that sta info *destruction* is done under
- *	 RTNL, otherwise it can try to access already freed STA structs
- *	 when a STA key is being freed.
+ * Within mac80211, key references are, just as STA structure references,
+ * protected by RCU. Note, however, that some things are unprotected,
+ * namely the key->sta dereferences within the hardware acceleration
+ * functions. This means that sta_info_destroy() must flush the key todo
+ * list.
+ *
+ * All the direct key list manipulation functions must not sleep because
+ * they can operate on STA info structs that are protected by RCU.
  */
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 static const u8 zero_addr[ETH_ALEN];
 
+/* key mutex: used to synchronise todo runners */
+static DEFINE_MUTEX(key_mutex);
+static DEFINE_SPINLOCK(todo_lock);
+static LIST_HEAD(todo_list);
+
+static void key_todo(struct work_struct *work)
+{
+	ieee80211_key_todo();
+}
+
+static DECLARE_WORK(todo_work, key_todo);
+
+/**
+ * add_todo - add todo item for a key
+ *
+ * @key: key to add to do item for
+ * @flag: todo flag(s)
+ */
+static void add_todo(struct ieee80211_key *key, u32 flag)
+{
+	if (!key)
+		return;
+
+	spin_lock(&todo_lock);
+	key->flags |= flag;
+	/* only add if not already added */
+	if (list_empty(&key->todo))
+		list_add(&key->todo, &todo_list);
+	schedule_work(&todo_work);
+	spin_unlock(&todo_lock);
+}
+
+/**
+ * ieee80211_key_lock - lock the mac80211 key operation lock
+ *
+ * This locks the (global) mac80211 key operation lock, all
+ * key operations must be done under this lock.
+ */
+static void ieee80211_key_lock(void)
+{
+	mutex_lock(&key_mutex);
+}
+
+/**
+ * ieee80211_key_unlock - unlock the mac80211 key operation lock
+ */
+static void ieee80211_key_unlock(void)
+{
+	mutex_unlock(&key_mutex);
+}
+
+static void assert_key_lock(void)
+{
+	WARN_ON(!mutex_is_locked(&key_mutex));
+}
+
 static const u8 *get_mac_for_key(struct ieee80211_key *key)
 {
 	const u8 *addr = bcast_addr;
@@ -70,26 +131,23 @@ static void ieee80211_key_enable_hw_acce
 	int ret;
 	DECLARE_MAC_BUF(mac);
 
+	assert_key_lock();
+	might_sleep();
+
 	if (!key->local->ops->set_key)
 		return;
 
-	/*
-	 * This makes sure that all pending flushes have
-	 * actually completed prior to uploading new key
-	 * material to the hardware. That is necessary to
-	 * avoid races between flushing STAs and adding
-	 * new keys for them.
-	 */
-	__ieee80211_run_pending_flush(key->local);
-
 	addr = get_mac_for_key(key);
 
 	ret = key->local->ops->set_key(local_to_hw(key->local), SET_KEY,
 				       key->sdata->dev->dev_addr, addr,
 				       &key->conf);
 
-	if (!ret)
+	if (!ret) {
+		spin_lock(&todo_lock);
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+		spin_unlock(&todo_lock);
+	}
 
 	if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
 		printk(KERN_ERR "mac80211-%s: failed to set key "
@@ -98,26 +156,24 @@ static void ieee80211_key_enable_hw_acce
 		       key->conf.keyidx, print_mac(mac, addr), ret);
 }
 
-static void ieee80211_key_mark_hw_accel_off(struct ieee80211_key *key)
-{
-	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-		key->flags |= KEY_FLAG_REMOVE_FROM_HARDWARE;
-	}
-}
-
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 {
 	const u8 *addr;
 	int ret;
 	DECLARE_MAC_BUF(mac);
 
+	assert_key_lock();
+	might_sleep();
+
 	if (!key || !key->local->ops->set_key)
 		return;
 
-	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(key->flags & KEY_FLAG_REMOVE_FROM_HARDWARE))
+	spin_lock(&todo_lock);
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+		spin_unlock(&todo_lock);
 		return;
+	}
+	spin_unlock(&todo_lock);
 
 	addr = get_mac_for_key(key);
 
@@ -131,8 +187,72 @@ static void ieee80211_key_disable_hw_acc
 		       wiphy_name(key->local->hw.wiphy),
 		       key->conf.keyidx, print_mac(mac, addr), ret);
 
-	key->flags &= ~(KEY_FLAG_UPLOADED_TO_HARDWARE |
-			KEY_FLAG_REMOVE_FROM_HARDWARE);
+	spin_lock(&todo_lock);
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+	spin_unlock(&todo_lock);
+}
+
+static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
+					int idx)
+{
+	struct ieee80211_key *key = NULL;
+
+	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
+		key = sdata->keys[idx];
+
+	rcu_assign_pointer(sdata->default_key, key);
+
+	if (key)
+		add_todo(key, KEY_FLAG_TODO_DEFKEY);
+}
+
+void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdata->local->sta_lock, flags);
+	__ieee80211_set_default_key(sdata, idx);
+	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
+}
+
+
+static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+				    struct sta_info *sta,
+				    struct ieee80211_key *old,
+				    struct ieee80211_key *new)
+{
+	int idx, defkey;
+
+	if (new)
+		list_add(&new->list, &sdata->key_list);
+
+	if (sta) {
+		rcu_assign_pointer(sta->key, new);
+	} else {
+		WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
+
+		if (old)
+			idx = old->conf.keyidx;
+		else
+			idx = new->conf.keyidx;
+
+		defkey = old && sdata->default_key == old;
+
+		if (defkey && !new)
+			__ieee80211_set_default_key(sdata, -1);
+
+		rcu_assign_pointer(sdata->keys[idx], new);
+		if (defkey && new)
+			__ieee80211_set_default_key(sdata, new->conf.keyidx);
+	}
+
+	if (old) {
+		/*
+		 * We'll use an empty list to indicate that the key
+		 * has already been removed.
+		 */
+		list_del_init(&old->list);
+	}
 }
 
 struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
@@ -160,6 +280,7 @@ struct ieee80211_key *ieee80211_key_allo
 	key->conf.keylen = key_len;
 	memcpy(key->conf.key, key_data, key_len);
 	INIT_LIST_HEAD(&key->list);
+	INIT_LIST_HEAD(&key->todo);
 
 	if (alg == ALG_CCMP) {
 		/*
@@ -168,7 +289,7 @@ struct ieee80211_key *ieee80211_key_allo
 		 */
 		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(key_data);
 		if (!key->u.ccmp.tfm) {
-			ieee80211_key_free(key);
+			kfree(key);
 			return NULL;
 		}
 	}
@@ -176,56 +297,14 @@ struct ieee80211_key *ieee80211_key_allo
 	return key;
 }
 
-static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
-				    struct sta_info *sta,
-				    struct ieee80211_key *key,
-				    struct ieee80211_key *new)
-{
-	int idx, defkey;
-
-	if (new)
-		list_add(&new->list, &sdata->key_list);
-
-	if (sta) {
-		rcu_assign_pointer(sta->key, new);
-	} else {
-		WARN_ON(new && key && new->conf.keyidx != key->conf.keyidx);
-
-		if (key)
-			idx = key->conf.keyidx;
-		else
-			idx = new->conf.keyidx;
-
-		defkey = key && sdata->default_key == key;
-
-		if (defkey && !new)
-			ieee80211_set_default_key(sdata, -1);
-
-		rcu_assign_pointer(sdata->keys[idx], new);
-		if (defkey && new)
-			ieee80211_set_default_key(sdata, new->conf.keyidx);
-	}
-
-	if (key) {
-		ieee80211_key_mark_hw_accel_off(key);
-		/*
-		 * We'll use an empty list to indicate that the key
-		 * has already been removed.
-		 */
-		list_del_init(&key->list);
-	}
-}
-
 void ieee80211_key_link(struct ieee80211_key *key,
 			struct ieee80211_sub_if_data *sdata,
 			struct sta_info *sta)
 {
 	struct ieee80211_key *old_key;
+	unsigned long flags;
 	int idx;
 
-	ASSERT_RTNL();
-	might_sleep();
-
 	BUG_ON(!sdata);
 	BUG_ON(!key);
 
@@ -234,11 +313,7 @@ void ieee80211_key_link(struct ieee80211
 	key->sdata = sdata;
 	key->sta = sta;
 
-	ieee80211_debugfs_key_add(key->local, key);
-
 	if (sta) {
-		ieee80211_debugfs_key_sta_link(key, sta);
-
 		/*
 		 * some hardware cannot handle TKIP with QoS, so
 		 * we indicate whether QoS could be in use.
@@ -249,7 +324,10 @@ void ieee80211_key_link(struct ieee80211
 		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 			struct sta_info *ap;
 
-			rcu_read_lock();
+			/*
+			 * We're getting a sta pointer in,
+			 * so must be under RCU read lock.
+			 */
 
 			/* same here, the AP could be using QoS */
 			ap = sta_info_get(key->local, key->sdata->u.sta.bssid);
@@ -258,11 +336,11 @@ void ieee80211_key_link(struct ieee80211
 					key->conf.flags |=
 						IEEE80211_KEY_FLAG_WMM_STA;
 			}
-
-			rcu_read_unlock();
 		}
 	}
 
+	spin_lock_irqsave(&sdata->local->sta_lock, flags);
+
 	if (sta)
 		old_key = sta->key;
 	else
@@ -270,50 +348,73 @@ void ieee80211_key_link(struct ieee80211
 
 	__ieee80211_key_replace(sdata, sta, old_key, key);
 
-	if (old_key) {
-		synchronize_rcu();
-		ieee80211_key_free(old_key);
-	}
+	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
+
+	/* free old key later */
+	add_todo(old_key, KEY_FLAG_TODO_DELETE);
 
+	add_todo(key, KEY_FLAG_TODO_ADD_DEBUGFS);
 	if (netif_running(sdata->dev))
-		ieee80211_key_enable_hw_accel(key);
+		add_todo(key, KEY_FLAG_TODO_HWACCEL);
 }
 
 void ieee80211_key_free(struct ieee80211_key *key)
 {
-	ASSERT_RTNL();
-	might_sleep();
+	unsigned long flags;
 
 	if (!key)
 		return;
 
+	/*
+	 * Replace key with nothingness if it was ever used.
+	 */
 	if (key->sdata) {
-		/*
-		 * Replace key with nothingness.
-		 *
-		 * Because other code may have key reference (RCU protected)
-		 * right now, we then wait for a grace period before freeing
-		 * it.
-		 * An empty list indicates it was never added to the key list
-		 * or has been removed already. It may, however, still be in
-		 * hardware for acceleration.
-		 */
-		if (!list_empty(&key->list))
-			__ieee80211_key_replace(key->sdata, key->sta,
-						key, NULL);
+		spin_lock_irqsave(&key->sdata->local->sta_lock, flags);
+		__ieee80211_key_replace(key->sdata, key->sta,
+					key, NULL);
+		spin_unlock_irqrestore(&key->sdata->local->sta_lock, flags);
+	}
 
-		/*
-		 * Do NOT remove this without looking at sta_info_destroy()
-		 */
-		synchronize_rcu();
+	add_todo(key, KEY_FLAG_TODO_DELETE);
+}
 
-		/*
-		 * Remove from hwaccel if appropriate, this will
-		 * only happen when the key is actually unlinked,
-		 * it will already be done when the key was replaced.
-		 */
+void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_key *key;
+
+	might_sleep();
+
+	if (WARN_ON(!netif_running(sdata->dev)))
+		return;
+
+	ieee80211_key_lock();
+
+	list_for_each_entry(key, &sdata->key_list, list)
+		ieee80211_key_enable_hw_accel(key);
+
+	ieee80211_key_unlock();
+}
+
+void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_key *key;
+
+	might_sleep();
+
+	ieee80211_key_lock();
+
+	list_for_each_entry(key, &sdata->key_list, list)
 		ieee80211_key_disable_hw_accel(key);
-	}
+
+	ieee80211_key_unlock();
+}
+
+static void __ieee80211_key_free(struct ieee80211_key *key)
+{
+	if (!key)
+		return;
+
+	ieee80211_key_disable_hw_accel(key);
 
 	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
@@ -322,21 +423,60 @@ void ieee80211_key_free(struct ieee80211
 	kfree(key);
 }
 
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)
+static void __ieee80211_key_todo(void)
 {
-	struct ieee80211_key *key = NULL;
+	struct ieee80211_key *key;
+	bool work_done;
+	u32 todoflags;
 
-	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
-		key = sdata->keys[idx];
+	/*
+	 * NB: sta_info_destroy relies on this!
+	 */
+	synchronize_rcu();
 
-	if (sdata->default_key != key) {
-		ieee80211_debugfs_key_remove_default(sdata);
+	spin_lock(&todo_lock);
+	while (!list_empty(&todo_list)) {
+		key = list_first_entry(&todo_list, struct ieee80211_key, todo);
+		list_del_init(&key->todo);
+		todoflags = key->flags & (KEY_FLAG_TODO_ADD_DEBUGFS |
+					  KEY_FLAG_TODO_DEFKEY |
+					  KEY_FLAG_TODO_HWACCEL |
+					  KEY_FLAG_TODO_DELETE);
+		key->flags &= ~todoflags;
+		spin_unlock(&todo_lock);
+
+		work_done = false;
+
+		if (todoflags & KEY_FLAG_TODO_ADD_DEBUGFS) {
+			ieee80211_debugfs_key_add(key);
+			work_done = true;
+		}
+		if (todoflags & KEY_FLAG_TODO_DEFKEY) {
+			ieee80211_debugfs_key_remove_default(key->sdata);
+			ieee80211_debugfs_key_add_default(key->sdata);
+			work_done = true;
+		}
+		if (todoflags & KEY_FLAG_TODO_HWACCEL) {
+			ieee80211_key_enable_hw_accel(key);
+			work_done = true;
+		}
+		if (todoflags & KEY_FLAG_TODO_DELETE) {
+			__ieee80211_key_free(key);
+			work_done = true;
+		}
 
-		rcu_assign_pointer(sdata->default_key, key);
+		WARN_ON(!work_done);
 
-		if (sdata->default_key)
-			ieee80211_debugfs_key_add_default(sdata);
+		spin_lock(&todo_lock);
 	}
+	spin_unlock(&todo_lock);
+}
+
+void ieee80211_key_todo(void)
+{
+	ieee80211_key_lock();
+	__ieee80211_key_todo();
+	ieee80211_key_unlock();
 }
 
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
@@ -344,34 +484,14 @@ void ieee80211_free_keys(struct ieee8021
 	struct ieee80211_key *key, *tmp;
 	LIST_HEAD(tmp_list);
 
-	ASSERT_RTNL();
-	might_sleep();
+	ieee80211_key_lock();
+
+	ieee80211_debugfs_key_remove_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 		ieee80211_key_free(key);
-}
 
-void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_key *key;
-
-	ASSERT_RTNL();
-	might_sleep();
-
-	if (WARN_ON(!netif_running(sdata->dev)))
-		return;
+	__ieee80211_key_todo();
 
-	list_for_each_entry(key, &sdata->key_list, list)
-		ieee80211_key_enable_hw_accel(key);
-}
-
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_key *key;
-
-	ASSERT_RTNL();
-	might_sleep();
-
-	list_for_each_entry(key, &sdata->key_list, list)
-		ieee80211_key_disable_hw_accel(key);
+	ieee80211_key_unlock();
 }
--- everything.orig/net/mac80211/ieee80211_key.h	2008-04-08 17:09:59.000000000 +0200
+++ everything/net/mac80211/ieee80211_key.h	2008-04-08 17:53:49.000000000 +0200
@@ -51,13 +51,19 @@ struct sta_info;
  *
  * @KEY_FLAG_UPLOADED_TO_HARDWARE: Indicates that this key is present
  *	in the hardware for TX crypto hardware acceleration.
- * @KEY_FLAG_REMOVE_FROM_HARDWARE: Indicates to the key code that this
- *	key is present in the hardware (but it cannot be used for
- *	hardware acceleration any more!)
+ * @KEY_FLAG_TODO_DELETE: Key is marked for deletion and will, after an
+ *	RCU grace period, no longer be reachable other than from the
+ *	todo list.
+ * @KEY_FLAG_TODO_HWACCEL: Key needs to be added to hardware acceleration.
+ * @KEY_FLAG_TODO_DEFKEY: Key is default key and debugfs needs to be updated.
+ * @KEY_FLAG_TODO_ADD_DEBUGFS: Key needs to be added to debugfs.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
-	KEY_FLAG_REMOVE_FROM_HARDWARE	= BIT(1),
+	KEY_FLAG_TODO_DELETE		= BIT(1),
+	KEY_FLAG_TODO_HWACCEL		= BIT(2),
+	KEY_FLAG_TODO_DEFKEY		= BIT(3),
+	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(4),
 };
 
 struct ieee80211_key {
@@ -65,8 +71,12 @@ struct ieee80211_key {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
+	/* for sdata list */
 	struct list_head list;
+	/* for todo list */
+	struct list_head todo;
 
+	/* protected by todo lock! */
 	unsigned int flags;
 
 	union {
@@ -143,4 +153,6 @@ void ieee80211_free_keys(struct ieee8021
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
 
+void ieee80211_key_todo(void);
+
 #endif /* IEEE80211_KEY_H */
--- everything.orig/net/mac80211/sta_info.c	2008-04-08 17:10:00.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-04-08 17:53:48.000000000 +0200
@@ -51,17 +51,15 @@
  *
  * In order to remove a STA info structure, the caller needs to first
  * unlink it (sta_info_unlink()) from the list and hash tables and
- * then destroy it while holding the RTNL; sta_info_destroy() will wait
- * for an RCU grace period to elapse before actually freeing it. Due to
- * the pinning and the possibility of multiple callers trying to remove
- * the same STA info at the same time, sta_info_unlink() can clear the
- * STA info pointer it is passed to indicate that the STA info is owned
- * by somebody else now.
+ * then destroy it; sta_info_destroy() will wait for an RCU grace period
+ * to elapse before actually freeing it. Due to the pinning and the
+ * possibility of multiple callers trying to remove the same STA info at
+ * the same time, sta_info_unlink() can clear the STA info pointer it is
+ * passed to indicate that the STA info is owned by somebody else now.
  *
  * If sta_info_unlink() did not clear the pointer then the caller owns
  * the STA info structure now and is responsible of destroying it with
- * a call to sta_info_destroy(), not before RCU synchronisation, of
- * course. Note that sta_info_destroy() must be protected by the RTNL.
+ * a call to sta_info_destroy().
  *
  * In all other cases, there is no concept of ownership on a STA entry,
  * each structure is owned by the global hash table/list until it is
@@ -164,7 +162,6 @@ void sta_info_destroy(struct sta_info *s
 	struct sk_buff *skb;
 	int i;
 
-	ASSERT_RTNL();
 	might_sleep();
 
 	if (!sta)
@@ -180,22 +177,16 @@ void sta_info_destroy(struct sta_info *s
 		mesh_plink_deactivate(sta);
 #endif
 
-	if (sta->key) {
-		/*
-		 * NOTE: This will call synchronize_rcu() internally to
-		 * make sure no key references can be in use. We rely on
-		 * that when we take this branch to make sure nobody can
-		 * reference this STA struct any longer!
-		 */
-		ieee80211_key_free(sta->key);
-		WARN_ON(sta->key);
-	} else {
-		/*
-		 * Make sure that nobody can reference this STA struct
-		 * any longer.
-		 */
-		synchronize_rcu();
-	}
+	/*
+	 * We have only unlinked the key, and actually destroying it
+	 * may mean it is removed from hardware which requires that
+	 * the key->sta pointer is still valid, so flush the key todo
+	 * list here.
+	 *
+	 * ieee80211_key_todo() will synchronize_rcu() so after this
+	 * nothing can reference this sta struct any more.
+	 */
+	ieee80211_key_todo();
 
 #ifdef CONFIG_MAC80211_MESH
 	if (ieee80211_vif_is_mesh(&sta->sdata->vif))
@@ -469,6 +460,11 @@ void __sta_info_unlink(struct sta_info *
 		return;
 	}
 
+	if ((*sta)->key) {
+		ieee80211_key_free((*sta)->key);
+		WARN_ON((*sta)->key);
+	}
+
 	list_del(&(*sta)->list);
 
 	if ((*sta)->flags & WLAN_STA_PS) {
@@ -652,7 +648,7 @@ static void sta_info_debugfs_add_work(st
 }
 #endif
 
-void __ieee80211_run_pending_flush(struct ieee80211_local *local)
+static void __ieee80211_run_pending_flush(struct ieee80211_local *local)
 {
 	struct sta_info *sta;
 	unsigned long flags;
--- everything.orig/net/mac80211/debugfs_key.c	2008-04-08 17:09:59.000000000 +0200
+++ everything/net/mac80211/debugfs_key.c	2008-04-08 17:53:48.000000000 +0200
@@ -184,24 +184,39 @@ KEY_OPS(key);
 	key->debugfs.name = debugfs_create_file(#name, 0400,\
 				key->debugfs.dir, key, &key_##name##_ops);
 
-void ieee80211_debugfs_key_add(struct ieee80211_local *local,
-			       struct ieee80211_key *key)
+void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 {
 	static int keycount;
-	char buf[20];
+	char buf[50];
+	DECLARE_MAC_BUF(mac);
+	struct sta_info *sta;
 
-	if (!local->debugfs.keys)
+	if (!key->local->debugfs.keys)
 		return;
 
 	sprintf(buf, "%d", keycount);
 	key->debugfs.cnt = keycount;
 	keycount++;
 	key->debugfs.dir = debugfs_create_dir(buf,
-					local->debugfs.keys);
+					key->local->debugfs.keys);
 
 	if (!key->debugfs.dir)
 		return;
 
+	if (!key->debugfs.dir)
+		return;
+
+	rcu_read_lock();
+	sta = rcu_dereference(key->sta);
+	if (sta)
+		sprintf(buf, "../../stations/%s", print_mac(mac, sta->addr));
+	rcu_read_unlock();
+
+	/* using sta as a boolean is fine outside RCU lock */
+	if (sta)
+		key->debugfs.stalink =
+			debugfs_create_symlink("station", key->debugfs.dir, buf);
+
 	DEBUGFS_ADD(keylen);
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(keyidx);
@@ -259,19 +274,6 @@ void ieee80211_debugfs_key_remove_defaul
 	debugfs_remove(sdata->debugfs.default_key);
 	sdata->debugfs.default_key = NULL;
 }
-void ieee80211_debugfs_key_sta_link(struct ieee80211_key *key,
-				    struct sta_info *sta)
-{
-	char buf[50];
-	DECLARE_MAC_BUF(mac);
-
-	if (!key->debugfs.dir)
-		return;
-
-	sprintf(buf, "../../stations/%s", print_mac(mac, sta->addr));
-	key->debugfs.stalink =
-		debugfs_create_symlink("station", key->debugfs.dir, buf);
-}
 
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 				   struct sta_info *sta)
--- everything.orig/net/mac80211/debugfs_key.h	2008-04-08 17:06:51.000000000 +0200
+++ everything/net/mac80211/debugfs_key.h	2008-04-08 17:10:01.000000000 +0200
@@ -2,18 +2,14 @@
 #define __MAC80211_DEBUGFS_KEY_H
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-void ieee80211_debugfs_key_add(struct ieee80211_local *local,
-			       struct ieee80211_key *key);
+void ieee80211_debugfs_key_add(struct ieee80211_key *key);
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
 void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata);
-void ieee80211_debugfs_key_sta_link(struct ieee80211_key *key,
-				    struct sta_info *sta);
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 				   struct sta_info *sta);
 #else
-static inline void ieee80211_debugfs_key_add(struct ieee80211_local *local,
-					     struct ieee80211_key *key)
+static inline void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 {}
 static inline void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
 {}
@@ -23,9 +19,6 @@ static inline void ieee80211_debugfs_key
 static inline void ieee80211_debugfs_key_remove_default(
 	struct ieee80211_sub_if_data *sdata)
 {}
-static inline void ieee80211_debugfs_key_sta_link(
-	struct ieee80211_key *key, struct sta_info *sta)
-{}
 static inline void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 						 struct sta_info *sta)
 {}
--- everything.orig/net/mac80211/ieee80211.c	2008-04-08 17:06:51.000000000 +0200
+++ everything/net/mac80211/ieee80211.c	2008-04-08 17:53:50.000000000 +0200
@@ -1855,6 +1855,12 @@ static void __exit ieee80211_exit(void)
 {
 	rc80211_pid_exit();
 
+	/*
+	 * For key todo, it'll be empty by now but the work
+	 * might still be scheduled.
+	 */
+	flush_scheduled_work();
+
 	if (mesh_allocated)
 		ieee80211s_stop();
 
--- everything.orig/net/mac80211/cfg.c	2008-04-08 17:09:59.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-04-08 17:53:47.000000000 +0200
@@ -141,6 +141,7 @@ static int ieee80211_add_key(struct wiph
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
 	struct ieee80211_key *key;
+	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -163,17 +164,24 @@ static int ieee80211_add_key(struct wiph
 	if (!key)
 		return -ENOMEM;
 
+	rcu_read_lock();
+
 	if (mac_addr) {
 		sta = sta_info_get(sdata->local, mac_addr);
 		if (!sta) {
 			ieee80211_key_free(key);
-			return -ENOENT;
+			err = -ENOENT;
+			goto out_unlock;
 		}
 	}
 
 	ieee80211_key_link(key, sdata, sta);
 
-	return 0;
+	err = 0;
+ out_unlock:
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
@@ -185,28 +193,37 @@ static int ieee80211_del_key(struct wiph
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	rcu_read_lock();
+
 	if (mac_addr) {
+		ret = -ENOENT;
+
 		sta = sta_info_get(sdata->local, mac_addr);
 		if (!sta)
-			return -ENOENT;
+			goto out_unlock;
 
-		ret = 0;
 		if (sta->key) {
 			ieee80211_key_free(sta->key);
 			WARN_ON(sta->key);
-		} else
-			ret = -ENOENT;
+			ret = 0;
+		}
 
-		return ret;
+		goto out_unlock;
 	}
 
-	if (!sdata->keys[key_idx])
-		return -ENOENT;
+	if (!sdata->keys[key_idx]) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
 
 	ieee80211_key_free(sdata->keys[key_idx]);
 	WARN_ON(sdata->keys[key_idx]);
 
-	return 0;
+	ret = 0;
+ out_unlock:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
@@ -223,6 +240,8 @@ static int ieee80211_get_key(struct wiph
 	u16 iv16;
 	int err = -ENOENT;
 
+	rcu_read_lock();
+
 	if (mac_addr) {
 		sta = sta_info_get(sdata->local, mac_addr);
 		if (!sta)
@@ -286,6 +305,7 @@ static int ieee80211_get_key(struct wiph
 	err = 0;
 
  out:
+	rcu_read_unlock();
 	return err;
 }
 
@@ -295,9 +315,13 @@ static int ieee80211_config_default_key(
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	rcu_read_lock();
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ieee80211_set_default_key(sdata, key_idx);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-04-08 17:09:59.000000000 +0200
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-04-08 17:53:50.000000000 +0200
@@ -36,6 +36,7 @@ static int ieee80211_set_encryption(stru
 	struct sta_info *sta;
 	struct ieee80211_key *key;
 	struct ieee80211_sub_if_data *sdata;
+	int err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -46,23 +47,31 @@ static int ieee80211_set_encryption(stru
 	}
 
 	if (remove) {
+		rcu_read_lock();
+
+		err = 0;
+
 		if (is_broadcast_ether_addr(sta_addr)) {
 			key = sdata->keys[idx];
 		} else {
 			sta = sta_info_get(local, sta_addr);
-			if (!sta)
-				return -ENOENT;
+			if (!sta) {
+				err = -ENOENT;
+				goto out_unlock;
+			}
 			key = sta->key;
 		}
 
 		ieee80211_key_free(key);
-		return 0;
 	} else {
 		key = ieee80211_key_alloc(alg, idx, key_len, _key);
 		if (!key)
 			return -ENOMEM;
 
 		sta = NULL;
+		err = 0;
+
+		rcu_read_lock();
 
 		if (!is_broadcast_ether_addr(sta_addr)) {
 			set_tx_key = 0;
@@ -74,13 +83,15 @@ static int ieee80211_set_encryption(stru
 			 */
 			if (idx != 0 && alg != ALG_WEP) {
 				ieee80211_key_free(key);
-				return -EINVAL;
+				err = -EINVAL;
+				goto out_unlock;
 			}
 
 			sta = sta_info_get(local, sta_addr);
 			if (!sta) {
 				ieee80211_key_free(key);
-				return -ENOENT;
+				err = -ENOENT;
+				goto out_unlock;
 			}
 		}
 
@@ -90,7 +101,10 @@ static int ieee80211_set_encryption(stru
 			ieee80211_set_default_key(sdata, idx);
 	}
 
-	return 0;
+ out_unlock:
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int ieee80211_ioctl_siwgenie(struct net_device *dev,
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-04-08 17:09:55.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-04-08 17:53:49.000000000 +0200
@@ -935,11 +935,8 @@ static void ieee80211_associated(struct 
 
 	rcu_read_unlock();
 
-	if (disassoc && sta) {
-		rtnl_lock();
+	if (disassoc && sta)
 		sta_info_destroy(sta);
-		rtnl_unlock();
-	}
 
 	if (disassoc) {
 		ifsta->state = IEEE80211_DISABLED;
@@ -3097,12 +3094,8 @@ static void ieee80211_sta_expire(struct 
 		}
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 
-	synchronize_rcu();
-
-	rtnl_lock();
 	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
 		sta_info_destroy(sta);
-	rtnl_unlock();
 }
 
 
--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-08 17:09:55.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-08 17:53:48.000000000 +0200
@@ -609,8 +609,8 @@ struct ieee80211_local {
 	/*
 	 * The lock only protects the list, hash, timer and counter
 	 * against manipulation, reads are done in RCU. Additionally,
-	 * the lock protects each BSS's TIM bitmap and a few items
-	 * in a STA info structure.
+	 * the lock protects each BSS's TIM bitmap, a few items in
+	 * STA info structures and various key pointers.
 	 */
 	spinlock_t sta_lock;
 	unsigned long num_sta;
--- everything.orig/net/mac80211/sta_info.h	2008-04-08 17:06:50.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-04-08 17:53:47.000000000 +0200
@@ -359,6 +359,5 @@ void sta_info_stop(struct ieee80211_loca
 int sta_info_flush(struct ieee80211_local *local,
 		    struct ieee80211_sub_if_data *sdata);
 void sta_info_flush_delayed(struct ieee80211_sub_if_data *sdata);
-void __ieee80211_run_pending_flush(struct ieee80211_local *local);
 
 #endif /* STA_INFO_H */


