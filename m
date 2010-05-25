Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50485 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624Ab0EYRm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 13:42:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k_hw: add multicast key search support
Date: Tue, 25 May 2010 19:42:44 +0200
Message-Id: <1274809366-73422-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a MAC address for a key table entry is flagged with the
multicast bit (0x01), indicate to the hardware that multicast
lookup instead of unicast lookup should be used. The multicast
bit itself never makes it to the actual keytable entry register,
as it is shifted out.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c33f17d..ce6b55c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1489,6 +1489,7 @@ EXPORT_SYMBOL(ath9k_hw_keyreset);
 bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
+	u32 unicast_flag = AR_KEYTABLE_VALID;
 
 	if (entry >= ah->caps.keycache_size) {
 		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
@@ -1497,6 +1498,16 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 	}
 
 	if (mac != NULL) {
+		/*
+		 * AR_KEYTABLE_VALID indicates that the address is a unicast
+		 * address, which must match the transmitter address for
+		 * decrypting frames.
+		 * Not setting this bit allows the hardware to use the key
+		 * for multicast frame decryption.
+		 */
+		if (mac[0] & 0x01)
+			unicast_flag = 0;
+
 		macHi = (mac[5] << 8) | mac[4];
 		macLo = (mac[3] << 24) |
 			(mac[2] << 16) |
@@ -1509,7 +1520,7 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 		macLo = macHi = 0;
 	}
 	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
-	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | AR_KEYTABLE_VALID);
+	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | unicast_flag);
 
 	return true;
 }
-- 
1.6.4.2

