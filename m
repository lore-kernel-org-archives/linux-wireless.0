Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496AbXHUQCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 12:02:23 -0400
Message-Id: <20070821160001.178017000@sipsolutions.net>
References: <20070821155725.489738000@sipsolutions.net>
Date: Tue, 21 Aug 2007 17:57:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: embed key conf in key, fix driver interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch embeds the struct ieee80211_key_conf into struct ieee80211_key
and thus avoids allocations and having data present twice.

This required some more changes:
 1) The removal of the IEEE80211_KEY_DEFAULT_TX_KEY key flag.
    This flag isn't used by drivers nor should it be since
    we have a set_key_idx() callback. Maybe that callback needs
    to be extended to include the key conf, but only a driver that
    requires it will tell.
 2) The removal of the IEEE80211_KEY_DEFAULT_WEP_ONLY key flag.
    This flag is global, so it shouldn't be passed in the key
    conf structure. Pass it to the function instead.

Also, this patch removes the AID parameter to the set_key() callback
because it is currently unused and the hardware currently cannot know
about the AID anyway. I suspect this was used with some hardware that
actually selected the AID itself, but that functionality was removed.

Additionally, I've removed the ALG_NULL key algorithm since we have
ALG_NONE.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/b43/main.c |    4 -
 drivers/net/wireless/iwl-base.c |    2 
 include/net/mac80211.h          |   51 ++++++++++--------
 net/mac80211/debugfs_key.c      |   49 +++++++++++-------
 net/mac80211/ieee80211.c        |    5 +
 net/mac80211/ieee80211_i.h      |    3 -
 net/mac80211/ieee80211_iface.c  |    3 -
 net/mac80211/ieee80211_ioctl.c  |  108 +++++++++++++++++-----------------------
 net/mac80211/ieee80211_key.h    |   20 ++-----
 net/mac80211/ieee80211_sta.c    |    2 
 net/mac80211/key.c              |   28 ----------
 net/mac80211/rx.c               |   22 +++-----
 net/mac80211/sta_info.c         |   17 ++----
 net/mac80211/tkip.c             |   18 +++---
 net/mac80211/tx.c               |    6 +-
 net/mac80211/wep.c              |   18 +++---
 net/mac80211/wpa.c              |   61 ++++++++++++----------
 17 files changed, 197 insertions(+), 220 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-21 15:17:25.805923881 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-21 16:04:26.335923881 +0200
@@ -2780,7 +2780,8 @@ static int b43_dev_config(struct ieee802
 
 static int b43_dev_set_key(struct ieee80211_hw *hw,
 			   set_key_cmd cmd,
-			   u8 * addr, struct ieee80211_key_conf *key, int aid)
+			   u8 *addr, struct ieee80211_key_conf *key,
+			   int static_wep_only)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -2794,7 +2795,6 @@ static int b43_dev_set_key(struct ieee80
 		return -ENODEV;
 	switch (key->alg) {
 	case ALG_NONE:
-	case ALG_NULL:
 		algorithm = B43_SEC_ALGO_NONE;
 		break;
 	case ALG_WEP:
--- wireless-dev.orig/include/net/mac80211.h	2007-08-21 16:02:54.745923881 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-21 16:04:26.345923881 +0200
@@ -205,8 +205,8 @@ struct ieee80211_tx_control {
 				 * is not implemented by the driver */
 	u8 power_level;		/* per-packet transmit power level, in dBm */
 	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
-	s8 key_idx;		/* -1 = do not encrypt, >= 0 keyidx from
-				 * hw->set_key() */
+	s8 key_idx;		/* HW_KEY_IDX_INVALID = do not encrypt,
+				 * other values: keyidx from hw->set_key() */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
@@ -392,26 +392,23 @@ struct ieee80211_if_conf {
 	struct ieee80211_tx_control *beacon_control;
 };
 
-typedef enum { ALG_NONE, ALG_WEP, ALG_TKIP, ALG_CCMP, ALG_NULL }
-ieee80211_key_alg;
-
+typedef enum {
+	ALG_NONE,
+	ALG_WEP,
+	ALG_TKIP,
+	ALG_CCMP,
+} ieee80211_key_alg;
 
 struct ieee80211_key_conf {
+	/* shall be changed by the driver to anything but HW_KEY_IDX_INVALID */
+	int hw_key_idx;
 
-	int hw_key_idx;			/* filled + used by low-level driver */
 	ieee80211_key_alg alg;
+
 	int keylen;
 
 #define IEEE80211_KEY_FORCE_SW_ENCRYPT (1<<0) /* to be cleared by low-level
 						 driver */
-#define IEEE80211_KEY_DEFAULT_TX_KEY   (1<<1) /* This key is the new default TX
-						 key (used only for broadcast
-						 keys). */
-#define IEEE80211_KEY_DEFAULT_WEP_ONLY (1<<2) /* static WEP is the only
-						 configured security policy;
-						 this allows some low-level
-						 drivers to determine when
-						 hwaccel can be used */
 	u32 flags; /* key configuration flags defined above */
 
 	s8 keyidx;			/* WEP key index */
@@ -628,20 +625,26 @@ struct ieee80211_ops {
 	 * Must be atomic. */
 	int (*set_tim)(struct ieee80211_hw *hw, int aid, int set);
 
-	/* Set encryption key. IEEE 802.11 module calls this function to set
-	 * encryption keys. addr is ff:ff:ff:ff:ff:ff for default keys and
-	 * station hwaddr for individual keys. aid of the station is given
-	 * to help low-level driver in selecting which key->hw_key_idx to use
-	 * for this key. TX control data will use the hw_key_idx selected by
-	 * the low-level driver. */
+	/*
+	 * Set encryption key.
+	 *
+	 * This is called to enable hardware acceleration of encryption and
+	 * decryption. The address will be the broadcast address for default
+	 * keys and the other station's hardware address for individual keys.
+	 * When transmitting, the TX control data will use the hw_key_idx
+	 * selected by the low-level driver.
+	 */
 	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
-		       u8 *addr, struct ieee80211_key_conf *key, int aid);
+		       u8 *address, struct ieee80211_key_conf *key,
+		       int static_wep_only);
 
-	/* Set TX key index for default/broadcast keys. This is needed in cases
+	/*
+	 * Set TX key index for default/broadcast keys. This is needed in cases
 	 * where wlan card is doing full WEP/TKIP encapsulation (wep_include_iv
 	 * is not set), in other cases, this function pointer can be set to
-	 * NULL since the IEEE 802. 11 module takes care of selecting the key
-	 * index for each TX frame. */
+	 * NULL since the IEEE 802.11 module takes care of selecting the key
+	 * index for each TX frame.
+	 */
 	int (*set_key_idx)(struct ieee80211_hw *hw, int idx);
 
 	/* Enable/disable IEEE 802.1X. This item requests wlan card to pass
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-21 15:59:22.725923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-21 16:04:26.375923881 +0200
@@ -278,10 +278,11 @@ static int ieee80211_ioctl_add_sta(struc
 		 * for TX filtering. */
 		memset(&conf, 0, sizeof(conf));
 		conf.hw_key_idx = HW_KEY_IDX_INVALID;
-		conf.alg = ALG_NULL;
+		conf.alg = ALG_NONE;
 		conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
 		if (local->ops->set_key(local_to_hw(local), SET_KEY,
-				       sta->addr, &conf, sta->aid)) {
+				       sta->addr, &conf,
+				       local->default_wep_only)) {
 			sta->key_idx_compression = HW_KEY_IDX_INVALID;
 		} else {
 			sta->key_idx_compression = conf.hw_key_idx;
@@ -396,31 +397,26 @@ int ieee80211_set_hw_encryption(struct n
 				struct sta_info *sta, u8 addr[ETH_ALEN],
 				struct ieee80211_key *key)
 {
-	struct ieee80211_key_conf *keyconf = NULL;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int rc = 0;
 
-	/* default to sw encryption; this will be cleared by low-level
-	 * driver if the hw supports requested encryption */
+	/*
+	 * default to sw encryption; this will be cleared by low-level
+	 * driver if the hw supports requested encryption
+	 */
 	if (key)
-		key->force_sw_encrypt = 1;
+		key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
 
-	if (key && local->ops->set_key &&
-	    (keyconf = ieee80211_key_data2conf(local, key))) {
-		if (local->ops->set_key(local_to_hw(local), SET_KEY, addr,
-				       keyconf, sta ? sta->aid : 0)) {
+	if (key && local->ops->set_key) {
+		rc = local->ops->set_key(local_to_hw(local), SET_KEY, addr,
+					 &key->conf, local->default_wep_only);
+		if (rc) {
 			rc = HOSTAP_CRYPT_ERR_KEY_SET_FAILED;
-			key->force_sw_encrypt = 1;
-			key->hw_key_idx = HW_KEY_IDX_INVALID;
-		} else {
-			key->force_sw_encrypt =
-				!!(keyconf->flags & IEEE80211_KEY_FORCE_SW_ENCRYPT);
-			key->hw_key_idx =
-				keyconf->hw_key_idx;
-
+			/* protect against buggy drivers */
+			key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+			key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
 		}
 	}
-	kfree(keyconf);
 
 	return rc;
 }
@@ -435,7 +431,6 @@ static int ieee80211_set_encryption(stru
 	struct sta_info *sta;
 	struct ieee80211_key *key, *old_key;
 	int try_hwaccel = 1;
-	struct ieee80211_key_conf *keyconf;
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -525,20 +520,18 @@ static int ieee80211_set_encryption(stru
 	}
 
 	if (alg == ALG_NONE) {
-		keyconf = NULL;
 		if (try_hwaccel && key &&
-		    key->hw_key_idx != HW_KEY_IDX_INVALID &&
+		    key->conf.hw_key_idx != HW_KEY_IDX_INVALID &&
 		    local->ops->set_key &&
-		    (keyconf = ieee80211_key_data2conf(local, key)) != NULL &&
 		    local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-				       sta_addr, keyconf, sta ? sta->aid : 0)) {
+					sta_addr, &key->conf,
+					local->default_wep_only)) {
 			if (err)
 				*err = HOSTAP_CRYPT_ERR_KEY_SET_FAILED;
 			printk(KERN_DEBUG "%s: set_encrypt - low-level disable"
 			       " failed\n", dev->name);
 			ret = -EINVAL;
 		}
-		kfree(keyconf);
 
 		if (set_tx_key || sdata->default_key == key) {
 			ieee80211_debugfs_key_remove_default(sdata);
@@ -562,22 +555,20 @@ static int ieee80211_set_encryption(stru
 
 		/* default to sw encryption; low-level driver sets these if the
 		 * requested encryption is supported */
-		key->hw_key_idx = HW_KEY_IDX_INVALID;
-		key->force_sw_encrypt = 1;
+		key->conf.hw_key_idx = HW_KEY_IDX_INVALID;
+		key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
 
-		key->alg = alg;
-		key->keyidx = idx;
-		key->keylen = key_len;
-		memcpy(key->key, _key, key_len);
-		if (set_tx_key)
-			key->default_tx_key = 1;
+		key->conf.alg = alg;
+		key->conf.keyidx = idx;
+		key->conf.keylen = key_len;
+		memcpy(key->conf.key, _key, key_len);
 
 		if (alg == ALG_CCMP) {
 			/* Initialize AES key state here as an optimization
 			 * so that it does not need to be initialized for every
 			 * packet. */
 			key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(
-				key->key);
+				key->conf.key);
 			if (!key->u.ccmp.tfm) {
 				ret = -ENOMEM;
 				goto err_free;
@@ -710,7 +701,7 @@ static int ieee80211_ioctl_get_encryptio
 		sta = NULL;
 		if (param->u.crypt.idx >= NUM_DEFAULT_KEYS) {
 			param->u.crypt.idx = sdata->default_key ?
-				sdata->default_key->keyidx : 0;
+				sdata->default_key->conf.keyidx : 0;
 			return 0;
 		} else
 			key = &sdata->keys[param->u.crypt.idx];
@@ -730,7 +721,7 @@ static int ieee80211_ioctl_get_encryptio
 		param->u.crypt.key_len = 0;
 		param->u.crypt.idx = 0xff;
 	} else {
-		switch ((*key)->alg) {
+		switch ((*key)->conf.alg) {
 		case ALG_WEP:
 			memcpy(param->u.crypt.alg, "WEP", 4);
 			break;
@@ -745,7 +736,7 @@ static int ieee80211_ioctl_get_encryptio
 				if (local->ops->get_sequence_counter(
 						local_to_hw(local),
 						param->sta_addr,
-						(*key)->keyidx,
+						(*key)->conf.keyidx,
 						IEEE80211_SEQ_COUNTER_TX,
 						&iv32,
 						&iv16)) {
@@ -785,12 +776,12 @@ static int ieee80211_ioctl_get_encryptio
 			break;
 		}
 
-		if (max_key_len < (*key)->keylen)
+		if (max_key_len < (*key)->conf.keylen)
 			ret = -E2BIG;
 		else {
-			param->u.crypt.key_len = (*key)->keylen;
-			memcpy(param->u.crypt.key, (*key)->key,
-			       (*key)->keylen);
+			param->u.crypt.key_len = (*key)->conf.keylen;
+			memcpy(param->u.crypt.key, (*key)->conf.key,
+			       (*key)->conf.keylen);
 		}
 	}
 
@@ -1824,43 +1815,38 @@ static int ieee80211_ioctl_giwretry(stru
 static void ieee80211_key_enable_hwaccel(struct ieee80211_local *local,
 					 struct ieee80211_key *key)
 {
-	struct ieee80211_key_conf *keyconf;
 	u8 addr[ETH_ALEN];
 
-	if (!key || key->alg != ALG_WEP || !key->force_sw_encrypt ||
+	if (!key || key->conf.alg != ALG_WEP ||
+	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ||
 	    (local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP))
 		return;
 
 	memset(addr, 0xff, ETH_ALEN);
-	keyconf = ieee80211_key_data2conf(local, key);
-	if (keyconf && local->ops->set_key &&
+
+	if (local->ops->set_key)
 	    local->ops->set_key(local_to_hw(local),
-			       SET_KEY, addr, keyconf, 0) == 0) {
-		key->force_sw_encrypt =
-			!!(keyconf->flags & IEEE80211_KEY_FORCE_SW_ENCRYPT);
-		key->hw_key_idx = keyconf->hw_key_idx;
-	}
-	kfree(keyconf);
+				SET_KEY, addr, &key->conf,
+				local->default_wep_only);
 }
 
 
 static void ieee80211_key_disable_hwaccel(struct ieee80211_local *local,
 					  struct ieee80211_key *key)
 {
-	struct ieee80211_key_conf *keyconf;
 	u8 addr[ETH_ALEN];
 
-	if (!key || key->alg != ALG_WEP || key->force_sw_encrypt ||
+	if (!key || key->conf.alg != ALG_WEP ||
+	    (key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ||
 	    (local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP))
 		return;
 
 	memset(addr, 0xff, ETH_ALEN);
-	keyconf = ieee80211_key_data2conf(local, key);
-	if (keyconf && local->ops->set_key)
+	if (local->ops->set_key)
 		local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-				   addr, keyconf, 0);
-	kfree(keyconf);
-	key->force_sw_encrypt = 1;
+				    addr, &key->conf,
+				    local->default_wep_only);
+	key->conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
 }
 
 
@@ -2286,9 +2272,9 @@ static int ieee80211_ioctl_giwencode(str
 		return 0;
 	}
 
-	memcpy(key, sdata->keys[idx]->key,
-	       min((int)erq->length, sdata->keys[idx]->keylen));
-	erq->length = sdata->keys[idx]->keylen;
+	memcpy(key, sdata->keys[idx]->conf.key,
+	       min((int)erq->length, sdata->keys[idx]->conf.keylen));
+	erq->length = sdata->keys[idx]->conf.keylen;
 	erq->flags |= IW_ENCODE_ENABLED;
 
 	return 0;
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-08-21 14:58:36.125923881 +0200
+++ wireless-dev/net/mac80211/sta_info.c	2007-08-21 16:04:26.375923881 +0200
@@ -254,23 +254,20 @@ void sta_info_free(struct sta_info *sta)
 
 	if (sta->key) {
 		if (local->ops->set_key) {
-			struct ieee80211_key_conf *key;
-			key = ieee80211_key_data2conf(local, sta->key);
-			if (key) {
-				local->ops->set_key(local_to_hw(local),
-						   DISABLE_KEY,
-						   sta->addr, key, sta->aid);
-				kfree(key);
-			}
+			local->ops->set_key(local_to_hw(local),
+					   DISABLE_KEY, sta->addr,
+					   &sta->key->conf,
+					   local->default_wep_only);
 		}
 	} else if (sta->key_idx_compression != HW_KEY_IDX_INVALID) {
 		struct ieee80211_key_conf conf;
 		memset(&conf, 0, sizeof(conf));
 		conf.hw_key_idx = sta->key_idx_compression;
-		conf.alg = ALG_NULL;
+		conf.alg = ALG_NONE;
 		conf.flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
 		local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-				   sta->addr, &conf, sta->aid);
+				    sta->addr, &conf,
+				    local->default_wep_only);
 		sta->key_idx_compression = HW_KEY_IDX_INVALID;
 	}
 
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-21 14:58:37.545923881 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-21 16:04:26.385923881 +0200
@@ -7864,7 +7864,7 @@ static int iwl_mac_hw_scan(struct ieee80
 }
 
 static int iwl_mac_set_key(struct ieee80211_hw *hw, set_key_cmd cmd, u8 *addr,
-			   struct ieee80211_key_conf *key, int aid)
+			   struct ieee80211_key_conf *key, int static_wep_only)
 {
 	struct iwl_priv *priv = hw->priv;
 	int rc = 0;
--- wireless-dev.orig/net/mac80211/debugfs_key.c	2007-08-21 15:17:20.585923881 +0200
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-08-21 16:04:26.385923881 +0200
@@ -14,17 +14,17 @@
 #include "debugfs.h"
 #include "debugfs_key.h"
 
-#define KEY_READ(name, buflen, format_string)				\
+#define KEY_READ(name, prop, buflen, format_string)			\
 static ssize_t key_##name##_read(struct file *file,			\
 				 char __user *userbuf,			\
 				 size_t count, loff_t *ppos)		\
 {									\
 	char buf[buflen];						\
 	struct ieee80211_key *key = file->private_data;			\
-	int res = scnprintf(buf, buflen, format_string, key->name);	\
+	int res = scnprintf(buf, buflen, format_string, key->prop);	\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }
-#define KEY_READ_D(name) KEY_READ(name, 20, "%d\n")
+#define KEY_READ_D(name) KEY_READ(name, name, 20, "%d\n")
 
 #define KEY_OPS(name)							\
 static const struct file_operations key_ ##name## _ops = {		\
@@ -36,10 +36,25 @@ static const struct file_operations key_
 		 KEY_READ_##format(name)				\
 		 KEY_OPS(name)
 
-KEY_FILE(keylen, D);
-KEY_FILE(force_sw_encrypt, D);
-KEY_FILE(keyidx, D);
-KEY_FILE(hw_key_idx, D);
+#define KEY_CONF_READ(name, buflen, format_string)			\
+	KEY_READ(conf_##name, conf.name, buflen, format_string)
+#define KEY_CONF_READ_D(name) KEY_CONF_READ(name, 20, "%d\n")
+#define KEY_CONF_READ_X(name) KEY_CONF_READ(name, 20, "0x%x\n")
+
+#define KEY_CONF_OPS(name)						\
+static const struct file_operations key_ ##name## _ops = {		\
+	.read = key_conf_##name##_read,					\
+	.open = mac80211_open_file_generic,				\
+}
+
+#define KEY_CONF_FILE(name, format)					\
+		 KEY_CONF_READ_##format(name)				\
+		 KEY_CONF_OPS(name)
+
+KEY_CONF_FILE(keylen, D);
+KEY_CONF_FILE(keyidx, D);
+KEY_CONF_FILE(hw_key_idx, D);
+KEY_CONF_FILE(flags, X);
 KEY_FILE(tx_rx_count, D);
 
 static ssize_t key_algorithm_read(struct file *file,
@@ -49,7 +64,7 @@ static ssize_t key_algorithm_read(struct
 	char *alg;
 	struct ieee80211_key *key = file->private_data;
 
-	switch (key->alg) {
+	switch (key->conf.alg) {
 	case ALG_WEP:
 		alg = "WEP\n";
 		break;
@@ -74,7 +89,7 @@ static ssize_t key_tx_spec_read(struct f
 	int len;
 	struct ieee80211_key *key = file->private_data;
 
-	switch (key->alg) {
+	switch (key->conf.alg) {
 	case ALG_WEP:
 		len = scnprintf(buf, sizeof(buf), "\n");
 		break;
@@ -103,7 +118,7 @@ static ssize_t key_rx_spec_read(struct f
 	int i, len;
 	const u8 *rpn;
 
-	switch (key->alg) {
+	switch (key->conf.alg) {
 	case ALG_WEP:
 		len = scnprintf(buf, sizeof(buf), "\n");
 		break;
@@ -139,7 +154,7 @@ static ssize_t key_replays_read(struct f
 	char buf[20];
 	int len;
 
-	if (key->alg != ALG_CCMP)
+	if (key->conf.alg != ALG_CCMP)
 		return 0;
 	len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
 	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
@@ -150,12 +165,12 @@ static ssize_t key_key_read(struct file 
 			    size_t count, loff_t *ppos)
 {
 	struct ieee80211_key *key = file->private_data;
-	int i, res, bufsize = 2*key->keylen+2;
+	int i, res, bufsize = 2 * key->conf.keylen + 2;
 	char *buf = kmalloc(bufsize, GFP_KERNEL);
 	char *p = buf;
 
-	for (i = 0; i < key->keylen; i++)
-		p += scnprintf(p, bufsize+buf-p, "%02x", key->key[i]);
+	for (i = 0; i < key->conf.keylen; i++)
+		p += scnprintf(p, bufsize + buf - p, "%02x", key->conf.key[i]);
 	p += scnprintf(p, bufsize+buf-p, "\n");
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 	kfree(buf);
@@ -185,7 +200,7 @@ void ieee80211_debugfs_key_add(struct ie
 		return;
 
 	DEBUGFS_ADD(keylen);
-	DEBUGFS_ADD(force_sw_encrypt);
+	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(keyidx);
 	DEBUGFS_ADD(hw_key_idx);
 	DEBUGFS_ADD(tx_rx_count);
@@ -205,7 +220,7 @@ void ieee80211_debugfs_key_remove(struct
 		return;
 
 	DEBUGFS_DEL(keylen);
-	DEBUGFS_DEL(force_sw_encrypt);
+	DEBUGFS_DEL(flags);
 	DEBUGFS_DEL(keyidx);
 	DEBUGFS_DEL(hw_key_idx);
 	DEBUGFS_DEL(tx_rx_count);
@@ -227,7 +242,7 @@ void ieee80211_debugfs_key_add_default(s
 	if (!sdata->debugfsdir)
 		return;
 
-	sprintf(buf, "../keys/%d", sdata->default_key->keyidx);
+	sprintf(buf, "../keys/%d", sdata->default_key->conf.keyidx);
 	sdata->debugfs.default_key =
 		debugfs_create_symlink("default_key", sdata->debugfsdir, buf);
 }
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-21 15:42:24.665923881 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-21 16:04:26.385923881 +0200
@@ -889,7 +889,7 @@ static void ieee80211_remove_tx_extra(st
 	if (!key)
 		goto no_key;
 
-	switch (key->alg) {
+	switch (key->conf.alg) {
 	case ALG_WEP:
 		iv_len = WEP_IV_LEN;
 		mic_len = WEP_ICV_LEN;
@@ -906,7 +906,8 @@ static void ieee80211_remove_tx_extra(st
 		goto no_key;
 	}
 
-	if (skb->len >= mic_len && key->force_sw_encrypt)
+	if (skb->len >= mic_len &&
+	    (key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT))
 		skb_trim(skb, skb->len - mic_len);
 	if (skb->len >= iv_len && skb->len > hdrlen) {
 		memmove(skb->data + iv_len, skb->data, hdrlen);
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-21 16:00:34.675923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-21 16:04:26.435923881 +0200
@@ -923,9 +923,6 @@ int ieee80211_subif_start_xmit(struct sk
 int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
 /* key handling */
-struct ieee80211_key_conf *
-ieee80211_key_data2conf(struct ieee80211_local *local,
-			const struct ieee80211_key *data);
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  int idx, size_t key_len, gfp_t flags);
 void ieee80211_key_free(struct ieee80211_key *key);
--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-08-21 14:58:36.265923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-08-21 16:04:26.435923881 +0200
@@ -44,8 +44,6 @@
 struct ieee80211_key {
 	struct kref kref;
 
-	int hw_key_idx; /* filled and used by low-level driver */
-	ieee80211_key_alg alg;
 	union {
 		struct {
 			/* last used TSC */
@@ -73,22 +71,16 @@ struct ieee80211_key {
 			u8 rx_crypto_buf[6 * AES_BLOCK_LEN];
 		} ccmp;
 	} u;
-	int tx_rx_count; /* number of times this key has been used */
-	int keylen;
 
-	/* if the low level driver can provide hardware acceleration it should
-	 * clear this flag */
-	unsigned int force_sw_encrypt:1;
-	unsigned int default_tx_key:1; /* This key is the new default TX key
-					* (used only for broadcast keys). */
-	s8 keyidx; /* WEP key index */
+	/* number of times this key has been used */
+	int tx_rx_count;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
 		struct dentry *stalink;
 		struct dentry *dir;
 		struct dentry *keylen;
-		struct dentry *force_sw_encrypt;
+		struct dentry *flags;
 		struct dentry *keyidx;
 		struct dentry *hw_key_idx;
 		struct dentry *tx_rx_count;
@@ -100,7 +92,11 @@ struct ieee80211_key {
 	} debugfs;
 #endif
 
-	u8 key[0];
+	/*
+	 * key config, must be last because it contains key
+	 * material as variable length member
+	 */
+	struct ieee80211_key_conf conf;
 };
 
 #endif /* IEEE80211_KEY_H */
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-21 15:59:22.735923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-21 16:04:26.435923881 +0200
@@ -1345,7 +1345,7 @@ static int ieee80211_sta_wep_configured(
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (!sdata || !sdata->default_key ||
-	    sdata->default_key->alg != ALG_WEP)
+	    sdata->default_key->conf.alg != ALG_WEP)
 		return 0;
 	return 1;
 }
--- wireless-dev.orig/net/mac80211/key.c	2007-08-21 14:58:36.365923881 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-21 16:04:26.445923881 +0200
@@ -13,32 +13,6 @@
 #include "debugfs_key.h"
 #include "aes_ccm.h"
 
-struct ieee80211_key_conf *
-ieee80211_key_data2conf(struct ieee80211_local *local,
-			const struct ieee80211_key *data)
-{
-	struct ieee80211_key_conf *conf;
-
-	conf = kmalloc(sizeof(*conf) + data->keylen, GFP_ATOMIC);
-	if (!conf)
-		return NULL;
-
-	conf->hw_key_idx = data->hw_key_idx;
-	conf->alg = data->alg;
-	conf->keylen = data->keylen;
-	conf->flags = 0;
-	if (data->force_sw_encrypt)
-		conf->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
-	conf->keyidx = data->keyidx;
-	if (data->default_tx_key)
-		conf->flags |= IEEE80211_KEY_DEFAULT_TX_KEY;
-	if (local->default_wep_only)
-		conf->flags |= IEEE80211_KEY_DEFAULT_WEP_ONLY;
-	memcpy(conf->key, data->key, data->keylen);
-
-	return conf;
-}
-
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  int idx, size_t key_len, gfp_t flags)
 {
@@ -56,7 +30,7 @@ static void ieee80211_key_release(struct
 	struct ieee80211_key *key;
 
 	key = container_of(kref, struct ieee80211_key, kref);
-	if (key->alg == ALG_CCMP)
+	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	ieee80211_debugfs_key_remove(key);
 	kfree(key);
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 16:02:54.815923881 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 16:06:31.725923881 +0200
@@ -382,7 +382,7 @@ ieee80211_rx_h_load_key(struct ieee80211
 		/*
 		 * If we got here for WEP, make sure we got WEP
 		 */
-		if (trying_wep && rx->key && rx->key->alg != ALG_WEP)
+		if (trying_wep && rx->key && rx->key->conf.alg != ALG_WEP)
 			rx->key = NULL;
 	} else {
 		rx->key = rx->sta->key;
@@ -532,17 +532,14 @@ ieee80211_rx_h_wep_weak_iv_detection(str
 {
 	if (!rx->sta || !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
 	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    !rx->key || rx->key->alg != ALG_WEP || !rx->u.rx.ra_match)
+	    !rx->key || rx->key->conf.alg != ALG_WEP || !rx->u.rx.ra_match)
 		return TXRX_CONTINUE;
 
 	/* Check for weak IVs, if hwaccel did not remove IV from the frame */
 	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) ||
-	    rx->key->force_sw_encrypt) {
-		u8 *iv = ieee80211_wep_is_weak_iv(rx->skb, rx->key);
-		if (iv) {
+	    (rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT))
+		if (ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 			rx->sta->wep_weak_iv_count++;
-		}
-	}
 
 	return TXRX_CONTINUE;
 }
@@ -550,7 +547,7 @@ ieee80211_rx_h_wep_weak_iv_detection(str
 static ieee80211_txrx_result
 ieee80211_rx_h_wep_decrypt(struct ieee80211_txrx_data *rx)
 {
-	if ((rx->key && rx->key->alg != ALG_WEP) ||
+	if ((rx->key && rx->key->conf.alg != ALG_WEP) ||
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	     ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
@@ -565,7 +562,7 @@ ieee80211_rx_h_wep_decrypt(struct ieee80
 	}
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED) ||
-	    rx->key->force_sw_encrypt) {
+	    (rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
@@ -689,7 +686,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		/* This is the first fragment of a new frame. */
 		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
 						 rx->u.rx.queue, &(rx->skb));
-		if (rx->key && rx->key->alg == ALG_CCMP &&
+		if (rx->key && rx->key->conf.alg == ALG_CCMP &&
 		    (rx->fc & IEEE80211_FCTL_PROTECTED)) {
 			/* Store CCMP PN so that we can verify that the next
 			 * fragment has a sequential PN value. */
@@ -716,7 +713,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	if (entry->ccmp) {
 		int i;
 		u8 pn[CCMP_PN_LEN], *rpn;
-		if (!rx->key || rx->key->alg != ALG_CCMP)
+		if (!rx->key || rx->key->conf.alg != ALG_CCMP)
 			return TXRX_DROP;
 		memcpy(pn, entry->last_pn, CCMP_PN_LEN);
 		for (i = CCMP_PN_LEN - 1; i >= 0; i--) {
@@ -908,7 +905,8 @@ ieee80211_rx_h_drop_unencrypted(struct i
 	 * uploaded to the hardware.
 	 */
 	if ((rx->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP) &&
-	    (!rx->key || !rx->key->force_sw_encrypt))
+	    (!rx->key ||
+	     !(rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)))
 		return TXRX_CONTINUE;
 
 	/* Drop unencrypted frames if key is set. */
--- wireless-dev.orig/net/mac80211/tkip.c	2007-08-21 14:58:36.435923881 +0200
+++ wireless-dev/net/mac80211/tkip.c	2007-08-21 16:04:26.445923881 +0200
@@ -182,7 +182,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
 	*pos++ = iv0;
 	*pos++ = iv1;
 	*pos++ = iv2;
-	*pos++ = (key->keyidx << 6) | (1 << 5) /* Ext IV */;
+	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
 	*pos++ = key->u.tkip.iv32 & 0xff;
 	*pos++ = (key->u.tkip.iv32 >> 8) & 0xff;
 	*pos++ = (key->u.tkip.iv32 >> 16) & 0xff;
@@ -194,7 +194,7 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, stru
 void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
 				  u16 *phase1key)
 {
-	tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
+	tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   key->u.tkip.iv32, phase1key);
 }
 
@@ -204,12 +204,13 @@ void ieee80211_tkip_gen_rc4key(struct ie
 	/* Calculate per-packet key */
 	if (key->u.tkip.iv16 == 0 || !key->u.tkip.tx_initialized) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
+		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 				   key->u.tkip.iv32, key->u.tkip.p1k);
 		key->u.tkip.tx_initialized = 1;
 	}
 
-	tkip_mixing_phase2(key->u.tkip.p1k, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
+	tkip_mixing_phase2(key->u.tkip.p1k,
+			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   key->u.tkip.iv16, rc4key);
 }
 
@@ -266,7 +267,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	if (!(keyid & (1 << 5)))
 		return TKIP_DECRYPT_NO_EXT_IV;
 
-	if ((keyid >> 6) != key->keyidx)
+	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;
 
 	if (key->u.tkip.rx_initialized[queue] &&
@@ -293,7 +294,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	    key->u.tkip.iv32_rx[queue] != iv32) {
 		key->u.tkip.rx_initialized[queue] = 1;
 		/* IV16 wrapped around - perform TKIP phase 1 */
-		tkip_mixing_phase1(ta, &key->key[ALG_TKIP_TEMP_ENCR_KEY],
+		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 				   iv32, key->u.tkip.p1k_rx[queue]);
 #ifdef CONFIG_TKIP_DEBUG
 		{
@@ -302,7 +303,8 @@ int ieee80211_tkip_decrypt_data(struct c
 			       " TK=", MAC_ARG(ta));
 			for (i = 0; i < 16; i++)
 				printk("%02x ",
-				       key->key[ALG_TKIP_TEMP_ENCR_KEY + i]);
+				       key->conf.key[
+						ALG_TKIP_TEMP_ENCR_KEY + i]);
 			printk("\n");
 			printk(KERN_DEBUG "TKIP decrypt: P1K=");
 			for (i = 0; i < 5; i++)
@@ -313,7 +315,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	}
 
 	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
-			   &key->key[ALG_TKIP_TEMP_ENCR_KEY],
+			   &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
 			   iv16, rc4key);
 #ifdef CONFIG_TKIP_DEBUG
 	{
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-21 16:04:00.675923881 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-21 16:04:26.445923881 +0200
@@ -538,11 +538,11 @@ ieee80211_tx_h_fragment(struct ieee80211
 
 static int wep_encrypt_skb(struct ieee80211_txrx_data *tx, struct sk_buff *skb)
 {
-	if (tx->key->force_sw_encrypt) {
+	if (tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
-		tx->u.tx.control->key_idx = tx->key->hw_key_idx;
+		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
 		if (tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
 			if (ieee80211_wep_add_iv(tx->local, skb, tx->key) ==
 			    NULL)
@@ -560,7 +560,7 @@ ieee80211_tx_h_wep_encrypt(struct ieee80
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (!tx->key || tx->key->alg != ALG_WEP ||
+	if (!tx->key || tx->key->conf.alg != ALG_WEP ||
 	    ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	     ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	      (fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH)))
--- wireless-dev.orig/net/mac80211/wep.c	2007-08-21 14:58:36.495923881 +0200
+++ wireless-dev/net/mac80211/wep.c	2007-08-21 16:04:26.455923881 +0200
@@ -67,7 +67,7 @@ void ieee80211_wep_get_iv(struct ieee802
 			  struct ieee80211_key *key, u8 *iv)
 {
 	local->wep_iv++;
-	if (ieee80211_wep_weak_iv(local->wep_iv, key->keylen))
+	if (ieee80211_wep_weak_iv(local->wep_iv, key->conf.keylen))
 		local->wep_iv += 0x0100;
 
 	if (!iv)
@@ -76,7 +76,7 @@ void ieee80211_wep_get_iv(struct ieee802
 	*iv++ = (local->wep_iv >> 16) & 0xff;
 	*iv++ = (local->wep_iv >> 8) & 0xff;
 	*iv++ = local->wep_iv & 0xff;
-	*iv++ = key->keyidx << 6;
+	*iv++ = key->conf.keyidx << 6;
 }
 
 
@@ -159,10 +159,10 @@ int ieee80211_wep_encrypt(struct ieee802
 	u8 *rc4key, *iv;
 	size_t len;
 
-	if (!key || key->alg != ALG_WEP)
+	if (!key || key->conf.alg != ALG_WEP)
 		return -1;
 
-	klen = 3 + key->keylen;
+	klen = 3 + key->conf.keylen;
 	rc4key = kmalloc(klen, GFP_ATOMIC);
 	if (!rc4key)
 		return -1;
@@ -179,7 +179,7 @@ int ieee80211_wep_encrypt(struct ieee802
 	memcpy(rc4key, iv, 3);
 
 	/* Copy rest of the WEP key (the secret part) */
-	memcpy(rc4key + 3, key->key, key->keylen);
+	memcpy(rc4key + 3, key->conf.key, key->conf.keylen);
 
 	/* Add room for ICV */
 	skb_put(skb, WEP_ICV_LEN);
@@ -251,10 +251,10 @@ int ieee80211_wep_decrypt(struct ieee802
 
 	keyidx = skb->data[hdrlen + 3] >> 6;
 
-	if (!key || keyidx != key->keyidx || key->alg != ALG_WEP)
+	if (!key || keyidx != key->conf.keyidx || key->conf.alg != ALG_WEP)
 		return -1;
 
-	klen = 3 + key->keylen;
+	klen = 3 + key->conf.keylen;
 
 	rc4key = kmalloc(klen, GFP_ATOMIC);
 	if (!rc4key)
@@ -264,7 +264,7 @@ int ieee80211_wep_decrypt(struct ieee802
 	memcpy(rc4key, skb->data + hdrlen, 3);
 
 	/* Copy rest of the WEP key (the secret part) */
-	memcpy(rc4key + 3, key->key, key->keylen);
+	memcpy(rc4key + 3, key->conf.key, key->conf.keylen);
 
 	if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
 				       skb->data + hdrlen + WEP_IV_LEN,
@@ -321,7 +321,7 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_
 	ivpos = skb->data + hdrlen;
 	iv = (ivpos[0] << 16) | (ivpos[1] << 8) | ivpos[2];
 
-	if (ieee80211_wep_weak_iv(iv, key->keylen))
+	if (ieee80211_wep_weak_iv(iv, key->conf.keylen))
 		return ivpos;
 
 	return NULL;
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-21 16:00:34.675923881 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-21 16:04:26.455923881 +0200
@@ -86,7 +86,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 
 	fc = tx->fc;
 
-	if (!tx->key || tx->key->alg != ALG_TKIP || skb->len < 24 ||
+	if (!tx->key || tx->key->conf.alg != ALG_TKIP || skb->len < 24 ||
 	    !WLAN_FC_DATA_PRESENT(fc))
 		return TXRX_CONTINUE;
 
@@ -101,7 +101,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	}
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if (!tx->key->force_sw_encrypt &&
+	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
 	    !tx->fragmented &&
 	    !(tx->local->hw.flags & IEEE80211_HW_TKIP_INCLUDE_MMIC) &&
 	    !wpa_test) {
@@ -126,8 +126,8 @@ ieee80211_tx_h_michael_mic_add(struct ie
 #else
 	authenticator = 1;
 #endif
-	key = &tx->key->key[authenticator ? ALG_TKIP_TEMP_AUTH_TX_MIC_KEY :
-			    ALG_TKIP_TEMP_AUTH_RX_MIC_KEY];
+	key = &tx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_TX_MIC_KEY :
+				 ALG_TKIP_TEMP_AUTH_RX_MIC_KEY];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 
@@ -173,7 +173,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	if (rx->local->hw.flags & IEEE80211_HW_DEVICE_STRIPS_MIC)
 		return TXRX_CONTINUE;
 
-	if (!rx->key || rx->key->alg != ALG_TKIP ||
+	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) || !WLAN_FC_DATA_PRESENT(fc))
 		return TXRX_CONTINUE;
 
@@ -184,7 +184,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !rx->key->force_sw_encrypt) {
+	    !(rx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
 		if (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
 			if (skb->len < MICHAEL_MIC_LEN)
 				return TXRX_DROP;
@@ -207,8 +207,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 #else
 	authenticator = 1;
 #endif
-	key = &rx->key->key[authenticator ? ALG_TKIP_TEMP_AUTH_RX_MIC_KEY :
-			    ALG_TKIP_TEMP_AUTH_TX_MIC_KEY];
+	key = &rx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_RX_MIC_KEY :
+				 ALG_TKIP_TEMP_AUTH_TX_MIC_KEY];
 	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	if (rx->sta && rx->sta->wpa_trigger & WPA_TRIGGER_FAIL_RX_MIC) {
@@ -244,7 +244,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 		printk(" (%d)\n", authenticator);
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-		mac80211_ev_michael_mic_failure(rx->dev, rx->key->keyidx,
+		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
 						(void *) skb->data);
 		return TXRX_DROP;
 	}
@@ -270,7 +270,11 @@ static int tkip_encrypt_skb(struct ieee8
 	hdrlen = ieee80211_get_hdrlen(fc);
 	len = skb->len - hdrlen;
 
-	tailneed = !tx->key->force_sw_encrypt ? 0 : TKIP_ICV_LEN;
+	if (tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)
+		tailneed = TKIP_ICV_LEN;
+	else
+		tailneed = 0;
+
 	if ((skb_headroom(skb) < TKIP_IV_LEN ||
 	     skb_tailroom(skb) < tailneed)) {
 		I802_DEBUG_INC(tx->local->tx_expand_skb_head);
@@ -302,7 +306,7 @@ iv_inc:
 skip_iv_inc:
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if (!tx->key->force_sw_encrypt
+	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	    && !tx->wpa_test
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
@@ -333,7 +337,7 @@ skip_iv_inc:
 					    ~IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY;
 		}
 
-		tx->u.tx.control->key_idx = tx->key->hw_key_idx;
+		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
 		return 0;
 	}
 
@@ -358,7 +362,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (!key || key->alg != ALG_TKIP || !WLAN_FC_DATA_PRESENT(fc))
+	if (!key || key->conf.alg != ALG_TKIP || !WLAN_FC_DATA_PRESENT(fc))
 		return TXRX_CONTINUE;
 
 	tx->u.tx.control->icv_len = TKIP_ICV_LEN;
@@ -396,11 +400,11 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 	}
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if (!tx->key->force_sw_encrypt &&
+	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
 	    !(tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for IV/ICV */
-		tx->u.tx.control->key_idx = tx->key->hw_key_idx;
+		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
 		return TXRX_CONTINUE;
 	}
 
@@ -455,7 +459,7 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
 	fc = le16_to_cpu(hdr->frame_control);
 	hdrlen = ieee80211_get_hdrlen(fc);
 
-	if (!rx->key || rx->key->alg != ALG_TKIP ||
+	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
 	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		return TXRX_CONTINUE;
@@ -475,7 +479,7 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !rx->key->force_sw_encrypt) {
+	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
 		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
 			/* Hardware takes care of all processing, including
 			 * replay protection, so no need to continue here. */
@@ -619,7 +623,10 @@ static int ccmp_encrypt_skb(struct ieee8
 	hdrlen = ieee80211_get_hdrlen(fc);
 	len = skb->len - hdrlen;
 
-	tailneed = !key->force_sw_encrypt ? 0 : CCMP_MIC_LEN;
+	if (key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)
+		tailneed = CCMP_MIC_LEN;
+	else
+		tailneed = 0;
 
 	if ((skb_headroom(skb) < CCMP_HDR_LEN ||
 	     skb_tailroom(skb) < tailneed)) {
@@ -657,11 +664,11 @@ pn_inc:
 skip_pn_inc:
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	ccmp_pn2hdr(pos, pn, key->keyidx);
+	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
-	if (!key->force_sw_encrypt) {
+	if (!(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
 		/* hwaccel - with preallocated room for CCMP header */
-		tx->u.tx.control->key_idx = key->hw_key_idx;
+		tx->u.tx.control->key_idx = key->conf.hw_key_idx;
 		return 0;
 	}
 
@@ -685,7 +692,7 @@ ieee80211_tx_h_ccmp_encrypt(struct ieee8
 
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (!key || key->alg != ALG_CCMP || !WLAN_FC_DATA_PRESENT(fc))
+	if (!key || key->conf.alg != ALG_CCMP || !WLAN_FC_DATA_PRESENT(fc))
 		return TXRX_CONTINUE;
 
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
@@ -713,11 +720,11 @@ ieee80211_tx_h_ccmp_encrypt(struct ieee8
 	tx->u.tx.control->iv_len = CCMP_HDR_LEN;
 	ieee80211_tx_set_iswep(tx);
 
-	if (!tx->key->force_sw_encrypt &&
+	if (!(tx->key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
 	    !(tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
 		/* hwaccel - with no need for preallocated room for CCMP "
 		 * header or MIC fields */
-		tx->u.tx.control->key_idx = tx->key->hw_key_idx;
+		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
 		return TXRX_CONTINUE;
 	}
 
@@ -755,7 +762,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 	fc = le16_to_cpu(hdr->frame_control);
 	hdrlen = ieee80211_get_hdrlen(fc);
 
-	if (!key || key->alg != ALG_CCMP ||
+	if (!key || key->conf.alg != ALG_CCMP ||
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
 	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		return TXRX_CONTINUE;
@@ -765,7 +772,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 		return TXRX_DROP;
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !key->force_sw_encrypt &&
+	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) &&
 	    !(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
 		return TXRX_CONTINUE;
 
@@ -786,7 +793,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 	}
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    !key->force_sw_encrypt) {
+	    !(key->conf.flags & IEEE80211_KEY_FORCE_SW_ENCRYPT)) {
 		/* hwaccel has already decrypted frame and verified MIC */
 	} else {
 		u8 *scratch, *b_0, *aad;
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-21 14:58:40.435923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-21 16:04:26.455923881 +0200
@@ -244,7 +244,8 @@ void ieee80211_if_reinit(struct net_devi
 		memset(addr, 0xff, ETH_ALEN);
 		if (local->ops->set_key)
 			local->ops->set_key(local_to_hw(local), DISABLE_KEY, addr,
-					    local->keys[i], 0);
+					    local->keys[i],
+					    local->default_wep_only);
 #endif
 		ieee80211_key_free(sdata->keys[i]);
 		sdata->keys[i] = NULL;

-- 

