Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37841 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbbCJIcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 04:32:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH 6/7] ath9k: Process the AIC calibration results
Date: Tue, 10 Mar 2015 14:05:33 +0530
Message-Id: <1425976534-1194-7-git-send-email-sujith@msujith.org> (sfid-20150310_093218_563516_D188A048)
In-Reply-To: <1425976534-1194-1-git-send-email-sujith@msujith.org>
References: <1425976534-1194-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch adds support for post-processing
the AIC calibration results.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 245 ++++++++++++++++++++++++++++
 1 file changed, 245 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index 00aaf4d..51ecc9b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -20,6 +20,22 @@
 #include "ar9003_aic.h"
 #include "reg_aic.h"
 
+static const u8 com_att_db_table[ATH_AIC_MAX_COM_ATT_DB_TABLE] = {
+	0, 3, 9, 15, 21, 27
+};
+
+static const u16 aic_lin_table[ATH_AIC_MAX_AIC_LIN_TABLE] = {
+	8191, 7300, 6506, 5799, 5168, 4606, 4105, 3659,
+	3261, 2906, 2590, 2309, 2057, 1834, 1634, 1457,
+	1298, 1157, 1031, 919,	819,  730,  651,  580,
+	517,  461,  411,  366,	326,  291,  259,  231,
+	206,  183,  163,  146,	130,  116,  103,  92,
+	82,   73,   65,	  58,	52,   46,   41,	  37,
+	33,   29,   26,	  23,	21,   18,   16,	  15,
+	13,   12,   10,	  9,	8,    7,    7,	  6,
+	5,    5,    4,	  4,	3
+};
+
 static bool ar9003_hw_is_aic_enabled(struct ath_hw *ah)
 {
 	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
@@ -30,6 +46,56 @@ static bool ar9003_hw_is_aic_enabled(struct ath_hw *ah)
 	return true;
 }
 
+static int16_t ar9003_aic_find_valid(struct ath_aic_sram_info *cal_sram,
+				     bool dir, u8 index)
+{
+	int16_t i;
+
+	if (dir) {
+		for (i = index + 1; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+			if (cal_sram[i].valid)
+				break;
+		}
+	} else {
+		for (i = index - 1; i >= 0; i--) {
+			if (cal_sram[i].valid)
+				break;
+		}
+	}
+
+	if ((i >= ATH_AIC_MAX_BT_CHANNEL) || (i < 0))
+		i = -1;
+
+	return i;
+}
+
+/*
+ * type 0: aic_lin_table, 1: com_att_db_table
+ */
+static int16_t ar9003_aic_find_index(u8 type, int16_t value)
+{
+	int16_t i = -1;
+
+	if (type == 0) {
+		for (i = ATH_AIC_MAX_AIC_LIN_TABLE - 1; i >= 0; i--) {
+			if (aic_lin_table[i] >= value)
+				break;
+		}
+	} else if (type == 1) {
+		for (i = 0; i < ATH_AIC_MAX_COM_ATT_DB_TABLE; i++) {
+			if (com_att_db_table[i] > value) {
+				i--;
+				break;
+			}
+		}
+
+		if (i >= ATH_AIC_MAX_COM_ATT_DB_TABLE)
+			i = -1;
+	}
+
+	return i;
+}
+
 static void ar9003_aic_gain_table(struct ath_hw *ah)
 {
 	u32 aic_atten_word[19], i;
@@ -186,12 +252,191 @@ static void ar9003_aic_cal_start(struct ath_hw *ah, u8 min_valid_count)
 	aic->aic_cal_state = AIC_CAL_STATE_STARTED;
 }
 
+static bool ar9003_aic_cal_post_process(struct ath_hw *ah)
+{
+	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
+	struct ath_aic_sram_info cal_sram[ATH_AIC_MAX_BT_CHANNEL];
+	struct ath_aic_out_info aic_sram[ATH_AIC_MAX_BT_CHANNEL];
+	u32 dir_path_gain_idx, quad_path_gain_idx, value;
+	u32 fixed_com_att_db;
+	int8_t dir_path_sign, quad_path_sign;
+	int16_t i;
+	bool ret = true;
+
+	memset(&cal_sram, 0, sizeof(cal_sram));
+	memset(&aic_sram, 0, sizeof(aic_sram));
+
+	for (i = 0; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+		value = aic->aic_sram[i];
+
+		cal_sram[i].valid =
+			MS(value, AR_PHY_AIC_SRAM_VALID);
+		cal_sram[i].rot_quad_att_db =
+			MS(value, AR_PHY_AIC_SRAM_ROT_QUAD_ATT_DB);
+		cal_sram[i].vga_quad_sign =
+			MS(value, AR_PHY_AIC_SRAM_VGA_QUAD_SIGN);
+		cal_sram[i].rot_dir_att_db =
+			MS(value, AR_PHY_AIC_SRAM_ROT_DIR_ATT_DB);
+		cal_sram[i].vga_dir_sign =
+			MS(value, AR_PHY_AIC_SRAM_VGA_DIR_SIGN);
+		cal_sram[i].com_att_6db =
+			MS(value, AR_PHY_AIC_SRAM_COM_ATT_6DB);
+
+		if (cal_sram[i].valid) {
+			dir_path_gain_idx = cal_sram[i].rot_dir_att_db +
+				com_att_db_table[cal_sram[i].com_att_6db];
+			quad_path_gain_idx = cal_sram[i].rot_quad_att_db +
+				com_att_db_table[cal_sram[i].com_att_6db];
+
+			dir_path_sign = (cal_sram[i].vga_dir_sign) ? 1 : -1;
+			quad_path_sign = (cal_sram[i].vga_quad_sign) ? 1 : -1;
+
+			aic_sram[i].dir_path_gain_lin = dir_path_sign *
+				aic_lin_table[dir_path_gain_idx];
+			aic_sram[i].quad_path_gain_lin = quad_path_sign *
+				aic_lin_table[quad_path_gain_idx];
+		}
+	}
+
+	for (i = 0; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+		int16_t start_idx, end_idx;
+
+		if (cal_sram[i].valid)
+			continue;
+
+		start_idx = ar9003_aic_find_valid(cal_sram, 0, i);
+		end_idx = ar9003_aic_find_valid(cal_sram, 1, i);
+
+		if (start_idx < 0) {
+			/* extrapolation */
+			start_idx = end_idx;
+			end_idx = ar9003_aic_find_valid(cal_sram, 1, start_idx);
+
+			if (end_idx < 0) {
+				ret = false;
+				break;
+			}
+
+			aic_sram[i].dir_path_gain_lin =
+				((aic_sram[start_idx].dir_path_gain_lin -
+				  aic_sram[end_idx].dir_path_gain_lin) *
+				 (start_idx - i) + ((end_idx - i) >> 1)) /
+				(end_idx - i) +
+				aic_sram[start_idx].dir_path_gain_lin;
+			aic_sram[i].quad_path_gain_lin =
+				((aic_sram[start_idx].quad_path_gain_lin -
+				  aic_sram[end_idx].quad_path_gain_lin) *
+				 (start_idx - i) + ((end_idx - i) >> 1)) /
+				(end_idx - i) +
+				aic_sram[start_idx].quad_path_gain_lin;
+		}
+
+		if (end_idx < 0) {
+			/* extrapolation */
+			end_idx = ar9003_aic_find_valid(cal_sram, 0, start_idx);
+
+			if (end_idx < 0) {
+				ret = false;
+				break;
+			}
+
+			aic_sram[i].dir_path_gain_lin =
+				((aic_sram[start_idx].dir_path_gain_lin -
+				  aic_sram[end_idx].dir_path_gain_lin) *
+				 (i - start_idx) + ((start_idx - end_idx) >> 1)) /
+				(start_idx - end_idx) +
+				aic_sram[start_idx].dir_path_gain_lin;
+			aic_sram[i].quad_path_gain_lin =
+				((aic_sram[start_idx].quad_path_gain_lin -
+				  aic_sram[end_idx].quad_path_gain_lin) *
+				 (i - start_idx) + ((start_idx - end_idx) >> 1)) /
+				(start_idx - end_idx) +
+				aic_sram[start_idx].quad_path_gain_lin;
+
+		} else if (start_idx >= 0){
+			/* interpolation */
+			aic_sram[i].dir_path_gain_lin =
+				(((end_idx - i) * aic_sram[start_idx].dir_path_gain_lin) +
+				 ((i - start_idx) * aic_sram[end_idx].dir_path_gain_lin) +
+				 ((end_idx - start_idx) >> 1)) /
+				(end_idx - start_idx);
+			aic_sram[i].quad_path_gain_lin =
+				(((end_idx - i) * aic_sram[start_idx].quad_path_gain_lin) +
+				 ((i - start_idx) * aic_sram[end_idx].quad_path_gain_lin) +
+				 ((end_idx - start_idx) >> 1))/
+				(end_idx - start_idx);
+		}
+	}
+
+	/* From dir/quad_path_gain_lin to sram. */
+	i = ar9003_aic_find_valid(cal_sram, 1, 0);
+	if (i < 0) {
+		i = 0;
+		ret = false;
+	}
+	fixed_com_att_db = com_att_db_table[cal_sram[i].com_att_6db];
+
+	for (i = 0; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+		int16_t rot_dir_path_att_db, rot_quad_path_att_db;
+
+		aic_sram[i].sram.vga_dir_sign =
+			(aic_sram[i].dir_path_gain_lin >= 0) ? 1 : 0;
+		aic_sram[i].sram.vga_quad_sign=
+			(aic_sram[i].quad_path_gain_lin >= 0) ? 1 : 0;
+
+		rot_dir_path_att_db =
+			ar9003_aic_find_index(0, abs(aic_sram[i].dir_path_gain_lin)) -
+			fixed_com_att_db;
+		rot_quad_path_att_db =
+			ar9003_aic_find_index(0, abs(aic_sram[i].quad_path_gain_lin)) -
+			fixed_com_att_db;
+
+		aic_sram[i].sram.com_att_6db =
+			ar9003_aic_find_index(1, fixed_com_att_db);
+
+		aic_sram[i].sram.valid = 1;
+
+		aic_sram[i].sram.rot_dir_att_db =
+			min(max(rot_dir_path_att_db,
+				(int16_t)ATH_AIC_MIN_ROT_DIR_ATT_DB),
+			    ATH_AIC_MAX_ROT_DIR_ATT_DB);
+		aic_sram[i].sram.rot_quad_att_db =
+			min(max(rot_quad_path_att_db,
+				(int16_t)ATH_AIC_MIN_ROT_QUAD_ATT_DB),
+			    ATH_AIC_MAX_ROT_QUAD_ATT_DB);
+	}
+
+	for (i = 0; i < ATH_AIC_MAX_BT_CHANNEL; i++) {
+		aic->aic_sram[i] = (SM(aic_sram[i].sram.vga_dir_sign,
+				       AR_PHY_AIC_SRAM_VGA_DIR_SIGN) |
+				    SM(aic_sram[i].sram.vga_quad_sign,
+				       AR_PHY_AIC_SRAM_VGA_QUAD_SIGN) |
+				    SM(aic_sram[i].sram.com_att_6db,
+				       AR_PHY_AIC_SRAM_COM_ATT_6DB) |
+				    SM(aic_sram[i].sram.valid,
+				       AR_PHY_AIC_SRAM_VALID) |
+				    SM(aic_sram[i].sram.rot_dir_att_db,
+				       AR_PHY_AIC_SRAM_ROT_DIR_ATT_DB) |
+				    SM(aic_sram[i].sram.rot_quad_att_db,
+				       AR_PHY_AIC_SRAM_ROT_QUAD_ATT_DB));
+	}
+
+	return ret;
+}
+
 static void ar9003_aic_cal_done(struct ath_hw *ah)
 {
+	struct ath9k_hw_aic *aic = &ah->btcoex_hw.aic;
+
 	/* Disable AIC reference signal in BT modem. */
 	REG_WRITE(ah, ATH_AIC_BT_JUPITER_CTRL,
 		  (REG_READ(ah, ATH_AIC_BT_JUPITER_CTRL) &
 		   ~ATH_AIC_BT_AIC_ENABLE));
+
+	if (ar9003_aic_cal_post_process(ah))
+		aic->aic_cal_state = AIC_CAL_STATE_DONE;
+	else
+		aic->aic_cal_state = AIC_CAL_STATE_ERROR;
 }
 
 static u8 ar9003_aic_cal_continue(struct ath_hw *ah, bool cal_once)
-- 
2.3.1

