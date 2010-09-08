Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:8377 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757871Ab0IHHFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:22 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0301629519
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:19 +0900 (JST)
Subject: [PATCH 4/8] ath5k: Remove old ath5k key handling functions
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:49 +0900
Message-ID: <20100908070449.11255.48691.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the old ath5k key handling functions, since we now use the key
management in ath common.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    5 -
 drivers/net/wireless/ath/ath5k/pcu.c   |  191 --------------------------------
 drivers/net/wireless/ath/ath5k/reg.h   |   42 -------
 3 files changed, 0 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index f399c4d..932ed56 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1207,11 +1207,6 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high);
 unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec);
 unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock);
 unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah);
-/* Key table (WEP) functions */
-int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
-int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
-		     const struct ieee80211_key_conf *key, const u8 *mac);
-int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac);
 
 /* Queue Control Unit, DFS Control Unit Functions */
 int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index bb2e215..6a891c4 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -640,197 +640,6 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 
 }
 
-
-/*********************\
-* Key table functions *
-\*********************/
-
-/*
- * Reset a key entry on the table
- */
-int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
-{
-	unsigned int i, type;
-	u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
-
-	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
-
-	type = ath5k_hw_reg_read(ah, AR5K_KEYTABLE_TYPE(entry));
-
-	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
-		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
-
-	/* Reset associated MIC entry if TKIP
-	 * is enabled located at offset (entry + 64) */
-	if (type == AR5K_KEYTABLE_TYPE_TKIP) {
-		AR5K_ASSERT_ENTRY(micentry, AR5K_KEYTABLE_SIZE);
-		for (i = 0; i < AR5K_KEYCACHE_SIZE / 2 ; i++)
-			ath5k_hw_reg_write(ah, 0,
-				AR5K_KEYTABLE_OFF(micentry, i));
-	}
-
-	/*
-	 * Set NULL encryption on AR5212+
-	 *
-	 * Note: AR5K_KEYTABLE_TYPE -> AR5K_KEYTABLE_OFF(entry, 5)
-	 *       AR5K_KEYTABLE_TYPE_NULL -> 0x00000007
-	 *
-	 * Note2: Windows driver (ndiswrapper) sets this to
-	 *        0x00000714 instead of 0x00000007
-	 */
-	if (ah->ah_version >= AR5K_AR5211) {
-		ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
-				AR5K_KEYTABLE_TYPE(entry));
-
-		if (type == AR5K_KEYTABLE_TYPE_TKIP) {
-			ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
-				AR5K_KEYTABLE_TYPE(micentry));
-		}
-	}
-
-	return 0;
-}
-
-static
-int ath5k_keycache_type(const struct ieee80211_key_conf *key)
-{
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_TKIP:
-		return AR5K_KEYTABLE_TYPE_TKIP;
-	case WLAN_CIPHER_SUITE_CCMP:
-		return AR5K_KEYTABLE_TYPE_CCM;
-	case WLAN_CIPHER_SUITE_WEP40:
-		return AR5K_KEYTABLE_TYPE_40;
-	case WLAN_CIPHER_SUITE_WEP104:
-		return AR5K_KEYTABLE_TYPE_104;
-	default:
-		return -EINVAL;
-	}
-}
-
-/*
- * Set a key entry on the table
- */
-int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
-		const struct ieee80211_key_conf *key, const u8 *mac)
-{
-	unsigned int i;
-	int keylen;
-	__le32 key_v[5] = {};
-	__le32 key0 = 0, key1 = 0;
-	__le32 *rxmic, *txmic;
-	int keytype;
-	u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
-	bool is_tkip;
-	const u8 *key_ptr;
-
-	is_tkip = (key->cipher == WLAN_CIPHER_SUITE_TKIP);
-
-	/*
-	 * key->keylen comes in from mac80211 in bytes.
-	 * TKIP is 128 bit + 128 bit mic
-	 */
-	keylen = (is_tkip) ? (128 / 8) : key->keylen;
-
-	if (entry > AR5K_KEYTABLE_SIZE ||
-		(is_tkip && micentry > AR5K_KEYTABLE_SIZE))
-		return -EOPNOTSUPP;
-
-	if (unlikely(keylen > 16))
-		return -EOPNOTSUPP;
-
-	keytype = ath5k_keycache_type(key);
-	if (keytype < 0)
-		return keytype;
-
-	/*
-	 * each key block is 6 bytes wide, written as pairs of
-	 * alternating 32 and 16 bit le values.
-	 */
-	key_ptr = key->key;
-	for (i = 0; keylen >= 6; keylen -= 6) {
-		memcpy(&key_v[i], key_ptr, 6);
-		i += 2;
-		key_ptr += 6;
-	}
-	if (keylen)
-		memcpy(&key_v[i], key_ptr, keylen);
-
-	/* intentionally corrupt key until mic is installed */
-	if (is_tkip) {
-		key0 = key_v[0] = ~key_v[0];
-		key1 = key_v[1] = ~key_v[1];
-	}
-
-	for (i = 0; i < ARRAY_SIZE(key_v); i++)
-		ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
-				AR5K_KEYTABLE_OFF(entry, i));
-
-	ath5k_hw_reg_write(ah, keytype, AR5K_KEYTABLE_TYPE(entry));
-
-	if (is_tkip) {
-		/* Install rx/tx MIC */
-		rxmic = (__le32 *) &key->key[16];
-		txmic = (__le32 *) &key->key[24];
-
-		if (ah->ah_combined_mic) {
-			key_v[0] = rxmic[0];
-			key_v[1] = cpu_to_le32(le32_to_cpu(txmic[0]) >> 16);
-			key_v[2] = rxmic[1];
-			key_v[3] = cpu_to_le32(le32_to_cpu(txmic[0]) & 0xffff);
-			key_v[4] = txmic[1];
-		} else {
-			key_v[0] = rxmic[0];
-			key_v[1] = 0;
-			key_v[2] = rxmic[1];
-			key_v[3] = 0;
-			key_v[4] = 0;
-		}
-		for (i = 0; i < ARRAY_SIZE(key_v); i++)
-			ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
-				AR5K_KEYTABLE_OFF(micentry, i));
-
-		ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
-			AR5K_KEYTABLE_TYPE(micentry));
-		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_MAC0(micentry));
-		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_MAC1(micentry));
-
-		/* restore first 2 words of key */
-		ath5k_hw_reg_write(ah, le32_to_cpu(~key0),
-			AR5K_KEYTABLE_OFF(entry, 0));
-		ath5k_hw_reg_write(ah, le32_to_cpu(~key1),
-			AR5K_KEYTABLE_OFF(entry, 1));
-	}
-
-	return ath5k_hw_set_key_lladdr(ah, entry, mac);
-}
-
-int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
-{
-	u32 low_id, high_id;
-
-	 /* Invalid entry (key table overflow) */
-	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
-
-	/*
-	 * MAC may be NULL if it's a broadcast key. In this case no need to
-	 * to compute get_unaligned_le32 and get_unaligned_le16 as we
-	 * already know it.
-	 */
-	if (!mac) {
-		low_id = 0xffffffff;
-		high_id = 0xffff | AR5K_KEYTABLE_VALID;
-	} else {
-		low_id = get_unaligned_le32(mac);
-		high_id = get_unaligned_le16(mac + 4) | AR5K_KEYTABLE_VALID;
-	}
-
-	ath5k_hw_reg_write(ah, low_id, AR5K_KEYTABLE_MAC0(entry));
-	ath5k_hw_reg_write(ah, high_id, AR5K_KEYTABLE_MAC1(entry));
-
-	return 0;
-}
-
 /**
  * ath5k_hw_set_coverage_class - Set IEEE 802.11 coverage class
  *
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 05ef587..67d6308 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1822,50 +1822,8 @@
 
 /*===5212 end===*/
 
-/*
- * Key table (WEP) register
- */
-#define AR5K_KEYTABLE_0_5210		0x9000
-#define AR5K_KEYTABLE_0_5211		0x8800
-#define AR5K_KEYTABLE_5210(_n)		(AR5K_KEYTABLE_0_5210 + ((_n) << 5))
-#define AR5K_KEYTABLE_5211(_n)		(AR5K_KEYTABLE_0_5211 + ((_n) << 5))
-#define	AR5K_KEYTABLE(_n)		(ah->ah_version == AR5K_AR5210 ? \
-					AR5K_KEYTABLE_5210(_n) : AR5K_KEYTABLE_5211(_n))
-#define AR5K_KEYTABLE_OFF(_n, x)	(AR5K_KEYTABLE(_n) + (x << 2))
-#define AR5K_KEYTABLE_TYPE(_n)		AR5K_KEYTABLE_OFF(_n, 5)
-#define AR5K_KEYTABLE_TYPE_40		0x00000000
-#define AR5K_KEYTABLE_TYPE_104		0x00000001
-#define AR5K_KEYTABLE_TYPE_128		0x00000003
-#define AR5K_KEYTABLE_TYPE_TKIP		0x00000004	/* [5212+] */
-#define AR5K_KEYTABLE_TYPE_AES		0x00000005	/* [5211+] */
-#define AR5K_KEYTABLE_TYPE_CCM		0x00000006	/* [5212+] */
-#define AR5K_KEYTABLE_TYPE_NULL		0x00000007	/* [5211+] */
-#define AR5K_KEYTABLE_ANTENNA		0x00000008	/* [5212+] */
-#define AR5K_KEYTABLE_MAC0(_n)		AR5K_KEYTABLE_OFF(_n, 6)
-#define AR5K_KEYTABLE_MAC1(_n)		AR5K_KEYTABLE_OFF(_n, 7)
-#define AR5K_KEYTABLE_VALID		0x00008000
-
-/* If key type is TKIP and MIC is enabled
- * MIC key goes in offset entry + 64 */
-#define	AR5K_KEYTABLE_MIC_OFFSET	64
-
-/* WEP 40-bit	= 40-bit  entered key + 24 bit IV = 64-bit
- * WEP 104-bit	= 104-bit entered key + 24-bit IV = 128-bit
- * WEP 128-bit	= 128-bit entered key + 24 bit IV = 152-bit
- *
- * Some vendors have introduced bigger WEP keys to address
- * security vulnerabilities in WEP. This includes:
- *
- * WEP 232-bit = 232-bit entered key + 24 bit IV = 256-bit
- *
- * We can expand this if we find ar5k Atheros cards with a larger
- * key table size.
- */
 #define AR5K_KEYTABLE_SIZE_5210		64
 #define AR5K_KEYTABLE_SIZE_5211		128
-#define	AR5K_KEYTABLE_SIZE		(ah->ah_version == AR5K_AR5210 ? \
-					AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211)
-
 
 /*===PHY REGISTERS===*/
 

