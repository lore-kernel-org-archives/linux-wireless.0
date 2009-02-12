Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36314 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbZBLEk2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:28 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:28 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42845.342445.265729@gargle.gargle.HOWL> (sfid-20090212_054033_099280_3F2F33C8)
Date: Thu, 12 Feb 2009 10:06:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/8] ath9k: Enable Fractional N mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables Fractional N mode for all channel
if the EEPROM says so, and also fixes the INI only
when the device is not a 2 GHz only capable device.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    7 +++++++
 drivers/net/wireless/ath9k/eeprom.h |    6 +++++-
 drivers/net/wireless/ath9k/hw.c     |   18 ++++++++++--------
 drivers/net/wireless/ath9k/phy.c    |   19 +++++++++++++------
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index afbd753..c2335af 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -466,6 +466,8 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 		return pBase->txMask;
 	case EEP_RX_MASK:
 		return pBase->rxMask;
+	case EEP_FRAC_N_5G:
+		return 0;
 	default:
 		return 0;
 	}
@@ -1599,6 +1601,11 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 			return pBase->dacHiPwrMode_5G;
 		else
 			return 0;
+	case EEP_FRAC_N_5G:
+		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_22)
+			return pBase->frac_n_5g;
+		else
+			return 0;
 	default:
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 5c0d6c3..60cb23d 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -125,6 +125,7 @@
 #define AR5416_EEP_MINOR_VER_17      0x11
 #define AR5416_EEP_MINOR_VER_19      0x13
 #define AR5416_EEP_MINOR_VER_20      0x14
+#define AR5416_EEP_MINOR_VER_22      0x16
 
 #define AR5416_NUM_5G_CAL_PIERS         8
 #define AR5416_NUM_2G_CAL_PIERS         4
@@ -188,6 +189,7 @@ enum eeprom_param {
 	EEP_RXGAIN_TYPE,
 	EEP_TXGAIN_TYPE,
 	EEP_DAC_HPWR_5G,
+	EEP_FRAC_N_5G
 };
 
 enum ar5416_rates {
@@ -232,7 +234,9 @@ struct base_eep_header {
 	u8 txGainType;
 	u8 rcChainMask;
 	u8 desiredScaleCCK;
-	u8 futureBase_3[23];
+	u8 power_table_offset;
+	u8 frac_n_5g;
+	u8 futureBase_3[21];
 } __packed;
 
 struct base_eep_header_4k {
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 55d5a74..6939e41 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -823,7 +823,16 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_txgain_ini(ah);
 
-	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
+	if (!ath9k_hw_fill_cap_info(ah)) {
+		DPRINTF(sc, ATH_DBG_RESET, "failed ath9k_hw_fill_cap_info\n");
+		ecode = -EINVAL;
+		goto bad;
+	}
+
+	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
+	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
+
+		/* EEPROM Fixup */
 		for (i = 0; i < ah->iniModes.ia_rows; i++) {
 			u32 reg = INI_RA(&ah->iniModes, i, 0);
 
@@ -838,13 +847,6 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		}
 	}
 
-	if (!ath9k_hw_fill_cap_info(ah)) {
-		DPRINTF(sc, ATH_DBG_RESET,
-			"failed ath9k_hw_fill_cap_info\n");
-		ecode = -EINVAL;
-		goto bad;
-	}
-
 	ecode = ath9k_hw_init_macaddr(ah);
 	if (ecode != 0) {
 		DPRINTF(sc, ATH_DBG_RESET,
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 52aa2a7..e1494ba 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -132,20 +132,27 @@ ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 		bMode = 0;
 		fracMode = 0;
 
-		if ((freq % 20) == 0) {
-			aModeRefSel = 3;
-		} else if ((freq % 10) == 0) {
-			aModeRefSel = 2;
-		} else {
+		switch(ah->eep_ops->get_eeprom(ah, EEP_FRAC_N_5G)) {
+		case 0:
+			if ((freq % 20) == 0) {
+				aModeRefSel = 3;
+			} else if ((freq % 10) == 0) {
+				aModeRefSel = 2;
+			}
+			if (aModeRefSel)
+				break;
+		case 1:
+		default:
 			aModeRefSel = 0;
-
 			fracMode = 1;
 			refDivA = 1;
 			channelSel = (freq * 0x8000) / 15;
 
 			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
 				      AR_AN_SYNTH9_REFDIVA, refDivA);
+
 		}
+
 		if (!fracMode) {
 			ndiv = (freq * (refDivA >> aModeRefSel)) / 60;
 			channelSel = ndiv & 0x1ff;
-- 
1.6.1

