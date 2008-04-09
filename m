Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYDIOp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 10:45:57 -0400
Subject: [PATCH v2] mac80211: fix key hwaccel race
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200804091639.24321.IvDoorn@gmail.com> (sfid-20080409_153547_539824_75C658CB)
References: <1207689103.7442.1.camel@johannes.berg>
	 <200804091639.24321.IvDoorn@gmail.com>
	 (sfid-20080409_153547_539824_75C658CB)
Content-Type: text/plain
Date: Wed, 09 Apr 2008 16:45:37 +0200
Message-Id: <1207752337.7442.29.camel@johannes.berg> (sfid-20080409_154603_226260_5D1D05EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous key locking patch left a small race: it would be possible
to add a key and take the interface down before the key todo is run so
that hwaccel for that key is enabled on an interface that is down. Avoid
this by running the todo list when an interface is brought up or down.

This patch also fixes a small bug: before this change, a few functions
used the key list without the lock that protects it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix duplicate BIT(2) pointed out by Ivo, thanks. Also updated for
file renames.

 net/mac80211/key.c |   84 ++++++++++++++++++++++++++++++++---------------------
 net/mac80211/key.h |   11 ++++--
 2 files changed, 59 insertions(+), 36 deletions(-)

--- everything.orig/net/mac80211/key.c	2008-04-09 16:21:59.000000000 +0200
+++ everything/net/mac80211/key.c	2008-04-09 16:38:32.000000000 +0200
@@ -355,61 +355,74 @@ void ieee80211_key_link(struct ieee80211
 
 	add_todo(key, KEY_FLAG_TODO_ADD_DEBUGFS);
 	if (netif_running(sdata->dev))
-		add_todo(key, KEY_FLAG_TODO_HWACCEL);
+		add_todo(key, KEY_FLAG_TODO_HWACCEL_ADD);
 }
 
-void ieee80211_key_free(struct ieee80211_key *key)
+static void __ieee80211_key_free(struct ieee80211_key *key)
 {
-	unsigned long flags;
-
-	if (!key)
-		return;
-
 	/*
 	 * Replace key with nothingness if it was ever used.
 	 */
-	if (key->sdata) {
-		spin_lock_irqsave(&key->sdata->local->sta_lock, flags);
+	if (key->sdata)
 		__ieee80211_key_replace(key->sdata, key->sta,
 					key, NULL);
-		spin_unlock_irqrestore(&key->sdata->local->sta_lock, flags);
-	}
 
 	add_todo(key, KEY_FLAG_TODO_DELETE);
 }
 
-void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
+void ieee80211_key_free(struct ieee80211_key *key)
 {
-	struct ieee80211_key *key;
-
-	might_sleep();
+	unsigned long flags;
 
-	if (WARN_ON(!netif_running(sdata->dev)))
+	if (!key)
 		return;
 
-	ieee80211_key_lock();
+	spin_lock_irqsave(&key->sdata->local->sta_lock, flags);
+	__ieee80211_key_free(key);
+	spin_unlock_irqrestore(&key->sdata->local->sta_lock, flags);
+}
 
+/*
+ * To be safe against concurrent manipulations of the list (which shouldn't
+ * actually happen) we need to hold the spinlock. But under the spinlock we
+ * can't actually do much, so we defer processing to the todo list. Then run
+ * the todo list to be sure the operation and possibly previously pending
+ * operations are completed.
+ */
+static void ieee80211_todo_for_each_key(struct ieee80211_sub_if_data *sdata,
+					u32 todo_flags)
+{
+	struct ieee80211_key *key;
+	unsigned long flags;
+
+	might_sleep();
+
+	spin_lock_irqsave(&sdata->local->sta_lock, flags);
 	list_for_each_entry(key, &sdata->key_list, list)
-		ieee80211_key_enable_hw_accel(key);
+		add_todo(key, todo_flags);
+	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
 
-	ieee80211_key_unlock();
+	ieee80211_key_todo();
 }
 
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
+void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_key *key;
+	ASSERT_RTNL();
 
-	might_sleep();
+	if (WARN_ON(!netif_running(sdata->dev)))
+		return;
 
-	ieee80211_key_lock();
+	ieee80211_todo_for_each_key(sdata, KEY_FLAG_TODO_HWACCEL_ADD);
+}
 
-	list_for_each_entry(key, &sdata->key_list, list)
-		ieee80211_key_disable_hw_accel(key);
+void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
+{
+	ASSERT_RTNL();
 
-	ieee80211_key_unlock();
+	ieee80211_todo_for_each_key(sdata, KEY_FLAG_TODO_HWACCEL_REMOVE);
 }
 
-static void __ieee80211_key_free(struct ieee80211_key *key)
+static void __ieee80211_key_destroy(struct ieee80211_key *key)
 {
 	if (!key)
 		return;
@@ -440,7 +453,8 @@ static void __ieee80211_key_todo(void)
 		list_del_init(&key->todo);
 		todoflags = key->flags & (KEY_FLAG_TODO_ADD_DEBUGFS |
 					  KEY_FLAG_TODO_DEFKEY |
-					  KEY_FLAG_TODO_HWACCEL |
+					  KEY_FLAG_TODO_HWACCEL_ADD |
+					  KEY_FLAG_TODO_HWACCEL_REMOVE |
 					  KEY_FLAG_TODO_DELETE);
 		key->flags &= ~todoflags;
 		spin_unlock(&todo_lock);
@@ -456,12 +470,16 @@ static void __ieee80211_key_todo(void)
 			ieee80211_debugfs_key_add_default(key->sdata);
 			work_done = true;
 		}
-		if (todoflags & KEY_FLAG_TODO_HWACCEL) {
+		if (todoflags & KEY_FLAG_TODO_HWACCEL_ADD) {
 			ieee80211_key_enable_hw_accel(key);
 			work_done = true;
 		}
+		if (todoflags & KEY_FLAG_TODO_HWACCEL_REMOVE) {
+			ieee80211_key_disable_hw_accel(key);
+			work_done = true;
+		}
 		if (todoflags & KEY_FLAG_TODO_DELETE) {
-			__ieee80211_key_free(key);
+			__ieee80211_key_destroy(key);
 			work_done = true;
 		}
 
@@ -482,14 +500,16 @@ void ieee80211_key_todo(void)
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
-	LIST_HEAD(tmp_list);
+	unsigned long flags;
 
 	ieee80211_key_lock();
 
 	ieee80211_debugfs_key_remove_default(sdata);
 
+	spin_lock_irqsave(&sdata->local->sta_lock, flags);
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
-		ieee80211_key_free(key);
+		__ieee80211_key_free(key);
+	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
 
 	__ieee80211_key_todo();
 
--- everything.orig/net/mac80211/key.h	2008-04-09 16:21:59.000000000 +0200
+++ everything/net/mac80211/key.h	2008-04-09 16:38:53.000000000 +0200
@@ -54,16 +54,19 @@ struct sta_info;
  * @KEY_FLAG_TODO_DELETE: Key is marked for deletion and will, after an
  *	RCU grace period, no longer be reachable other than from the
  *	todo list.
- * @KEY_FLAG_TODO_HWACCEL: Key needs to be added to hardware acceleration.
+ * @KEY_FLAG_TODO_HWACCEL_ADD: Key needs to be added to hardware acceleration.
+ * @KEY_FLAG_TODO_HWACCEL_REMOVE: Key needs to be removed from hardware
+ *	acceleration.
  * @KEY_FLAG_TODO_DEFKEY: Key is default key and debugfs needs to be updated.
  * @KEY_FLAG_TODO_ADD_DEBUGFS: Key needs to be added to debugfs.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TODO_DELETE		= BIT(1),
-	KEY_FLAG_TODO_HWACCEL		= BIT(2),
-	KEY_FLAG_TODO_DEFKEY		= BIT(3),
-	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(4),
+	KEY_FLAG_TODO_HWACCEL_ADD	= BIT(2),
+	KEY_FLAG_TODO_HWACCEL_REMOVE	= BIT(3),
+	KEY_FLAG_TODO_DEFKEY		= BIT(4),
+	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(5),
 };
 
 struct ieee80211_key {


