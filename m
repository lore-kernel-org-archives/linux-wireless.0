Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39283 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbYLRMdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 07:33:05 -0500
Date: Thu, 18 Dec 2008 14:33:00 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fixed RX decryption status reporting
Message-ID: <20081218123300.GB32267@jm.kir.nu> (sfid-20081218_133309_294392_ECFF980C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RX code in ath9k uses sc_keymap to figure out whether a default
key was used. However, the default key entries in sc_keymap were
always set and as such, frames could have been claimed to be decrypted
by hardware when they were not. This can cause problems especially
with TKIP since mac80211 is validating the Michael MIC in the frame
and this will result in MIC failure and potentially TKIP
countermeasures if the frame was not decrypted correctly.

Change key cache slot allocation to mark only the keys that really
have been used in sc_keymap to avoid the issue. The key cache slot
selection routines are now internally avoiding the slots that may be
needed for TKIP group keys.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2008-12-18 13:22:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2008-12-18 13:23:05.000000000 +0200
@@ -776,6 +776,18 @@ static int ath_reserve_key_cache_slot(st
 
 	/* No partially used TKIP slots, pick any available slot */
 	for (i = IEEE80211_WEP_NKID; i < sc->sc_keymax; i++) {
+		/* Do not allow slots that could be needed for TKIP group keys
+		 * to be used. This limitation could be removed if we know that
+		 * TKIP will not be used. */
+		if (i >= 64 && i < 64 + IEEE80211_WEP_NKID)
+			continue;
+		if (sc->sc_splitmic) {
+			if (i >= 32 && i < 32 + IEEE80211_WEP_NKID)
+				continue;
+			if (i >= 64 + 32 && i < 64 + 32 + IEEE80211_WEP_NKID)
+				continue;
+		}
+
 		if (!test_bit(i, sc->sc_keymap))
 			return i; /* Found a free slot for a key */
 	}
@@ -1363,20 +1375,6 @@ static int ath_init(u16 devid, struct at
 	 */
 	for (i = 0; i < sc->sc_keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
-	/*
-	 * Mark key cache slots associated with global keys
-	 * as in use.  If we knew TKIP was not to be used we
-	 * could leave the +32, +64, and +32+64 slots free.
-	 */
-	for (i = 0; i < IEEE80211_WEP_NKID; i++) {
-		set_bit(i, sc->sc_keymap);
-		set_bit(i + 64, sc->sc_keymap);
-		if (ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
-					   0, NULL)) {
-			set_bit(i + 32, sc->sc_keymap);
-			set_bit(i + 32 + 64, sc->sc_keymap);
-		}
-	}
 
 	/* Collect the channel list using the default country code */
 

-- 
Jouni Malinen                                            PGP id EFC895FA
