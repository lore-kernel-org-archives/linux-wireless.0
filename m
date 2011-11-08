Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52108 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1KHIsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:48:43 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/4] ath9k_hw: Read and configure quick drop for AR9003
Date: Tue, 8 Nov 2011 14:19:32 +0530
Message-ID: <1320742175-10962-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111108_094847_642641_E9B49014)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read and configure quick drop feild from AR9003 eeprom
inorder to help with strong signal. This patch also removes
obsolate parameters ob, db_stage2, db_stage_3, db_stage4
from the eeprom templates.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  108 +++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    2 +
 drivers/net/wireless/ath/ath9k/eeprom.h        |    3 +-
 4 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 3b262ba..de103ef 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -121,10 +121,8 @@ static const struct ar9300_eeprom ar9300_default = {
 		 * if the register is per chain
 		 */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {1, 1, 1},/* 3 chain */
-		.db_stage2 = {1, 1, 1}, /* 3 chain  */
-		.db_stage3 = {0, 0, 0},
-		.db_stage4 = {0, 0, 0},
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -144,7 +142,7 @@ static const struct ar9300_eeprom ar9300_default = {
 	 },
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -323,10 +321,8 @@ static const struct ar9300_eeprom ar9300_default = {
 		.spurChans = {0, 0, 0, 0, 0},
 		/* noiseFloorThreshCh Check if the register is per chain */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {3, 3, 3}, /* 3 chain */
-		.db_stage2 = {3, 3, 3}, /* 3 chain */
-		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
-		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -698,10 +694,8 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		 * if the register is per chain
 		 */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {1, 1, 1},/* 3 chain */
-		.db_stage2 = {1, 1, 1}, /* 3 chain  */
-		.db_stage3 = {0, 0, 0},
-		.db_stage4 = {0, 0, 0},
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -721,7 +715,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 	 },
 	 .base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
 	 },
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -900,10 +894,8 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.spurChans = {FREQ2FBIN(5500, 0), 0, 0, 0, 0},
 		/* noiseFloorThreshCh Check if the register is per chain */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {3, 3, 3}, /* 3 chain */
-		.db_stage2 = {3, 3, 3}, /* 3 chain */
-		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
-		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0xf,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -1276,10 +1268,8 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		 * if the register is per chain
 		 */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {1, 1, 1},/* 3 chain */
-		.db_stage2 = {1, 1, 1}, /* 3 chain  */
-		.db_stage3 = {0, 0, 0},
-		.db_stage4 = {0, 0, 0},
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -1299,7 +1289,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 	},
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -1478,10 +1468,8 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.spurChans = {0, 0, 0, 0, 0},
 		/* noiseFloorThreshCh Check if the register is per chain */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {3, 3, 3}, /* 3 chain */
-		.db_stage2 = {3, 3, 3}, /* 3 chain */
-		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
-		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -1854,10 +1842,8 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		 * if the register is per chain
 		 */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {1, 1, 1},/* 3 chain */
-		.db_stage2 = {1, 1, 1}, /* 3 chain  */
-		.db_stage3 = {0, 0, 0},
-		.db_stage4 = {0, 0, 0},
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -1877,7 +1863,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 	},
 	.base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
 	},
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -2056,10 +2042,8 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.spurChans = {0, 0, 0, 0, 0},
 		/* noiseFloorThreshch check if the register is per chain */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {3, 3, 3}, /* 3 chain */
-		.db_stage2 = {3, 3, 3}, /* 3 chain */
-		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
-		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -2431,10 +2415,8 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		 * if the register is per chain
 		 */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {1, 1, 1},/* 3 chain */
-		.db_stage2 = {1, 1, 1}, /* 3 chain  */
-		.db_stage3 = {0, 0, 0},
-		.db_stage4 = {0, 0, 0},
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -2454,7 +2436,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 	 },
 	 .base_ext1 = {
 		.ant_div_control = 0,
-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
+		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
 	 },
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
@@ -2633,10 +2615,8 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.spurChans = {0, 0, 0, 0, 0},
 		/* noiseFloorThreshCh Check if the register is per chain */
 		.noiseFloorThreshCh = {-1, 0, 0},
-		.ob = {3, 3, 3}, /* 3 chain */
-		.db_stage2 = {3, 3, 3}, /* 3 chain */
-		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
-		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
+		.reserved = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+		.quick_drop = 0,
 		.xpaBiasLvl = 0,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
@@ -3023,6 +3003,8 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 		return eep->modalHeader5G.antennaGain;
 	case EEP_ANTENNA_GAIN_2G:
 		return eep->modalHeader2G.antennaGain;
+	case EEP_QUICK_DROP:
+		return pBase->miscConfiguration & BIT(1);
 	default:
 		return 0;
 	}
@@ -3428,25 +3410,13 @@ static u32 ar9003_dump_modal_eeprom(char *buf, u32 len, u32 size,
 	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
 	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
 	PR_EEP("Chain2 NF Threshold", modal_hdr->noiseFloorThreshCh[2]);
+	PR_EEP("Quick Drop", modal_hdr->quick_drop);
 	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
 	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
 	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
 	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
 	PR_EEP("txClip", modal_hdr->txClip);
 	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
-	PR_EEP("Chain0 ob", modal_hdr->ob[0]);
-	PR_EEP("Chain1 ob", modal_hdr->ob[1]);
-	PR_EEP("Chain2 ob", modal_hdr->ob[2]);
-
-	PR_EEP("Chain0 db_stage2", modal_hdr->db_stage2[0]);
-	PR_EEP("Chain1 db_stage2", modal_hdr->db_stage2[1]);
-	PR_EEP("Chain2 db_stage2", modal_hdr->db_stage2[2]);
-	PR_EEP("Chain0 db_stage3", modal_hdr->db_stage3[0]);
-	PR_EEP("Chain1 db_stage3", modal_hdr->db_stage3[1]);
-	PR_EEP("Chain2 db_stage3", modal_hdr->db_stage3[2]);
-	PR_EEP("Chain0 db_stage4", modal_hdr->db_stage4[0]);
-	PR_EEP("Chain1 db_stage4", modal_hdr->db_stage4[1]);
-	PR_EEP("Chain2 db_stage4", modal_hdr->db_stage4[2]);
 
 	return len;
 }
@@ -3503,6 +3473,7 @@ static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	PR_EEP("Internal regulator", !!(pBase->featureEnable & BIT(4)));
 	PR_EEP("Enable Paprd", !!(pBase->featureEnable & BIT(5)));
 	PR_EEP("Driver Strength", !!(pBase->miscConfiguration & BIT(0)));
+	PR_EEP("Quick Drop", !!(pBase->miscConfiguration & BIT(1)));
 	PR_EEP("Chain mask Reduce", (pBase->miscConfiguration >> 0x3) & 0x1);
 	PR_EEP("Write enable Gpio", pBase->eepromWriteEnableGpio);
 	PR_EEP("WLAN Disable Gpio", pBase->wlanDisableGpio);
@@ -3965,6 +3936,26 @@ static void ar9003_hw_apply_tuning_caps(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_hw_quick_drop_apply(struct ath_hw *ah, u16 freq)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	int quick_drop = ath9k_hw_ar9300_get_eeprom(ah, EEP_QUICK_DROP);
+	s32 t[3], f[3] = {5180, 5500, 5785};
+
+	if (!quick_drop)
+		return;
+
+	if (freq < 4000)
+		quick_drop = eep->modalHeader2G.quick_drop;
+	else {
+		t[0] = eep->base_ext1.quick_drop_low;
+		t[1] = eep->modalHeader5G.quick_drop;
+		t[2] = eep->base_ext1.quick_drop_high;
+		quick_drop = ar9003_hw_power_interpolate(freq, f, t, 3);
+	}
+	REG_RMW_FIELD(ah, AR_PHY_AGC, AR_PHY_AGC_QUICK_DROP, quick_drop);
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -3972,6 +3963,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_ant_ctrl_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_drive_strength_apply(ah);
 	ar9003_hw_atten_apply(ah, chan);
+	ar9003_hw_quick_drop_apply(ah, chan->channel);
 	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 6335a86..bb223fe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -216,10 +216,8 @@ struct ar9300_modal_eep_header {
 	u8 spurChans[AR_EEPROM_MODAL_SPURS];
 	/* 3  Check if the register is per chain */
 	int8_t noiseFloorThreshCh[AR9300_MAX_CHAINS];
-	u8 ob[AR9300_MAX_CHAINS];
-	u8 db_stage2[AR9300_MAX_CHAINS];
-	u8 db_stage3[AR9300_MAX_CHAINS];
-	u8 db_stage4[AR9300_MAX_CHAINS];
+	u8 reserved[11];
+	int8_t quick_drop;
 	u8 xpaBiasLvl;
 	u8 txFrameToDataStart;
 	u8 txFrameToPaOn;
@@ -269,7 +267,9 @@ struct cal_ctl_data_5g {
 
 struct ar9300_BaseExtension_1 {
 	u8 ant_div_control;
-	u8 future[13];
+	u8 future[11];
+	int8_t quick_drop_low;
+	int8_t quick_drop_high;
 } __packed;
 
 struct ar9300_BaseExtension_2 {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 4114fe7..497d746 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -389,6 +389,8 @@
 #define AR_PHY_DAG_CTRLCCK_RSSI_THR_S   10
 
 #define AR_PHY_RIFS_INIT_DELAY         0x3ff0000
+#define AR_PHY_AGC_QUICK_DROP       0x03c00000
+#define AR_PHY_AGC_QUICK_DROP_S     22
 #define AR_PHY_AGC_COARSE_LOW       0x00007F80
 #define AR_PHY_AGC_COARSE_LOW_S     7
 #define AR_PHY_AGC_COARSE_HIGH      0x003F8000
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 49abd34..5ff7ab9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -249,7 +249,8 @@ enum eeprom_param {
 	EEP_ANT_DIV_CTL1,
 	EEP_CHAIN_MASK_REDUCE,
 	EEP_ANTENNA_GAIN_2G,
-	EEP_ANTENNA_GAIN_5G
+	EEP_ANTENNA_GAIN_5G,
+	EEP_QUICK_DROP
 };
 
 enum ar5416_rates {
-- 
1.7.7.2

