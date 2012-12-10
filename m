Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:53669
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2LJBxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 20:53:23 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] ath9k_hw: Fix PAPRD registers for AR9485
Date: Mon, 10 Dec 2012 07:22:31 +0530
Message-Id: <1355104358-30062-1-git-send-email-sujith@msujith.org> (sfid-20121210_025335_083060_8811EEFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Various PAPRD registers are at addresses that are different
from those for the rest of the chips in the AR9003 family.
Fix them.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 4c3d06d..1079562 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -1145,9 +1145,8 @@
 #define AR_PHY_PAPRD_CTRL1_PAPRD_MAG_SCALE_FACT		0x0ffe0000
 #define AR_PHY_PAPRD_CTRL1_PAPRD_MAG_SCALE_FACT_S	17
 
-#define AR_PHY_PAPRD_TRAINER_CNTL1				(AR_SM_BASE + \
-								 (AR_SREV_9485(ah) ? \
-								  0x580 : 0x490))
+#define AR_PHY_PAPRD_TRAINER_CNTL1 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x580 : 0x490))
+
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE	0x00000001
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE_S	0
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_AGC2_SETTLING	0x0000007e
@@ -1163,15 +1162,13 @@
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_LB_SKIP		0x0003f000
 #define AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_LB_SKIP_S		12
 
-#define AR_PHY_PAPRD_TRAINER_CNTL2				(AR_SM_BASE + \
-								 (AR_SREV_9485(ah) ? \
-								  0x584 : 0x494))
+#define AR_PHY_PAPRD_TRAINER_CNTL2 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x584 : 0x494))
+
 #define AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN	0xFFFFFFFF
 #define AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN_S	0
 
-#define AR_PHY_PAPRD_TRAINER_CNTL3				(AR_SM_BASE + \
-								 (AR_SREV_9485(ah) ? \
-								  0x588 : 0x498))
+#define AR_PHY_PAPRD_TRAINER_CNTL3 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x588 : 0x498))
+
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE	0x0000003f
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE_S	0
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP		0x00000fc0
@@ -1187,9 +1184,8 @@
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_BBTXMIX_DISABLE	0x20000000
 #define AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_BBTXMIX_DISABLE_S	29
 
-#define AR_PHY_PAPRD_TRAINER_CNTL4				(AR_SM_BASE + \
-								 (AR_SREV_9485(ah) ? \
-								  0x58c : 0x49c))
+#define AR_PHY_PAPRD_TRAINER_CNTL4 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x58c : 0x49c))
+
 #define AR_PHY_PAPRD_TRAINER_CNTL4_CF_PAPRD_NUM_TRAIN_SAMPLES	0x03ff0000
 #define AR_PHY_PAPRD_TRAINER_CNTL4_CF_PAPRD_NUM_TRAIN_SAMPLES_S	16
 #define AR_PHY_PAPRD_TRAINER_CNTL4_CF_PAPRD_SAFETY_DELTA	0x0000f000
@@ -1208,7 +1204,8 @@
 #define AR_PHY_PAPRD_PRE_POST_SCALING				0x3FFFF
 #define AR_PHY_PAPRD_PRE_POST_SCALING_S				0
 
-#define AR_PHY_PAPRD_TRAINER_STAT1				(AR_SM_BASE + 0x4a0)
+#define AR_PHY_PAPRD_TRAINER_STAT1 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x590 : 0x4a0))
+
 #define AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE		0x00000001
 #define AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE_S		0
 #define AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_INCOMPLETE	0x00000002
@@ -1222,7 +1219,8 @@
 #define AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_AGC2_PWR		0x0001fe00
 #define AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_AGC2_PWR_S		9
 
-#define AR_PHY_PAPRD_TRAINER_STAT2				(AR_SM_BASE + 0x4a4)
+#define AR_PHY_PAPRD_TRAINER_STAT2 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x594 : 0x4a4))
+
 #define AR_PHY_PAPRD_TRAINER_STAT2_PAPRD_FINE_VAL		0x0000ffff
 #define AR_PHY_PAPRD_TRAINER_STAT2_PAPRD_FINE_VAL_S		0
 #define AR_PHY_PAPRD_TRAINER_STAT2_PAPRD_COARSE_IDX		0x001f0000
@@ -1230,7 +1228,8 @@
 #define AR_PHY_PAPRD_TRAINER_STAT2_PAPRD_FINE_IDX		0x00600000
 #define AR_PHY_PAPRD_TRAINER_STAT2_PAPRD_FINE_IDX_S		21
 
-#define AR_PHY_PAPRD_TRAINER_STAT3				(AR_SM_BASE + 0x4a8)
+#define AR_PHY_PAPRD_TRAINER_STAT3 (AR_SM_BASE + (AR_SREV_9485(ah) ? 0x598 : 0x4a8))
+
 #define AR_PHY_PAPRD_TRAINER_STAT3_PAPRD_TRAIN_SAMPLES_CNT	0x000fffff
 #define AR_PHY_PAPRD_TRAINER_STAT3_PAPRD_TRAIN_SAMPLES_CNT_S	0
 
-- 
1.8.0.1

