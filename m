Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33674 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZCBNGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 08:06:43 -0500
Date: Mon, 2 Mar 2009 15:06:31 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Document keycache operations
Message-ID: <20090302130631.GA30293@jm.kir.nu> (sfid-20090302_140648_258669_33F02529)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are number of small details about the keycache operations that
are very easy to miss (and forget), so better include detailed
comments in ath9k_hw_set_keycache_entry() to avoid having to figure
out this every time when having to touch this area.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/hw.c  |   76 +++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath9k/mac.h |    8 ++--
 2 files changed, 78 insertions(+), 6 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/hw.c	2009-03-02 14:23:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/hw.c	2009-03-02 14:23:07.000000000 +0200
@@ -2482,18 +2482,49 @@ bool ath9k_hw_set_keycache_entry(struct 
 	if (k->kv_len <= LEN_WEP104)
 		key4 &= 0xff;
 
+	/*
+	 * Note: Key cache registers access special memory area that requires
+	 * two 32-bit writes to actually update the values in the internal
+	 * memory. Consequently, the exact order and pairs used here must be
+	 * maintained.
+	 */
+
 	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
 		u16 micentry = entry + 64;
 
+		/*
+		 * Write inverted key[47:0] first to avoid Michael MIC errors
+		 * on frames that could be sent or received at the same time.
+		 * The correct key will be written in the end once everything
+		 * else is ready.
+		 */
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), ~key0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), ~key1);
+
+		/* Write key[95:48] */
 		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
 		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
+
+		/* Write key[127:96] and key type */
 		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
 		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
+
+		/* Write MAC address for the entry */
 		(void) ath9k_hw_keysetmac(ah, entry, mac);
 
 		if (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) {
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
 			u32 mic0, mic1, mic2, mic3, mic4;
 
 			mic0 = get_unaligned_le32(k->kv_mic + 0);
@@ -2501,45 +2532,84 @@ bool ath9k_hw_set_keycache_entry(struct 
 			mic1 = get_unaligned_le16(k->kv_txmic + 2) & 0xffff;
 			mic3 = get_unaligned_le16(k->kv_txmic + 0) & 0xffff;
 			mic4 = get_unaligned_le32(k->kv_txmic + 4);
+
+			/* Write RX[31:0] and TX[31:16] */
 			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
 			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), mic1);
+
+			/* Write RX[63:32] and TX[15:0] */
 			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
 			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), mic3);
+
+			/* Write TX[63:32] and keyType(reserved) */
 			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), mic4);
 			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
 				  AR_KEYTABLE_TYPE_CLR);
 
 		} else {
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
 			u32 mic0, mic2;
 
 			mic0 = get_unaligned_le32(k->kv_mic + 0);
 			mic2 = get_unaligned_le32(k->kv_mic + 4);
+
+			/* Write MIC key[31:0] */
 			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
 			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
+
+			/* Write MIC key[63:32] */
 			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
 			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+
+			/* Write TX[63:32] and keyType(reserved) */
 			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
 			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
 				  AR_KEYTABLE_TYPE_CLR);
 		}
+
+		/* MAC address registers are reserved for the MIC entry */
 		REG_WRITE(ah, AR_KEYTABLE_MAC0(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_MAC1(micentry), 0);
+
+		/*
+		 * Write the correct (un-inverted) key[47:0] last to enable
+		 * TKIP now that all other registers are set with correct
+		 * values.
+		 */
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
 	} else {
+		/* Write key[47:0] */
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
+
+		/* Write key[95:48] */
 		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
 		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
+
+		/* Write key[127:96] and key type */
 		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
 		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
 
+		/* Write MAC address for the entry */
 		(void) ath9k_hw_keysetmac(ah, entry, mac);
 	}
 
-	if (ah->curchan == NULL)
-		return true;
-
 	return true;
 }
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/mac.h	2009-03-02 14:23:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/mac.h	2009-03-02 14:23:07.000000000 +0200
@@ -588,9 +588,11 @@ struct ath9k_keyval {
 	u8 kv_type;
 	u8 kv_pad;
 	u16 kv_len;
-	u8 kv_val[16];
-	u8 kv_mic[8];
-	u8 kv_txmic[8];
+	u8 kv_val[16]; /* TK */
+	u8 kv_mic[8]; /* Michael MIC key */
+	u8 kv_txmic[8]; /* Michael MIC TX key (used only if the hardware
+			 * supports both MIC keys in the same key cache entry;
+			 * in that case, kv_mic is the RX key) */
 };
 
 enum ath9k_key_type {

-- 
Jouni Malinen                                            PGP id EFC895FA
