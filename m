Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab0LISwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 13:52:12 -0500
Message-Id: <20101209185002.961488119@sipsolutions.net>
Date: Thu, 09 Dec 2010 19:49:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: support separate default keys
References: <20101209184859.155955840@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for split default keys (unicast
and multicast) in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/debugfs_key.c |   37 +++++++++++++++++++++----------------
 net/mac80211/debugfs_key.h |    8 ++------
 net/mac80211/ieee80211_i.h |    5 +++--
 net/mac80211/key.c         |   45 ++++++++++++++++++++++++++-------------------
 net/mac80211/key.h         |    3 ++-
 net/mac80211/main.c        |    3 ++-
 net/mac80211/tx.c          |    6 +++++-
 8 files changed, 62 insertions(+), 47 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-12-07 22:42:52.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-12-07 22:43:04.000000000 +0100
@@ -558,7 +558,7 @@ struct ieee80211_sub_if_data {
 	unsigned int fragment_next;
 
 	struct ieee80211_key *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
-	struct ieee80211_key *default_key;
+	struct ieee80211_key *default_unicast_key, *default_multicast_key;
 	struct ieee80211_key *default_mgmt_key;
 
 	u16 sequence_number;
@@ -596,7 +596,8 @@ struct ieee80211_sub_if_data {
 	struct {
 		struct dentry *dir;
 		struct dentry *subdir_stations;
-		struct dentry *default_key;
+		struct dentry *default_unicast_key;
+		struct dentry *default_multicast_key;
 		struct dentry *default_mgmt_key;
 	} debugfs;
 #endif
--- wireless-testing.orig/net/mac80211/tx.c	2010-12-07 22:42:49.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-12-07 22:43:04.000000000 +0100
@@ -539,7 +539,11 @@ ieee80211_tx_h_select_key(struct ieee802
 		 ieee80211_is_robust_mgmt_frame(hdr) &&
 		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
 		tx->key = key;
-	else if ((key = rcu_dereference(tx->sdata->default_key)))
+	else if (is_multicast_ether_addr(hdr->addr1) &&
+		 (key = rcu_dereference(tx->sdata->default_multicast_key)))
+		tx->key = key;
+	else if (!is_multicast_ether_addr(hdr->addr1) &&
+		 (key = rcu_dereference(tx->sdata->default_unicast_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
 		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
--- wireless-testing.orig/net/mac80211/debugfs_key.c	2010-12-07 22:40:44.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_key.c	2010-12-07 22:43:04.000000000 +0100
@@ -274,7 +274,8 @@ void ieee80211_debugfs_key_remove(struct
 	debugfs_remove_recursive(key->debugfs.dir);
 	key->debugfs.dir = NULL;
 }
-void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata)
+
+void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 {
 	char buf[50];
 	struct ieee80211_key *key;
@@ -282,25 +283,29 @@ void ieee80211_debugfs_key_add_default(s
 	if (!sdata->debugfs.dir)
 		return;
 
-	/* this is running under the key lock */
+	lockdep_assert_held(&sdata->local->key_mtx);
 
-	key = sdata->default_key;
-	if (key) {
+	if (sdata->default_unicast_key) {
+		key = sdata->default_unicast_key;
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
-		sdata->debugfs.default_key =
-			debugfs_create_symlink("default_key",
+		sdata->debugfs.default_unicast_key =
+			debugfs_create_symlink("default_unicast_key",
 					       sdata->debugfs.dir, buf);
-	} else
-		ieee80211_debugfs_key_remove_default(sdata);
-}
+	} else {
+		debugfs_remove(sdata->debugfs.default_unicast_key);
+		sdata->debugfs.default_unicast_key = NULL;
+	}
 
-void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata)
-{
-	if (!sdata)
-		return;
-
-	debugfs_remove(sdata->debugfs.default_key);
-	sdata->debugfs.default_key = NULL;
+	if (sdata->default_multicast_key) {
+		key = sdata->default_multicast_key;
+		sprintf(buf, "../keys/%d", key->debugfs.cnt);
+		sdata->debugfs.default_multicast_key =
+			debugfs_create_symlink("default_multicast_key",
+					       sdata->debugfs.dir, buf);
+	} else {
+		debugfs_remove(sdata->debugfs.default_multicast_key);
+		sdata->debugfs.default_multicast_key = NULL;
+	}
 }
 
 void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/debugfs_key.h	2010-12-07 22:40:45.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_key.h	2010-12-07 22:43:04.000000000 +0100
@@ -4,8 +4,7 @@
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_key_add(struct ieee80211_key *key);
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
-void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata);
-void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_add_mgmt_default(
 	struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_remove_mgmt_default(
@@ -17,10 +16,7 @@ static inline void ieee80211_debugfs_key
 {}
 static inline void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
 {}
-static inline void ieee80211_debugfs_key_add_default(
-	struct ieee80211_sub_if_data *sdata)
-{}
-static inline void ieee80211_debugfs_key_remove_default(
+static inline void ieee80211_debugfs_key_update_default(
 	struct ieee80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_debugfs_key_add_mgmt_default(
--- wireless-testing.orig/net/mac80211/key.c	2010-12-07 22:40:44.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2010-12-07 22:43:04.000000000 +0100
@@ -178,7 +178,7 @@ void ieee80211_key_removed(struct ieee80
 EXPORT_SYMBOL_GPL(ieee80211_key_removed);
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
-					int idx)
+					int idx, bool uni, bool multi)
 {
 	struct ieee80211_key *key = NULL;
 
@@ -187,18 +187,19 @@ static void __ieee80211_set_default_key(
 	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
 		key = sdata->keys[idx];
 
-	rcu_assign_pointer(sdata->default_key, key);
+	if (uni)
+		rcu_assign_pointer(sdata->default_unicast_key, key);
+	if (multi)
+		rcu_assign_pointer(sdata->default_multicast_key, key);
 
-	if (key) {
-		ieee80211_debugfs_key_remove_default(key->sdata);
-		ieee80211_debugfs_key_add_default(key->sdata);
-	}
+	ieee80211_debugfs_key_update_default(sdata);
 }
 
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)
+void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
+			       bool uni, bool multi)
 {
 	mutex_lock(&sdata->local->key_mtx);
-	__ieee80211_set_default_key(sdata, idx);
+	__ieee80211_set_default_key(sdata, idx, uni, multi);
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
@@ -215,10 +216,7 @@ __ieee80211_set_default_mgmt_key(struct
 
 	rcu_assign_pointer(sdata->default_mgmt_key, key);
 
-	if (key) {
-		ieee80211_debugfs_key_remove_mgmt_default(key->sdata);
-		ieee80211_debugfs_key_add_mgmt_default(key->sdata);
-	}
+	ieee80211_debugfs_key_update_default(sdata);
 }
 
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
@@ -236,7 +234,8 @@ static void __ieee80211_key_replace(stru
 				    struct ieee80211_key *old,
 				    struct ieee80211_key *new)
 {
-	int idx, defkey, defmgmtkey;
+	int idx;
+	bool defunikey, defmultikey, defmgmtkey;
 
 	if (new)
 		list_add(&new->list, &sdata->key_list);
@@ -257,17 +256,24 @@ static void __ieee80211_key_replace(stru
 		else
 			idx = new->conf.keyidx;
 
-		defkey = old && sdata->default_key == old;
+		defunikey = old && sdata->default_unicast_key == old;
+		defmultikey = old && sdata->default_multicast_key == old;
 		defmgmtkey = old && sdata->default_mgmt_key == old;
 
-		if (defkey && !new)
-			__ieee80211_set_default_key(sdata, -1);
+		if (defunikey && !new)
+			__ieee80211_set_default_key(sdata, -1, true, false);
+		if (defmultikey && !new)
+			__ieee80211_set_default_key(sdata, -1, false, true);
 		if (defmgmtkey && !new)
 			__ieee80211_set_default_mgmt_key(sdata, -1);
 
 		rcu_assign_pointer(sdata->keys[idx], new);
-		if (defkey && new)
-			__ieee80211_set_default_key(sdata, new->conf.keyidx);
+		if (defunikey && new)
+			__ieee80211_set_default_key(sdata, new->conf.keyidx,
+						    true, false);
+		if (defmultikey && new)
+			__ieee80211_set_default_key(sdata, new->conf.keyidx,
+						    false, true);
 		if (defmgmtkey && new)
 			__ieee80211_set_default_mgmt_key(sdata,
 							 new->conf.keyidx);
@@ -509,11 +515,12 @@ void ieee80211_free_keys(struct ieee8021
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	ieee80211_debugfs_key_remove_default(sdata);
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 		__ieee80211_key_free(key);
 
+	ieee80211_debugfs_key_update_default(sdata);
+
 	mutex_unlock(&sdata->local->key_mtx);
 }
--- wireless-testing.orig/net/mac80211/key.h	2010-12-07 22:40:44.000000000 +0100
+++ wireless-testing/net/mac80211/key.h	2010-12-07 22:43:04.000000000 +0100
@@ -138,7 +138,8 @@ int __must_check ieee80211_key_link(stru
 				    struct sta_info *sta);
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key);
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
+void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
+			       bool uni, bool multi);
 void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 				    int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
--- wireless-testing.orig/net/mac80211/main.c	2010-12-07 22:42:46.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2010-12-07 22:43:04.000000000 +0100
@@ -519,7 +519,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
 			WIPHY_FLAG_4ADDR_AP |
-			WIPHY_FLAG_4ADDR_STATION;
+			WIPHY_FLAG_4ADDR_STATION |
+			WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS;
 	wiphy->privid = mac80211_wiphy_privid;
 
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-07 22:43:03.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-07 22:43:04.000000000 +0100
@@ -300,7 +300,7 @@ static int ieee80211_config_default_key(
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	ieee80211_set_default_key(sdata, key_idx);
+	ieee80211_set_default_key(sdata, key_idx, uni, multi);
 
 	return 0;
 }


