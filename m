Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0ESUpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 16:45:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_hw: Enable TX IQ calibration on AR9003
Date: Wed, 19 May 2010 16:45:50 -0400
Message-Id: <1274301950-6883-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable it we now disable and re-enable the PHY chips
after TX IQ calibration.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   10 ++++++----
 drivers/net/wireless/ath/ath9k/hw.c           |    6 ------
 drivers/net/wireless/ath/ath9k/hw.h           |    1 -
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 5fcafb4..15bf4e2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -740,6 +740,12 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	 */
 	ar9003_hw_set_chain_masks(ah, 0x7, 0x7);
 
+	/* Do Tx IQ Calibration */
+	ar9003_hw_tx_iq_cal(ah);
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+	udelay(5);
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
 	/* Calibrate the AGC */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
@@ -754,10 +760,6 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		return false;
 	}
 
-	/* Do Tx IQ Calibration */
-	if (ah->config.tx_iq_calibration)
-		ar9003_hw_tx_iq_cal(ah);
-
 	/* Revert chainmasks to their original values before NF cal */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7b9779a..fe0a60b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -392,12 +392,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.rx_intr_mitigation = true;
 
 	/*
-	 * Tx IQ Calibration (ah->config.tx_iq_calibration) is only
-	 * used by AR9003, but it is showing reliability issues.
-	 * It will take a while to fix so this is currently disabled.
-	 */
-
-	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
 	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
 	 * This means we use it for all AR5416 devices, and the few
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9124edd..ab19f4e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -263,7 +263,6 @@ struct ath9k_ops_config {
 #define AR_BASE_FREQ_5GHZ   	4900
 #define AR_SPUR_FEEQ_BOUND_HT40 19
 #define AR_SPUR_FEEQ_BOUND_HT20 10
-	bool tx_iq_calibration; /* Only available for >= AR9003 */
 	int spurmode;
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 	u8 max_txtrig_level;
-- 
1.6.3.3

