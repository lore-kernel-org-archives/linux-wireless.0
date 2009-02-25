Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51103 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbZBYSUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 13:20:04 -0500
Date: Wed, 25 Feb 2009 20:19:53 +0200
From: Jouni Malinen <j@w1.fi>
To: pat-lkml <pat-lkml@erley.org>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: ath9k and TKIP hw crypto in AP mode
Message-ID: <20090225181953.GA23880@jm.kir.nu> (sfid-20090225_192010_902993_DDA097EB)
References: <20090224114201.GB21933@jm.kir.nu> <49A40320.1040902@erley.org> <20090224150710.GA1419@jm.kir.nu> <49A41315.3030007@erley.org> <49A45378.50009@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49A45378.50009@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:07:20PM -0500, pat-lkml wrote:
> pass phrase.  Use nohwcrypt=1, hostapd now works perfectly with wep/wpa/wpa2, while
> with nohwcrypt=0, I get errors (that I'll need physical access to my computer to 
> debug/log) in wpa only.

Thanks, I was able to reproduce this and figure out what was happening.
It looks like I have not tested TKIP in AP mode before (I've been mainly
testing HT and that does not allow TKIP..). Anyway, the Michael MIC
TX/RX keys are set incorrectly for the group key which will trigger
Michael MIC errors on every broadcast frame.

I have more complete cleanup of the key configuration for ath9k in
progress, but as far as this particular issue is concerned, the
following change should resolve it. So far, I've only tested this with
the current hardware revision, but I will test this with older design,
too, and submit a proper patch later. Anyway, you may want to test this
as a fix for TKIP in AP mode.


--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-02-25 20:09:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-02-25 20:11:19.000000000 +0200
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
@@ -826,7 +832,8 @@ static int ath_key_config(struct ath_sof
 	}
 
 	if (key->alg == ALG_TKIP)
-		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac);
+		ret = ath_setkey_tkip(sc, idx, key->key, &hk, mac,
+				      vif->type == NL80211_IFTYPE_AP);
 	else
 		ret = ath_keyset(sc, idx, &hk, mac);
 
-- 
Jouni Malinen                                            PGP id EFC895FA
