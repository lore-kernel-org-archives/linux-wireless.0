Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54850 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3EPRUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 13:20:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, <stable@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Enable manual peak calibration for AR9485
Date: Thu, 16 May 2013 22:47:34 +0530
Message-Id: <1368724654-23241-1-git-send-email-sujith@msujith.org> (sfid-20130516_192009_358066_6B49687E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Manual peak calibration is currently enabled only for
AR9462 and AR9565. This is also required for AR9485.
The initvals are also modified to disable HW peak calibration.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c    | 2 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 639ba7d..6988e1d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -965,7 +965,7 @@ static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
 {
 	int i;
 
-	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah))
+	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah) && !AR_SREV_9485(ah))
 		return;
 
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index 712f415..88ff1d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -1020,7 +1020,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x000002a0, 0x000002a0},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.8.2.3

