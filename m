Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49585 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab2GLPEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:04:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 11/12] ath9k_hw: apply XLNA bias settings from EEPROM
Date: Thu, 12 Jul 2012 17:04:10 +0200
Message-Id: <1342105451-42297-11-git-send-email-nbd@openwrt.org> (sfid-20120712_170428_277382_720A465A)
In-Reply-To: <1342105451-42297-10-git-send-email-nbd@openwrt.org>
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org>
 <1342105451-42297-2-git-send-email-nbd@openwrt.org>
 <1342105451-42297-3-git-send-email-nbd@openwrt.org>
 <1342105451-42297-4-git-send-email-nbd@openwrt.org>
 <1342105451-42297-5-git-send-email-nbd@openwrt.org>
 <1342105451-42297-6-git-send-email-nbd@openwrt.org>
 <1342105451-42297-7-git-send-email-nbd@openwrt.org>
 <1342105451-42297-8-git-send-email-nbd@openwrt.org>
 <1342105451-42297-9-git-send-email-nbd@openwrt.org>
 <1342105451-42297-10-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   53 +++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    5 ++
 3 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4d90265..c5f3c43 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -131,8 +131,9 @@ static const struct ar9300_eeprom ar9300_default = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext1 = {
@@ -331,8 +332,9 @@ static const struct ar9300_eeprom ar9300_default = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext2 = {
@@ -704,8 +706,9 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	 .base_ext1 = {
@@ -904,8 +907,9 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext2 = {
@@ -1278,8 +1282,9 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext1 = {
@@ -1478,8 +1483,9 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext2 = {
@@ -1852,8 +1858,9 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80c080),
 		.papdRateMaskHt40 = LE32(0x0080c080),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext1 = {
@@ -2052,8 +2059,9 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	},
 	.base_ext2 = {
@@ -2425,8 +2433,9 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0c80C080),
 		.papdRateMaskHt40 = LE32(0x0080C080),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	 .base_ext1 = {
@@ -2625,8 +2634,9 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.thresh62 = 28,
 		.papdRateMaskHt20 = LE32(0x0cf0e0e0),
 		.papdRateMaskHt40 = LE32(0x6cf0e0e0),
+		.xlna_bias_strength = 0,
 		.futureModal = {
-			0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0,
 		},
 	 },
 	.base_ext2 = {
@@ -3942,6 +3952,28 @@ static void ar9003_hw_xpa_timing_control_apply(struct ath_hw *ah, bool is2ghz)
 			      AR_PHY_XPA_TIMING_CTL_FRAME_XPAA_ON, xpa_ctl);
 }
 
+static void ar9003_hw_xlna_bias_strength_apply(struct ath_hw *ah, bool is2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	u8 bias;
+
+	if (!(eep->baseEepHeader.featureEnable & 0x40))
+		return;
+
+	if (!AR_SREV_9300(ah))
+		return;
+
+	bias = ar9003_modal_header(ah, is2ghz)->xlna_bias_strength;
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4, AR_PHY_65NM_RXTX4_XLNA_BIAS,
+		      bias & 0x3);
+	bias >>= 2;
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4, AR_PHY_65NM_RXTX4_XLNA_BIAS,
+		      bias & 0x3);
+	bias >>= 2;
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4, AR_PHY_65NM_RXTX4_XLNA_BIAS,
+		      bias & 0x3);
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -3950,6 +3982,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_xpa_bias_level_apply(ah, is2ghz);
 	ar9003_hw_ant_ctrl_apply(ah, is2ghz);
 	ar9003_hw_drive_strength_apply(ah);
+	ar9003_hw_xlna_bias_strength_apply(ah, is2ghz);
 	ar9003_hw_atten_apply(ah, chan);
 	ar9003_hw_quick_drop_apply(ah, chan->channel);
 	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) && !AR_SREV_9550(ah))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 8396d15..3a1ff55 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -231,7 +231,8 @@ struct ar9300_modal_eep_header {
 	__le32 papdRateMaskHt20;
 	__le32 papdRateMaskHt40;
 	__le16 switchcomspdt;
-	u8 futureModal[8];
+	u8 xlna_bias_strength;
+	u8 futureModal[7];
 } __packed;
 
 struct ar9300_cal_data_per_freq_op_loop {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 751c83b..7bfbaf0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -633,6 +633,8 @@
 #define AR_PHY_65NM_CH0_BIAS2       0x160c4
 #define AR_PHY_65NM_CH0_BIAS4       0x160cc
 #define AR_PHY_65NM_CH0_RXTX4       0x1610c
+#define AR_PHY_65NM_CH1_RXTX4       0x1650c
+#define AR_PHY_65NM_CH2_RXTX4       0x1690c
 
 #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
 				((AR_SREV_9462(ah) ? 0x1628c : 0x16280)))
@@ -876,6 +878,9 @@
 #define AR_PHY_65NM_CH0_RXTX4_THERM_ON          0x10000000
 #define AR_PHY_65NM_CH0_RXTX4_THERM_ON_S        28
 
+#define AR_PHY_65NM_RXTX4_XLNA_BIAS		0xC0000000
+#define AR_PHY_65NM_RXTX4_XLNA_BIAS_S		30
+
 /*
  * Channel 1 Register Map
  */
-- 
1.7.3.2

