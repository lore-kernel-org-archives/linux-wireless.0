Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34726 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbZCCLMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 06:12:06 -0500
Date: Tue, 3 Mar 2009 13:11:53 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Clean up setkey operations
Message-ID: <20090303111153.GA17684@jm.kir.nu> (sfid-20090303_121212_070199_70408C71)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to use ath_keyset() wrapper for
ath9k_hw_set_keycache_entry() calls. In addition, improve the comments
describing the key setting operations.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/main.c |   42 ++++++++++++++------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 13:08:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 13:08:18.000000000 +0200
@@ -636,17 +636,6 @@ static u32 ath_get_extchanmode(struct at
 	return chanmode;
 }
 
-static int ath_keyset(struct ath_softc *sc, u16 keyix,
-	       struct ath9k_keyval *hk, const u8 mac[ETH_ALEN])
-{
-	bool status;
-
-	status = ath9k_hw_set_keycache_entry(sc->sc_ah,
-		keyix, hk, mac);
-
-	return status != false;
-}
-
 static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 			   struct ath9k_keyval *hk, const u8 *addr,
 			   bool authenticator)
@@ -658,7 +647,11 @@ static int ath_setkey_tkip(struct ath_so
 	key_rxmic = key + NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
 
 	if (addr == NULL) {
-		/* Group key installation */
+		/*
+		 * Group key installation - only two key cache entries are used
+		 * regardless of splitmic capability since group key is only
+		 * used either for TX or RX.
+		 */
 		if (authenticator) {
 			memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
 			memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_mic));
@@ -666,24 +659,21 @@ static int ath_setkey_tkip(struct ath_so
 			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
 		}
-		return ath_keyset(sc, keyix, hk, addr);
+		return ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, addr);
 	}
 	if (!sc->splitmic) {
-		/*
-		 * data key goes at first index,
-		 * the hal handles the MIC keys at index+64.
-		 */
+		/* TX and RX keys share the same key cache entry. */
 		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
-		return ath_keyset(sc, keyix, hk, addr);
+		return ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, addr);
 	}
-	/*
-	 * TX key goes at first index, RX key at +32.
-	 * The hal handles the MIC keys at index+64.
-	 */
+
+	/* Separate key cache entries for TX and RX */
+
+	/* TX key goes at first index, RX key at +32. */
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-	if (!ath_keyset(sc, keyix, hk, NULL)) {
-		/* Txmic entry failed. No need to proceed further */
+	if (!ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, NULL)) {
+		/* TX MIC entry failed. No need to proceed further */
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"Setting TX MIC Key Failed\n");
 		return 0;
@@ -691,7 +681,7 @@ static int ath_setkey_tkip(struct ath_so
 
 	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 	/* XXX delete tx key on failure? */
-	return ath_keyset(sc, keyix + 32, hk, addr);
+	return ath9k_hw_set_keycache_entry(sc->sc_ah, keyix + 32, hk, addr);
 }
 
 static int ath_reserve_key_cache_slot_tkip(struct ath_softc *sc)
@@ -838,7 +828,7 @@ static int ath_key_config(struct ath_sof
 		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac,
 				      vif->type == NL80211_IFTYPE_AP);
 	else
-		ret = ath_keyset(sc, idx, &hk, mac);
+		ret = ath9k_hw_set_keycache_entry(sc->sc_ah, idx, &hk, mac);
 
 	if (!ret)
 		return -EIO;

-- 
Jouni Malinen                                            PGP id EFC895FA
