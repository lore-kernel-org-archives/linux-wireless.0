Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXIZPzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:55:00 -0400
Message-Id: <20070926155434.436992000@sipsolutions.net>
References: <20070926155313.955049000@sipsolutions.net>
Date: Wed, 26 Sep 2007 17:53:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [patch 4/7] mac80211: remove ALG_NONE
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This "algorithm" is used only internally and is not useful.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Zhu Yi <yi.zhu@intel.com>

---
 drivers/net/wireless/b43/main.c             |    3 ---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ----
 include/net/mac80211.h                      |    2 --
 net/mac80211/ieee80211_ioctl.c              |   19 +++++++++++--------
 net/mac80211/key.c                          |    1 -
 net/mac80211/rx.c                           |    2 --
 net/mac80211/tx.c                           |    2 --
 8 files changed, 11 insertions(+), 26 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-26 17:43:17.217337342 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-26 17:43:21.277337342 +0200
@@ -538,13 +538,11 @@ struct ieee80211_if_conf {
 
 /**
  * enum ieee80211_key_alg - key algorithm
- * @ALG_NONE: Unset key algorithm, will never be passed to the driver
  * @ALG_WEP: WEP40 or WEP104
  * @ALG_TKIP: TKIP
  * @ALG_CCMP: CCMP (AES)
  */
 enum ieee80211_key_alg {
-	ALG_NONE,
 	ALG_WEP,
 	ALG_TKIP,
 	ALG_CCMP,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-26 17:41:53.227337342 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-26 17:44:40.867337342 +0200
@@ -27,8 +27,9 @@
 
 
 static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
-				    int idx, int alg, int set_tx_key,
-				    const u8 *_key, size_t key_len)
+				    int idx, int alg, int remove,
+				    int set_tx_key, const u8 *_key,
+				    size_t key_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int ret = 0;
@@ -75,7 +76,7 @@ static int ieee80211_set_encryption(stru
 		key = sta->key;
 	}
 
-	if (alg == ALG_NONE) {
+	if (remove) {
 		ieee80211_key_free(key);
 		key = NULL;
 	} else {
@@ -827,6 +828,7 @@ static int ieee80211_ioctl_siwencode(str
 	struct ieee80211_sub_if_data *sdata;
 	int idx, i, alg = ALG_WEP;
 	u8 bcaddr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	int remove = 0;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -845,7 +847,7 @@ static int ieee80211_ioctl_siwencode(str
 		idx--;
 
 	if (erq->flags & IW_ENCODE_DISABLED)
-		alg = ALG_NONE;
+		remove = 1;
 	else if (erq->length == 0) {
 		/* No key data - just set the default TX key index */
 		ieee80211_set_default_key(sdata, idx);
@@ -854,7 +856,7 @@ static int ieee80211_ioctl_siwencode(str
 
 	return ieee80211_set_encryption(
 		dev, bcaddr,
-		idx, alg,
+		idx, alg, remove,
 		!sdata->default_key,
 		keybuf, erq->length);
 }
@@ -1005,11 +1007,11 @@ static int ieee80211_ioctl_siwencodeext(
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
-	int alg, idx, i;
+	int uninitialized_var(alg), idx, i, remove = 0;
 
 	switch (ext->alg) {
 	case IW_ENCODE_ALG_NONE:
-		alg = ALG_NONE;
+		remove = 1;
 		break;
 	case IW_ENCODE_ALG_WEP:
 		alg = ALG_WEP;
@@ -1025,7 +1027,7 @@ static int ieee80211_ioctl_siwencodeext(
 	}
 
 	if (erq->flags & IW_ENCODE_DISABLED)
-		alg = ALG_NONE;
+		remove = 1;
 
 	idx = erq->flags & IW_ENCODE_INDEX;
 	if (idx < 1 || idx > 4) {
@@ -1044,6 +1046,7 @@ static int ieee80211_ioctl_siwencodeext(
 		idx--;
 
 	return ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
+					remove,
 					ext->ext_flags &
 					IW_ENCODE_EXT_SET_TX_KEY,
 					ext->key, ext->key_len);
--- wireless-dev.orig/net/mac80211/key.c	2007-09-26 17:43:08.097337342 +0200
+++ wireless-dev/net/mac80211/key.c	2007-09-26 17:43:11.157337342 +0200
@@ -121,7 +121,6 @@ struct ieee80211_key *ieee80211_key_allo
 	struct ieee80211_key *key;
 
 	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS);
-	BUG_ON(alg == ALG_NONE);
 
 	key = kzalloc(sizeof(struct ieee80211_key) + key_len, GFP_KERNEL);
 	if (!key)
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-26 17:45:01.447337342 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-26 17:45:32.207337342 +0200
@@ -532,8 +532,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		return ieee80211_crypto_tkip_decrypt(rx);
 	case ALG_CCMP:
 		return ieee80211_crypto_ccmp_decrypt(rx);
-	case ALG_NONE:
-		/* fall through, not reached */
 	}
 
 	/* not reached */
--- wireless-dev.orig/net/mac80211/tx.c	2007-09-26 17:45:43.277337342 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-26 17:45:46.507337342 +0200
@@ -554,8 +554,6 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 		return ieee80211_crypto_tkip_encrypt(tx);
 	case ALG_CCMP:
 		return ieee80211_crypto_ccmp_encrypt(tx);
-	case ALG_NONE:
-		return TXRX_CONTINUE;
 	}
 
 	/* not reached */
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-26 17:46:27.737337342 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-26 17:46:43.467337342 +0200
@@ -2893,9 +2893,6 @@ static int b43_dev_set_key(struct ieee80
 	if (!dev)
 		return -ENODEV;
 	switch (key->alg) {
-	case ALG_NONE:
-		algorithm = B43_SEC_ALGO_NONE;
-		break;
 	case ALG_WEP:
 		if (key->keylen == 5)
 			algorithm = B43_SEC_ALGO_WEP40;
--- wireless-dev.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-09-26 17:47:05.597337342 +0200
+++ wireless-dev/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-09-26 17:47:15.057337342 +0200
@@ -2595,10 +2595,6 @@ static void iwl_build_tx_cmd_hwcrypto(st
 			     "with key %d\n", ctl->key_idx);
 		break;
 
-	case ALG_NONE:
-		IWL_DEBUG_TX("Tx packet in the clear (encrypt requested).\n");
-		break;
-
 	default:
 		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
 		break;
--- wireless-dev.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-09-26 17:47:20.237337342 +0200
+++ wireless-dev/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-09-26 17:47:23.817337342 +0200
@@ -2673,10 +2673,6 @@ static void iwl_build_tx_cmd_hwcrypto(st
 			     "with key %d\n", ctl->key_idx);
 		break;
 
-	case ALG_NONE:
-		IWL_DEBUG_TX("Tx packet in the clear (encrypt requested).\n");
-		break;
-
 	default:
 		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
 		break;

-- 

