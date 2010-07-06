Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41290 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0GFUaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 16:30:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove wep dependency
Date: Tue,  6 Jul 2010 16:19:11 -0400
Message-Id: <1278447551-4981-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current mac80211 code assumes that WEP is always available.  If WEP
fails to initialize, ieee80211_register_hw will always fail.

In some cases (e.g. FIPS certification), the cryptography used by WEP is
unavailable.  However, in such cases there is no good reason why CCMP
encryption (or even no link level encryption) cannot be used.  So, this
patch removes mac80211's assumption that WEP (and TKIP) will always be
available for use.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/cfg.c  |    5 +++++
 net/mac80211/main.c |    5 +----
 net/mac80211/tkip.c |    8 ++++----
 net/mac80211/tkip.h |    2 +-
 net/mac80211/wep.c  |   18 ++++++++++++------
 net/mac80211/wep.h  |    2 +-
 net/mac80211/wpa.c  |    5 ++---
 7 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e55970b..5b8b446 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -143,6 +143,11 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
+	/* reject WEP and TKIP keys if WEP failed to initialize */
+	if ((alg == ALG_WEP || alg == ALG_TKIP) &&
+	    IS_ERR(sdata->local->wep_tx_tfm))
+		return -EINVAL;
+
 	key = ieee80211_key_alloc(alg, key_idx, params->key_len, params->key,
 				  params->seq_len, params->seq);
 	if (!key)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index edf7aff..0e95c75 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -637,11 +637,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_sta_info;
 
 	result = ieee80211_wep_init(local);
-	if (result < 0) {
+	if (result < 0)
 		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
 		       wiphy_name(local->hw.wiphy), result);
-		goto fail_wep;
-	}
 
 	rtnl_lock();
 
@@ -694,7 +692,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  fail_rate:
 	rtnl_unlock();
 	ieee80211_wep_free(local);
- fail_wep:
 	sta_info_stop(local);
  fail_sta_info:
 	destroy_workqueue(local->workqueue);
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 7ef491e..e840c9c 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -202,9 +202,9 @@ EXPORT_SYMBOL(ieee80211_get_tkip_key);
  * @payload_len is the length of payload (_not_ including IV/ICV length).
  * @ta is the transmitter addresses.
  */
-void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
-				 struct ieee80211_key *key,
-				 u8 *pos, size_t payload_len, u8 *ta)
+int ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
+				struct ieee80211_key *key,
+				u8 *pos, size_t payload_len, u8 *ta)
 {
 	u8 rc4key[16];
 	struct tkip_ctx *ctx = &key->u.tkip.tx;
@@ -216,7 +216,7 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 
 	tkip_mixing_phase2(tk, ctx, ctx->iv16, rc4key);
 
-	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
+	return ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
 
 /* Decrypt packet payload with TKIP using @key. @pos is a pointer to the
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index d471438..7e83dee 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -15,7 +15,7 @@
 
 u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key, u16 iv16);
 
-void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
+int ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta);
 enum {
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 5f3a411..54263db 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -122,19 +122,24 @@ static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
 /* Perform WEP encryption using given key. data buffer must have tailroom
  * for 4-byte ICV. data_len must not include this ICV. Note: this function
  * does _not_ add IV. data = RC4(data | CRC32(data)) */
-void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
-				size_t klen, u8 *data, size_t data_len)
+int ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
+			       size_t klen, u8 *data, size_t data_len)
 {
 	struct blkcipher_desc desc = { .tfm = tfm };
 	struct scatterlist sg;
 	__le32 icv;
 
+	if (IS_ERR(tfm))
+		return -1;
+
 	icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 	put_unaligned(icv, (__le32 *)(data + data_len));
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
 	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
+
+	return 0;
 }
 
 
@@ -168,10 +173,8 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	/* Add room for ICV */
 	skb_put(skb, WEP_ICV_LEN);
 
-	ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, keylen + 3,
-				   iv + WEP_IV_LEN, len);
-
-	return 0;
+	return ieee80211_wep_encrypt_data(local->wep_tx_tfm, rc4key, keylen + 3,
+					  iv + WEP_IV_LEN, len);
 }
 
 
@@ -185,6 +188,9 @@ int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	struct scatterlist sg;
 	__le32 crc;
 
+	if (IS_ERR(tfm))
+		return -1;
+
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
 	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_decrypt(&desc, &sg, &sg, sg.length);
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index fe29d7e..58654ee 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -18,7 +18,7 @@
 
 int ieee80211_wep_init(struct ieee80211_local *local);
 void ieee80211_wep_free(struct ieee80211_local *local);
-void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
+int ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index a14e677..8d59d27 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -183,9 +183,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	skb_put(skb, TKIP_ICV_LEN);
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-	ieee80211_tkip_encrypt_data(tx->local->wep_tx_tfm,
-				    key, pos, len, hdr->addr2);
-	return 0;
+	return ieee80211_tkip_encrypt_data(tx->local->wep_tx_tfm,
+					   key, pos, len, hdr->addr2);
 }
 
 
-- 
1.7.1

