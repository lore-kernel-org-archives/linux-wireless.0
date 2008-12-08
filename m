Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23965 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYLHOOM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 09:14:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 06:14:12 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 3/5] ath9k: Adding support for Atheros AR9285 chipset.
Date: Mon, 8 Dec 2008 19:43:48 +0530
Message-ID: <1228745630-6928-3-git-send-email-senthilkumar@atheros.com> (sfid-20081208_151418_542353_A3429A93)
In-Reply-To: <1228745630-6928-2-git-send-email-senthilkumar@atheros.com>
References: <1228745630-6928-1-git-send-email-senthilkumar@atheros.com>
 <1228745630-6928-2-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath9k/calib.c  |   98 ++
 drivers/net/wireless/ath9k/eeprom.c | 1824 +++++++++++++++++++++++++++++------
 drivers/net/wireless/ath9k/hw.c     |   90 ++-
 drivers/net/wireless/ath9k/hw.h     |  135 +++-
 drivers/net/wireless/ath9k/mac.c    |    4 +-
 drivers/net/wireless/ath9k/main.c   |    1 +
 drivers/net/wireless/ath9k/phy.h    |    5 +
 8 files changed, 1826 insertions(+), 332 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 9520aa0..d278135 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -26,6 +26,7 @@
 #define AR9160_DEVID_PCI	0x0027
 #define AR9280_DEVID_PCI	0x0029
 #define AR9280_DEVID_PCIE	0x002a
+#define AR9285_DEVID_PCIE	0x002b
 
 #define AR5416_AR9100_DEVID	0x000b
 
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 51c8a3c..3c7454f 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -818,6 +818,101 @@ bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
 	return true;
 }
 
+static inline void ath9k_hw_9285_pa_cal(struct ath_hal *ah)
+{
+
+	u32 regVal;
+	int i, offset, offs_6_1, offs_0;
+	u32 ccomp_org, reg_field;
+	u32 regList[][2] = {
+		{ 0x786c, 0 },
+		{ 0x7854, 0 },
+		{ 0x7820, 0 },
+		{ 0x7824, 0 },
+		{ 0x7868, 0 },
+		{ 0x783c, 0 },
+		{ 0x7838, 0 },
+	};
+
+	if (AR_SREV_9285_11(ah)) {
+		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
+		udelay(10);
+	}
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
+	REG_RMW_FIELD(ah, AR9285_AN_TOP3, AR9285_AN_TOP3_PWDDAC, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDRXTXBB1, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDV2I, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDDACIF, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G2, AR9285_AN_RF2G2_OFFCAL, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PWDDB, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_ENPACAL, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV2, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G8, AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
+	ccomp_org = MS(REG_READ(ah, AR9285_AN_RF2G6), AR9285_AN_RF2G6_CCOMP);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, 7);
+
+	REG_WRITE(ah, AR9285_AN_TOP2, 0xca0358a0);
+	udelay(30);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, 0);
+
+	for (i = 6; i > 0; i--) {
+		regVal = REG_READ(ah, 0x7834);
+		regVal |= (1 << (19 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+		udelay(1);
+		regVal = REG_READ(ah, 0x7834);
+		regVal &= (~(0x1 << (19 + i)));
+		reg_field = MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9);
+		regVal |= (reg_field << (19 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+	}
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, 1);
+	udelay(1);
+	reg_field = MS(REG_READ(ah, AR9285_AN_RF2G9), AR9285_AN_RXTXBB1_SPARE9);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, reg_field);
+	offs_6_1 = MS(REG_READ(ah, AR9285_AN_RF2G6), AR9285_AN_RF2G6_OFFS);
+	offs_0   = MS(REG_READ(ah, AR9285_AN_RF2G3), AR9285_AN_RF2G3_PDVCCOMP);
+
+	offset = (offs_6_1<<1) | offs_0;
+	offset = offset - 0;
+	offs_6_1 = offset>>1;
+	offs_0 = offset & 1;
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, offs_6_1);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, offs_0);
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
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, ccomp_org);
+
+	if (AR_SREV_9285_11(ah))
+		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
+
+}
+
 bool ath9k_hw_init_cal(struct ath_hal *ah,
 		       struct ath9k_channel *chan)
 {
@@ -835,6 +930,9 @@ bool ath9k_hw_init_cal(struct ath_hal *ah,
 		return false;
 	}
 
+	if (AR_SREV_9285(ah) && AR_SREV_9285_11_OR_LATER(ah))
+		ath9k_hw_9285_pa_cal(ah);
+
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
 		  AR_PHY_AGC_CONTROL_NF);
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index e180c90..d4e51dd 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -140,61 +140,97 @@ static inline bool ath9k_hw_nvram_read(struct ath_hal *ah, u32 off, u16 *data)
 		return ath9k_hw_eeprom_read(ah, off, data);
 }
 
-static bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
+static bool ath9k_hw_fill_4k_eeprom(struct ath_hal *ah)
 {
+#define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
+	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
 	u16 *eep_data;
-	int addr, ar5416_eep_start_loc = 0;
+	int addr, eep_start_loc = 0;
+
+	eep_start_loc = 64;
 
 	if (!ath9k_hw_use_flash(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"Reading from EEPROM, not flash\n");
-		ar5416_eep_start_loc = 256;
 	}
 
-	if (AR_SREV_9100(ah))
-		ar5416_eep_start_loc = 256;
+	eep_data = (u16 *)eep;
+
+	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
+		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			       "Unable to read eeprom region \n");
+			return false;
+		}
+		eep_data++;
+	}
+	return true;
+#undef SIZE_EEPROM_4K
+}
+
+static bool ath9k_hw_fill_def_eeprom(struct ath_hal *ah)
+{
+#define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	u16 *eep_data;
+	int addr, ar5416_eep_start_loc = 0x100;
 
 	eep_data = (u16 *)eep;
 
-	for (addr = 0; addr < sizeof(struct ar5416_eeprom) / sizeof(u16); addr++) {
+	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Unable to read eeprom region \n");
+				"Unable to read eeprom region\n");
 			return false;
 		}
 		eep_data++;
 	}
 	return true;
+#undef SIZE_EEPROM_DEF
+}
+
+bool (*ath9k_fill_eeprom[]) (struct ath_hal *) = {
+	ath9k_hw_fill_def_eeprom,
+	ath9k_hw_fill_4k_eeprom
+};
+
+static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_fill_eeprom[ahp->ah_eep_map](ah);
 }
 
-static int ath9k_hw_check_eeprom(struct ath_hal *ah)
+static int ath9k_hw_check_def_eeprom(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep =
-		(struct ar5416_eeprom *) &ahp->ah_eeprom;
+	struct ar5416_eeprom_def *eep =
+		(struct ar5416_eeprom_def *) &ahp->ah_eeprom.def;
 	u16 *eepdata, temp, magic, magic2;
 	u32 sum = 0, el;
 	bool need_swap = false;
 	int i, addr, size;
 
+	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
+				 &magic)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"Reading Magic # failed\n");
+		return false;
+	}
+
 	if (!ath9k_hw_use_flash(ah)) {
-		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
-					 &magic)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Reading Magic # failed\n");
-			return false;
-		}
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "Read Magic = 0x%04X\n", magic);
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
 
 			if (magic2 == AR5416_EEPROM_MAGIC) {
-				size = sizeof(struct ar5416_eeprom);
+				size = sizeof(struct ar5416_eeprom_def);
 				need_swap = true;
 				eepdata = (u16 *) (&ahp->ah_eeprom);
 
@@ -223,12 +259,12 @@ static int ath9k_hw_check_eeprom(struct ath_hal *ah)
 		need_swap ? "True" : "False");
 
 	if (need_swap)
-		el = swab16(ahp->ah_eeprom.baseEepHeader.length);
+		el = swab16(ahp->ah_eeprom.def.baseEepHeader.length);
 	else
-		el = ahp->ah_eeprom.baseEepHeader.length;
+		el = ahp->ah_eeprom.def.baseEepHeader.length;
 
-	if (el > sizeof(struct ar5416_eeprom))
-		el = sizeof(struct ar5416_eeprom) / sizeof(u16);
+	if (el > sizeof(struct ar5416_eeprom_def))
+		el = sizeof(struct ar5416_eeprom_def) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
 
@@ -297,6 +333,145 @@ static int ath9k_hw_check_eeprom(struct ath_hal *ah)
 	return 0;
 }
 
+static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
+{
+#define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_4k *eep =
+		(struct ar5416_eeprom_4k *) &ahp->ah_eeprom.map4k;
+	u16 *eepdata, temp, magic, magic2;
+	u32 sum = 0, el;
+	bool need_swap = false;
+	int i, addr;
+
+
+	if (!ath9k_hw_use_flash(ah)) {
+
+		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
+					 &magic)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Reading Magic # failed\n");
+			return false;
+		}
+
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Read Magic = 0x%04X\n", magic);
+
+		if (magic != AR5416_EEPROM_MAGIC) {
+			magic2 = swab16(magic);
+
+			if (magic2 == AR5416_EEPROM_MAGIC) {
+				need_swap = true;
+				eepdata = (u16 *) (&ahp->ah_eeprom);
+
+				for (addr = 0; addr < EEPROM_4K_SIZE; addr++) {
+					temp = swab16(*eepdata);
+					*eepdata = temp;
+					eepdata++;
+
+					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+						"0x%04X  ", *eepdata);
+
+					if (((addr + 1) % 6) == 0)
+						DPRINTF(ah->ah_sc,
+							ATH_DBG_EEPROM, "\n");
+				}
+			} else {
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+					"Invalid EEPROM Magic. "
+					"endianness mismatch.\n");
+				return -EINVAL;
+			}
+		}
+	}
+
+	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n",
+		need_swap ? "True" : "False");
+
+	if (need_swap)
+		el = swab16(ahp->ah_eeprom.map4k.baseEepHeader.length);
+	else
+		el = ahp->ah_eeprom.map4k.baseEepHeader.length;
+
+	if (el > sizeof(struct ar5416_eeprom_def))
+		el = sizeof(struct ar5416_eeprom_4k) / sizeof(u16);
+	else
+		el = el / sizeof(u16);
+
+	eepdata = (u16 *)(&ahp->ah_eeprom);
+
+	for (i = 0; i < el; i++)
+		sum ^= *eepdata++;
+
+	if (need_swap) {
+		u32 integer;
+		u16 word;
+
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"EEPROM Endianness is not native.. Changing \n");
+
+		word = swab16(eep->baseEepHeader.length);
+		eep->baseEepHeader.length = word;
+
+		word = swab16(eep->baseEepHeader.checksum);
+		eep->baseEepHeader.checksum = word;
+
+		word = swab16(eep->baseEepHeader.version);
+		eep->baseEepHeader.version = word;
+
+		word = swab16(eep->baseEepHeader.regDmn[0]);
+		eep->baseEepHeader.regDmn[0] = word;
+
+		word = swab16(eep->baseEepHeader.regDmn[1]);
+		eep->baseEepHeader.regDmn[1] = word;
+
+		word = swab16(eep->baseEepHeader.rfSilent);
+		eep->baseEepHeader.rfSilent = word;
+
+		word = swab16(eep->baseEepHeader.blueToothOptions);
+		eep->baseEepHeader.blueToothOptions = word;
+
+		word = swab16(eep->baseEepHeader.deviceCap);
+		eep->baseEepHeader.deviceCap = word;
+
+		integer = swab32(eep->modalHeader.antCtrlCommon);
+		eep->modalHeader.antCtrlCommon = integer;
+
+		for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+			integer = swab32(eep->modalHeader.antCtrlChain[i]);
+			eep->modalHeader.antCtrlChain[i] = integer;
+		}
+
+		for (i = 0; i < AR5416_EEPROM_MODAL_SPURS; i++) {
+			word = swab16(eep->modalHeader.spurChans[i].spurChan);
+			eep->modalHeader.spurChans[i].spurChan = word;
+		}
+	}
+
+	if (sum != 0xffff || ar5416_get_eep4k_ver(ahp) != AR5416_EEP_VER ||
+	    ar5416_get_eep4k_rev(ahp) < AR5416_EEP_NO_BACK_VER) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			sum, ar5416_get_eep4k_ver(ahp));
+		return -EINVAL;
+	}
+
+	return 0;
+#undef EEPROM_4K_SIZE
+}
+
+int (*ath9k_check_eeprom[]) (struct ath_hal *) = {
+	ath9k_hw_check_def_eeprom,
+	ath9k_hw_check_4k_eeprom
+};
+
+static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_check_eeprom[ahp->ah_eep_map](ah);
+}
+
 static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 					   u8 *pVpdList, u16 numIntercepts,
 					   u8 *pRetVpdList)
@@ -326,7 +501,175 @@ static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 	return true;
 }
 
-static void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
+static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hal *ah,
+				struct ath9k_channel *chan,
+				struct cal_data_per_freq_4k *pRawDataSet,
+				u8 *bChans, u16 availPiers,
+				u16 tPdGainOverlap, int16_t *pMinCalPower,
+				u16 *pPdGainBoundaries, u8 *pPDADCValues,
+				u16 numXpdGains)
+{
+#define TMP_VAL_VPD_TABLE \
+	((vpdTableI[i][sizeCurrVpdTable - 1] + (ss - maxIndex + 1) * vpdStep));
+	int i, j, k;
+	int16_t ss;
+	u16 idxL = 0, idxR = 0, numPiers;
+	static u8 vpdTableL[AR5416_EEP4K_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableR[AR5416_EEP4K_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableI[AR5416_EEP4K_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+
+	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
+	u8 minPwrT4[AR5416_EEP4K_NUM_PD_GAINS];
+	u8 maxPwrT4[AR5416_EEP4K_NUM_PD_GAINS];
+	int16_t vpdStep;
+	int16_t tmpVal;
+	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
+	bool match;
+	int16_t minDelta = 0;
+	struct chan_centers centers;
+#define PD_GAIN_BOUNDARY_DEFAULT 58;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	for (numPiers = 0; numPiers < availPiers; numPiers++) {
+		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
+			break;
+	}
+
+	match = ath9k_hw_get_lower_upper_index(
+					(u8)FREQ2FBIN(centers.synth_center,
+					IS_CHAN_2GHZ(chan)), bChans, numPiers,
+					&idxL, &idxR);
+
+	if (match) {
+		for (i = 0; i < numXpdGains; i++) {
+			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
+			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+					pRawDataSet[idxL].pwrPdg[i],
+					pRawDataSet[idxL].vpdPdg[i],
+					AR5416_EEP4K_PD_GAIN_ICEPTS,
+					vpdTableI[i]);
+		}
+	} else {
+		for (i = 0; i < numXpdGains; i++) {
+			pVpdL = pRawDataSet[idxL].vpdPdg[i];
+			pPwrL = pRawDataSet[idxL].pwrPdg[i];
+			pVpdR = pRawDataSet[idxR].vpdPdg[i];
+			pPwrR = pRawDataSet[idxR].pwrPdg[i];
+
+			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
+
+			maxPwrT4[i] =
+				min(pPwrL[AR5416_EEP4K_PD_GAIN_ICEPTS - 1],
+				    pPwrR[AR5416_EEP4K_PD_GAIN_ICEPTS - 1]);
+
+
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						pPwrL, pVpdL,
+						AR5416_EEP4K_PD_GAIN_ICEPTS,
+						vpdTableL[i]);
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						pPwrR, pVpdR,
+						AR5416_EEP4K_PD_GAIN_ICEPTS,
+						vpdTableR[i]);
+
+			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
+				vpdTableI[i][j] =
+					(u8)(ath9k_hw_interpolate((u16)
+					     FREQ2FBIN(centers.
+						       synth_center,
+						       IS_CHAN_2GHZ
+						       (chan)),
+					     bChans[idxL], bChans[idxR],
+					     vpdTableL[i][j], vpdTableR[i][j]));
+			}
+		}
+	}
+
+	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
+
+	k = 0;
+
+	for (i = 0; i < numXpdGains; i++) {
+		if (i == (numXpdGains - 1))
+			pPdGainBoundaries[i] =
+				(u16)(maxPwrT4[i] / 2);
+		else
+			pPdGainBoundaries[i] =
+				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
+
+		pPdGainBoundaries[i] =
+			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
+
+		if ((i == 0) && !AR_SREV_5416_V20_OR_LATER(ah)) {
+			minDelta = pPdGainBoundaries[0] - 23;
+			pPdGainBoundaries[0] = 23;
+		} else {
+			minDelta = 0;
+		}
+
+		if (i == 0) {
+			if (AR_SREV_9280_10_OR_LATER(ah))
+				ss = (int16_t)(0 - (minPwrT4[i] / 2));
+			else
+				ss = 0;
+		} else {
+			ss = (int16_t)((pPdGainBoundaries[i - 1] -
+					(minPwrT4[i] / 2)) -
+				       tPdGainOverlap + 1 + minDelta);
+		}
+		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
+		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
+			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
+			ss++;
+		}
+
+		sizeCurrVpdTable = (u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
+		tgtIndex = (u8)(pPdGainBoundaries[i] + tPdGainOverlap -
+				(minPwrT4[i] / 2));
+		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
+			tgtIndex : sizeCurrVpdTable;
+
+		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1)))
+			pPDADCValues[k++] = vpdTableI[i][ss++];
+
+		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
+				    vpdTableI[i][sizeCurrVpdTable - 2]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
+		if (tgtIndex > maxIndex) {
+			while ((ss <= tgtIndex) &&
+			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
+				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
+							 255 : tmpVal);
+				ss++;
+			}
+		}
+	}
+
+	while (i < AR5416_EEP4K_PD_GAINS_IN_MASK) {
+		pPdGainBoundaries[i] = PD_GAIN_BOUNDARY_DEFAULT;
+		i++;
+	}
+
+	while (k < AR5416_NUM_PDADC_VALUES) {
+		pPDADCValues[k] = pPDADCValues[k - 1];
+		k++;
+	}
+
+	return;
+#undef TMP_VAL_VPD_TABLE
+}
+
+static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hal *ah,
 				struct ath9k_channel *chan,
 				struct cal_data_per_freq *pRawDataSet,
 				u8 *bChans, u16 availPiers,
@@ -603,12 +946,12 @@ static void ath9k_hw_get_target_powers(struct ath_hal *ah,
 
 static u16 ath9k_hw_get_max_edge_power(u16 freq,
 				       struct cal_ctl_edges *pRdEdgesPower,
-				       bool is2GHz)
+				       bool is2GHz, int num_band_edges)
 {
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	int i;
 
-	for (i = 0; (i < AR5416_NUM_BAND_EDGES) &&
+	for (i = 0; (i < num_band_edges) &&
 		     (pRdEdgesPower[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
 		if (freq == ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel, is2GHz)) {
 			twiceMaxEdgePower = pRdEdgesPower[i].tPower;
@@ -629,207 +972,269 @@ static u16 ath9k_hw_get_max_edge_power(u16 freq,
 	return twiceMaxEdgePower;
 }
 
-int ath9k_hw_set_txpower(struct ath_hal *ah,
-			 struct ath9k_channel *chan,
-			 u16 cfgCtl,
-			 u8 twiceAntennaReduction,
-			 u8 twiceMaxRegulatoryPower,
-			 u8 powerLimit)
+static bool ath9k_hw_set_def_power_cal_table(struct ath_hal *ah,
+				  struct ath9k_channel *chan,
+				  int16_t *pTxPowerIndexOffset)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *pEepData = &ahp->ah_eeprom;
-	struct modal_eep_header *pModal =
-		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
-	int16_t ratesArray[Ar5416RateSize];
-	int16_t txPowerIndexOffset = 0;
-	u8 ht40PowerIncForPdadc = 2;
-	int i;
+	struct ar5416_eeprom_def *pEepData = &ahp->ah_eeprom.def;
+	struct cal_data_per_freq *pRawDataset;
+	u8 *pCalBChans = NULL;
+	u16 pdGainOverlap_t2;
+	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
+	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
+	u16 numPiers, i, j;
+	int16_t tMinCalPower;
+	u16 numXpdGain, xpdMask;
+	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
+	u32 reg32, regOffset, regChainOffset;
+	int16_t modalIdx;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
+	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
+	xpdMask = pEepData->modalHeader[modalIdx].xpdGain;
 
 	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
 	    AR5416_EEP_MINOR_VER_2) {
-		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
-	}
-
-	if (!ath9k_hw_set_power_per_rate_table(ah, chan,
-					       &ratesArray[0], cfgCtl,
-					       twiceAntennaReduction,
-					       twiceMaxRegulatoryPower,
-					       powerLimit)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"ath9k_hw_set_txpower: unable to set "
-			"tx power per rate table\n");
-		return -EIO;
+		pdGainOverlap_t2 =
+			pEepData->modalHeader[modalIdx].pdGainOverlap;
+	} else {
+		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
+					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
 	}
 
-	if (!ath9k_hw_set_power_cal_table(ah, chan, &txPowerIndexOffset)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			 "ath9k_hw_set_txpower: unable to set power table\n");
-		return -EIO;
+	if (IS_CHAN_2GHZ(chan)) {
+		pCalBChans = pEepData->calFreqPier2G;
+		numPiers = AR5416_NUM_2G_CAL_PIERS;
+	} else {
+		pCalBChans = pEepData->calFreqPier5G;
+		numPiers = AR5416_NUM_5G_CAL_PIERS;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
-		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
-		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
-			ratesArray[i] = AR5416_MAX_RATE_POWER;
-	}
+	numXpdGain = 0;
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		for (i = 0; i < Ar5416RateSize; i++)
-			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
+	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
+			if (numXpdGain >= AR5416_NUM_PD_GAINS)
+				break;
+			xpdGainValues[numXpdGain] =
+				(u16)(AR5416_PD_GAINS_IN_MASK - i);
+			numXpdGain++;
+		}
 	}
 
-	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
-		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
-		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
-		  | ATH9K_POW_SM(ratesArray[rate9mb], 8)
-		  | ATH9K_POW_SM(ratesArray[rate6mb], 0));
-	REG_WRITE(ah, AR_PHY_POWER_TX_RATE2,
-		  ATH9K_POW_SM(ratesArray[rate54mb], 24)
-		  | ATH9K_POW_SM(ratesArray[rate48mb], 16)
-		  | ATH9K_POW_SM(ratesArray[rate36mb], 8)
-		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
+		      (numXpdGain - 1) & 0x3);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
+		      xpdGainValues[0]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
+		      xpdGainValues[1]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
+		      xpdGainValues[2]);
 
-	if (IS_CHAN_2GHZ(chan)) {
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
-			  ATH9K_POW_SM(ratesArray[rate2s], 24)
-			  | ATH9K_POW_SM(ratesArray[rate2l], 16)
-			  | ATH9K_POW_SM(ratesArray[rateXr], 8)
-			  | ATH9K_POW_SM(ratesArray[rate1l], 0));
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
-			  ATH9K_POW_SM(ratesArray[rate11s], 24)
-			  | ATH9K_POW_SM(ratesArray[rate11l], 16)
-			  | ATH9K_POW_SM(ratesArray[rate5_5s], 8)
-			  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
-	}
+	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		if (AR_SREV_5416_V20_OR_LATER(ah) &&
+		    (ahp->ah_rxchainmask == 5 || ahp->ah_txchainmask == 5) &&
+		    (i != 0)) {
+			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
+		} else
+			regChainOffset = i * 0x1000;
 
-	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
-		  ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
-		  | ATH9K_POW_SM(ratesArray[rateHt20_2], 16)
-		  | ATH9K_POW_SM(ratesArray[rateHt20_1], 8)
-		  | ATH9K_POW_SM(ratesArray[rateHt20_0], 0));
-	REG_WRITE(ah, AR_PHY_POWER_TX_RATE6,
-		  ATH9K_POW_SM(ratesArray[rateHt20_7], 24)
-		  | ATH9K_POW_SM(ratesArray[rateHt20_6], 16)
-		  | ATH9K_POW_SM(ratesArray[rateHt20_5], 8)
-		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
+		if (pEepData->baseEepHeader.txMask & (1 << i)) {
+			if (IS_CHAN_2GHZ(chan))
+				pRawDataset = pEepData->calPierData2G[i];
+			else
+				pRawDataset = pEepData->calPierData5G[i];
 
-	if (IS_CHAN_HT40(chan)) {
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
-			  ATH9K_POW_SM(ratesArray[rateHt40_3] +
-				       ht40PowerIncForPdadc, 24)
-			  | ATH9K_POW_SM(ratesArray[rateHt40_2] +
-					 ht40PowerIncForPdadc, 16)
-			  | ATH9K_POW_SM(ratesArray[rateHt40_1] +
-					 ht40PowerIncForPdadc, 8)
-			  | ATH9K_POW_SM(ratesArray[rateHt40_0] +
-					 ht40PowerIncForPdadc, 0));
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
-			  ATH9K_POW_SM(ratesArray[rateHt40_7] +
-				       ht40PowerIncForPdadc, 24)
-			  | ATH9K_POW_SM(ratesArray[rateHt40_6] +
-					 ht40PowerIncForPdadc, 16)
-			  | ATH9K_POW_SM(ratesArray[rateHt40_5] +
-					 ht40PowerIncForPdadc, 8)
-			  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
-					 ht40PowerIncForPdadc, 0));
+			ath9k_hw_get_def_gain_boundaries_pdadcs(ah, chan,
+					    pRawDataset, pCalBChans,
+					    numPiers, pdGainOverlap_t2,
+					    &tMinCalPower, gainBoundaries,
+					    pdadcValues, numXpdGain);
 
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
-			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
-			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
-			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
-			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
-	}
+			if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
+				REG_WRITE(ah,
+					  AR_PHY_TPCRG5 + regChainOffset,
+					  SM(pdGainOverlap_t2,
+					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
+					  | SM(gainBoundaries[0],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
+					  | SM(gainBoundaries[1],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
+					  | SM(gainBoundaries[2],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
+					  | SM(gainBoundaries[3],
+				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
+			}
 
-	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
-		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
-		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
+			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
+			for (j = 0; j < 32; j++) {
+				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
+					((pdadcValues[4 * j + 1] & 0xFF) << 8) |
+					((pdadcValues[4 * j + 2] & 0xFF) << 16)|
+					((pdadcValues[4 * j + 3] & 0xFF) << 24);
+				REG_WRITE(ah, regOffset, reg32);
 
-	i = rate6mb;
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+					"PDADC (%d,%4x): %4.4x %8.8x\n",
+					i, regChainOffset, regOffset,
+					reg32);
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+					"PDADC: Chain %d | PDADC %3d "
+					"Value %3d | PDADC %3d Value %3d | "
+					"PDADC %3d Value %3d | PDADC %3d "
+					"Value %3d |\n",
+					i, 4 * j, pdadcValues[4 * j],
+					4 * j + 1, pdadcValues[4 * j + 1],
+					4 * j + 2, pdadcValues[4 * j + 2],
+					4 * j + 3,
+					pdadcValues[4 * j + 3]);
 
-	if (IS_CHAN_HT40(chan))
-		i = rateHt40_0;
-	else if (IS_CHAN_HT20(chan))
-		i = rateHt20_0;
+				regOffset += 4;
+			}
+		}
+	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->ah_maxPowerLevel =
-			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
-	else
-		ah->ah_maxPowerLevel = ratesArray[i];
+	*pTxPowerIndexOffset = 0;
 
-	return 0;
+	return true;
 }
 
-void ath9k_hw_set_addac(struct ath_hal *ah, struct ath9k_channel *chan)
+static bool ath9k_hw_set_4k_power_cal_table(struct ath_hal *ah,
+				  struct ath9k_channel *chan,
+				  int16_t *pTxPowerIndexOffset)
 {
-	struct modal_eep_header *pModal;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
-	u8 biaslevel;
+	struct ar5416_eeprom_4k *pEepData = &ahp->ah_eeprom.map4k;
+	struct cal_data_per_freq_4k *pRawDataset;
+	u8 *pCalBChans = NULL;
+	u16 pdGainOverlap_t2;
+	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
+	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
+	u16 numPiers, i, j;
+	int16_t tMinCalPower;
+	u16 numXpdGain, xpdMask;
+	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
+	u32 reg32, regOffset, regChainOffset;
 
-	if (ah->ah_macVersion != AR_SREV_VERSION_9160)
-		return;
+	xpdMask = pEepData->modalHeader.xpdGain;
 
-	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
-		return;
+	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+	    AR5416_EEP_MINOR_VER_2) {
+		pdGainOverlap_t2 =
+			pEepData->modalHeader.pdGainOverlap;
+	} else {
+		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
+					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
+	}
 
-	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
+	pCalBChans = pEepData->calFreqPier2G;
+	numPiers = AR5416_NUM_2G_CAL_PIERS;
 
-	if (pModal->xpaBiasLvl != 0xff) {
-		biaslevel = pModal->xpaBiasLvl;
-	} else {
-		u16 resetFreqBin, freqBin, freqCount = 0;
-		struct chan_centers centers;
+	numXpdGain = 0;
 
-		ath9k_hw_get_channel_centers(ah, chan, &centers);
+	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
+			if (numXpdGain >= AR5416_NUM_PD_GAINS)
+				break;
+			xpdGainValues[numXpdGain] =
+				(u16)(AR5416_PD_GAINS_IN_MASK - i);
+			numXpdGain++;
+		}
+	}
 
-		resetFreqBin = FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan));
-		freqBin = pModal->xpaBiasLvlFreq[0] & 0xff;
-		biaslevel = (u8) (pModal->xpaBiasLvlFreq[0] >> 14);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
+		      (numXpdGain - 1) & 0x3);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
+		      xpdGainValues[0]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
+		      xpdGainValues[1]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
+		      xpdGainValues[2]);
 
-		freqCount++;
+	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		if (AR_SREV_5416_V20_OR_LATER(ah) &&
+		    (ahp->ah_rxchainmask == 5 || ahp->ah_txchainmask == 5) &&
+		    (i != 0)) {
+			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
+		} else
+			regChainOffset = i * 0x1000;
 
-		while (freqCount < 3) {
-			if (pModal->xpaBiasLvlFreq[freqCount] == 0x0)
-				break;
+		if (pEepData->baseEepHeader.txMask & (1 << i)) {
+			pRawDataset = pEepData->calPierData2G[i];
 
-			freqBin = pModal->xpaBiasLvlFreq[freqCount] & 0xff;
-			if (resetFreqBin >= freqBin) {
-				biaslevel = (u8)(pModal->xpaBiasLvlFreq[freqCount] >> 14);
-			} else {
-				break;
+			ath9k_hw_get_4k_gain_boundaries_pdadcs(ah, chan,
+					    pRawDataset, pCalBChans,
+					    numPiers, pdGainOverlap_t2,
+					    &tMinCalPower, gainBoundaries,
+					    pdadcValues, numXpdGain);
+
+			if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
+				REG_WRITE(ah, AR_PHY_TPCRG5 + regChainOffset,
+					  SM(pdGainOverlap_t2,
+					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
+					  | SM(gainBoundaries[0],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
+					  | SM(gainBoundaries[1],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
+					  | SM(gainBoundaries[2],
+					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
+					  | SM(gainBoundaries[3],
+				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
+			}
+
+			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
+			for (j = 0; j < 32; j++) {
+				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
+					((pdadcValues[4 * j + 1] & 0xFF) << 8) |
+					((pdadcValues[4 * j + 2] & 0xFF) << 16)|
+					((pdadcValues[4 * j + 3] & 0xFF) << 24);
+				REG_WRITE(ah, regOffset, reg32);
+
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+					"PDADC (%d,%4x): %4.4x %8.8x\n",
+					i, regChainOffset, regOffset,
+					reg32);
+				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
+					"PDADC: Chain %d | "
+					"PDADC %3d Value %3d | "
+					"PDADC %3d Value %3d | "
+					"PDADC %3d Value %3d | "
+					"PDADC %3d Value %3d |\n",
+					i, 4 * j, pdadcValues[4 * j],
+					4 * j + 1, pdadcValues[4 * j + 1],
+					4 * j + 2, pdadcValues[4 * j + 2],
+					4 * j + 3,
+					pdadcValues[4 * j + 3]);
+
+				regOffset += 4;
 			}
-			freqCount++;
 		}
 	}
 
-	if (IS_CHAN_2GHZ(chan)) {
-		INI_RA(&ahp->ah_iniAddac, 7, 1) =
-			(INI_RA(&ahp->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel	<< 3;
-	} else {
-		INI_RA(&ahp->ah_iniAddac, 6, 1) =
-			(INI_RA(&ahp->ah_iniAddac, 6, 1) & (~0xc0)) | biaslevel	<< 6;
-	}
+	*pTxPowerIndexOffset = 0;
+
+	return true;
 }
 
-bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
+bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 				       struct ath9k_channel *chan,
 				       int16_t *ratesArray,
 				       u16 cfgCtl,
-				       u8 AntennaReduction,
-				       u8 twiceMaxRegulatoryPower,
-				       u8 powerLimit)
+				       u16 AntennaReduction,
+				       u16 twiceMaxRegulatoryPower,
+				       u16 powerLimit)
 {
+#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
+
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *pEepData = &ahp->ah_eeprom;
-	u8 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	struct ar5416_eeprom_def *pEepData = &ahp->ah_eeprom.def;
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 
 	int i;
-	int8_t twiceLargestAntenna;
+	int16_t twiceLargestAntenna;
 	struct cal_ctl_data *rep;
 	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
 		0, { 0, 0, 0, 0}
@@ -841,7 +1246,7 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 	struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
 		0, {0, 0, 0, 0}
 	};
-	u8 scaledPower = 0, minCtlPower, maxRegAllowedPower;
+	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
 	u16 ctlModesFor11a[] =
 		{ CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40 };
 	u16 ctlModesFor11g[] =
@@ -851,7 +1256,7 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 	u16 numCtlModes, *pCtlMode, ctlMode, freq;
 	struct chan_centers centers;
 	int tx_chainmask;
-	u8 twiceMinEdgePower;
+	u16 twiceMinEdgePower;
 
 	tx_chainmask = ahp->ah_txchainmask;
 
@@ -867,7 +1272,8 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				  pEepData->modalHeader
 				  [IS_CHAN_2GHZ(chan)].antennaGainCh[2]);
 
-	twiceLargestAntenna = (int8_t)min(AntennaReduction - twiceLargestAntenna, 0);
+	twiceLargestAntenna = (int16_t)min(AntennaReduction -
+					   twiceLargestAntenna, 0);
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
 
@@ -882,16 +1288,14 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 	case 1:
 		break;
 	case 2:
-		scaledPower -=
-			pEepData->modalHeader[IS_CHAN_2GHZ(chan)].pwrDecreaseFor2Chain;
+		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
 		break;
 	case 3:
-		scaledPower -=
-			pEepData->modalHeader[IS_CHAN_2GHZ(chan)].pwrDecreaseFor3Chain;
+		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
 		break;
 	}
 
-	scaledPower = max(0, (int32_t) scaledPower);
+	scaledPower = max((u16)0, scaledPower);
 
 	if (IS_CHAN_2GHZ(chan)) {
 		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
@@ -990,7 +1394,7 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 
 				twiceMinEdgePower = ath9k_hw_get_max_edge_power(freq,
 				rep->ctlEdges[ar5416_get_ntxchains(tx_chainmask) - 1],
-				IS_CHAN_2GHZ(chan));
+				IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
 
 				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 					"    MATCH-EE_IDX %d: ch %d is2 %d "
@@ -1021,7 +1425,7 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 		case CTL_11B:
 			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x); i++) {
 				targetPowerCck.tPow2x[i] =
-					min(targetPowerCck.tPow2x[i],
+					min((u16)targetPowerCck.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
@@ -1029,7 +1433,7 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 		case CTL_11G:
 			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x); i++) {
 				targetPowerOfdm.tPow2x[i] =
-					min(targetPowerOfdm.tPow2x[i],
+					min((u16)targetPowerOfdm.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
@@ -1037,24 +1441,26 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 		case CTL_2GHT20:
 			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++) {
 				targetPowerHt20.tPow2x[i] =
-					min(targetPowerHt20.tPow2x[i],
+					min((u16)targetPowerHt20.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
 		case CTL_11B_EXT:
-			targetPowerCckExt.tPow2x[0] =
-				min(targetPowerCckExt.tPow2x[0], minCtlPower);
+			targetPowerCckExt.tPow2x[0] = min((u16)
+					targetPowerCckExt.tPow2x[0],
+					minCtlPower);
 			break;
 		case CTL_11A_EXT:
 		case CTL_11G_EXT:
-			targetPowerOfdmExt.tPow2x[0] =
-				min(targetPowerOfdmExt.tPow2x[0], minCtlPower);
+			targetPowerOfdmExt.tPow2x[0] = min((u16)
+					targetPowerOfdmExt.tPow2x[0],
+					minCtlPower);
 			break;
 		case CTL_5GHT40:
 		case CTL_2GHT40:
 			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
 				targetPowerHt40.tPow2x[i] =
-					min(targetPowerHt40.tPow2x[i],
+					min((u16)targetPowerHt40.tPow2x[i],
 					    minCtlPower);
 			}
 			break;
@@ -1101,139 +1507,623 @@ bool ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 	return true;
 }
 
-bool ath9k_hw_set_power_cal_table(struct ath_hal *ah,
-				  struct ath9k_channel *chan,
-				  int16_t *pTxPowerIndexOffset)
+bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
+				       struct ath9k_channel *chan,
+				       int16_t *ratesArray,
+				       u16 cfgCtl,
+				       u16 AntennaReduction,
+				       u16 twiceMaxRegulatoryPower,
+				       u16 powerLimit)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *pEepData = &ahp->ah_eeprom;
-	struct cal_data_per_freq *pRawDataset;
-	u8 *pCalBChans = NULL;
-	u16 pdGainOverlap_t2;
-	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
-	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
-	u16 numPiers, i, j;
-	int16_t tMinCalPower;
-	u16 numXpdGain, xpdMask;
-	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = { 0, 0, 0, 0 };
-	u32 reg32, regOffset, regChainOffset;
-	int16_t modalIdx;
+	struct ar5416_eeprom_4k *pEepData = &ahp->ah_eeprom.map4k;
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	static const u16 tpScaleReductionTable[5] =
+		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 
-	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
-	xpdMask = pEepData->modalHeader[modalIdx].xpdGain;
+	int i;
+	int16_t twiceLargestAntenna;
+	struct cal_ctl_data_4k *rep;
+	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
+		0, { 0, 0, 0, 0}
+	};
+	struct cal_target_power_leg targetPowerOfdmExt = {
+		0, { 0, 0, 0, 0} }, targetPowerCckExt = {
+		0, { 0, 0, 0, 0 }
+	};
+	struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
+		0, {0, 0, 0, 0}
+	};
+	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
+	u16 ctlModesFor11g[] =
+		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
+		  CTL_2GHT40
+		};
+	u16 numCtlModes, *pCtlMode, ctlMode, freq;
+	struct chan_centers centers;
+	int tx_chainmask;
+	u16 twiceMinEdgePower;
+
+	tx_chainmask = ahp->ah_txchainmask;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	twiceLargestAntenna = pEepData->modalHeader.antennaGainCh[0];
+
+	twiceLargestAntenna = (int16_t)min(AntennaReduction -
+					   twiceLargestAntenna, 0);
+
+	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
+
+	if (ah->ah_tpScale != ATH9K_TP_SCALE_MAX) {
+		maxRegAllowedPower -=
+			(tpScaleReductionTable[(ah->ah_tpScale)] * 2);
+	}
+
+	scaledPower = min(powerLimit, maxRegAllowedPower);
+	scaledPower = max((u16)0, scaledPower);
+
+	numCtlModes = ARRAY_SIZE(ctlModesFor11g) - SUB_NUM_CTL_MODES_AT_2G_40;
+	pCtlMode = ctlModesFor11g;
+
+	ath9k_hw_get_legacy_target_powers(ah, chan,
+			pEepData->calTargetPowerCck,
+			AR5416_NUM_2G_CCK_TARGET_POWERS,
+			&targetPowerCck, 4, false);
+	ath9k_hw_get_legacy_target_powers(ah, chan,
+			pEepData->calTargetPower2G,
+			AR5416_NUM_2G_20_TARGET_POWERS,
+			&targetPowerOfdm, 4, false);
+	ath9k_hw_get_target_powers(ah, chan,
+			pEepData->calTargetPower2GHT20,
+			AR5416_NUM_2G_20_TARGET_POWERS,
+			&targetPowerHt20, 8, false);
+
+	if (IS_CHAN_HT40(chan)) {
+		numCtlModes = ARRAY_SIZE(ctlModesFor11g);
+		ath9k_hw_get_target_powers(ah, chan,
+				pEepData->calTargetPower2GHT40,
+				AR5416_NUM_2G_40_TARGET_POWERS,
+				&targetPowerHt40, 8, true);
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPowerCck,
+				AR5416_NUM_2G_CCK_TARGET_POWERS,
+				&targetPowerCckExt, 4, true);
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPower2G,
+				AR5416_NUM_2G_20_TARGET_POWERS,
+				&targetPowerOfdmExt, 4, true);
+	}
+
+	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
+		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
+			(pCtlMode[ctlMode] == CTL_2GHT40);
+		if (isHt40CtlMode)
+			freq = centers.synth_center;
+		else if (pCtlMode[ctlMode] & EXT_ADDITIVE)
+			freq = centers.ext_center;
+		else
+			freq = centers.ctl_center;
+
+		if (ar5416_get_eep_ver(ahp) == 14 &&
+				ar5416_get_eep_rev(ahp) <= 2)
+			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
+			"EXT_ADDITIVE %d\n",
+			ctlMode, numCtlModes, isHt40CtlMode,
+			(pCtlMode[ctlMode] & EXT_ADDITIVE));
+
+		for (i = 0; (i < AR5416_NUM_CTLS) &&
+				pEepData->ctlIndex[i]; i++) {
+			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
+				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
+				"chan %d\n",
+				i, cfgCtl, pCtlMode[ctlMode],
+				pEepData->ctlIndex[i], chan->channel);
+
+			if ((((cfgCtl & ~CTL_MODE_M) |
+			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+			     pEepData->ctlIndex[i]) ||
+			    (((cfgCtl & ~CTL_MODE_M) |
+			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+			     ((pEepData->ctlIndex[i] & CTL_MODE_M) |
+			      SD_NO_CTL))) {
+				rep = &(pEepData->ctlData[i]);
+
+				twiceMinEdgePower =
+					ath9k_hw_get_max_edge_power(freq,
+				rep->ctlEdges[ar5416_get_ntxchains
+						(tx_chainmask) - 1],
+				IS_CHAN_2GHZ(chan),
+				AR5416_EEP4K_NUM_BAND_EDGES);
+
+				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+					"    MATCH-EE_IDX %d: ch %d is2 %d "
+					"2xMinEdge %d chainmask %d chains %d\n",
+					i, freq, IS_CHAN_2GHZ(chan),
+					twiceMinEdgePower, tx_chainmask,
+					ar5416_get_ntxchains
+					(tx_chainmask));
+				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
+					twiceMaxEdgePower =
+						min(twiceMaxEdgePower,
+						    twiceMinEdgePower);
+				} else {
+					twiceMaxEdgePower = twiceMinEdgePower;
+					break;
+				}
+			}
+		}
+
+		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
+
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			"    SEL-Min ctlMode %d pCtlMode %d "
+			"2xMaxEdge %d sP %d minCtlPwr %d\n",
+			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
+			scaledPower, minCtlPower);
+
+		switch (pCtlMode[ctlMode]) {
+		case CTL_11B:
+			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x);
+					i++) {
+				targetPowerCck.tPow2x[i] =
+					min((u16)targetPowerCck.tPow2x[i],
+					    minCtlPower);
+			}
+			break;
+		case CTL_11G:
+			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x);
+					i++) {
+				targetPowerOfdm.tPow2x[i] =
+					min((u16)targetPowerOfdm.tPow2x[i],
+					    minCtlPower);
+			}
+			break;
+		case CTL_2GHT20:
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x);
+					i++) {
+				targetPowerHt20.tPow2x[i] =
+					min((u16)targetPowerHt20.tPow2x[i],
+					    minCtlPower);
+			}
+			break;
+		case CTL_11B_EXT:
+			targetPowerCckExt.tPow2x[0] = min((u16)
+					targetPowerCckExt.tPow2x[0],
+					minCtlPower);
+			break;
+		case CTL_11G_EXT:
+			targetPowerOfdmExt.tPow2x[0] = min((u16)
+					targetPowerOfdmExt.tPow2x[0],
+					minCtlPower);
+			break;
+		case CTL_2GHT40:
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x);
+					i++) {
+				targetPowerHt40.tPow2x[i] =
+					min((u16)targetPowerHt40.tPow2x[i],
+					    minCtlPower);
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+	ratesArray[rate6mb] = ratesArray[rate9mb] = ratesArray[rate12mb] =
+		ratesArray[rate18mb] = ratesArray[rate24mb] =
+		targetPowerOfdm.tPow2x[0];
+	ratesArray[rate36mb] = targetPowerOfdm.tPow2x[1];
+	ratesArray[rate48mb] = targetPowerOfdm.tPow2x[2];
+	ratesArray[rate54mb] = targetPowerOfdm.tPow2x[3];
+	ratesArray[rateXr] = targetPowerOfdm.tPow2x[0];
+
+	for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++)
+		ratesArray[rateHt20_0 + i] = targetPowerHt20.tPow2x[i];
+
+	ratesArray[rate1l] = targetPowerCck.tPow2x[0];
+	ratesArray[rate2s] = ratesArray[rate2l] = targetPowerCck.tPow2x[1];
+	ratesArray[rate5_5s] = ratesArray[rate5_5l] = targetPowerCck.tPow2x[2];
+	ratesArray[rate11s] = ratesArray[rate11l] = targetPowerCck.tPow2x[3];
+
+	if (IS_CHAN_HT40(chan)) {
+		for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
+			ratesArray[rateHt40_0 + i] =
+				targetPowerHt40.tPow2x[i];
+		}
+		ratesArray[rateDupOfdm] = targetPowerHt40.tPow2x[0];
+		ratesArray[rateDupCck] = targetPowerHt40.tPow2x[0];
+		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
+		ratesArray[rateExtCck] = targetPowerCckExt.tPow2x[0];
+	}
+	return true;
+}
+
+static int ath9k_hw_def_set_txpower(struct ath_hal *ah,
+			 struct ath9k_channel *chan,
+			 u16 cfgCtl,
+			 u8 twiceAntennaReduction,
+			 u8 twiceMaxRegulatoryPower,
+			 u8 powerLimit)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_def *pEepData = &ahp->ah_eeprom.def;
+	struct modal_eep_header *pModal =
+		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
+	int16_t ratesArray[Ar5416RateSize];
+	int16_t txPowerIndexOffset = 0;
+	u8 ht40PowerIncForPdadc = 2;
+	int i;
+
+	memset(ratesArray, 0, sizeof(ratesArray));
 
 	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
 	    AR5416_EEP_MINOR_VER_2) {
-		pdGainOverlap_t2 =
-			pEepData->modalHeader[modalIdx].pdGainOverlap;
-	} else {
-		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
-					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
+		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
+	}
+
+	if (!ath9k_hw_set_def_power_per_rate_table(ah, chan,
+					       &ratesArray[0], cfgCtl,
+					       twiceAntennaReduction,
+					       twiceMaxRegulatoryPower,
+					       powerLimit)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"ath9k_hw_set_txpower: unable to set "
+			"tx power per rate table\n");
+		return -EIO;
+	}
+
+	if (!ath9k_hw_set_def_power_cal_table(ah, chan, &txPowerIndexOffset)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			 "ath9k_hw_set_txpower: unable to set power table\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
+		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
+		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
+			ratesArray[i] = AR5416_MAX_RATE_POWER;
 	}
 
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		for (i = 0; i < Ar5416RateSize; i++)
+			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
+	}
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
+		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
+		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
+		  | ATH9K_POW_SM(ratesArray[rate9mb], 8)
+		  | ATH9K_POW_SM(ratesArray[rate6mb], 0));
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE2,
+		  ATH9K_POW_SM(ratesArray[rate54mb], 24)
+		  | ATH9K_POW_SM(ratesArray[rate48mb], 16)
+		  | ATH9K_POW_SM(ratesArray[rate36mb], 8)
+		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
+
 	if (IS_CHAN_2GHZ(chan)) {
-		pCalBChans = pEepData->calFreqPier2G;
-		numPiers = AR5416_NUM_2G_CAL_PIERS;
-	} else {
-		pCalBChans = pEepData->calFreqPier5G;
-		numPiers = AR5416_NUM_5G_CAL_PIERS;
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
+			  ATH9K_POW_SM(ratesArray[rate2s], 24)
+			  | ATH9K_POW_SM(ratesArray[rate2l], 16)
+			  | ATH9K_POW_SM(ratesArray[rateXr], 8)
+			  | ATH9K_POW_SM(ratesArray[rate1l], 0));
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
+			  ATH9K_POW_SM(ratesArray[rate11s], 24)
+			  | ATH9K_POW_SM(ratesArray[rate11l], 16)
+			  | ATH9K_POW_SM(ratesArray[rate5_5s], 8)
+			  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
 	}
 
-	numXpdGain = 0;
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
+		  ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_2], 16)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_1], 8)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_0], 0));
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE6,
+		  ATH9K_POW_SM(ratesArray[rateHt20_7], 24)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_6], 16)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_5], 8)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
 
-	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
-		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
-			if (numXpdGain >= AR5416_NUM_PD_GAINS)
-				break;
-			xpdGainValues[numXpdGain] =
-				(u16)(AR5416_PD_GAINS_IN_MASK - i);
-			numXpdGain++;
-		}
+	if (IS_CHAN_HT40(chan)) {
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
+			  ATH9K_POW_SM(ratesArray[rateHt40_3] +
+				       ht40PowerIncForPdadc, 24)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_2] +
+					 ht40PowerIncForPdadc, 16)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_1] +
+					 ht40PowerIncForPdadc, 8)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_0] +
+					 ht40PowerIncForPdadc, 0));
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
+			  ATH9K_POW_SM(ratesArray[rateHt40_7] +
+				       ht40PowerIncForPdadc, 24)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_6] +
+					 ht40PowerIncForPdadc, 16)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_5] +
+					 ht40PowerIncForPdadc, 8)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
+					 ht40PowerIncForPdadc, 0));
+
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
+			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
+			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
+			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
+			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
 
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
-		      (numXpdGain - 1) & 0x3);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
-		      xpdGainValues[0]);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
-		      xpdGainValues[1]);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
-		      xpdGainValues[2]);
+	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
+		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
+		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
 
-	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ahp->ah_rxchainmask == 5 || ahp->ah_txchainmask == 5) &&
-		    (i != 0)) {
-			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
-		} else
-			regChainOffset = i * 0x1000;
+	i = rate6mb;
 
-		if (pEepData->baseEepHeader.txMask & (1 << i)) {
-			if (IS_CHAN_2GHZ(chan))
-				pRawDataset = pEepData->calPierData2G[i];
-			else
-				pRawDataset = pEepData->calPierData5G[i];
+	if (IS_CHAN_HT40(chan))
+		i = rateHt40_0;
+	else if (IS_CHAN_HT20(chan))
+		i = rateHt20_0;
 
-			ath9k_hw_get_gain_boundaries_pdadcs(ah, chan,
-					    pRawDataset, pCalBChans,
-					    numPiers, pdGainOverlap_t2,
-					    &tMinCalPower, gainBoundaries,
-					    pdadcValues, numXpdGain);
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->ah_maxPowerLevel =
+			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
+	else
+		ah->ah_maxPowerLevel = ratesArray[i];
 
-			if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
-				REG_WRITE(ah,
-					  AR_PHY_TPCRG5 + regChainOffset,
-					  SM(pdGainOverlap_t2,
-					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
-					  | SM(gainBoundaries[0],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
-					  | SM(gainBoundaries[1],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
-					  | SM(gainBoundaries[2],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
-					  | SM(gainBoundaries[3],
-				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
-			}
+	return 0;
+}
 
-			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
-			for (j = 0; j < 32; j++) {
-				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
-					((pdadcValues[4 * j + 1] & 0xFF) << 8) |
-					((pdadcValues[4 * j + 2] & 0xFF) << 16) |
-					((pdadcValues[4 * j + 3] & 0xFF) << 24);
-				REG_WRITE(ah, regOffset, reg32);
+static int ath9k_hw_4k_set_txpower(struct ath_hal *ah,
+			 struct ath9k_channel *chan,
+			 u16 cfgCtl,
+			 u8 twiceAntennaReduction,
+			 u8 twiceMaxRegulatoryPower,
+			 u8 powerLimit)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_4k *pEepData = &ahp->ah_eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
+	int16_t ratesArray[Ar5416RateSize];
+	int16_t txPowerIndexOffset = 0;
+	u8 ht40PowerIncForPdadc = 2;
+	int i;
 
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-					"PDADC (%d,%4x): %4.4x %8.8x\n",
-					i, regChainOffset, regOffset,
-					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-					"PDADC: Chain %d | PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d | PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d |\n",
-					i, 4 * j, pdadcValues[4 * j],
-					4 * j + 1, pdadcValues[4 * j + 1],
-					4 * j + 2, pdadcValues[4 * j + 2],
-					4 * j + 3,
-					pdadcValues[4 * j + 3]);
+	memset(ratesArray, 0, sizeof(ratesArray));
 
-				regOffset += 4;
-			}
+	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+	    AR5416_EEP_MINOR_VER_2) {
+		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
+	}
+
+	if (!ath9k_hw_set_4k_power_per_rate_table(ah, chan,
+					       &ratesArray[0], cfgCtl,
+					       twiceAntennaReduction,
+					       twiceMaxRegulatoryPower,
+					       powerLimit)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"ath9k_hw_set_txpower: unable to set "
+			"tx power per rate table\n");
+		return -EIO;
+	}
+
+	if (!ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			 "ath9k_hw_set_txpower: unable to set power table\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
+		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
+		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
+			ratesArray[i] = AR5416_MAX_RATE_POWER;
+	}
+
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		for (i = 0; i < Ar5416RateSize; i++)
+			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
+	}
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
+		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
+		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
+		  | ATH9K_POW_SM(ratesArray[rate9mb], 8)
+		  | ATH9K_POW_SM(ratesArray[rate6mb], 0));
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE2,
+		  ATH9K_POW_SM(ratesArray[rate54mb], 24)
+		  | ATH9K_POW_SM(ratesArray[rate48mb], 16)
+		  | ATH9K_POW_SM(ratesArray[rate36mb], 8)
+		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
+
+	if (IS_CHAN_2GHZ(chan)) {
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
+			  ATH9K_POW_SM(ratesArray[rate2s], 24)
+			  | ATH9K_POW_SM(ratesArray[rate2l], 16)
+			  | ATH9K_POW_SM(ratesArray[rateXr], 8)
+			  | ATH9K_POW_SM(ratesArray[rate1l], 0));
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
+			  ATH9K_POW_SM(ratesArray[rate11s], 24)
+			  | ATH9K_POW_SM(ratesArray[rate11l], 16)
+			  | ATH9K_POW_SM(ratesArray[rate5_5s], 8)
+			  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
+	}
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
+		  ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_2], 16)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_1], 8)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_0], 0));
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE6,
+		  ATH9K_POW_SM(ratesArray[rateHt20_7], 24)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_6], 16)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_5], 8)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
+
+	if (IS_CHAN_HT40(chan)) {
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
+			  ATH9K_POW_SM(ratesArray[rateHt40_3] +
+				       ht40PowerIncForPdadc, 24)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_2] +
+					 ht40PowerIncForPdadc, 16)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_1] +
+					 ht40PowerIncForPdadc, 8)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_0] +
+					 ht40PowerIncForPdadc, 0));
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
+			  ATH9K_POW_SM(ratesArray[rateHt40_7] +
+				       ht40PowerIncForPdadc, 24)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_6] +
+					 ht40PowerIncForPdadc, 16)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_5] +
+					 ht40PowerIncForPdadc, 8)
+			  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
+					 ht40PowerIncForPdadc, 0));
+
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
+			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
+			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
+			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
+			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
+	}
+
+	i = rate6mb;
+
+	if (IS_CHAN_HT40(chan))
+		i = rateHt40_0;
+	else if (IS_CHAN_HT20(chan))
+		i = rateHt20_0;
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->ah_maxPowerLevel =
+			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
+	else
+		ah->ah_maxPowerLevel = ratesArray[i];
+
+	return 0;
+}
+
+int (*ath9k_set_txpower[]) (struct ath_hal *,
+			    struct ath9k_channel *,
+			    u16, u8, u8, u8) = {
+	ath9k_hw_def_set_txpower,
+	ath9k_hw_4k_set_txpower
+};
+
+int ath9k_hw_set_txpower(struct ath_hal *ah,
+			 struct ath9k_channel *chan,
+			 u16 cfgCtl,
+			 u8 twiceAntennaReduction,
+			 u8 twiceMaxRegulatoryPower,
+			 u8 powerLimit)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_set_txpower[ahp->ah_eep_map](ah, chan, cfgCtl,
+			twiceAntennaReduction, twiceMaxRegulatoryPower,
+			powerLimit);
+}
+
+static void ath9k_hw_set_def_addac(struct ath_hal *ah,
+				   struct ath9k_channel *chan)
+{
+#define XPA_LVL_FREQ(cnt) (pModal->xpaBiasLvlFreq[cnt])
+	struct modal_eep_header *pModal;
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
+	u8 biaslevel;
+
+	if (ah->ah_macVersion != AR_SREV_VERSION_9160)
+		return;
+
+	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
+		return;
+
+	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
+
+	if (pModal->xpaBiasLvl != 0xff) {
+		biaslevel = pModal->xpaBiasLvl;
+	} else {
+		u16 resetFreqBin, freqBin, freqCount = 0;
+		struct chan_centers centers;
+
+		ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+		resetFreqBin = FREQ2FBIN(centers.synth_center,
+					 IS_CHAN_2GHZ(chan));
+		freqBin = XPA_LVL_FREQ(0) & 0xff;
+		biaslevel = (u8) (XPA_LVL_FREQ(0) >> 14);
+
+		freqCount++;
+
+		while (freqCount < 3) {
+			if (XPA_LVL_FREQ(freqCount) == 0x0)
+				break;
+
+			freqBin = XPA_LVL_FREQ(freqCount) & 0xff;
+			if (resetFreqBin >= freqBin)
+				biaslevel = (u8)(XPA_LVL_FREQ(freqCount) >> 14);
+			else
+				break;
+			freqCount++;
 		}
 	}
 
-	*pTxPowerIndexOffset = 0;
+	if (IS_CHAN_2GHZ(chan)) {
+		INI_RA(&ahp->ah_iniAddac, 7, 1) = (INI_RA(&ahp->ah_iniAddac,
+					7, 1) & (~0x18)) | biaslevel << 3;
+	} else {
+		INI_RA(&ahp->ah_iniAddac, 6, 1) = (INI_RA(&ahp->ah_iniAddac,
+					6, 1) & (~0xc0)) | biaslevel << 6;
+	}
+#undef XPA_LVL_FREQ
+}
 
-	return true;
+static void ath9k_hw_set_4k_addac(struct ath_hal *ah,
+				  struct ath9k_channel *chan)
+{
+	struct modal_eep_4k_header *pModal;
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	u8 biaslevel;
+
+	if (ah->ah_macVersion != AR_SREV_VERSION_9160)
+		return;
+
+	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
+		return;
+
+	pModal = &eep->modalHeader;
+
+	if (pModal->xpaBiasLvl != 0xff) {
+		biaslevel = pModal->xpaBiasLvl;
+		INI_RA(&ahp->ah_iniAddac, 7, 1) =
+		  (INI_RA(&ahp->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
+	}
+}
+
+void (*ath9k_set_addac[]) (struct ath_hal *, struct ath9k_channel *) = {
+	ath9k_hw_set_def_addac,
+	ath9k_hw_set_4k_addac
+};
+
+void ath9k_hw_set_addac(struct ath_hal *ah, struct ath9k_channel *chan)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	ath9k_set_addac[ahp->ah_eep_map](ah, chan);
 }
 
+
+
 /* XXX: Clean me up, make me more legible */
-bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
+static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hal *ah,
 				      struct ath9k_channel *chan)
 {
 	struct modal_eep_header *pModal;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
+	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	int i, regChainOffset;
 	u8 txRxAttenLocal;
 	u16 ant_config;
@@ -1462,12 +2352,214 @@ bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 	return true;
 }
 
-int ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hal *ah,
+				      struct ath9k_channel *chan)
+{
+	struct modal_eep_4k_header *pModal;
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	int regChainOffset;
+	u8 txRxAttenLocal;
+	u16 ant_config = 0;
+	u8 ob[5], db1[5], db2[5];
+	u8 ant_div_control1, ant_div_control2;
+	u32 regVal;
+
+
+	pModal = &eep->modalHeader;
+
+	txRxAttenLocal = 23;
+
+	ath9k_hw_get_eeprom_antenna_cfg(ah, chan, 0, &ant_config);
+	REG_WRITE(ah, AR_PHY_SWITCH_COM, ant_config);
+
+	regChainOffset = 0;
+	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0 + regChainOffset,
+		  pModal->antCtrlChain[0]);
+
+	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
+		 (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset) &
+		 ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
+		 AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
+		 SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
+		 SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
+
+	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+			AR5416_EEP_MINOR_VER_3) {
+		txRxAttenLocal = pModal->txRxAttenCh[0];
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN, pModal->bswMargin[0]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			AR_PHY_GAIN_2GHZ_XATTEN1_DB, pModal->bswAtten[0]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
+			pModal->xatten2Margin[0]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			AR_PHY_GAIN_2GHZ_XATTEN2_DB, pModal->xatten2Db[0]);
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
+			AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
+	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
+			AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
+
+	if (AR_SREV_9285_11(ah))
+		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
+
+	/* Initialize Ant Diversity settings from EEPROM */
+	if (pModal->version == 3) {
+		ant_div_control1 = ((pModal->ob_234 >> 12) & 0xf);
+		ant_div_control2 = ((pModal->db1_234 >> 12) & 0xf);
+		regVal = REG_READ(ah, 0x99ac);
+		regVal &= (~(0x7f000000));
+		regVal |= ((ant_div_control1 & 0x1) << 24);
+		regVal |= (((ant_div_control1 >> 1) & 0x1) << 29);
+		regVal |= (((ant_div_control1 >> 2) & 0x1) << 30);
+		regVal |= ((ant_div_control2 & 0x3) << 25);
+		regVal |= (((ant_div_control2 >> 2) & 0x3) << 27);
+		REG_WRITE(ah, 0x99ac, regVal);
+		regVal = REG_READ(ah, 0x99ac);
+		regVal = REG_READ(ah, 0xa208);
+		regVal &= (~(0x1 << 13));
+		regVal |= (((ant_div_control1 >> 3) & 0x1) << 13);
+		REG_WRITE(ah, 0xa208, regVal);
+		regVal = REG_READ(ah, 0xa208);
+	}
+
+	if (pModal->version >= 2) {
+		ob[0] = (pModal->ob_01 & 0xf);
+		ob[1] = (pModal->ob_01 >> 4) & 0xf;
+		ob[2] = (pModal->ob_234 & 0xf);
+		ob[3] = ((pModal->ob_234 >> 4) & 0xf);
+		ob[4] = ((pModal->ob_234 >> 8) & 0xf);
+
+		db1[0] = (pModal->db1_01 & 0xf);
+		db1[1] = ((pModal->db1_01 >> 4) & 0xf);
+		db1[2] = (pModal->db1_234 & 0xf);
+		db1[3] = ((pModal->db1_234 >> 4) & 0xf);
+		db1[4] = ((pModal->db1_234 >> 8) & 0xf);
+
+		db2[0] = (pModal->db2_01 & 0xf);
+		db2[1] = ((pModal->db2_01 >> 4) & 0xf);
+		db2[2] = (pModal->db2_234 & 0xf);
+		db2[3] = ((pModal->db2_234 >> 4) & 0xf);
+		db2[4] = ((pModal->db2_234 >> 8) & 0xf);
+
+	} else if (pModal->version == 1) {
+
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"EEPROM Model version is set to 1 \n");
+		ob[0] = (pModal->ob_01 & 0xf);
+		ob[1] = ob[2] = ob[3] = ob[4] = (pModal->ob_01 >> 4) & 0xf;
+		db1[0] = (pModal->db1_01 & 0xf);
+		db1[1] = db1[2] = db1[3] =
+			db1[4] = ((pModal->db1_01 >> 4) & 0xf);
+		db2[0] = (pModal->db2_01 & 0xf);
+		db2[1] = db2[2] = db2[3] =
+			db2[4] = ((pModal->db2_01 >> 4) & 0xf);
+	} else {
+		int i;
+		for (i = 0; i < 5; i++) {
+			ob[i] = pModal->ob_01;
+			db1[i] = pModal->db1_01;
+			db2[i] = pModal->db1_01;
+		}
+	}
+
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_OB_0, AR9285_AN_RF2G3_OB_0_S, ob[0]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_OB_1, AR9285_AN_RF2G3_OB_1_S, ob[1]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_OB_2, AR9285_AN_RF2G3_OB_2_S, ob[2]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_OB_3, AR9285_AN_RF2G3_OB_3_S, ob[3]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_OB_4, AR9285_AN_RF2G3_OB_4_S, ob[4]);
+
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_DB1_0, AR9285_AN_RF2G3_DB1_0_S, db1[0]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_DB1_1, AR9285_AN_RF2G3_DB1_1_S, db1[1]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G3,
+			AR9285_AN_RF2G3_DB1_2, AR9285_AN_RF2G3_DB1_2_S, db1[2]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB1_3, AR9285_AN_RF2G4_DB1_3_S, db1[3]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB1_4, AR9285_AN_RF2G4_DB1_4_S, db1[4]);
+
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB2_0, AR9285_AN_RF2G4_DB2_0_S, db2[0]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB2_1, AR9285_AN_RF2G4_DB2_1_S, db2[1]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB2_2, AR9285_AN_RF2G4_DB2_2_S, db2[2]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB2_3, AR9285_AN_RF2G4_DB2_3_S, db2[3]);
+	ath9k_hw_analog_shift_rmw(ah, AR9285_AN_RF2G4,
+			AR9285_AN_RF2G4_DB2_4, AR9285_AN_RF2G4_DB2_4_S, db2[4]);
+
+
+	if (AR_SREV_9285_11(ah))
+		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
+
+	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
+		      pModal->switchSettling);
+	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
+		      pModal->adcDesiredSize);
+
+	REG_WRITE(ah, AR_PHY_RF_CTL4,
+		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAA_OFF) |
+		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAB_OFF) |
+		  SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAA_ON)  |
+		  SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAB_ON));
+
+	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
+		      pModal->txEndToRxOn);
+	REG_RMW_FIELD(ah, AR_PHY_CCA, AR9280_PHY_CCA_THRESH62,
+		      pModal->thresh62);
+	REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0, AR_PHY_EXT_CCA0_THRESH62,
+		      pModal->thresh62);
+
+	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+						AR5416_EEP_MINOR_VER_2) {
+		REG_RMW_FIELD(ah, AR_PHY_RF_CTL2, AR_PHY_TX_END_DATA_START,
+			      pModal->txFrameToDataStart);
+		REG_RMW_FIELD(ah, AR_PHY_RF_CTL2, AR_PHY_TX_END_PA_ON,
+			      pModal->txFrameToPaOn);
+	}
+
+	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+						AR5416_EEP_MINOR_VER_3) {
+		if (IS_CHAN_HT40(chan))
+			REG_RMW_FIELD(ah, AR_PHY_SETTLING,
+				      AR_PHY_SETTLING_SWITCH,
+				      pModal->swSettleHt40);
+	}
+
+	return true;
+}
+
+bool (*ath9k_eeprom_set_board_values[])(struct ath_hal *,
+					struct ath9k_channel *) = {
+	ath9k_hw_eeprom_set_def_board_values,
+	ath9k_hw_eeprom_set_4k_board_values
+};
+
+bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
+				      struct ath9k_channel *chan)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_eeprom_set_board_values[ahp->ah_eep_map](ah, chan);
+}
+
+static int ath9k_hw_get_def_eeprom_antenna_cfg(struct ath_hal *ah,
 				    struct ath9k_channel *chan,
 				    u8 index, u16 *config)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
+	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
@@ -1492,11 +2584,52 @@ int ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
 	return -EINVAL;
 }
 
-u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
+static int ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hal *ah,
+				    struct ath9k_channel *chan,
+				    u8 index, u16 *config)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &eep->modalHeader;
+
+	switch (index) {
+	case 0:
+		*config = pModal->antCtrlCommon & 0xFFFF;
+		return 0;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+int (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hal *, struct ath9k_channel *,
+				      u8, u16 *) = {
+	ath9k_hw_get_def_eeprom_antenna_cfg,
+	ath9k_hw_get_4k_eeprom_antenna_cfg
+};
+
+int ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+				    struct ath9k_channel *chan,
+				    u8 index, u16 *config)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_get_eeprom_antenna_cfg[ahp->ah_eep_map](ah, chan,
+							     index, config);
+}
+
+u8 ath9k_hw_get_4k_num_ant_config(struct ath_hal *ah,
+			       enum ieee80211_band freq_band)
+{
+	return 1;
+}
+
+u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
 			       enum ieee80211_band freq_band)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
+	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IEEE80211_BAND_5GHZ == freq_band]);
 	struct base_eep_header *pBase = &eep->baseEepHeader;
@@ -1511,11 +2644,26 @@ u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
 	return num_ant_config;
 }
 
+u8 (*ath9k_get_num_ant_config[])(struct ath_hal *, enum ieee80211_band) = {
+	ath9k_hw_get_def_num_ant_config,
+	ath9k_hw_get_4k_num_ant_config
+};
+
+u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
+			       enum ieee80211_band freq_band)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_get_num_ant_config[ahp->ah_eep_map](ah, freq_band);
+}
+
 u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz)
 {
+#define EEP_MAP4K_SPURCHAN \
+	(ahp->ah_eeprom.map4k.modalHeader.spurChans[i].spurChan)
+#define EEP_DEF_SPURCHAN \
+	(ahp->ah_eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep =
-		(struct ar5416_eeprom *) &ahp->ah_eeprom;
 	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -1531,19 +2679,66 @@ u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz)
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
-		spur_val = eep->modalHeader[is2GHz].spurChans[i].spurChan;
+		if (ahp->ah_eep_map == EEP_MAP_4KBITS)
+			spur_val = EEP_MAP4K_SPURCHAN;
+		else
+			spur_val = EEP_DEF_SPURCHAN;
 		break;
 
 	}
 
 	return spur_val;
+#undef EEP_DEF_SPURCHAN
+#undef EEP_MAP4K_SPURCHAN
 }
 
-u32 ath9k_hw_get_eeprom(struct ath_hal *ah,
-			enum eeprom_param param)
+static u32 ath9k_hw_get_eeprom_4k(struct ath_hal *ah,
+				  enum eeprom_param param)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &eep->modalHeader;
+	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
+
+	switch (param) {
+	case EEP_NFTHRESH_2:
+		return pModal[1].noiseFloorThreshCh[0];
+	case AR_EEPROM_MAC(0):
+		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
+	case AR_EEPROM_MAC(1):
+		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
+	case AR_EEPROM_MAC(2):
+		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
+	case EEP_REG_0:
+		return pBase->regDmn[0];
+	case EEP_REG_1:
+		return pBase->regDmn[1];
+	case EEP_OP_CAP:
+		return pBase->deviceCap;
+	case EEP_OP_MODE:
+		return pBase->opCapFlags;
+	case EEP_RF_SILENT:
+		return pBase->rfSilent;
+	case EEP_OB_2:
+		return pModal->ob_01;
+	case EEP_DB_2:
+		return pModal->db1_01;
+	case EEP_MINOR_REV:
+		return pBase->version & AR5416_EEP_VER_MINOR_MASK;
+	case EEP_TX_MASK:
+		return pBase->txMask;
+	case EEP_RX_MASK:
+		return pBase->rxMask;
+	default:
+		return 0;
+	}
+}
+
+static u32 ath9k_hw_get_eeprom_def(struct ath_hal *ah,
+				   enum eeprom_param param)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
+	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	struct modal_eep_header *pModal = eep->modalHeader;
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 
@@ -1592,13 +2787,32 @@ u32 ath9k_hw_get_eeprom(struct ath_hal *ah,
 	}
 }
 
+u32 (*ath9k_get_eeprom[])(struct ath_hal *, enum eeprom_param) = {
+	ath9k_hw_get_eeprom_def,
+	ath9k_hw_get_eeprom_4k
+};
+
+u32 ath9k_hw_get_eeprom(struct ath_hal *ah,
+			enum eeprom_param param)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	return ath9k_get_eeprom[ahp->ah_eep_map](ah, param);
+}
+
 int ath9k_hw_eeprom_attach(struct ath_hal *ah)
 {
 	int status;
+	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (ath9k_hw_use_flash(ah))
 		ath9k_hw_flash_map(ah);
 
+	if (AR_SREV_9285(ah))
+		ahp->ah_eep_map = EEP_MAP_4KBITS;
+	else
+		ahp->ah_eep_map = EEP_MAP_DEFAULT;
+
 	if (!ath9k_hw_fill_eeprom(ah))
 		return -EIO;
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 60d18d6..d7a2c20 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -37,7 +37,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hal *ah, u32 type);
 static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 			      enum ath9k_ht_macmode macmode);
 static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
-			      struct ar5416_eeprom *pEepData,
+			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value);
 static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *chan);
 static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *chan);
@@ -392,6 +392,8 @@ static const char *ath9k_hw_devname(u16 devid)
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
 		return "Atheros 9280";
+	case AR9285_DEVID_PCIE:
+		return "Atheros 9285";
 	}
 
 	return NULL;
@@ -683,7 +685,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if ((ah->ah_macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_9160) &&
-	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah))) {
+	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) && (!AR_SREV_9285(ah))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->ah_macVersion, ah->ah_macRev);
@@ -734,7 +736,38 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		"This Mac Chip Rev 0x%02x.%x is \n",
 		ah->ah_macVersion, ah->ah_macRev);
 
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
+	if (AR_SREV_9285_12_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9285Modes_9285_1_2,
+			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
+		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9285Common_9285_1_2,
+			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
+
+		if (ah->ah_config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			ar9285PciePhy_clkreq_off_L1_9285_1_2,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
+		} else {
+			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
+				  2);
+		}
+	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9285Modes_9285,
+			       ARRAY_SIZE(ar9285Modes_9285), 6);
+		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9285Common_9285,
+			       ARRAY_SIZE(ar9285Common_9285), 2);
+
+		if (ah->ah_config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			ar9285PciePhy_clkreq_off_L1_9285,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
+		} else {
+			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
+			ar9285PciePhy_clkreq_always_on_L1_9285,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
+		}
+	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9280Modes_9280_2,
 			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
 		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9280Common_9280_2,
@@ -844,11 +877,11 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		goto bad;
 
 	/* rxgain table */
-	if (AR_SREV_9280_20_OR_LATER(ah))
+	if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_rxgain_ini(ah);
 
 	/* txgain table */
-	if (AR_SREV_9280_20_OR_LATER(ah))
+	if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_txgain_ini(ah);
 
 	if (ah->ah_devid == AR9280_DEVID_PCI) {
@@ -859,7 +892,8 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 				u32 val = INI_RA(&ahp->ah_iniModes, i, j);
 
 				INI_RA(&ahp->ah_iniModes, i, j) =
-					ath9k_hw_ini_fixup(ah, &ahp->ah_eeprom,
+					ath9k_hw_ini_fixup(ah,
+							   &ahp->ah_eeprom.def,
 							   reg, val);
 			}
 		}
@@ -1017,8 +1051,6 @@ static void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 		}
 	case 0x1:
 	case 0x2:
-		if (!AR_SREV_9280(ah))
-			break;
 	case 0x7:
 		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
 		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
@@ -1163,12 +1195,10 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 	case AR9160_DEVID_PCI:
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
+	case AR9285_DEVID_PCIE:
 		ah = ath9k_hw_do_attach(devid, sc, mem, error);
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
-			"devid=0x%x not supported.\n", devid);
-		ah = NULL;
 		*error = -ENXIO;
 		break;
 	}
@@ -1190,8 +1220,8 @@ static void ath9k_hw_override_ini(struct ath_hal *ah,
 	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
 }
 
-static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
-			      struct ar5416_eeprom *pEepData,
+static u32 ath9k_hw_def_ini_fixup(struct ath_hal *ah,
+			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value)
 {
 	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
@@ -1224,6 +1254,18 @@ static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
 	return value;
 }
 
+static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
+			      struct ar5416_eeprom_def *pEepData,
+			      u32 reg, u32 value)
+{
+	struct ath_hal_5416 *ahp = AH5416(ah);
+
+	if (ahp->ah_eep_map == EEP_MAP_4KBITS)
+		return value;
+	else
+		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
+}
+
 static int ath9k_hw_process_ini(struct ath_hal *ah,
 				struct ath9k_channel *chan,
 				enum ath9k_ht_macmode macmode)
@@ -1301,10 +1343,10 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 		DO_DELAY(regWrites);
 	}
 
-	if (AR_SREV_9280_20_OR_LATER(ah))
+	if (AR_SREV_9280(ah))
 		REG_WRITE_ARRAY(&ahp->ah_iniModesRxGain, modesIndex, regWrites);
 
-	if (AR_SREV_9280_20_OR_LATER(ah))
+	if (AR_SREV_9280(ah))
 		REG_WRITE_ARRAY(&ahp->ah_iniModesTxGain, modesIndex, regWrites);
 
 	for (i = 0; i < ahp->ah_iniCommon.ia_rows; i++) {
@@ -1577,10 +1619,15 @@ static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 			      enum ath9k_ht_macmode macmode)
 {
 	u32 phymode;
+	u32 enableDacFifo = 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
+					 AR_PHY_FC_ENABLE_DAC_FIFO);
+
 	phymode = AR_PHY_FC_HT_EN | AR_PHY_FC_SHORT_GI_40
-		| AR_PHY_FC_SINGLE_HT_LTF1 | AR_PHY_FC_WALSH;
+		| AR_PHY_FC_SINGLE_HT_LTF1 | AR_PHY_FC_WALSH | enableDacFifo;
 
 	if (IS_CHAN_HT40(chan)) {
 		phymode |= AR_PHY_FC_DYN2040_EN;
@@ -2763,11 +2810,14 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 	if (ah->ah_config.pcie_waen) {
 		REG_WRITE(ah, AR_WA, ah->ah_config.pcie_waen);
 	} else {
-		if (AR_SREV_9280(ah))
-			REG_WRITE(ah, AR_WA, 0x0040073f);
+		if (AR_SREV_9285(ah))
+			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
+		else if (AR_SREV_9280(ah))
+			REG_WRITE(ah, AR_WA, AR9280_WA_DEFAULT);
 		else
-			REG_WRITE(ah, AR_WA, 0x0000073f);
+			REG_WRITE(ah, AR_WA, AR_WA_DEFAULT);
 	}
+
 }
 
 /**********************/
@@ -3318,7 +3368,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
 
-	if (AR_SREV_9280(ah))
+	if (AR_SREV_9280(ah) || AR_SREV_9285(ah))
 		pCap->hw_caps &= ~ATH9K_HW_CAP_4KB_SPLITTRANS;
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 02256c3..a4d5285 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -448,6 +448,17 @@ struct ar5416Stats {
 #define AR5416_EEP_TXGAIN_ORIGINAL         0
 #define AR5416_EEP_TXGAIN_HIGH_POWER       1
 
+#define AR5416_EEP4K_START_LOC         64
+#define AR5416_EEP4K_NUM_2G_CAL_PIERS      3
+#define AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS 3
+#define AR5416_EEP4K_NUM_2G_20_TARGET_POWERS  3
+#define AR5416_EEP4K_NUM_2G_40_TARGET_POWERS  3
+#define AR5416_EEP4K_NUM_CTLS              12
+#define AR5416_EEP4K_NUM_BAND_EDGES        4
+#define AR5416_EEP4K_NUM_PD_GAINS          2
+#define AR5416_EEP4K_PD_GAINS_IN_MASK      4
+#define AR5416_EEP4K_PD_GAIN_ICEPTS        5
+#define AR5416_EEP4K_MAX_CHAINS            1
 
 enum eeprom_param {
 	EEP_NFTHRESH_5,
@@ -507,6 +518,25 @@ struct base_eep_header {
 	u8 futureBase_3[25];
 } __packed;
 
+struct base_eep_header_4k {
+	u16 length;
+	u16 checksum;
+	u16 version;
+	u8 opCapFlags;
+	u8 eepMisc;
+	u16 regDmn[2];
+	u8 macAddr[6];
+	u8 rxMask;
+	u8 txMask;
+	u16 rfSilent;
+	u16 blueToothOptions;
+	u16 deviceCap;
+	u32 binBuildNumber;
+	u8 deviceType;
+	u8 futureBase[1];
+} __packed;
+
+
 struct spur_chan {
 	u16 spurChan;
 	u8 spurRangeLow;
@@ -559,11 +589,58 @@ struct modal_eep_header {
 	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
 } __packed;
 
+struct modal_eep_4k_header {
+    u32  antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
+    u32  antCtrlCommon;
+    u8   antennaGainCh[AR5416_EEP4K_MAX_CHAINS];
+    u8   switchSettling;
+    u8   txRxAttenCh[AR5416_EEP4K_MAX_CHAINS];
+    u8   rxTxMarginCh[AR5416_EEP4K_MAX_CHAINS];
+    u8   adcDesiredSize;
+    u8   pgaDesiredSize;
+    u8   xlnaGainCh[AR5416_EEP4K_MAX_CHAINS];
+    u8   txEndToXpaOff;
+    u8   txEndToRxOn;
+    u8   txFrameToXpaOn;
+    u8   thresh62;
+    u8   noiseFloorThreshCh[AR5416_EEP4K_MAX_CHAINS];
+    u8   xpdGain;
+    u8   xpd;
+    u8   iqCalICh[AR5416_EEP4K_MAX_CHAINS];
+    u8   iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
+    u8   pdGainOverlap;
+    u8   ob_01;
+    u8   db1_01;
+    u8   xpaBiasLvl;
+    u8   txFrameToDataStart;
+    u8   txFrameToPaOn;
+    u8   ht40PowerIncForPdadc;
+    u8   bswAtten[AR5416_EEP4K_MAX_CHAINS];
+    u8   bswMargin[AR5416_EEP4K_MAX_CHAINS];
+    u8   swSettleHt40;
+    u8   xatten2Db[AR5416_EEP4K_MAX_CHAINS];
+    u8   xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
+    u8   db2_01;
+    u8   version;
+    u16  ob_234;
+    u16  db1_234;
+    u16  db2_234;
+    u8   futureModal[4];
+
+    struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
+} __packed;
+
+
 struct cal_data_per_freq {
 	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
 	u8 vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
 } __packed;
 
+struct cal_data_per_freq_4k {
+	u8 pwrPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
+} __packed;
+
 struct cal_target_power_leg {
 	u8 bChannel;
 	u8 tPow2x[4];
@@ -574,6 +651,7 @@ struct cal_target_power_ht {
 	u8 tPow2x[8];
 } __packed;
 
+
 #ifdef __BIG_ENDIAN_BITFIELD
 struct cal_ctl_edges {
 	u8 bChannel;
@@ -588,10 +666,15 @@ struct cal_ctl_edges {
 
 struct cal_ctl_data {
 	struct cal_ctl_edges
-	 ctlEdges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
+	ctlEdges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
+} __packed;
+
+struct cal_ctl_data_4k {
+	struct cal_ctl_edges
+	ctlEdges[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_BAND_EDGES];
 } __packed;
 
-struct ar5416_eeprom {
+struct ar5416_eeprom_def {
 	struct base_eep_header baseEepHeader;
 	u8 custData[64];
 	struct modal_eep_header modalHeader[2];
@@ -620,6 +703,26 @@ struct ar5416_eeprom {
 	u8 padding;
 } __packed;
 
+struct ar5416_eeprom_4k {
+	struct base_eep_header_4k baseEepHeader;
+	u8 custData[20];
+	struct modal_eep_4k_header modalHeader;
+	u8 calFreqPier2G[AR5416_EEP4K_NUM_2G_CAL_PIERS];
+	struct cal_data_per_freq_4k
+	calPierData2G[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	calTargetPowerCck[AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	calTargetPower2G[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT20[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT40[AR5416_EEP4K_NUM_2G_40_TARGET_POWERS];
+	u8 ctlIndex[AR5416_EEP4K_NUM_CTLS];
+	struct cal_ctl_data_4k ctlData[AR5416_EEP4K_NUM_CTLS];
+	u8 padding;
+} __packed;
+
 struct ar5416IniArray {
 	u32 *ia_array;
 	u32 ia_rows;
@@ -687,9 +790,22 @@ struct hal_cal_list {
 	struct hal_cal_list *calNext;
 };
 
+/*
+ * Enum to indentify the eeprom mappings
+ */
+enum hal_eep_map {
+	EEP_MAP_DEFAULT = 0x0,
+	EEP_MAP_4KBITS,
+	EEP_MAP_MAX
+};
+
+
 struct ath_hal_5416 {
 	struct ath_hal ah;
-	struct ar5416_eeprom ah_eeprom;
+	union {
+		struct ar5416_eeprom_def def;
+		struct ar5416_eeprom_4k map4k;
+	} ah_eeprom;
 	struct ar5416Stats ah_stats;
 	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
 	void __iomem *ah_cal_mem;
@@ -813,6 +929,8 @@ struct ath_hal_5416 {
 	struct ar5416IniArray ah_iniModesAdditional;
 	struct ar5416IniArray ah_iniModesRxGain;
 	struct ar5416IniArray ah_iniModesTxGain;
+	/* To indicate EEPROM mapping used */
+	enum hal_eep_map ah_eep_map;
 };
 #define AH5416(_ah) ((struct ath_hal_5416 *)(_ah))
 
@@ -854,13 +972,20 @@ struct ath_hal_5416 {
 	(AR_SREV_9100(ah)) ? 0x1fff1000 : 0x503f1200
 #define AR5416_EEPROM_MAX           0xae0
 #define ar5416_get_eep_ver(_ahp) \
-	(((_ahp)->ah_eeprom.baseEepHeader.version >> 12) & 0xF)
+	(((_ahp)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
 #define ar5416_get_eep_rev(_ahp) \
-	(((_ahp)->ah_eeprom.baseEepHeader.version) & 0xFFF)
+	(((_ahp)->ah_eeprom.def.baseEepHeader.version) & 0xFFF)
 #define ar5416_get_ntxchains(_txchainmask) \
 	(((_txchainmask >> 2) & 1) + \
 		((_txchainmask >> 1) & 1) + (_txchainmask & 1))
 
+/* EEPROM 4K bit map definations */
+#define ar5416_get_eep4k_ver(_ahp)   \
+    (((_ahp)->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF)
+#define ar5416_get_eep4k_rev(_ahp)   \
+    (((_ahp)->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF)
+
+
 #ifdef __BIG_ENDIAN
 #define AR5416_EEPROM_MAGIC 0x5aa5
 #else
diff --git a/drivers/net/wireless/ath9k/mac.c b/drivers/net/wireless/ath9k/mac.c
index a4e9898..5254ea4 100644
--- a/drivers/net/wireless/ath9k/mac.c
+++ b/drivers/net/wireless/ath9k/mac.c
@@ -916,12 +916,12 @@ void ath9k_hw_rxena(struct ath_hal *ah)
 
 void ath9k_hw_startpcureceive(struct ath_hal *ah)
 {
-	REG_CLR_BIT(ah, AR_DIAG_SW,
-		    (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
 	ath9k_enable_mib_counters(ah);
 
 	ath9k_ani_reset(ah);
+
 }
 
 void ath9k_hw_stoppcurecv(struct ath_hal *ah)
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 9939749..f1a1e4d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -34,6 +34,7 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0027) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
 	{ 0 }
 };
 
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 1470234..3a406a5 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -50,6 +50,9 @@ bool ath9k_hw_init_rf(struct ath_hal *ah,
 #define AR_PHY_FC_SHORT_GI_40       0x00000080
 #define AR_PHY_FC_WALSH             0x00000100
 #define AR_PHY_FC_SINGLE_HT_LTF1    0x00000200
+#define AR_PHY_FC_ENABLE_DAC_FIFO   0x00000800
+
+#define AR_PHY_TEST2 		    0x9808
 
 #define AR_PHY_TIMING2           0x9810
 #define AR_PHY_TIMING3           0x9814
@@ -100,6 +103,8 @@ bool ath9k_hw_init_rf(struct ath_hal *ah,
 #define AR_PHY_RF_CTL4_FRAME_XPAA_ON      0x000000FF
 #define AR_PHY_RF_CTL4_FRAME_XPAA_ON_S    0
 
+#define AR_PHY_TSTDAC_CONST               0x983c
+
 #define AR_PHY_SETTLING          0x9844
 #define AR_PHY_SETTLING_SWITCH   0x00003F80
 #define AR_PHY_SETTLING_SWITCH_S 7
-- 
1.6.0.4

