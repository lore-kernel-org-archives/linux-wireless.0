Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZKGUTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:08 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 24/29] ath9k: move driver keymap, keymax and splitmic to common
Date: Sat,  7 Nov 2009 15:19:01 -0500
Message-Id: <1257625146-17971-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make sharing code easier between ath9k and ath9k_htc.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h         |   14 +++
 drivers/net/wireless/ath/ath9k/ath9k.h |   13 ---
 drivers/net/wireless/ath/ath9k/main.c  |  136 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 4 files changed, 85 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 4af1362..9e05648 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -21,6 +21,16 @@
 #include <linux/if_ether.h>
 #include <net/mac80211.h>
 
+/*
+ * The key cache is used for h/w cipher state and also for
+ * tracking station state such as the current tx antenna.
+ * We also setup a mapping table between key cache slot indices
+ * and station state to short-circuit node lookups on rx.
+ * Different parts have different size key caches.  We handle
+ * up to ATH_KEYMAX entries (could dynamically allocate state).
+ */
+#define	ATH_KEYMAX	        128     /* max key cache size we handle */
+
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 struct ath_ani {
@@ -89,6 +99,10 @@ struct ath_common {
 
 	u32 rx_bufsize;
 
+	u32 keymax;
+	DECLARE_BITMAP(keymap, ATH_KEYMAX);
+	u8 splitmic;
+
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
 	const struct ath_bus_ops *bus_ops;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 377b0ea..88969cb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -492,16 +492,6 @@ struct ath_led {
 #define ATH_CHAN_MAX            255
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
 
-/*
- * The key cache is used for h/w cipher state and also for
- * tracking station state such as the current tx antenna.
- * We also setup a mapping table between key cache slot indices
- * and station state to short-circuit node lookups on rx.
- * Different parts have different size key caches.  We handle
- * up to ATH_KEYMAX entries (could dynamically allocate state).
- */
-#define	ATH_KEYMAX	        128     /* max key cache size we handle */
-
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 #define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RATE_DUMMY_MARKER   0
@@ -562,9 +552,6 @@ struct ath_softc {
 	u16 curtxpow;
 	u8 nbcnvifs;
 	u16 nvifs;
-	u32 keymax;
-	DECLARE_BITMAP(keymap, ATH_KEYMAX);
-	u8 splitmic;
 	bool ps_enabled;
 	unsigned long ps_usecount;
 	enum ath9k_int imask;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 01ac897..3c02b97 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -733,10 +733,11 @@ static u32 ath_get_extchanmode(struct ath_softc *sc,
 	return chanmode;
 }
 
-static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
+static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
 			   struct ath9k_keyval *hk, const u8 *addr,
 			   bool authenticator)
 {
+	struct ath_hw *ah = common->ah;
 	const u8 *key_rxmic;
 	const u8 *key_txmic;
 
@@ -756,42 +757,42 @@ static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
 			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
 		}
-		return ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, addr);
+		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
 	}
-	if (!sc->splitmic) {
+	if (!common->splitmic) {
 		/* TX and RX keys share the same key cache entry. */
 		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
-		return ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, addr);
+		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
 	}
 
 	/* Separate key cache entries for TX and RX */
 
 	/* TX key goes at first index, RX key at +32. */
 	memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
-	if (!ath9k_hw_set_keycache_entry(sc->sc_ah, keyix, hk, NULL)) {
+	if (!ath9k_hw_set_keycache_entry(ah, keyix, hk, NULL)) {
 		/* TX MIC entry failed. No need to proceed further */
-		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
+		ath_print(common, ATH_DBG_FATAL,
 			  "Setting TX MIC Key Failed\n");
 		return 0;
 	}
 
 	memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 	/* XXX delete tx key on failure? */
-	return ath9k_hw_set_keycache_entry(sc->sc_ah, keyix + 32, hk, addr);
+	return ath9k_hw_set_keycache_entry(ah, keyix + 32, hk, addr);
 }
 
-static int ath_reserve_key_cache_slot_tkip(struct ath_softc *sc)
+static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
 {
 	int i;
 
-	for (i = IEEE80211_WEP_NKID; i < sc->keymax / 2; i++) {
-		if (test_bit(i, sc->keymap) ||
-		    test_bit(i + 64, sc->keymap))
+	for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
+		if (test_bit(i, common->keymap) ||
+		    test_bit(i + 64, common->keymap))
 			continue; /* At least one part of TKIP key allocated */
-		if (sc->splitmic &&
-		    (test_bit(i + 32, sc->keymap) ||
-		     test_bit(i + 64 + 32, sc->keymap)))
+		if (common->splitmic &&
+		    (test_bit(i + 32, common->keymap) ||
+		     test_bit(i + 64 + 32, common->keymap)))
 			continue; /* At least one part of TKIP key allocated */
 
 		/* Found a free slot for a TKIP key */
@@ -800,60 +801,60 @@ static int ath_reserve_key_cache_slot_tkip(struct ath_softc *sc)
 	return -1;
 }
 
-static int ath_reserve_key_cache_slot(struct ath_softc *sc)
+static int ath_reserve_key_cache_slot(struct ath_common *common)
 {
 	int i;
 
 	/* First, try to find slots that would not be available for TKIP. */
-	if (sc->splitmic) {
-		for (i = IEEE80211_WEP_NKID; i < sc->keymax / 4; i++) {
-			if (!test_bit(i, sc->keymap) &&
-			    (test_bit(i + 32, sc->keymap) ||
-			     test_bit(i + 64, sc->keymap) ||
-			     test_bit(i + 64 + 32, sc->keymap)))
+	if (common->splitmic) {
+		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
+			if (!test_bit(i, common->keymap) &&
+			    (test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
 				return i;
-			if (!test_bit(i + 32, sc->keymap) &&
-			    (test_bit(i, sc->keymap) ||
-			     test_bit(i + 64, sc->keymap) ||
-			     test_bit(i + 64 + 32, sc->keymap)))
+			if (!test_bit(i + 32, common->keymap) &&
+			    (test_bit(i, common->keymap) ||
+			     test_bit(i + 64, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
 				return i + 32;
-			if (!test_bit(i + 64, sc->keymap) &&
-			    (test_bit(i , sc->keymap) ||
-			     test_bit(i + 32, sc->keymap) ||
-			     test_bit(i + 64 + 32, sc->keymap)))
+			if (!test_bit(i + 64, common->keymap) &&
+			    (test_bit(i , common->keymap) ||
+			     test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64 + 32, common->keymap)))
 				return i + 64;
-			if (!test_bit(i + 64 + 32, sc->keymap) &&
-			    (test_bit(i, sc->keymap) ||
-			     test_bit(i + 32, sc->keymap) ||
-			     test_bit(i + 64, sc->keymap)))
+			if (!test_bit(i + 64 + 32, common->keymap) &&
+			    (test_bit(i, common->keymap) ||
+			     test_bit(i + 32, common->keymap) ||
+			     test_bit(i + 64, common->keymap)))
 				return i + 64 + 32;
 		}
 	} else {
-		for (i = IEEE80211_WEP_NKID; i < sc->keymax / 2; i++) {
-			if (!test_bit(i, sc->keymap) &&
-			    test_bit(i + 64, sc->keymap))
+		for (i = IEEE80211_WEP_NKID; i < common->keymax / 2; i++) {
+			if (!test_bit(i, common->keymap) &&
+			    test_bit(i + 64, common->keymap))
 				return i;
-			if (test_bit(i, sc->keymap) &&
-			    !test_bit(i + 64, sc->keymap))
+			if (test_bit(i, common->keymap) &&
+			    !test_bit(i + 64, common->keymap))
 				return i + 64;
 		}
 	}
 
 	/* No partially used TKIP slots, pick any available slot */
-	for (i = IEEE80211_WEP_NKID; i < sc->keymax; i++) {
+	for (i = IEEE80211_WEP_NKID; i < common->keymax; i++) {
 		/* Do not allow slots that could be needed for TKIP group keys
 		 * to be used. This limitation could be removed if we know that
 		 * TKIP will not be used. */
 		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
 			continue;
-		if (sc->splitmic) {
+		if (common->splitmic) {
 			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
 				continue;
 			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
 				continue;
 		}
 
-		if (!test_bit(i, sc->keymap))
+		if (!test_bit(i, common->keymap))
 			return i; /* Found a free slot for a key */
 	}
 
@@ -861,11 +862,12 @@ static int ath_reserve_key_cache_slot(struct ath_softc *sc)
 	return -1;
 }
 
-static int ath_key_config(struct ath_softc *sc,
+static int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key)
 {
+	struct ath_hw *ah = common->ah;
 	struct ath9k_keyval hk;
 	const u8 *mac = NULL;
 	int ret = 0;
@@ -911,48 +913,50 @@ static int ath_key_config(struct ath_softc *sc,
 		mac = sta->addr;
 
 		if (key->alg == ALG_TKIP)
-			idx = ath_reserve_key_cache_slot_tkip(sc);
+			idx = ath_reserve_key_cache_slot_tkip(common);
 		else
-			idx = ath_reserve_key_cache_slot(sc);
+			idx = ath_reserve_key_cache_slot(common);
 		if (idx < 0)
 			return -ENOSPC; /* no free key cache entries */
 	}
 
 	if (key->alg == ALG_TKIP)
-		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac,
+		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
 				      vif->type == NL80211_IFTYPE_AP);
 	else
-		ret = ath9k_hw_set_keycache_entry(sc->sc_ah, idx, &hk, mac);
+		ret = ath9k_hw_set_keycache_entry(ah, idx, &hk, mac);
 
 	if (!ret)
 		return -EIO;
 
-	set_bit(idx, sc->keymap);
+	set_bit(idx, common->keymap);
 	if (key->alg == ALG_TKIP) {
-		set_bit(idx + 64, sc->keymap);
-		if (sc->splitmic) {
-			set_bit(idx + 32, sc->keymap);
-			set_bit(idx + 64 + 32, sc->keymap);
+		set_bit(idx + 64, common->keymap);
+		if (common->splitmic) {
+			set_bit(idx + 32, common->keymap);
+			set_bit(idx + 64 + 32, common->keymap);
 		}
 	}
 
 	return idx;
 }
 
-static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
+static void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 {
-	ath9k_hw_keyreset(sc->sc_ah, key->hw_key_idx);
+	struct ath_hw *ah = common->ah;
+
+	ath9k_hw_keyreset(ah, key->hw_key_idx);
 	if (key->hw_key_idx < IEEE80211_WEP_NKID)
 		return;
 
-	clear_bit(key->hw_key_idx, sc->keymap);
+	clear_bit(key->hw_key_idx, common->keymap);
 	if (key->alg != ALG_TKIP)
 		return;
 
-	clear_bit(key->hw_key_idx + 64, sc->keymap);
-	if (sc->splitmic) {
-		clear_bit(key->hw_key_idx + 32, sc->keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, sc->keymap);
+	clear_bit(key->hw_key_idx + 64, common->keymap);
+	if (common->splitmic) {
+		clear_bit(key->hw_key_idx + 32, common->keymap);
+		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
 	}
 }
 
@@ -1679,19 +1683,19 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	}
 
 	/* Get the hardware key cache size. */
-	sc->keymax = ah->caps.keycache_size;
-	if (sc->keymax > ATH_KEYMAX) {
+	common->keymax = ah->caps.keycache_size;
+	if (common->keymax > ATH_KEYMAX) {
 		ath_print(common, ATH_DBG_ANY,
 			  "Warning, using only %u entries in %u key cache\n",
-			  ATH_KEYMAX, sc->keymax);
-		sc->keymax = ATH_KEYMAX;
+			  ATH_KEYMAX, common->keymax);
+		common->keymax = ATH_KEYMAX;
 	}
 
 	/*
 	 * Reset the key cache since some parts do not
 	 * reset the contents on initial power up.
 	 */
-	for (i = 0; i < sc->keymax; i++)
+	for (i = 0; i < common->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
 	/* default to MONITOR mode */
@@ -1788,7 +1792,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 				      ATH9K_CIPHER_MIC, NULL)
 	    && ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
 				      0, NULL))
-		sc->splitmic = 1;
+		common->splitmic = 1;
 
 	/* turn on mcast key search if possible */
 	if (!ath9k_hw_getcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
@@ -2917,7 +2921,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath_key_config(sc, vif, sta, key);
+		ret = ath_key_config(common, vif, sta, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
@@ -2930,7 +2934,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(sc, key);
+		ath_key_delete(common, key);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c4a8663..3abefb5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -856,7 +856,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			   && !decrypt_error && skb->len >= hdrlen + 4) {
 			keyix = skb->data[hdrlen + 3] >> 6;
 
-			if (test_bit(keyix, sc->keymap))
+			if (test_bit(keyix, common->keymap))
 				rxs->flag |= RX_FLAG_DECRYPTED;
 		}
 		if (ah->sw_mgmt_crypto &&
-- 
1.6.5.2.143.g8cc62

