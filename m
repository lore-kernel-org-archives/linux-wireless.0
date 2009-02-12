Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36316 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbZBLEkb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:31 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:31 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42849.198425.552819@gargle.gargle.HOWL> (sfid-20090212_054034_455438_B91D5F96)
Date: Thu, 12 Feb 2009 10:06:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/8] ath9k: Initialize AGC calibration properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/phy.h   |    4 ++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 1fc3a08..a7ce8c5 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -851,6 +851,30 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 bool ath9k_hw_init_cal(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+
+		/* Kick off the cal */
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			  AR_PHY_AGC_CONTROL_CAL);
+
+		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+				   AR_PHY_AGC_CONTROL_CAL, 0)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
+				"offset calibration failed to complete in 1ms; "
+				"noisy environment?\n");
+			return false;
+		}
+
+		REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	}
+
+	/* Calibrate the AGC */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_CAL);
@@ -862,9 +886,16 @@ bool ath9k_hw_init_cal(struct ath_hw *ah,
 		return false;
 	}
 
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+	}
+
+	/* Do PA Calibration */
 	if (AR_SREV_9285(ah) && AR_SREV_9285_11_OR_LATER(ah))
 		ath9k_hw_9285_pa_cal(ah);
 
+	/* Do NF Calibration */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_NF);
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 837a598..4758c37 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -485,6 +485,10 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4    0x0FC00000
 #define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4_S  22
 
+/* Carrier leak calibration control, do it after AGC calibration */
+#define AR_PHY_CL_CAL_CTL       0xA358
+#define AR_PHY_CL_CAL_ENABLE    0x00000002
+
 #define AR_PHY_POWER_TX_RATE5   0xA38C
 #define AR_PHY_POWER_TX_RATE6   0xA390
 
-- 
1.6.1

