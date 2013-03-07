Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3CGK1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:27:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: batch key free synchronize_net()
Date: Thu,  7 Mar 2013 11:27:47 +0100
Message-Id: <1362652067-14903-3-git-send-email-johannes@sipsolutions.net> (sfid-20130307_112756_625579_02BAA0CA)
In-Reply-To: <1362652067-14903-1-git-send-email-johannes@sipsolutions.net>
References: <1362652067-14903-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of calling synchronize_net() for every key
on an interface or when a station is removed, do it
only once for all keys in both of these cases.

As a side-effect, removing station keys now always
calls synchronize_net() even if there are no keys,
which fixes an issue with station removal happening
in the driver while the station could still be used
for TX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c      | 77 ++++++++++++++++++++++++++++++++++++++++---------
 net/mac80211/key.h      |  2 ++
 net/mac80211/sta_info.c | 12 ++------
 3 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 953887b..989f773 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -406,18 +406,9 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	kfree(key);
 }
 
-static void ieee80211_key_destroy(struct ieee80211_key *key,
-				  bool delay_tailroom)
+static void __ieee80211_key_destroy(struct ieee80211_key *key,
+				    bool delay_tailroom)
 {
-	if (!key)
-		return;
-
-	/*
-	 * Synchronize so the TX path can no longer be using
-	 * this key before we free/remove it.
-	 */
-	synchronize_net();
-
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 
@@ -439,6 +430,21 @@ static void ieee80211_key_destroy(struct ieee80211_key *key,
 	ieee80211_key_free_common(key);
 }
 
+static void ieee80211_key_destroy(struct ieee80211_key *key,
+				  bool delay_tailroom)
+{
+	if (!key)
+		return;
+
+	/*
+	 * Synchronize so the TX path can no longer be using
+	 * this key before we free/remove it.
+	 */
+	synchronize_net();
+
+	__ieee80211_key_destroy(key, delay_tailroom);
+}
+
 void ieee80211_key_free_unused(struct ieee80211_key *key)
 {
 	WARN_ON(key->sdata || key->local);
@@ -560,6 +566,7 @@ EXPORT_SYMBOL(ieee80211_iter_keys);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
+	LIST_HEAD(keys);
 
 	cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
 
@@ -571,17 +578,61 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
-	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
-		ieee80211_key_free(key, false);
+	list_for_each_entry_safe(key, tmp, &sdata->key_list, list) {
+		ieee80211_key_replace(key->sdata, key->sta,
+				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
+				key, NULL);
+		list_add_tail(&key->list, &keys);
+	}
 
 	ieee80211_debugfs_key_update_default(sdata);
 
+	synchronize_net();
+	list_for_each_entry_safe(key, tmp, &keys, list)
+		__ieee80211_key_destroy(key, false);
+
 	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
 		     sdata->crypto_tx_tailroom_pending_dec);
 
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
+void ieee80211_free_sta_keys(struct ieee80211_local *local,
+			     struct sta_info *sta)
+{
+	struct ieee80211_key *key, *tmp;
+	LIST_HEAD(keys);
+	int i;
+
+	mutex_lock(&local->key_mtx);
+	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+		key = key_mtx_dereference(local, sta->gtk[i]);
+		ieee80211_key_replace(key->sdata, key->sta,
+				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
+				key, NULL);
+		list_add(&key->list, &keys);
+	}
+
+	key = key_mtx_dereference(local, sta->ptk);
+	if (key) {
+		ieee80211_key_replace(key->sdata, key->sta,
+				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
+				key, NULL);
+		list_add(&key->list, &keys);
+	}
+
+	/*
+	 * NB: the station code relies on this being
+	 * done even if there aren't any keys
+	 */
+	synchronize_net();
+
+	list_for_each_entry_safe(key, tmp, &keys, list)
+		__ieee80211_key_destroy(key, true);
+
+	mutex_unlock(&local->key_mtx);
+}
+
 void ieee80211_delayed_tailroom_dec(struct work_struct *wk)
 {
 	struct ieee80211_sub_if_data *sdata;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index a353ddd6..e8de3e6 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -141,6 +141,8 @@ void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
+void ieee80211_free_sta_keys(struct ieee80211_local *local,
+			     struct sta_info *sta);
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
 
 #define key_mtx_dereference(local, ref) \
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2961f3d..11216bc 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -783,7 +783,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	int ret, i;
+	int ret;
 
 	might_sleep();
 
@@ -810,14 +810,8 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	list_del_rcu(&sta->list);
 
-	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-		ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]),
-				   true);
-	if (sta->ptk)
-		ieee80211_key_free(key_mtx_dereference(local, sta->ptk),
-				   true);
-	mutex_unlock(&local->key_mtx);
+	/* this always calls synchronize_net() */
+	ieee80211_free_sta_keys(local, sta);
 
 	sta->dead = true;
 
-- 
1.8.0

