Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1ELMbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 08:31:51 -0400
Subject: [PATCH] mac80211: make key locking clearer
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 14:31:49 +0200
Message-ID: <1305203509.3461.25.camel@jlt3.sipsolutions.net> (sfid-20110512_143154_411900_453612B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code in ieee80211_del_key() doesn't acquire the
key_mtx properly when it dereferences the keys. It
turns out that isn't actually necessary since the
key_mtx itself seems to be redundant since all key
manipulations are done under the RTNL, but as long
as we have the key_mtx we should use it the right
way too.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |   38 +++++++++++++++-----------------------
 net/mac80211/key.c |    8 ++++----
 net/mac80211/key.h |    1 +
 3 files changed, 20 insertions(+), 27 deletions(-)

--- a/net/mac80211/cfg.c	2011-05-12 14:07:12.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-05-12 14:22:01.000000000 +0200
@@ -157,13 +157,14 @@ static int ieee80211_add_key(struct wiph
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	struct ieee80211_key *key = NULL;
 	int ret;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	mutex_lock(&sdata->local->sta_mtx);
+	mutex_lock(&local->sta_mtx);
+	mutex_lock(&local->key_mtx);
 
 	if (mac_addr) {
 		ret = -ENOENT;
@@ -172,33 +173,24 @@ static int ieee80211_del_key(struct wiph
 		if (!sta)
 			goto out_unlock;
 
-		if (pairwise) {
-			if (sta->ptk) {
-				ieee80211_key_free(sdata->local, sta->ptk);
-				ret = 0;
-			}
-		} else {
-			if (sta->gtk[key_idx]) {
-				ieee80211_key_free(sdata->local,
-						   sta->gtk[key_idx]);
-				ret = 0;
-			}
-		}
-
-		goto out_unlock;
-	}
+		if (pairwise)
+			key = sta->ptk;
+		else
+			key = sta->gtk[key_idx];
+	} else
+		key = sdata->keys[key_idx];
 
-	if (!sdata->keys[key_idx]) {
+	if (!key) {
 		ret = -ENOENT;
 		goto out_unlock;
 	}
 
-	ieee80211_key_free(sdata->local, sdata->keys[key_idx]);
-	WARN_ON(sdata->keys[key_idx]);
+	__ieee80211_key_free(key);
 
 	ret = 0;
  out_unlock:
-	mutex_unlock(&sdata->local->sta_mtx);
+	mutex_unlock(&local->key_mtx);
+	mutex_unlock(&local->sta_mtx);
 
 	return ret;
 }
--- a/net/mac80211/key.c	2011-05-12 14:07:12.000000000 +0200
+++ b/net/mac80211/key.c	2011-05-12 14:22:01.000000000 +0200
@@ -471,8 +471,11 @@ int ieee80211_key_link(struct ieee80211_
 	return ret;
 }
 
-static void __ieee80211_key_free(struct ieee80211_key *key)
+void __ieee80211_key_free(struct ieee80211_key *key)
 {
+	if (!key)
+		return;
+
 	/*
 	 * Replace key with nothingness if it was ever used.
 	 */
@@ -486,9 +489,6 @@ static void __ieee80211_key_free(struct
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key)
 {
-	if (!key)
-		return;
-
 	mutex_lock(&local->key_mtx);
 	__ieee80211_key_free(key);
 	mutex_unlock(&local->key_mtx);
--- a/net/mac80211/key.h	2011-05-12 14:07:12.000000000 +0200
+++ b/net/mac80211/key.h	2011-05-12 14:07:15.000000000 +0200
@@ -135,6 +135,7 @@ struct ieee80211_key *ieee80211_key_allo
 int __must_check ieee80211_key_link(struct ieee80211_key *key,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
+void __ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,


