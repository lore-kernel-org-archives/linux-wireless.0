Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbZGGBrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:47:15 -0400
Message-Id: <20090707014552.391262252@sipsolutions.net>
References: <20090707014515.024822579@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:45:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: refactor the WEP code to be directly usable
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new key work for cfg80211 will only give us the WEP
key for shared auth to do that authentication, and not
via the regular key settings, so we need to be able to
encrypt a single frame in software, and that without a
key struct. Thus, refactor the WEP code to not require
a key structure but use the key, len and idx directly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wep.c |   52 +++++++++++++++++++++++-----------------------------
 net/mac80211/wep.h |    4 ----
 2 files changed, 23 insertions(+), 33 deletions(-)

--- wireless-testing.orig/net/mac80211/wep.c	2009-07-07 03:43:38.000000000 +0200
+++ wireless-testing/net/mac80211/wep.c	2009-07-07 03:43:41.000000000 +0200
@@ -67,10 +67,10 @@ static inline bool ieee80211_wep_weak_iv
 
 
 static void ieee80211_wep_get_iv(struct ieee80211_local *local,
-				 struct ieee80211_key *key, u8 *iv)
+				 int keylen, int keyidx, u8 *iv)
 {
 	local->wep_iv++;
-	if (ieee80211_wep_weak_iv(local->wep_iv, key->conf.keylen))
+	if (ieee80211_wep_weak_iv(local->wep_iv, keylen))
 		local->wep_iv += 0x0100;
 
 	if (!iv)
@@ -79,13 +79,13 @@ static void ieee80211_wep_get_iv(struct 
 	*iv++ = (local->wep_iv >> 16) & 0xff;
 	*iv++ = (local->wep_iv >> 8) & 0xff;
 	*iv++ = local->wep_iv & 0xff;
-	*iv++ = key->conf.keyidx << 6;
+	*iv++ = keyidx << 6;
 }
 
 
 static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 				struct sk_buff *skb,
-				struct ieee80211_key *key)
+				int keylen, int keyidx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	unsigned int hdrlen;
@@ -100,7 +100,7 @@ static u8 *ieee80211_wep_add_iv(struct i
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, WEP_IV_LEN);
 	memmove(newhdr, newhdr + WEP_IV_LEN, hdrlen);
-	ieee80211_wep_get_iv(local, key, newhdr + hdrlen);
+	ieee80211_wep_get_iv(local, keylen, keyidx, newhdr + hdrlen);
 	return newhdr + hdrlen;
 }
 
@@ -144,26 +144,17 @@ void ieee80211_wep_encrypt_data(struct c
  *
  * WEP frame payload: IV + TX key idx, RC4(data), ICV = RC4(CRC32(data))
  */
-int ieee80211_wep_encrypt(struct ieee80211_local *local, struct sk_buff *skb,
-			  struct ieee80211_key *key)
+static int ieee80211_wep_encrypt(struct ieee80211_local *local,
+				 struct sk_buff *skb,
+				 const u8 *key, int keylen, int keyidx)
 {
-	u32 klen;
-	u8 *rc4key, *iv;
+	u8 *iv;
 	size_t len;
+	u8 rc4key[3 + WLAN_KEY_LEN_WEP104];
 
-	if (!key || key->conf.alg != ALG_WEP)
-		return -1;
-
-	klen = 3 + key->conf.keylen;
-	rc4key = kmalloc(klen, GFP_ATOMIC);
-	if (!rc4key)
-		return -1;
-
-	iv = ieee80211_wep_add_iv(local, skb, key);
-	if (!iv) {
-		kfree(rc4key);
+	iv = ieee80211_wep_add_iv(local, skb, keylen, keyidx);
+	if (!iv)
 		return -1;
-	}
 
 	len = skb->len - (iv + WEP_IV_LEN - skb->data);
 
@@ -171,16 +162,14 @@ int ieee80211_wep_encrypt(struct ieee802
 	memcpy(rc4key, iv, 3);
 
 	/* Copy rest of the WEP key (the secret part) */
-	memcpy(rc4key + 3, key->conf.key, key->conf.keylen);
+	memcpy(rc4key + 3, key, keylen);
 
 	/* Add room for ICV */
 	skb_put(skb, WEP_ICV_LEN);
 
-	ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, klen,
+	ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, keylen + 3,
 				   iv + WEP_IV_LEN, len);
 
-	kfree(rc4key);
-
 	return 0;
 }
 
@@ -216,8 +205,9 @@ int ieee80211_wep_decrypt_data(struct cr
  * failure. If frame is OK, IV and ICV will be removed, i.e., decrypted payload
  * is moved to the beginning of the skb and skb length will be reduced.
  */
-int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
-			  struct ieee80211_key *key)
+static int ieee80211_wep_decrypt(struct ieee80211_local *local,
+				 struct sk_buff *skb,
+				 struct ieee80211_key *key)
 {
 	u32 klen;
 	u8 *rc4key;
@@ -314,12 +304,16 @@ static int wep_encrypt_skb(struct ieee80
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
+		if (ieee80211_wep_encrypt(tx->local, skb, tx->key->conf.key,
+					  tx->key->conf.keylen,
+					  tx->key->conf.keyidx))
 			return -1;
 	} else {
 		info->control.hw_key = &tx->key->conf;
 		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
-			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
+			if (!ieee80211_wep_add_iv(tx->local, skb,
+						  tx->key->conf.keylen,
+						  tx->key->conf.keyidx))
 				return -1;
 		}
 	}
--- wireless-testing.orig/net/mac80211/wep.h	2009-07-07 03:43:38.000000000 +0200
+++ wireless-testing/net/mac80211/wep.h	2009-07-07 03:43:41.000000000 +0200
@@ -22,10 +22,6 @@ void ieee80211_wep_encrypt_data(struct c
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len);
-int ieee80211_wep_encrypt(struct ieee80211_local *local, struct sk_buff *skb,
-			  struct ieee80211_key *key);
-int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
-			  struct ieee80211_key *key);
 bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
 ieee80211_rx_result

-- 

