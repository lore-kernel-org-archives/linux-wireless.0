Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYBYPcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:32:05 -0500
Message-Id: <20080225153006.827673000@sipsolutions.net> (sfid-20080225_153212_343175_740F6811)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 05/10] mac80211: split ieee80211_key_alloc/free
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to RCU-ify sta_info, we need to be able to allocate
a key without linking it to an sdata/sta structure (because
allocation cannot be done in an rcu critical section). This
patch splits up ieee80211_key_alloc() and updates all users
appropriately.

While at it, this patch fixes a number of race conditions
such as finally making key replacement atomic, unfortunately
at the expense of more complex code.

Note that this patch documents /existing/ bugs with sta info
and key interaction, there is currently a race condition
when a sta info is freed without holding the RTNL. This will
finally be fixed by a followup patch.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c             |   27 ++++---
 net/mac80211/ieee80211_ioctl.c |   90 ++++++++++++-----------
 net/mac80211/ieee80211_key.h   |   26 +++++-
 net/mac80211/key.c             |  156 +++++++++++++++++++++++++++++------------
 net/mac80211/sta_info.c        |    2 
 5 files changed, 203 insertions(+), 98 deletions(-)

--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-02-23 15:13:17.000000000 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-02-24 10:27:18.000000000 +0100
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
 
@@ -46,58 +46,64 @@ static int ieee80211_set_encryption(stru
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
 
--- everything.orig/net/mac80211/ieee80211_key.h	2008-02-23 11:37:09.000000000 +0100
+++ everything/net/mac80211/ieee80211_key.h	2008-02-24 10:27:18.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/crypto.h>
+#include <linux/rcupdate.h>
 #include <net/mac80211.h>
 
 /* ALG_TKIP
@@ -45,7 +46,19 @@ struct ieee80211_local;
 struct ieee80211_sub_if_data;
 struct sta_info;
 
-#define KEY_FLAG_UPLOADED_TO_HARDWARE	(1<<0)
+/**
+ * enum ieee80211_internal_key_flags - internal key flags
+ *
+ * @KEY_FLAG_UPLOADED_TO_HARDWARE: Indicates that this key is present
+ *	in the hardware for TX crypto hardware acceleration.
+ * @KEY_FLAG_REMOVE_FROM_HARDWARE: Indicates to the key code that this
+ *	key is present in the hardware (but it cannot be used for
+ *	hardware acceleration any more!)
+ */
+enum ieee80211_internal_key_flags {
+	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
+	KEY_FLAG_REMOVE_FROM_HARDWARE	= BIT(1),
+};
 
 struct ieee80211_key {
 	struct ieee80211_local *local;
@@ -112,12 +125,17 @@ struct ieee80211_key {
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
+ * to make it used, free old key.
+ */
+void ieee80211_key_link(struct ieee80211_key *key,
+			struct ieee80211_sub_if_data *sdata,
+			struct sta_info *sta);
 void ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
--- everything.orig/net/mac80211/key.c	2008-02-23 13:03:38.000000000 +0100
+++ everything/net/mac80211/key.c	2008-02-24 10:27:18.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/rcupdate.h>
+#include <linux/rtnetlink.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "debugfs_key.h"
@@ -34,6 +35,10 @@
  *
  * All operations here are called under RTNL so no extra locking is
  * required.
+ *
+ * NOTE: This code requires that sta info *destruction* is done under
+ *	 RTNL, otherwise it can try to access already freed STA structs
+ *	 when a STA key is being freed.
  */
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -84,16 +89,25 @@ static void ieee80211_key_enable_hw_acce
 		       key->conf.keyidx, print_mac(mac, addr), ret);
 }
 
+static void ieee80211_key_mark_hw_accel_off(struct ieee80211_key *key)
+{
+	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+		key->flags |= KEY_FLAG_REMOVE_FROM_HARDWARE;
+	}
+}
+
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 {
 	const u8 *addr;
 	int ret;
 	DECLARE_MAC_BUF(mac);
 
-	if (!key->local->ops->set_key)
+	if (!key || !key->local->ops->set_key)
 		return;
 
-	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
+	    !(key->flags & KEY_FLAG_REMOVE_FROM_HARDWARE))
 		return;
 
 	addr = get_mac_for_key(key);
@@ -108,12 +122,11 @@ static void ieee80211_key_disable_hw_acc
 		       wiphy_name(key->local->hw.wiphy),
 		       key->conf.keyidx, print_mac(mac, addr), ret);
 
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+	key->flags &= ~(KEY_FLAG_UPLOADED_TO_HARDWARE |
+			KEY_FLAG_REMOVE_FROM_HARDWARE);
 }
 
-struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  struct sta_info *sta,
-					  enum ieee80211_key_alg alg,
+struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 					  int idx,
 					  size_t key_len,
 					  const u8 *key_data)
@@ -138,10 +151,6 @@ struct ieee80211_key *ieee80211_key_allo
 	key->conf.keylen = key_len;
 	memcpy(key->conf.key, key_data, key_len);
 
-	key->local = sdata->local;
-	key->sdata = sdata;
-	key->sta = sta;
-
 	if (alg == ALG_CCMP) {
 		/*
 		 * Initialize AES key state here as an optimization so that
@@ -154,13 +163,62 @@ struct ieee80211_key *ieee80211_key_allo
 		}
 	}
 
-	ieee80211_debugfs_key_add(key->local, key);
+	return key;
+}
 
-	/* remove key first */
-	if (sta)
-		ieee80211_key_free(sta->key);
-	else
-		ieee80211_key_free(sdata->keys[idx]);
+static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+				    struct sta_info *sta,
+				    struct ieee80211_key *key,
+				    struct ieee80211_key *new)
+{
+	int idx, defkey;
+
+	if (sta) {
+		rcu_assign_pointer(sta->key, new);
+	} else {
+		WARN_ON(new && key && new->conf.keyidx != key->conf.keyidx);
+
+		if (key)
+			idx = key->conf.keyidx;
+		else
+			idx = new->conf.keyidx;
+
+		defkey = key && sdata->default_key == key;
+
+		if (defkey && !new)
+			ieee80211_set_default_key(sdata, -1);
+
+		rcu_assign_pointer(sdata->keys[idx], new);
+
+		if (defkey && new)
+			ieee80211_set_default_key(sdata, new->conf.keyidx);
+	}
+
+	if (key) {
+		ieee80211_key_mark_hw_accel_off(key);
+		list_del(&key->list);
+	}
+}
+
+void ieee80211_key_link(struct ieee80211_key *key,
+			struct ieee80211_sub_if_data *sdata,
+			struct sta_info *sta)
+{
+	struct ieee80211_key *old_key;
+	int idx;
+
+	ASSERT_RTNL();
+	might_sleep();
+
+	BUG_ON(!sdata);
+	BUG_ON(!key);
+
+	idx = key->conf.keyidx;
+	key->local = sdata->local;
+	key->sdata = sdata;
+	key->sta = sta;
+
+	ieee80211_debugfs_key_add(key->local, key);
 
 	if (sta) {
 		ieee80211_debugfs_key_sta_link(key, sta);
@@ -186,50 +244,53 @@ struct ieee80211_key *ieee80211_key_allo
 		}
 	}
 
-	/* enable hwaccel if appropriate */
-	if (netif_running(key->sdata->dev))
-		ieee80211_key_enable_hw_accel(key);
-
 	if (sta)
-		rcu_assign_pointer(sta->key, key);
+		old_key = sta->key;
 	else
-		rcu_assign_pointer(sdata->keys[idx], key);
+		old_key = sdata->keys[idx];
+
+	__ieee80211_key_replace(sdata, sta, old_key, key);
 
 	list_add(&key->list, &sdata->key_list);
 
-	return key;
+	synchronize_rcu();
+
+	ieee80211_key_free(old_key);
+	ieee80211_key_enable_hw_accel(key);
 }
 
 void ieee80211_key_free(struct ieee80211_key *key)
 {
+	ASSERT_RTNL();
+	might_sleep();
+
 	if (!key)
 		return;
 
-	if (key->sta) {
-		rcu_assign_pointer(key->sta->key, NULL);
-	} else {
-		if (key->sdata->default_key == key)
-			ieee80211_set_default_key(key->sdata, -1);
-		if (key->conf.keyidx >= 0 &&
-		    key->conf.keyidx < NUM_DEFAULT_KEYS)
-			rcu_assign_pointer(key->sdata->keys[key->conf.keyidx],
-					   NULL);
-		else
-			WARN_ON(1);
-	}
+	if (key->sdata) {
+		/*
+		 * Replace key with nothingness.
+		 *
+		 * Because other code may have key reference (RCU protected)
+		 * right now, we then wait for a grace period before freeing
+		 * it.
+		 */
+		__ieee80211_key_replace(key->sdata, key->sta, key, NULL);
 
-	/* wait for all key users to complete */
-	synchronize_rcu();
+		synchronize_rcu();
 
-	/* remove from hwaccel if appropriate */
-	ieee80211_key_disable_hw_accel(key);
+		/*
+		 * Remove from hwaccel if appropriate, this will
+		 * only happen when the key is actually unlinked,
+		 * it will already be done when the key was replaced.
+		 */
+		ieee80211_key_disable_hw_accel(key);
+	}
 
 	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	ieee80211_debugfs_key_remove(key);
 
-	list_del(&key->list);
-
 	kfree(key);
 }
 
@@ -253,6 +314,10 @@ void ieee80211_set_default_key(struct ie
 void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
+	LIST_HEAD(tmp_list);
+
+	ASSERT_RTNL();
+	might_sleep();
 
 	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 		ieee80211_key_free(key);
@@ -262,8 +327,10 @@ void ieee80211_enable_keys(struct ieee80
 {
 	struct ieee80211_key *key;
 
-	WARN_ON(!netif_running(sdata->dev));
-	if (!netif_running(sdata->dev))
+	ASSERT_RTNL();
+	might_sleep();
+
+	if (WARN_ON(!netif_running(sdata->dev)))
 		return;
 
 	list_for_each_entry(key, &sdata->key_list, list)
@@ -274,6 +341,9 @@ void ieee80211_disable_keys(struct ieee8
 {
 	struct ieee80211_key *key;
 
+	ASSERT_RTNL();
+	might_sleep();
+
 	list_for_each_entry(key, &sdata->key_list, list)
 		ieee80211_key_disable_hw_accel(key);
 }
--- everything.orig/net/mac80211/cfg.c	2008-02-23 15:13:17.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-24 10:27:18.000000000 +0100
@@ -143,6 +143,7 @@ static int ieee80211_add_key(struct wiph
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
 	int ret;
+	struct ieee80211_key *key;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -161,16 +162,21 @@ static int ieee80211_add_key(struct wiph
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
+
 	ret = 0;
-	if (!ieee80211_key_alloc(sdata, sta, alg, key_idx,
-				 params->key_len, params->key))
-		ret = -ENOMEM;
 
 	if (sta)
 		sta_info_put(sta);
@@ -184,6 +190,7 @@ static int ieee80211_del_key(struct wiph
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int ret;
+	struct ieee80211_key *key;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -193,9 +200,11 @@ static int ieee80211_del_key(struct wiph
 			return -ENOENT;
 
 		ret = 0;
-		if (sta->key)
-			ieee80211_key_free(sta->key);
-		else
+		if (sta->key) {
+			key = sta->key;
+			ieee80211_key_free(key);
+			WARN_ON(sta->key);
+		} else
 			ret = -ENOENT;
 
 		sta_info_put(sta);
@@ -205,7 +214,9 @@ static int ieee80211_del_key(struct wiph
 	if (!sdata->keys[key_idx])
 		return -ENOENT;
 
-	ieee80211_key_free(sdata->keys[key_idx]);
+	key = sdata->keys[key_idx];
+	ieee80211_key_free(key);
+	WARN_ON(sdata->keys[key_idx]);
 
 	return 0;
 }
--- everything.orig/net/mac80211/sta_info.c	2008-02-23 14:59:28.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-24 10:27:37.000000000 +0100
@@ -342,7 +342,7 @@ void sta_info_free(struct sta_info *sta)
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	ieee80211_key_free(sta->key);
-	sta->key = NULL;
+	WARN_ON(sta->key);
 
 	if (local->ops->sta_notify) {
 

-- 

