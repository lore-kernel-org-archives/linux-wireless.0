Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55236
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764742AbXHWW1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:08 -0400
Message-Id: <20070823222157.102919000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:22:00 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [patch 7/7] b43: Fix and cleanup hwcrypto
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes bugs and does a cleanup of the hwcrypto stuff.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>

Index: wireless-dev-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/b43.h	2007-08-23 22:55:18.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/b43.h	2007-08-24 00:14:00.000000000 +0200
@@ -571,8 +571,10 @@ struct b43_stats {
 };
 
 struct b43_key {
-	void *keyconf;
-	bool enabled;
+	/* If keyconf is NULL, this key is disabled.
+	 * keyconf is a cookie. Don't derefenrence it outside of the set_key
+	 * path, because b43 doesn't own it. */
+	struct ieee80211_key_conf *keyconf;
 	u8 algorithm;
 };
 
Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-23 23:42:20.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-24 00:03:09.000000000 +0200
@@ -806,31 +806,29 @@ static int b43_key_write(struct b43_wlde
 {
 	int i;
 	int sta_keys_start;
+	bool removal = 0;
 
 	if (key_len > B43_SEC_KEYSIZE)
 		return -EINVAL;
 	if (index < 0) {
-		/* Per station key with associated MAC address.
-		 * Look if it already exists, if yes update, otherwise
-		 * allocate a new key.
-		 */
+		/* Either pairwise key or address is 00:00:00:00:00:00
+		 * for transmit-only keys. Search the index. */
 		if (b43_new_kidx_api(dev))
 			sta_keys_start = 4;
 		else
 			sta_keys_start = 8;
 		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
 			if (dev->key[i].keyconf == keyconf) {
-				/*
-				 * we already have this key so we must be
-				 * in removal (there is no update)
-				 */
+				/* we already have this key so we must be
+				 * in removal (there is no update) */
+				removal = 1;
 				index = i;
 				break;
 			}
 		}
 		if (index < 0) {
 			for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
-				if (!dev->key[i].enabled) {
+				if (!dev->key[i].keyconf) {
 					/* found empty */
 					index = i;
 					break;
@@ -851,6 +849,7 @@ static int b43_key_write(struct b43_wlde
 		do_key_write(dev, index + 4, algorithm, key, key_len, NULL);
 	}
 	keyconf->hw_key_idx = index;
+	dev->key[index].keyconf = removal ? NULL : keyconf;
 
 	return 0;
 }
@@ -864,7 +863,7 @@ static void b43_clear_keys(struct b43_wl
 	for (i = 0; i < dev->max_nr_keys; i++) {
 		do_key_write(dev, i, B43_SEC_ALGO_NONE,
 			     zero, B43_SEC_KEYSIZE, zero);
-		dev->key[i].enabled = 0;
+		dev->key[i].keyconf = NULL;
 	}
 }
 
@@ -2960,7 +2959,6 @@ static int b43_dev_set_key(struct ieee80
 		}
 		if (err)
 			goto out_unlock;
-		dev->key[key->hw_key_idx].enabled = 1;
 
 		if (algorithm == B43_SEC_ALGO_WEP40 ||
 		    algorithm == B43_SEC_ALGO_WEP104) {
@@ -2974,16 +2972,11 @@ static int b43_dev_set_key(struct ieee80
 		static const u8 zero[B43_SEC_KEYSIZE] = { 0 };
 
 		algorithm = B43_SEC_ALGO_NONE;
-		if (is_broadcast_ether_addr(addr)) {
-			err = b43_key_write(dev, index, algorithm,
-					    zero, B43_SEC_KEYSIZE,
-					    NULL, key);
-		} else {
-			err = b43_key_write(dev, -1, algorithm,
-					    zero, B43_SEC_KEYSIZE,
-					    addr, key);
-		}
-		dev->key[key->hw_key_idx].enabled = 0;
+		err = b43_key_write(dev, index, algorithm,
+				    zero, B43_SEC_KEYSIZE,
+				    NULL, key);
+		if (err)
+			goto out_unlock;
 		break;
 	}
 	default:
Index: wireless-dev-new/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/xmit.c	2007-08-23 22:55:18.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/xmit.c	2007-08-24 00:06:28.000000000 +0200
@@ -234,23 +234,20 @@ static void generate_txhdr_fw4(struct b4
 
 		B43_WARN_ON(key_idx >= dev->max_nr_keys);
 		key = &(dev->key[key_idx]);
+		B43_WARN_ON(!key->keyconf);
 
-		if (key->enabled) {
-			/* Hardware appends ICV. */
-			plcp_fragment_len += txctl->icv_len;
-
-			key_idx = b43_kidx_to_fw(dev, key_idx);
-			mac_ctl |= (key_idx << B43_TX4_MAC_KEYIDX_SHIFT) &
-			    B43_TX4_MAC_KEYIDX;
-			mac_ctl |=
-			    (key->
-			     algorithm << B43_TX4_MAC_KEYALG_SHIFT) &
-			    B43_TX4_MAC_KEYALG;
-			wlhdr_len = ieee80211_get_hdrlen(fctl);
-			iv_len = min((size_t) txctl->iv_len,
-				     ARRAY_SIZE(txhdr->iv));
-			memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
-		}
+		/* Hardware appends ICV. */
+		plcp_fragment_len += txctl->icv_len;
+
+		key_idx = b43_kidx_to_fw(dev, key_idx);
+		mac_ctl |= (key_idx << B43_TX4_MAC_KEYIDX_SHIFT) &
+			   B43_TX4_MAC_KEYIDX;
+		mac_ctl |= (key->algorithm << B43_TX4_MAC_KEYALG_SHIFT) &
+			   B43_TX4_MAC_KEYALG;
+		wlhdr_len = ieee80211_get_hdrlen(fctl);
+		iv_len = min((size_t) txctl->iv_len,
+			     ARRAY_SIZE(txhdr->iv));
+		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
 	}
 	b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->plcp),
 			      plcp_fragment_len, rate);

-- 

