Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59540 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbeIXQKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 12:10:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] lib80211: don't use skcipher
Date: Mon, 24 Sep 2018 12:08:37 +0200
Message-Id: <20180924100837.8505-1-johannes@sipsolutions.net> (sfid-20180924_120858_165364_0CFE6E64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using skcipher just makes the code longer, and mac80211
also "open-codes" the WEP encrypt/decrypt.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/lib80211_crypt_tkip.c | 59 +++++++++++++-------------------------
 net/wireless/lib80211_crypt_wep.c  | 52 +++++++++++++--------------------
 2 files changed, 40 insertions(+), 71 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index e6bce1f130c9..b5e235573c8a 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -30,7 +30,7 @@
 #include <net/iw_handler.h>
 
 #include <crypto/hash.h>
-#include <crypto/skcipher.h>
+#include <linux/crypto.h>
 #include <linux/crc32.h>
 
 #include <net/lib80211.h>
@@ -64,9 +64,9 @@ struct lib80211_tkip_data {
 
 	int key_idx;
 
-	struct crypto_skcipher *rx_tfm_arc4;
+	struct crypto_cipher *rx_tfm_arc4;
 	struct crypto_shash *rx_tfm_michael;
-	struct crypto_skcipher *tx_tfm_arc4;
+	struct crypto_cipher *tx_tfm_arc4;
 	struct crypto_shash *tx_tfm_michael;
 
 	/* scratch buffers for virt_to_page() (crypto API) */
@@ -99,8 +99,7 @@ static void *lib80211_tkip_init(int key_idx)
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		priv->tx_tfm_arc4 = NULL;
 		goto fail;
@@ -112,8 +111,7 @@ static void *lib80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		priv->rx_tfm_arc4 = NULL;
 		goto fail;
@@ -130,9 +128,9 @@ static void *lib80211_tkip_init(int key_idx)
       fail:
 	if (priv) {
 		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_skcipher(priv->tx_tfm_arc4);
+		crypto_free_cipher(priv->tx_tfm_arc4);
 		crypto_free_shash(priv->rx_tfm_michael);
-		crypto_free_skcipher(priv->rx_tfm_arc4);
+		crypto_free_cipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
 
@@ -144,9 +142,9 @@ static void lib80211_tkip_deinit(void *priv)
 	struct lib80211_tkip_data *_priv = priv;
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_skcipher(_priv->tx_tfm_arc4);
+		crypto_free_cipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_skcipher(_priv->rx_tfm_arc4);
+		crypto_free_cipher(_priv->rx_tfm_arc4);
 	}
 	kfree(priv);
 }
@@ -344,12 +342,10 @@ static int lib80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
 static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
 	int len;
 	u8 rc4key[16], *pos, *icv;
 	u32 crc;
-	struct scatterlist sg;
-	int err;
+	int i;
 
 	if (tkey->flags & IEEE80211_CRYPTO_TKIP_COUNTERMEASURES) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -374,14 +370,10 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-	sg_init_one(&sg, pos, len + 4);
-	skcipher_request_set_tfm(req, tkey->tx_tfm_arc4);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
-	err = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	return err;
+	crypto_cipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
+	for (i = 0; i < len + 4; i++)
+		crypto_cipher_encrypt_one(tkey->tx_tfm_arc4, pos + i, pos + i);
+	return 0;
 }
 
 /*
@@ -400,7 +392,6 @@ static inline int tkip_replay_check(u32 iv32_n, u16 iv16_n,
 static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
 	u8 rc4key[16];
 	u8 keyidx, *pos;
 	u32 iv32;
@@ -408,9 +399,8 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	struct ieee80211_hdr *hdr;
 	u8 icv[4];
 	u32 crc;
-	struct scatterlist sg;
 	int plen;
-	int err;
+	int i;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 
@@ -463,18 +453,9 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	plen = skb->len - hdr_len - 12;
 
-	crypto_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-	sg_init_one(&sg, pos, plen + 4);
-	skcipher_request_set_tfm(req, tkey->rx_tfm_arc4);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
-	err = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (err) {
-		net_dbg_ratelimited("TKIP: failed to decrypt received packet from %pM\n",
-				    hdr->addr2);
-		return -7;
-	}
+	crypto_cipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
+	for (i = 0; i < plen + 4; i++)
+		crypto_cipher_decrypt_one(tkey->rx_tfm_arc4, pos + i, pos + i);
 
 	crc = ~crc32_le(~0, pos, plen);
 	icv[0] = crc;
@@ -660,9 +641,9 @@ static int lib80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
 	struct lib80211_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_shash *tfm = tkey->tx_tfm_michael;
-	struct crypto_skcipher *tfm2 = tkey->tx_tfm_arc4;
+	struct crypto_cipher *tfm2 = tkey->tx_tfm_arc4;
 	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_skcipher *tfm4 = tkey->rx_tfm_arc4;
+	struct crypto_cipher *tfm4 = tkey->rx_tfm_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index d05f58b0fd04..6015f6b542a6 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -22,7 +22,7 @@
 
 #include <net/lib80211.h>
 
-#include <crypto/skcipher.h>
+#include <linux/crypto.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -35,8 +35,8 @@ struct lib80211_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_skcipher *tx_tfm;
-	struct crypto_skcipher *rx_tfm;
+	struct crypto_cipher *tx_tfm;
+	struct crypto_cipher *rx_tfm;
 };
 
 static void *lib80211_wep_init(int keyidx)
@@ -48,13 +48,13 @@ static void *lib80211_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm)) {
 		priv->tx_tfm = NULL;
 		goto fail;
 	}
 
-	priv->rx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm)) {
 		priv->rx_tfm = NULL;
 		goto fail;
@@ -66,8 +66,8 @@ static void *lib80211_wep_init(int keyidx)
 
       fail:
 	if (priv) {
-		crypto_free_skcipher(priv->tx_tfm);
-		crypto_free_skcipher(priv->rx_tfm);
+		crypto_free_cipher(priv->tx_tfm);
+		crypto_free_cipher(priv->rx_tfm);
 		kfree(priv);
 	}
 	return NULL;
@@ -77,8 +77,8 @@ static void lib80211_wep_deinit(void *priv)
 {
 	struct lib80211_wep_data *_priv = priv;
 	if (_priv) {
-		crypto_free_skcipher(_priv->tx_tfm);
-		crypto_free_skcipher(_priv->rx_tfm);
+		crypto_free_cipher(_priv->tx_tfm);
+		crypto_free_cipher(_priv->rx_tfm);
 	}
 	kfree(priv);
 }
@@ -129,12 +129,10 @@ static int lib80211_wep_build_iv(struct sk_buff *skb, int hdr_len,
 static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
 	u32 crc, klen, len;
 	u8 *pos, *icv;
-	struct scatterlist sg;
 	u8 key[WEP_KEY_LEN + 3];
-	int err;
+	int i;
 
 	/* other checks are in lib80211_wep_build_iv */
 	if (skb_tailroom(skb) < 4)
@@ -162,14 +160,12 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_skcipher_setkey(wep->tx_tfm, key, klen);
-	sg_init_one(&sg, pos, len + 4);
-	skcipher_request_set_tfm(req, wep->tx_tfm);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
-	err = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	return err;
+	crypto_cipher_setkey(wep->tx_tfm, key, klen);
+
+	for (i = 0; i < len + 4; i++)
+		crypto_cipher_encrypt_one(wep->tx_tfm, pos + i, pos + i);
+
+	return 0;
 }
 
 /* Perform WEP decryption on given buffer. Buffer includes whole WEP part of
@@ -182,12 +178,10 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
 	u32 crc, klen, plen;
 	u8 key[WEP_KEY_LEN + 3];
 	u8 keyidx, *pos, icv[4];
-	struct scatterlist sg;
-	int err;
+	int i;
 
 	if (skb->len < hdr_len + 8)
 		return -1;
@@ -208,15 +202,9 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	/* Apply RC4 to data and compute CRC32 over decrypted data */
 	plen = skb->len - hdr_len - 8;
 
-	crypto_skcipher_setkey(wep->rx_tfm, key, klen);
-	sg_init_one(&sg, pos, plen + 4);
-	skcipher_request_set_tfm(req, wep->rx_tfm);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
-	err = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (err)
-		return -7;
+	crypto_cipher_setkey(wep->rx_tfm, key, klen);
+	for (i = 0; i < plen + 4; i++)
+		crypto_cipher_decrypt_one(wep->rx_tfm, pos + i, pos + i);
 
 	crc = ~crc32_le(~0, pos, plen);
 	icv[0] = crc;
-- 
2.14.4
