Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbXHPNz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:55:58 -0400
Message-Id: <20070816135318.875323000@sipsolutions.net>
References: <20070816135314.691716000@sipsolutions.net>
Date: Thu, 16 Aug 2007 15:53:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: revamp key handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A whole bunch of things:

 1) remove krefs for keys, they aren't really refcounted

 2) move code and hardware acceleration handling into
    key.c, weed out ieee80211_ioctl.c

 3) remove the extended error codes, hostapd and wpa_supplicant
    don't use them

 4) remove the default_wep_only stuff, this wasn't really
    done well and no current driver actually cared, allow
    drivers to handle this instead by giving them access
    to the local MAC address where the key should be used.
    Also allow drivers to keep a list of keys and tell us that
    they've had to disable a key.

 5) Remove adding a fake key with a NONE key algorithm for each
    associated STA. If we have hardware with such TX filtering
    we should probably extend the sta_table_notification()
    callback with the sta information instead; the fact that
    it's treated as a key for some atheros hardware shouldn't
    bother the stack.

 6) Turn off hardware acceleration for keys when the interface
    is down. This is necessary because otherwise monitor
    interfaces could be decrypting frames for other interfaces
    that are down at the moment. Also, it should go some way
    towards better suspend/resume support, in any case the
    routines used here could be used for that as well.
    Additionally, this makes the driver interface nicer, keys
    for a specific local MAC address are only ever present
    while an interface with that MAC address is enabled.

 7) Change driver set_key() callback interface to allow only
    return values of -ENOSPC, -EOPNOTSUPP and 0, warn on all
    other return values. This allows debugging the stack when
    a driver notices it's handed a key while it is down.

 8) Invert the flag meaning to KEY_FLAG_UPLOADED_TO_HARDWARE.

 9) Update b43 and iwlwifi, but iwlwifi will give loads of
    warnings because it never disables keys, I don't know the
    hardware nor the driver well enough to fix that though.

10) Remove REMOVE_ALL_KEYS command as it isn't used nor do
    we want to use it, we'll use DISABLE_KEY for each key.
    It is hard to use REMOVE_ALL_KEYS because we can handle
    multiple virtual interfaces with different key configuration,
    so we'd have to keep track of a lot of state for this and
    that isn't worth it.

11) Warn when disabling a key fails, it musn't.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/b43/main.c |   25 ---
 drivers/net/wireless/iwl-base.c |    9 -
 include/net/mac80211.h          |   56 +++++-
 net/mac80211/debugfs_key.c      |    4 
 net/mac80211/debugfs_sta.c      |    1 
 net/mac80211/hostapd_ioctl.h    |    7 
 net/mac80211/ieee80211.c        |    6 
 net/mac80211/ieee80211_i.h      |   19 --
 net/mac80211/ieee80211_iface.c  |   25 ---
 net/mac80211/ieee80211_ioctl.c  |  328 +++-------------------------------------
 net/mac80211/ieee80211_key.h    |   28 +++
 net/mac80211/key.c              |  292 ++++++++++++++++++++++++++++++++++-
 net/mac80211/rx.c               |    4 
 net/mac80211/sta_info.c         |   30 ---
 net/mac80211/sta_info.h         |    4 
 net/mac80211/tx.c               |    9 -
 net/mac80211/wpa.c              |   30 +--
 17 files changed, 443 insertions(+), 434 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-16 13:38:05.933471955 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-16 13:45:40.793471955 +0200
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
+#include <linux/mutex.h>
 #include <net/wireless.h>
 #include "ieee80211_key.h"
 #include "sta_info.h"
@@ -308,6 +309,10 @@ struct ieee80211_sub_if_data {
 
 	struct wireless_dev wdev;
 
+	/* keys */
+	struct mutex key_mtx;
+	struct list_head key_list;
+
 	struct net_device *dev;
 	struct ieee80211_local *local;
 
@@ -607,9 +612,6 @@ struct ieee80211_local {
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
 
-	int default_wep_only; /* only default WEP keys are used with this
-			       * interface; this is used to decide when hwaccel
-			       * can be used with default keys */
 	int total_ps_buffered; /* total number of all buffered unicast and
 				* multicast packets for power saving stations
 				*/
@@ -793,12 +795,6 @@ void ieee80211_key_threshold_notify(stru
 int ieee80211_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 extern const struct iw_handler_def ieee80211_iw_handler_def;
 
-/* Set hw encryption from ieee80211 */
-int ieee80211_set_hw_encryption(struct net_device *dev,
-				struct sta_info *sta, u8 addr[ETH_ALEN],
-				struct ieee80211_key *key);
-void ieee80211_update_default_wep_only(struct ieee80211_local *local);
-
 
 /* Least common multiple of the used rates (in 100 kbps). This is used to
  * calculate rate_inv values for each rate so that only integers are needed. */
@@ -902,11 +898,6 @@ int ieee80211_monitor_start_xmit(struct 
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
-/* key handling */
-struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  int idx, size_t key_len, gfp_t flags);
-void ieee80211_key_free(struct ieee80211_key *key);
-
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-16 13:38:05.953471955 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-16 13:45:40.803471955 +0200
@@ -25,7 +25,6 @@
 #include "ieee80211_rate.h"
 #include "wpa.h"
 #include "aes_ccm.h"
-#include "debugfs_key.h"
 
 
 static int ieee80211_ioctl_set_beacon(struct net_device *dev,
@@ -215,7 +214,6 @@ static int ieee80211_ioctl_add_sta(struc
 	int i, j;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hw_mode *mode;
-	int add_key_entry = 1;
 
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
@@ -273,24 +271,6 @@ static int ieee80211_ioctl_add_sta(struc
 	else
 		sta->flags &= ~WLAN_STA_WDS;
 
-	if (add_key_entry && !sta->key && !sdata->default_key &&
-	    local->ops->set_key) {
-		struct ieee80211_key_conf conf;
-		/* Add key cache entry with NULL key type because this may used
-		 * for TX filtering. */
-		memset(&conf, 0, sizeof(conf));
-		conf.hw_key_idx = HW_KEY_IDX_INVALID;
-		conf.alg = ALG_NONE;
-		conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-		if (local->ops->set_key(local_to_hw(local), SET_KEY,
-				       sta->addr, &conf,
-				       local->default_wep_only)) {
-			sta->key_idx_compression = HW_KEY_IDX_INVALID;
-		} else {
-			sta->key_idx_compression = conf.hw_key_idx;
-		}
-	}
-
 	sta_info_put(sta);
 
 	if (sdata->type == IEEE80211_IF_TYPE_AP)
@@ -394,44 +374,14 @@ static int ieee80211_ioctl_set_flags_sta
 }
 
 
-int ieee80211_set_hw_encryption(struct net_device *dev,
-				struct sta_info *sta, u8 addr[ETH_ALEN],
-				struct ieee80211_key *key)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int rc = 0;
-
-	/*
-	 * default to sw encryption; this will be cleared by low-level
-	 * driver if the hw supports requested encryption
-	 */
-	if (key)
-		key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-
-	if (key && local->ops->set_key) {
-		rc = local->ops->set_key(local_to_hw(local), SET_KEY, addr,
-					 &key->conf, local->default_wep_only);
-		if (rc) {
-			rc = HOSTAP_CRYPT_ERR_KEY_SET_FAILED;
-			/* protect against buggy drivers */
-			key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-			key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
-		}
-	}
-
-	return rc;
-}
-
-
 static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
-				    int idx, int alg, int set_tx_key, u32 *err,
+				    int idx, int alg, int set_tx_key,
 				    const u8 *_key, size_t key_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int ret = 0;
 	struct sta_info *sta;
-	struct ieee80211_key *key, *old_key;
-	int try_hwaccel = 1;
+	struct ieee80211_key *key;
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -464,8 +414,6 @@ static int ieee80211_set_encryption(stru
 
 		sta = sta_info_get(local, sta_addr);
 		if (!sta) {
-			if (err)
-				*err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: set_encrypt - unknown addr "
 			       MAC_FMT "\n",
@@ -478,146 +426,27 @@ static int ieee80211_set_encryption(stru
 		key = sta->key;
 	}
 
-	/* FIX:
-	 * Cannot configure default hwaccel keys with WEP algorithm, if
-	 * any of the virtual interfaces is using static WEP
-	 * configuration because hwaccel would otherwise try to decrypt
-	 * these frames.
-	 *
-	 * For now, just disable WEP hwaccel for broadcast when there is
-	 * possibility of conflict with default keys. This can maybe later be
-	 * optimized by using non-default keys (at least with Atheros ar521x).
-	 */
-	if (!sta && alg == ALG_WEP && !local->default_wep_only &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS &&
-	    sdata->type != IEEE80211_IF_TYPE_AP) {
-		try_hwaccel = 0;
-	}
-
-	if (local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP) {
-		/* Software encryption cannot be used with devices that hide
-		 * encryption from the host system, so always try to use
-		 * hardware acceleration with such devices. */
-		try_hwaccel = 1;
-	}
-
-	if ((local->hw.flags & IEEE80211_HW_NO_TKIP_WMM_HWACCEL) &&
-	    alg == ALG_TKIP) {
-		if (sta && (sta->flags & WLAN_STA_WME)) {
-		/* Hardware does not support hwaccel with TKIP when using WMM.
-		 */
-			try_hwaccel = 0;
-		}
-		else if (sdata->type == IEEE80211_IF_TYPE_STA) {
-			sta = sta_info_get(local, sdata->u.sta.bssid);
-			if (sta) {
-				if (sta->flags & WLAN_STA_WME) {
-					try_hwaccel = 0;
-				}
-				sta_info_put(sta);
-				sta = NULL;
-			}
-		}
-	}
-
 	if (alg == ALG_NONE) {
-		if (try_hwaccel && key &&
-		    key->conf.hw_key_idx != HW_KEY_IDX_INVALID &&
-		    local->ops->set_key &&
-		    local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-					sta_addr, &key->conf,
-					local->default_wep_only)) {
-			if (err)
-				*err = HOSTAP_CRYPT_ERR_KEY_SET_FAILED;
-			printk(KERN_DEBUG "%s: set_encrypt - low-level disable"
-			       " failed\n", dev->name);
-			ret = -EINVAL;
-		}
-
-		if (set_tx_key || sdata->default_key == key) {
-			ieee80211_debugfs_key_remove_default(sdata);
-			sdata->default_key = NULL;
-		}
-		ieee80211_debugfs_key_remove(key);
-		if (sta)
-			sta->key = NULL;
-		else
-			sdata->keys[idx] = NULL;
 		ieee80211_key_free(key);
 		key = NULL;
 	} else {
-		old_key = key;
-		key = ieee80211_key_alloc(sta ? NULL : sdata, idx, key_len,
-					  GFP_KERNEL);
+		/*
+		 * need to free it before allocating a new one with
+		 * with the same index or debugfs messes up
+		 */
+		ieee80211_key_free(key);
+		key = ieee80211_key_alloc(sdata, sta, alg, idx, key_len, _key);
 		if (!key) {
 			ret = -ENOMEM;
 			goto err_out;
 		}
-
-		/* default to sw encryption; low-level driver sets these if the
-		 * requested encryption is supported */
-		key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
-		key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-
-		key->conf.alg = alg;
-		key->conf.keyidx = idx;
-		key->conf.keylen = key_len;
-		memcpy(key->conf.key, _key, key_len);
-
-		if (alg == ALG_CCMP) {
-			/* Initialize AES key state here as an optimization
-			 * so that it does not need to be initialized for every
-			 * packet. */
-			key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(
-				key->conf.key);
-			if (!key->u.ccmp.tfm) {
-				ret = -ENOMEM;
-				goto err_free;
-			}
-		}
-
-		if (set_tx_key || sdata->default_key == old_key) {
-			ieee80211_debugfs_key_remove_default(sdata);
-			sdata->default_key = NULL;
-		}
-		ieee80211_debugfs_key_remove(old_key);
-		if (sta)
-			sta->key = key;
-		else
-			sdata->keys[idx] = key;
-		ieee80211_key_free(old_key);
-		ieee80211_debugfs_key_add(local, key);
-		if (sta)
-			ieee80211_debugfs_key_sta_link(key, sta);
-
-		if (try_hwaccel &&
-		    (alg == ALG_WEP || alg == ALG_TKIP || alg == ALG_CCMP)) {
-			int e = ieee80211_set_hw_encryption(dev, sta, sta_addr,
-							    key);
-			if (err)
-				*err = e;
-		}
 	}
 
-	if (set_tx_key || (!sta && !sdata->default_key && key)) {
-		sdata->default_key = key;
-		if (key)
-			ieee80211_debugfs_key_add_default(sdata);
-
-		if (local->ops->set_key_idx &&
-		    local->ops->set_key_idx(local_to_hw(local), idx))
-			printk(KERN_DEBUG "%s: failed to set TX key idx for "
-			       "low-level driver\n", dev->name);
-	}
-
-	if (sta)
-		sta_info_put(sta);
-
-	return 0;
+	if (set_tx_key || (!sta && !sdata->default_key && key))
+		ieee80211_set_default_key(sdata, idx);
 
-err_free:
-	ieee80211_key_free(key);
-err_out:
+	ret = 0;
+ err_out:
 	if (sta)
 		sta_info_put(sta);
 	return ret;
@@ -662,7 +491,6 @@ static int ieee80211_ioctl_set_encryptio
 		}
 		alg = ALG_CCMP;
 	} else {
-		param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ALG;
 		printk(KERN_DEBUG "%s: set_encrypt - unknown alg\n",
 		       dev->name);
 		return -EINVAL;
@@ -672,7 +500,7 @@ static int ieee80211_ioctl_set_encryptio
 		dev, param->sta_addr,
 		param->u.crypt.idx, alg,
 		param->u.crypt.flags & HOSTAP_CRYPT_FLAG_SET_TX_KEY,
-		&param->u.crypt.err, param->u.crypt.key,
+		param->u.crypt.key,
 		param->u.crypt.key_len);
 }
 
@@ -684,7 +512,7 @@ static int ieee80211_ioctl_get_encryptio
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int ret = 0;
 	struct sta_info *sta;
-	struct ieee80211_key **key;
+	struct ieee80211_key *key;
 	int max_key_len;
 	struct ieee80211_sub_if_data *sdata;
 	u8 *pos;
@@ -705,24 +533,22 @@ static int ieee80211_ioctl_get_encryptio
 				sdata->default_key->conf.keyidx : 0;
 			return 0;
 		} else
-			key = &sdata->keys[param->u.crypt.idx];
+			key = sdata->keys[param->u.crypt.idx];
 	} else {
 		sta = sta_info_get(local, param->sta_addr);
-		if (!sta) {
-			param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
+		if (!sta)
 			return -EINVAL;
-		}
 
-		key = &sta->key;
+		key = sta->key;
 	}
 
 	memset(param->u.crypt.seq_counter, 0, HOSTAP_SEQ_COUNTER_SIZE);
-	if (!*key) {
+	if (!key) {
 		memcpy(param->u.crypt.alg, "none", 5);
 		param->u.crypt.key_len = 0;
 		param->u.crypt.idx = 0xff;
 	} else {
-		switch ((*key)->conf.alg) {
+		switch (key->conf.alg) {
 		case ALG_WEP:
 			memcpy(param->u.crypt.alg, "WEP", 4);
 			break;
@@ -737,7 +563,7 @@ static int ieee80211_ioctl_get_encryptio
 				if (local->ops->get_sequence_counter(
 						local_to_hw(local),
 						param->sta_addr,
-						(*key)->conf.keyidx,
+						key->conf.keyidx,
 						IEEE80211_SEQ_COUNTER_TX,
 						&iv32,
 						&iv16)) {
@@ -746,8 +572,8 @@ static int ieee80211_ioctl_get_encryptio
 				}
 			} else {
 				/* Get it from our own local data */
-				iv32 = (*key)->u.tkip.iv32;
-				iv16 = (*key)->u.tkip.iv16;
+				iv32 = key->u.tkip.iv32;
+				iv16 = key->u.tkip.iv16;
 			}
 			pos = param->u.crypt.seq_counter;
 			*pos++ = iv16 & 0xff;
@@ -763,7 +589,7 @@ static int ieee80211_ioctl_get_encryptio
 			u8 *pn;
 			memcpy(param->u.crypt.alg, "CCMP", 5);
 			pos = param->u.crypt.seq_counter;
-			pn = (*key)->u.ccmp.tx_pn;
+			pn = key->u.ccmp.tx_pn;
 			*pos++ = pn[5];
 			*pos++ = pn[4];
 			*pos++ = pn[3];
@@ -777,12 +603,12 @@ static int ieee80211_ioctl_get_encryptio
 			break;
 		}
 
-		if (max_key_len < (*key)->conf.keylen)
+		if (max_key_len < key->conf.keylen)
 			ret = -E2BIG;
 		else {
-			param->u.crypt.key_len = (*key)->conf.keylen;
-			memcpy(param->u.crypt.key, (*key)->conf.key,
-			       (*key)->conf.keylen);
+			param->u.crypt.key_len = key->conf.keylen;
+			memcpy(param->u.crypt.key, key->conf.key,
+			       key->conf.keylen);
 		}
 	}
 
@@ -1749,95 +1575,6 @@ static int ieee80211_ioctl_giwretry(stru
 	return 0;
 }
 
-static void ieee80211_key_enable_hwaccel(struct ieee80211_local *local,
-					 struct ieee80211_key *key)
-{
-	u8 addr[ETH_ALEN];
-
-	if (!key || key->conf.alg != ALG_WEP ||
-	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ||
-	    (local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP))
-		return;
-
-	memset(addr, 0xff, ETH_ALEN);
-
-	if (local->ops->set_key)
-	    local->ops->set_key(local_to_hw(local),
-				SET_KEY, addr, &key->conf,
-				local->default_wep_only);
-}
-
-
-static void ieee80211_key_disable_hwaccel(struct ieee80211_local *local,
-					  struct ieee80211_key *key)
-{
-	u8 addr[ETH_ALEN];
-
-	if (!key || key->conf.alg != ALG_WEP ||
-	    (key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ||
-	    (local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP))
-		return;
-
-	memset(addr, 0xff, ETH_ALEN);
-	if (local->ops->set_key)
-		local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-				    addr, &key->conf,
-				    local->default_wep_only);
-	key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-}
-
-
-static int ieee80211_ioctl_default_wep_only(struct ieee80211_local *local,
-					    int value)
-{
-	int i;
-	struct ieee80211_sub_if_data *sdata;
-
-	local->default_wep_only = value;
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list)
-		for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-			if (value)
-				ieee80211_key_enable_hwaccel(local,
-							     sdata->keys[i]);
-			else
-				ieee80211_key_disable_hwaccel(local,
-							      sdata->keys[i]);
-	read_unlock(&local->sub_if_lock);
-
-	return 0;
-}
-
-
-void ieee80211_update_default_wep_only(struct ieee80211_local *local)
-{
-	int i = 0;
-	struct ieee80211_sub_if_data *sdata;
-
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list) {
-
-		if (sdata->dev == local->mdev)
-			continue;
-
-		/* If there is an AP interface then depend on userspace to
-		   set default_wep_only correctly. */
-		if (sdata->type == IEEE80211_IF_TYPE_AP) {
-			read_unlock(&local->sub_if_lock);
-			return;
-		}
-
-		i++;
-	}
-
-	read_unlock(&local->sub_if_lock);
-
-	if (i <= 1)
-		ieee80211_ioctl_default_wep_only(local, 1);
-	else
-		ieee80211_ioctl_default_wep_only(local, 0);
-}
-
 
 static int ieee80211_ioctl_prism2_param(struct net_device *dev,
 					struct iw_request_info *info,
@@ -2092,12 +1829,7 @@ static int ieee80211_ioctl_siwencode(str
 		alg = ALG_NONE;
 	else if (erq->length == 0) {
 		/* No key data - just set the default TX key index */
-		if (sdata->default_key != sdata->keys[idx]) {
-			ieee80211_debugfs_key_remove_default(sdata);
-			sdata->default_key = sdata->keys[idx];
-			if (sdata->default_key)
-				ieee80211_debugfs_key_add_default(sdata);
-		}
+		ieee80211_set_default_key(sdata, idx);
 		return 0;
 	}
 
@@ -2105,7 +1837,7 @@ static int ieee80211_ioctl_siwencode(str
 		dev, bcaddr,
 		idx, alg,
 		!sdata->default_key,
-		NULL, keybuf, erq->length);
+		keybuf, erq->length);
 }
 
 
@@ -2308,7 +2040,7 @@ static int ieee80211_ioctl_siwencodeext(
 	return ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
 					ext->ext_flags &
 					IW_ENCODE_EXT_SET_TX_KEY,
-					NULL, ext->key, ext->key_len);
+					ext->key, ext->key_len);
 }
 
 
--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-08-16 13:38:06.033471955 +0200
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-08-16 14:09:43.663471955 +0200
@@ -11,7 +11,7 @@
 #define IEEE80211_KEY_H
 
 #include <linux/types.h>
-#include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/crypto.h>
 #include <net/mac80211.h>
 
@@ -41,8 +41,20 @@
 
 #define NUM_RX_DATA_QUEUES 17
 
+struct ieee80211_local;
+struct ieee80211_sub_if_data;
+struct sta_info;
+
+#define KEY_FLAG_UPLOADED_TO_HARDWARE	(1<<0)
+
 struct ieee80211_key {
-	struct kref kref;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+
+	struct list_head list;
+
+	unsigned int flags;
 
 	union {
 		struct {
@@ -99,4 +111,16 @@ struct ieee80211_key {
 	struct ieee80211_key_conf conf;
 };
 
+struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
+					  struct sta_info *sta,
+					  ieee80211_key_alg alg,
+					  int idx,
+					  size_t key_len,
+					  const u8 *key_data);
+void ieee80211_key_free(struct ieee80211_key *key);
+void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
+void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
+void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
+
 #endif /* IEEE80211_KEY_H */
--- wireless-dev.orig/net/mac80211/key.c	2007-08-16 13:38:06.063471955 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-16 14:11:03.443471955 +0200
@@ -2,42 +2,318 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
 
+#include <linux/if_ether.h>
+#include <linux/etherdevice.h>
+#include <linux/list.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "debugfs_key.h"
 #include "aes_ccm.h"
 
+
+/*
+ * Key handling basics
+ *
+ * Key handling in mac80211 is done based on per-interface (sub_if_data)
+ * keys and per-station keys. Since each station belongs to an interface,
+ * each station key also belongs to that interface.
+ *
+ * Hardware acceleration is done on a best-effort basis, for each key
+ * that is eligible the hardware is asked to enable that key but if
+ * it cannot do that they key is simply kept for software encryption.
+ * There is currently no way of knowing this except by looking into
+ * debugfs.
+ */
+
+static u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+
+static void ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
+{
+	u8 *addr = bcast_addr;
+	int ret;
+
+	if (key->local->ops->set_key) {
+		int try_hwaccel = 1;
+
+		/*
+		 * XXX: with the new local_mac feature most of this
+		 * can probably go. Also, we should probably remove the
+		 * IEEE80211_HW_NO_TKIP_WMM_HWACCEL flag and instead tell drivers
+		 * with each key whether WMM might be enabled.
+		 */
+
+		/* FIX:
+		 * Cannot configure default hwaccel keys with WEP algorithm, if
+		 * any of the virtual interfaces is using static WEP
+		 * configuration because hwaccel would otherwise try to decrypt
+		 * these frames.
+		 *
+		 * For now, just disable WEP hwaccel for broadcast when there is
+		 * possibility of conflict with default keys. This can maybe later be
+		 * optimized by using non-default keys (at least with Atheros ar521x).
+		 */
+		if (!key->sta && key->conf.alg == ALG_WEP &&
+		    key->sdata->type != IEEE80211_IF_TYPE_IBSS &&
+		    key->sdata->type != IEEE80211_IF_TYPE_AP) {
+			try_hwaccel = 0;
+		}
+
+		if (key->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP) {
+			/*
+			 * Software encryption cannot be used with devices that
+			 * hide encryption from the host system, so always try
+			 * to use hardware acceleration with such devices.
+			 */
+			try_hwaccel = 1;
+		}
+
+		if ((key->local->hw.flags & IEEE80211_HW_NO_TKIP_WMM_HWACCEL) &&
+		    key->conf.alg == ALG_TKIP) {
+			if (key->sta && (key->sta->flags & WLAN_STA_WME)) {
+				/*
+				 * Hardware does not support hwaccel
+				 * with TKIP when using WMM.
+				 */
+				try_hwaccel = 0;
+			}
+			else if (key->sdata->type == IEEE80211_IF_TYPE_STA) {
+				struct sta_info *sta;
+				sta = sta_info_get(key->local,
+						   key->sdata->u.sta.bssid);
+				if (sta) {
+					if (sta->flags & WLAN_STA_WME)
+						try_hwaccel = 0;
+					sta_info_put(sta);
+				}
+			}
+		}
+
+		if (!try_hwaccel)
+			return;
+
+		if (key->sta)
+			addr = key->sta->addr;
+		ret = key->local->ops->set_key(local_to_hw(key->local),
+					       SET_KEY,
+					       key->sdata->dev->dev_addr,
+					       addr, &key->conf);
+
+		WARN_ON(!ret && (key->conf.hw_key_idx == HW_KEY_IDX_INVALID));
+
+		if (!ret)
+			key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+		if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
+			printk(KERN_ERR "mac80211-%s: failed to set key "
+			       "(%d, " MAC_FMT ") to hardware (%d)\n",
+			       wiphy_name(key->local->hw.wiphy),
+			       key->conf.keyidx, MAC_ARG(addr), ret);
+	}
+}
+
+static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
+{
+	u8 *addr = bcast_addr;
+	int ret;
+
+	if (key->local->ops->set_key &&
+	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+		if (key->sta)
+			addr = key->sta->addr;
+		ret = key->local->ops->set_key(local_to_hw(key->local),
+					       DISABLE_KEY,
+					       key->sdata->dev->dev_addr,
+					       addr, &key->conf);
+		if (ret)
+			printk(KERN_ERR "mac80211-%s: failed to remove key "
+			       "(%d, " MAC_FMT ") from hardware (%d)\n",
+			       wiphy_name(key->local->hw.wiphy),
+			       key->conf.keyidx, MAC_ARG(addr), ret);
+
+		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+		key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
+	}
+}
+
+/*
+ * driver notifying us that it removed a key from hw accel,
+ * set the software key flag.
+ */
+void ieee80211_key_removed(struct ieee80211_key_conf *conf)
+{
+	struct ieee80211_key *key = container_of(conf, struct ieee80211_key,
+						 conf);
+
+	WARN_ON(!conf);
+	if (!conf)
+		return;
+
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
+}
+
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
-					  int idx, size_t key_len, gfp_t flags)
+					  struct sta_info *sta,
+					  ieee80211_key_alg alg,
+					  int idx,
+					  size_t key_len,
+					  const u8 *key_data)
 {
 	struct ieee80211_key *key;
 
-	key = kzalloc(sizeof(struct ieee80211_key) + key_len, flags);
+	BUG_ON(alg == ALG_NONE);
+
+	key = kzalloc(sizeof(struct ieee80211_key) + key_len, GFP_KERNEL);
 	if (!key)
 		return NULL;
-	kref_init(&key->kref);
+
+	/*
+	 * Default to software encryption; we'll later upload the
+	 * key to the hardware if possible.
+	 */
+	key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
+	key->flags = 0;
+
+	key->conf.alg = alg;
+	key->conf.keyidx = idx;
+	key->conf.keylen = key_len;
+	memcpy(key->conf.key, key_data, key_len);
+
+	key->local = sdata->local;
+	key->sdata = sdata;
+	key->sta = sta;
+
+	if (alg == ALG_CCMP) {
+		/*
+		 * Initialize AES key state here as an optimization so that
+		 * it does not need to be initialized for every packet.
+		 */
+		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(key_data);
+		if (!key->u.ccmp.tfm) {
+			ieee80211_key_free(key);
+			return NULL;
+		}
+	}
+
+	ieee80211_debugfs_key_add(key->local, key);
+
+	if (sta) {
+		ieee80211_debugfs_key_sta_link(key, sta);
+		sta->key = key;
+	} else {
+		if (idx >= 0 && idx < NUM_DEFAULT_KEYS) {
+			if (!sdata->keys[idx])
+				sdata->keys[idx] = key;
+			else
+				WARN_ON(1);
+		} else
+			WARN_ON(1);
+	}
+
+	list_add(&key->list, &sdata->key_list);
+
+	if (netif_running(key->sdata->dev))
+		ieee80211_key_enable_hw_accel(key);
+
 	return key;
 }
 
-static void ieee80211_key_release(struct kref *kref)
+static void __ieee80211_key_free(struct ieee80211_key *key)
 {
-	struct ieee80211_key *key;
+	if (!key)
+		return;
+
+	ieee80211_key_disable_hw_accel(key);
+
+	if (key->sta) {
+		key->sta->key = NULL;
+	} else {
+		if (key->sdata->default_key == key)
+			ieee80211_set_default_key(key->sdata, -1);
+		if (key->conf.keyidx >= 0 &&
+		    key->conf.keyidx < NUM_DEFAULT_KEYS)
+			key->sdata->keys[key->conf.keyidx] = NULL;
+		else
+			WARN_ON(1);
+	}
 
-	key = container_of(kref, struct ieee80211_key, kref);
 	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	ieee80211_debugfs_key_remove(key);
+
+	list_del(&key->list);
+
 	kfree(key);
 }
 
 void ieee80211_key_free(struct ieee80211_key *key)
 {
-	if (key)
-		kref_put(&key->kref, ieee80211_key_release);
+	if (!key)
+		return;
+
+	mutex_lock(&key->sdata->key_mtx);
+	__ieee80211_key_free(key);
+	mutex_unlock(&key->sdata->key_mtx);
+}
+
+void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx)
+{
+	struct ieee80211_key *key = NULL;
+
+	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
+		key = sdata->keys[idx];
+
+	if (sdata->default_key != key) {
+		ieee80211_debugfs_key_remove_default(sdata);
+
+		sdata->default_key = key;
+
+		if (sdata->default_key)
+			ieee80211_debugfs_key_add_default(sdata);
+
+		if (sdata->local->ops->set_key_idx)
+			sdata->local->ops->set_key_idx(
+				local_to_hw(sdata->local), idx);
+	}
+}
+
+void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_key *key, *tmp;
+
+	mutex_lock(&sdata->key_mtx);
+	list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
+		__ieee80211_key_free(key);
+	mutex_unlock(&sdata->key_mtx);
+}
+
+void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_key *key;
+
+	WARN_ON(!netif_running(sdata->dev));
+	if (!netif_running(sdata->dev))
+		return;
+
+	mutex_lock(&sdata->key_mtx);
+	list_for_each_entry(key, &sdata->key_list, list)
+		ieee80211_key_enable_hw_accel(key);
+	mutex_unlock(&sdata->key_mtx);
+}
+
+void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_key *key;
+
+	mutex_lock(&sdata->key_mtx);
+	list_for_each_entry(key, &sdata->key_list, list)
+		ieee80211_key_disable_hw_accel(key);
+	mutex_unlock(&sdata->key_mtx);
 }
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-16 13:38:06.533471955 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-16 13:45:40.803471955 +0200
@@ -2758,9 +2758,8 @@ static int b43_dev_config(struct ieee802
 }
 
 static int b43_dev_set_key(struct ieee80211_hw *hw,
-			   set_key_cmd cmd,
-			   u8 * addr, struct ieee80211_key_conf *key,
-			   int static_wep_only)
+			   set_key_cmd cmd, u8 *local_addr,
+			   u8 * addr, struct ieee80211_key_conf *key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -2769,7 +2768,6 @@ static int b43_dev_set_key(struct ieee80
 	u8 index;
 	int err = -EINVAL;
 
-	key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
 	if (!dev)
 		return -ENODEV;
 	switch (key->alg) {
@@ -2807,11 +2805,10 @@ static int b43_dev_set_key(struct ieee80
 
 	switch (cmd) {
 	case SET_KEY:
-		key->flags &= ~IEEE80211_KEY_FORCE_SW_ENCRYPT;
-
 		if (algorithm == B43_SEC_ALGO_TKIP) {
 			/* FIXME: No TKIP hardware encryption for now. */
-			key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+			err = -EOPNOTSUPP;
+			goto out_unlock;
 		}
 
 		if (is_broadcast_ether_addr(addr)) {
@@ -2822,10 +2819,8 @@ static int b43_dev_set_key(struct ieee80
 			err = b43_key_write(dev, -1, algorithm,
 					    key->key, key->keylen, addr, key);
 		}
-		if (err) {
-			key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+		if (err)
 			goto out_unlock;
-		}
 		dev->key[key->hw_key_idx].enabled = 1;
 
 		if (algorithm == B43_SEC_ALGO_WEP40 ||
@@ -2852,10 +2847,6 @@ static int b43_dev_set_key(struct ieee80
 		dev->key[key->hw_key_idx].enabled = 0;
 		break;
 	}
-	case REMOVE_ALL_KEYS:
-		b43_clear_keys(dev);
-		err = 0;
-		break;
 	default:
 		B43_WARN_ON(1);
 	}
@@ -2864,10 +2855,10 @@ out_unlock:
 	mutex_unlock(&wl->mutex);
 out:
 	if (!err) {
-		bcmdbg(wl, "Using %s based encryption for keyidx: %d, "
+		bcmdbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: " MAC_FMT "\n",
-		       (key->flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ?
-		       "software" : "hardware", key->keyidx, MAC_ARG(addr));
+		       cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
+		       MAC_ARG(addr));
 	}
 	return err;
 }
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-16 13:38:06.573471955 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-16 13:45:40.813471955 +0200
@@ -7879,8 +7879,9 @@ static int iwl_mac_hw_scan(struct ieee80
 	return rc;
 }
 
-static int iwl_mac_set_key(struct ieee80211_hw *hw, set_key_cmd cmd, u8 *addr,
-			   struct ieee80211_key_conf *key, int static_wep_only)
+static int iwl_mac_set_key(struct ieee80211_hw *hw, set_key_cmd cmd,
+			   u8 *local_addr, u8 *addr,
+			   struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
 	int rc = 0;
@@ -7897,7 +7898,7 @@ static int iwl_mac_set_key(struct ieee80
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211("leave - " MAC_FMT
 				   " not in station map.\n", MAC_ARG(addr));
-		return -EINVAL;
+		return -ENOSPC;
 	}
 
 	mutex_lock(&priv->mutex);
@@ -7910,8 +7911,6 @@ static int iwl_mac_set_key(struct ieee80
 	if (!rc) {
 		iwl_set_rxon_hwcrypto(priv, 1);
 		iwl_commit_rxon(priv);
-		key->flags &= (u32)
-			(~IEEE80211_KEY_FORCE_SW_ENCRYPT);
 		key->hw_key_idx = sta_id;
 		/* TODO do we need below */
 		/*
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-08-16 13:38:06.123471955 +0200
+++ wireless-dev/net/mac80211/sta_info.c	2007-08-16 13:45:40.813471955 +0200
@@ -19,7 +19,6 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "sta_info.h"
-#include "debugfs_key.h"
 #include "debugfs_sta.h"
 
 /* Caller must hold local->sta_lock */
@@ -144,8 +143,6 @@ static void sta_info_release(struct kref
 	}
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
-	if (sta->key)
-		ieee80211_debugfs_key_sta_del(sta->key, sta);
 	kfree(sta);
 }
 
@@ -191,7 +188,6 @@ struct sta_info * sta_info_add(struct ie
 		local->ops->sta_table_notification(local_to_hw(local),
 						  local->num_sta);
 	write_unlock_bh(&local->sta_lock);
-	sta->key_idx_compression = HW_KEY_IDX_INVALID;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Added STA " MAC_FMT "\n",
@@ -252,35 +248,13 @@ void sta_info_free(struct sta_info *sta)
 		dev_kfree_skb(skb);
 	}
 
-	if (sta->key) {
-		if (local->ops->set_key) {
-			local->ops->set_key(local_to_hw(local),
-					   DISABLE_KEY, sta->addr,
-					   &sta->key->conf,
-					   local->default_wep_only);
-		}
-	} else if (sta->key_idx_compression != HW_KEY_IDX_INVALID) {
-		struct ieee80211_key_conf conf;
-		memset(&conf, 0, sizeof(conf));
-		conf.hw_key_idx = sta->key_idx_compression;
-		conf.alg = ALG_NONE;
-		conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-		local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-				    sta->addr, &conf,
-				    local->default_wep_only);
-		sta->key_idx_compression = HW_KEY_IDX_INVALID;
-	}
-
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
 	       local->mdev->name, MAC_ARG(sta->addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-	if (sta->key) {
-		ieee80211_debugfs_key_remove(sta->key);
-		ieee80211_key_free(sta->key);
-		sta->key = NULL;
-	}
+	ieee80211_key_free(sta->key);
+	sta->key = NULL;
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-08-16 13:38:06.143471955 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-08-16 13:45:40.813471955 +0200
@@ -60,7 +60,6 @@ static const struct file_operations sta_
 		STA_OPS(name)
 
 STA_FILE(aid, aid, D);
-STA_FILE(key_idx_compression, key_idx_compression, D);
 STA_FILE(dev, dev->name, S);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-08-16 13:38:06.173471955 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-08-16 13:45:40.813471955 +0200
@@ -91,10 +91,6 @@ struct sta_info {
 	int channel_use;
 	int channel_use_raw;
 
-	int key_idx_compression; /* key table index for compression and TX
-				  * filtering; used only if sta->key is not
-				  * set */
-
 	unsigned int assoc_ap:1; /* whether this is an AP that we are
 				  * associated with as a client */
 	unsigned int dls_sta:1; /* whether this stations is a DLS peer of us */
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-16 13:38:06.243471955 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-16 14:11:30.563471955 +0200
@@ -425,10 +425,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 static ieee80211_txrx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
-	if (tx->sta)
-		tx->u.tx.control->key_idx = tx->sta->key_idx_compression;
-	else
-		tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
+	tx->u.tx.control->key_idx = HW_KEY_IDX_INVALID;
 
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
@@ -538,7 +535,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 
 static int wep_encrypt_skb(struct ieee80211_txrx_data *tx, struct sk_buff *skb)
 {
-	if (tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) {
+	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
@@ -831,7 +828,7 @@ __ieee80211_parse_tx_radiotap(
 	 */
 
 	control->retry_limit = 1; /* no retry */
-	control->key_idx = -1; /* no encryption key */
+	control->key_idx = HW_KEY_IDX_INVALID;
 	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 			    IEEE80211_TXCTL_USE_CTS_PROTECT);
 	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT |
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-16 13:38:06.283471955 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-16 13:45:40.823471955 +0200
@@ -25,6 +25,9 @@ void ieee80211_if_sdata_init(struct ieee
 	sdata->eapol = 1;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
 		skb_queue_head_init(&sdata->fragments[i].skb_list);
+
+	mutex_init(&sdata->key_mtx);
+	INIT_LIST_HEAD(&sdata->key_list);
 }
 
 static void ieee80211_if_sdata_deinit(struct ieee80211_sub_if_data *sdata)
@@ -88,8 +91,6 @@ int ieee80211_if_add(struct net_device *
 		*new_dev = ndev;
 	write_unlock_bh(&local->sub_if_lock);
 
-	ieee80211_update_default_wep_only(local);
-
 	return 0;
 
 fail:
@@ -154,7 +155,6 @@ void ieee80211_if_del_mgmt(struct ieee80
 void ieee80211_if_set_type(struct net_device *dev, int type)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int oldtype = sdata->type;
 
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
@@ -220,7 +220,6 @@ void ieee80211_if_set_type(struct net_de
 		       dev->name, __FUNCTION__, type);
 	}
 	ieee80211_debugfs_change_if_type(sdata, oldtype);
-	ieee80211_update_default_wep_only(local);
 }
 
 /* Must be called with rtnl lock held. */
@@ -232,21 +231,14 @@ void ieee80211_if_reinit(struct net_devi
 	int i;
 
 	ASSERT_RTNL();
+
+	ieee80211_free_keys(sdata);
+
 	ieee80211_if_sdata_deinit(sdata);
+
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-		if (!sdata->keys[i])
-			continue;
-#if 0
-		/* The interface is down at the moment, so there is not
-		 * really much point in disabling the keys at this point. */
-		memset(addr, 0xff, ETH_ALEN);
-		if (local->ops->set_key)
-			local->ops->set_key(local_to_hw(local), DISABLE_KEY, addr,
-					    local->keys[i],
-					    local->default_wep_only);
-#endif
 		ieee80211_key_free(sdata->keys[i]);
-		sdata->keys[i] = NULL;
+		WARN_ON(sdata->keys[i]);
 	}
 
 	switch (sdata->type) {
@@ -351,7 +343,6 @@ int ieee80211_if_remove(struct net_devic
 			list_del(&sdata->list);
 			write_unlock_bh(&local->sub_if_lock);
 			__ieee80211_if_del(local, sdata);
-			ieee80211_update_default_wep_only(local);
 			return 0;
 		}
 	}
--- wireless-dev.orig/include/net/mac80211.h	2007-08-16 13:38:06.633471955 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-16 14:21:40.823471955 +0200
@@ -404,11 +404,13 @@ struct ieee80211_key_conf {
 
 	int keylen;
 
-#define IEEE80211_KEY_FORCE_SW_ENCRYPT (1<<0) /* to be cleared by low-level
-						 driver */
-	u32 flags; /* key configuration flags defined above */
+	/*
+	 * for use by the driver, named this way to avoid
+	 * accidental use in the stack
+	 */
+	struct list_head driver_keylist;
 
-	s8 keyidx;			/* WEP key index */
+	s8 keyidx;
 	u8 key[0];
 };
 
@@ -416,7 +418,7 @@ struct ieee80211_key_conf {
 #define IEEE80211_SEQ_COUNTER_TX	1
 
 typedef enum {
-	SET_KEY, DISABLE_KEY, REMOVE_ALL_KEYS,
+	SET_KEY, DISABLE_KEY,
 } set_key_cmd;
 
 /* This is driver-visible part of the per-hw state the stack keeps. */
@@ -675,12 +677,35 @@ struct ieee80211_ops {
 	 * This is called to enable hardware acceleration of encryption and
 	 * decryption. The address will be the broadcast address for default
 	 * keys and the other station's hardware address for individual keys.
+	 *
+	 * The local_address parameter will always be set to our own address,
+	 * this is only relevant if you support multiple local addresses.
+	 *
 	 * When transmitting, the TX control data will use the hw_key_idx
 	 * selected by the low-level driver.
+	 *
+	 * If you support multiple MAC addresses but only hardware acceleration
+	 * based on the transmitter address, you should keep a list of all
+	 * keys that are currently enabled (use the key conf's driver_keylist
+	 * member) and call ieee80211_key_removed() for all keys that you had
+	 * to remove.
+	 * Note that you should only do that if you're unable to use the key
+	 * for transmission afterwards, if you only disabled it for reception
+	 * you should not call ieee80211_key_removed() because that will also
+	 * remove the key for transmission.
+	 *
+	 * Return 0 if the key is now in use, -EOPNOTSUPP or -ENOSPC if it
+	 * couldn't be added; if you return 0 then hw_key_idx must be
+	 * assigned to something other than HW_KEY_IDX_INVALID. When the cmd
+	 * is DISABLE_KEY then it must succeed.
+	 *
+	 * This callback can sleep, and is only called between add_interface
+	 * and remove_interface calls, i.e. while the interface with the
+	 * given local_address is enabled.
 	 */
 	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
-		       u8 *address, struct ieee80211_key_conf *key,
-		       int static_wep_only);
+		       u8 *local_address, u8 *address,
+		       struct ieee80211_key_conf *key);
 
 	/*
 	 * Set TX key index for default/broadcast keys. This is needed in cases
@@ -688,6 +713,10 @@ struct ieee80211_ops {
 	 * is not set), in other cases, this function pointer can be set to
 	 * NULL since the IEEE 802.11 module takes care of selecting the key
 	 * index for each TX frame.
+	 *
+	 * TODO: If you use this callback in your driver tell us if you need
+	 *	 any other information from it to make it easier, like the
+	 *	 key_conf instead.
 	 */
 	int (*set_key_idx)(struct ieee80211_hw *hw, int idx);
 
@@ -1081,6 +1110,19 @@ ieee80211_get_mc_list_item(struct ieee80
 			   struct dev_mc_list *prev,
 			   void **ptr);
 
+/**
+ * ieee80211_key_removed - the driver removed a key from hardware accel
+ *
+ * @keyconf: The key config structure for the key that was removed.
+ *
+ * Call this function if for some reason you had to remove a key
+ * from the hardware acceleration completely.
+ * Note that after calling this function you will not get a
+ * DISABLE_KEY notification via set_key() any more for this key,
+ * it is assumed that you've removed it already.
+ */
+void ieee80211_key_removed(struct ieee80211_key_conf *keyconf);
+
 /* called by driver to notify scan status completed */
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
 
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-16 13:38:06.333471955 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-16 14:10:17.933471955 +0200
@@ -428,6 +428,7 @@ static int ieee80211_open(struct net_dev
 
 		ieee80211_if_config(dev);
 		ieee80211_reset_erp_info(dev);
+		ieee80211_enable_keys(sdata);
 
 		if (sdata->type == IEEE80211_IF_TYPE_STA &&
 		    !local->user_space_mlme)
@@ -466,6 +467,9 @@ static int ieee80211_stop(struct net_dev
 
 	local->open_count--;
 
+	/* disable all keys for as long as this netdev is down */
+	ieee80211_disable_keys(sdata);
+
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_MNTR:
 		local->monitors--;
@@ -862,7 +866,7 @@ static void ieee80211_remove_tx_extra(st
 	}
 
 	if (skb->len >= mic_len &&
-	    (key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT))
+	    !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		skb_trim(skb, skb->len - mic_len);
 	if (skb->len >= iv_len && skb->len > hdrlen) {
 		memmove(skb->data + iv_len, skb->data, hdrlen);
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-16 13:38:06.363471955 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-16 14:11:22.353471955 +0200
@@ -525,7 +525,7 @@ ieee80211_rx_h_wep_weak_iv_detection(str
 
 	/* Check for weak IVs, if hwaccel did not remove IV from the frame */
 	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) ||
-	    (rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT))
+	    !(rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		if (ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 			rx->sta->wep_weak_iv_count++;
 
@@ -554,7 +554,7 @@ ieee80211_rx_h_wep_decrypt(struct ieee80
 	}
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED) ||
-	    (rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
+	    !(rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-16 13:38:06.403471955 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-16 14:13:02.743471955 +0200
@@ -101,7 +101,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	}
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
+	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !tx->fragmented &&
 	    !(tx->local->hw.flags & IEEE80211_HW_TKIP_INCLUDE_MMIC) &&
 	    !wpa_test) {
@@ -183,7 +183,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !(rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
+	    (rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		if (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
 			if (skb->len < MICHAEL_MIC_LEN)
 				return TXRX_DROP;
@@ -269,10 +269,10 @@ static int tkip_encrypt_skb(struct ieee8
 	hdrlen = ieee80211_get_hdrlen(fc);
 	len = skb->len - hdrlen;
 
-	if (tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)
-		tailneed = TKIP_ICV_LEN;
-	else
+	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 		tailneed = 0;
+	else
+		tailneed = TKIP_ICV_LEN;
 
 	if ((skb_headroom(skb) < TKIP_IV_LEN ||
 	     skb_tailroom(skb) < tailneed)) {
@@ -305,7 +305,7 @@ iv_inc:
 skip_iv_inc:
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)
+	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	    && !tx->wpa_test
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
@@ -399,7 +399,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 	}
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
+	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for IV/ICV */
@@ -478,7 +478,7 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
+	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
 			/* Hardware takes care of all processing, including
 			 * replay protection, so no need to continue here. */
@@ -622,10 +622,10 @@ static int ccmp_encrypt_skb(struct ieee8
 	hdrlen = ieee80211_get_hdrlen(fc);
 	len = skb->len - hdrlen;
 
-	if (key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)
-		tailneed = CCMP_MIC_LEN;
-	else
+	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 		tailneed = 0;
+	else
+		tailneed = CCMP_MIC_LEN;
 
 	if ((skb_headroom(skb) < CCMP_HDR_LEN ||
 	     skb_tailroom(skb) < tailneed)) {
@@ -665,7 +665,7 @@ skip_pn_inc:
 
 	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
-	if (!(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
+	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		/* hwaccel - with preallocated room for CCMP header */
 		tx->u.tx.control->key_idx = key->conf.hw_key_idx;
 		return 0;
@@ -719,7 +719,7 @@ ieee80211_tx_h_ccmp_encrypt(struct ieee8
 	tx->u.tx.control->iv_len = CCMP_HDR_LEN;
 	ieee80211_tx_set_iswep(tx);
 
-	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
+	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
 		/* hwaccel - with no need for preallocated room for CCMP "
 		 * header or MIC fields */
@@ -771,7 +771,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 		return TXRX_DROP;
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
+	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
 		return TXRX_CONTINUE;
 
@@ -792,7 +792,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 	}
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
+	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
 		/* hwaccel has already decrypted frame and verified MIC */
 	} else {
 		u8 *scratch, *b_0, *aad;
--- wireless-dev.orig/net/mac80211/debugfs_key.c	2007-08-16 13:38:06.453471955 +0200
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-08-16 13:45:40.823471955 +0200
@@ -25,7 +25,6 @@ static ssize_t key_conf_##name##_read(st
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }
 #define KEY_CONF_READ_D(name) KEY_CONF_READ(name, 20, "%d\n")
-#define KEY_CONF_READ_X(name) KEY_CONF_READ(name, 20, "0x%x\n")
 
 #define KEY_CONF_OPS(name)						\
 static const struct file_operations key_ ##name## _ops = {		\
@@ -40,7 +39,6 @@ static const struct file_operations key_
 KEY_CONF_FILE(keylen, D);
 KEY_CONF_FILE(keyidx, D);
 KEY_CONF_FILE(hw_key_idx, D);
-KEY_CONF_FILE(flags, X);
 
 
 #define KEY_READ(name, buflen, format_string)				\
@@ -54,6 +52,7 @@ static ssize_t key_##name##_read(struct 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }
 #define KEY_READ_D(name) KEY_READ(name, 20, "%d\n")
+#define KEY_READ_X(name) KEY_READ(name, 20, "0x%x\n")
 
 #define KEY_OPS(name)							\
 static const struct file_operations key_ ##name## _ops = {		\
@@ -66,6 +65,7 @@ static const struct file_operations key_
 		 KEY_OPS(name)
 
 KEY_FILE(tx_rx_count, D);
+KEY_FILE(flags, X);
 
 
 static ssize_t key_algorithm_read(struct file *file,
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-16 13:38:06.503471955 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-16 13:45:40.833471955 +0200
@@ -166,13 +166,6 @@ struct prism2_hostapd_param {
 #define HOSTAP_CRYPT_FLAG_SET_TX_KEY BIT(0)
 #define HOSTAP_CRYPT_FLAG_PERMANENT BIT(1)
 
-#define HOSTAP_CRYPT_ERR_UNKNOWN_ALG 2
-#define HOSTAP_CRYPT_ERR_UNKNOWN_ADDR 3
-#define HOSTAP_CRYPT_ERR_CRYPT_INIT_FAILED 4
-#define HOSTAP_CRYPT_ERR_KEY_SET_FAILED 5
-#define HOSTAP_CRYPT_ERR_TX_KEY_SET_FAILED 6
-#define HOSTAP_CRYPT_ERR_CARD_CONF_FAILED 7
-
 #define HOSTAP_HW_FLAG_NULLFUNC_OK BIT(0)
 
 /* Data structures used for get_hw_features ioctl */

-- 

