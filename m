Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/8] mac80211: move synchronize_net() before sta key removal
Date: Thu,  5 Dec 2013 13:35:53 +0100
Message-Id: <1386246956-14257-6-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133611_739449_5C4629FC)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to do this inside the sta key removal
since the keys can only be reached through the sta (and
not by the driver at all) so once the sta can no longer
be reached, the keys are safe.

This will allow further optimisation opportunities with
multiple stations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c      | 16 +++-------------
 net/mac80211/sta_info.c |  3 ++-
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e568d98..12e6154 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -628,8 +628,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
-	struct ieee80211_key *key, *tmp;
-	LIST_HEAD(keys);
+	struct ieee80211_key *key;
 	int i;
 
 	mutex_lock(&local->key_mtx);
@@ -640,7 +639,7 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-		list_add(&key->list, &keys);
+		__ieee80211_key_destroy(key, true);
 	}
 
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
@@ -650,17 +649,8 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-		list_add(&key->list, &keys);
-	}
-
-	/*
-	 * NB: the station code relies on this being
-	 * done even if there aren't any keys
-	 */
-	synchronize_net();
-
-	list_for_each_entry_safe(key, tmp, &keys, list)
 		__ieee80211_key_destroy(key, true);
+	}
 
 	mutex_unlock(&local->key_mtx);
 }
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7241f322..08e5076 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -831,7 +831,8 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
-	/* this always calls synchronize_net() */
+	synchronize_net();
+	/* now keys can no longer be reached */
 	ieee80211_free_sta_keys(local, sta);
 
 	sta->dead = true;
-- 
1.8.4.rc3

