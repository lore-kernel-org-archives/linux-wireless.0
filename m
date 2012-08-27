Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53758 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab2H0PAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 11:00:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.6 3/6] ath9k_hw: calibrate PA input for PA predistortion
Date: Mon, 27 Aug 2012 17:00:05 +0200
Message-Id: <1346079608-40944-3-git-send-email-nbd@openwrt.org> (sfid-20120827_170103_633454_490C1D57)
In-Reply-To: <1346079608-40944-2-git-send-email-nbd@openwrt.org>
References: <1346079608-40944-1-git-send-email-nbd@openwrt.org>
 <1346079608-40944-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-train if the calibrated PA linearization curve is out of bounds
(affects AR933x and AR9485).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   99 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    4 +
 drivers/net/wireless/ath/ath9k/link.c         |    9 ++-
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 2173bd7..0ed3846 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -786,6 +786,102 @@ int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
 }
 EXPORT_SYMBOL(ar9003_paprd_setup_gain_table);
 
+static bool ar9003_paprd_retrain_pa_in(struct ath_hw *ah,
+				       struct ath9k_hw_cal_data *caldata,
+				       int chain)
+{
+	u32 *pa_in = caldata->pa_table[chain];
+	int capdiv_offset, quick_drop_offset;
+	int capdiv2g, quick_drop;
+	int count = 0;
+	int i;
+
+	if (!AR_SREV_9485(ah) && !AR_SREV_9330(ah))
+		return false;
+
+	capdiv2g = REG_READ_FIELD(ah, AR_PHY_65NM_CH0_TXRF3,
+				  AR_PHY_65NM_CH0_TXRF3_CAPDIV2G);
+
+	quick_drop = REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
+				    AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP);
+
+	if (quick_drop)
+		quick_drop -= 0x40;
+
+	for (i = 0; i < NUM_BIN + 1; i++) {
+		if (pa_in[i] == 1400)
+			count++;
+	}
+
+	if (AR_SREV_9485(ah)) {
+		if (pa_in[23] < 800) {
+			capdiv_offset = (int)((1000 - pa_in[23] + 75) / 150);
+			capdiv2g += capdiv_offset;
+			if (capdiv2g > 7) {
+				capdiv2g = 7;
+				if (pa_in[23] < 600) {
+					quick_drop++;
+					if (quick_drop > 0)
+						quick_drop = 0;
+				}
+			}
+		} else if (pa_in[23] == 1400) {
+			quick_drop_offset = min_t(int, count / 3, 2);
+			quick_drop += quick_drop_offset;
+			capdiv2g += quick_drop_offset / 2;
+
+			if (capdiv2g > 7)
+				capdiv2g = 7;
+
+			if (quick_drop > 0) {
+				quick_drop = 0;
+				capdiv2g -= quick_drop_offset;
+				if (capdiv2g < 0)
+					capdiv2g = 0;
+			}
+		} else {
+			return false;
+		}
+	} else if (AR_SREV_9330(ah)) {
+		if (pa_in[23] < 1000) {
+			capdiv_offset = (1000 - pa_in[23]) / 100;
+			capdiv2g += capdiv_offset;
+			if (capdiv_offset > 3) {
+				capdiv_offset = 1;
+				quick_drop--;
+			}
+
+			capdiv2g += capdiv_offset;
+			if (capdiv2g > 6)
+				capdiv2g = 6;
+			if (quick_drop < -4)
+				quick_drop = -4;
+		} else if (pa_in[23] == 1400) {
+			if (count > 3) {
+				quick_drop++;
+				capdiv2g -= count / 4;
+				if (quick_drop > -2)
+					quick_drop = -2;
+			} else {
+				capdiv2g--;
+			}
+
+			if (capdiv2g < 0)
+				capdiv2g = 0;
+		} else {
+			return false;
+		}
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_TXRF3,
+		      AR_PHY_65NM_CH0_TXRF3_CAPDIV2G, capdiv2g);
+	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
+		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
+		      quick_drop);
+
+	return true;
+}
+
 int ar9003_paprd_create_curve(struct ath_hw *ah,
 			      struct ath9k_hw_cal_data *caldata, int chain)
 {
@@ -821,6 +917,9 @@ int ar9003_paprd_create_curve(struct ath_hw *ah,
 	if (!create_pa_curve(data_L, data_U, pa_table, small_signal_gain))
 		status = -2;
 
+	if (ar9003_paprd_retrain_pa_in(ah, caldata, chain))
+		status = -EINPROGRESS;
+
 	REG_CLR_BIT(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 		    AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 7bfbaf0..84d3d49 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -625,6 +625,10 @@
 #define AR_PHY_AIC_CTRL_4_B0	(AR_SM_BASE + 0x4c0)
 #define AR_PHY_AIC_STAT_2_B0	(AR_SM_BASE + 0x4cc)
 
+#define AR_PHY_65NM_CH0_TXRF3       0x16048
+#define AR_PHY_65NM_CH0_TXRF3_CAPDIV2G		0x0000001e
+#define AR_PHY_65NM_CH0_TXRF3_CAPDIV2G_S	1
+
 #define AR_PHY_65NM_CH0_SYNTH4      0x1608c
 #define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   (AR_SREV_9462(ah) ? 0x00000001 : 0x00000002)
 #define AR_PHY_SYNTH4_LONG_SHIFT_SELECT_S (AR_SREV_9462(ah) ? 0 : 1)
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index d4549e9..1c24192 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -254,6 +254,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int chain_ok = 0;
 	int chain;
 	int len = 1800;
+	int ret;
 
 	if (!caldata)
 		return;
@@ -302,7 +303,13 @@ void ath_paprd_calibrate(struct work_struct *work)
 			break;
 		}
 
-		if (ar9003_paprd_create_curve(ah, caldata, chain)) {
+		ret = ar9003_paprd_create_curve(ah, caldata, chain);
+		if (ret == -EINPROGRESS) {
+			ath_dbg(common, CALIBRATE,
+				"PAPRD curve on chain %d needs to be re-trained\n",
+				chain);
+			break;
+		} else if (ret) {
 			ath_dbg(common, CALIBRATE,
 				"PAPRD create curve failed on chain %d\n",
 				chain);
-- 
1.7.9.6 (Apple Git-31.1)

