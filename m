Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11905 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab0DGFde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:33:34 -0400
Subject: [PATCH] ath9k: simplify AR9220 fixup code for AR_AN_TOP2 register
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 01:33:33 -0400
Message-ID: <20100407053333.23713.61655.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't modify ah->iniModes, it's supposed to be constant.  Instead, apply
the fixup when the data is written to the registers.

Change ath9k_hw_init_eeprom_fix() to only determine whether the fixup is
needed.

This allows similteneous support for AR9220 cards that need AR_AN_TOP2
fixup (such as Ubiquiti SR71-12) and those that don't need it (D-Link
DWA-552 rev A2).

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   76 ++++++-----------------------------
 drivers/net/wireless/ath/ath9k/hw.h |    1 
 2 files changed, 13 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e716b60..9bf8e0d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -27,9 +27,6 @@
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
-static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value);
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
@@ -830,24 +827,17 @@ static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
 
 static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 {
-	u32 i, j;
-
-	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
-
-		/* EEPROM Fixup */
-		for (i = 0; i < ah->iniModes.ia_rows; i++) {
-			u32 reg = INI_RA(&ah->iniModes, i, 0);
+	struct base_eep_header *pBase = &(ah->eeprom.def.baseEepHeader);
+	struct ath_common *common = ath9k_hw_common(ah);
 
-			for (j = 1; j < ah->iniModes.ia_columns; j++) {
-				u32 val = INI_RA(&ah->iniModes, i, j);
+	ah->need_an_top2_fixup = (ah->hw_version.devid == AR9280_DEVID_PCI) &&
+				 (ah->eep_map != EEP_MAP_4KBITS) &&
+				 ((pBase->version & 0xff) > 0x0a) &&
+				 (pBase->pwdclkind == 0);
 
-				INI_RA(&ah->iniModes, i, j) =
-					ath9k_hw_ini_fixup(ah,
-							   &ah->eeprom.def,
-							   reg, val);
-			}
-		}
-	}
+	if (ah->need_an_top2_fixup)
+		ath_print(common, ATH_DBG_EEPROM,
+			  "needs fixup for AR_AN_TOP2 register\n");
 }
 
 int ath9k_hw_init(struct ath_hw *ah)
@@ -1289,51 +1279,6 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 	}
 }
 
-static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value)
-{
-	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	switch (ah->hw_version.devid) {
-	case AR9280_DEVID_PCI:
-		if (reg == 0x7894) {
-			ath_print(common, ATH_DBG_EEPROM,
-				"ini VAL: %x  EEPROM: %x\n", value,
-				(pBase->version & 0xff));
-
-			if ((pBase->version & 0xff) > 0x0a) {
-				ath_print(common, ATH_DBG_EEPROM,
-					  "PWDCLKIND: %d\n",
-					  pBase->pwdclkind);
-				value &= ~AR_AN_TOP2_PWDCLKIND;
-				value |= AR_AN_TOP2_PWDCLKIND &
-					(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
-			} else {
-				ath_print(common, ATH_DBG_EEPROM,
-					  "PWDCLKIND Earlier Rev\n");
-			}
-
-			ath_print(common, ATH_DBG_EEPROM,
-				  "final ini VAL: %x\n", value);
-		}
-		break;
-	}
-
-	return value;
-}
-
-static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value)
-{
-	if (ah->eep_map == EEP_MAP_4KBITS)
-		return value;
-	else
-		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
-}
-
 static void ath9k_olc_init(struct ath_hw *ah)
 {
 	u32 i;
@@ -1439,6 +1384,9 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		u32 reg = INI_RA(&ah->iniModes, i, 0);
 		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
 
+		if (reg == AR_AN_TOP2 && ah->need_an_top2_fixup)
+			val &= ~AR_AN_TOP2_PWDCLKIND;
+
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 97ebeba..7cbb16f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -461,6 +461,7 @@ struct ath_hw {
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
+	bool need_an_top2_fixup;
 	u16 tx_trig_level;
 	u16 rfsilent;
 	u32 rfkill_gpio;
