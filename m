Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbYDKTku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 15:40:50 -0400
Subject: [PATCH] mac80211: fix spinlock recursion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 21:40:35 +0200
Message-Id: <1207942835.13354.74.camel@johannes.berg> (sfid-20080411_204055_527320_51C13EE9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When STAs are expired, we need to hold the sta_lock. Using
the same lock for keys too would then mean we'd need another
key free function, and that'll just lead to confusion, so just
use a new spinlock for all key lists.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   10 ++++++++--
 net/mac80211/key.c         |   20 ++++++++++----------
 net/mac80211/main.c        |    2 ++
 3 files changed, 20 insertions(+), 12 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-11 21:22:34.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-11 21:31:33.000000000 +0200
@@ -600,8 +600,7 @@ struct ieee80211_local {
 	/*
 	 * The lock only protects the list, hash, timer and counter
 	 * against manipulation, reads are done in RCU. Additionally,
-	 * the lock protects each BSS's TIM bitmap, a few items in
-	 * STA info structures and various key pointers.
+	 * the lock protects each BSS's TIM bitmap.
 	 */
 	spinlock_t sta_lock;
 	unsigned long num_sta;
@@ -635,6 +634,13 @@ struct ieee80211_local {
 
 	struct list_head interfaces;
 
+	/*
+	 * Key lock, protects sdata's key_list and sta_info's
+	 * key pointers (write access, they're RCU.)
+	 */
+	spinlock_t key_lock;
+
+
 	bool sta_sw_scanning;
 	bool sta_hw_scanning;
 	int scan_channel_idx;
--- everything.orig/net/mac80211/key.c	2008-04-11 21:32:27.000000000 +0200
+++ everything/net/mac80211/key.c	2008-04-11 21:32:31.000000000 +0200
@@ -210,9 +210,9 @@ void ieee80211_set_default_key(struct ie
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sdata->local->sta_lock, flags);
+	spin_lock_irqsave(&sdata->local->key_lock, flags);
 	__ieee80211_set_default_key(sdata, idx);
-	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
+	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
 }
 
 
@@ -339,7 +339,7 @@ void ieee80211_key_link(struct ieee80211
 		}
 	}
 
-	spin_lock_irqsave(&sdata->local->sta_lock, flags);
+	spin_lock_irqsave(&sdata->local->key_lock, flags);
 
 	if (sta)
 		old_key = sta->key;
@@ -348,7 +348,7 @@ void ieee80211_key_link(struct ieee80211
 
 	__ieee80211_key_replace(sdata, sta, old_key, key);
 
-	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
+	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
 
 	/* free old key later */
 	add_todo(old_key, KEY_FLAG_TODO_DELETE);
@@ -377,9 +377,9 @@ void ieee80211_key_free(struct ieee80211
 	if (!key)
 		return;
 
-	spin_lock_irqsave(&key->sdata->local->sta_lock, flags);
+	spin_lock_irqsave(&key->sdata->local->key_lock, flags);
 	__ieee80211_key_free(key);
-	spin_unlock_irqrestore(&key->sdata->local->sta_lock, flags);
+	spin_unlock_irqrestore(&key->sdata->local->key_lock, flags);
 }
 
 /*
@@ -397,10 +397,10 @@ static void ieee80211_todo_for_each_key(
 
 	might_sleep();
 
-	spin_lock_irqsave(&sdata->local->sta_lock, flags);
+	spin_lock_irqsave(&sdata->local->key_lock, flags);
 	list_for_each_entry(key, &sdata->key_list, list)
 		add_todo(key, todo_flags);
-	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
+	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
 
 	ieee80211_key_todo();
 }
@@ -506,10 +506,10 @@ void ieee80211_free_keys(struct ieee8021
 
 	ieee80211_debugfs_key_remove_default(sdata);
 
-	spin_lock_irqsave(&sdata->local->sta_lock, flags);
+	spin_lock_irqsave(&sdata->local->key_lock, flags);
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 		__ieee80211_key_free(key);
-	spin_unlock_irqrestore(&sdata->local->sta_lock, flags);
+	spin_unlock_irqrestore(&sdata->local->key_lock, flags);
 
 	__ieee80211_key_todo();
 
--- everything.orig/net/mac80211/main.c	2008-04-11 21:30:19.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-11 21:32:20.000000000 +0200
@@ -1587,6 +1587,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	INIT_LIST_HEAD(&local->interfaces);
 
+	spin_lock_init(&local->key_lock);
+
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
 
 	sta_info_init(local);


