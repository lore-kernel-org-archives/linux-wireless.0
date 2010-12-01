Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13858 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab0LAHfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:35:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:35:00 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 21/26] ath9k_hw: Define IQcal correction coefficient registers using index
Date: Tue, 30 Nov 2010 23:32:50 -0800
Message-ID: <1291188775-13707-22-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    8 +++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index f218613..c3867cd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -608,11 +608,6 @@ static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
 		AR_PHY_TX_IQCAL_STATUS_B1,
 		AR_PHY_TX_IQCAL_STATUS_B2,
 	};
-	static const u32 tx_corr_coeff[AR9300_MAX_CHAINS] = {
-		AR_PHY_TX_IQCAL_CORR_COEFF_01_B0,
-		AR_PHY_TX_IQCAL_CORR_COEFF_01_B1,
-		AR_PHY_TX_IQCAL_CORR_COEFF_01_B2,
-	};
 	static const u32 rx_corr[AR9300_MAX_CHAINS] = {
 		AR_PHY_RX_IQCAL_CORR_B0,
 		AR_PHY_RX_IQCAL_CORR_B1,
@@ -623,11 +618,16 @@ static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
 		AR_PHY_CHAN_INFO_TAB_1,
 		AR_PHY_CHAN_INFO_TAB_2,
 	};
+	u32 tx_corr_coeff[AR9300_MAX_CHAINS];
 	s32 iq_res[6];
 	s32 iqc_coeff[2];
 	s32 i, j;
 	u32 num_chains = 0;
 
+	tx_corr_coeff[0] = AR_PHY_TX_IQCAL_CORR_COEFF_B0(0);
+	tx_corr_coeff[1] = AR_PHY_TX_IQCAL_CORR_COEFF_B1(0);
+	tx_corr_coeff[2] = AR_PHY_TX_IQCAL_CORR_COEFF_B2(0);
+
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 		if (ah->txchainmask & (1 << i))
 			num_chains++;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 4c64eb1..abb4ec1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -549,7 +549,9 @@
 #define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + 0x448)
 #define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + 0x440)
 #define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + 0x48c)
-#define AR_PHY_TX_IQCAL_CORR_COEFF_01_B0    (AR_SM_BASE + 0x450)
+#define AR_PHY_TX_IQCAL_CORR_COEFF_B0(_i)    (AR_SM_BASE + \
+					     (AR_SREV_9485(ah) ? \
+					      0x3d0 : 0x450) + ((_i) << 2))
 
 #define AR_PHY_WATCHDOG_STATUS      (AR_SM_BASE + 0x5c0)
 #define AR_PHY_WATCHDOG_CTL_1       (AR_SM_BASE + 0x5c4)
@@ -813,7 +815,7 @@
 #define AR_PHY_TPC_11_B1         (AR_SM1_BASE + 0x220)
 #define AR_PHY_PDADC_TAB_1       (AR_SM1_BASE + 0x240)
 #define AR_PHY_TX_IQCAL_STATUS_B1   (AR_SM1_BASE + 0x48c)
-#define AR_PHY_TX_IQCAL_CORR_COEFF_01_B1    (AR_SM1_BASE + 0x450)
+#define AR_PHY_TX_IQCAL_CORR_COEFF_B1(_i)    (AR_SM_BASE + 0x450 + ((_i) << 2))
 
 /*
  * Channel 2 Register Map
@@ -866,7 +868,7 @@
 #define AR_PHY_TPC_11_B2         (AR_SM2_BASE + 0x220)
 #define AR_PHY_PDADC_TAB_2       (AR_SM2_BASE + 0x240)
 #define AR_PHY_TX_IQCAL_STATUS_B2   (AR_SM2_BASE + 0x48c)
-#define AR_PHY_TX_IQCAL_CORR_COEFF_01_B2    (AR_SM2_BASE + 0x450)
+#define AR_PHY_TX_IQCAL_CORR_COEFF_B2(_i)    (AR_SM2_BASE + 0x450 + ((_i) << 2))
 
 #define AR_PHY_TX_IQCAL_STATUS_B2_FAILED    0x00000001
 
-- 
1.7.0.4

