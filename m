Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43780 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbZBZJSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 04:18:53 -0500
Date: Thu, 26 Feb 2009 11:18:46 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix hw crypto configuration for TKIP in AP mode
Message-ID: <20090226091846.GA11508@jm.kir.nu> (sfid-20090226_101910_450564_3D329E70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect Michael MIC key (RX, should have been TX) was set for the
group key in AP mode. This resulted in all broadcast frames triggering
Michael MIC errors and eventual TKIP countermeasures. The change here
sets the correct Michael MIC key based on whether the local end is the
authenticator (well, AP for now).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Tested-by: Pat Erley <pat-lkml@erley.org>

---
 drivers/net/wireless/ath9k/main.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-02-26 10:49:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-02-26 10:51:41.000000000 +0200
@@ -648,8 +648,8 @@ static int ath_keyset(struct ath_softc *
 }
 
 static int ath_setkey_tkip(struct ath_softc *sc, u16 keyix, const u8 *key,
-			   struct ath9k_keyval *hk,
-			   const u8 *addr)
+			   struct ath9k_keyval *hk, const u8 *addr,
+			   bool authenticator)
 {
 	const u8 *key_rxmic;
 	const u8 *key_txmic;
@@ -659,7 +659,13 @@ static int ath_setkey_tkip(struct ath_so
 
 	if (addr == NULL) {
 		/* Group key installation */
-		memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+		if (authenticator) {
+			memcpy(hk->kv_mic, key_txmic, sizeof(hk->kv_mic));
+			memcpy(hk->kv_txmic, key_txmic, sizeof(hk->kv_mic));
+		} else {
+			memcpy(hk->kv_mic, key_rxmic, sizeof(hk->kv_mic));
+			memcpy(hk->kv_txmic, key_rxmic, sizeof(hk->kv_mic));
+		}
 		return ath_keyset(sc, keyix, hk, addr);
 	}
 	if (!sc->splitmic) {
@@ -769,6 +775,7 @@ static int ath_reserve_key_cache_slot(st
 }
 
 static int ath_key_config(struct ath_softc *sc,
+			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key)
 {
@@ -828,7 +835,8 @@ static int ath_key_config(struct ath_sof
 	}
 
 	if (key->alg == ALG_TKIP)
-		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac);
+		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac,
+				      vif->type == NL80211_IFTYPE_AP);
 	else
 		ret = ath_keyset(sc, idx, &hk, mac);
 
@@ -2481,7 +2489,7 @@ static int ath9k_set_key(struct ieee8021
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = ath_key_config(sc, sta, key);
+		ret = ath_key_config(sc, vif, sta, key);
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */

-- 
Jouni Malinen                                            PGP id EFC895FA
