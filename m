Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54880 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYLQLcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:32:22 -0500
Date: Wed, 17 Dec 2008 13:32:17 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Key cache allocation for AP mode
Message-ID: <20081217113217.GB18060@jm.kir.nu> (sfid-20081217_123225_574711_95FEDA6B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enhance allocation of key cache entries to support multiple pairwise
keys to fix AP mode with more than one associated STA.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |  202 +++++++++++++++++++++++++-------------
 1 file changed, 133 insertions(+), 69 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2008-12-17 13:00:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2008-12-17 13:05:54.000000000 +0200
@@ -664,13 +664,6 @@ static u32 ath_get_extchanmode(struct at
 	return chanmode;
 }
 
-static void ath_key_reset(struct ath_softc *sc, u16 keyix, int freeslot)
-{
-	ath9k_hw_keyreset(sc->sc_ah, keyix);
-	if (freeslot)
-		clear_bit(keyix, sc->sc_keymap);
-}
-
 static int ath_keyset(struct ath_softc *sc, u16 keyix,
 	       struct ath9k_keyval *hk, const u8 mac[ETH_ALEN])
 {
@@ -682,21 +675,20 @@ static int ath_keyset(struct ath_softc *
 	return status != false;
 }
 
-static int ath_setkey_tkip(struct ath_softc *sc,
-			   struct ieee80211_key_conf *key,
+static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 			   struct ath9k_keyval *hk,
 			   const u8 *addr)
 {
-	u8 *key_rxmic = NULL;
-	u8 *key_txmic = NULL;
+	const u8 *key_rxmic;
+	const u8 *key_txmic;
 
-	key_txmic = key->key + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
-	key_rxmic = key->key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
+	key_txmic = key + NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
+	key_rxmic = key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
 
 	if (addr == NULL) {
 		/* Group key installation */
-		memcpy(hk->kv_mic,  key_rxmic, sizeof(hk->kv_mic));
-		return ath_keyset(sc, key->keyidx, hk, addr);
+		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+		return ath_keyset(sc, keyix, hk, addr);
 	}
 	if (!sc->sc_splitmic) {
 		/*
@@ -705,14 +697,14 @@ static int ath_setkey_tkip(struct ath_so
 		 */
 		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
-		return ath_keyset(sc, key->keyidx, hk, addr);
+		return ath_keyset(sc, keyix, hk, addr);
 	}
 	/*
 	 * TX key goes at first index, RX key at +32.
 	 * The hal handles the MIC keys at index+64.
 	 */
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-	if (!ath_keyset(sc, key->keyidx, hk, NULL)) {
+	if (!ath_keyset(sc, keyix, hk, NULL)) {
 		/* Txmic entry failed. No need to proceed further */
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"Setting TX MIC Key Failed\n");
@@ -721,18 +713,85 @@ static int ath_setkey_tkip(struct ath_so
 
 	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 	/* XXX delete tx key on failure? */
-	return ath_keyset(sc, key->keyidx+32, hk, addr);
+	return ath_keyset(sc, keyix + 32, hk, addr);
+}
+
+static int ath_reserve_key_cache_slot_tkip(struct ath_softc *sc)
+{
+	int i;
+
+	for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 2; i++) {
+		if (test_bit(i, sc->sc_keymap) ||
+		    test_bit(i + 64, sc->sc_keymap))
+			continue; /* At least one part of TKIP key allocated */
+		if (sc->sc_splitmic &&
+		    (test_bit(i + 32, sc->sc_keymap) ||
+		     test_bit(i + 64 + 32, sc->sc_keymap)))
+			continue; /* At least one part of TKIP key allocated */
+
+		/* Found a free slot for a TKIP key */
+		return i;
+	}
+	return -1;
+}
+
+static int ath_reserve_key_cache_slot(struct ath_softc *sc)
+{
+	int i;
+
+	/* First, try to find slots that would not be available for TKIP. */
+	if (sc->sc_splitmic) {
+		for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 4; i++) {
+			if (!test_bit(i, sc->sc_keymap) &&
+			    (test_bit(i + 32, sc->sc_keymap) ||
+			     test_bit(i + 64, sc->sc_keymap) ||
+			     test_bit(i + 64 + 32, sc->sc_keymap)))
+				return i;
+			if (!test_bit(i + 32, sc->sc_keymap) &&
+			    (test_bit(i, sc->sc_keymap) ||
+			     test_bit(i + 64, sc->sc_keymap) ||
+			     test_bit(i + 64 + 32, sc->sc_keymap)))
+				return i + 32;
+			if (!test_bit(i + 64, sc->sc_keymap) &&
+			    (test_bit(i , sc->sc_keymap) ||
+			     test_bit(i + 32, sc->sc_keymap) ||
+			     test_bit(i + 64 + 32, sc->sc_keymap)))
+				return i;
+			if (!test_bit(i + 64 + 32, sc->sc_keymap) &&
+			    (test_bit(i, sc->sc_keymap) ||
+			     test_bit(i + 32, sc->sc_keymap) ||
+			     test_bit(i + 64, sc->sc_keymap)))
+				return i;
+		}
+	} else {
+		for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax / 2; i++) {
+			if (!test_bit(i, sc->sc_keymap) &&
+			    test_bit(i + 64, sc->sc_keymap))
+				return i;
+			if (test_bit(i, sc->sc_keymap) &&
+			    !test_bit(i + 64, sc->sc_keymap))
+				return i + 64;
+		}
+	}
+
+	/* No partially used TKIP slots, pick any available slot */
+	for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax; i++) {
+		if (!test_bit(i, sc->sc_keymap))
+			return i; /* Found a free slot for a key */
+	}
+
+	/* No free slot found */
+	return -1;
 }
 
 static int ath_key_config(struct ath_softc *sc,
 			  const u8 *addr,
 			  struct ieee80211_key_conf *key)
 {
-	struct ieee80211_vif *vif;
 	struct ath9k_keyval hk;
 	const u8 *mac = NULL;
 	int ret = 0;
-	enum nl80211_iftype opmode;
+	int idx;
 
 	memset(&hk, 0, sizeof(hk));
 
@@ -750,65 +809,69 @@ static int ath_key_config(struct ath_sof
 		return -EINVAL;
 	}
 
-	hk.kv_len  = key->keylen;
+	hk.kv_len = key->keylen;
 	memcpy(hk.kv_val, key->key, key->keylen);
 
-	if (!sc->sc_vaps[0])
-		return -EIO;
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/* For now, use the default keys for broadcast keys. This may
+		 * need to change with virtual interfaces. */
+		idx = key->keyidx;
+	} else if (key->keyidx) {
+		struct ieee80211_vif *vif;
 
-	vif = sc->sc_vaps[0];
-	opmode = vif->type;
-
-	/*
-	 *  Strategy:
-	 *   For STA mc tx, we will not setup a key at
-	 *   all since we never tx mc.
-	 *
-	 *   For STA mc rx, we will use the keyID.
-	 *
-	 *   For ADHOC mc tx, we will use the keyID, and no macaddr.
-	 *
-	 *   For ADHOC mc rx, we will alloc a slot and plumb the mac of
-	 *   the peer node.
-	 *   BUT we will plumb a cleartext key so that we can do
-	 *   per-Sta default key table lookup in software.
-	 */
-	if (is_broadcast_ether_addr(addr)) {
-		switch (opmode) {
-		case NL80211_IFTYPE_STATION:
-			/* default key:  could be group WPA key
-			 * or could be static WEP key */
-			mac = NULL;
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			break;
-		case NL80211_IFTYPE_AP:
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
+		mac = addr;
+		vif = sc->sc_vaps[0];
+		if (vif->type != NL80211_IFTYPE_AP) {
+			/* Only keyidx 0 should be used with unicast key, but
+			 * allow this for client mode for now. */
+			idx = key->keyidx;
+		} else
+			return -EIO;
 	} else {
 		mac = addr;
+		if (key->alg == ALG_TKIP)
+			idx = ath_reserve_key_cache_slot_tkip(sc);
+		else
+			idx = ath_reserve_key_cache_slot(sc);
+		if (idx < 0)
+			return -EIO; /* no free key cache entries */
 	}
 
 	if (key->alg == ALG_TKIP)
-		ret = ath_setkey_tkip(sc, key, &hk, mac);
+		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac);
 	else
-		ret = ath_keyset(sc, key->keyidx, &hk, mac);
+		ret = ath_keyset(sc, idx, &hk, mac);
 
 	if (!ret)
 		return -EIO;
 
-	return 0;
+	set_bit(idx, sc->sc_keymap);
+	if (key->alg == ALG_TKIP) {
+		set_bit(idx + 64, sc->sc_keymap);
+		if (sc->sc_splitmic) {
+			set_bit(idx + 32, sc->sc_keymap);
+			set_bit(idx + 64 + 32, sc->sc_keymap);
+		}
+	}
+
+	return idx;
 }
 
 static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 {
-	int freeslot;
+	ath9k_hw_keyreset(sc->sc_ah, key->hw_key_idx);
+	if (key->hw_key_idx < IEEE80211_WEP_NKID)
+		return;
+
+	clear_bit(key->hw_key_idx, sc->sc_keymap);
+	if (key->alg != ALG_TKIP)
+		return;
 
-	freeslot = (key->keyidx >= 4) ? 1 : 0;
-	ath_key_reset(sc, key->keyidx, freeslot);
+	clear_bit(key->hw_key_idx + 64, sc->sc_keymap);
+	if (sc->sc_splitmic) {
+		clear_bit(key->hw_key_idx + 32, sc->sc_keymap);
+		clear_bit(key->hw_key_idx + 64 + 32, sc->sc_keymap);
+	}
 }
 
 static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
@@ -1306,13 +1369,15 @@ static int ath_init(u16 devid, struct at
 	 * Mark key cache slots associated with global keys
 	 * as in use.  If we knew TKIP was not to be used we
 	 * could leave the +32, +64, and +32+64 slots free.
-	 * XXX only for splitmic.
 	 */
-	for (i = 0; i < IEEE80211_WEP_NKID; i++) {
+ 	for (i = 0; i < IEEE80211_WEP_NKID; i++) {
 		set_bit(i, sc->sc_keymap);
-		set_bit(i + 32, sc->sc_keymap);
 		set_bit(i + 64, sc->sc_keymap);
-		set_bit(i + 32 + 64, sc->sc_keymap);
+		if (ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
+					   0, NULL)) {
+			set_bit(i + 32, sc->sc_keymap);
+			set_bit(i + 32 + 64, sc->sc_keymap);
+		}
 	}
 
 	/* Collect the channel list using the default country code */
@@ -2312,18 +2377,17 @@ static int ath9k_set_key(struct ieee8021
 	switch (cmd) {
 	case SET_KEY:
 		ret = ath_key_config(sc, addr, key);
-		if (!ret) {
-			set_bit(key->keyidx, sc->sc_keymap);
-			key->hw_key_idx = key->keyidx;
+		if (ret >= 0) {
+			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			if (key->alg == ALG_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+			ret = 0;
 		}
 		break;
 	case DISABLE_KEY:
 		ath_key_delete(sc, key);
-		clear_bit(key->keyidx, sc->sc_keymap);
 		break;
 	default:
 		ret = -EINVAL;

-- 
Jouni Malinen                                            PGP id EFC895FA
