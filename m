Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30462 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZBIIAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57810.402081.31777@gargle.gargle.HOWL> (sfid-20090209_090057_202851_E0830BBD)
Date: Mon, 9 Feb 2009 13:27:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 04/10] ath9k: Store HW version information in a separate structure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves all the HW version/revision specific
information into a separate structure.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ahb.c    |    8 ++--
 drivers/net/wireless/ath9k/eeprom.c |    4 +-
 drivers/net/wireless/ath9k/hw.c     |   62 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/hw.h     |   21 +++++++-----
 drivers/net/wireless/ath9k/pci.c    |    8 ++--
 drivers/net/wireless/ath9k/reg.h    |   54 +++++++++++++++++-------------
 6 files changed, 84 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
index 361ace1..d254b35 100644
--- a/drivers/net/wireless/ath9k/ahb.c
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -132,10 +132,10 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	       "%s: Atheros AR%s MAC/BB Rev:%x, "
 	       "AR%s RF Rev:%x, mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       ath_mac_bb_name(ah->ah_macVersion),
-	       ah->ah_macRev,
-	       ath_rf_name((ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR)),
-	       ah->ah_phyRev,
+	       ath_mac_bb_name(ah->hw_version.macVersion),
+	       ah->hw_version.macRev,
+	       ath_rf_name((ah->hw_version.analog5GhzRev & AR_RADIO_SREV_MAJOR)),
+	       ah->hw_version.phyRev,
 	       (unsigned long)mem, irq);
 
 	return 0;
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index aa62409..420a060 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1989,7 +1989,7 @@ static void ath9k_hw_set_def_addac(struct ath_hal *ah,
 	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	u8 biaslevel;
 
-	if (ah->ah_macVersion != AR_SREV_VERSION_9160)
+	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
 		return;
 
 	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
@@ -2043,7 +2043,7 @@ static void ath9k_hw_set_4k_addac(struct ath_hal *ah,
 	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
 	u8 biaslevel;
 
-	if (ah->ah_macVersion != AR_SREV_VERSION_9160)
+	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
 		return;
 
 	if (ar5416_get_eep_rev(ahp) < AR5416_EEP_MINOR_VER_7)
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 1a6c5ac..164a543 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -229,16 +229,17 @@ static void ath9k_hw_read_revisions(struct ath_hal *ah)
 
 	if (val == 0xFF) {
 		val = REG_READ(ah, AR_SREV);
-		ah->ah_macVersion = (val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
-		ah->ah_macRev = MS(val, AR_SREV_REVISION2);
+		ah->hw_version.macVersion =
+			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
+		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
 		ah->ah_isPciExpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
 	} else {
 		if (!AR_SREV_9100(ah))
-			ah->ah_macVersion = MS(val, AR_SREV_VERSION);
+			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
 
-		ah->ah_macRev = val & AR_SREV_REVISION;
+		ah->hw_version.macRev = val & AR_SREV_REVISION;
 
-		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCIE)
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
 			ah->ah_isPciExpress = true;
 	}
 }
@@ -407,14 +408,14 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 	ah = &ahp->ah;
 	ah->ah_sc = sc;
 	ah->ah_sh = mem;
-	ah->ah_magic = AR5416_MAGIC;
+	ah->hw_version.magic = AR5416_MAGIC;
 	ah->ah_countryCode = CTRY_DEFAULT;
-	ah->ah_devid = devid;
-	ah->ah_subvendorid = 0;
+	ah->hw_version.devid = devid;
+	ah->hw_version.subvendorid = 0;
 
 	ah->ah_flags = 0;
 	if ((devid == AR5416_AR9100_DEVID))
-		ah->ah_macVersion = AR_SREV_VERSION_9100;
+		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 	if (!AR_SREV_9100(ah))
 		ah->ah_flags = AH_USE_EEPROM;
 
@@ -473,11 +474,11 @@ static int ath9k_hw_rf_claim(struct ath_hal *ah)
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			"5G Radio Chip Rev 0x%02X is not "
 			"supported by this driver\n",
-			ah->ah_analog5GhzRev);
+			ah->hw_version.analog5GhzRev);
 		return -EOPNOTSUPP;
 	}
 
-	ah->ah_analog5GhzRev = val;
+	ah->hw_version.analog5GhzRev = val;
 
 	return 0;
 }
@@ -615,7 +616,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	}
 
 	if (ah->ah_config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) {
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) {
 			ah->ah_config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {
@@ -628,13 +629,14 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		"serialize_regmode is %d\n",
 		ah->ah_config.serialize_regmode);
 
-	if ((ah->ah_macVersion != AR_SREV_VERSION_5416_PCI) &&
-	    (ah->ah_macVersion != AR_SREV_VERSION_5416_PCIE) &&
-	    (ah->ah_macVersion != AR_SREV_VERSION_9160) &&
+	if ((ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCI) &&
+	    (ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCIE) &&
+	    (ah->hw_version.macVersion != AR_SREV_VERSION_9160) &&
 	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) && (!AR_SREV_9285(ah))) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
-			"this driver\n", ah->ah_macVersion, ah->ah_macRev);
+			"this driver\n", ah->hw_version.macVersion,
+			ah->hw_version.macRev);
 		ecode = -EOPNOTSUPP;
 		goto bad;
 	}
@@ -644,7 +646,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		ahp->ah_suppCals = IQ_MISMATCH_CAL;
 		ah->ah_isPciExpress = false;
 	}
-	ah->ah_phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
+	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
@@ -680,7 +682,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 		"This Mac Chip Rev 0x%02x.%x is \n",
-		ah->ah_macVersion, ah->ah_macRev);
+		ah->hw_version.macVersion, ah->hw_version.macRev);
 
 	if (AR_SREV_9285_12_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ahp->ah_iniModes, ar9285Modes_9285_1_2,
@@ -830,7 +832,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_txgain_ini(ah);
 
-	if (ah->ah_devid == AR9280_DEVID_PCI) {
+	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
 		for (i = 0; i < ahp->ah_iniModes.ia_rows; i++) {
 			u32 reg = INI_RA(&ahp->ah_iniModes, i, 0);
 
@@ -990,7 +992,7 @@ static void ath9k_hw_init_chain_masks(struct ath_hal *ah)
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
 	case 0x3:
-		if (((ah)->ah_macVersion <= AR_SREV_VERSION_9160)) {
+		if (((ah)->hw_version.macVersion <= AR_SREV_VERSION_9160)) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
 			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
 			break;
@@ -1181,7 +1183,7 @@ static u32 ath9k_hw_def_ini_fixup(struct ath_hal *ah,
 {
 	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
 
-	switch (ah->ah_devid) {
+	switch (ah->hw_version.devid) {
 	case AR9280_DEVID_PCI:
 		if (reg == 0x7894) {
 			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
@@ -2438,7 +2440,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				"AES-CCM not supported by mac rev 0x%x\n",
-				ah->ah_macRev);
+				ah->hw_version.macRev);
 			return false;
 		}
 		keyType = AR_KEYTABLE_TYPE_CCM;
@@ -2687,7 +2689,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 		}
 		udelay(1000);
 	} else if (AR_SREV_9280(ah) &&
-		   (ah->ah_macRev == AR_SREV_REVISION_9280_10)) {
+		   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
 
@@ -3142,7 +3144,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	capField = ath9k_hw_get_eeprom(ah, EEP_OP_CAP);
 
 	if (ah->ah_opmode != NL80211_IFTYPE_AP &&
-	    ah->ah_subvendorid == AR_SUBVENDOR_ID_NEW_A) {
+	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (ah->ah_currentRD == 0x64 || ah->ah_currentRD == 0x65)
 			ah->ah_currentRD += 5;
 		else if (ah->ah_currentRD == 0x41)
@@ -3195,7 +3197,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 			(ath9k_hw_gpio_get(ah, 0)) ? 0x5 : 0x7;
 	}
 
-	if (!(AR_SREV_9280(ah) && (ah->ah_macRev == 0)))
+	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
 		ahp->ah_miscMode |= AR_PCU_MIC_NEW_LOC_ENA;
 
 	pCap->low_2ghz_chan = 2312;
@@ -3276,11 +3278,11 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	}
 #endif
 
-	if ((ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) ||
-	    (ah->ah_macVersion == AR_SREV_VERSION_5416_PCIE) ||
-	    (ah->ah_macVersion == AR_SREV_VERSION_9160) ||
-	    (ah->ah_macVersion == AR_SREV_VERSION_9100) ||
-	    (ah->ah_macVersion == AR_SREV_VERSION_9280))
+	if ((ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9160) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9100) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280))
 		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index b353b1f..afa64bd 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -406,16 +406,19 @@ enum {
 	ATH9K_RESET_COLD,
 };
 
-struct ath_hal {
-	u32 ah_magic;
-	u16 ah_devid;
-	u16 ah_subvendorid;
-	u32 ah_macVersion;
-	u16 ah_macRev;
-	u16 ah_phyRev;
-	u16 ah_analog5GhzRev;
-	u16 ah_analog2GhzRev;
+struct ath9k_hw_version {
+	u32 magic;
+	u16 devid;
+	u16 subvendorid;
+	u32 macVersion;
+	u16 macRev;
+	u16 phyRev;
+	u16 analog5GhzRev;
+	u16 analog2GhzRev;
+};
 
+struct ath_hal {
+	struct ath9k_hw_version hw_version;
 	void __iomem *ah_sh;
 	struct ath_softc *ah_sc;
 
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index aa3ac20..192c8c4 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -190,10 +190,10 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	       "%s: Atheros AR%s MAC/BB Rev:%x "
 	       "AR%s RF Rev:%x: mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       ath_mac_bb_name(ah->ah_macVersion),
-	       ah->ah_macRev,
-	       ath_rf_name((ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR)),
-	       ah->ah_phyRev,
+	       ath_mac_bb_name(ah->hw_version.macVersion),
+	       ah->hw_version.macRev,
+	       ath_rf_name((ah->hw_version.analog5GhzRev & AR_RADIO_SREV_MAJOR)),
+	       ah->hw_version.phyRev,
 	       (unsigned long)mem, pdev->irq);
 
 	return 0;
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 45b9fbf..17ed190 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -160,7 +160,7 @@
 
 #define AR_SREV_VERSION_9100                  0x014
 
-#define AR_SREV_9100(ah) ((ah->ah_macVersion) == AR_SREV_VERSION_9100)
+#define AR_SREV_9100(ah) ((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
 #define AR_SREV_5416_V20_OR_LATER(_ah) \
 	(AR_SREV_9100((_ah)) || AR_SREV_5416_20_OR_LATER(_ah))
 #define AR_SREV_5416_V22_OR_LATER(_ah) \
@@ -747,44 +747,50 @@
 #define AR_SREV_REVISION_9285_12              2
 
 #define AR_SREV_9100_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion >= AR_SREV_VERSION_5416_PCIE))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_5416_PCIE))
 #define AR_SREV_5416_20_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion >= AR_SREV_VERSION_9160) || \
-		((_ah)->ah_macRev >= AR_SREV_REVISION_5416_20))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160) || \
+		((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20))
 #define AR_SREV_5416_22_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion >= AR_SREV_VERSION_9160) || \
-		((_ah)->ah_macRev >= AR_SREV_REVISION_5416_22))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160) || \
+		((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22))
 #define AR_SREV_9160(_ah) \
-	(((_ah)->ah_macVersion == AR_SREV_VERSION_9160))
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9160))
 #define AR_SREV_9160_10_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion >= AR_SREV_VERSION_9160))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160))
 #define AR_SREV_9160_11(_ah) \
-	(AR_SREV_9160(_ah) && ((_ah)->ah_macRev == AR_SREV_REVISION_9160_11))
+	(AR_SREV_9160(_ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9160_11))
 #define AR_SREV_9280(_ah) \
-	(((_ah)->ah_macVersion == AR_SREV_VERSION_9280))
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
 #define AR_SREV_9280_10_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion >= AR_SREV_VERSION_9280))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))
 #define AR_SREV_9280_20(_ah) \
-	(((_ah)->ah_macVersion == AR_SREV_VERSION_9280) && \
-		((_ah)->ah_macRev >= AR_SREV_REVISION_9280_20))
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
+		((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20))
 #define AR_SREV_9280_20_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion > AR_SREV_VERSION_9280) || \
-	(((_ah)->ah_macVersion == AR_SREV_VERSION_9280) && \
-	((_ah)->ah_macRev >= AR_SREV_REVISION_9280_20)))
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9280) || \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
+	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20)))
 
-#define AR_SREV_9285(_ah) (((_ah)->ah_macVersion == AR_SREV_VERSION_9285))
+#define AR_SREV_9285(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285))
 #define AR_SREV_9285_10_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion >= AR_SREV_VERSION_9285))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
 #define AR_SREV_9285_11(_ah) \
-	(AR_SREV_9280(ah) && ((_ah)->ah_macRev == AR_SREV_REVISION_9285_11))
+	(AR_SREV_9280(ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_11))
 #define AR_SREV_9285_11_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion > AR_SREV_VERSION_9285) || \
-	 (AR_SREV_9285(ah) && ((_ah)->ah_macRev >= AR_SREV_REVISION_9285_11)))
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
+	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
+			       AR_SREV_REVISION_9285_11)))
 #define AR_SREV_9285_12(_ah) \
-	(AR_SREV_9280(ah) && ((_ah)->ah_macRev == AR_SREV_REVISION_9285_12))
+	(AR_SREV_9280(ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_12))
 #define AR_SREV_9285_12_OR_LATER(_ah) \
-	(((_ah)->ah_macVersion > AR_SREV_VERSION_9285) || \
-	 (AR_SREV_9285(ah) && ((_ah)->ah_macRev >= AR_SREV_REVISION_9285_12)))
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
+	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
+			       AR_SREV_REVISION_9285_12)))
 
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
-- 
1.6.1

