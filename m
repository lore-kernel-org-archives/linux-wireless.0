Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43347 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbZCBQQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 11:16:01 -0500
Date: Mon, 2 Mar 2009 18:15:53 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath9k: Remove unused key xoring
Message-ID: <20090302161553.GA6271@jm.kir.nu> (sfid-20090302_171608_337140_441A8E19)
References: <20090302130728.GB30293@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090302130728.GB30293@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not used anywhere in ath9k and is just making the code more
confusing.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/hw.c   |   15 ++++++---------
 drivers/net/wireless/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath9k/main.c |    2 +-
 drivers/net/wireless/ath9k/phy.h  |    2 --
 4 files changed, 8 insertions(+), 13 deletions(-)

v2: Remove unneeded &0xffff from key3 = get_unaligned_le16()

--- wireless-testing.orig/drivers/net/wireless/ath9k/hw.c	2009-03-02 14:23:07.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/hw.c	2009-03-02 14:23:09.000000000 +0200
@@ -2415,14 +2415,11 @@ bool ath9k_hw_keysetmac(struct ath_hw *a
 
 bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
-				 const u8 *mac, int xorKey)
+				 const u8 *mac)
 {
 	const struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u32 key0, key1, key2, key3, key4;
 	u32 keyType;
-	u32 xorMask = xorKey ?
-		(ATH9K_KEY_XOR << 24 | ATH9K_KEY_XOR << 16 | ATH9K_KEY_XOR << 8
-		 | ATH9K_KEY_XOR) : 0;
 
 	if (entry >= pCap->keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
@@ -2474,11 +2471,11 @@ bool ath9k_hw_set_keycache_entry(struct 
 		return false;
 	}
 
-	key0 = get_unaligned_le32(k->kv_val + 0) ^ xorMask;
-	key1 = (get_unaligned_le16(k->kv_val + 4) ^ xorMask) & 0xffff;
-	key2 = get_unaligned_le32(k->kv_val + 6) ^ xorMask;
-	key3 = (get_unaligned_le16(k->kv_val + 10) ^ xorMask) & 0xffff;
-	key4 = get_unaligned_le32(k->kv_val + 12) ^ xorMask;
+	key0 = get_unaligned_le32(k->kv_val + 0);
+	key1 = get_unaligned_le16(k->kv_val + 4);
+	key2 = get_unaligned_le32(k->kv_val + 6);
+	key3 = get_unaligned_le16(k->kv_val + 10);
+	key4 = get_unaligned_le32(k->kv_val + 12);
 	if (k->kv_len <= LEN_WEP104)
 		key4 &= 0xff;
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/hw.h	2009-03-02 14:23:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/hw.h	2009-03-02 14:23:09.000000000 +0200
@@ -584,7 +584,7 @@ bool ath9k_hw_keyreset(struct ath_hw *ah
 bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac);
 bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
-				 const u8 *mac, int xorKey);
+				 const u8 *mac);
 bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry);
 
 /* GPIO / RFKILL / Antennae */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-02 14:23:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-02 14:23:09.000000000 +0200
@@ -642,7 +642,7 @@ static int ath_keyset(struct ath_softc *
 	bool status;
 
 	status = ath9k_hw_set_keycache_entry(sc->sc_ah,
-		keyix, hk, mac, false);
+		keyix, hk, mac);
 
 	return status != false;
 }
--- wireless-testing.orig/drivers/net/wireless/ath9k/phy.h	2009-03-02 14:23:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/phy.h	2009-03-02 14:23:09.000000000 +0200
@@ -559,8 +559,6 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 		}							\
 	} while (0)
 
-#define ATH9K_KEY_XOR                 0xaa
-
 #define ATH9K_IS_MIC_ENABLED(ah)					\
 	((ah)->sta_id1_defaults & AR_STA_ID1_CRPT_MIC_ENABLE)
 
-- 
Jouni Malinen                                            PGP id EFC895FA
