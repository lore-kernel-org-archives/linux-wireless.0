Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36050 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0LFMaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 07:30:04 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 04:29:50 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 06/27] ath9k_hw: Eeeprom changes for AR9485
Date: Mon, 6 Dec 2010 04:27:39 -0800
Message-ID: <1291638480-8950-7-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
References: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calibration data are stored at 4k address (0xfff). The cal data
for AR9485 is not compressed so its lengh can exceed 1024 limit,
take care of that.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++++++--
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 872b1a3..791e849 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3320,7 +3320,10 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	memcpy(mptr, &ar9300_default, mdata_size);
 
 	read = ar9300_read_eeprom;
-	cptr = AR9300_BASE_ADDR;
+	if (AR_SREV_9485(ah))
+		cptr = AR9300_BASE_ADDR_4K;
+	else
+		cptr = AR9300_BASE_ADDR;
 	ath_print(common, ATH_DBG_EEPROM,
 		"Trying EEPROM accesss at Address 0x%04x\n", cptr);
 	if (ar9300_check_eeprom_header(ah, read, cptr))
@@ -3363,7 +3366,8 @@ found:
 			  "Found block at %x: code=%d ref=%d"
 			  "length=%d major=%d minor=%d\n", cptr, code,
 			  reference, length, major, minor);
-		if (length >= 1024) {
+		if ((!AR_SREV_9485(ah) && length >= 1024) ||
+		    (AR_SREV_9485(ah) && length >= (4 * 1024))) {
 			ath_print(common, ATH_DBG_EEPROM,
 				  "Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 9c14633..ce4d762 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -78,6 +78,7 @@
 #define AR9300_EEPROM_SIZE (16*1024)
 #define FIXED_CCA_THRESHOLD 15
 
+#define AR9300_BASE_ADDR_4K 0xfff
 #define AR9300_BASE_ADDR 0x3ff
 #define AR9300_BASE_ADDR_512 0x1ff
 
-- 
1.7.0.4

