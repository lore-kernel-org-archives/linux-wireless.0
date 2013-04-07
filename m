Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58783 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934397Ab3DGWEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/7] ath9k_hw: make various ar5416/ar91xx rf banks const
Date: Mon,  8 Apr 2013 00:04:08 +0200
Message-Id: <1365372253-32782-2-git-send-email-nbd@openwrt.org> (sfid-20130408_000430_993671_EDB81C0C)
In-Reply-To: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Banks 0-3,7 are neither modified at run time, nor SREV dependent.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 75 ++++++++---------------------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |  6 ---
 drivers/net/wireless/ath/ath9k/calib.h      |  6 +++
 drivers/net/wireless/ath/ath9k/hw.h         | 10 ----
 4 files changed, 26 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 93f8f96..391da5a 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -18,6 +18,7 @@
 #include "hw-ops.h"
 #include "../regd.h"
 #include "ar9002_phy.h"
+#include "ar5008_initvals.h"
 
 /* All code below is for AR5008, AR9001, AR9002 */
 
@@ -43,23 +44,16 @@ static const int m2ThreshLowExt_off = 127;
 static const int m1ThreshExt_off = 127;
 static const int m2ThreshExt_off = 127;
 
+static const struct ar5416IniArray bank0 = STATIC_INI_ARRAY(ar5416Bank0);
+static const struct ar5416IniArray bank1 = STATIC_INI_ARRAY(ar5416Bank1);
+static const struct ar5416IniArray bank2 = STATIC_INI_ARRAY(ar5416Bank2);
+static const struct ar5416IniArray bank3 = STATIC_INI_ARRAY(ar5416Bank3);
+static const struct ar5416IniArray bank7 = STATIC_INI_ARRAY(ar5416Bank7);
 
-static void ar5008_rf_bank_setup(u32 *bank, struct ar5416IniArray *array,
-				 int col)
-{
-	int i;
-
-	for (i = 0; i < array->ia_rows; i++)
-		bank[i] = INI_RA(array, i, col);
-}
-
-
-#define REG_WRITE_RF_ARRAY(iniarray, regData, regWr) \
-	ar5008_write_rf_array(ah, iniarray, regData, &(regWr))
-
-static void ar5008_write_rf_array(struct ath_hw *ah, struct ar5416IniArray *array,
-				  u32 *data, unsigned int *writecnt)
+static void ar5008_write_bank6(struct ath_hw *ah, unsigned int *writecnt)
 {
+	struct ar5416IniArray *array = &ah->iniBank6;
+	u32 *data = ah->analogBank6Data;
 	int r;
 
 	ENABLE_REGWRITE_BUFFER(ah);
@@ -165,7 +159,7 @@ static void ar5008_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 	ar5008_hw_phy_modify_rx_buffer(ah->analogBank6Data, tmp_reg, 3, 181, 3);
 
 	/* write Bank 6 with new params */
-	REG_WRITE_RF_ARRAY(&ah->iniBank6, ah->analogBank6Data, reg_writes);
+	ar5008_write_bank6(ah, &reg_writes);
 }
 
 /**
@@ -469,29 +463,16 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
  */
 static int ar5008_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 {
-#define ATH_ALLOC_BANK(bank, size) do { \
-		bank = devm_kzalloc(ah->dev, sizeof(u32) * size, GFP_KERNEL); \
-		if (!bank) \
-			goto error; \
-	} while (0);
-
-	struct ath_common *common = ath9k_hw_common(ah);
+	int size = ah->iniBank6.ia_rows * sizeof(u32);
 
 	if (AR_SREV_9280_20_OR_LATER(ah))
 	    return 0;
 
-	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank2Data, ah->iniBank2.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank3Data, ah->iniBank3.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank6Data, ah->iniBank6.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank7Data, ah->iniBank7.ia_rows);
+	ah->analogBank6Data = devm_kzalloc(ah->dev, size, GFP_KERNEL);
+	if (!ah->analogBank6Data)
+		return -ENOMEM;
 
 	return 0;
-#undef ATH_ALLOC_BANK
-error:
-	ath_err(common, "Cannot allocate RF banks\n");
-	return -ENOMEM;
 }
 
 
@@ -528,19 +509,6 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	/* Setup rf parameters */
 	eepMinorRev = ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV);
 
-	/* Setup Bank 0 Write */
-	ar5008_rf_bank_setup(ah->analogBank0Data, &ah->iniBank0, 1);
-
-	/* Setup Bank 1 Write */
-	ar5008_rf_bank_setup(ah->analogBank1Data, &ah->iniBank1, 1);
-
-	/* Setup Bank 2 Write */
-	ar5008_rf_bank_setup(ah->analogBank2Data, &ah->iniBank2, 1);
-
-	/* Setup Bank 6 Write */
-	ar5008_rf_bank_setup(ah->analogBank3Data, &ah->iniBank3,
-		      modesIndex);
-
 	for (i = 0; i < ah->iniBank6.ia_rows; i++)
 		ah->analogBank6Data[i] = INI_RA(&ah->iniBank6, i, modesIndex);
 
@@ -563,16 +531,13 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 		}
 	}
 
-	/* Setup Bank 7 Setup */
-	ar5008_rf_bank_setup(ah->analogBank7Data, &ah->iniBank7, 1);
-
 	/* Write Analog registers */
-	REG_WRITE_RF_ARRAY(&ah->iniBank0, ah->analogBank0Data, regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank1, ah->analogBank1Data, regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank2, ah->analogBank2Data, regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank3, ah->analogBank3Data, regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank6, ah->analogBank6Data, regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank7, ah->analogBank7Data, regWrites);
+	REG_WRITE_ARRAY(&bank0, 1, regWrites);
+	REG_WRITE_ARRAY(&bank1, 1, regWrites);
+	REG_WRITE_ARRAY(&bank2, 1, regWrites);
+	REG_WRITE_ARRAY(&bank3, modesIndex, regWrites);
+	ar5008_write_bank6(ah, &regWrites);
+	REG_WRITE_ARRAY(&bank7, 1, regWrites);
 
 	return true;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index a4654d3..830daa1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -78,12 +78,6 @@ static int ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		/* Common for AR5416, AR913x, AR9160 */
 		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain);
 
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7);
-
 		/* Common for AR913x, AR9160 */
 		if (!AR_SREV_5416(ah))
 			INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6TPC_9100);
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 60dcb6c..3d70b8c 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -33,6 +33,12 @@ struct ar5416IniArray {
 	u32 ia_columns;
 };
 
+#define STATIC_INI_ARRAY(array) {			\
+		.ia_array = (u32 *)(array),		\
+		.ia_rows = ARRAY_SIZE(array),		\
+		.ia_columns = ARRAY_SIZE(array[0]),	\
+	}
+
 #define INIT_INI_ARRAY(iniarray, array) do {	\
 		(iniarray)->ia_array = (u32 *)(array);		\
 		(iniarray)->ia_rows = ARRAY_SIZE(array);	\
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e463c9a..ae30343 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -847,12 +847,7 @@ struct ath_hw {
 	struct ath_hw_ops ops;
 
 	/* Used to program the radio on non single-chip devices */
-	u32 *analogBank0Data;
-	u32 *analogBank1Data;
-	u32 *analogBank2Data;
-	u32 *analogBank3Data;
 	u32 *analogBank6Data;
-	u32 *analogBank7Data;
 
 	int coverage_class;
 	u32 slottime;
@@ -883,13 +878,8 @@ struct ath_hw {
 
 	struct ar5416IniArray iniModes;
 	struct ar5416IniArray iniCommon;
-	struct ar5416IniArray iniBank0;
 	struct ar5416IniArray iniBB_RfGain;
-	struct ar5416IniArray iniBank1;
-	struct ar5416IniArray iniBank2;
-	struct ar5416IniArray iniBank3;
 	struct ar5416IniArray iniBank6;
-	struct ar5416IniArray iniBank7;
 	struct ar5416IniArray iniAddac;
 	struct ar5416IniArray iniPcieSerdes;
 #ifdef CONFIG_PM_SLEEP
-- 
1.8.0.2

