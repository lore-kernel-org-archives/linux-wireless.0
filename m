Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbbGHMmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/10] mac80211: remove ieee80211_aes_cmac_calculate_k1_k2()
Date: Wed,  8 Jul 2015 15:41:48 +0300
Message-Id: <1436359312-26533-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144254_350866_ECD76AB0)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwlwifi driver was the only driver that used this, but as
it turns out it never needed it, so we can remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  | 13 -------------
 net/mac80211/aes_cmac.c | 17 -----------------
 2 files changed, 30 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 484cc14..e3314e5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4331,19 +4331,6 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 			    struct sk_buff *skb, u8 *p2k);
 
 /**
- * ieee80211_aes_cmac_calculate_k1_k2 - calculate the AES-CMAC sub keys
- *
- * This function computes the two AES-CMAC sub-keys, based on the
- * previously installed master key.
- *
- * @keyconf: the parameter passed with the set key
- * @k1: a buffer to be filled with the 1st sub-key
- * @k2: a buffer to be filled with the 2nd sub-key
- */
-void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
-					u8 *k1, u8 *k2);
-
-/**
  * ieee80211_get_key_tx_seq - get key TX sequence counter
  *
  * @keyconf: the parameter passed with the set key
diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 4192806..bdf0790 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -145,20 +145,3 @@ void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm)
 {
 	crypto_free_cipher(tfm);
 }
-
-void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
-					u8 *k1, u8 *k2)
-{
-	u8 l[AES_BLOCK_SIZE] = {};
-	struct ieee80211_key *key =
-		container_of(keyconf, struct ieee80211_key, conf);
-
-	crypto_cipher_encrypt_one(key->u.aes_cmac.tfm, l, l);
-
-	memcpy(k1, l, AES_BLOCK_SIZE);
-	gf_mulx(k1);
-
-	memcpy(k2, k1, AES_BLOCK_SIZE);
-	gf_mulx(k2);
-}
-EXPORT_SYMBOL(ieee80211_aes_cmac_calculate_k1_k2);
-- 
2.1.4

