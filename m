Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60885 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925AbcAUPeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 10:34:14 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, martin.blumenstingl@googlemail.com
Subject: [PATCH] ath9k_hw: ignore eeprom magic mismatch on flash based devices
Date: Thu, 21 Jan 2016 16:34:08 +0100
Message-Id: <1453390448-87417-1-git-send-email-nbd@openwrt.org> (sfid-20160121_163417_634968_3A7461ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many AR913x based devices (maybe others too) do not have a valid EEPROM
magic in their calibration data partition.

Fixes: 6fa658fd5ab2 ("ath9k: Simplify and fix eeprom endianness swapping")
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a7afdee..73fb423 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -150,18 +150,18 @@ int ath9k_hw_nvram_swap_data(struct ath_hw *ah, bool *swap_needed, int size)
 		return -EIO;
 	}
 
-	if (magic == AR5416_EEPROM_MAGIC) {
-		*swap_needed = false;
-	} else if (swab16(magic) == AR5416_EEPROM_MAGIC) {
+	*swap_needed = false;
+	if (swab16(magic) == AR5416_EEPROM_MAGIC) {
 		if (ah->ah_flags & AH_NO_EEP_SWAP) {
 			ath_info(common,
 				 "Ignoring endianness difference in EEPROM magic bytes.\n");
-
-			*swap_needed = false;
 		} else {
 			*swap_needed = true;
 		}
-	} else {
+	} else if (magic != AR5416_EEPROM_MAGIC) {
+		if (ath9k_hw_use_flash(ah))
+			return 0;
+
 		ath_err(common,
 			"Invalid EEPROM Magic (0x%04x).\n", magic);
 		return -EINVAL;
-- 
2.2.2

