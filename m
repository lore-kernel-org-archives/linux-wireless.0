Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3CGK1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:27:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: remove underscores from some key functions
Date: Thu,  7 Mar 2013 11:27:46 +0100
Message-Id: <1362652067-14903-2-git-send-email-johannes@sipsolutions.net> (sfid-20130307_112757_508954_F76708AF)
In-Reply-To: <1362652067-14903-1-git-send-email-johannes@sipsolutions.net>
References: <1362652067-14903-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some key function don't exist without underscores, so
remove the underscores from those.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      |  2 +-
 net/mac80211/key.c      | 28 ++++++++++++++--------------
 net/mac80211/key.h      |  2 +-
 net/mac80211/sta_info.c |  8 ++++----
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2d4bf2..e5c1441 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -252,7 +252,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		goto out_unlock;
 	}
 
-	__ieee80211_key_free(key, true);
+	ieee80211_key_free(key, true);
 
 	ret = 0;
  out_unlock:
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d86be64..953887b 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -248,11 +248,11 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 }
 
 
-static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
-				    struct sta_info *sta,
-				    bool pairwise,
-				    struct ieee80211_key *old,
-				    struct ieee80211_key *new)
+static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+				  struct sta_info *sta,
+				  bool pairwise,
+				  struct ieee80211_key *old,
+				  struct ieee80211_key *new)
 {
 	int idx;
 	bool defunikey, defmultikey, defmgmtkey;
@@ -406,8 +406,8 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 	kfree(key);
 }
 
-static void __ieee80211_key_destroy(struct ieee80211_key *key,
-				    bool delay_tailroom)
+static void ieee80211_key_destroy(struct ieee80211_key *key,
+				  bool delay_tailroom)
 {
 	if (!key)
 		return;
@@ -473,22 +473,22 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
-	__ieee80211_key_destroy(old_key, true);
+	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
+	ieee80211_key_destroy(old_key, true);
 
 	ieee80211_debugfs_key_add(key);
 
 	ret = ieee80211_key_enable_hw_accel(key);
 
 	if (ret)
-		__ieee80211_key_free(key, true);
+		ieee80211_key_free(key, true);
 
 	mutex_unlock(&sdata->local->key_mtx);
 
 	return ret;
 }
 
-void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
+void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 {
 	if (!key)
 		return;
@@ -497,10 +497,10 @@ void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 	 * Replace key with nothingness if it was ever used.
 	 */
 	if (key->sdata)
-		__ieee80211_key_replace(key->sdata, key->sta,
+		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-	__ieee80211_key_destroy(key, delay_tailroom);
+	ieee80211_key_destroy(key, delay_tailroom);
 }
 
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
@@ -572,7 +572,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
-		__ieee80211_key_free(key, false);
+		ieee80211_key_free(key, false);
 
 	ieee80211_debugfs_key_update_default(sdata);
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 8ef56cd..a353ddd6 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -134,7 +134,7 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta);
-void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
+void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
 void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a36ceed..2961f3d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -812,11 +812,11 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]),
-				     true);
+		ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]),
+				   true);
 	if (sta->ptk)
-		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk),
-				     true);
+		ieee80211_key_free(key_mtx_dereference(local, sta->ptk),
+				   true);
 	mutex_unlock(&local->key_mtx);
 
 	sta->dead = true;
-- 
1.8.0

