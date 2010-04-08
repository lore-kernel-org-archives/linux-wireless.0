Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab0DHT1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 073/102] ath9k_hw: move AR9280 PCI EEPROM fix to ar9002_hw.c
Date: Thu,  8 Apr 2010 15:27:09 -0400
Message-Id: <1270754858-26266-74-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   56 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   56 +---------------------------
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 3 files changed, 58 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index ecc0699..487cd8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -479,6 +479,62 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 	}
 }
 
+static u32 ar9280_pci_hw_def_ini_fixup(struct ath_hw *ah,
+				       struct ar5416_eeprom_def *pEepData,
+				       u32 reg,
+				       u32 value)
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
+void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah)
+{
+	u32 i, j;
+
+	/* EEPROM Fixup */
+	for (i = 0; i < ah->iniModes.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniModes, i, 0);
+
+		for (j = 1; j < ah->iniModes.ia_columns; j++) {
+			u32 val = INI_RA(&ah->iniModes, i, j);
+
+			INI_RA(&ah->iniModes, i, j) =
+				ar9280_pci_hw_def_ini_fixup(ah,
+							    &ah->eeprom.def,
+							    reg, val);
+		}
+	}
+}
+
+
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
 void ar9002_hw_attach_ops(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4cf11de..fcb6b6d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -521,60 +521,6 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	return 0;
 }
 
-static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value)
-{
-#define PWDCL_KIND	(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
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
-				value |= AR_AN_TOP2_PWDCLKIND & PWDCL_KIND
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
-static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
-{
-	u32 i, j;
-
-	/* EEPROM Fixup */
-	for (i = 0; i < ah->iniModes.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->iniModes, i, 0);
-
-		for (j = 1; j < ah->iniModes.ia_columns; j++) {
-			u32 val = INI_RA(&ah->iniModes, i, j);
-
-			INI_RA(&ah->iniModes, i, j) =
-				ath9k_hw_def_ini_fixup(ah,
-						&ah->eeprom.def,
-						reg, val);
-		}
-	}
-}
-
 static void ath9k_hw_attach_ops(struct ath_hw *ah)
 {
 	if (AR_SREV_9300_20_OR_LATER(ah))
@@ -662,7 +608,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return r;
 
 	if (ah->hw_version.devid == AR9280_DEVID_PCI)
-		ath9k_hw_init_eeprom_fix(ah);
+		ar9280_pci_hw_init_eeprom_fix(ah);
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6ae8353..e7c8005 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -839,6 +839,7 @@ void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
 
 void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
+void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah);
 
 /*
  * Code specifric to AR9003, we stuff these here to avoid callbacks
-- 
1.6.3.3

