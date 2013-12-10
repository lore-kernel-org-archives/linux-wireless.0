Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:13807 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3LJQkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 11:40:49 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 2/2] mac80211: Use RCU to handle local->key_list
Date: Tue, 10 Dec 2013 17:39:58 +0100
Message-Id: <1386693598-3934-2-git-send-email-antonio@meshcoding.com> (sfid-20131210_174105_669263_54D0C52A)
In-Reply-To: <1386693598-3934-1-git-send-email-antonio@meshcoding.com>
References: <1386693598-3934-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

By using RCU it is now possible to iterate over the key list
without holding lock (other than rcu_read).

This allows to simplify ieee80211_iter_keys() so that it can
now run without holding any lock (other than rcu_read)

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/key.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 04c885a..e2a1e3c 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -261,7 +261,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	bool defunikey, defmultikey, defmgmtkey;
 
 	if (new)
-		list_add_tail(&new->list, &sdata->key_list);
+		list_add_tail_rcu(&new->list, &sdata->key_list);
 
 	if (sta && pairwise) {
 		rcu_assign_pointer(sta->ptk, new);
@@ -309,7 +309,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (old)
-		list_del(&old->list);
+		list_del_rcu(&old->list);
 }
 
 struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
@@ -537,6 +537,10 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
+/*
+ * This function is supposed to be used for reading operations only.
+ * Iterations over the key list are performed with RCU_read lock only
+ */
 void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 void (*iter)(struct ieee80211_hw *hw,
@@ -547,27 +551,24 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 void *iter_data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_key *key, *tmp;
 	struct ieee80211_sub_if_data *sdata;
 
 	mutex_lock(&local->key_mtx);
+	rcu_read_lock();
 	if (vif) {
 		sdata = vif_to_sdata(vif);
-		list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
+		list_for_each_entry(key, &sdata->key_list, list)
 			iter(hw, &sdata->vif,
 			     key->sta ? &key->sta->sta : NULL,
 			     &key->conf, iter_data);
 	} else {
-		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list)
-			list_for_each_entry_safe(key, tmp,
-						 &sdata->key_list, list)
+			list_for_each_entry_rcu(key, &sdata->key_list, list)
 				iter(hw, &sdata->vif,
 				     key->sta ? &key->sta->sta : NULL,
 				     &key->conf, iter_data);
-		rcu_read_unlock();
 	}
-	mutex_unlock(&local->key_mtx);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_iter_keys);
 
-- 
1.8.5.1

