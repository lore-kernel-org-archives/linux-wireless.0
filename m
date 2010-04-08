Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933248Ab0DHT1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 045/102] ath9k_hw: Get rid of eep_map and reorganize the functions.
Date: Thu,  8 Apr 2010 15:26:41 -0400
Message-Id: <1270754858-26266-46-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

The eep_map is used only for AR9280 PCI card ini fixup. We can
reorganize the code in such a way that eep_map can be removed
and also the makes the code more clearer.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |    3 -
 drivers/net/wireless/ath/ath9k/eeprom.h |    7 --
 drivers/net/wireless/ath/ath9k/hw.c     |  107 +++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/hw.h     |    1 -
 4 files changed, 46 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index dacaae9..1a48f43 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -257,13 +257,10 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah)
 	int status;
 
 	if (AR_SREV_9287(ah)) {
-		ah->eep_map = EEP_MAP_AR9287;
 		ah->eep_ops = &eep_AR9287_ops;
 	} else if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
-		ah->eep_map = EEP_MAP_4KBITS;
 		ah->eep_ops = &eep_4k_ops;
 	} else {
-		ah->eep_map = EEP_MAP_DEFAULT;
 		ah->eep_ops = &eep_def_ops;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 2f2993b..e087e2d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -656,13 +656,6 @@ struct ath9k_country_entry {
 	u8 iso[3];
 };
 
-enum ath9k_eep_map {
-	EEP_MAP_DEFAULT = 0x0,
-	EEP_MAP_4KBITS,
-	EEP_MAP_AR9287,
-	EEP_MAP_MAX
-};
-
 struct eeprom_ops {
 	int (*check_eeprom)(struct ath_hw *hw);
 	u32 (*get_eeprom)(struct ath_hw *hw, enum eeprom_param param);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 312eda4..2ede866 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -33,9 +33,6 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah);
 static void ar9003_hw_attach_ops(struct ath_hw *ah);
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
-static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value);
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
@@ -937,24 +934,56 @@ static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
 	}
 }
 
+static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
+			      struct ar5416_eeprom_def *pEepData,
+			      u32 reg, u32 value)
+{
+#define PWDCL_KIND	(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
+	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	switch (ah->hw_version.devid) {
+	case AR9280_DEVID_PCI:
+		if (reg == 0x7894) {
+			ath_print(common, ATH_DBG_EEPROM,
+				"ini VAL: %x  EEPROM: %x\n", value,
+				(pBase->version & 0xff));
+
+			if ((pBase->version & 0xff) > 0x0a) {
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PWDCLKIND: %d\n",
+					  pBase->pwdclkind);
+				value &= ~AR_AN_TOP2_PWDCLKIND;
+				value |= AR_AN_TOP2_PWDCLKIND & PWDCL_KIND
+			} else {
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PWDCLKIND Earlier Rev\n");
+			}
+
+			ath_print(common, ATH_DBG_EEPROM,
+				  "final ini VAL: %x\n", value);
+		}
+		break;
+	}
+
+	return value;
+}
+
 static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 {
 	u32 i, j;
 
-	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
+	/* EEPROM Fixup */
+	for (i = 0; i < ah->iniModes.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniModes, i, 0);
 
-		/* EEPROM Fixup */
-		for (i = 0; i < ah->iniModes.ia_rows; i++) {
-			u32 reg = INI_RA(&ah->iniModes, i, 0);
+		for (j = 1; j < ah->iniModes.ia_columns; j++) {
+			u32 val = INI_RA(&ah->iniModes, i, j);
 
-			for (j = 1; j < ah->iniModes.ia_columns; j++) {
-				u32 val = INI_RA(&ah->iniModes, i, j);
-
-				INI_RA(&ah->iniModes, i, j) =
-					ath9k_hw_ini_fixup(ah,
-							   &ah->eeprom.def,
-							   reg, val);
-			}
+			INI_RA(&ah->iniModes, i, j) =
+				ath9k_hw_def_ini_fixup(ah,
+						&ah->eeprom.def,
+						reg, val);
 		}
 	}
 }
@@ -1058,7 +1087,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
-	ath9k_hw_init_eeprom_fix(ah);
+	if (ah->hw_version.devid == AR9280_DEVID_PCI)
+		ath9k_hw_init_eeprom_fix(ah);
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
@@ -1284,51 +1314,6 @@ EXPORT_SYMBOL(ath9k_hw_deinit);
 /* INI */
 /*******/
 
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
 u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 {
 	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 89708d8..111b7cb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -543,7 +543,6 @@ struct ath_hw {
 		struct ar9287_eeprom map9287;
 	} eeprom;
 	const struct eeprom_ops *eep_ops;
-	enum ath9k_eep_map eep_map;
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
-- 
1.6.3.3

