Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:39491 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYKZVRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 16:17:33 -0500
Received: by qw-out-2122.google.com with SMTP id 3so186027qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 13:17:31 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: jirislaby@gmail.com, nbd@openwrt.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, linville@tuxdriver.com
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Date: Wed, 26 Nov 2008 16:17:18 -0500
Message-Id: <20081126211718.16875.65815.sendpatchset@localhost> (sfid-20081126_221736_165969_88AEFBB3)
In-Reply-To: <20081126211711.16875.71258.sendpatchset@localhost>
References: <20081126211711.16875.71258.sendpatchset@localhost>
Subject: [PATCH 2/3] ath5k: clean up ath5k_hw_set_key
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the addition of TKIP (and soon CCMP), key->alg is a more useful
guide to key type than the key length.

This patch cleans up key type assignment in ath5k_hw_set_key by
extracting the keytype assignment.  It also replaces the separate
memcpy() calls for extracting key material into the hardware format
with a loop that works regardless of key size.

Finally, the patch removes support for WEP-128 since it is a
non-standard key length that mac80211 also doesn't use.

Changes-licensed-under: ISC
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/pcu.c |   58 ++++++++++++++++++++++---------------
 1 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index 79879f2..86ca54b 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -1013,6 +1013,23 @@ int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
 		AR5K_KEYTABLE_VALID;
 }
 
+static
+int ath5k_keycache_type(const struct ieee80211_key_conf *key)
+{
+	switch (key->alg) {
+	case ALG_TKIP:
+		return AR5K_KEYTABLE_TYPE_TKIP;
+	case ALG_CCMP:
+		return AR5K_KEYTABLE_TYPE_CCM;
+	case ALG_WEP:
+		if (key->len == WEP40)
+			return AR5K_KEYTABLE_TYPE_40;
+		else if (key->len == WEP104)
+			return AR5K_KEYTABLE_TYPE_104;
+	}
+	return -EINVAL;
+}
+
 /*
  * Set a key entry on the table
  */
@@ -1027,6 +1044,7 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 	u32 keytype;
 	u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
 	bool is_tkip;
+	const u8 *key_ptr;
 
 	ATH5K_TRACE(ah->ah_sc);
 
@@ -1042,33 +1060,25 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 		(is_tkip && micentry > AR5K_KEYTABLE_SIZE))
 		return -EOPNOTSUPP;
 
-	switch (keylen) {
-	/* WEP 40-bit   = 40-bit  entered key + 24 bit IV = 64-bit */
-	case 40 / 8:
-		memcpy(&key_v[0], key->key, 5);
-		keytype = AR5K_KEYTABLE_TYPE_40;
-		break;
+	if (unlikely(keylen > 16))
+		return -EOPNOTSUPP;
 
-	/* WEP 104-bit  = 104-bit entered key + 24-bit IV = 128-bit */
-	case 104 / 8:
-		memcpy(&key_v[0], &key->key[0], 6);
-		memcpy(&key_v[2], &key->key[6], 6);
-		memcpy(&key_v[4], &key->key[12], 1);
-		keytype = AR5K_KEYTABLE_TYPE_104;
-		break;
-	/* WEP/TKIP 128-bit  = 128-bit entered key + 24 bit IV = 152-bit */
-	case 128 / 8:
-		memcpy(&key_v[0], &key->key[0], 6);
-		memcpy(&key_v[2], &key->key[6], 6);
-		memcpy(&key_v[4], &key->key[12], 4);
-		keytype = is_tkip ?
-			AR5K_KEYTABLE_TYPE_TKIP :
-			AR5K_KEYTABLE_TYPE_128;
-		break;
+	keytype = ath5k_keycache_type(key);
+	if (keytype < 0)
+		return keytype;
 
-	default:
-		return -EINVAL; /* shouldn't happen */
+	/*
+	 * each key block is 6 bytes wide, written as pairs of
+	 * alternating 32 and 16 bit le values.
+	 */
+	key_ptr = key->key;
+	for (i = 0; keylen >= 6; keylen -= 6) {
+		memcpy(&key_v[i], key_ptr, 6);
+		i += 2;
+		key_ptr += 6;
 	}
+	if (keylen)
+		memcpy(&key_v[i], key_ptr, keylen);
 
 	/* intentionally corrupt key until mic is installed */
 	if (is_tkip) {
-- 
1.5.4.2.182.gb3092

