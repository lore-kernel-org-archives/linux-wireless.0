Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:30303 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757871Ab0IHHF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 03:05:26 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-028689524
	for <linux-wireless@vger.kernel.org>; Wed,  8 Sep 2010 16:05:24 +0900 (JST)
Subject: [PATCH 5/8] ath/ath9k: Replace common->splitmic with a flag
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Wed, 08 Sep 2010 16:04:54 +0900
Message-ID: <20100908070454.11255.14931.stgit@tt-desk>
In-Reply-To: <20100908070427.11255.17659.stgit@tt-desk>
References: <20100908070427.11255.17659.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace common->splitmic with ATH_CRYPT_CAP_MIC_COMBINED flag.

splitmic has to be used when the ATH_CRYPT_CAP_MIC_COMBINED capability flag is
not set.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath.h          |    2 +-
 drivers/net/wireless/ath/ath9k/common.c |   12 ++++++------
 drivers/net/wireless/ath/ath9k/init.c   |    4 ++--
 drivers/net/wireless/ath/key.c          |   14 +++++++-------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index fb24f66..c558407 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -78,6 +78,7 @@ enum ath_crypt_caps {
 	ATH_CRYPT_CAP_CIPHER_AESCCM		= BIT(3),
 	ATH_CRYPT_CAP_CIPHER_CKIP		= BIT(4),
 	ATH_CRYPT_CAP_CIPHER_TKIP		= BIT(5),
+	ATH_CRYPT_CAP_MIC_COMBINED		= BIT(6),
 };
 
 struct ath_keyval {
@@ -150,7 +151,6 @@ struct ath_common {
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
-	u8 splitmic;
 	enum ath_crypt_caps crypt_caps;
 
 	struct ath_regulatory regulatory;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 2dab64b..2db24eb 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -174,7 +174,7 @@ static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
 		}
 		return ath9k_hw_set_keycache_entry(ah, keyix, hk, addr);
 	}
-	if (!common->splitmic) {
+	if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) {
 		/* TX and RX keys share the same key cache entry. */
 		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
@@ -205,7 +205,7 @@ static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
 		if (test_bit(i, common->keymap) ||
 		    test_bit(i + 64, common->keymap))
 			continue; /* At least one part of TKIP key allocated */
-		if (common->splitmic &&
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) &&
 		    (test_bit(i + 32, common->keymap) ||
 		     test_bit(i + 64 + 32, common->keymap)))
 			continue; /* At least one part of TKIP key allocated */
@@ -225,7 +225,7 @@ static int ath_reserve_key_cache_slot(struct ath_common *common,
 		return ath_reserve_key_cache_slot_tkip(common);
 
 	/* First, try to find slots that would not be available for TKIP. */
-	if (common->splitmic) {
+	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
 			if (!test_bit(i, common->keymap) &&
 			    (test_bit(i + 32, common->keymap) ||
@@ -266,7 +266,7 @@ static int ath_reserve_key_cache_slot(struct ath_common *common,
 		 * TKIP will not be used. */
 		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
 			continue;
-		if (common->splitmic) {
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
 				continue;
 			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
@@ -374,7 +374,7 @@ int ath9k_cmn_key_config(struct ath_common *common,
 		set_bit(idx + 64, common->keymap);
 		set_bit(idx, common->tkip_keymap);
 		set_bit(idx + 64, common->tkip_keymap);
-		if (common->splitmic) {
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 			set_bit(idx + 32, common->keymap);
 			set_bit(idx + 64 + 32, common->keymap);
 			set_bit(idx + 32, common->tkip_keymap);
@@ -407,7 +407,7 @@ void ath9k_cmn_key_delete(struct ath_common *common,
 	clear_bit(key->hw_key_idx, common->tkip_keymap);
 	clear_bit(key->hw_key_idx + 64, common->tkip_keymap);
 
-	if (common->splitmic) {
+	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 		ath9k_hw_keyreset(ah, key->hw_key_idx + 32);
 		clear_bit(key->hw_key_idx + 32, common->keymap);
 		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3dbff8d..d41e41d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -389,8 +389,8 @@ static void ath9k_init_crypto(struct ath_softc *sc)
 	 * With split mic keys the number of stations is limited
 	 * to 27 otherwise 59.
 	 */
-	if (!(sc->sc_ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA))
-		common->splitmic = 1;
+	if (sc->sc_ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA)
+		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
 }
 
 static int ath9k_init_btcoex(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index e45b854..bd21a4d 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -201,7 +201,7 @@ bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 		/* Write MAC address for the entry */
 		(void) ath_hw_keysetmac(common, entry, mac);
 
-		if (common->splitmic == 0) {
+		if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) {
 			/*
 			 * TKIP uses two key cache entries:
 			 * Michael MIC TX/RX keys in the same key cache entry
@@ -327,7 +327,7 @@ static int ath_setkey_tkip(struct ath_common *common, u16 keyix, const u8 *key,
 		}
 		return ath_hw_set_keycache_entry(common, keyix, hk, addr);
 	}
-	if (!common->splitmic) {
+	if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) {
 		/* TX and RX keys share the same key cache entry. */
 		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
 		memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_txmic));
@@ -358,7 +358,7 @@ static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
 		if (test_bit(i, common->keymap) ||
 		    test_bit(i + 64, common->keymap))
 			continue; /* At least one part of TKIP key allocated */
-		if (common->splitmic &&
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED) &&
 		    (test_bit(i + 32, common->keymap) ||
 		     test_bit(i + 64 + 32, common->keymap)))
 			continue; /* At least one part of TKIP key allocated */
@@ -378,7 +378,7 @@ static int ath_reserve_key_cache_slot(struct ath_common *common,
 		return ath_reserve_key_cache_slot_tkip(common);
 
 	/* First, try to find slots that would not be available for TKIP. */
-	if (common->splitmic) {
+	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
 			if (!test_bit(i, common->keymap) &&
 			    (test_bit(i + 32, common->keymap) ||
@@ -419,7 +419,7 @@ static int ath_reserve_key_cache_slot(struct ath_common *common,
 		 * TKIP will not be used. */
 		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
 			continue;
-		if (common->splitmic) {
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
 				continue;
 			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
@@ -526,7 +526,7 @@ int ath_key_config(struct ath_common *common,
 		set_bit(idx + 64, common->keymap);
 		set_bit(idx, common->tkip_keymap);
 		set_bit(idx + 64, common->tkip_keymap);
-		if (common->splitmic) {
+		if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 			set_bit(idx + 32, common->keymap);
 			set_bit(idx + 64 + 32, common->keymap);
 			set_bit(idx + 32, common->tkip_keymap);
@@ -556,7 +556,7 @@ void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 	clear_bit(key->hw_key_idx, common->tkip_keymap);
 	clear_bit(key->hw_key_idx + 64, common->tkip_keymap);
 
-	if (common->splitmic) {
+	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
 		ath_hw_keyreset(common, key->hw_key_idx + 32);
 		clear_bit(key->hw_key_idx + 32, common->keymap);
 		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);

