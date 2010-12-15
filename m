Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64251 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0LOPbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:30:51 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] ath9k_hw: Remove unnecessary Rx IQ cal register configuration in ar9003_hw_tx_iq_cal()
Date: Wed, 15 Dec 2010 07:30:48 -0800
Message-ID: <1292427053-5880-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 7c3334b..75a1c6e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -616,11 +616,6 @@ static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
 		AR_PHY_TX_IQCAL_STATUS_B1,
 		AR_PHY_TX_IQCAL_STATUS_B2,
 	};
-	static const u32 rx_corr[AR9300_MAX_CHAINS] = {
-		AR_PHY_RX_IQCAL_CORR_B0,
-		AR_PHY_RX_IQCAL_CORR_B1,
-		AR_PHY_RX_IQCAL_CORR_B2,
-	};
 	static const u_int32_t chan_info_tab[] = {
 		AR_PHY_CHAN_INFO_TAB_0,
 		AR_PHY_CHAN_INFO_TAB_1,
@@ -703,18 +698,10 @@ static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
 		REG_RMW_FIELD(ah, tx_corr_coeff[i],
 			      AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE,
 			      iqc_coeff[0]);
-		REG_RMW_FIELD(ah, rx_corr[i],
-			      AR_PHY_RX_IQCAL_CORR_LOOPBACK_IQCORR_Q_Q_COFF,
-			      iqc_coeff[1] >> 7);
-		REG_RMW_FIELD(ah, rx_corr[i],
-			      AR_PHY_RX_IQCAL_CORR_LOOPBACK_IQCORR_Q_I_COFF,
-			      iqc_coeff[1]);
 	}
 
 	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
 		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
-	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
-		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
 
 	return;
 
-- 
1.7.0.4

