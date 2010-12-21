Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24205 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382Ab0LUJmk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 04:42:40 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 01:42:24 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Fix bug in eeprom data length validation for AR9485
Date: Tue, 21 Dec 2010 01:42:43 -0800
Message-ID: <1292924563-3339-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The size of the eeprom data is 1088 bytes for AR9485. But
a sanity check is done against 4K which would result in a
'potential read past the end of the buffer' smatch complaint.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f80ec74..579a033 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -59,6 +59,8 @@
 
 #define CTL(_tpower, _flag) ((_tpower) | ((_flag) << 6))
 
+#define EEPROM_DATA_LEN_9485	1088
+
 static int ar9003_hw_power_interpolate(int32_t x,
 				       int32_t *px, int32_t *py, u_int16_t np);
 
@@ -3367,7 +3369,7 @@ found:
 			"Found block at %x: code=%d ref=%d length=%d major=%d minor=%d\n",
 			cptr, code, reference, length, major, minor);
 		if ((!AR_SREV_9485(ah) && length >= 1024) ||
-		    (AR_SREV_9485(ah) && length >= (4 * 1024))) {
+		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485)) {
 			ath_dbg(common, ATH_DBG_EEPROM,
 				"Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
-- 
1.7.0.4

