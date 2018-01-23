Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:40290 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbeAWHlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 02:41:24 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 2/4] ath9k: Read noise floor calibration data from eeprom
Date: Tue, 23 Jan 2018 08:35:23 +0100
Message-Id: <1516692925-6695-3-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180123_084136_878454_B9C960A1)
In-Reply-To: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 devices can have calibrated noise floor values
which can be used instead of hard coded one. Read them
from eeprom and save interpolated value in nf limits for
the current channel.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 63 ++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h | 10 ++++
 drivers/net/wireless/ath/ath9k/hw.h            |  2 +
 3 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 23bb677..de2e503 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4689,7 +4689,8 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 				  int ichain,
 				  int *pfrequency,
 				  int *pcorrection,
-				  int *ptemperature, int *pvoltage)
+				  int *ptemperature, int *pvoltage,
+				  int *pnf_cal, int *pnf_power)
 {
 	u8 *pCalPier;
 	struct ar9300_cal_data_per_freq_op_loop *pCalPierStruct;
@@ -4731,6 +4732,10 @@ static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
 	*pcorrection = pCalPierStruct->refPower;
 	*ptemperature = pCalPierStruct->tempMeas;
 	*pvoltage = pCalPierStruct->voltMeas;
+	*pnf_cal = pCalPierStruct->rxTempMeas ?
+			N2DBM(pCalPierStruct->rxNoisefloorCal) : 0;
+	*pnf_power = pCalPierStruct->rxTempMeas ?
+			N2DBM(pCalPierStruct->rxNoisefloorPower) : 0;
 
 	return 0;
 }
@@ -4895,14 +4900,18 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 	int mode;
 	int lfrequency[AR9300_MAX_CHAINS],
 	    lcorrection[AR9300_MAX_CHAINS],
-	    ltemperature[AR9300_MAX_CHAINS], lvoltage[AR9300_MAX_CHAINS];
+	    ltemperature[AR9300_MAX_CHAINS], lvoltage[AR9300_MAX_CHAINS],
+	    lnf_cal[AR9300_MAX_CHAINS], lnf_pwr[AR9300_MAX_CHAINS];
 	int hfrequency[AR9300_MAX_CHAINS],
 	    hcorrection[AR9300_MAX_CHAINS],
-	    htemperature[AR9300_MAX_CHAINS], hvoltage[AR9300_MAX_CHAINS];
+	    htemperature[AR9300_MAX_CHAINS], hvoltage[AR9300_MAX_CHAINS],
+	    hnf_cal[AR9300_MAX_CHAINS], hnf_pwr[AR9300_MAX_CHAINS];
 	int fdiff;
 	int correction[AR9300_MAX_CHAINS],
-	    voltage[AR9300_MAX_CHAINS], temperature[AR9300_MAX_CHAINS];
-	int pfrequency, pcorrection, ptemperature, pvoltage;
+	    voltage[AR9300_MAX_CHAINS], temperature[AR9300_MAX_CHAINS],
+	    nf_cal[AR9300_MAX_CHAINS], nf_pwr[AR9300_MAX_CHAINS];
+	int pfrequency, pcorrection, ptemperature, pvoltage,
+	    pnf_cal, pnf_pwr;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	mode = (frequency >= 4000);
@@ -4920,7 +4929,8 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 		for (ipier = 0; ipier < npier; ipier++) {
 			if (!ar9003_hw_cal_pier_get(ah, mode, ipier, ichain,
 						    &pfrequency, &pcorrection,
-						    &ptemperature, &pvoltage)) {
+						    &ptemperature, &pvoltage,
+						    &pnf_cal, &pnf_pwr)) {
 				fdiff = frequency - pfrequency;
 
 				/*
@@ -4942,6 +4952,8 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 						htemperature[ichain] =
 						    ptemperature;
 						hvoltage[ichain] = pvoltage;
+						hnf_cal[ichain] = pnf_cal;
+						hnf_pwr[ichain] = pnf_pwr;
 					}
 				}
 				if (fdiff >= 0) {
@@ -4958,6 +4970,8 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 						ltemperature[ichain] =
 						    ptemperature;
 						lvoltage[ichain] = pvoltage;
+						lnf_cal[ichain] = pnf_cal;
+						lnf_pwr[ichain] = pnf_pwr;
 					}
 				}
 			}
@@ -4966,15 +4980,20 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 
 	/* interpolate  */
 	for (ichain = 0; ichain < AR9300_MAX_CHAINS; ichain++) {
-		ath_dbg(common, EEPROM, "ch=%d f=%d low=%d %d h=%d %d\n",
+		ath_dbg(common, EEPROM,
+			"ch=%d f=%d low=%d %d h=%d %d n=%d %d p=%d %d\n",
 			ichain, frequency, lfrequency[ichain],
 			lcorrection[ichain], hfrequency[ichain],
-			hcorrection[ichain]);
+			hcorrection[ichain], lnf_cal[ichain],
+			hnf_cal[ichain], lnf_pwr[ichain],
+			hnf_pwr[ichain]);
 		/* they're the same, so just pick one */
 		if (hfrequency[ichain] == lfrequency[ichain]) {
 			correction[ichain] = lcorrection[ichain];
 			voltage[ichain] = lvoltage[ichain];
 			temperature[ichain] = ltemperature[ichain];
+			nf_cal[ichain] = lnf_cal[ichain];
+			nf_pwr[ichain] = lnf_pwr[ichain];
 		}
 		/* the low frequency is good */
 		else if (frequency - lfrequency[ichain] < 1000) {
@@ -4998,12 +5017,26 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 						hfrequency[ichain],
 						lvoltage[ichain],
 						hvoltage[ichain]);
+
+				nf_cal[ichain] = interpolate(frequency,
+						lfrequency[ichain],
+						hfrequency[ichain],
+						lnf_cal[ichain],
+						hnf_cal[ichain]);
+
+				nf_pwr[ichain] = interpolate(frequency,
+						lfrequency[ichain],
+						hfrequency[ichain],
+						lnf_pwr[ichain],
+						hnf_pwr[ichain]);
 			}
 			/* only low is good, use it */
 			else {
 				correction[ichain] = lcorrection[ichain];
 				temperature[ichain] = ltemperature[ichain];
 				voltage[ichain] = lvoltage[ichain];
+				nf_cal[ichain] = lnf_cal[ichain];
+				nf_pwr[ichain] = lnf_pwr[ichain];
 			}
 		}
 		/* only high is good, use it */
@@ -5011,10 +5044,14 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 			correction[ichain] = hcorrection[ichain];
 			temperature[ichain] = htemperature[ichain];
 			voltage[ichain] = hvoltage[ichain];
+			nf_cal[ichain] = hnf_cal[ichain];
+			nf_pwr[ichain] = hnf_pwr[ichain];
 		} else {	/* nothing is good, presume 0???? */
 			correction[ichain] = 0;
 			temperature[ichain] = 0;
 			voltage[ichain] = 0;
+			nf_cal[ichain] = 0;
+			nf_pwr[ichain] = 0;
 		}
 	}
 
@@ -5025,6 +5062,16 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 		"for frequency=%d, calibration correction = %d %d %d\n",
 		frequency, correction[0], correction[1], correction[2]);
 
+	/* Store calibrated noise floor values */
+	for (ichain = 0; ichain < AR5416_MAX_CHAINS; ichain++)
+		if (mode) {
+			ah->nf_5g.cal[ichain] = nf_cal[ichain];
+			ah->nf_5g.pwr[ichain] = nf_pwr[ichain];
+		} else {
+			ah->nf_2g.cal[ichain] = nf_cal[ichain];
+			ah->nf_2g.pwr[ichain] = nf_pwr[ichain];
+		}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index bd2269c..e8fda54 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -62,6 +62,16 @@
  */
 #define AR9300_PWR_TABLE_OFFSET  0
 
+/* Noise power data definitions
+ * units are: 4 x dBm - NOISE_PWR_DATA_OFFSET
+ * (e.g. -25 = (-25/4 - 90) = -96.25 dBm)
+ * range (for 6 signed bits) is (-32 to 31) + offset => -122dBm to -59dBm
+ * resolution (2 bits) is 0.25dBm
+ */
+#define NOISE_PWR_DATA_OFFSET	-90
+#define NOISE_PWR_DBM_2_INT(_p)	((((_p) + 3) >> 2) + NOISE_PWR_DATA_OFFSET)
+#define N2DBM(_p)		NOISE_PWR_DBM_2_INT(_p)
+
 /* byte addressable */
 #define AR9300_EEPROM_SIZE (16*1024)
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0d6c07c7..9804a24 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -754,6 +754,8 @@ struct ath_nf_limits {
 	s16 max;
 	s16 min;
 	s16 nominal;
+	s16 cal[AR5416_MAX_CHAINS];
+	s16 pwr[AR5416_MAX_CHAINS];
 };
 
 enum ath_cal_list {
-- 
2.7.4
