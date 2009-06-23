Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZFWS5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 14:57:00 -0400
Subject: [PATCH v3] mac80211: fix todo lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090623183126.GA3337@hash.localnet>
References: <1245751007.4184.17.camel@johannes.local>
	 <1245766038.21314.24.camel@johannes.local> <4A40F856.2010501@openwrt.org>
	 <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com>
	 <1245776114.21314.41.camel@johannes.local>
	 <20090623183126.GA3337@hash.localnet>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 20:56:47 +0200
Message-Id: <1245783408.21314.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: mac80211: fix todo lock

The key todo lock can be taken from different locks
that require it to be _bh to avoid lock inversion
due to (soft)irqs.

This should fix the two problems reported by Bob and
Gabor:
http://mid.gmane.org/20090619113049.GB18956@hash.localnet
http://mid.gmane.org/4A3FA376.8020307@openwrt.org

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Gabor Juhos <juhosg@openwrt.org>
---
 net/mac80211/key.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- wireless-testing.orig/net/mac80211/key.c	2009-06-23 11:48:12.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2009-06-23 20:56:02.000000000 +0200
@@ -67,6 +67,8 @@ static DECLARE_WORK(todo_work, key_todo)
  *
  * @key: key to add to do item for
  * @flag: todo flag(s)
+ *
+ * Must be called with IRQs or softirqs disabled.
  */
 static void add_todo(struct ieee80211_key *key, u32 flag)
 {
@@ -140,9 +142,9 @@ static void ieee80211_key_enable_hw_acce
 	ret = drv_set_key(key->local, SET_KEY, &sdata->vif, sta, &key->conf);
 
 	if (!ret) {
-		spin_lock(&todo_lock);
+		spin_lock_bh(&todo_lock);
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-		spin_unlock(&todo_lock);
+		spin_unlock_bh(&todo_lock);
 	}
 
 	if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
@@ -164,12 +166,12 @@ static void ieee80211_key_disable_hw_acc
 	if (!key || !key->local->ops->set_key)
 		return;
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		spin_unlock(&todo_lock);
+		spin_unlock_bh(&todo_lock);
 		return;
 	}
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 
 	sta = get_sta_for_key(key);
 	sdata = key->sdata;
@@ -188,9 +190,9 @@ static void ieee80211_key_disable_hw_acc
 		       wiphy_name(key->local->hw.wiphy),
 		       key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -437,14 +439,14 @@ void ieee80211_key_link(struct ieee80211
 
 	__ieee80211_key_replace(sdata, sta, old_key, key);
 
-	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
-
 	/* free old key later */
 	add_todo(old_key, KEY_FLAG_TODO_DELETE);
 
 	add_todo(key, KEY_FLAG_TODO_ADD_DEBUGFS);
 	if (netif_running(sdata->dev))
 		add_todo(key, KEY_FLAG_TODO_HWACCEL_ADD);
+
+	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
 }
 
 static void __ieee80211_key_free(struct ieee80211_key *key)
@@ -547,7 +549,7 @@ static void __ieee80211_key_todo(void)
 	 */
 	synchronize_rcu();
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	while (!list_empty(&todo_list)) {
 		key = list_first_entry(&todo_list, struct ieee80211_key, todo);
 		list_del_init(&key->todo);
@@ -558,7 +560,7 @@ static void __ieee80211_key_todo(void)
 					  KEY_FLAG_TODO_HWACCEL_REMOVE |
 					  KEY_FLAG_TODO_DELETE);
 		key->flags &= ~todoflags;
-		spin_unlock(&todo_lock);
+		spin_unlock_bh(&todo_lock);
 
 		work_done = false;
 
@@ -591,9 +593,9 @@ static void __ieee80211_key_todo(void)
 
 		WARN_ON(!work_done);
 
-		spin_lock(&todo_lock);
+		spin_lock_bh(&todo_lock);
 	}
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 }
 
 void ieee80211_key_todo(void)


