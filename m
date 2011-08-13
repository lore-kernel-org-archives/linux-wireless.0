Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:31 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 06/11] ath9k_hw: Remove unnecessary chainmask configuration
Date: Sat, 13 Aug 2011 10:28:13 +0530
Message-ID: <1313211498-14442-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065833_447405_68A04EFA)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chainmasks were already configured at process_ini
before doing init calibration.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   15 ---------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    2 --
 3 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index f48051c..fa35a02 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -839,20 +839,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	int val;
 	bool txiqcal_done = false;
 
-	val = REG_READ(ah, AR_ENT_OTP);
-	ath_dbg(common, ATH_DBG_CALIBRATE, "ath9k: AR_ENT_OTP 0x%x\n", val);
-
-	/* Configure rx/tx chains before running AGC/TxiQ cals */
-	if (val & AR_ENT_OTP_CHAIN2_DISABLE)
-		ar9003_hw_set_chain_masks(ah, 0x3, 0x3);
-	else
-		ar9003_hw_set_chain_masks(ah, pCap->rx_chainmask,
-					  pCap->tx_chainmask);
-
 	/* Do Tx IQ Calibration */
 	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
 		      AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
@@ -887,9 +875,6 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	if (txiqcal_done)
 		ar9003_hw_tx_iq_cal_post_proc(ah);
 
-	/* Revert chainmasks to their original values before NF cal */
-	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
-
 	ath9k_hw_start_nfcal(ah, true);
 
 	/* Initialize list pointers */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index dbe0b58..33edb56 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -540,7 +540,7 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
-void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
+static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
 	switch (rx) {
 	case 0x5:
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 5c59042..80397de 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -1124,6 +1124,4 @@
 #define AR_PHY_CL_TAB_CL_GAIN_MOD		0x1f
 #define AR_PHY_CL_TAB_CL_GAIN_MOD_S		0
 
-void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
-
 #endif  /* AR9003_PHY_H */
-- 
1.7.6

