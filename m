Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbYB0MjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 07:39:15 -0500
Subject: [PATCH] mac80211: fix key replacing, hw accel
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 13:39:00 +0100
Message-Id: <1204115940.6309.2.camel@johannes.berg> (sfid-20080227_123925_567845_3A49F179)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though I thought about it a lot and had also tested it, some
of my recent changes in the key code broke replacing keys, making
the kernel oops because a key is removed from a list while not on
it.

This patch fixes that using the list as an indication whether or
not the key is on it (an empty list means it's not on any list.)

Also, this patch fixes hw accel enabling, the check for not doing
hw accel when the interface is down was lost and is restored by
this.

Additionally, move adding the key to the list into the function
__ieee80211_key_replace() for more consistency.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/key.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- everything.orig/net/mac80211/key.c	2008-02-27 13:16:02.000000000 +0100
+++ everything/net/mac80211/key.c	2008-02-27 13:31:23.000000000 +0100
@@ -150,6 +150,7 @@ struct ieee80211_key *ieee80211_key_allo
 	key->conf.keyidx = idx;
 	key->conf.keylen = key_len;
 	memcpy(key->conf.key, key_data, key_len);
+	INIT_LIST_HEAD(&key->list);
 
 	if (alg == ALG_CCMP) {
 		/*
@@ -189,6 +190,8 @@ static void __ieee80211_key_replace(stru
 			ieee80211_set_default_key(sdata, -1);
 
 		rcu_assign_pointer(sdata->keys[idx], new);
+		if (new)
+			list_add(&new->list, &sdata->key_list);
 
 		if (defkey && new)
 			ieee80211_set_default_key(sdata, new->conf.keyidx);
@@ -196,7 +199,11 @@ static void __ieee80211_key_replace(stru
 
 	if (key) {
 		ieee80211_key_mark_hw_accel_off(key);
-		list_del(&key->list);
+		/*
+		 * We'll use an empty list to indicate that the key
+		 * has already been removed.
+		 */
+		list_del_init(&key->list);
 	}
 }
 
@@ -254,12 +261,13 @@ void ieee80211_key_link(struct ieee80211
 
 	__ieee80211_key_replace(sdata, sta, old_key, key);
 
-	list_add(&key->list, &sdata->key_list);
-
-	synchronize_rcu();
+	if (old_key) {
+		synchronize_rcu();
+		ieee80211_key_free(old_key);
+	}
 
-	ieee80211_key_free(old_key);
-	ieee80211_key_enable_hw_accel(key);
+	if (netif_running(sdata->dev))
+		ieee80211_key_enable_hw_accel(key);
 }
 
 void ieee80211_key_free(struct ieee80211_key *key)
@@ -277,8 +285,13 @@ void ieee80211_key_free(struct ieee80211
 		 * Because other code may have key reference (RCU protected)
 		 * right now, we then wait for a grace period before freeing
 		 * it.
+		 * An empty list indicates it was never added to the key list
+		 * or has been removed already. It may, however, still be in
+		 * hardware for acceleration.
 		 */
-		__ieee80211_key_replace(key->sdata, key->sta, key, NULL);
+		if (!list_empty(&key->list))
+			__ieee80211_key_replace(key->sdata, key->sta,
+						key, NULL);
 
 		/*
 		 * Do NOT remove this without looking at sta_info_destroy()


