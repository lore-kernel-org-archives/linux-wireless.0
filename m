Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:13205 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757871Ab0IHHFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:11 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0428229508
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:09 +0900 (JST)
Subject: [PATCH 2/8] ath: Copy key cache management functions from ath9k to ath
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:38 +0900
Message-ID: <20100908070438.11255.44367.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Copied the key cache management functions from ath9k (common.c and hw.c) to
ath/key.c so we can use them from ath5k, later.

Minor changes have been made:
 - renamed ath9k_* to ath_*
 - replaced ah->caps.keycache_size with common->keymax
 - removed ATH9K_IS_MIC_ENABLED since it is always true.
 - the AR_PCU_MIC_NEW_LOC_ENA flag is replaced with (splitmic == 0).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/Makefile |    3 
 drivers/net/wireless/ath/ath.h    |   27 ++
 drivers/net/wireless/ath/key.c    |  568 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/reg.h    |   23 +
 4 files changed, 620 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/key.c

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 8113a50..9df4406 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
 ath-objs :=	main.o \
 		regd.o \
-		hw.o
+		hw.o \
+		key.o
 
 ath-$(CONFIG_ATH_DEBUG) += debug.o
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 057fdd7..fb24f66 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -80,6 +80,27 @@ enum ath_crypt_caps {
 	ATH_CRYPT_CAP_CIPHER_TKIP		= BIT(5),
 };
 
+struct ath_keyval {
+	u8 kv_type;
+	u8 kv_pad;
+	u16 kv_len;
+	u8 kv_val[16]; /* TK */
+	u8 kv_mic[8]; /* Michael MIC key */
+	u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
+			 * supports both MIC keys in the same key cache entry;
+			 * in that case, kv_mic is the RX key) */
+};
+
+enum ath_cipher {
+	ATH_CIPHER_WEP = 0,
+	ATH_CIPHER_AES_OCB = 1,
+	ATH_CIPHER_AES_CCM = 2,
+	ATH_CIPHER_CKIP = 3,
+	ATH_CIPHER_TKIP = 4,
+	ATH_CIPHER_CLR = 5,
+	ATH_CIPHER_MIC = 127
+};
+
 /**
  * struct ath_ops - Register read/write operations
  *
@@ -142,5 +163,11 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 				gfp_t gfp_mask);
 
 void ath_hw_setbssidmask(struct ath_common *common);
+void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
+int ath_key_config(struct ath_common *common,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key);
+bool ath_hw_keyreset(struct ath_common *common, u16 entry);
 
 #endif /* ATH_H */
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
new file mode 100644
index 0000000..e45b854
--- /dev/null
+++ b/drivers/net/wireless/ath/key.c
@@ -0,0 +1,568 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
+ * Copyright (c) 2010 Bruno Randolf <br1@einfach.org>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <asm/unaligned.h>
+#include <net/mac80211.h>
+
+#include "ath.h"
+#include "reg.h"
+#include "debug.h"
+
+#define REG_READ			(common->ops->read)
+#define REG_WRITE(_ah, _reg, _val)	(common->ops->write)(_ah, _val, _reg)
+
+#define IEEE80211_WEP_NKID      4       /* number of key ids */
+
+/************************/
+/* Key Cache Management */
+/************************/
+
+bool ath_hw_keyreset(struct ath_common *common, u16 entry)
+{
+	u32 keyType;
+	void *ah = common->ah;
+
+	if (entry >= common->keymax) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "keychache entry %u out of range\n", entry);
+		return false;
+	}
+
+	keyType = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
+
+	REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), AR_KEYTABLE_TYPE_CLR);
+	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), 0);
+
+	if (keyType == AR_KEYTABLE_TYPE_TKIP) {
+		u16 micentry = entry + 64;
+
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(ath_hw_keyreset);
+
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac)
+{
+	u32 macHi, macLo;
+	u32 unicast_flag = AR_KEYTABLE_VALID;
+	void *ah = common->ah;
+
+	if (entry >= common->keymax) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "keychache entry %u out of range\n", entry);
+		return false;
+	}
+
+	if (mac != NULL) {
+		/*
+		 * AR_KEYTABLE_VALID indicates that the address is a unicast
+		 * address, which must match the transmitter address for
+		 * decrypting frames.
+		 * Not setting this bit allows the hardware to use the key
+		 * for multicast frame decryption.
+		 */
+		if (mac[0] & 0x01)
+			unicast_flag = 0;
+
+		macHi = (mac[5] << 8) | mac[4];
+		macLo = (mac[3] << 24) |
+			(mac[2] << 16) |
+			(mac[1] << 8) |
+			mac[0];
+		macLo >>= 1;
+		macLo |= (macHi & 1) << 31;
+		macHi >>= 1;
+	} else {
+		macLo = macHi = 0;
+	}
+	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
+	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | unicast_flag);
+
+	return true;
+}
+
+bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
+				 const struct ath_keyval *k,
+				 const u8 *mac)
+{
+	void *ah = common->ah;
+	u32 key0, key1, key2, key3, key4;
+	u32 keyType;
+
+	if (entry >= common->keymax) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "keycache entry %u out of range\n", entry);
+		return false;
+	}
+
+	switch (k->kv_type) {
+	case ATH_CIPHER_AES_OCB:
+		keyType = AR_KEYTABLE_TYPE_AES;
+		break;
+	case ATH_CIPHER_AES_CCM:
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)) {
+			ath_print(common, ATH_DBG_ANY,
+				  "AES-CCM not supported by this mac rev\n");
+			return false;
+		}
+		keyType = AR_KEYTABLE_TYPE_CCM;
+		break;
+	case ATH_CIPHER_TKIP:
+		keyType = AR_KEYTABLE_TYPE_TKIP;
+		if (entry + 64 >= common->keymax) {
+			ath_print(common, ATH_DBG_ANY,
+				  "entry %u inappropriate for TKIP\n", entry);
+			return false;
+		}
+		break;
+	case ATH_CIPHER_WEP:
+		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
+			ath_print(common, ATH_DBG_ANY,
+				  "WEP key length %u too small\n", k->kv_len);
+			return false;
+		}
+		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
+			keyType = AR_KEYTABLE_TYPE_40;
+		else if (k->kv_len <= WLAN_KEY_LEN_WEP104)
+			keyType = AR_KEYTABLE_TYPE_104;
+		else
+			keyType = AR_KEYTABLE_TYPE_128;
+		break;
+	case ATH_CIPHER_CLR:
+		keyType = AR_KEYTABLE_TYPE_CLR;
+		break;
+	default:
+		ath_print(common, ATH_DBG_FATAL,
+			  "cipher %u not supported\n", k->kv_type);
+		return false;
+	}
+
+	key0 = get_unaligned_le32(k->kv_val + 0);
+	key1 = get_unaligned_le16(k->kv_val + 4);
+	key2 = get_unaligned_le32(k->kv_val + 6);
+	key3 = get_unaligned_le16(k->kv_val + 10);
+	key4 = get_unaligned_le32(k->kv_val + 12);
+	if (k->kv_len <= WLAN_KEY_LEN_WEP104)
+		key4 &= 0xff;
+
+	/*
+	 * Note: Key cache registers access special memory area that requires
+	 * two 32-bit writes to actually update the values in the internal
+	 * memory. Consequently, the exact order and pairs used here must be
+	 * maintained.
+	 */
+
+	if (keyType == AR_KEYTABLE_TYPE_TKIP) {
+		u16 micentry = entry + 64;
+
+		/*
+		 * Write inverted key[47:0] first to avoid Michael MIC errors
+		 * on frames that could be sent or received at the same time.
+		 * The correct key will be written in the end once everything
+		 * else is ready.
+		 */
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), ~key0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), ~key1);
+
+		/* Write key[95:48] */
+		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
+		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
+
+		/* Write key[127:96] and key type */
+		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
+		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
+
+		/* Write MAC address for the entry */
+		(void) ath_hw_keysetmac(common, entry, mac);
+
+		if (common->splitmic == 0) {
+			/*
+			 * TKIP uses two key cache entries:
+			 * Michael MIC TX/RX keys in the same key cache entry
+			 * (idx = main index + 64):
+			 * key0 [31:0] = RX key [31:0]
+			 * key1 [15:0] = TX key [31:16]
+			 * key1 [31:16] = reserved
+			 * key2 [31:0] = RX key [63:32]
+			 * key3 [15:0] = TX key [15:0]
+			 * key3 [31:16] = reserved
+			 * key4 [31:0] = TX key [63:32]
+			 */
+			u32 mic0, mic1, mic2, mic3, mic4;
+
+			mic0 = get_unaligned_le32(k->kv_mic + 0);
+			mic2 = get_unaligned_le32(k->kv_mic + 4);
+			mic1 = get_unaligned_le16(k->kv_txmic + 2) & 0xffff;
+			mic3 = get_unaligned_le16(k->kv_txmic + 0) & 0xffff;
+			mic4 = get_unaligned_le32(k->kv_txmic + 4);
+
+			/* Write RX[31:0] and TX[31:16] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
+			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), mic1);
+
+			/* Write RX[63:32] and TX[15:0] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
+			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), mic3);
+
+			/* Write TX[63:32] and keyType(reserved) */
+			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), mic4);
+			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
+				  AR_KEYTABLE_TYPE_CLR);
+
+		} else {
+			/*
+			 * TKIP uses four key cache entries (two for group
+			 * keys):
+			 * Michael MIC TX/RX keys are in different key cache
+			 * entries (idx = main index + 64 for TX and
+			 * main index + 32 + 96 for RX):
+			 * key0 [31:0] = TX/RX MIC key [31:0]
+			 * key1 [31:0] = reserved
+			 * key2 [31:0] = TX/RX MIC key [63:32]
+			 * key3 [31:0] = reserved
+			 * key4 [31:0] = reserved
+			 *
+			 * Upper layer code will call this function separately
+			 * for TX and RX keys when these registers offsets are
+			 * used.
+			 */
+			u32 mic0, mic2;
+
+			mic0 = get_unaligned_le32(k->kv_mic + 0);
+			mic2 = get_unaligned_le32(k->kv_mic + 4);
+
+			/* Write MIC key[31:0] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
+			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
+
+			/* Write MIC key[63:32] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
+			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+
+			/* Write TX[63:32] and keyType(reserved) */
+			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
+			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
+				  AR_KEYTABLE_TYPE_CLR);
+		}
+
+		/* MAC address registers are reserved for the MIC entry */
+		REG_WRITE(ah, AR_KEYTABLE_MAC0(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_MAC1(micentry), 0);
+
+		/*
+		 * Write the correct (un-inverted) key[47:0] last to enable
+		 * TKIP now that all other registers are set with correct
+		 * values.
+		 */
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
+	} else {
+		/* Write key[47:0] */
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
+
+		/* Write key[95:48] */
+		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
+		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
+
+		/* Write key[127:96] and key type */
+		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
+		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
+
+		/* Write MAC address for the entry */
+		(void) ath_hw_keysetmac(common, entry, mac);
+	}
+
+	return true;
+}
+
+static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
+			   struct ath_keyval *hk, const u8 *addr,
+			   bool authenticator)
+{
+	const u8 *key_rxmic;
+	const u8 *key_txmic;
+
+	key_txmic = key + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
+	key_rxmic = key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
+
+	if (addr == NULL) {
+		/*
+		 * Group key installation - only two key cache entries are used
+		 * regardless of splitmic capability since group key is only
+		 * used either for TX or RX.
+		 */
+		if (authenticator) {
+			memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
+			memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_mic));
+		} else {
+			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
+		}
+		return ath_hw_set_keycache_entry(common, keyix, hk, addr);
+	}
+	if (!common->splitmic) {
+		/* TX and RX keys share the same key cache entry. */
+		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
+		return ath_hw_set_keycache_entry(common, keyix, hk, addr);
+	}
+
+	/* Separate key cache entries for TX and RX */
+
+	/* TX key goes at first index, RX key at +32. */
+	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
+	if (!ath_hw_set_keycache_entry(common, keyix, hk, NULL)) {
+		/* TX MIC entry failed. No need to proceed further */
+		ath_print(common, ATH_DBG_FATAL,
+			  "Setting TX MIC Key Failed\n");
+		return 0;
+	}
+
+	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+	/* XXX delete tx key on failure? */
+	return ath_hw_set_keycache_entry(common, keyix + 32, hk, addr);
+}
+
+static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
+{
+	int i;
+
+	for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
+		if (test_bit(i, common->keymap) ||
+		    test_bit(i + 64, common->keymap))
+			continue; /* At least one part of TKIP key allocated */
+		if (common->splitmic &&
+		    (test_bit(i + 32, common->keymap) ||
+		     test_bit(i + 64 + 32, common->keymap)))
+			continue; /* At least one part of TKIP key allocated */
+
+		/* Found a free slot for a TKIP key */
+		return i;
+	}
+	return -1;
+}
+
+static int ath_reserve_key_cache_slot(struct ath_common *common,
+				      u32 cipher)
+{
+	int i;
+
+	if (cipher == WLAN_CIPHER_SUITE_TKIP)
+		return ath_reserve_key_cache_slot_tkip(common);
+
+	/* First, try to find slots that would not be available for TKIP. */
+	if (common->splitmic) {
+		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
+			if (!test_bit(i, common->keymap) &&
+			    (test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
+				return i;
+			if (!test_bit(i + 32, common->keymap) &&
+			    (test_bit(i, common->keymap) ||
+			     test_bit(i + 64, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
+				return i + 32;
+			if (!test_bit(i + 64, common->keymap) &&
+			    (test_bit(i , common->keymap) ||
+			     test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
+				return i + 64;
+			if (!test_bit(i + 64 + 32, common->keymap) &&
+			    (test_bit(i, common->keymap) ||
+			     test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64, common->keymap)))
+				return i + 64 + 32;
+		}
+	} else {
+		for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
+			if (!test_bit(i, common->keymap) &&
+			    test_bit(i + 64, common->keymap))
+				return i;
+			if (test_bit(i, common->keymap) &&
+			    !test_bit(i + 64, common->keymap))
+				return i + 64;
+		}
+	}
+
+	/* No partially used TKIP slots, pick any available slot */
+	for (i = IEEE80211_WEP_NKID; i < common->keymax; i++) {
+		/* Do not allow slots that could be needed for TKIP group keys
+		 * to be used. This limitation could be removed if we know that
+		 * TKIP will not be used. */
+		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
+			continue;
+		if (common->splitmic) {
+			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
+				continue;
+			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
+				continue;
+		}
+
+		if (!test_bit(i, common->keymap))
+			return i; /* Found a free slot for a key */
+	}
+
+	/* No free slot found */
+	return -1;
+}
+
+/*
+ * Configure encryption in the HW.
+ */
+int ath_key_config(struct ath_common *common,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key)
+{
+	struct ath_keyval hk;
+	const u8 *mac = NULL;
+	u8 gmac[ETH_ALEN];
+	int ret = 0;
+	int idx;
+
+	memset(&hk, 0, sizeof(hk));
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		hk.kv_type = ATH_CIPHER_WEP;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		hk.kv_type = ATH_CIPHER_TKIP;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		hk.kv_type = ATH_CIPHER_AES_CCM;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	hk.kv_len = key->keylen;
+	memcpy(hk.kv_val, key->key, key->keylen);
+
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		switch (vif->type) {
+		case NL80211_IFTYPE_AP:
+			memcpy(gmac, vif->addr, ETH_ALEN);
+			gmac[0] |= 0x01;
+			mac = gmac;
+			idx = ath_reserve_key_cache_slot(common, key->cipher);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			if (!sta) {
+				idx = key->keyidx;
+				break;
+			}
+			memcpy(gmac, sta->addr, ETH_ALEN);
+			gmac[0] |= 0x01;
+			mac = gmac;
+			idx = ath_reserve_key_cache_slot(common, key->cipher);
+			break;
+		default:
+			idx = key->keyidx;
+			break;
+		}
+	} else if (key->keyidx) {
+		if (WARN_ON(!sta))
+			return -EOPNOTSUPP;
+		mac = sta->addr;
+
+		if (vif->type != NL80211_IFTYPE_AP) {
+			/* Only keyidx 0 should be used with unicast key, but
+			 * allow this for client mode for now. */
+			idx = key->keyidx;
+		} else
+			return -EIO;
+	} else {
+		if (WARN_ON(!sta))
+			return -EOPNOTSUPP;
+		mac = sta->addr;
+
+		idx = ath_reserve_key_cache_slot(common, key->cipher);
+	}
+
+	if (idx < 0)
+		return -ENOSPC; /* no free key cache entries */
+
+	if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
+		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
+				      vif->type == NL80211_IFTYPE_AP);
+	else
+		ret = ath_hw_set_keycache_entry(common, idx, &hk, mac);
+
+	if (!ret)
+		return -EIO;
+
+	set_bit(idx, common->keymap);
+	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
+		set_bit(idx + 64, common->keymap);
+		set_bit(idx, common->tkip_keymap);
+		set_bit(idx + 64, common->tkip_keymap);
+		if (common->splitmic) {
+			set_bit(idx + 32, common->keymap);
+			set_bit(idx + 64 + 32, common->keymap);
+			set_bit(idx + 32, common->tkip_keymap);
+			set_bit(idx + 64 + 32, common->tkip_keymap);
+		}
+	}
+
+	return idx;
+}
+EXPORT_SYMBOL(ath_key_config);
+
+/*
+ * Delete Key.
+ */
+void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
+{
+	ath_hw_keyreset(common, key->hw_key_idx);
+	if (key->hw_key_idx < IEEE80211_WEP_NKID)
+		return;
+
+	clear_bit(key->hw_key_idx, common->keymap);
+	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
+		return;
+
+	clear_bit(key->hw_key_idx + 64, common->keymap);
+
+	clear_bit(key->hw_key_idx, common->tkip_keymap);
+	clear_bit(key->hw_key_idx + 64, common->tkip_keymap);
+
+	if (common->splitmic) {
+		ath_hw_keyreset(common, key->hw_key_idx + 32);
+		clear_bit(key->hw_key_idx + 32, common->keymap);
+		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
+
+		clear_bit(key->hw_key_idx + 32, common->tkip_keymap);
+		clear_bit(key->hw_key_idx + 64 + 32, common->tkip_keymap);
+	}
+}
+EXPORT_SYMBOL(ath_key_delete);
diff --git a/drivers/net/wireless/ath/reg.h b/drivers/net/wireless/ath/reg.h
index dfe1fbe..e798ef4 100644
--- a/drivers/net/wireless/ath/reg.h
+++ b/drivers/net/wireless/ath/reg.h
@@ -24,4 +24,27 @@
 #define AR_BSSMSKL		0x80e0
 #define AR_BSSMSKU		0x80e4
 
+#define AR_KEYTABLE_0           0x8800
+#define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
+#define AR_KEY_CACHE_SIZE       128
+#define AR_RSVD_KEYTABLE_ENTRIES 4
+#define AR_KEY_TYPE             0x00000007
+#define AR_KEYTABLE_TYPE_40     0x00000000
+#define AR_KEYTABLE_TYPE_104    0x00000001
+#define AR_KEYTABLE_TYPE_128    0x00000003
+#define AR_KEYTABLE_TYPE_TKIP   0x00000004
+#define AR_KEYTABLE_TYPE_AES    0x00000005
+#define AR_KEYTABLE_TYPE_CCM    0x00000006
+#define AR_KEYTABLE_TYPE_CLR    0x00000007
+#define AR_KEYTABLE_ANT         0x00000008
+#define AR_KEYTABLE_VALID       0x00008000
+#define AR_KEYTABLE_KEY0(_n)    (AR_KEYTABLE(_n) + 0)
+#define AR_KEYTABLE_KEY1(_n)    (AR_KEYTABLE(_n) + 4)
+#define AR_KEYTABLE_KEY2(_n)    (AR_KEYTABLE(_n) + 8)
+#define AR_KEYTABLE_KEY3(_n)    (AR_KEYTABLE(_n) + 12)
+#define AR_KEYTABLE_KEY4(_n)    (AR_KEYTABLE(_n) + 16)
+#define AR_KEYTABLE_TYPE(_n)    (AR_KEYTABLE(_n) + 20)
+#define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)
+#define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)
+
 #endif /* ATH_REGISTERS_H */

