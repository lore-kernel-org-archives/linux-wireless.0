Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33520 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbcJBW3Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 18:29:25 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, arnd@arndb.de
Cc: chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 4/7] ath9k: replace eeprom_param EEP_MINOR_REV with get_eeprom_rev
Date: Mon,  3 Oct 2016 00:29:10 +0200
Message-Id: <20161002222913.12223-5-martin.blumenstingl@googlemail.com> (sfid-20161003_002935_089016_05ADD4AD)
In-Reply-To: <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
 <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_eeprom(ah, EEP_MINOR_REV) and get_eeprom_rev(ah) are both doing the
same thing: returning the EEPROM revision (12 lowest bits). Make the
code consistent by using get_eeprom_rev(ah) everywhere.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 2 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c   | 6 ++----
 drivers/net/wireless/ath/ath9k/eeprom.h      | 1 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 5 -----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c | 6 +-----
 drivers/net/wireless/ath/ath9k/eeprom_def.c  | 2 --
 6 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 8eea8d2..7922550 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -524,7 +524,7 @@ static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
 		return true;
 
 	/* Setup rf parameters */
-	eepMinorRev = ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV);
+	eepMinorRev = ah->eep_ops->get_eeprom_rev(ah);
 
 	for (i = 0; i < ah->iniBank6.ia_rows; i++)
 		ah->analogBank6Data[i] = INI_RA(&ah->iniBank6, i, modesIndex);
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index d480d2f..ae68f67 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -108,8 +108,7 @@ static void ar9280_20_hw_init_rxgain_ini(struct ath_hw *ah)
 {
 	u32 rxgain_type;
 
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >=
-	    AR5416_EEP_MINOR_VER_17) {
+	if (ah->eep_ops->get_eeprom_rev(ah) >= AR5416_EEP_MINOR_VER_17) {
 		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
 
 		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
@@ -129,8 +128,7 @@ static void ar9280_20_hw_init_rxgain_ini(struct ath_hw *ah)
 
 static void ar9280_20_hw_init_txgain_ini(struct ath_hw *ah, u32 txgain_type)
 {
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >=
-	    AR5416_EEP_MINOR_VER_19) {
+	if (ah->eep_ops->get_eeprom_rev(ah) >= AR5416_EEP_MINOR_VER_19) {
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 				       ar9280Modes_high_power_tx_gain_9280_2);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 408cfa7..8ef8090 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -230,7 +230,6 @@ enum eeprom_param {
 	EEP_DB_5,
 	EEP_OB_2,
 	EEP_DB_2,
-	EEP_MINOR_REV,
 	EEP_TX_MASK,
 	EEP_RX_MASK,
 	EEP_FSTCLK_5G,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 7cd9c64..d466871 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -254,9 +254,6 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
-	u16 ver_minor;
-
-	ver_minor = pBase->version & AR5416_EEP_VER_MINOR_MASK;
 
 	switch (param) {
 	case EEP_NFTHRESH_2:
@@ -279,8 +276,6 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 		return pModal->ob_0;
 	case EEP_DB_2:
 		return pModal->db1_1;
-	case EEP_MINOR_REV:
-		return ver_minor;
 	case EEP_TX_MASK:
 		return pBase->txMask;
 	case EEP_RX_MASK:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index e1ba9bc..7f85bd1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -250,9 +250,7 @@ static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
-	u16 ver_minor;
-
-	ver_minor = pBase->version & AR9287_EEP_VER_MINOR_MASK;
+	u16 ver_minor = ath9k_hw_ar9287_get_eeprom_rev(ah);
 
 	switch (param) {
 	case EEP_NFTHRESH_2:
@@ -271,8 +269,6 @@ static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 		return pBase->opCapFlags;
 	case EEP_RF_SILENT:
 		return pBase->rfSilent;
-	case EEP_MINOR_REV:
-		return ver_minor;
 	case EEP_TX_MASK:
 		return pBase->txMask;
 	case EEP_RX_MASK:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 087bdb7..e9af4a5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -380,8 +380,6 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 		return pModal[1].ob;
 	case EEP_DB_2:
 		return pModal[1].db;
-	case EEP_MINOR_REV:
-		return AR5416_VER_MASK;
 	case EEP_TX_MASK:
 		return pBase->txMask;
 	case EEP_RX_MASK:
-- 
2.10.0
