Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbZHDDON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 23:14:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	ath9k-devel@lists.ath9k.org, stephen.chen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] ath9k: add initial hardware support for ar9271
Date: Mon,  3 Aug 2009 23:14:12 -0400
Message-Id: <1249355652-10031-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249355652-10031-1-git-send-email-lrodriguez@atheros.com>
References: <1249355652-10031-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will finalize this after some driver core changes, for now
we leave this unsupported.

Cc: Stephen Chen <stephen.chen@atheros.com>
Cc: Zhifeng Cai <zhifeng.cai@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c  |  106 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/eeprom.c |  142 +++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/hw.c     |  104 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h     |    2 +
 4 files changed, 314 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d1bbb02..26d8752 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -753,6 +753,98 @@ static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 	}
 }
 
+static void ath9k_hw_9271_pa_cal(struct ath_hw *ah)
+{
+	u32 regVal;
+	unsigned int i;
+	u32 regList [][2] = {
+		{ 0x786c, 0 },
+		{ 0x7854, 0 },
+		{ 0x7820, 0 },
+		{ 0x7824, 0 },
+		{ 0x7868, 0 },
+		{ 0x783c, 0 },
+		{ 0x7838, 0 } ,
+		{ 0x7828, 0 } ,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(regList); i++)
+		regList[i][1] = REG_READ(ah, regList[i][0]);
+
+	regVal = REG_READ(ah, 0x7834);
+	regVal &= (~(0x1));
+	REG_WRITE(ah, 0x7834, regVal);
+	regVal = REG_READ(ah, 0x9808);
+	regVal |= (0x1 << 27);
+	REG_WRITE(ah, 0x9808, regVal);
+
+	/* 786c,b23,1, pwddac=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_TOP3, AR9285_AN_TOP3_PWDDAC, 1);
+	/* 7854, b5,1, pdrxtxbb=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDRXTXBB1, 1);
+	/* 7854, b7,1, pdv2i=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDV2I, 1);
+	/* 7854, b8,1, pddacinterface=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDDACIF, 1);
+	/* 7824,b12,0, offcal=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G2, AR9285_AN_RF2G2_OFFCAL, 0);
+	/* 7838, b1,0, pwddb=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PWDDB, 0);
+	/* 7820,b11,0, enpacal=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_ENPACAL, 0);
+	/* 7820,b25,1, pdpadrv1=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 0);
+	/* 7820,b24,0, pdpadrv2=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1,AR9285_AN_RF2G1_PDPADRV2,0);
+	/* 7820,b23,0, pdpaout=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
+	/* 783c,b14-16,7, padrvgn2tab_0=7 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G8,AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
+	/*
+	 * 7838,b29-31,0, padrvgn1tab_0=0
+	 * does not matter since we turn it off
+	 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7,AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9271_AN_RF2G3_CCOMP, 0xfff);
+
+	/* Set:
+	 * localmode=1,bmode=1,bmoderxtx=1,synthon=1,
+	 * txon=1,paon=1,oscon=1,synthon_force=1
+	 */
+	REG_WRITE(ah, AR9285_AN_TOP2, 0xca0358a0);
+	udelay(30);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9271_AN_RF2G6_OFFS, 0);
+
+	/* find off_6_1; */
+	for (i = 6; i >= 0; i--) {
+		regVal = REG_READ(ah, 0x7834);
+		regVal |= (1 << (20 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+		udelay(1);
+		//regVal = REG_READ(ah, 0x7834);
+		regVal &= (~(0x1 << (20 + i)));
+		regVal |= (MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9)
+			    << (20 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+	}
+
+	/*  Empirical offset correction  */
+#if 0
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9271_AN_RF2G6_OFFS, 0x20);
+#endif
+
+	regVal = REG_READ(ah, 0x7834);
+	regVal |= 0x1;
+	REG_WRITE(ah, 0x7834, regVal);
+	regVal = REG_READ(ah, 0x9808);
+	regVal &= (~(0x1 << 27));
+	REG_WRITE(ah, 0x9808, regVal);
+
+	for (i = 0; i < ARRAY_SIZE(regList); i++)
+		REG_WRITE(ah, regList[i][0], regList[i][1]);
+}
+
 static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 {
 
@@ -869,14 +961,26 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	}
 
+	/* Do NF cal only at longer intervals */
 	if (longcal) {
-		if (AR_SREV_9285_11_OR_LATER(ah))
+		/* Do periodic PAOffset Cal */
+		if (AR_SREV_9271(ah))
+			ath9k_hw_9271_pa_cal(ah);
+		else if (AR_SREV_9285_11_OR_LATER(ah))
 			ath9k_hw_9285_pa_cal(ah);
 
 		if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
 			ath9k_olc_temp_compensation(ah);
+
+		/* Get the value from the previous NF cal and update history buffer */
 		ath9k_hw_getnf(ah, chan);
+
+		/*
+		 * Load the NF from history buffer of the current channel.
+		 * NF is slow time-variant, so it is OK to use a historical value.
+		 */
 		ath9k_hw_loadnf(ah, ah->curchan);
+
 		ath9k_hw_start_nfcal(ah);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index c724c55..4cb64a0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -1237,6 +1237,10 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
 }
 
+/*
+ * Read EEPROM header info and program the device for correct operation
+ * given the channel value.
+ */
 static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
@@ -1313,38 +1317,110 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 		}
 	}
 
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_OB_0, AR9285_AN_RF2G3_OB_0_S, ob[0]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_OB_1, AR9285_AN_RF2G3_OB_1_S, ob[1]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_OB_2, AR9285_AN_RF2G3_OB_2_S, ob[2]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_OB_3, AR9285_AN_RF2G3_OB_3_S, ob[3]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_OB_4, AR9285_AN_RF2G3_OB_4_S, ob[4]);
-
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_DB1_0, AR9285_AN_RF2G3_DB1_0_S, db1[0]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_DB1_1, AR9285_AN_RF2G3_DB1_1_S, db1[1]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
-			AR9285_AN_RF2G3_DB1_2, AR9285_AN_RF2G3_DB1_2_S, db1[2]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB1_3, AR9285_AN_RF2G4_DB1_3_S, db1[3]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB1_4, AR9285_AN_RF2G4_DB1_4_S, db1[4]);
-
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB2_0, AR9285_AN_RF2G4_DB2_0_S, db2[0]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB2_1, AR9285_AN_RF2G4_DB2_1_S, db2[1]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB2_2, AR9285_AN_RF2G4_DB2_2_S, db2[2]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB2_3, AR9285_AN_RF2G4_DB2_3_S, db2[3]);
-	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
-			AR9285_AN_RF2G4_DB2_4, AR9285_AN_RF2G4_DB2_4_S, db2[4]);
+	if (AR_SREV_9271(ah)) {
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9271_AN_RF2G3_OB_cck,
+					  AR9271_AN_RF2G3_OB_cck_S,
+					  ob[0]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9271_AN_RF2G3_OB_psk,
+					  AR9271_AN_RF2G3_OB_psk_S,
+					  ob[1]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9271_AN_RF2G3_OB_qam,
+					  AR9271_AN_RF2G3_OB_qam_S,
+					  ob[2]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9271_AN_RF2G3_DB_1,
+					  AR9271_AN_RF2G3_DB_1_S,
+					  db1[0]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9271_AN_RF2G4_DB_2,
+					  AR9271_AN_RF2G4_DB_2_S,
+					  db2[0]);
+	} else {
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_OB_0,
+					  AR9285_AN_RF2G3_OB_0_S,
+					  ob[0]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_OB_1,
+					  AR9285_AN_RF2G3_OB_1_S,
+					  ob[1]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_OB_2,
+					  AR9285_AN_RF2G3_OB_2_S,
+					  ob[2]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_OB_3,
+					  AR9285_AN_RF2G3_OB_3_S,
+					  ob[3]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_OB_4,
+					  AR9285_AN_RF2G3_OB_4_S,
+					  ob[4]);
+
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_DB1_0,
+					  AR9285_AN_RF2G3_DB1_0_S,
+					  db1[0]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_DB1_1,
+					  AR9285_AN_RF2G3_DB1_1_S,
+					  db1[1]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G3,
+					  AR9285_AN_RF2G3_DB1_2,
+					  AR9285_AN_RF2G3_DB1_2_S,
+					  db1[2]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB1_3,
+					  AR9285_AN_RF2G4_DB1_3_S,
+					  db1[3]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB1_4,
+					  AR9285_AN_RF2G4_DB1_4_S, db1[4]);
+
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB2_0,
+					  AR9285_AN_RF2G4_DB2_0_S,
+					  db2[0]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB2_1,
+					  AR9285_AN_RF2G4_DB2_1_S,
+					  db2[1]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB2_2,
+					  AR9285_AN_RF2G4_DB2_2_S,
+					  db2[2]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB2_3,
+					  AR9285_AN_RF2G4_DB2_3_S,
+					  db2[3]);
+		ath9k_hw_analog_shift_rmw(ah,
+					  AR9285_AN_RF2G4,
+					  AR9285_AN_RF2G4_DB2_4,
+					  AR9285_AN_RF2G4_DB2_4_S,
+					  db2[4]);
+	}
 
 
 	if (AR_SREV_9285_11(ah))
@@ -3989,7 +4065,7 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah)
 	if (AR_SREV_9287(ah)) {
 		ah->eep_map = EEP_MAP_AR9287;
 		ah->eep_ops = &eep_AR9287_ops;
-	} else if (AR_SREV_9285(ah)) {
+	} else if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
 		ah->eep_map = EEP_MAP_4KBITS;
 		ah->eep_ops = &eep_4k_ops;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0d60b35..71a3bcc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -638,6 +638,8 @@ static bool ath9k_hw_macversion_supported(u32 macversion)
 	case AR_SREV_VERSION_9285:
 	case AR_SREV_VERSION_9287:
 		return true;
+	/* Not yet */
+	case AR_SREV_VERSION_9271:
 	default:
 		break;
 	}
@@ -670,6 +672,14 @@ static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
 
 static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
 {
+	if (AR_SREV_9271(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271_1_0,
+			       ARRAY_SIZE(ar9271Modes_9271_1_0), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271_1_0,
+			       ARRAY_SIZE(ar9271Common_9271_1_0), 2);
+		return;
+	}
+
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
 				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
@@ -943,6 +953,10 @@ int ath9k_hw_init(struct ath_hw *ah)
 		ah->supp_cals = IQ_MISMATCH_CAL;
 		ah->is_pciexpress = false;
 	}
+
+	if (AR_SREV_9271(ah))
+		ah->is_pciexpress = false;
+
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 
 	ath9k_hw_init_cal_settings(ah);
@@ -973,7 +987,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 		return r;
 	}
 
-	if (AR_SREV_9285(ah))
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
 	else
 		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
@@ -1234,6 +1248,27 @@ void ath9k_hw_detach(struct ath_hw *ah)
 static void ath9k_hw_override_ini(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
 {
+	u32 val;
+
+	if (AR_SREV_9271(ah)) {
+		/*
+		 * Enable spectral scan to solution for issues with stuck
+		 * beacons on AR9271 1.0. The beacon stuck issue is not seeon on
+		 * AR9271 1.1
+		 */
+		if (AR_SREV_9271_10(ah)) {
+			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) | AR_PHY_SPECTRAL_SCAN_ENABLE;
+			REG_WRITE(ah, AR_PHY_SPECTRAL_SCAN, val);
+		}
+		else if (AR_SREV_9271_11(ah))
+			/*
+			 * change AR_PHY_RF_CTL3 setting to fix MAC issue
+			 * present on AR9271 1.1
+			 */
+			REG_WRITE(ah, AR_PHY_RF_CTL3, 0x3a020001);
+		return;
+	}
+
 	/*
 	 * Set the RX_ABORT and RX_DIS and clear if off only after
 	 * RXE is set for MAC. This prevents frames with corrupted
@@ -1245,7 +1280,10 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 	if (!AR_SREV_5416_20_OR_LATER(ah) ||
 	    AR_SREV_9280_10_OR_LATER(ah))
 		return;
-
+	/*
+	 * Disable BB clock gating
+	 * Necessary to avoid issues on AR5416 2.0
+	 */
 	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
 }
 
@@ -1477,23 +1515,48 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	u32 regval;
 
+	/*
+	 * set AHB_MODE not to do cacheline prefetches
+	*/
 	regval = REG_READ(ah, AR_AHB_MODE);
 	REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
 
+	/*
+	 * let mac dma reads be in 128 byte chunks
+	 */
 	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
 
+	/*
+	 * Restore TX Trigger Level to its pre-reset value.
+	 * The initial value depends on whether aggregation is enabled, and is
+	 * adjusted whenever underruns are detected.
+	 */
 	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
 
+	/*
+	 * let mac dma writes be in 128 byte chunks
+	 */
 	regval = REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_RXCFG, regval | AR_RXCFG_DMASZ_128B);
 
+	/*
+	 * Setup receive FIFO threshold to hold off TX activities
+	 */
 	REG_WRITE(ah, AR_RXFIFO_CFG, 0x200);
 
+	/*
+	 * reduce the number of usable entries in PCU TXBUF to avoid
+	 * wrap around issues.
+	 */
 	if (AR_SREV_9285(ah)) {
+		/* For AR9285 the number of Fifos are reduced to half.
+		 * So set the usable tx buf size also to half to
+		 * avoid data/delimiter underruns
+		 */
 		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
 			  AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE);
-	} else {
+	} else if (!AR_SREV_9271(ah)) {
 		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
 			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
 	}
@@ -2299,11 +2362,26 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_mark_phy_inactive(ah);
 
+	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
+		REG_WRITE(ah,
+			  AR9271_RESET_POWER_DOWN_CONTROL,
+			  AR9271_RADIO_RF_RST);
+		udelay(50);
+	}
+
 	if (!ath9k_hw_chip_reset(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Chip reset failed\n");
 		return -EINVAL;
 	}
 
+	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
+		ah->htc_reset_init = false;
+		REG_WRITE(ah,
+			  AR9271_RESET_POWER_DOWN_CONTROL,
+			  AR9271_GATE_MAC_CTL);
+		udelay(50);
+	}
+
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
@@ -2439,6 +2517,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
 
+	/*
+	 * For big endian systems turn on swapping for descriptors
+	 */
 	if (AR_SREV_9100(ah)) {
 		u32 mask;
 		mask = REG_READ(ah, AR_CFG);
@@ -2453,8 +2534,12 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
 		}
 	} else {
+		/* Configure AR9271 target WLAN */
+                if (AR_SREV_9271(ah))
+			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
 #ifdef __BIG_ENDIAN
-		REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
+                else
+			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 #endif
 	}
 
@@ -2981,7 +3066,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 	if (ah->config.pcie_waen) {
 		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
 	} else {
-		if (AR_SREV_9285(ah))
+		if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
 		/*
 		 * On AR9280 chips bit 22 of 0x4004 needs to be set to
@@ -3445,10 +3530,17 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
+	/*
+	 * For AR9271 we will temporarilly uses the rx chainmax as read from
+	 * the EEPROM.
+	 */
 	if ((ah->hw_version.devid == AR5416_DEVID_PCI) &&
-	    !(eeval & AR5416_OPFLAGS_11A))
+	    !(eeval & AR5416_OPFLAGS_11A) &&
+	    !(AR_SREV_9271(ah)))
+		/* CB71: GPIO 0 is pulled down to indicate 3 rx chains */
 		pCap->rx_chainmask = ath9k_hw_gpio_get(ah, 0) ? 0x5 : 0x7;
 	else
+		/* Use rx_chainmask from EEPROM. */
 		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
 
 	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9c23db1..d4aaf4f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -419,6 +419,8 @@ struct ath_hw {
 	u32 wlanactive_gpio;
 	u32 ah_flags;
 
+	bool htc_reset_init;
+
 	enum nl80211_iftype opmode;
 	enum ath9k_power_mode power_mode;
 
-- 
1.6.3.3

