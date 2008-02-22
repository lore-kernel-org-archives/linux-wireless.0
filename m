Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761809AbYBVOIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:04 -0500
Message-Id: <20080222111749.198388000@sipsolutions.net> (sfid-20080222_140812_436133_1B785131)
References: <20080222111644.183587000@sipsolutions.net>
Date: Fri, 22 Feb 2008 12:16:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 3/8] mac80211: split ieee80211_key_alloc
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to RCU-ify sta_info, we need to be able to allocate
a key without linking it to an sdata/sta structure (because
allocation cannot be done in an rcu critical section). This
patch splits up ieee80211_key_alloc() and updates all users
appropriately.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c             |   13 ++++-
 net/mac80211/ieee80211_ioctl.c |   91 ++++++++++++++++++++++-------------------
 net/mac80211/ieee80211_key.h   |   11 +++-
 net/mac80211/key.c             |   32 +++++++++-----
 4 files changed, 87 insertions(+), 60 deletions(-)

--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-02-21 16:02:41.000000000 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-02-21 16:12:55.000000000 +0100
@@ -33,8 +33,8 @@ static int ieee80211_set_encryption(stru
 				    size_t key_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int ret = 0;
-	struct sta_info *sta;
+	int ret;
+	struct sta_info *sta = NULL;
 	struct ieee80211_key *key;
 	struct ieee80211_sub_if_data *sdata;
 
@@ -46,58 +46,65 @@ static int ieee80211_set_encryption(stru
 		return -EINVAL;
 	}
 
-	if (is_broadcast_ether_addr(sta_addr)) {
-		sta = NULL;
-		key = sdata->keys[idx];
-	} else {
-		set_tx_key = 0;
-		/*
-		 * According to the standard, the key index of a pairwise
-		 * key must be zero. However, some AP are broken when it
-		 * comes to WEP key indices, so we work around this.
-		 */
-		if (idx != 0 && alg != ALG_WEP) {
-			printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
-			       "individual key\n", dev->name);
-			return -EINVAL;
+	if (remove) {
+		if (is_broadcast_ether_addr(sta_addr)) {
+			key = sdata->keys[idx];
+		} else {
+			sta = sta_info_get(local, sta_addr);
+			if (!sta) {
+				ret = -ENOENT;
+				key = NULL;
+				goto err_out;
+			}
+
+			key = sta->key;
 		}
 
-		sta = sta_info_get(local, sta_addr);
-		if (!sta) {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			DECLARE_MAC_BUF(mac);
-			printk(KERN_DEBUG "%s: set_encrypt - unknown addr "
-			       "%s\n",
-			       dev->name, print_mac(mac, sta_addr));
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+		if (!key)
+			ret = -ENOENT;
+		else
+			ret = 0;
+	} else {
+		key = ieee80211_key_alloc(alg, idx, key_len, _key);
+		if (!key)
+			return -ENOMEM;
+
+		if (!is_broadcast_ether_addr(sta_addr)) {
+			set_tx_key = 0;
+			/*
+			 * According to the standard, the key index of a
+			 * pairwise key must be zero. However, some AP are
+			 * broken when it comes to WEP key indices, so we
+			 * work around this.
+			 */
+			if (idx != 0 && alg != ALG_WEP) {
+				ret = -EINVAL;
+				goto err_out;
+			}
 
-			return -ENOENT;
+			sta = sta_info_get(local, sta_addr);
+			if (!sta) {
+				ret = -ENOENT;
+				goto err_out;
+			}
 		}
 
-		key = sta->key;
-	}
+		/* Automatically frees any old key if present. */
+		ieee80211_key_link(key, sdata, sta);
 
-	if (remove) {
-		ieee80211_key_free(key);
+		if (set_tx_key || (!sta && !sdata->default_key && key))
+			ieee80211_set_default_key(sdata, idx);
+
+		/* don't free key later */
 		key = NULL;
-	} else {
-		/*
-		 * Automatically frees any old key if present.
-		 */
-		key = ieee80211_key_alloc(sdata, sta, alg, idx, key_len, _key);
-		if (!key) {
-			ret = -ENOMEM;
-			goto err_out;
-		}
-	}
 
-	if (set_tx_key || (!sta && !sdata->default_key && key))
-		ieee80211_set_default_key(sdata, idx);
+		ret = 0;
+	}
 
-	ret = 0;
  err_out:
 	if (sta)
 		sta_info_put(sta);
+	ieee80211_key_free(key);
 	return ret;
 }
 
--- everything.orig/net/mac80211/ieee80211_key.h	2008-02-21 16:02:40.000000000 +0100
+++ everything/net/mac80211/ieee80211_key.h	2008-02-21 16:02:46.000000000 +0100
@@ -112,12 +112,17 @@ struct ieee80211_key {
 	struct ieee80211_key_conf conf;
 };
 
-struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  struct sta_info *sta,
-					  enum ieee80211_key_alg alg,
+struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
 					  const u8 *key_data);
+/*
+ * Insert a key into data structures (sdata, sta if necessary)
+ * to make it used.
+ */
+void ieee80211_key_link(struct ieee80211_key *key,
+			struct ieee80211_sub_if_data *sdata,
+			struct sta_info *sta);
 void ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
--- everything.orig/net/mac80211/key.c	2008-02-21 16:02:41.000000000 +0100
+++ everything/net/mac80211/key.c	2008-02-21 16:18:13.000000000 +0100
@@ -111,9 +111,7 @@ static void ieee80211_key_disable_hw_acc
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 }
 
-struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  struct sta_info *sta,
-					  enum ieee80211_key_alg alg,
+struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
 					  const u8 *key_data)
@@ -138,10 +136,6 @@ struct ieee80211_key *ieee80211_key_allo
 	key->conf.keylen = key_len;
 	memcpy(key->conf.key, key_data, key_len);
 
-	key->local = sdata->local;
-	key->sdata = sdata;
-	key->sta = sta;
-
 	if (alg == ALG_CCMP) {
 		/*
 		 * Initialize AES key state here as an optimization so that
@@ -154,6 +148,23 @@ struct ieee80211_key *ieee80211_key_allo
 		}
 	}
 
+	return key;
+}
+
+void ieee80211_key_link(struct ieee80211_key *key,
+			struct ieee80211_sub_if_data *sdata,
+			struct sta_info *sta)
+{
+	int idx;
+
+	BUG_ON(!sdata);
+	BUG_ON(!key);
+
+	idx = key->conf.keyidx;
+	key->local = sdata->local;
+	key->sdata = sdata;
+	key->sta = sta;
+
 	ieee80211_debugfs_key_add(key->local, key);
 
 	/* remove key first */
@@ -196,8 +207,6 @@ struct ieee80211_key *ieee80211_key_allo
 		rcu_assign_pointer(sdata->keys[idx], key);
 
 	list_add(&key->list, &sdata->key_list);
-
-	return key;
 }
 
 void ieee80211_key_free(struct ieee80211_key *key)
@@ -207,7 +216,7 @@ void ieee80211_key_free(struct ieee80211
 
 	if (key->sta) {
 		rcu_assign_pointer(key->sta->key, NULL);
-	} else {
+	} else if (key->sdata) {
 		if (key->sdata->default_key == key)
 			ieee80211_set_default_key(key->sdata, -1);
 		if (key->conf.keyidx >= 0 &&
@@ -228,7 +237,8 @@ void ieee80211_key_free(struct ieee80211
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	ieee80211_debugfs_key_remove(key);
 
-	list_del(&key->list);
+	if (key->sdata)
+		list_del(&key->list);
 
 	kfree(key);
 }
--- everything.orig/net/mac80211/cfg.c	2008-02-21 16:13:31.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-21 16:15:07.000000000 +0100
@@ -129,6 +129,7 @@ static int ieee80211_add_key(struct wiph
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
 	int ret;
+	struct ieee80211_key *key;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -147,16 +148,20 @@ static int ieee80211_add_key(struct wiph
 		return -EINVAL;
 	}
 
+	key = ieee80211_key_alloc(alg, key_idx, params->key_len, params->key);
+	if (!key)
+		return -ENOMEM;
+
 	if (mac_addr) {
 		sta = sta_info_get(sdata->local, mac_addr);
-		if (!sta)
+		if (!sta) {
+			ieee80211_key_free(key);
 			return -ENOENT;
+		}
 	}
 
+	ieee80211_key_link(key, sdata, sta);
 	ret = 0;
-	if (!ieee80211_key_alloc(sdata, sta, alg, key_idx,
-				 params->key_len, params->key))
-		ret = -ENOMEM;
 
 	if (sta)
 		sta_info_put(sta);

-- 

