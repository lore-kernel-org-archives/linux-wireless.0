Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZFWJ5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 05:57:08 -0400
Subject: [PATCH] mac80211: fix todo lock
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 11:56:47 +0200
Message-Id: <1245751007.4184.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 net/mac80211/key.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/key.c	2009-06-23 11:22:42.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2009-06-23 11:36:17.000000000 +0200
@@ -73,7 +73,7 @@ static void add_todo(struct ieee80211_ke
 	if (!key)
 		return;
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	key->flags |= flag;
 	/*
 	 * Remove again if already on the list so that we move it to the end.
@@ -82,7 +82,7 @@ static void add_todo(struct ieee80211_ke
 		list_del(&key->todo);
 	list_add_tail(&key->todo, &todo_list);
 	schedule_work(&todo_work);
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 }
 
 /**
@@ -140,9 +140,9 @@ static void ieee80211_key_enable_hw_acce
 	ret = drv_set_key(key->local, SET_KEY, &sdata->vif, sta, &key->conf);
 
 	if (!ret) {
-		spin_lock(&todo_lock);
+		spin_lock_bh(&todo_lock);
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-		spin_unlock(&todo_lock);
+		spin_unlock_bh(&todo_lock);
 	}
 
 	if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
@@ -164,12 +164,12 @@ static void ieee80211_key_disable_hw_acc
 	if (!key || !key->local->ops->set_key)
 		return;
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		spin_unlock(&todo_lock);
 		return;
 	}
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 
 	sta = get_sta_for_key(key);
 	sdata = key->sdata;
@@ -188,9 +188,9 @@ static void ieee80211_key_disable_hw_acc
 		       wiphy_name(key->local->hw.wiphy),
 		       key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -547,7 +547,7 @@ static void __ieee80211_key_todo(void)
 	 */
 	synchronize_rcu();
 
-	spin_lock(&todo_lock);
+	spin_lock_bh(&todo_lock);
 	while (!list_empty(&todo_list)) {
 		key = list_first_entry(&todo_list, struct ieee80211_key, todo);
 		list_del_init(&key->todo);
@@ -558,7 +558,7 @@ static void __ieee80211_key_todo(void)
 					  KEY_FLAG_TODO_HWACCEL_REMOVE |
 					  KEY_FLAG_TODO_DELETE);
 		key->flags &= ~todoflags;
-		spin_unlock(&todo_lock);
+		spin_unlock_bh(&todo_lock);
 
 		work_done = false;
 
@@ -591,9 +591,9 @@ static void __ieee80211_key_todo(void)
 
 		WARN_ON(!work_done);
 
-		spin_lock(&todo_lock);
+		spin_lock_bh(&todo_lock);
 	}
-	spin_unlock(&todo_lock);
+	spin_unlock_bh(&todo_lock);
 }
 
 void ieee80211_key_todo(void)


