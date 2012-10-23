Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab2JWMR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 08:17:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH] mac80211: expose AES-CMAC subkey calculation
Date: Tue, 23 Oct 2012 14:17:58 +0200
Message-Id: <1350994678-14752-1-git-send-email-johannes@sipsolutions.net> (sfid-20121023_141731_452545_766734B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Expose a function for the AES-CMAC subkey calculation
to drivers. This is the first step of the AES-CMAC
cipher key setup and may be required for CMAC hardware
offloading.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |   13 +++++++++++++
 net/mac80211/aes_cmac.c |   17 +++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71c2f9c..00b7204 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3223,6 +3223,19 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 			    struct sk_buff *skb, u8 *p2k);
 
 /**
+ * ieee80211_aes_cmac_calculate_k1_k2 - calculate the AES-CMAC sub keys
+ *
+ * This function computes the two AES-CMAC sub-keys, based on the
+ * previously installed master key.
+ *
+ * @keyconf: the parameter passed with the set key
+ * @k1: a buffer to be filled with the 1st sub-key
+ * @k2: a buffer to be filled with the 2nd sub-key
+ */
+void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
+					u8 *k1, u8 *k2);
+
+/**
  * struct ieee80211_key_seq - key sequence counter
  *
  * @tkip: TKIP data, containing IV32 and IV16 in host byte order
diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index a04752e..4933535 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -126,3 +126,20 @@ void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm)
 {
 	crypto_free_cipher(tfm);
 }
+
+void ieee80211_aes_cmac_calculate_k1_k2(struct ieee80211_key_conf *keyconf,
+					u8 *k1, u8 *k2)
+{
+	u8 l[AES_BLOCK_SIZE] = {};
+	struct ieee80211_key *key =
+		container_of(keyconf, struct ieee80211_key, conf);
+
+	crypto_cipher_encrypt_one(key->u.aes_cmac.tfm, l, l);
+
+	memcpy(k1, l, AES_BLOCK_SIZE);
+	gf_mulx(k1);
+
+	memcpy(k2, k1, AES_BLOCK_SIZE);
+	gf_mulx(k2);
+}
+EXPORT_SYMBOL(ieee80211_aes_cmac_calculate_k1_k2);
-- 
1.7.10.4

