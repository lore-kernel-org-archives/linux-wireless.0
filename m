Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42686 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZBIII5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:08:57 -0500
Received: from mail.atheros.com ([10.10.21.49])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:08:57 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57828.170128.720390@gargle.gargle.HOWL> (sfid-20090209_090904_673009_7E59908D)
Date: Mon, 9 Feb 2009 13:27:24 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 09/10] ath9k: Cleanup EEPROM operations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the various function pointer
assignments and unifies them in a single ops structure.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c  |    4 +-
 drivers/net/wireless/ath9k/eeprom.c | 2828 +++++++++++++++++------------------
 drivers/net/wireless/ath9k/eeprom.h |   30 +-
 drivers/net/wireless/ath9k/hw.c     |   72 +-
 drivers/net/wireless/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath9k/phy.c    |   10 +-
 6 files changed, 1453 insertions(+), 1492 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 8c44d5a..7e70a81 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -172,10 +172,10 @@ static bool getNoiseFloorThresh(struct ath_hw *ah,
 {
 	switch (band) {
 	case IEEE80211_BAND_5GHZ:
-		*nft = (int8_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_5);
+		*nft = (int8_t)ah->eep_ops->get_eeprom(ah, EEP_NFTHRESH_5);
 		break;
 	case IEEE80211_BAND_2GHZ:
-		*nft = (int8_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_2);
+		*nft = (int8_t)ah->eep_ops->get_eeprom(ah, EEP_NFTHRESH_2);
 		break;
 	default:
 		BUG_ON(1);
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 94e7993..2e604e1 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -95,195 +95,216 @@ static inline bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 	return sc->bus_ops->eeprom_read(ah, off, data);
 }
 
-static bool ath9k_hw_fill_4k_eeprom(struct ath_hw *ah)
+static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
+					   u8 *pVpdList, u16 numIntercepts,
+					   u8 *pRetVpdList)
 {
-#define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
-	u16 *eep_data;
-	int addr, eep_start_loc = 0;
-
-	eep_start_loc = 64;
+	u16 i, k;
+	u8 currPwr = pwrMin;
+	u16 idxL = 0, idxR = 0;
 
-	if (!ath9k_hw_use_flash(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"Reading from EEPROM, not flash\n");
+	for (i = 0; i <= (pwrMax - pwrMin) / 2; i++) {
+		ath9k_hw_get_lower_upper_index(currPwr, pPwrList,
+					       numIntercepts, &(idxL),
+					       &(idxR));
+		if (idxR < 1)
+			idxR = 1;
+		if (idxL == numIntercepts - 1)
+			idxL = (u16) (numIntercepts - 2);
+		if (pPwrList[idxL] == pPwrList[idxR])
+			k = pVpdList[idxL];
+		else
+			k = (u16)(((currPwr - pPwrList[idxL]) * pVpdList[idxR] +
+				   (pPwrList[idxR] - currPwr) * pVpdList[idxL]) /
+				  (pPwrList[idxR] - pPwrList[idxL]));
+		pRetVpdList[i] = (u8) k;
+		currPwr += 2;
 	}
 
-	eep_data = (u16 *)eep;
-
-	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
-		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			       "Unable to read eeprom region \n");
-			return false;
-		}
-		eep_data++;
-	}
 	return true;
-#undef SIZE_EEPROM_4K
 }
 
-static bool ath9k_hw_fill_def_eeprom(struct ath_hw *ah)
+static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
+				      struct ath9k_channel *chan,
+				      struct cal_target_power_leg *powInfo,
+				      u16 numChannels,
+				      struct cal_target_power_leg *pNewPower,
+				      u16 numRates, bool isExtTarget)
 {
-#define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
-	u16 *eep_data;
-	int addr, ar5416_eep_start_loc = 0x100;
+	struct chan_centers centers;
+	u16 clo, chi;
+	int i;
+	int matchIndex = -1, lowIndex = -1;
+	u16 freq;
 
-	eep_data = (u16 *)eep;
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = (isExtTarget) ? centers.ext_center : centers.ctl_center;
 
-	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
-		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
-					 eep_data)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Unable to read eeprom region\n");
-			return false;
+	if (freq <= ath9k_hw_fbin2freq(powInfo[0].bChannel,
+				       IS_CHAN_2GHZ(chan))) {
+		matchIndex = 0;
+	} else {
+		for (i = 0; (i < numChannels) &&
+			     (powInfo[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
+			if (freq == ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						       IS_CHAN_2GHZ(chan))) {
+				matchIndex = i;
+				break;
+			} else if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						      IS_CHAN_2GHZ(chan))) &&
+				   (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
+						      IS_CHAN_2GHZ(chan)))) {
+				lowIndex = i - 1;
+				break;
+			}
 		}
-		eep_data++;
+		if ((matchIndex == -1) && (lowIndex == -1))
+			matchIndex = i - 1;
 	}
-	return true;
-#undef SIZE_EEPROM_DEF
-}
 
-static bool (*ath9k_fill_eeprom[]) (struct ath_hw *) = {
-	ath9k_hw_fill_def_eeprom,
-	ath9k_hw_fill_4k_eeprom
-};
+	if (matchIndex != -1) {
+		*pNewPower = powInfo[matchIndex];
+	} else {
+		clo = ath9k_hw_fbin2freq(powInfo[lowIndex].bChannel,
+					 IS_CHAN_2GHZ(chan));
+		chi = ath9k_hw_fbin2freq(powInfo[lowIndex + 1].bChannel,
+					 IS_CHAN_2GHZ(chan));
 
-static inline bool ath9k_hw_fill_eeprom(struct ath_hw *ah)
-{
-	return ath9k_fill_eeprom[ah->ah_eep_map](ah);
+		for (i = 0; i < numRates; i++) {
+			pNewPower->tPow2x[i] =
+				(u8)ath9k_hw_interpolate(freq, clo, chi,
+						powInfo[lowIndex].tPow2x[i],
+						powInfo[lowIndex + 1].tPow2x[i]);
+		}
+	}
 }
 
-static int ath9k_hw_check_def_eeprom(struct ath_hw *ah)
+static void ath9k_hw_get_target_powers(struct ath_hw *ah,
+				       struct ath9k_channel *chan,
+				       struct cal_target_power_ht *powInfo,
+				       u16 numChannels,
+				       struct cal_target_power_ht *pNewPower,
+				       u16 numRates, bool isHt40Target)
 {
-	struct ar5416_eeprom_def *eep =
-		(struct ar5416_eeprom_def *) &ah->ah_eeprom.def;
-	u16 *eepdata, temp, magic, magic2;
-	u32 sum = 0, el;
-	bool need_swap = false;
-	int i, addr, size;
-
-	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
-				 &magic)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"Reading Magic # failed\n");
-		return false;
-	}
-
-	if (!ath9k_hw_use_flash(ah)) {
+	struct chan_centers centers;
+	u16 clo, chi;
+	int i;
+	int matchIndex = -1, lowIndex = -1;
+	u16 freq;
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Read Magic = 0x%04X\n", magic);
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = isHt40Target ? centers.synth_center : centers.ctl_center;
 
-		if (magic != AR5416_EEPROM_MAGIC) {
-			magic2 = swab16(magic);
+	if (freq <= ath9k_hw_fbin2freq(powInfo[0].bChannel, IS_CHAN_2GHZ(chan))) {
+		matchIndex = 0;
+	} else {
+		for (i = 0; (i < numChannels) &&
+			     (powInfo[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
+			if (freq == ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						       IS_CHAN_2GHZ(chan))) {
+				matchIndex = i;
+				break;
+			} else
+				if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						       IS_CHAN_2GHZ(chan))) &&
+				    (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
+						       IS_CHAN_2GHZ(chan)))) {
+					lowIndex = i - 1;
+					break;
+				}
+		}
+		if ((matchIndex == -1) && (lowIndex == -1))
+			matchIndex = i - 1;
+	}
 
-			if (magic2 == AR5416_EEPROM_MAGIC) {
-				size = sizeof(struct ar5416_eeprom_def);
-				need_swap = true;
-				eepdata = (u16 *) (&ah->ah_eeprom);
+	if (matchIndex != -1) {
+		*pNewPower = powInfo[matchIndex];
+	} else {
+		clo = ath9k_hw_fbin2freq(powInfo[lowIndex].bChannel,
+					 IS_CHAN_2GHZ(chan));
+		chi = ath9k_hw_fbin2freq(powInfo[lowIndex + 1].bChannel,
+					 IS_CHAN_2GHZ(chan));
 
-				for (addr = 0; addr < size / sizeof(u16); addr++) {
-					temp = swab16(*eepdata);
-					*eepdata = temp;
-					eepdata++;
+		for (i = 0; i < numRates; i++) {
+			pNewPower->tPow2x[i] = (u8)ath9k_hw_interpolate(freq,
+						clo, chi,
+						powInfo[lowIndex].tPow2x[i],
+						powInfo[lowIndex + 1].tPow2x[i]);
+		}
+	}
+}
 
-					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-						"0x%04X  ", *eepdata);
+static u16 ath9k_hw_get_max_edge_power(u16 freq,
+				       struct cal_ctl_edges *pRdEdgesPower,
+				       bool is2GHz, int num_band_edges)
+{
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	int i;
 
-					if (((addr + 1) % 6) == 0)
-						DPRINTF(ah->ah_sc,
-							ATH_DBG_EEPROM, "\n");
-				}
-			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-					"Invalid EEPROM Magic. "
-					"endianness mismatch.\n");
-				return -EINVAL;
+	for (i = 0; (i < num_band_edges) &&
+		     (pRdEdgesPower[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
+		if (freq == ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel, is2GHz)) {
+			twiceMaxEdgePower = pRdEdgesPower[i].tPower;
+			break;
+		} else if ((i > 0) &&
+			   (freq < ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel,
+						      is2GHz))) {
+			if (ath9k_hw_fbin2freq(pRdEdgesPower[i - 1].bChannel,
+					       is2GHz) < freq &&
+			    pRdEdgesPower[i - 1].flag) {
+				twiceMaxEdgePower =
+					pRdEdgesPower[i - 1].tPower;
 			}
+			break;
 		}
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n",
-		need_swap ? "True" : "False");
+	return twiceMaxEdgePower;
+}
 
-	if (need_swap)
-		el = swab16(ah->ah_eeprom.def.baseEepHeader.length);
-	else
-		el = ah->ah_eeprom.def.baseEepHeader.length;
+/****************************************/
+/* EEPROM Operations for 4K sized cards */
+/****************************************/
 
-	if (el > sizeof(struct ar5416_eeprom_def))
-		el = sizeof(struct ar5416_eeprom_def) / sizeof(u16);
-	else
-		el = el / sizeof(u16);
+static int ath9k_hw_4k_get_eeprom_ver(struct ath_hw *ah)
+{
+	return ((ah->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF);
+}
 
-	eepdata = (u16 *)(&ah->ah_eeprom);
+static int ath9k_hw_4k_get_eeprom_rev(struct ath_hw *ah)
+{
+	return ((ah->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF);
+}
 
-	for (i = 0; i < el; i++)
-		sum ^= *eepdata++;
+static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
+{
+#define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	u16 *eep_data;
+	int addr, eep_start_loc = 0;
 
-	if (need_swap) {
-		u32 integer, j;
-		u16 word;
+	eep_start_loc = 64;
 
+	if (!ath9k_hw_use_flash(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"EEPROM Endianness is not native.. Changing \n");
-
-		word = swab16(eep->baseEepHeader.length);
-		eep->baseEepHeader.length = word;
-
-		word = swab16(eep->baseEepHeader.checksum);
-		eep->baseEepHeader.checksum = word;
-
-		word = swab16(eep->baseEepHeader.version);
-		eep->baseEepHeader.version = word;
-
-		word = swab16(eep->baseEepHeader.regDmn[0]);
-		eep->baseEepHeader.regDmn[0] = word;
-
-		word = swab16(eep->baseEepHeader.regDmn[1]);
-		eep->baseEepHeader.regDmn[1] = word;
-
-		word = swab16(eep->baseEepHeader.rfSilent);
-		eep->baseEepHeader.rfSilent = word;
-
-		word = swab16(eep->baseEepHeader.blueToothOptions);
-		eep->baseEepHeader.blueToothOptions = word;
-
-		word = swab16(eep->baseEepHeader.deviceCap);
-		eep->baseEepHeader.deviceCap = word;
-
-		for (j = 0; j < ARRAY_SIZE(eep->modalHeader); j++) {
-			struct modal_eep_header *pModal =
-				&eep->modalHeader[j];
-			integer = swab32(pModal->antCtrlCommon);
-			pModal->antCtrlCommon = integer;
+			"Reading from EEPROM, not flash\n");
+	}
 
-			for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-				integer = swab32(pModal->antCtrlChain[i]);
-				pModal->antCtrlChain[i] = integer;
-			}
+	eep_data = (u16 *)eep;
 
-			for (i = 0; i < AR5416_EEPROM_MODAL_SPURS; i++) {
-				word = swab16(pModal->spurChans[i].spurChan);
-				pModal->spurChans[i].spurChan = word;
-			}
+	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
+		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			       "Unable to read eeprom region \n");
+			return false;
 		}
+		eep_data++;
 	}
-
-	if (sum != 0xffff || ar5416_get_eep_ver(ah) != AR5416_EEP_VER ||
-	    ar5416_get_eep_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ar5416_get_eep_ver(ah));
-		return -EINVAL;
-	}
-
-	return 0;
+	return true;
+#undef SIZE_EEPROM_4K
 }
 
-static int ath9k_hw_check_4k_eeprom(struct ath_hw *ah)
+static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 {
 #define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
 	struct ar5416_eeprom_4k *eep =
@@ -397,11 +418,11 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hw *ah)
 		}
 	}
 
-	if (sum != 0xffff || ar5416_get_eep4k_ver(ah) != AR5416_EEP_VER ||
-	    ar5416_get_eep4k_rev(ah) < AR5416_EEP_NO_BACK_VER) {
+	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
+	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
-			sum, ar5416_get_eep4k_ver(ah));
+			sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
 	}
 
@@ -409,43 +430,45 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hw *ah)
 #undef EEPROM_4K_SIZE
 }
 
-static int (*ath9k_check_eeprom[]) (struct ath_hw *) = {
-	ath9k_hw_check_def_eeprom,
-	ath9k_hw_check_4k_eeprom
-};
-
-static inline int ath9k_hw_check_eeprom(struct ath_hw *ah)
-{
-	return ath9k_check_eeprom[ah->ah_eep_map](ah);
-}
-
-static inline bool ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
-					   u8 *pVpdList, u16 numIntercepts,
-					   u8 *pRetVpdList)
+static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
+				  enum eeprom_param param)
 {
-	u16 i, k;
-	u8 currPwr = pwrMin;
-	u16 idxL = 0, idxR = 0;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &eep->modalHeader;
+	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
 
-	for (i = 0; i <= (pwrMax - pwrMin) / 2; i++) {
-		ath9k_hw_get_lower_upper_index(currPwr, pPwrList,
-					       numIntercepts, &(idxL),
-					       &(idxR));
-		if (idxR < 1)
-			idxR = 1;
-		if (idxL == numIntercepts - 1)
-			idxL = (u16) (numIntercepts - 2);
-		if (pPwrList[idxL] == pPwrList[idxR])
-			k = pVpdList[idxL];
-		else
-			k = (u16)(((currPwr - pPwrList[idxL]) * pVpdList[idxR] +
-				   (pPwrList[idxR] - currPwr) * pVpdList[idxL]) /
-				  (pPwrList[idxR] - pPwrList[idxL]));
-		pRetVpdList[i] = (u8) k;
-		currPwr += 2;
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
 	}
-
-	return true;
 }
 
 static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
@@ -616,435 +639,6 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 #undef TMP_VAL_VPD_TABLE
 }
 
-static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
-				struct ath9k_channel *chan,
-				struct cal_data_per_freq *pRawDataSet,
-				u8 *bChans, u16 availPiers,
-				u16 tPdGainOverlap, int16_t *pMinCalPower,
-				u16 *pPdGainBoundaries, u8 *pPDADCValues,
-				u16 numXpdGains)
-{
-	int i, j, k;
-	int16_t ss;
-	u16 idxL = 0, idxR = 0, numPiers;
-	static u8 vpdTableL[AR5416_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableR[AR5416_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableI[AR5416_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-
-	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR5416_NUM_PD_GAINS];
-	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
-	int16_t vpdStep;
-	int16_t tmpVal;
-	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
-	bool match;
-	int16_t minDelta = 0;
-	struct chan_centers centers;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-
-	for (numPiers = 0; numPiers < availPiers; numPiers++) {
-		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
-			break;
-	}
-
-	match = ath9k_hw_get_lower_upper_index((u8)FREQ2FBIN(centers.synth_center,
-							     IS_CHAN_2GHZ(chan)),
-					       bChans, numPiers, &idxL, &idxR);
-
-	if (match) {
-		for (i = 0; i < numXpdGains; i++) {
-			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
-			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-					pRawDataSet[idxL].pwrPdg[i],
-					pRawDataSet[idxL].vpdPdg[i],
-					AR5416_PD_GAIN_ICEPTS,
-					vpdTableI[i]);
-		}
-	} else {
-		for (i = 0; i < numXpdGains; i++) {
-			pVpdL = pRawDataSet[idxL].vpdPdg[i];
-			pPwrL = pRawDataSet[idxL].pwrPdg[i];
-			pVpdR = pRawDataSet[idxR].vpdPdg[i];
-			pPwrR = pRawDataSet[idxR].pwrPdg[i];
-
-			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
-
-			maxPwrT4[i] =
-				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
-				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
-
-
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrL, pVpdL,
-						AR5416_PD_GAIN_ICEPTS,
-						vpdTableL[i]);
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrR, pVpdR,
-						AR5416_PD_GAIN_ICEPTS,
-						vpdTableR[i]);
-
-			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
-				vpdTableI[i][j] =
-					(u8)(ath9k_hw_interpolate((u16)
-					     FREQ2FBIN(centers.
-						       synth_center,
-						       IS_CHAN_2GHZ
-						       (chan)),
-					     bChans[idxL], bChans[idxR],
-					     vpdTableL[i][j], vpdTableR[i][j]));
-			}
-		}
-	}
-
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
-
-	k = 0;
-
-	for (i = 0; i < numXpdGains; i++) {
-		if (i == (numXpdGains - 1))
-			pPdGainBoundaries[i] =
-				(u16)(maxPwrT4[i] / 2);
-		else
-			pPdGainBoundaries[i] =
-				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
-
-		pPdGainBoundaries[i] =
-			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
-
-		if ((i == 0) && !AR_SREV_5416_V20_OR_LATER(ah)) {
-			minDelta = pPdGainBoundaries[0] - 23;
-			pPdGainBoundaries[0] = 23;
-		} else {
-			minDelta = 0;
-		}
-
-		if (i == 0) {
-			if (AR_SREV_9280_10_OR_LATER(ah))
-				ss = (int16_t)(0 - (minPwrT4[i] / 2));
-			else
-				ss = 0;
-		} else {
-			ss = (int16_t)((pPdGainBoundaries[i - 1] -
-					(minPwrT4[i] / 2)) -
-				       tPdGainOverlap + 1 + minDelta);
-		}
-		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
-			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
-			ss++;
-		}
-
-		sizeCurrVpdTable = (u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
-		tgtIndex = (u8)(pPdGainBoundaries[i] + tPdGainOverlap -
-				(minPwrT4[i] / 2));
-		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
-			tgtIndex : sizeCurrVpdTable;
-
-		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-			pPDADCValues[k++] = vpdTableI[i][ss++];
-		}
-
-		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
-				    vpdTableI[i][sizeCurrVpdTable - 2]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		if (tgtIndex > maxIndex) {
-			while ((ss <= tgtIndex) &&
-			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-				tmpVal = (int16_t)((vpdTableI[i][sizeCurrVpdTable - 1] +
-						    (ss - maxIndex + 1) * vpdStep));
-				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
-							 255 : tmpVal);
-				ss++;
-			}
-		}
-	}
-
-	while (i < AR5416_PD_GAINS_IN_MASK) {
-		pPdGainBoundaries[i] = pPdGainBoundaries[i - 1];
-		i++;
-	}
-
-	while (k < AR5416_NUM_PDADC_VALUES) {
-		pPDADCValues[k] = pPDADCValues[k - 1];
-		k++;
-	}
-
-	return;
-}
-
-static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
-				      struct ath9k_channel *chan,
-				      struct cal_target_power_leg *powInfo,
-				      u16 numChannels,
-				      struct cal_target_power_leg *pNewPower,
-				      u16 numRates, bool isExtTarget)
-{
-	struct chan_centers centers;
-	u16 clo, chi;
-	int i;
-	int matchIndex = -1, lowIndex = -1;
-	u16 freq;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	freq = (isExtTarget) ? centers.ext_center : centers.ctl_center;
-
-	if (freq <= ath9k_hw_fbin2freq(powInfo[0].bChannel,
-				       IS_CHAN_2GHZ(chan))) {
-		matchIndex = 0;
-	} else {
-		for (i = 0; (i < numChannels) &&
-			     (powInfo[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
-			if (freq == ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						       IS_CHAN_2GHZ(chan))) {
-				matchIndex = i;
-				break;
-			} else if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						      IS_CHAN_2GHZ(chan))) &&
-				   (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
-						      IS_CHAN_2GHZ(chan)))) {
-				lowIndex = i - 1;
-				break;
-			}
-		}
-		if ((matchIndex == -1) && (lowIndex == -1))
-			matchIndex = i - 1;
-	}
-
-	if (matchIndex != -1) {
-		*pNewPower = powInfo[matchIndex];
-	} else {
-		clo = ath9k_hw_fbin2freq(powInfo[lowIndex].bChannel,
-					 IS_CHAN_2GHZ(chan));
-		chi = ath9k_hw_fbin2freq(powInfo[lowIndex + 1].bChannel,
-					 IS_CHAN_2GHZ(chan));
-
-		for (i = 0; i < numRates; i++) {
-			pNewPower->tPow2x[i] =
-				(u8)ath9k_hw_interpolate(freq, clo, chi,
-						powInfo[lowIndex].tPow2x[i],
-						powInfo[lowIndex + 1].tPow2x[i]);
-		}
-	}
-}
-
-static void ath9k_hw_get_target_powers(struct ath_hw *ah,
-				       struct ath9k_channel *chan,
-				       struct cal_target_power_ht *powInfo,
-				       u16 numChannels,
-				       struct cal_target_power_ht *pNewPower,
-				       u16 numRates, bool isHt40Target)
-{
-	struct chan_centers centers;
-	u16 clo, chi;
-	int i;
-	int matchIndex = -1, lowIndex = -1;
-	u16 freq;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	freq = isHt40Target ? centers.synth_center : centers.ctl_center;
-
-	if (freq <= ath9k_hw_fbin2freq(powInfo[0].bChannel, IS_CHAN_2GHZ(chan))) {
-		matchIndex = 0;
-	} else {
-		for (i = 0; (i < numChannels) &&
-			     (powInfo[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
-			if (freq == ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						       IS_CHAN_2GHZ(chan))) {
-				matchIndex = i;
-				break;
-			} else
-				if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						       IS_CHAN_2GHZ(chan))) &&
-				    (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
-						       IS_CHAN_2GHZ(chan)))) {
-					lowIndex = i - 1;
-					break;
-				}
-		}
-		if ((matchIndex == -1) && (lowIndex == -1))
-			matchIndex = i - 1;
-	}
-
-	if (matchIndex != -1) {
-		*pNewPower = powInfo[matchIndex];
-	} else {
-		clo = ath9k_hw_fbin2freq(powInfo[lowIndex].bChannel,
-					 IS_CHAN_2GHZ(chan));
-		chi = ath9k_hw_fbin2freq(powInfo[lowIndex + 1].bChannel,
-					 IS_CHAN_2GHZ(chan));
-
-		for (i = 0; i < numRates; i++) {
-			pNewPower->tPow2x[i] = (u8)ath9k_hw_interpolate(freq,
-						clo, chi,
-						powInfo[lowIndex].tPow2x[i],
-						powInfo[lowIndex + 1].tPow2x[i]);
-		}
-	}
-}
-
-static u16 ath9k_hw_get_max_edge_power(u16 freq,
-				       struct cal_ctl_edges *pRdEdgesPower,
-				       bool is2GHz, int num_band_edges)
-{
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	int i;
-
-	for (i = 0; (i < num_band_edges) &&
-		     (pRdEdgesPower[i].bChannel != AR5416_BCHAN_UNUSED); i++) {
-		if (freq == ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel, is2GHz)) {
-			twiceMaxEdgePower = pRdEdgesPower[i].tPower;
-			break;
-		} else if ((i > 0) &&
-			   (freq < ath9k_hw_fbin2freq(pRdEdgesPower[i].bChannel,
-						      is2GHz))) {
-			if (ath9k_hw_fbin2freq(pRdEdgesPower[i - 1].bChannel,
-					       is2GHz) < freq &&
-			    pRdEdgesPower[i - 1].flag) {
-				twiceMaxEdgePower =
-					pRdEdgesPower[i - 1].tPower;
-			}
-			break;
-		}
-	}
-
-	return twiceMaxEdgePower;
-}
-
-static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
-				  struct ath9k_channel *chan,
-				  int16_t *pTxPowerIndexOffset)
-{
-	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
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
-
-	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
-	xpdMask = pEepData->modalHeader[modalIdx].xpdGain;
-
-	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
-	    AR5416_EEP_MINOR_VER_2) {
-		pdGainOverlap_t2 =
-			pEepData->modalHeader[modalIdx].pdGainOverlap;
-	} else {
-		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
-					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
-	}
-
-	if (IS_CHAN_2GHZ(chan)) {
-		pCalBChans = pEepData->calFreqPier2G;
-		numPiers = AR5416_NUM_2G_CAL_PIERS;
-	} else {
-		pCalBChans = pEepData->calFreqPier5G;
-		numPiers = AR5416_NUM_5G_CAL_PIERS;
-	}
-
-	numXpdGain = 0;
-
-	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
-		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
-			if (numXpdGain >= AR5416_NUM_PD_GAINS)
-				break;
-			xpdGainValues[numXpdGain] =
-				(u16)(AR5416_PD_GAINS_IN_MASK - i);
-			numXpdGain++;
-		}
-	}
-
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
-		      (numXpdGain - 1) & 0x3);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
-		      xpdGainValues[0]);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
-		      xpdGainValues[1]);
-	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
-		      xpdGainValues[2]);
-
-	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		if (AR_SREV_5416_V20_OR_LATER(ah) &&
-		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5) &&
-		    (i != 0)) {
-			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
-		} else
-			regChainOffset = i * 0x1000;
-
-		if (pEepData->baseEepHeader.txMask & (1 << i)) {
-			if (IS_CHAN_2GHZ(chan))
-				pRawDataset = pEepData->calPierData2G[i];
-			else
-				pRawDataset = pEepData->calPierData5G[i];
-
-			ath9k_hw_get_def_gain_boundaries_pdadcs(ah, chan,
-					    pRawDataset, pCalBChans,
-					    numPiers, pdGainOverlap_t2,
-					    &tMinCalPower, gainBoundaries,
-					    pdadcValues, numXpdGain);
-
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
-
-			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
-			for (j = 0; j < 32; j++) {
-				reg32 = ((pdadcValues[4 * j + 0] & 0xFF) << 0) |
-					((pdadcValues[4 * j + 1] & 0xFF) << 8) |
-					((pdadcValues[4 * j + 2] & 0xFF) << 16)|
-					((pdadcValues[4 * j + 3] & 0xFF) << 24);
-				REG_WRITE(ah, regOffset, reg32);
-
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-					"PDADC (%d,%4x): %4.4x %8.8x\n",
-					i, regChainOffset, regOffset,
-					reg32);
-				DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
-					"PDADC: Chain %d | PDADC %3d "
-					"Value %3d | PDADC %3d Value %3d | "
-					"PDADC %3d Value %3d | PDADC %3d "
-					"Value %3d |\n",
-					i, 4 * j, pdadcValues[4 * j],
-					4 * j + 1, pdadcValues[4 * j + 1],
-					4 * j + 2, pdadcValues[4 * j + 2],
-					4 * j + 3,
-					pdadcValues[4 * j + 3]);
-
-				regOffset += 4;
-			}
-		}
-	}
-
-	*pTxPowerIndexOffset = 0;
-
-	return true;
-}
-
 static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
@@ -1161,296 +755,6 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	return true;
 }
 
-static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
-						  struct ath9k_channel *chan,
-						  int16_t *ratesArray,
-						  u16 cfgCtl,
-						  u16 AntennaReduction,
-						  u16 twiceMaxRegulatoryPower,
-						  u16 powerLimit)
-{
-#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
-
-	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
-
-	int i;
-	int16_t twiceLargestAntenna;
-	struct cal_ctl_data *rep;
-	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
-		0, { 0, 0, 0, 0}
-	};
-	struct cal_target_power_leg targetPowerOfdmExt = {
-		0, { 0, 0, 0, 0} }, targetPowerCckExt = {
-		0, { 0, 0, 0, 0 }
-	};
-	struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
-		0, {0, 0, 0, 0}
-	};
-	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
-	u16 ctlModesFor11a[] =
-		{ CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40 };
-	u16 ctlModesFor11g[] =
-		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
-		  CTL_2GHT40
-		};
-	u16 numCtlModes, *pCtlMode, ctlMode, freq;
-	struct chan_centers centers;
-	int tx_chainmask;
-	u16 twiceMinEdgePower;
-
-	tx_chainmask = ah->ah_txchainmask;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-
-	twiceLargestAntenna = max(
-		pEepData->modalHeader
-			[IS_CHAN_2GHZ(chan)].antennaGainCh[0],
-		pEepData->modalHeader
-			[IS_CHAN_2GHZ(chan)].antennaGainCh[1]);
-
-	twiceLargestAntenna = max((u8)twiceLargestAntenna,
-				  pEepData->modalHeader
-				  [IS_CHAN_2GHZ(chan)].antennaGainCh[2]);
-
-	twiceLargestAntenna = (int16_t)min(AntennaReduction -
-					   twiceLargestAntenna, 0);
-
-	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
-
-	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
-		maxRegAllowedPower -=
-			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
-	}
-
-	scaledPower = min(powerLimit, maxRegAllowedPower);
-
-	switch (ar5416_get_ntxchains(tx_chainmask)) {
-	case 1:
-		break;
-	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
-		break;
-	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
-		break;
-	}
-
-	scaledPower = max((u16)0, scaledPower);
-
-	if (IS_CHAN_2GHZ(chan)) {
-		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
-			SUB_NUM_CTL_MODES_AT_2G_40;
-		pCtlMode = ctlModesFor11g;
-
-		ath9k_hw_get_legacy_target_powers(ah, chan,
-			pEepData->calTargetPowerCck,
-			AR5416_NUM_2G_CCK_TARGET_POWERS,
-			&targetPowerCck, 4, false);
-		ath9k_hw_get_legacy_target_powers(ah, chan,
-			pEepData->calTargetPower2G,
-			AR5416_NUM_2G_20_TARGET_POWERS,
-			&targetPowerOfdm, 4, false);
-		ath9k_hw_get_target_powers(ah, chan,
-			pEepData->calTargetPower2GHT20,
-			AR5416_NUM_2G_20_TARGET_POWERS,
-			&targetPowerHt20, 8, false);
-
-		if (IS_CHAN_HT40(chan)) {
-			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
-			ath9k_hw_get_target_powers(ah, chan,
-				pEepData->calTargetPower2GHT40,
-				AR5416_NUM_2G_40_TARGET_POWERS,
-				&targetPowerHt40, 8, true);
-			ath9k_hw_get_legacy_target_powers(ah, chan,
-				pEepData->calTargetPowerCck,
-				AR5416_NUM_2G_CCK_TARGET_POWERS,
-				&targetPowerCckExt, 4, true);
-			ath9k_hw_get_legacy_target_powers(ah, chan,
-				pEepData->calTargetPower2G,
-				AR5416_NUM_2G_20_TARGET_POWERS,
-				&targetPowerOfdmExt, 4, true);
-		}
-	} else {
-		numCtlModes = ARRAY_SIZE(ctlModesFor11a) -
-			SUB_NUM_CTL_MODES_AT_5G_40;
-		pCtlMode = ctlModesFor11a;
-
-		ath9k_hw_get_legacy_target_powers(ah, chan,
-			pEepData->calTargetPower5G,
-			AR5416_NUM_5G_20_TARGET_POWERS,
-			&targetPowerOfdm, 4, false);
-		ath9k_hw_get_target_powers(ah, chan,
-			pEepData->calTargetPower5GHT20,
-			AR5416_NUM_5G_20_TARGET_POWERS,
-			&targetPowerHt20, 8, false);
-
-		if (IS_CHAN_HT40(chan)) {
-			numCtlModes = ARRAY_SIZE(ctlModesFor11a);
-			ath9k_hw_get_target_powers(ah, chan,
-				pEepData->calTargetPower5GHT40,
-				AR5416_NUM_5G_40_TARGET_POWERS,
-				&targetPowerHt40, 8, true);
-			ath9k_hw_get_legacy_target_powers(ah, chan,
-				pEepData->calTargetPower5G,
-				AR5416_NUM_5G_20_TARGET_POWERS,
-				&targetPowerOfdmExt, 4, true);
-		}
-	}
-
-	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
-		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
-			(pCtlMode[ctlMode] == CTL_2GHT40);
-		if (isHt40CtlMode)
-			freq = centers.synth_center;
-		else if (pCtlMode[ctlMode] & EXT_ADDITIVE)
-			freq = centers.ext_center;
-		else
-			freq = centers.ctl_center;
-
-		if (ar5416_get_eep_ver(ah) == 14 && ar5416_get_eep_rev(ah) <= 2)
-			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
-			"EXT_ADDITIVE %d\n",
-			ctlMode, numCtlModes, isHt40CtlMode,
-			(pCtlMode[ctlMode] & EXT_ADDITIVE));
-
-		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
-			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
-				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
-				"chan %d\n",
-				i, cfgCtl, pCtlMode[ctlMode],
-				pEepData->ctlIndex[i], chan->channel);
-
-			if ((((cfgCtl & ~CTL_MODE_M) |
-			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			     pEepData->ctlIndex[i]) ||
-			    (((cfgCtl & ~CTL_MODE_M) |
-			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			     ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))) {
-				rep = &(pEepData->ctlData[i]);
-
-				twiceMinEdgePower = ath9k_hw_get_max_edge_power(freq,
-				rep->ctlEdges[ar5416_get_ntxchains(tx_chainmask) - 1],
-				IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
-
-				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-					"    MATCH-EE_IDX %d: ch %d is2 %d "
-					"2xMinEdge %d chainmask %d chains %d\n",
-					i, freq, IS_CHAN_2GHZ(chan),
-					twiceMinEdgePower, tx_chainmask,
-					ar5416_get_ntxchains
-					(tx_chainmask));
-				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
-					twiceMaxEdgePower = min(twiceMaxEdgePower,
-								twiceMinEdgePower);
-				} else {
-					twiceMaxEdgePower = twiceMinEdgePower;
-					break;
-				}
-			}
-		}
-
-		minCtlPower = min(twiceMaxEdgePower, scaledPower);
-
-		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-			"    SEL-Min ctlMode %d pCtlMode %d "
-			"2xMaxEdge %d sP %d minCtlPwr %d\n",
-			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
-			scaledPower, minCtlPower);
-
-		switch (pCtlMode[ctlMode]) {
-		case CTL_11B:
-			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x); i++) {
-				targetPowerCck.tPow2x[i] =
-					min((u16)targetPowerCck.tPow2x[i],
-					    minCtlPower);
-			}
-			break;
-		case CTL_11A:
-		case CTL_11G:
-			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x); i++) {
-				targetPowerOfdm.tPow2x[i] =
-					min((u16)targetPowerOfdm.tPow2x[i],
-					    minCtlPower);
-			}
-			break;
-		case CTL_5GHT20:
-		case CTL_2GHT20:
-			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++) {
-				targetPowerHt20.tPow2x[i] =
-					min((u16)targetPowerHt20.tPow2x[i],
-					    minCtlPower);
-			}
-			break;
-		case CTL_11B_EXT:
-			targetPowerCckExt.tPow2x[0] = min((u16)
-					targetPowerCckExt.tPow2x[0],
-					minCtlPower);
-			break;
-		case CTL_11A_EXT:
-		case CTL_11G_EXT:
-			targetPowerOfdmExt.tPow2x[0] = min((u16)
-					targetPowerOfdmExt.tPow2x[0],
-					minCtlPower);
-			break;
-		case CTL_5GHT40:
-		case CTL_2GHT40:
-			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
-				targetPowerHt40.tPow2x[i] =
-					min((u16)targetPowerHt40.tPow2x[i],
-					    minCtlPower);
-			}
-			break;
-		default:
-			break;
-		}
-	}
-
-	ratesArray[rate6mb] = ratesArray[rate9mb] = ratesArray[rate12mb] =
-		ratesArray[rate18mb] = ratesArray[rate24mb] =
-		targetPowerOfdm.tPow2x[0];
-	ratesArray[rate36mb] = targetPowerOfdm.tPow2x[1];
-	ratesArray[rate48mb] = targetPowerOfdm.tPow2x[2];
-	ratesArray[rate54mb] = targetPowerOfdm.tPow2x[3];
-	ratesArray[rateXr] = targetPowerOfdm.tPow2x[0];
-
-	for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++)
-		ratesArray[rateHt20_0 + i] = targetPowerHt20.tPow2x[i];
-
-	if (IS_CHAN_2GHZ(chan)) {
-		ratesArray[rate1l] = targetPowerCck.tPow2x[0];
-		ratesArray[rate2s] = ratesArray[rate2l] =
-			targetPowerCck.tPow2x[1];
-		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
-			targetPowerCck.tPow2x[2];
-		;
-		ratesArray[rate11s] = ratesArray[rate11l] =
-			targetPowerCck.tPow2x[3];
-		;
-	}
-	if (IS_CHAN_HT40(chan)) {
-		for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
-			ratesArray[rateHt40_0 + i] =
-				targetPowerHt40.tPow2x[i];
-		}
-		ratesArray[rateDupOfdm] = targetPowerHt40.tPow2x[0];
-		ratesArray[rateDupCck] = targetPowerHt40.tPow2x[0];
-		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
-		if (IS_CHAN_2GHZ(chan)) {
-			ratesArray[rateExtCck] =
-				targetPowerCckExt.tPow2x[0];
-		}
-	}
-	return true;
-}
-
 static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 						 struct ath9k_channel *chan,
 						 int16_t *ratesArray,
@@ -1548,8 +852,8 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
-		if (ar5416_get_eep_ver(ah) == 14 &&
-				ar5416_get_eep_rev(ah) <= 2)
+		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
+		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
@@ -1686,16 +990,15 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	return true;
 }
 
-static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
-			 struct ath9k_channel *chan,
-			 u16 cfgCtl,
-			 u8 twiceAntennaReduction,
-			 u8 twiceMaxRegulatoryPower,
-			 u8 powerLimit)
+static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
+				   struct ath9k_channel *chan,
+				   u16 cfgCtl,
+				   u8 twiceAntennaReduction,
+				   u8 twiceMaxRegulatoryPower,
+				   u8 powerLimit)
 {
-	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
-	struct modal_eep_header *pModal =
-		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
+	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
@@ -1708,7 +1011,7 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 	}
 
-	if (!ath9k_hw_set_def_power_per_rate_table(ah, chan,
+	if (!ath9k_hw_set_4k_power_per_rate_table(ah, chan,
 					       &ratesArray[0], cfgCtl,
 					       twiceAntennaReduction,
 					       twiceMaxRegulatoryPower,
@@ -1719,7 +1022,7 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		return -EIO;
 	}
 
-	if (!ath9k_hw_set_def_power_cal_table(ah, chan, &txPowerIndexOffset)) {
+	if (!ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "ath9k_hw_set_txpower: unable to set power table\n");
 		return -EIO;
@@ -1798,10 +1101,6 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
 
-	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
-		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
-		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
-
 	i = rate6mb;
 
 	if (IS_CHAN_HT40(chan))
@@ -1818,241 +1117,497 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	return 0;
 }
 
-static int ath9k_hw_4k_set_txpower(struct ath_hw *ah,
-			 struct ath9k_channel *chan,
-			 u16 cfgCtl,
-			 u8 twiceAntennaReduction,
-			 u8 twiceMaxRegulatoryPower,
-			 u8 powerLimit)
+static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
+				  struct ath9k_channel *chan)
 {
-	struct ar5416_eeprom_4k *pEepData = &ah->ah_eeprom.map4k;
-	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
-	int16_t ratesArray[Ar5416RateSize];
-	int16_t txPowerIndexOffset = 0;
-	u8 ht40PowerIncForPdadc = 2;
-	int i;
+	struct modal_eep_4k_header *pModal;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	u8 biaslevel;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
+	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
+		return;
 
-	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
-	    AR5416_EEP_MINOR_VER_2) {
-		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
+	if (ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_MINOR_VER_7)
+		return;
+
+	pModal = &eep->modalHeader;
+
+	if (pModal->xpaBiasLvl != 0xff) {
+		biaslevel = pModal->xpaBiasLvl;
+		INI_RA(&ah->ah_iniAddac, 7, 1) =
+		  (INI_RA(&ah->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
 	}
+}
 
-	if (!ath9k_hw_set_4k_power_per_rate_table(ah, chan,
-					       &ratesArray[0], cfgCtl,
-					       twiceAntennaReduction,
-					       twiceMaxRegulatoryPower,
-					       powerLimit)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"ath9k_hw_set_txpower: unable to set "
-			"tx power per rate table\n");
-		return -EIO;
+static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	struct modal_eep_4k_header *pModal;
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	int regChainOffset;
+	u8 txRxAttenLocal;
+	u8 ob[5], db1[5], db2[5];
+	u8 ant_div_control1, ant_div_control2;
+	u32 regVal;
+
+
+	pModal = &eep->modalHeader;
+
+	txRxAttenLocal = 23;
+
+	REG_WRITE(ah, AR_PHY_SWITCH_COM,
+		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
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
 	}
 
-	if (!ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset)) {
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
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			 "ath9k_hw_set_txpower: unable to set power table\n");
-		return -EIO;
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
 	}
 
-	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
-		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
-		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
-			ratesArray[i] = AR5416_MAX_RATE_POWER;
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
 	}
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		for (i = 0; i < Ar5416RateSize; i++)
-			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
+	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+						AR5416_EEP_MINOR_VER_3) {
+		if (IS_CHAN_HT40(chan))
+			REG_RMW_FIELD(ah, AR_PHY_SETTLING,
+				      AR_PHY_SETTLING_SWITCH,
+				      pModal->swSettleHt40);
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
+	return true;
+}
 
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
+static u16 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
+					      struct ath9k_channel *chan)
+{
+	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 
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
+	return pModal->antCtrlCommon & 0xFFFF;
+}
 
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
+static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
+					 enum ieee80211_band freq_band)
+{
+	return 1;
+}
 
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
-			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
-			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
-			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
-			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
-	}
+u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
+{
+#define EEP_MAP4K_SPURCHAN \
+	(ah->ah_eeprom.map4k.modalHeader.spurChans[i].spurChan)
 
-	i = rate6mb;
+	u16 spur_val = AR_NO_SPUR;
 
-	if (IS_CHAN_HT40(chan))
-		i = rateHt40_0;
-	else if (IS_CHAN_HT20(chan))
-		i = rateHt20_0;
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		"Getting spur idx %d is2Ghz. %d val %x\n",
+		i, is2GHz, ah->ah_config.spurchans[i][is2GHz]);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->regulatory.max_power_level =
-			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
-	else
-		ah->regulatory.max_power_level = ratesArray[i];
+	switch (ah->ah_config.spurmode) {
+	case SPUR_DISABLE:
+		break;
+	case SPUR_ENABLE_IOCTL:
+		spur_val = ah->ah_config.spurchans[i][is2GHz];
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			"Getting spur val from new loc. %d\n", spur_val);
+		break;
+	case SPUR_ENABLE_EEPROM:
+		spur_val = EEP_MAP4K_SPURCHAN;
+		break;
+	}
 
-	return 0;
+	return spur_val;
+
+#undef EEP_MAP4K_SPURCHAN
 }
 
-static int (*ath9k_set_txpower[]) (struct ath_hw *,
-				   struct ath9k_channel *,
-				   u16, u8, u8, u8) = {
-	ath9k_hw_def_set_txpower,
-	ath9k_hw_4k_set_txpower
+struct eeprom_ops eep_4k_ops = {
+	.check_eeprom		= ath9k_hw_4k_check_eeprom,
+	.get_eeprom		= ath9k_hw_4k_get_eeprom,
+	.fill_eeprom		= ath9k_hw_4k_fill_eeprom,
+	.get_eeprom_ver		= ath9k_hw_4k_get_eeprom_ver,
+	.get_eeprom_rev		= ath9k_hw_4k_get_eeprom_rev,
+	.get_num_ant_config	= ath9k_hw_4k_get_num_ant_config,
+	.get_eeprom_antenna_cfg	= ath9k_hw_4k_get_eeprom_antenna_cfg,
+	.set_board_values	= ath9k_hw_4k_set_board_values,
+	.set_addac		= ath9k_hw_4k_set_addac,
+	.set_txpower		= ath9k_hw_4k_set_txpower,
+	.get_spur_channel	= ath9k_hw_4k_get_spur_channel
 };
 
-int ath9k_hw_set_txpower(struct ath_hw *ah,
-			 struct ath9k_channel *chan,
-			 u16 cfgCtl,
-			 u8 twiceAntennaReduction,
-			 u8 twiceMaxRegulatoryPower,
-			 u8 powerLimit)
+/************************************************/
+/* EEPROM Operations for non-4K (Default) cards */
+/************************************************/
+
+static int ath9k_hw_def_get_eeprom_ver(struct ath_hw *ah)
 {
-	return ath9k_set_txpower[ah->ah_eep_map](ah, chan, cfgCtl,
-				 twiceAntennaReduction, twiceMaxRegulatoryPower,
-				 powerLimit);
+	return ((ah->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF);
 }
 
-static void ath9k_hw_set_def_addac(struct ath_hw *ah,
-				   struct ath9k_channel *chan)
+static int ath9k_hw_def_get_eeprom_rev(struct ath_hw *ah)
 {
-#define XPA_LVL_FREQ(cnt) (pModal->xpaBiasLvlFreq[cnt])
-	struct modal_eep_header *pModal;
+	return ((ah->ah_eeprom.def.baseEepHeader.version) & 0xFFF);
+}
+
+static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
+{
+#define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
 	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
-	u8 biaslevel;
+	u16 *eep_data;
+	int addr, ar5416_eep_start_loc = 0x100;
 
-	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
-		return;
+	eep_data = (u16 *)eep;
 
-	if (ar5416_get_eep_rev(ah) < AR5416_EEP_MINOR_VER_7)
-		return;
+	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
+		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
+					 eep_data)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Unable to read eeprom region\n");
+			return false;
+		}
+		eep_data++;
+	}
+	return true;
+#undef SIZE_EEPROM_DEF
+}
 
-	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
+static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
+{
+	struct ar5416_eeprom_def *eep =
+		(struct ar5416_eeprom_def *) &ah->ah_eeprom.def;
+	u16 *eepdata, temp, magic, magic2;
+	u32 sum = 0, el;
+	bool need_swap = false;
+	int i, addr, size;
 
-	if (pModal->xpaBiasLvl != 0xff) {
-		biaslevel = pModal->xpaBiasLvl;
-	} else {
-		u16 resetFreqBin, freqBin, freqCount = 0;
-		struct chan_centers centers;
+	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
+				 &magic)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"Reading Magic # failed\n");
+		return false;
+	}
 
-		ath9k_hw_get_channel_centers(ah, chan, &centers);
+	if (!ath9k_hw_use_flash(ah)) {
 
-		resetFreqBin = FREQ2FBIN(centers.synth_center,
-					 IS_CHAN_2GHZ(chan));
-		freqBin = XPA_LVL_FREQ(0) & 0xff;
-		biaslevel = (u8) (XPA_LVL_FREQ(0) >> 14);
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Read Magic = 0x%04X\n", magic);
 
-		freqCount++;
+		if (magic != AR5416_EEPROM_MAGIC) {
+			magic2 = swab16(magic);
 
-		while (freqCount < 3) {
-			if (XPA_LVL_FREQ(freqCount) == 0x0)
-				break;
+			if (magic2 == AR5416_EEPROM_MAGIC) {
+				size = sizeof(struct ar5416_eeprom_def);
+				need_swap = true;
+				eepdata = (u16 *) (&ah->ah_eeprom);
 
-			freqBin = XPA_LVL_FREQ(freqCount) & 0xff;
-			if (resetFreqBin >= freqBin)
-				biaslevel = (u8)(XPA_LVL_FREQ(freqCount) >> 14);
-			else
-				break;
-			freqCount++;
+				for (addr = 0; addr < size / sizeof(u16); addr++) {
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
 		}
 	}
 
-	if (IS_CHAN_2GHZ(chan)) {
-		INI_RA(&ah->ah_iniAddac, 7, 1) = (INI_RA(&ah->ah_iniAddac,
-					7, 1) & (~0x18)) | biaslevel << 3;
-	} else {
-		INI_RA(&ah->ah_iniAddac, 6, 1) = (INI_RA(&ah->ah_iniAddac,
-					6, 1) & (~0xc0)) | biaslevel << 6;
-	}
-#undef XPA_LVL_FREQ
-}
+	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n",
+		need_swap ? "True" : "False");
 
-static void ath9k_hw_set_4k_addac(struct ath_hw *ah,
-				  struct ath9k_channel *chan)
-{
-	struct modal_eep_4k_header *pModal;
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
-	u8 biaslevel;
+	if (need_swap)
+		el = swab16(ah->ah_eeprom.def.baseEepHeader.length);
+	else
+		el = ah->ah_eeprom.def.baseEepHeader.length;
 
-	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
-		return;
+	if (el > sizeof(struct ar5416_eeprom_def))
+		el = sizeof(struct ar5416_eeprom_def) / sizeof(u16);
+	else
+		el = el / sizeof(u16);
 
-	if (ar5416_get_eep_rev(ah) < AR5416_EEP_MINOR_VER_7)
-		return;
+	eepdata = (u16 *)(&ah->ah_eeprom);
 
-	pModal = &eep->modalHeader;
+	for (i = 0; i < el; i++)
+		sum ^= *eepdata++;
 
-	if (pModal->xpaBiasLvl != 0xff) {
-		biaslevel = pModal->xpaBiasLvl;
-		INI_RA(&ah->ah_iniAddac, 7, 1) =
-		  (INI_RA(&ah->ah_iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
+	if (need_swap) {
+		u32 integer, j;
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
+		for (j = 0; j < ARRAY_SIZE(eep->modalHeader); j++) {
+			struct modal_eep_header *pModal =
+				&eep->modalHeader[j];
+			integer = swab32(pModal->antCtrlCommon);
+			pModal->antCtrlCommon = integer;
+
+			for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+				integer = swab32(pModal->antCtrlChain[i]);
+				pModal->antCtrlChain[i] = integer;
+			}
+
+			for (i = 0; i < AR5416_EEPROM_MODAL_SPURS; i++) {
+				word = swab16(pModal->spurChans[i].spurChan);
+				pModal->spurChans[i].spurChan = word;
+			}
+		}
 	}
-}
 
-static void (*ath9k_set_addac[]) (struct ath_hw *, struct ath9k_channel *) = {
-	ath9k_hw_set_def_addac,
-	ath9k_hw_set_4k_addac
-};
+	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
+	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			sum, ah->eep_ops->get_eeprom_ver(ah));
+		return -EINVAL;
+	}
 
-void ath9k_hw_set_addac(struct ath_hw *ah, struct ath9k_channel *chan)
+	return 0;
+}
+
+static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
+				   enum eeprom_param param)
 {
-	ath9k_set_addac[ah->ah_eep_map](ah, chan);
+#define AR5416_VER_MASK (pBase->version & AR5416_EEP_VER_MINOR_MASK)
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct modal_eep_header *pModal = eep->modalHeader;
+	struct base_eep_header *pBase = &eep->baseEepHeader;
+
+	switch (param) {
+	case EEP_NFTHRESH_5:
+		return pModal[0].noiseFloorThreshCh[0];
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
+	case EEP_OB_5:
+		return pModal[0].ob;
+	case EEP_DB_5:
+		return pModal[0].db;
+	case EEP_OB_2:
+		return pModal[1].ob;
+	case EEP_DB_2:
+		return pModal[1].db;
+	case EEP_MINOR_REV:
+		return AR5416_VER_MASK;
+	case EEP_TX_MASK:
+		return pBase->txMask;
+	case EEP_RX_MASK:
+		return pBase->rxMask;
+	case EEP_RXGAIN_TYPE:
+		return pBase->rxGainType;
+	case EEP_TXGAIN_TYPE:
+		return pBase->txGainType;
+	case EEP_DAC_HPWR_5G:
+		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_20)
+			return pBase->dacHiPwrMode_5G;
+		else
+			return 0;
+	default:
+		return 0;
+	}
+#undef AR5416_VER_MASK
 }
 
 /* XXX: Clean me up, make me more legible */
-static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hw *ah,
-				      struct ath9k_channel *chan)
+static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
+					  struct ath9k_channel *chan)
 {
 #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 	struct modal_eep_header *pModal;
@@ -2065,7 +1620,7 @@ static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hw *ah,
 	txRxAttenLocal = IS_CHAN_2GHZ(chan) ? 23 : 44;
 
 	REG_WRITE(ah, AR_PHY_SWITCH_COM,
-		  ath9k_hw_get_eeprom_antenna_cfg(ah, chan));
+		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_9280(ah)) {
@@ -2295,242 +1850,775 @@ static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hw *ah,
 #undef AR5416_VER_MASK
 }
 
-static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hw *ah,
-				      struct ath9k_channel *chan)
+static void ath9k_hw_def_set_addac(struct ath_hw *ah,
+				   struct ath9k_channel *chan)
 {
-	struct modal_eep_4k_header *pModal;
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
-	int regChainOffset;
-	u8 txRxAttenLocal;
-	u8 ob[5], db1[5], db2[5];
-	u8 ant_div_control1, ant_div_control2;
-	u32 regVal;
+#define XPA_LVL_FREQ(cnt) (pModal->xpaBiasLvlFreq[cnt])
+	struct modal_eep_header *pModal;
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	u8 biaslevel;
 
+	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
+		return;
 
-	pModal = &eep->modalHeader;
+	if (ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_MINOR_VER_7)
+		return;
 
-	txRxAttenLocal = 23;
+	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
-	REG_WRITE(ah, AR_PHY_SWITCH_COM,
-		  ath9k_hw_get_eeprom_antenna_cfg(ah, chan));
+	if (pModal->xpaBiasLvl != 0xff) {
+		biaslevel = pModal->xpaBiasLvl;
+	} else {
+		u16 resetFreqBin, freqBin, freqCount = 0;
+		struct chan_centers centers;
 
-	regChainOffset = 0;
-	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0 + regChainOffset,
-		  pModal->antCtrlChain[0]);
+		ath9k_hw_get_channel_centers(ah, chan, &centers);
 
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
-		 (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset) &
-		 ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
-		 AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
-		 SM(pModal->iqCalICh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
-		 SM(pModal->iqCalQCh[0], AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
+		resetFreqBin = FREQ2FBIN(centers.synth_center,
+					 IS_CHAN_2GHZ(chan));
+		freqBin = XPA_LVL_FREQ(0) & 0xff;
+		biaslevel = (u8) (XPA_LVL_FREQ(0) >> 14);
 
-	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
-			AR5416_EEP_MINOR_VER_3) {
-		txRxAttenLocal = pModal->txRxAttenCh[0];
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN, pModal->bswMargin[0]);
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN1_DB, pModal->bswAtten[0]);
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
-			pModal->xatten2Margin[0]);
-		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
-			AR_PHY_GAIN_2GHZ_XATTEN2_DB, pModal->xatten2Db[0]);
-	}
+		freqCount++;
 
-	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
-			AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
-	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
-			AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
+		while (freqCount < 3) {
+			if (XPA_LVL_FREQ(freqCount) == 0x0)
+				break;
 
-	if (AR_SREV_9285_11(ah))
-		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
+			freqBin = XPA_LVL_FREQ(freqCount) & 0xff;
+			if (resetFreqBin >= freqBin)
+				biaslevel = (u8)(XPA_LVL_FREQ(freqCount) >> 14);
+			else
+				break;
+			freqCount++;
+		}
+	}
 
-	/* Initialize Ant Diversity settings from EEPROM */
-	if (pModal->version == 3) {
-		ant_div_control1 = ((pModal->ob_234 >> 12) & 0xf);
-		ant_div_control2 = ((pModal->db1_234 >> 12) & 0xf);
-		regVal = REG_READ(ah, 0x99ac);
-		regVal &= (~(0x7f000000));
-		regVal |= ((ant_div_control1 & 0x1) << 24);
-		regVal |= (((ant_div_control1 >> 1) & 0x1) << 29);
-		regVal |= (((ant_div_control1 >> 2) & 0x1) << 30);
-		regVal |= ((ant_div_control2 & 0x3) << 25);
-		regVal |= (((ant_div_control2 >> 2) & 0x3) << 27);
-		REG_WRITE(ah, 0x99ac, regVal);
-		regVal = REG_READ(ah, 0x99ac);
-		regVal = REG_READ(ah, 0xa208);
-		regVal &= (~(0x1 << 13));
-		regVal |= (((ant_div_control1 >> 3) & 0x1) << 13);
-		REG_WRITE(ah, 0xa208, regVal);
-		regVal = REG_READ(ah, 0xa208);
+	if (IS_CHAN_2GHZ(chan)) {
+		INI_RA(&ah->ah_iniAddac, 7, 1) = (INI_RA(&ah->ah_iniAddac,
+					7, 1) & (~0x18)) | biaslevel << 3;
+	} else {
+		INI_RA(&ah->ah_iniAddac, 6, 1) = (INI_RA(&ah->ah_iniAddac,
+					6, 1) & (~0xc0)) | biaslevel << 6;
 	}
+#undef XPA_LVL_FREQ
+}
 
-	if (pModal->version >= 2) {
-		ob[0] = (pModal->ob_01 & 0xf);
-		ob[1] = (pModal->ob_01 >> 4) & 0xf;
-		ob[2] = (pModal->ob_234 & 0xf);
-		ob[3] = ((pModal->ob_234 >> 4) & 0xf);
-		ob[4] = ((pModal->ob_234 >> 8) & 0xf);
+static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
+				struct ath9k_channel *chan,
+				struct cal_data_per_freq *pRawDataSet,
+				u8 *bChans, u16 availPiers,
+				u16 tPdGainOverlap, int16_t *pMinCalPower,
+				u16 *pPdGainBoundaries, u8 *pPDADCValues,
+				u16 numXpdGains)
+{
+	int i, j, k;
+	int16_t ss;
+	u16 idxL = 0, idxR = 0, numPiers;
+	static u8 vpdTableL[AR5416_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableR[AR5416_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableI[AR5416_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
-		db1[0] = (pModal->db1_01 & 0xf);
-		db1[1] = ((pModal->db1_01 >> 4) & 0xf);
-		db1[2] = (pModal->db1_234 & 0xf);
-		db1[3] = ((pModal->db1_234 >> 4) & 0xf);
-		db1[4] = ((pModal->db1_234 >> 8) & 0xf);
+	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
+	u8 minPwrT4[AR5416_NUM_PD_GAINS];
+	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
+	int16_t vpdStep;
+	int16_t tmpVal;
+	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
+	bool match;
+	int16_t minDelta = 0;
+	struct chan_centers centers;
 
-		db2[0] = (pModal->db2_01 & 0xf);
-		db2[1] = ((pModal->db2_01 >> 4) & 0xf);
-		db2[2] = (pModal->db2_234 & 0xf);
-		db2[3] = ((pModal->db2_234 >> 4) & 0xf);
-		db2[4] = ((pModal->db2_234 >> 8) & 0xf);
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
-	} else if (pModal->version == 1) {
+	for (numPiers = 0; numPiers < availPiers; numPiers++) {
+		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
+			break;
+	}
 
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"EEPROM Model version is set to 1 \n");
-		ob[0] = (pModal->ob_01 & 0xf);
-		ob[1] = ob[2] = ob[3] = ob[4] = (pModal->ob_01 >> 4) & 0xf;
-		db1[0] = (pModal->db1_01 & 0xf);
-		db1[1] = db1[2] = db1[3] =
-			db1[4] = ((pModal->db1_01 >> 4) & 0xf);
-		db2[0] = (pModal->db2_01 & 0xf);
-		db2[1] = db2[2] = db2[3] =
-			db2[4] = ((pModal->db2_01 >> 4) & 0xf);
+	match = ath9k_hw_get_lower_upper_index((u8)FREQ2FBIN(centers.synth_center,
+							     IS_CHAN_2GHZ(chan)),
+					       bChans, numPiers, &idxL, &idxR);
+
+	if (match) {
+		for (i = 0; i < numXpdGains; i++) {
+			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
+			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+					pRawDataSet[idxL].pwrPdg[i],
+					pRawDataSet[idxL].vpdPdg[i],
+					AR5416_PD_GAIN_ICEPTS,
+					vpdTableI[i]);
+		}
 	} else {
-		int i;
-		for (i = 0; i < 5; i++) {
-			ob[i] = pModal->ob_01;
-			db1[i] = pModal->db1_01;
-			db2[i] = pModal->db1_01;
+		for (i = 0; i < numXpdGains; i++) {
+			pVpdL = pRawDataSet[idxL].vpdPdg[i];
+			pPwrL = pRawDataSet[idxL].pwrPdg[i];
+			pVpdR = pRawDataSet[idxR].vpdPdg[i];
+			pPwrR = pRawDataSet[idxR].pwrPdg[i];
+
+			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
+
+			maxPwrT4[i] =
+				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
+				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
+
+
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						pPwrL, pVpdL,
+						AR5416_PD_GAIN_ICEPTS,
+						vpdTableL[i]);
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						pPwrR, pVpdR,
+						AR5416_PD_GAIN_ICEPTS,
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
+	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
 
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
+	k = 0;
 
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
+	for (i = 0; i < numXpdGains; i++) {
+		if (i == (numXpdGains - 1))
+			pPdGainBoundaries[i] =
+				(u16)(maxPwrT4[i] / 2);
+		else
+			pPdGainBoundaries[i] =
+				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
 
+		pPdGainBoundaries[i] =
+			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
 
-	if (AR_SREV_9285_11(ah))
-		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
+		if ((i == 0) && !AR_SREV_5416_V20_OR_LATER(ah)) {
+			minDelta = pPdGainBoundaries[0] - 23;
+			pPdGainBoundaries[0] = 23;
+		} else {
+			minDelta = 0;
+		}
 
-	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
-		      pModal->switchSettling);
-	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
-		      pModal->adcDesiredSize);
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
 
-	REG_WRITE(ah, AR_PHY_RF_CTL4,
-		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAA_OFF) |
-		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAB_OFF) |
-		  SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAA_ON)  |
-		  SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAB_ON));
+		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
+			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
+			ss++;
+		}
 
-	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
-		      pModal->txEndToRxOn);
-	REG_RMW_FIELD(ah, AR_PHY_CCA, AR9280_PHY_CCA_THRESH62,
-		      pModal->thresh62);
-	REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0, AR_PHY_EXT_CCA0_THRESH62,
-		      pModal->thresh62);
+		sizeCurrVpdTable = (u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
+		tgtIndex = (u8)(pPdGainBoundaries[i] + tPdGainOverlap -
+				(minPwrT4[i] / 2));
+		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
+			tgtIndex : sizeCurrVpdTable;
 
-	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
-						AR5416_EEP_MINOR_VER_2) {
-		REG_RMW_FIELD(ah, AR_PHY_RF_CTL2, AR_PHY_TX_END_DATA_START,
-			      pModal->txFrameToDataStart);
-		REG_RMW_FIELD(ah, AR_PHY_RF_CTL2, AR_PHY_TX_END_PA_ON,
-			      pModal->txFrameToPaOn);
-	}
+		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+			pPDADCValues[k++] = vpdTableI[i][ss++];
+		}
 
-	if ((eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
-						AR5416_EEP_MINOR_VER_3) {
-		if (IS_CHAN_HT40(chan))
-			REG_RMW_FIELD(ah, AR_PHY_SETTLING,
-				      AR_PHY_SETTLING_SWITCH,
-				      pModal->swSettleHt40);
+		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
+				    vpdTableI[i][sizeCurrVpdTable - 2]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
+		if (tgtIndex > maxIndex) {
+			while ((ss <= tgtIndex) &&
+			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+				tmpVal = (int16_t)((vpdTableI[i][sizeCurrVpdTable - 1] +
+						    (ss - maxIndex + 1) * vpdStep));
+				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
+							 255 : tmpVal);
+				ss++;
+			}
+		}
 	}
 
-	return true;
-}
+	while (i < AR5416_PD_GAINS_IN_MASK) {
+		pPdGainBoundaries[i] = pPdGainBoundaries[i - 1];
+		i++;
+	}
 
-static bool (*ath9k_eeprom_set_board_values[])(struct ath_hw *,
-					       struct ath9k_channel *) = {
-	ath9k_hw_eeprom_set_def_board_values,
-	ath9k_hw_eeprom_set_4k_board_values
-};
+	while (k < AR5416_NUM_PDADC_VALUES) {
+		pPDADCValues[k] = pPDADCValues[k - 1];
+		k++;
+	}
 
-bool ath9k_hw_eeprom_set_board_values(struct ath_hw *ah,
-				      struct ath9k_channel *chan)
-{
-	return ath9k_eeprom_set_board_values[ah->ah_eep_map](ah, chan);
+	return;
 }
 
-static u16 ath9k_hw_get_def_eeprom_antenna_cfg(struct ath_hw *ah,
-					       struct ath9k_channel *chan)
+static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
+				  struct ath9k_channel *chan,
+				  int16_t *pTxPowerIndexOffset)
 {
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
-	struct modal_eep_header *pModal =
-		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
+	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
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
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
+	xpdMask = pEepData->modalHeader[modalIdx].xpdGain;
+
+	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+	    AR5416_EEP_MINOR_VER_2) {
+		pdGainOverlap_t2 =
+			pEepData->modalHeader[modalIdx].pdGainOverlap;
+	} else {
+		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
+					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
+	}
+
+	if (IS_CHAN_2GHZ(chan)) {
+		pCalBChans = pEepData->calFreqPier2G;
+		numPiers = AR5416_NUM_2G_CAL_PIERS;
+	} else {
+		pCalBChans = pEepData->calFreqPier5G;
+		numPiers = AR5416_NUM_5G_CAL_PIERS;
+	}
+
+	numXpdGain = 0;
+
+	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
+			if (numXpdGain >= AR5416_NUM_PD_GAINS)
+				break;
+			xpdGainValues[numXpdGain] =
+				(u16)(AR5416_PD_GAINS_IN_MASK - i);
+			numXpdGain++;
+		}
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
+		      (numXpdGain - 1) & 0x3);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
+		      xpdGainValues[0]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
+		      xpdGainValues[1]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
+		      xpdGainValues[2]);
+
+	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		if (AR_SREV_5416_V20_OR_LATER(ah) &&
+		    (ah->ah_rxchainmask == 5 || ah->ah_txchainmask == 5) &&
+		    (i != 0)) {
+			regChainOffset = (i == 1) ? 0x2000 : 0x1000;
+		} else
+			regChainOffset = i * 0x1000;
+
+		if (pEepData->baseEepHeader.txMask & (1 << i)) {
+			if (IS_CHAN_2GHZ(chan))
+				pRawDataset = pEepData->calPierData2G[i];
+			else
+				pRawDataset = pEepData->calPierData5G[i];
+
+			ath9k_hw_get_def_gain_boundaries_pdadcs(ah, chan,
+					    pRawDataset, pCalBChans,
+					    numPiers, pdGainOverlap_t2,
+					    &tMinCalPower, gainBoundaries,
+					    pdadcValues, numXpdGain);
+
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
+					"PDADC: Chain %d | PDADC %3d "
+					"Value %3d | PDADC %3d Value %3d | "
+					"PDADC %3d Value %3d | PDADC %3d "
+					"Value %3d |\n",
+					i, 4 * j, pdadcValues[4 * j],
+					4 * j + 1, pdadcValues[4 * j + 1],
+					4 * j + 2, pdadcValues[4 * j + 2],
+					4 * j + 3,
+					pdadcValues[4 * j + 3]);
+
+				regOffset += 4;
+			}
+		}
+	}
+
+	*pTxPowerIndexOffset = 0;
+
+	return true;
 }
 
-static u16 ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hw *ah,
-					      struct ath9k_channel *chan)
+static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
+						  struct ath9k_channel *chan,
+						  int16_t *ratesArray,
+						  u16 cfgCtl,
+						  u16 AntennaReduction,
+						  u16 twiceMaxRegulatoryPower,
+						  u16 powerLimit)
 {
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
-	struct modal_eep_4k_header *pModal = &eep->modalHeader;
+#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
-	return pModal->antCtrlCommon & 0xFFFF;
-}
+	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	static const u16 tpScaleReductionTable[5] =
+		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 
-static u16 (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hw *,
-					     struct ath9k_channel *) = {
-	ath9k_hw_get_def_eeprom_antenna_cfg,
-	ath9k_hw_get_4k_eeprom_antenna_cfg
-};
+	int i;
+	int16_t twiceLargestAntenna;
+	struct cal_ctl_data *rep;
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
+	u16 ctlModesFor11a[] =
+		{ CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40 };
+	u16 ctlModesFor11g[] =
+		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
+		  CTL_2GHT40
+		};
+	u16 numCtlModes, *pCtlMode, ctlMode, freq;
+	struct chan_centers centers;
+	int tx_chainmask;
+	u16 twiceMinEdgePower;
 
-u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hw *ah,
-				    struct ath9k_channel *chan)
-{
-	return ath9k_get_eeprom_antenna_cfg[ah->ah_eep_map](ah, chan);
+	tx_chainmask = ah->ah_txchainmask;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	twiceLargestAntenna = max(
+		pEepData->modalHeader
+			[IS_CHAN_2GHZ(chan)].antennaGainCh[0],
+		pEepData->modalHeader
+			[IS_CHAN_2GHZ(chan)].antennaGainCh[1]);
+
+	twiceLargestAntenna = max((u8)twiceLargestAntenna,
+				  pEepData->modalHeader
+				  [IS_CHAN_2GHZ(chan)].antennaGainCh[2]);
+
+	twiceLargestAntenna = (int16_t)min(AntennaReduction -
+					   twiceLargestAntenna, 0);
+
+	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
+
+	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
+		maxRegAllowedPower -=
+			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
+	}
+
+	scaledPower = min(powerLimit, maxRegAllowedPower);
+
+	switch (ar5416_get_ntxchains(tx_chainmask)) {
+	case 1:
+		break;
+	case 2:
+		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		break;
+	case 3:
+		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		break;
+	}
+
+	scaledPower = max((u16)0, scaledPower);
+
+	if (IS_CHAN_2GHZ(chan)) {
+		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
+			SUB_NUM_CTL_MODES_AT_2G_40;
+		pCtlMode = ctlModesFor11g;
+
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+			pEepData->calTargetPowerCck,
+			AR5416_NUM_2G_CCK_TARGET_POWERS,
+			&targetPowerCck, 4, false);
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+			pEepData->calTargetPower2G,
+			AR5416_NUM_2G_20_TARGET_POWERS,
+			&targetPowerOfdm, 4, false);
+		ath9k_hw_get_target_powers(ah, chan,
+			pEepData->calTargetPower2GHT20,
+			AR5416_NUM_2G_20_TARGET_POWERS,
+			&targetPowerHt20, 8, false);
+
+		if (IS_CHAN_HT40(chan)) {
+			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
+			ath9k_hw_get_target_powers(ah, chan,
+				pEepData->calTargetPower2GHT40,
+				AR5416_NUM_2G_40_TARGET_POWERS,
+				&targetPowerHt40, 8, true);
+			ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPowerCck,
+				AR5416_NUM_2G_CCK_TARGET_POWERS,
+				&targetPowerCckExt, 4, true);
+			ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPower2G,
+				AR5416_NUM_2G_20_TARGET_POWERS,
+				&targetPowerOfdmExt, 4, true);
+		}
+	} else {
+		numCtlModes = ARRAY_SIZE(ctlModesFor11a) -
+			SUB_NUM_CTL_MODES_AT_5G_40;
+		pCtlMode = ctlModesFor11a;
+
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+			pEepData->calTargetPower5G,
+			AR5416_NUM_5G_20_TARGET_POWERS,
+			&targetPowerOfdm, 4, false);
+		ath9k_hw_get_target_powers(ah, chan,
+			pEepData->calTargetPower5GHT20,
+			AR5416_NUM_5G_20_TARGET_POWERS,
+			&targetPowerHt20, 8, false);
+
+		if (IS_CHAN_HT40(chan)) {
+			numCtlModes = ARRAY_SIZE(ctlModesFor11a);
+			ath9k_hw_get_target_powers(ah, chan,
+				pEepData->calTargetPower5GHT40,
+				AR5416_NUM_5G_40_TARGET_POWERS,
+				&targetPowerHt40, 8, true);
+			ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPower5G,
+				AR5416_NUM_5G_20_TARGET_POWERS,
+				&targetPowerOfdmExt, 4, true);
+		}
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
+		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
+		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
+			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d, "
+			"EXT_ADDITIVE %d\n",
+			ctlMode, numCtlModes, isHt40CtlMode,
+			(pCtlMode[ctlMode] & EXT_ADDITIVE));
+
+		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
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
+			     ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))) {
+				rep = &(pEepData->ctlData[i]);
+
+				twiceMinEdgePower = ath9k_hw_get_max_edge_power(freq,
+				rep->ctlEdges[ar5416_get_ntxchains(tx_chainmask) - 1],
+				IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
+
+				DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+					"    MATCH-EE_IDX %d: ch %d is2 %d "
+					"2xMinEdge %d chainmask %d chains %d\n",
+					i, freq, IS_CHAN_2GHZ(chan),
+					twiceMinEdgePower, tx_chainmask,
+					ar5416_get_ntxchains
+					(tx_chainmask));
+				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
+					twiceMaxEdgePower = min(twiceMaxEdgePower,
+								twiceMinEdgePower);
+				} else {
+					twiceMaxEdgePower = twiceMinEdgePower;
+					break;
+				}
+			}
+		}
+
+		minCtlPower = min(twiceMaxEdgePower, scaledPower);
+
+		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
+			"    SEL-Min ctlMode %d pCtlMode %d "
+			"2xMaxEdge %d sP %d minCtlPwr %d\n",
+			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
+			scaledPower, minCtlPower);
+
+		switch (pCtlMode[ctlMode]) {
+		case CTL_11B:
+			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x); i++) {
+				targetPowerCck.tPow2x[i] =
+					min((u16)targetPowerCck.tPow2x[i],
+					    minCtlPower);
+			}
+			break;
+		case CTL_11A:
+		case CTL_11G:
+			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x); i++) {
+				targetPowerOfdm.tPow2x[i] =
+					min((u16)targetPowerOfdm.tPow2x[i],
+					    minCtlPower);
+			}
+			break;
+		case CTL_5GHT20:
+		case CTL_2GHT20:
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++) {
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
+		case CTL_11A_EXT:
+		case CTL_11G_EXT:
+			targetPowerOfdmExt.tPow2x[0] = min((u16)
+					targetPowerOfdmExt.tPow2x[0],
+					minCtlPower);
+			break;
+		case CTL_5GHT40:
+		case CTL_2GHT40:
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
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
+	if (IS_CHAN_2GHZ(chan)) {
+		ratesArray[rate1l] = targetPowerCck.tPow2x[0];
+		ratesArray[rate2s] = ratesArray[rate2l] =
+			targetPowerCck.tPow2x[1];
+		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
+			targetPowerCck.tPow2x[2];
+		;
+		ratesArray[rate11s] = ratesArray[rate11l] =
+			targetPowerCck.tPow2x[3];
+		;
+	}
+	if (IS_CHAN_HT40(chan)) {
+		for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
+			ratesArray[rateHt40_0 + i] =
+				targetPowerHt40.tPow2x[i];
+		}
+		ratesArray[rateDupOfdm] = targetPowerHt40.tPow2x[0];
+		ratesArray[rateDupCck] = targetPowerHt40.tPow2x[0];
+		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
+		if (IS_CHAN_2GHZ(chan)) {
+			ratesArray[rateExtCck] =
+				targetPowerCckExt.tPow2x[0];
+		}
+	}
+	return true;
 }
 
-static u8 ath9k_hw_get_4k_num_ant_config(struct ath_hw *ah,
-					 enum ieee80211_band freq_band)
+static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
+				    struct ath9k_channel *chan,
+				    u16 cfgCtl,
+				    u8 twiceAntennaReduction,
+				    u8 twiceMaxRegulatoryPower,
+				    u8 powerLimit)
 {
-	return 1;
+	struct ar5416_eeprom_def *pEepData = &ah->ah_eeprom.def;
+	struct modal_eep_header *pModal =
+		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
+	int16_t ratesArray[Ar5416RateSize];
+	int16_t txPowerIndexOffset = 0;
+	u8 ht40PowerIncForPdadc = 2;
+	int i;
+
+	memset(ratesArray, 0, sizeof(ratesArray));
+
+	if ((pEepData->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK) >=
+	    AR5416_EEP_MINOR_VER_2) {
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
+	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
+		  ATH9K_POW_SM(pModal->pwrDecreaseFor3Chain, 6)
+		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
+
+	i = rate6mb;
+
+	if (IS_CHAN_HT40(chan))
+		i = rateHt40_0;
+	else if (IS_CHAN_HT20(chan))
+		i = rateHt20_0;
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->regulatory.max_power_level =
+			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
+	else
+		ah->regulatory.max_power_level = ratesArray[i];
+
+	return 0;
 }
 
-static u8 ath9k_hw_get_def_num_ant_config(struct ath_hw *ah,
+static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
 					  enum ieee80211_band freq_band)
 {
 	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
@@ -2548,24 +2636,21 @@ static u8 ath9k_hw_get_def_num_ant_config(struct ath_hw *ah,
 	return num_ant_config;
 }
 
-static u8 (*ath9k_get_num_ant_config[])(struct ath_hw *,
-					enum ieee80211_band) = {
-	ath9k_hw_get_def_num_ant_config,
-	ath9k_hw_get_4k_num_ant_config
-};
-
-u8 ath9k_hw_get_num_ant_config(struct ath_hw *ah,
-			       enum ieee80211_band freq_band)
+static u16 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
+					       struct ath9k_channel *chan)
 {
-	return ath9k_get_num_ant_config[ah->ah_eep_map](ah, freq_band);
+	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
+	struct modal_eep_header *pModal =
+		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
+
+	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hw *ah, u16 i, bool is2GHz)
+u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
-#define EEP_MAP4K_SPURCHAN \
-	(ah->ah_eeprom.map4k.modalHeader.spurChans[i].spurChan)
 #define EEP_DEF_SPURCHAN \
 	(ah->ah_eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
+
 	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
@@ -2581,142 +2666,45 @@ u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hw *ah, u16 i, bool is2GHz)
 			"Getting spur val from new loc. %d\n", spur_val);
 		break;
 	case SPUR_ENABLE_EEPROM:
-		if (ah->ah_eep_map == EEP_MAP_4KBITS)
-			spur_val = EEP_MAP4K_SPURCHAN;
-		else
-			spur_val = EEP_DEF_SPURCHAN;
+		spur_val = EEP_DEF_SPURCHAN;
 		break;
-
 	}
 
 	return spur_val;
-#undef EEP_DEF_SPURCHAN
-#undef EEP_MAP4K_SPURCHAN
-}
-
-static u32 ath9k_hw_get_eeprom_4k(struct ath_hw *ah,
-				  enum eeprom_param param)
-{
-	struct ar5416_eeprom_4k *eep = &ah->ah_eeprom.map4k;
-	struct modal_eep_4k_header *pModal = &eep->modalHeader;
-	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
-
-	switch (param) {
-	case EEP_NFTHRESH_2:
-		return pModal[1].noiseFloorThreshCh[0];
-	case AR_EEPROM_MAC(0):
-		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
-	case AR_EEPROM_MAC(1):
-		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
-	case AR_EEPROM_MAC(2):
-		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
-	case EEP_REG_0:
-		return pBase->regDmn[0];
-	case EEP_REG_1:
-		return pBase->regDmn[1];
-	case EEP_OP_CAP:
-		return pBase->deviceCap;
-	case EEP_OP_MODE:
-		return pBase->opCapFlags;
-	case EEP_RF_SILENT:
-		return pBase->rfSilent;
-	case EEP_OB_2:
-		return pModal->ob_01;
-	case EEP_DB_2:
-		return pModal->db1_01;
-	case EEP_MINOR_REV:
-		return pBase->version & AR5416_EEP_VER_MINOR_MASK;
-	case EEP_TX_MASK:
-		return pBase->txMask;
-	case EEP_RX_MASK:
-		return pBase->rxMask;
-	default:
-		return 0;
-	}
-}
 
-static u32 ath9k_hw_get_eeprom_def(struct ath_hw *ah,
-				   enum eeprom_param param)
-{
-#define AR5416_VER_MASK (pBase->version & AR5416_EEP_VER_MINOR_MASK)
-	struct ar5416_eeprom_def *eep = &ah->ah_eeprom.def;
-	struct modal_eep_header *pModal = eep->modalHeader;
-	struct base_eep_header *pBase = &eep->baseEepHeader;
-
-	switch (param) {
-	case EEP_NFTHRESH_5:
-		return pModal[0].noiseFloorThreshCh[0];
-	case EEP_NFTHRESH_2:
-		return pModal[1].noiseFloorThreshCh[0];
-	case AR_EEPROM_MAC(0):
-		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
-	case AR_EEPROM_MAC(1):
-		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
-	case AR_EEPROM_MAC(2):
-		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
-	case EEP_REG_0:
-		return pBase->regDmn[0];
-	case EEP_REG_1:
-		return pBase->regDmn[1];
-	case EEP_OP_CAP:
-		return pBase->deviceCap;
-	case EEP_OP_MODE:
-		return pBase->opCapFlags;
-	case EEP_RF_SILENT:
-		return pBase->rfSilent;
-	case EEP_OB_5:
-		return pModal[0].ob;
-	case EEP_DB_5:
-		return pModal[0].db;
-	case EEP_OB_2:
-		return pModal[1].ob;
-	case EEP_DB_2:
-		return pModal[1].db;
-	case EEP_MINOR_REV:
-		return AR5416_VER_MASK;
-	case EEP_TX_MASK:
-		return pBase->txMask;
-	case EEP_RX_MASK:
-		return pBase->rxMask;
-	case EEP_RXGAIN_TYPE:
-		return pBase->rxGainType;
-	case EEP_TXGAIN_TYPE:
-		return pBase->txGainType;
-	case EEP_DAC_HPWR_5G:
-		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_20)
-			return pBase->dacHiPwrMode_5G;
-		else
-			return 0;
-	default:
-		return 0;
-	}
-#undef AR5416_VER_MASK
+#undef EEP_DEF_SPURCHAN
 }
 
-static u32 (*ath9k_get_eeprom[])(struct ath_hw *, enum eeprom_param) = {
-	ath9k_hw_get_eeprom_def,
-	ath9k_hw_get_eeprom_4k
+struct eeprom_ops eep_def_ops = {
+	.check_eeprom		= ath9k_hw_def_check_eeprom,
+	.get_eeprom		= ath9k_hw_def_get_eeprom,
+	.fill_eeprom		= ath9k_hw_def_fill_eeprom,
+	.get_eeprom_ver		= ath9k_hw_def_get_eeprom_ver,
+	.get_eeprom_rev		= ath9k_hw_def_get_eeprom_rev,
+	.get_num_ant_config	= ath9k_hw_def_get_num_ant_config,
+	.get_eeprom_antenna_cfg	= ath9k_hw_def_get_eeprom_antenna_cfg,
+	.set_board_values	= ath9k_hw_def_set_board_values,
+	.set_addac		= ath9k_hw_def_set_addac,
+	.set_txpower		= ath9k_hw_def_set_txpower,
+	.get_spur_channel	= ath9k_hw_def_get_spur_channel
 };
 
-u32 ath9k_hw_get_eeprom(struct ath_hw *ah,
-			enum eeprom_param param)
-{
-	return ath9k_get_eeprom[ah->ah_eep_map](ah, param);
-}
-
 int ath9k_hw_eeprom_attach(struct ath_hw *ah)
 {
 	int status;
 
-	if (AR_SREV_9285(ah))
+	if (AR_SREV_9285(ah)) {
 		ah->ah_eep_map = EEP_MAP_4KBITS;
-	else
+		ah->eep_ops = &eep_4k_ops;
+	} else {
 		ah->ah_eep_map = EEP_MAP_DEFAULT;
+		ah->eep_ops = &eep_def_ops;
+	}
 
-	if (!ath9k_hw_fill_eeprom(ah))
+	if (!ah->eep_ops->fill_eeprom(ah))
 		return -EIO;
 
-	status = ath9k_hw_check_eeprom(ah);
+	status = ah->eep_ops->check_eeprom(ah);
 
 	return status;
 }
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 47c8eea..7a4266f 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -464,38 +464,10 @@ struct eeprom_ops {
 	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
 };
 
-#define ar5416_get_eep_ver(_ah) \
-	(((_ah)->ah_eeprom.def.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep_rev(_ah) \
-	(((_ah)->ah_eeprom.def.baseEepHeader.version) & 0xFFF)
 #define ar5416_get_ntxchains(_txchainmask)			\
-	(((_txchainmask >> 2) & 1) +				\
+	(((_txchainmask >> 2) & 1) +                            \
 	 ((_txchainmask >> 1) & 1) + (_txchainmask & 1))
 
-#define ar5416_get_eep4k_ver(_ah) \
-	(((_ah)->ah_eeprom.map4k.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep4k_rev(_ah) \
-	(((_ah)->ah_eeprom.map4k.baseEepHeader.version) & 0xFFF)
-
-int ath9k_hw_set_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
-			 u16 cfgCtl, u8 twiceAntennaReduction,
-			 u8 twiceMaxRegulatoryPower, u8 powerLimit);
-void ath9k_hw_set_addac(struct ath_hw *ah, struct ath9k_channel *chan);
-bool ath9k_hw_set_power_per_rate_table(struct ath_hw *ah,
-		       struct ath9k_channel *chan, int16_t *ratesArray,
-		       u16 cfgCtl, u8 AntennaReduction,
-		       u8 twiceMaxRegulatoryPower, u8 powerLimit);
-bool ath9k_hw_set_power_cal_table(struct ath_hw *ah,
-				  struct ath9k_channel *chan,
-				  int16_t *pTxPowerIndexOffset);
-bool ath9k_hw_eeprom_set_board_values(struct ath_hw *ah,
-				      struct ath9k_channel *chan);
-u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hw *ah,
-				    struct ath9k_channel *chan);
-u8 ath9k_hw_get_num_ant_config(struct ath_hw *ah,
-			       enum ieee80211_band freq_band);
-u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hw *ah, u16 i, bool is2GHz);
-u32 ath9k_hw_get_eeprom(struct ath_hw *ah, enum eeprom_param param);
 int ath9k_hw_eeprom_attach(struct ath_hw *ah);
 
 #endif /* EEPROM_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ba908e9..f744d8c 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -487,7 +487,7 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 
 	sum = 0;
 	for (i = 0; i < 3; i++) {
-		eeval = ath9k_hw_get_eeprom(ah, AR_EEPROM_MAC(i));
+		eeval = ah->eep_ops->get_eeprom(ah, AR_EEPROM_MAC(i));
 		sum += eeval;
 		ah->macaddr[2 * i] = eeval >> 8;
 		ah->macaddr[2 * i + 1] = eeval & 0xff;
@@ -506,8 +506,8 @@ static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
 {
 	u32 rxgain_type;
 
-	if (ath9k_hw_get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
-		rxgain_type = ath9k_hw_get_eeprom(ah, EEP_RXGAIN_TYPE);
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
+		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
 
 		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
 			INIT_INI_ARRAY(&ah->ah_iniModesRxGain,
@@ -532,8 +532,8 @@ static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
 {
 	u32 txgain_type;
 
-	if (ath9k_hw_get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
-		txgain_type = ath9k_hw_get_eeprom(ah, EEP_TXGAIN_TYPE);
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
+		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
 
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
 			INIT_INI_ARRAY(&ah->ah_iniModesTxGain,
@@ -1238,7 +1238,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_PHY(0), 0x00000007);
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
-	ath9k_hw_set_addac(ah, chan);
+	ah->eep_ops->set_addac(ah, chan);
 
 	if (AR_SREV_5416_V22_OR_LATER(ah)) {
 		REG_WRITE_ARRAY(&ah->ah_iniAddac, 1, regWrites);
@@ -1306,12 +1306,12 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	ath9k_hw_set_regs(ah, chan, macmode);
 	ath9k_hw_init_chain_masks(ah);
 
-	status = ath9k_hw_set_txpower(ah, chan,
-				      ath9k_regd_get_ctl(ah, chan),
-				      channel->max_antenna_gain * 2,
-				      channel->max_power * 2,
-				      min((u32) MAX_RATE_POWER,
-					  (u32) ah->regulatory.power_limit));
+	status = ah->eep_ops->set_txpower(ah, chan,
+				  ath9k_regd_get_ctl(ah, chan),
+				  channel->max_antenna_gain * 2,
+				  channel->max_power * 2,
+				  min((u32) MAX_RATE_POWER,
+				      (u32) ah->regulatory.power_limit));
 	if (status != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			"error init'ing transmit power\n");
@@ -1632,12 +1632,12 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		}
 	}
 
-	if (ath9k_hw_set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(ah, chan),
-				 channel->max_antenna_gain * 2,
-				 channel->max_power * 2,
-				 min((u32) MAX_RATE_POWER,
-				     (u32) ah->regulatory.power_limit)) != 0) {
+	if (ah->eep_ops->set_txpower(ah, chan,
+			     ath9k_regd_get_ctl(ah, chan),
+			     channel->max_antenna_gain * 2,
+			     channel->max_power * 2,
+			     min((u32) MAX_RATE_POWER,
+				 (u32) ah->regulatory.power_limit)) != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"error init'ing transmit power\n");
 		return false;
@@ -1703,7 +1703,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel
 
 	ah->ah_config.spurmode = SPUR_ENABLE_EEPROM;
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		cur_bb_spur = ath9k_hw_eeprom_get_spur_chan(ah, i, is2GHz);
+		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
 
 		if (is2GHz)
 			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_2GHZ;
@@ -1946,7 +1946,7 @@ static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan
 	memset(&mask_p, 0, sizeof(int8_t) * 123);
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		cur_bb_spur = ath9k_hw_eeprom_get_spur_chan(ah, i, is2GHz);
+		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
 		if (AR_NO_SPUR == cur_bb_spur)
 			break;
 		cur_bb_spur = cur_bb_spur - (chan->channel * 10);
@@ -2211,7 +2211,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	else
 		ath9k_hw_spur_mitigate(ah, chan);
 
-	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
+	if (!ah->eep_ops->set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"error setting board options\n");
 		return -EIO;
@@ -3092,14 +3092,14 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u16 capField = 0, eeval;
 
-	eeval = ath9k_hw_get_eeprom(ah, EEP_REG_0);
+	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
 
 	ah->regulatory.current_rd = eeval;
 
-	eeval = ath9k_hw_get_eeprom(ah, EEP_REG_1);
+	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
 	ah->regulatory.current_rd_ext = eeval;
 
-	capField = ath9k_hw_get_eeprom(ah, EEP_OP_CAP);
+	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
 
 	if (ah->ah_opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
@@ -3112,7 +3112,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			"regdomain mapped to 0x%x\n", ah->regulatory.current_rd);
 	}
 
-	eeval = ath9k_hw_get_eeprom(ah, EEP_OP_MODE);
+	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
 	bitmap_zero(pCap->wireless_modes, ATH9K_MODE_MAX);
 
 	if (eeval & AR5416_OPFLAGS_11A) {
@@ -3146,11 +3146,11 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		}
 	}
 
-	pCap->tx_chainmask = ath9k_hw_get_eeprom(ah, EEP_TX_MASK);
+	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
 	if ((ah->ah_isPciExpress)
 	    || (eeval & AR5416_OPFLAGS_11A)) {
 		pCap->rx_chainmask =
-			ath9k_hw_get_eeprom(ah, EEP_RX_MASK);
+			ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
 	} else {
 		pCap->rx_chainmask =
 			(ath9k_hw_gpio_get(ah, 0)) ? 0x5 : 0x7;
@@ -3226,7 +3226,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	ah->ah_rfsilent = ath9k_hw_get_eeprom(ah, EEP_RF_SILENT);
+	ah->ah_rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
 	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
 		ah->ah_rfkill_gpio =
 			MS(ah->ah_rfsilent, EEP_RFSILENT_GPIO_SEL);
@@ -3266,9 +3266,9 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
 
 	pCap->num_antcfg_5ghz =
-		ath9k_hw_get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
+		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
 	pCap->num_antcfg_2ghz =
-		ath9k_hw_get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
+		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
 
 	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
@@ -3613,12 +3613,12 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 
 	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
 
-	if (ath9k_hw_set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(ah, chan),
-				 channel->max_antenna_gain * 2,
-				 channel->max_power * 2,
-				 min((u32) MAX_RATE_POWER,
-				     (u32) ah->regulatory.power_limit)) != 0)
+	if (ah->eep_ops->set_txpower(ah, chan,
+			     ath9k_regd_get_ctl(ah, chan),
+			     channel->max_antenna_gain * 2,
+			     channel->max_power * 2,
+			     min((u32) MAX_RATE_POWER,
+				 (u32) ah->regulatory.power_limit)) != 0)
 		return false;
 
 	return true;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 84914e2..f8f46db 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -430,6 +430,7 @@ struct ath_hw {
 		struct ar5416_eeprom_def def;
 		struct ar5416_eeprom_4k map4k;
 	} ah_eeprom;
+	const struct eeprom_ops *eep_ops;
 
 	bool sw_mgmt_crypto;
 	bool ah_isPciExpress;
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index da4165b..5a42969 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -205,7 +205,7 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		return true;
 
-	eepMinorRev = ath9k_hw_get_eeprom(ah, EEP_MINOR_REV);
+	eepMinorRev = ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV);
 
 	RF_BANK_SETUP(ah->ah_analogBank0Data, &ah->ah_iniBank0, 1);
 
@@ -225,15 +225,15 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	if (eepMinorRev >= 2) {
 		if (IS_CHAN_2GHZ(chan)) {
-			ob2GHz = ath9k_hw_get_eeprom(ah, EEP_OB_2);
-			db2GHz = ath9k_hw_get_eeprom(ah, EEP_DB_2);
+			ob2GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_2);
+			db2GHz = ah->eep_ops->get_eeprom(ah, EEP_DB_2);
 			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   ob2GHz, 3, 197, 0);
 			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   db2GHz, 3, 194, 0);
 		} else {
-			ob5GHz = ath9k_hw_get_eeprom(ah, EEP_OB_5);
-			db5GHz = ath9k_hw_get_eeprom(ah, EEP_DB_5);
+			ob5GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_5);
+			db5GHz = ah->eep_ops->get_eeprom(ah, EEP_DB_5);
 			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
 						   ob5GHz, 3, 203, 0);
 			ath9k_phy_modify_rx_buffer(ah->ah_analogBank6Data,
-- 
1.6.1

