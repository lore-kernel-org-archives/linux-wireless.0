Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:29991 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757729Ab0IHHFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:36 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-029849535
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:35 +0900 (JST)
Subject: [PATCH 7/8] ath9k: Use common ath key management functions
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:05:04 +0900
Message-ID: <20100908070504.11255.52567.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use key management functions which have been moved to ath/key.c and remove
ath9k copies of these functions and other now unused definitions.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath9k/common.c       |  270 ------------------------
 drivers/net/wireless/ath/ath9k/common.h       |    6 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 
 drivers/net/wireless/ath/ath9k/hw.c           |  276 -------------------------
 drivers/net/wireless/ath/ath9k/hw.h           |    6 -
 drivers/net/wireless/ath/ath9k/init.c         |    2 
 drivers/net/wireless/ath/ath9k/mac.h          |   21 --
 drivers/net/wireless/ath/ath9k/main.c         |    4 
 drivers/net/wireless/ath/ath9k/phy.h          |    3 
 10 files changed, 6 insertions(+), 588 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 2db24eb..f43a2d9 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -148,276 +148,6 @@ struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ath9k_cmn_get_curchannel);
 
-static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
-			   struct ath9k_keyval *hk, const u8 *addr,
-			   bool authenticator)
-{
-	struct ath_hw *ah = common->ah;
-	const u8 *key_rxmic;
-	const u8 *key_txmic;
-
-	key_txmic = key + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
-	key_rxmic = key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
-
-	if (addr == NULL) {
-		/*
-		 * Group key installation - only two key cache entries are used
-		 * regardless of splitmic capability since group key is only
-		 * used either for TX or RX.
-		 */
-		if (authenticator) {
-			memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-			memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_mic));
-		} else {
-			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
-			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
-		}
-		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
-	}
-	if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) {
-		/* TX and RX keys share the same key cache entry. */
-		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
-		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
-		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
-	}
-
-	/* Separate key cache entries for TX and RX */
-
-	/* TX key goes at first index, RX key at +32. */
-	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-	if (!ath9k_hw_set_keycache_entry(ah, keyix, hk, NULL)) {
-		/* TX MIC entry failed. No need to proceed further */
-		ath_print(common, ATH_DBG_FATAL,
-			  "Setting TX MIC Key Failed\n");
-		return 0;
-	}
-
-	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
-	/* XXX delete tx key on failure? */
-	return ath9k_hw_set_keycache_entry(ah, keyix + 32, hk, addr);
-}
-
-static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
-{
-	int i;
-
-	for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
-		if (test_bit(i, common->keymap) ||
-		    test_bit(i + 64, common->keymap))
-			continue; /* At least one part of TKIP key allocated */
-		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) &&
-		    (test_bit(i + 32, common->keymap) ||
-		     test_bit(i + 64 + 32, common->keymap)))
-			continue; /* At least one part of TKIP key allocated */
-
-		/* Found a free slot for a TKIP key */
-		return i;
-	}
-	return -1;
-}
-
-static int ath_reserve_key_cache_slot(struct ath_common *common,
-				      u32 cipher)
-{
-	int i;
-
-	if (cipher == WLAN_CIPHER_SUITE_TKIP)
-		return ath_reserve_key_cache_slot_tkip(common);
-
-	/* First, try to find slots that would not be available for TKIP. */
-	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
-		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
-			if (!test_bit(i, common->keymap) &&
-			    (test_bit(i + 32, common->keymap) ||
-			     test_bit(i + 64, common->keymap) ||
-			     test_bit(i + 64 + 32, common->keymap)))
-				return i;
-			if (!test_bit(i + 32, common->keymap) &&
-			    (test_bit(i, common->keymap) ||
-			     test_bit(i + 64, common->keymap) ||
-			     test_bit(i + 64 + 32, common->keymap)))
-				return i + 32;
-			if (!test_bit(i + 64, common->keymap) &&
-			    (test_bit(i , common->keymap) ||
-			     test_bit(i + 32, common->keymap) ||
-			     test_bit(i + 64 + 32, common->keymap)))
-				return i + 64;
-			if (!test_bit(i + 64 + 32, common->keymap) &&
-			    (test_bit(i, common->keymap) ||
-			     test_bit(i + 32, common->keymap) ||
-			     test_bit(i + 64, common->keymap)))
-				return i + 64 + 32;
-		}
-	} else {
-		for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
-			if (!test_bit(i, common->keymap) &&
-			    test_bit(i + 64, common->keymap))
-				return i;
-			if (test_bit(i, common->keymap) &&
-			    !test_bit(i + 64, common->keymap))
-				return i + 64;
-		}
-	}
-
-	/* No partially used TKIP slots, pick any available slot */
-	for (i = IEEE80211_WEP_NKID; i < common->keymax; i++) {
-		/* Do not allow slots that could be needed for TKIP group keys
-		 * to be used. This limitation could be removed if we know that
-		 * TKIP will not be used. */
-		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
-			continue;
-		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
-			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
-				continue;
-			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
-				continue;
-		}
-
-		if (!test_bit(i, common->keymap))
-			return i; /* Found a free slot for a key */
-	}
-
-	/* No free slot found */
-	return -1;
-}
-
-/*
- * Configure encryption in the HW.
- */
-int ath9k_cmn_key_config(struct ath_common *common,
-			 struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta,
-			 struct ieee80211_key_conf *key)
-{
-	struct ath_hw *ah = common->ah;
-	struct ath9k_keyval hk;
-	const u8 *mac = NULL;
-	u8 gmac[ETH_ALEN];
-	int ret = 0;
-	int idx;
-
-	memset(&hk, 0, sizeof(hk));
-
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
-		hk.kv_type = ATH9K_CIPHER_WEP;
-		break;
-	case WLAN_CIPHER_SUITE_TKIP:
-		hk.kv_type = ATH9K_CIPHER_TKIP;
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		hk.kv_type = ATH9K_CIPHER_AES_CCM;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	hk.kv_len = key->keylen;
-	memcpy(hk.kv_val, key->key, key->keylen);
-
-	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
-		switch (vif->type) {
-		case NL80211_IFTYPE_AP:
-			memcpy(gmac, vif->addr, ETH_ALEN);
-			gmac[0] |= 0x01;
-			mac = gmac;
-			idx = ath_reserve_key_cache_slot(common, key->cipher);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			if (!sta) {
-				idx = key->keyidx;
-				break;
-			}
-			memcpy(gmac, sta->addr, ETH_ALEN);
-			gmac[0] |= 0x01;
-			mac = gmac;
-			idx = ath_reserve_key_cache_slot(common, key->cipher);
-			break;
-		default:
-			idx = key->keyidx;
-			break;
-		}
-	} else if (key->keyidx) {
-		if (WARN_ON(!sta))
-			return -EOPNOTSUPP;
-		mac = sta->addr;
-
-		if (vif->type != NL80211_IFTYPE_AP) {
-			/* Only keyidx 0 should be used with unicast key, but
-			 * allow this for client mode for now. */
-			idx = key->keyidx;
-		} else
-			return -EIO;
-	} else {
-		if (WARN_ON(!sta))
-			return -EOPNOTSUPP;
-		mac = sta->addr;
-
-		idx = ath_reserve_key_cache_slot(common, key->cipher);
-	}
-
-	if (idx < 0)
-		return -ENOSPC; /* no free key cache entries */
-
-	if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
-		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
-				      vif->type == NL80211_IFTYPE_AP);
-	else
-		ret = ath9k_hw_set_keycache_entry(ah, idx, &hk, mac);
-
-	if (!ret)
-		return -EIO;
-
-	set_bit(idx, common->keymap);
-	if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
-		set_bit(idx + 64, common->keymap);
-		set_bit(idx, common->tkip_keymap);
-		set_bit(idx + 64, common->tkip_keymap);
-		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
-			set_bit(idx + 32, common->keymap);
-			set_bit(idx + 64 + 32, common->keymap);
-			set_bit(idx + 32, common->tkip_keymap);
-			set_bit(idx + 64 + 32, common->tkip_keymap);
-		}
-	}
-
-	return idx;
-}
-EXPORT_SYMBOL(ath9k_cmn_key_config);
-
-/*
- * Delete Key.
- */
-void ath9k_cmn_key_delete(struct ath_common *common,
-			  struct ieee80211_key_conf *key)
-{
-	struct ath_hw *ah = common->ah;
-
-	ath9k_hw_keyreset(ah, key->hw_key_idx);
-	if (key->hw_key_idx < IEEE80211_WEP_NKID)
-		return;
-
-	clear_bit(key->hw_key_idx, common->keymap);
-	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
-		return;
-
-	clear_bit(key->hw_key_idx + 64, common->keymap);
-
-	clear_bit(key->hw_key_idx, common->tkip_keymap);
-	clear_bit(key->hw_key_idx + 64, common->tkip_keymap);
-
-	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
-		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
-		clear_bit(key->hw_key_idx + 32, common->keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
-
-		clear_bit(key->hw_key_idx + 32, common->tkip_keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->tkip_keymap);
-	}
-}
-EXPORT_SYMBOL(ath9k_cmn_key_delete);
-
 int ath9k_cmn_count_streams(unsigned int chainmask, int max)
 {
 	int streams = 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 4aa4e7d..fea3b33 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -66,12 +66,6 @@ void ath9k_cmn_update_ichannel(struct ieee80211_hw *hw,
 			       struct ath9k_channel *ichan);
 struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 					       struct ath_hw *ah);
-int ath9k_cmn_key_config(struct ath_common *common,
-			 struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta,
-			 struct ieee80211_key_conf *key);
-void ath9k_cmn_key_delete(struct ath_common *common,
-			  struct ieee80211_key_conf *key);
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
 void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
 				  enum ath_stomp_type stomp_type);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 695e2b0..2b762be 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -566,7 +566,7 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 	 * reset the contents on initial power up.
 	 */
 	for (i = 0; i < common->keymax; i++)
-		ath9k_hw_keyreset(priv->ah, (u16) i);
+		ath_hw_keyreset(common, (u16) i);
 }
 
 static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f467207..8c353dd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1591,7 +1591,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath9k_cmn_key_config(common, vif, sta, key);
+		ret = ath_key_config(common, vif, sta, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
@@ -1605,7 +1605,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath9k_cmn_key_delete(common, key);
+		ath_key_delete(common, key);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3384ca1..14fb082 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1474,282 +1474,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 }
 EXPORT_SYMBOL(ath9k_hw_reset);
 
-/************************/
-/* Key Cache Management */
-/************************/
-
-bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
-{
-	u32 keyType;
-
-	if (entry >= ah->caps.keycache_size) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "keychache entry %u out of range\n", entry);
-		return false;
-	}
-
-	keyType = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
-
-	REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), AR_KEYTABLE_TYPE_CLR);
-	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), 0);
-
-	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
-		u16 micentry = entry + 64;
-
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
-
-	}
-
-	return true;
-}
-EXPORT_SYMBOL(ath9k_hw_keyreset);
-
-static bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
-{
-	u32 macHi, macLo;
-	u32 unicast_flag = AR_KEYTABLE_VALID;
-
-	if (entry >= ah->caps.keycache_size) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "keychache entry %u out of range\n", entry);
-		return false;
-	}
-
-	if (mac != NULL) {
-		/*
-		 * AR_KEYTABLE_VALID indicates that the address is a unicast
-		 * address, which must match the transmitter address for
-		 * decrypting frames.
-		 * Not setting this bit allows the hardware to use the key
-		 * for multicast frame decryption.
-		 */
-		if (mac[0] & 0x01)
-			unicast_flag = 0;
-
-		macHi = (mac[5] << 8) | mac[4];
-		macLo = (mac[3] << 24) |
-			(mac[2] << 16) |
-			(mac[1] << 8) |
-			mac[0];
-		macLo >>= 1;
-		macLo |= (macHi & 1) << 31;
-		macHi >>= 1;
-	} else {
-		macLo = macHi = 0;
-	}
-	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
-	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | unicast_flag);
-
-	return true;
-}
-
-bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
-				 const struct ath9k_keyval *k,
-				 const u8 *mac)
-{
-	const struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 key0, key1, key2, key3, key4;
-	u32 keyType;
-
-	if (entry >= pCap->keycache_size) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "keycache entry %u out of range\n", entry);
-		return false;
-	}
-
-	switch (k->kv_type) {
-	case ATH9K_CIPHER_AES_OCB:
-		keyType = AR_KEYTABLE_TYPE_AES;
-		break;
-	case ATH9K_CIPHER_AES_CCM:
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
-			ath_print(common, ATH_DBG_ANY,
-				  "AES-CCM not supported by mac rev 0x%x\n",
-				  ah->hw_version.macRev);
-			return false;
-		}
-		keyType = AR_KEYTABLE_TYPE_CCM;
-		break;
-	case ATH9K_CIPHER_TKIP:
-		keyType = AR_KEYTABLE_TYPE_TKIP;
-		if (ATH9K_IS_MIC_ENABLED(ah)
-		    && entry + 64 >= pCap->keycache_size) {
-			ath_print(common, ATH_DBG_ANY,
-				  "entry %u inappropriate for TKIP\n", entry);
-			return false;
-		}
-		break;
-	case ATH9K_CIPHER_WEP:
-		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
-			ath_print(common, ATH_DBG_ANY,
-				  "WEP key length %u too small\n", k->kv_len);
-			return false;
-		}
-		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
-			keyType = AR_KEYTABLE_TYPE_40;
-		else if (k->kv_len <= WLAN_KEY_LEN_WEP104)
-			keyType = AR_KEYTABLE_TYPE_104;
-		else
-			keyType = AR_KEYTABLE_TYPE_128;
-		break;
-	case ATH9K_CIPHER_CLR:
-		keyType = AR_KEYTABLE_TYPE_CLR;
-		break;
-	default:
-		ath_print(common, ATH_DBG_FATAL,
-			  "cipher %u not supported\n", k->kv_type);
-		return false;
-	}
-
-	key0 = get_unaligned_le32(k->kv_val + 0);
-	key1 = get_unaligned_le16(k->kv_val + 4);
-	key2 = get_unaligned_le32(k->kv_val + 6);
-	key3 = get_unaligned_le16(k->kv_val + 10);
-	key4 = get_unaligned_le32(k->kv_val + 12);
-	if (k->kv_len <= WLAN_KEY_LEN_WEP104)
-		key4 &= 0xff;
-
-	/*
-	 * Note: Key cache registers access special memory area that requires
-	 * two 32-bit writes to actually update the values in the internal
-	 * memory. Consequently, the exact order and pairs used here must be
-	 * maintained.
-	 */
-
-	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
-		u16 micentry = entry + 64;
-
-		/*
-		 * Write inverted key[47:0] first to avoid Michael MIC errors
-		 * on frames that could be sent or received at the same time.
-		 * The correct key will be written in the end once everything
-		 * else is ready.
-		 */
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), ~key0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), ~key1);
-
-		/* Write key[95:48] */
-		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
-		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
-
-		/* Write key[127:96] and key type */
-		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
-		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
-
-		/* Write MAC address for the entry */
-		(void) ath9k_hw_keysetmac(ah, entry, mac);
-
-		if (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) {
-			/*
-			 * TKIP uses two key cache entries:
-			 * Michael MIC TX/RX keys in the same key cache entry
-			 * (idx = main index + 64):
-			 * key0 [31:0] = RX key [31:0]
-			 * key1 [15:0] = TX key [31:16]
-			 * key1 [31:16] = reserved
-			 * key2 [31:0] = RX key [63:32]
-			 * key3 [15:0] = TX key [15:0]
-			 * key3 [31:16] = reserved
-			 * key4 [31:0] = TX key [63:32]
-			 */
-			u32 mic0, mic1, mic2, mic3, mic4;
-
-			mic0 = get_unaligned_le32(k->kv_mic + 0);
-			mic2 = get_unaligned_le32(k->kv_mic + 4);
-			mic1 = get_unaligned_le16(k->kv_txmic + 2) & 0xffff;
-			mic3 = get_unaligned_le16(k->kv_txmic + 0) & 0xffff;
-			mic4 = get_unaligned_le32(k->kv_txmic + 4);
-
-			/* Write RX[31:0] and TX[31:16] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
-			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), mic1);
-
-			/* Write RX[63:32] and TX[15:0] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
-			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), mic3);
-
-			/* Write TX[63:32] and keyType(reserved) */
-			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), mic4);
-			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
-				  AR_KEYTABLE_TYPE_CLR);
-
-		} else {
-			/*
-			 * TKIP uses four key cache entries (two for group
-			 * keys):
-			 * Michael MIC TX/RX keys are in different key cache
-			 * entries (idx = main index + 64 for TX and
-			 * main index + 32 + 96 for RX):
-			 * key0 [31:0] = TX/RX MIC key [31:0]
-			 * key1 [31:0] = reserved
-			 * key2 [31:0] = TX/RX MIC key [63:32]
-			 * key3 [31:0] = reserved
-			 * key4 [31:0] = reserved
-			 *
-			 * Upper layer code will call this function separately
-			 * for TX and RX keys when these registers offsets are
-			 * used.
-			 */
-			u32 mic0, mic2;
-
-			mic0 = get_unaligned_le32(k->kv_mic + 0);
-			mic2 = get_unaligned_le32(k->kv_mic + 4);
-
-			/* Write MIC key[31:0] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
-			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
-
-			/* Write MIC key[63:32] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
-			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
-
-			/* Write TX[63:32] and keyType(reserved) */
-			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
-			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
-				  AR_KEYTABLE_TYPE_CLR);
-		}
-
-		/* MAC address registers are reserved for the MIC entry */
-		REG_WRITE(ah, AR_KEYTABLE_MAC0(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_MAC1(micentry), 0);
-
-		/*
-		 * Write the correct (un-inverted) key[47:0] last to enable
-		 * TKIP now that all other registers are set with correct
-		 * values.
-		 */
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
-	} else {
-		/* Write key[47:0] */
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
-
-		/* Write key[95:48] */
-		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
-		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
-
-		/* Write key[127:96] and key type */
-		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
-		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
-
-		/* Write MAC address for the entry */
-		(void) ath9k_hw_keysetmac(ah, entry, mac);
-	}
-
-	return true;
-}
-EXPORT_SYMBOL(ath9k_hw_set_keycache_entry);
 
 /******************************/
 /* Power Management (Chipset) */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1601dd4..1bee964 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -874,12 +874,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 int ath9k_hw_fill_cap_info(struct ath_hw *ah);
 u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan);
 
-/* Key Cache Management */
-bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry);
-bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
-				 const struct ath9k_keyval *k,
-				 const u8 *mac);
-
 /* GPIO / RFKILL / Antennae */
 void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio);
 u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d41e41d..f235508 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -381,7 +381,7 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 	 * reset the contents on initial power up.
 	 */
 	for (i = 0; i < common->keymax; i++)
-		ath9k_hw_keyreset(sc->sc_ah, (u16) i);
+		ath_hw_keyreset(common, (u16) i);
 
 	/*
 	 * Check whether the separate key cache entries
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 2633896..7c1a34d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -660,17 +660,6 @@ struct ath9k_11n_rate_series {
 	u32 RateFlags;
 };
 
-struct ath9k_keyval {
-	u8 kv_type;
-	u8 kv_pad;
-	u16 kv_len;
-	u8 kv_val[16]; /* TK */
-	u8 kv_mic[8]; /* Michael MIC key */
-	u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
-			 * supports both MIC keys in the same key cache entry;
-			 * in that case, kv_mic is the RX key) */
-};
-
 enum ath9k_key_type {
 	ATH9K_KEY_TYPE_CLEAR,
 	ATH9K_KEY_TYPE_WEP,
@@ -678,16 +667,6 @@ enum ath9k_key_type {
 	ATH9K_KEY_TYPE_TKIP,
 };
 
-enum ath9k_cipher {
-	ATH9K_CIPHER_WEP = 0,
-	ATH9K_CIPHER_AES_OCB = 1,
-	ATH9K_CIPHER_AES_CCM = 2,
-	ATH9K_CIPHER_CKIP = 3,
-	ATH9K_CIPHER_TKIP = 4,
-	ATH9K_CIPHER_CLR = 5,
-	ATH9K_CIPHER_MIC = 127
-};
-
 struct ath_hw;
 struct ath9k_channel;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..de7c5a5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1777,7 +1777,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath9k_cmn_key_config(common, vif, sta, key);
+		ret = ath_key_config(common, vif, sta, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
@@ -1791,7 +1791,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath9k_cmn_key_delete(common, key);
+		ath_key_delete(common, key);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index e724c2c..17969af 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -45,9 +45,6 @@
 		}							\
 	} while (0)
 
-#define ATH9K_IS_MIC_ENABLED(ah)					\
-	((ah)->sta_id1_defaults & AR_STA_ID1_CRPT_MIC_ENABLE)
-
 #define ANTSWAP_AB 0x0001
 #define REDUCE_CHAIN_0 0x00000050
 #define REDUCE_CHAIN_1 0x00000051

