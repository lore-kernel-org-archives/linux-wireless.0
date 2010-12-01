Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13863 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0LAHfd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:35:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:35:19 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 24/26] ath9k_hw: Setup paprd only for chain 0 on AR9485
Date: Tue, 30 Nov 2010 23:32:53 -0800
Message-ID: <1291188775-13707-25-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   40 +++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |   16 +++++++--
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 850bc98..71d7648 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -21,10 +21,12 @@ void ar9003_paprd_enable(struct ath_hw *ah, bool val)
 {
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B0,
 		      AR_PHY_PAPRD_CTRL0_PAPRD_ENABLE, !!val);
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B1,
-		      AR_PHY_PAPRD_CTRL0_PAPRD_ENABLE, !!val);
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B2,
-		      AR_PHY_PAPRD_CTRL0_PAPRD_ENABLE, !!val);
+	if (!AR_SREV_9485(ah)) {
+		REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B1,
+			      AR_PHY_PAPRD_CTRL0_PAPRD_ENABLE, !!val);
+		REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B2,
+			      AR_PHY_PAPRD_CTRL0_PAPRD_ENABLE, !!val);
+	}
 }
 EXPORT_SYMBOL(ar9003_paprd_enable);
 
@@ -44,6 +46,7 @@ static void ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	};
 	u32 am_mask, ht40_mask;
 	int i;
+	u8 nchains = AR9300_MAX_CHAINS;
 
 	if (ah->curchan && IS_CHAN_5GHZ(ah->curchan))
 		hdr = &eep->modalHeader5G;
@@ -57,7 +60,10 @@ static void ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2PM, AR_PHY_PAPRD_AM2PM_MASK, am_mask);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_HT40, AR_PHY_PAPRD_HT40_MASK, ht40_mask);
 
-	for (i = 0; i < 3; i++) {
+	if (AR_SREV_9485(ah))
+		nchains = 1;
+
+	for (i = 0; i < nchains; i++) {
 		REG_RMW_FIELD(ah, ctrl0[i],
 			      AR_PHY_PAPRD_CTRL0_USE_SINGLE_TABLE_MASK, 1);
 		REG_RMW_FIELD(ah, ctrl1[i],
@@ -102,8 +108,14 @@ static void ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_NUM_CORR_STAGES, 7);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_MIN_LOOPBACK_DEL, 1);
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
-		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP, -6);
+	if (AR_SREV_9485(ah))
+		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
+			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
+			      -3);
+	else
+		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
+			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
+			      -6);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE,
 		      -15);
@@ -620,13 +632,15 @@ void ar9003_paprd_populate_single_table(struct ath_hw *ah,
 		      AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL,
 		      training_power);
 
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL1_B1,
-		      AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL,
-		      training_power);
+	if (!AR_SREV_9485(ah)) {
+		REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL1_B1,
+			      AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL,
+			      training_power);
 
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL1_B2,
-		      AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL,
-		      training_power);
+		REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL1_B2,
+			      AR_PHY_PAPRD_CTRL1_PAPRD_POWER_AT_AM2AM_CAL,
+			      training_power);
+	}
 }
 EXPORT_SYMBOL(ar9003_paprd_populate_single_table);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 00cd3e5..6f811c7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -987,7 +987,9 @@
 #define AR_PHY_PAPRD_CTRL1_PAPRD_MAG_SCALE_FACT		0x0ffe0000
 #define AR_PHY_PAPRD_CTRL1_PAPRD_MAG_SCALE_FACT_S	17
 
-#define AR_PHY_PAPRD_TRAINER_CNTL1				(AR_SM_BASE + 0x490)
+#define AR_PHY_PAPRD_TRAINER_CNTL1				(AR_SM_BASE + \
+								 (AR_SREV_9485(ah) ? \
+								  0x580 : 0x490))
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE	0x00000001
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE_S	0
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_AGC2_SETTLING	0x0000007e
@@ -1003,11 +1005,15 @@
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_LB_SKIP		0x0003f000
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_LB_SKIP_S		12
 
-#define AR_PHY_PAPRD_TRAINER_CNTL2				(AR_SM_BASE + 0x494)
+#define AR_PHY_PAPRD_TRAINER_CNTL2				(AR_SM_BASE + \
+								 (AR_SREV_9485(ah) ? \
+								  0x584 : 0x494))
 #define AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN	0xFFFFFFFF
 #define AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN_S	0
 
-#define AR_PHY_PAPRD_TRAINER_CNTL3				(AR_SM_BASE + 0x498)
+#define AR_PHY_PAPRD_TRAINER_CNTL3				(AR_SM_BASE + \
+								 (AR_SREV_9485(ah) ? \
+								  0x588 : 0x498))
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE	0x0000003f
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE_S	0
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP		0x00000fc0
@@ -1023,7 +1029,9 @@
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_BBTXMIX_DISABLE	0x20000000
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_BBTXMIX_DISABLE_S	29
 
-#define AR_PHY_PAPRD_TRAINER_CNTL4				(AR_SM_BASE + 0x49c)
+#define AR_PHY_PAPRD_TRAINER_CNTL4				(AR_SM_BASE + \
+								 (AR_SREV_9485(ah) ? \
+								  0x58c : 0x49c))
 #define AR_PHY_PAPRD_TRAINER_CNTL4_CF_PAPRD_NUM_TRAIN_SAMPLES	0x03ff0000
 #define AR_PHY_PAPRD_TRAINER_CNTL4_CF_PAPRD_NUM_TRAIN_SAMPLES_S	16
 #define AR_PHY_PAPRD_TRAINER_CNTL4_CF_PAPRD_SAFETY_DELTA	0x0000f000
-- 
1.7.0.4

