Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47530 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1COOZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 10:25:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 07:25:17 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/4] ath: Speedup key set/reset ops for HTC driver
Date: Tue, 15 Mar 2011 19:55:38 +0530
Message-ID: <1300199138-11851-4-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
References: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By enabling buffered register write for ath9k_htc driver
avoids unnecessary dissociation while rekeying phase under
heavy traffic exchange.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/key.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 37b8e11..0d4f39c 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -23,6 +23,14 @@
 
 #define REG_READ			(common->ops->read)
 #define REG_WRITE(_ah, _reg, _val)	(common->ops->write)(_ah, _val, _reg)
+#define ENABLE_REGWRITE_BUFFER(_ah)			\
+	if (common->ops->enable_write_buffer)		\
+		common->ops->enable_write_buffer((_ah));
+
+#define REGWRITE_BUFFER_FLUSH(_ah)			\
+	if (common->ops->write_flush)			\
+		common->ops->write_flush((_ah));
+
 
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
 
@@ -42,6 +50,8 @@ bool ath_hw_keyreset(struct ath_common *common, u16 entry)
 
 	keyType = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), 0);
 	REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), 0);
 	REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), 0);
@@ -66,6 +76,8 @@ bool ath_hw_keyreset(struct ath_common *common, u16 entry)
 
 	}
 
+	REGWRITE_BUFFER_FLUSH(ah);
+
 	return true;
 }
 EXPORT_SYMBOL(ath_hw_keyreset);
@@ -104,9 +116,13 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 	} else {
 		macLo = macHi = 0;
 	}
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
 	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | unicast_flag);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+
 	return true;
 }
 
@@ -223,6 +239,8 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 			mic3 = get_unaligned_le16(k->kv_txmic + 0) & 0xffff;
 			mic4 = get_unaligned_le32(k->kv_txmic + 4);
 
+			ENABLE_REGWRITE_BUFFER(ah);
+
 			/* Write RX[31:0] and TX[31:16] */
 			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
 			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), mic1);
@@ -236,6 +254,8 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
 				  AR_KEYTABLE_TYPE_CLR);
 
+			REGWRITE_BUFFER_FLUSH(ah);
+
 		} else {
 			/*
 			 * TKIP uses four key cache entries (two for group
@@ -258,6 +278,8 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 			mic0 = get_unaligned_le32(k->kv_mic + 0);
 			mic2 = get_unaligned_le32(k->kv_mic + 4);
 
+			ENABLE_REGWRITE_BUFFER(ah);
+
 			/* Write MIC key[31:0] */
 			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
 			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
@@ -270,8 +292,12 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
 			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
 				  AR_KEYTABLE_TYPE_CLR);
+
+			REGWRITE_BUFFER_FLUSH(ah);
 		}
 
+		ENABLE_REGWRITE_BUFFER(ah);
+
 		/* MAC address registers are reserved for the MIC entry */
 		REG_WRITE(ah, AR_KEYTABLE_MAC0(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_MAC1(micentry), 0);
@@ -283,7 +309,11 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 		 */
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
+
+		REGWRITE_BUFFER_FLUSH(ah);
 	} else {
+		ENABLE_REGWRITE_BUFFER(ah);
+
 		/* Write key[47:0] */
 		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
@@ -296,6 +326,8 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
 		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
 
+		REGWRITE_BUFFER_FLUSH(ah);
+
 		/* Write MAC address for the entry */
 		(void) ath_hw_keysetmac(common, entry, mac);
 	}
-- 
1.7.4.1

