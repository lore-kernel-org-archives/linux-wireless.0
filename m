Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63480 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZCMDaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:30:06 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:30:05 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53827.387393.694183@gargle.gargle.HOWL> (sfid-20090313_043012_505674_32338C14)
Date: Fri, 13 Mar 2009 08:55:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/7] ath9k: Miscellaneous EEPROM handling cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print the EEPROM version/revision on init.
Choose appropriate debug masks on error conditions,
and remove useless print messages.
---
 drivers/net/wireless/ath9k/eeprom.c |   75 +++++++++++-----------------------
 drivers/net/wireless/ath9k/hw.c     |    4 ++
 2 files changed, 28 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 183c949..6c9bc5f 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -342,8 +342,7 @@ static int ath9k_hw_4k_get_eeprom_rev(struct ath_hw *ah)
 static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(u16))
-	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
-	u16 *eep_data;
+	u16 *eep_data = (u16 *)&ah->eeprom.map4k;
 	int addr, eep_start_loc = 0;
 
 	eep_start_loc = 64;
@@ -353,8 +352,6 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 			"Reading from EEPROM, not flash\n");
 	}
 
-	eep_data = (u16 *)eep;
-
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
@@ -363,6 +360,7 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 		}
 		eep_data++;
 	}
+
 	return true;
 #undef SIZE_EEPROM_4K
 }
@@ -379,16 +377,15 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 
 
 	if (!ath9k_hw_use_flash(ah)) {
-
 		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
 					 &magic)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Reading Magic # failed\n");
 			return false;
 		}
 
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Read Magic = 0x%04X\n", magic);
+			"Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -401,16 +398,9 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 					temp = swab16(*eepdata);
 					*eepdata = temp;
 					eepdata++;
-
-					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-						"0x%04X  ", *eepdata);
-
-					if (((addr + 1) % 6) == 0)
-						DPRINTF(ah->ah_sc,
-							ATH_DBG_EEPROM, "\n");
 				}
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 					"Invalid EEPROM Magic. "
 					"endianness mismatch.\n");
 				return -EINVAL;
@@ -441,7 +431,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		u16 word;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"EEPROM Endianness is not native.. Changing \n");
+			"EEPROM Endianness is not native.. Changing\n");
 
 		word = swab16(eep->baseEepHeader.length);
 		eep->baseEepHeader.length = word;
@@ -483,7 +473,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
 	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
@@ -1295,9 +1285,6 @@ static bool ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 		db2[4] = ((pModal->db2_234 >> 8) & 0xf);
 
 	} else if (pModal->version == 1) {
-
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"EEPROM Model version is set to 1 \n");
 		ob[0] = (pModal->ob_01 & 0xf);
 		ob[1] = ob[2] = ob[3] = ob[4] = (pModal->ob_01 >> 4) & 0xf;
 		db1[0] = (pModal->db1_01 & 0xf);
@@ -1464,16 +1451,13 @@ static int ath9k_hw_def_get_eeprom_rev(struct ath_hw *ah)
 static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
-	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
-	u16 *eep_data;
+	u16 *eep_data = (u16 *)&ah->eeprom.def;
 	int addr, ar5416_eep_start_loc = 0x100;
 
-	eep_data = (u16 *)eep;
-
 	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
 		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
 					 eep_data)) {
-			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				"Unable to read eeprom region\n");
 			return false;
 		}
@@ -1492,17 +1476,14 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	bool need_swap = false;
 	int i, addr, size;
 
-	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
-				 &magic)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"Reading Magic # failed\n");
+	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Reading Magic # failed\n");
 		return false;
 	}
 
 	if (!ath9k_hw_use_flash(ah)) {
-
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Read Magic = 0x%04X\n", magic);
+			"Read Magic = 0x%04X\n", magic);
 
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
@@ -1516,18 +1497,11 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 					temp = swab16(*eepdata);
 					*eepdata = temp;
 					eepdata++;
-
-					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-						"0x%04X  ", *eepdata);
-
-					if (((addr + 1) % 6) == 0)
-						DPRINTF(ah->ah_sc,
-							ATH_DBG_EEPROM, "\n");
 				}
 			} else {
-				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 					"Invalid EEPROM Magic. "
-					"endianness mismatch.\n");
+					"Endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
@@ -1556,7 +1530,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		u16 word;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"EEPROM Endianness is not native.. Changing \n");
+			"EEPROM Endianness is not native.. Changing.\n");
 
 		word = swab16(eep->baseEepHeader.length);
 		eep->baseEepHeader.length = word;
@@ -1602,7 +1576,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 
 	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR5416_EEP_VER ||
 	    ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			sum, ah->eep_ops->get_eeprom_ver(ah));
 		return -EINVAL;
@@ -1855,8 +1829,6 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 					  AR_AN_TOP2_LOCALBIAS,
 					  AR_AN_TOP2_LOCALBIAS_S,
 					  pModal->local_bias);
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "ForceXPAon: %d\n",
-			pModal->force_xpaon);
 		REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
 			      pModal->force_xpaon);
 	}
@@ -1882,6 +1854,7 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 
 	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3, AR_PHY_TX_END_TO_A2_RX_ON,
 		      pModal->txEndToRxOn);
+
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_CCA, AR9280_PHY_CCA_THRESH62,
 			      pModal->thresh62);
@@ -1912,10 +1885,10 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 	}
 
 	if (AR_SREV_9280_20_OR_LATER(ah) &&
-			AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_19)
+	    AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_19)
 		REG_RMW_FIELD(ah, AR_PHY_CCK_TX_CTRL,
-				AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK,
-				pModal->miscBits);
+			      AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK,
+			      pModal->miscBits);
 
 
 	if (AR_SREV_9280_20(ah) && AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_20) {
@@ -1926,14 +1899,14 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			REG_RMW_FIELD(ah, AR_AN_TOP1, AR_AN_TOP1_DACIPMODE, 0);
 		else
 			REG_RMW_FIELD(ah, AR_AN_TOP1, AR_AN_TOP1_DACIPMODE,
-					eep->baseEepHeader.dacLpMode);
+				      eep->baseEepHeader.dacLpMode);
 
 		REG_RMW_FIELD(ah, AR_PHY_FRAME_CTL, AR_PHY_FRAME_CTL_TX_CLIP,
-				pModal->miscBits >> 2);
+			      pModal->miscBits >> 2);
 
 		REG_RMW_FIELD(ah, AR_PHY_TX_PWRCTRL9,
-				AR_PHY_TX_DESIRED_SCALE_CCK,
-				eep->baseEepHeader.desiredScaleCCK);
+			      AR_PHY_TX_DESIRED_SCALE_CCK,
+			      eep->baseEepHeader.desiredScaleCCK);
 	}
 
 	return true;
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 51d3a4e..00c9e78 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -588,6 +588,10 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 	ecode = ath9k_hw_eeprom_attach(ah);
 	if (ecode != 0)
 		return ecode;
+
+	DPRINTF(ah->ah_sc, ATH_DBG_CONFIG, "Eeprom VER: %d, REV: %d\n",
+		ah->eep_ops->get_eeprom_ver(ah), ah->eep_ops->get_eeprom_rev(ah));
+
 	ecode = ath9k_hw_rfattach(ah);
 	if (ecode != 0)
 		return ecode;
-- 
1.6.2

