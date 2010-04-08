Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab0DHT1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 074/102] ath9k_hw: simplify the AR9280 PCI EEPROM fix
Date: Thu,  8 Apr 2010 15:27:10 -0400
Message-Id: <1270754858-26266-75-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we know the EEPROM fix is only for AR9820 PCI
and that the code is only called for that case we can
simplify things a bit more.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   64 ++++++++++++++--------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 487cd8d..8441807 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -488,52 +488,52 @@ static u32 ar9280_pci_hw_def_ini_fixup(struct ath_hw *ah,
 	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
 	struct ath_common *common = ath9k_hw_common(ah);
 
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
-				value |= AR_AN_TOP2_PWDCLKIND & PWDCL_KIND
-			} else {
-				ath_print(common, ATH_DBG_EEPROM,
-					  "PWDCLKIND Earlier Rev\n");
-			}
+	if (reg == 0x7894) {
+		ath_print(common, ATH_DBG_EEPROM,
+			"ini VAL: %x  EEPROM: %x\n", value,
+			(pBase->version & 0xff));
 
+		if ((pBase->version & 0xff) > 0x0a) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "PWDCLKIND: %d\n",
+				  pBase->pwdclkind);
+			value &= ~AR_AN_TOP2_PWDCLKIND;
+			value |= AR_AN_TOP2_PWDCLKIND & PWDCL_KIND
+		} else {
 			ath_print(common, ATH_DBG_EEPROM,
-				  "final ini VAL: %x\n", value);
+				  "PWDCLKIND Earlier Rev\n");
 		}
-		break;
+
+		ath_print(common, ATH_DBG_EEPROM,
+			  "final ini VAL: %x\n", value);
 	}
 
 	return value;
 }
 
-void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah)
+static void ar9280_pci_hw_mode_eeprom_fix(struct ath_hw *ah, u32 row)
 {
-	u32 i, j;
+	u32 reg = INI_RA(&ah->iniModes, row, 0);
+	u32 column;
 
-	/* EEPROM Fixup */
-	for (i = 0; i < ah->iniModes.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->iniModes, i, 0);
-
-		for (j = 1; j < ah->iniModes.ia_columns; j++) {
-			u32 val = INI_RA(&ah->iniModes, i, j);
+	for (column = 1; column < ah->iniModes.ia_columns; column++) {
+		u32 val = INI_RA(&ah->iniModes, row, column);
 
-			INI_RA(&ah->iniModes, i, j) =
-				ar9280_pci_hw_def_ini_fixup(ah,
-							    &ah->eeprom.def,
-							    reg, val);
-		}
+		INI_RA(&ah->iniModes, row, column) =
+			ar9280_pci_hw_def_ini_fixup(ah,
+						    &ah->eeprom.def,
+						    reg, val);
 	}
 }
 
+void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah)
+{
+	u32 row;
+
+	/* EEPROM Fixup */
+	for (row = 0; row < ah->iniModes.ia_rows; row++)
+		ar9280_pci_hw_mode_eeprom_fix(ah, row);
+}
 
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
 void ar9002_hw_attach_ops(struct ath_hw *ah)
-- 
1.6.3.3

