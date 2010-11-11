Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:12728 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab0KKIkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 03:40:41 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 00:40:29 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 01/11 V2] ath9k_hw: Fix a reset failure on AR9382 (2x2).
Date: Thu, 11 Nov 2010 00:40:33 -0800
Message-ID: <1289464833-7989-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

AR9382 needs to be configured for the correct chain mask before
running AGC/TxIQ caliberation. Otherwise reset would fail.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
V2 - Fix indentation

 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   17 ++++++++++++-----
 drivers/net/wireless/ath/ath9k/reg.h          |    2 ++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 9e6edff..32eed19 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -718,12 +718,19 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	int val;
 
-	/*
-	 * 0x7 = 0b111 , AR9003 needs to be configured for 3-chain mode before
-	 * running AGC/TxIQ cals
-	 */
-	ar9003_hw_set_chain_masks(ah, 0x7, 0x7);
+	val = REG_READ(ah, AR_ENT_OTP);
+	ath_print(common, ATH_DBG_CALIBRATE, "ath9k: AR_ENT_OTP 0x%x\n", val);
+
+	if (val & AR_ENT_OTP_CHAIN2_DISABLE)
+		ar9003_hw_set_chain_masks(ah, 0x3, 0x3);
+	else
+		/*
+		 * 0x7 = 0b111 , AR9003 needs to be configured for 3-chain
+		 * mode before running AGC/TxIQ cals
+		 */
+		ar9003_hw_set_chain_masks(ah, 0x7, 0x7);
 
 	/* Do Tx IQ Calibration */
 	ar9003_hw_tx_iq_cal(ah);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index fa05b71..e676a80 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1066,6 +1066,8 @@ enum {
 #define AR_INTR_PRIO_ASYNC_MASK   0x40c8
 #define AR_INTR_PRIO_SYNC_MASK    0x40cc
 #define AR_INTR_PRIO_ASYNC_ENABLE 0x40d4
+#define AR_ENT_OTP		  0x40d8
+#define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
 
 #define AR_RTC_9300_PLL_DIV          0x000003ff
 #define AR_RTC_9300_PLL_DIV_S        0
-- 
1.7.0.4

