Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:65143 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2KIJWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 04:22:03 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Fix wrong peak detector DC offset
Date: Fri, 9 Nov 2012 14:51:30 +0530
Message-ID: <1352452890-9512-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121109_102217_662723_22D6E169)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An issue is reported in AR9462 & AR9565 that NF_cal_not_done is
not observed when HW peak detector calibration is disabled. At that
state, the HW is stuck at NF calibration which prevents tx output.
The root cause is wrong peak detector offset calibrated by HW. To
resolve this issue, peak detector calibration is done manually by SW
for AR9462 and AR9565.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      | 76 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        | 46 +++++++++++--
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |  2 +-
 3 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 162401f..8b0d8dc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -891,6 +891,74 @@ static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
 }
 
+static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
+{
+	int offset[8], total = 0, test;
+	int agc_out, i;
+
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+		      AR_PHY_65NM_RXRF_GAINSTAGES_RX_OVERRIDE, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+		      AR_PHY_65NM_RXRF_GAINSTAGES_LNAON_CALDC, 0x0);
+	if (is_2g)
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+			      AR_PHY_65NM_RXRF_GAINSTAGES_LNA2G_GAIN_OVR, 0x0);
+	else
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+			      AR_PHY_65NM_RXRF_GAINSTAGES_LNA5G_GAIN_OVR, 0x0);
+
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXTX2(chain),
+		      AR_PHY_65NM_RXTX2_RXON_OVR, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXTX2(chain),
+		      AR_PHY_65NM_RXTX2_RXON, 0x0);
+
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+		      AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+		      AR_PHY_65NM_RXRF_AGC_AGC_ON_OVR, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0x1);
+	if (is_2g)
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR, 0x0);
+	else
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR, 0x0);
+
+	for (i = 6; i > 0; i--) {
+		offset[i] = BIT(i - 1);
+		test = total + offset[i];
+
+		if (is_2g)
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+				      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR,
+				      test);
+		else
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+				      AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR,
+				      test);
+		udelay(100);
+		agc_out = REG_READ_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+					 AR_PHY_65NM_RXRF_AGC_AGC_OUT);
+		offset[i] = (agc_out) ? 0 : 1;
+		total += (offset[i] << (i - 1));
+	}
+
+	if (is_2g)
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR, total);
+	else
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			      AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR, total);
+
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
+		      AR_PHY_65NM_RXRF_GAINSTAGES_RX_OVERRIDE, 0);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXTX2(chain),
+		      AR_PHY_65NM_RXTX2_RXON_OVR, 0);
+	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0);
+}
+
 static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
@@ -989,6 +1057,14 @@ skip_tx_iqcal:
 		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				       AR_PHY_AGC_CONTROL_CAL,
 				       0, AH_WAIT_TIMEOUT);
+		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+				if (!(ah->rxchainmask & (1 << i)))
+					continue;
+				ar9003_hw_manual_peak_cal(ah, i,
+							  IS_CHAN_2GHZ(chan));
+			}
+		}
 	}
 
 	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 8f58523..4c3d06d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -698,13 +698,6 @@
 #define AR_PHY_65NM_CH0_THERM_SAR_ADC_OUT   0x0000ff00
 #define AR_PHY_65NM_CH0_THERM_SAR_ADC_OUT_S 8
 
-#define AR_PHY_65NM_CH0_RXTX1       0x16100
-#define AR_PHY_65NM_CH0_RXTX2       0x16104
-#define AR_PHY_65NM_CH1_RXTX1       0x16500
-#define AR_PHY_65NM_CH1_RXTX2       0x16504
-#define AR_PHY_65NM_CH2_RXTX1       0x16900
-#define AR_PHY_65NM_CH2_RXTX2       0x16904
-
 #define AR_CH0_TOP2		(AR_SREV_9300(ah) ? 0x1628c : \
 					(AR_SREV_9462(ah) ? 0x16290 : 0x16284))
 #define AR_CH0_TOP2_XPABIASLVL		0xf000
@@ -1286,4 +1279,43 @@
 #define AR_BTCOEX_WL_LNADIV_BT_INACTIVE_THRESHOLD          0xFC000000
 #define AR_BTCOEX_WL_LNADIV_BT_INACTIVE_THRESHOLD_S        26
 
+/* Manual Peak detector calibration */
+#define AR_PHY_65NM_BASE                               0x16000
+#define AR_PHY_65NM_RXRF_GAINSTAGES(i)                 (AR_PHY_65NM_BASE + \
+							(i * 0x400) + 0x8)
+#define AR_PHY_65NM_RXRF_GAINSTAGES_RX_OVERRIDE        0x80000000
+#define AR_PHY_65NM_RXRF_GAINSTAGES_RX_OVERRIDE_S      31
+#define AR_PHY_65NM_RXRF_GAINSTAGES_LNAON_CALDC        0x00000002
+#define AR_PHY_65NM_RXRF_GAINSTAGES_LNAON_CALDC_S      1
+#define AR_PHY_65NM_RXRF_GAINSTAGES_LNA2G_GAIN_OVR     0x70000000
+#define AR_PHY_65NM_RXRF_GAINSTAGES_LNA2G_GAIN_OVR_S   28
+#define AR_PHY_65NM_RXRF_GAINSTAGES_LNA5G_GAIN_OVR     0x03800000
+#define AR_PHY_65NM_RXRF_GAINSTAGES_LNA5G_GAIN_OVR_S   23
+
+#define AR_PHY_65NM_RXTX2(i)                           (AR_PHY_65NM_BASE + \
+							(i * 0x400) + 0x104)
+#define AR_PHY_65NM_RXTX2_RXON_OVR                     0x00001000
+#define AR_PHY_65NM_RXTX2_RXON_OVR_S                   12
+#define AR_PHY_65NM_RXTX2_RXON                         0x00000800
+#define AR_PHY_65NM_RXTX2_RXON_S                       11
+
+#define AR_PHY_65NM_RXRF_AGC(i)                        (AR_PHY_65NM_BASE + \
+							(i * 0x400) + 0xc)
+#define AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE              0x80000000
+#define AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE_S            31
+#define AR_PHY_65NM_RXRF_AGC_AGC_ON_OVR                0x40000000
+#define AR_PHY_65NM_RXRF_AGC_AGC_ON_OVR_S              30
+#define AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR               0x20000000
+#define AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR_S             29
+#define AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR           0x1E000000
+#define AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR_S         25
+#define AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR           0x00078000
+#define AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR_S         15
+#define AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR          0x01F80000
+#define AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR_S        19
+#define AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR          0x00007e00
+#define AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR_S        9
+#define AR_PHY_65NM_RXRF_AGC_AGC_OUT                   0x00000004
+#define AR_PHY_65NM_RXRF_AGC_AGC_OUT_S                 2
+
 #endif  /* AR9003_PHY_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 58f30f6..ccc42a7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -78,7 +78,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.8.0

