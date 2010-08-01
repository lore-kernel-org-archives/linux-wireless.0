Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52699 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0HAQhQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 12:37:16 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Marcin Owsiany <porridge@debian.org>, 550739@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 17:37:03 +0100
Message-ID: <1280680623.13192.382.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] mac80211: Don't squash error codes in key setup functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_add_key() currently returns -ENOMEM in case of any error,
including a missing crypto algorithm.  Change ieee80211_key_alloc()
and ieee80211_aes_{key_setup_encrypt,cmac_key_setup}() to encode
errors with ERR_PTR() rather than returning NULL, and change
ieee80211_add_key() accordingly.

Compile-tested only.

Reported-by: Marcin Owsiany <porridge@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/aes_ccm.c  |    6 ++----
 net/mac80211/aes_cmac.c |    6 ++----
 net/mac80211/cfg.c      |    4 ++--
 net/mac80211/key.c      |   14 ++++++++------
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index a87cb3b..d2b03e0 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -138,10 +138,8 @@ struct crypto_cipher *ieee80211_aes_key_setup_encrypt(const u8 key[])
 	struct crypto_cipher *tfm;
 
 	tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return NULL;
-
-	crypto_cipher_setkey(tfm, key, ALG_CCMP_KEY_LEN);
+	if (!IS_ERR(tfm))
+		crypto_cipher_setkey(tfm, key, ALG_CCMP_KEY_LEN);
 
 	return tfm;
 }
diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 3d097b3..b4d66cc 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -119,10 +119,8 @@ struct crypto_cipher * ieee80211_aes_cmac_key_setup(const u8 key[])
 	struct crypto_cipher *tfm;
 
 	tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return NULL;
-
-	crypto_cipher_setkey(tfm, key, AES_CMAC_KEY_LEN);
+	if (!IS_ERR(tfm))
+		crypto_cipher_setkey(tfm, key, AES_CMAC_KEY_LEN);
 
 	return tfm;
 }
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index db4d934..34f32e3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -150,8 +150,8 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	key = ieee80211_key_alloc(alg, key_idx, params->key_len, params->key,
 				  params->seq_len, params->seq);
-	if (!key)
-		return -ENOMEM;
+	if (IS_ERR(key))
+		return PTR_ERR(key);
 
 	mutex_lock(&sdata->local->sta_mtx);
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 50d1cff..acf97d6 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -234,13 +234,13 @@ struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 					  size_t seq_len, const u8 *seq)
 {
 	struct ieee80211_key *key;
-	int i, j;
+	int i, j, err;
 
 	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS);
 
 	key = kzalloc(sizeof(struct ieee80211_key) + key_len, GFP_KERNEL);
 	if (!key)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/*
 	 * Default to software encryption; we'll later upload the
@@ -296,9 +296,10 @@ struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 		 * it does not need to be initialized for every packet.
 		 */
 		key->u.ccmp.tfm = ieee80211_aes_key_setup_encrypt(key_data);
-		if (!key->u.ccmp.tfm) {
+		if (IS_ERR(key->u.ccmp.tfm)) {
+			err = PTR_ERR(key->u.ccmp.tfm);
 			kfree(key);
-			return NULL;
+			key = ERR_PTR(err);
 		}
 	}
 
@@ -309,9 +310,10 @@ struct ieee80211_key *ieee80211_key_alloc(enum ieee80211_key_alg alg,
 		 */
 		key->u.aes_cmac.tfm =
 			ieee80211_aes_cmac_key_setup(key_data);
-		if (!key->u.aes_cmac.tfm) {
+		if (IS_ERR(key->u.aes_cmac.tfm)) {
+			err = PTR_ERR(key->u.aes_cmac.tfm);
 			kfree(key);
-			return NULL;
+			key = ERR_PTR(err);
 		}
 	}
 
-- 
1.7.1


