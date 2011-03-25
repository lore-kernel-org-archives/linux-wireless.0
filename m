Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52909 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1CYUj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 16:39:28 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: remove the dependency on crypto_blkcipher
Date: Fri, 25 Mar 2011 21:39:19 +0100
Message-Id: <1301085559-58240-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only thing that using crypto_blkcipher with ecb does over just using
arc4 directly is wrapping the encrypt/decrypt function into a for loop,
looping over each individual character.
To be able to do this, it pulls in around 40 kb worth of unnecessary
kernel modules (at least on a MIPS embedded device).
Using arc4 directly not only eliminates those dependencies, it also makes
the code smaller.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/Kconfig       |    1 -
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/tkip.c        |    4 ++--
 net/mac80211/tkip.h        |    4 ++--
 net/mac80211/wep.c         |   34 +++++++++++++++-------------------
 net/mac80211/wep.h         |    4 ++--
 6 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 513f85c..f5fdfcb 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -2,7 +2,6 @@ config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
 	depends on CFG80211
 	select CRYPTO
-	select CRYPTO_ECB
 	select CRYPTO_ARC4
 	select CRYPTO_AES
 	select CRC32
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a404017..6eb2c852 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -809,8 +809,8 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	struct crypto_blkcipher *wep_tx_tfm;
-	struct crypto_blkcipher *wep_rx_tfm;
+	struct crypto_cipher *wep_tx_tfm;
+	struct crypto_cipher *wep_rx_tfm;
 	u32 wep_iv;
 
 	/* see iface.c */
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index e840c9c..757e4eb 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -202,7 +202,7 @@ EXPORT_SYMBOL(ieee80211_get_tkip_key);
  * @payload_len is the length of payload (_not_ including IV/ICV length).
  * @ta is the transmitter addresses.
  */
-int ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
+int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
 				struct ieee80211_key *key,
 				u8 *pos, size_t payload_len, u8 *ta)
 {
@@ -223,7 +223,7 @@ int ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
  * beginning of the buffer containing IEEE 802.11 header payload, i.e.,
  * including IV, Ext. IV, real data, Michael MIC, ICV. @payload_len is the
  * length of payload, including IV, Ext. IV, MIC, ICV.  */
-int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
+int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
 				u8 *ra, int only_iv, int queue,
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index 7e83dee..1cab9c8 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -15,7 +15,7 @@
 
 u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16);
 
-int ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
+int ieee80211_tkip_encrypt_data(struct crypto_cipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
 enum {
@@ -24,7 +24,7 @@ enum {
 	TKIP_DECRYPT_INVALID_KEYIDX = -2,
 	TKIP_DECRYPT_REPLAY = -3,
 };
-int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
+int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 				struct ieee80211_key *key,
 				u8 *payload, size_t payload_len, u8 *ta,
 				u8 *ra, int only_iv, int queue,
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 2ff6d1e..a1c6bfd 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -30,17 +30,15 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 	/* start WEP IV from a random value */
 	get_random_bytes(&local->wep_iv, WEP_IV_LEN);
 
-	local->wep_tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
-						CRYPTO_ALG_ASYNC);
+	local->wep_tx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_tx_tfm)) {
 		local->wep_rx_tfm = ERR_PTR(-EINVAL);
 		return PTR_ERR(local->wep_tx_tfm);
 	}
 
-	local->wep_rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
-						CRYPTO_ALG_ASYNC);
+	local->wep_rx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_rx_tfm)) {
-		crypto_free_blkcipher(local->wep_tx_tfm);
+		crypto_free_cipher(local->wep_tx_tfm);
 		local->wep_tx_tfm = ERR_PTR(-EINVAL);
 		return PTR_ERR(local->wep_rx_tfm);
 	}
@@ -51,9 +49,9 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 void ieee80211_wep_free(struct ieee80211_local *local)
 {
 	if (!IS_ERR(local->wep_tx_tfm))
-		crypto_free_blkcipher(local->wep_tx_tfm);
+		crypto_free_cipher(local->wep_tx_tfm);
 	if (!IS_ERR(local->wep_rx_tfm))
-		crypto_free_blkcipher(local->wep_rx_tfm);
+		crypto_free_cipher(local->wep_rx_tfm);
 }
 
 static inline bool ieee80211_wep_weak_iv(u32 iv, int keylen)
@@ -127,12 +125,11 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
 /* Perform WEP encryption using given key. data buffer must have tailroom
  * for 4-byte ICV. data_len must not include this ICV. Note: this function
  * does _not_ add IV. data = RC4(data | CRC32(data)) */
-int ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
+int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len)
 {
-	struct blkcipher_desc desc = { .tfm = tfm };
-	struct scatterlist sg;
 	__le32 icv;
+	int i;
 
 	if (IS_ERR(tfm))
 		return -1;
@@ -140,9 +137,9 @@ int ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 	put_unaligned(icv, (__le32 *)(data + data_len));
 
-	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
-	crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
+	crypto_cipher_setkey(tfm, rc4key, klen);
+	for (i = 0; i < data_len + WEP_ICV_LEN; i++)
+		crypto_cipher_encrypt_one(tfm, data + i, data + i);
 
 	return 0;
 }
@@ -186,19 +183,18 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 /* Perform WEP decryption using given key. data buffer includes encrypted
  * payload, including 4-byte ICV, but _not_ IV. data_len must not include ICV.
  * Return 0 on success and -1 on ICV mismatch. */
-int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
+int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len)
 {
-	struct blkcipher_desc desc = { .tfm = tfm };
-	struct scatterlist sg;
 	__le32 crc;
+	int i;
 
 	if (IS_ERR(tfm))
 		return -1;
 
-	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
-	crypto_blkcipher_decrypt(&desc, &sg, &sg, sg.length);
+	crypto_cipher_setkey(tfm, rc4key, klen);
+	for (i = 0; i < data_len + WEP_ICV_LEN; i++)
+		crypto_cipher_decrypt_one(tfm, data + i, data + i);
 
 	crc = cpu_to_le32(~crc32_le(~0, data, data_len));
 	if (memcmp(&crc, data + data_len, WEP_ICV_LEN) != 0)
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 58654ee..01e5484 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -18,12 +18,12 @@
 
 int ieee80211_wep_init(struct ieee80211_local *local);
 void ieee80211_wep_free(struct ieee80211_local *local);
-int ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
+int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
 			  const u8 *key, int keylen, int keyidx);
-int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
+int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len);
 bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
-- 
1.7.3.2

