Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58776 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396Ab3DGWES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:04:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/7] ath9k_hw: clean up RF Bank6 handling on AR5416/AR91xx
Date: Mon,  8 Apr 2013 00:04:07 +0200
Message-Id: <1365372253-32782-1-git-send-email-nbd@openwrt.org> (sfid-20130408_000421_414077_85A250D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two sets of initvals for this RF bank, one with TPC support and
one without.
The TPC one always gets used, so remove the other one to avoid confusion.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 31 ++++++++++-------------------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  | 11 +++-------
 drivers/net/wireless/ath/ath9k/hw.h         |  3 ---
 3 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index fd69376..93f8f96 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -485,9 +485,7 @@ static int ar5008_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 	ATH_ALLOC_BANK(ah->analogBank2Data, ah->iniBank2.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank3Data, ah->iniBank3.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank6Data, ah->iniBank6.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank6TPCData, ah->iniBank6TPC.ia_rows);
 	ATH_ALLOC_BANK(ah->analogBank7Data, ah->iniBank7.ia_rows);
-	ATH_ALLOC_BANK(ah->bank6Temp, ah->iniBank6.ia_rows);
 
 	return 0;
 #undef ATH_ALLOC_BANK
@@ -517,6 +515,7 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	u32 ob5GHz = 0, db5GHz = 0;
 	u32 ob2GHz = 0, db2GHz = 0;
 	int regWrites = 0;
+	int i;
 
 	/*
 	 * Software does not need to program bank data
@@ -541,13 +540,9 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	/* Setup Bank 6 Write */
 	ar5008_rf_bank_setup(ah->analogBank3Data, &ah->iniBank3,
 		      modesIndex);
-	{
-		int i;
-		for (i = 0; i < ah->iniBank6TPC.ia_rows; i++) {
-			ah->analogBank6Data[i] =
-			    INI_RA(&ah->iniBank6TPC, i, modesIndex);
-		}
-	}
+
+	for (i = 0; i < ah->iniBank6.ia_rows; i++)
+		ah->analogBank6Data[i] = INI_RA(&ah->iniBank6, i, modesIndex);
 
 	/* Only the 5 or 2 GHz OB/DB need to be set for a mode */
 	if (eepMinorRev >= 2) {
@@ -572,18 +567,12 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 	ar5008_rf_bank_setup(ah->analogBank7Data, &ah->iniBank7, 1);
 
 	/* Write Analog registers */
-	REG_WRITE_RF_ARRAY(&ah->iniBank0, ah->analogBank0Data,
-			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank1, ah->analogBank1Data,
-			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank2, ah->analogBank2Data,
-			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank3, ah->analogBank3Data,
-			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank6TPC, ah->analogBank6Data,
-			   regWrites);
-	REG_WRITE_RF_ARRAY(&ah->iniBank7, ah->analogBank7Data,
-			   regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank0, ah->analogBank0Data, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank1, ah->analogBank1Data, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank2, ah->analogBank2Data, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank3, ah->analogBank3Data, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank6, ah->analogBank6Data, regWrites);
+	REG_WRITE_RF_ARRAY(&ah->iniBank7, ah->analogBank7Data, regWrites);
 
 	return true;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index f053d97..a4654d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -67,12 +67,10 @@ static int ar9002_hw_init_mode_regs(struct ath_hw *ah)
 	} else if (AR_SREV_9100_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9100);
 		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100);
 		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100);
 	} else {
 		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes);
 		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC);
 		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac);
 	}
 
@@ -86,14 +84,11 @@ static int ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3);
 		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7);
 
-		/* Common for AR5416, AR9160 */
-		if (!AR_SREV_9100(ah))
-			INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6);
-
 		/* Common for AR913x, AR9160 */
 		if (!AR_SREV_5416(ah))
-			INIT_INI_ARRAY(&ah->iniBank6TPC,
-				      ar5416Bank6TPC_9100);
+			INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6TPC_9100);
+		else
+			INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6TPC);
 	}
 
 	/* iniAddac needs to be modified for these chips */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 30e62d9..e463c9a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -852,9 +852,7 @@ struct ath_hw {
 	u32 *analogBank2Data;
 	u32 *analogBank3Data;
 	u32 *analogBank6Data;
-	u32 *analogBank6TPCData;
 	u32 *analogBank7Data;
-	u32 *bank6Temp;
 
 	int coverage_class;
 	u32 slottime;
@@ -891,7 +889,6 @@ struct ath_hw {
 	struct ar5416IniArray iniBank2;
 	struct ar5416IniArray iniBank3;
 	struct ar5416IniArray iniBank6;
-	struct ar5416IniArray iniBank6TPC;
 	struct ar5416IniArray iniBank7;
 	struct ar5416IniArray iniAddac;
 	struct ar5416IniArray iniPcieSerdes;
-- 
1.8.0.2

