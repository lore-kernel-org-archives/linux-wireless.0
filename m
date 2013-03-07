Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3CGK1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:27:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: clean up key freeing a bit
Date: Thu,  7 Mar 2013 11:27:45 +0100
Message-Id: <1362652067-14903-1-git-send-email-johannes@sipsolutions.net> (sfid-20130307_112754_901060_C0007A11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a key is allocated but not really added, there's no
need to go through the entire teardown process. Also, if
adding a key fails, ieee80211_key_link() can take care of
freeing it instead of the (only) caller.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |  4 +---
 net/mac80211/key.c | 32 +++++++++++++++++++-------------
 net/mac80211/key.h | 11 +++++------
 3 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 61fc911..c2d4bf2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -175,7 +175,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		 *       add it to the device after the station.
 		 */
 		if (!sta || !test_sta_flag(sta, WLAN_STA_ASSOC)) {
-			ieee80211_key_free(sdata->local, key);
+			ieee80211_key_free_unused(key);
 			err = -ENOENT;
 			goto out_unlock;
 		}
@@ -214,8 +214,6 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	err = ieee80211_key_link(key, sdata, sta);
-	if (err)
-		ieee80211_key_free(sdata->local, key);
 
  out_unlock:
 	mutex_unlock(&sdata->local->sta_mtx);
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 99e9f6a..d86be64 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -397,6 +397,15 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 	return key;
 }
 
+static void ieee80211_key_free_common(struct ieee80211_key *key)
+{
+	if (key->conf.cipher == WLAN_CIPHER_SUITE_CCMP)
+		ieee80211_aes_key_free(key->u.ccmp.tfm);
+	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
+		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
+	kfree(key);
+}
+
 static void __ieee80211_key_destroy(struct ieee80211_key *key,
 				    bool delay_tailroom)
 {
@@ -412,10 +421,6 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 	if (key->local)
 		ieee80211_key_disable_hw_accel(key);
 
-	if (key->conf.cipher == WLAN_CIPHER_SUITE_CCMP)
-		ieee80211_aes_key_free(key->u.ccmp.tfm);
-	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
-		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
 	if (key->local) {
 		struct ieee80211_sub_if_data *sdata = key->sdata;
 
@@ -431,7 +436,13 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 		}
 	}
 
-	kfree(key);
+	ieee80211_key_free_common(key);
+}
+
+void ieee80211_key_free_unused(struct ieee80211_key *key)
+{
+	WARN_ON(key->sdata || key->local);
+	ieee80211_key_free_common(key);
 }
 
 int ieee80211_key_link(struct ieee80211_key *key,
@@ -469,6 +480,9 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	ret = ieee80211_key_enable_hw_accel(key);
 
+	if (ret)
+		__ieee80211_key_free(key, true);
+
 	mutex_unlock(&sdata->local->key_mtx);
 
 	return ret;
@@ -489,14 +503,6 @@ void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 	__ieee80211_key_destroy(key, delay_tailroom);
 }
 
-void ieee80211_key_free(struct ieee80211_local *local,
-			struct ieee80211_key *key)
-{
-	mutex_lock(&local->key_mtx);
-	__ieee80211_key_free(key, true);
-	mutex_unlock(&local->key_mtx);
-}
-
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 2a682d8..8ef56cd 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -129,14 +129,13 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 					  size_t seq_len, const u8 *seq);
 /*
  * Insert a key into data structures (sdata, sta if necessary)
- * to make it used, free old key.
+ * to make it used, free old key. On failure, also free the new key.
  */
-int __must_check ieee80211_key_link(struct ieee80211_key *key,
-				    struct ieee80211_sub_if_data *sdata,
-				    struct sta_info *sta);
+int ieee80211_key_link(struct ieee80211_key *key,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct sta_info *sta);
 void __ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
-void ieee80211_key_free(struct ieee80211_local *local,
-			struct ieee80211_key *key);
+void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi);
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
-- 
1.8.0

