Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:37552 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYI1WSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 18:18:17 -0400
Date: Mon, 29 Sep 2008 01:18:16 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 2/5] ath5k: Use new srevs to properly attach radio chips
Message-ID: <20080928221816.GB21335@makis> (sfid-20080929_001823_338666_8C69A7D9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Use new SREV values and PHY srevs to identify radio type durring attach

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/attach.c |  182 ++++++++++++++++++++++-------------
 1 files changed, 113 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
index d92b4a1..51d5698 100644
--- a/drivers/net/wireless/ath5k/attach.c
+++ b/drivers/net/wireless/ath5k/attach.c
@@ -137,7 +137,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	ah->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
 
 	/*
-	 * Set the mac revision based on the pci id
+	 * Set the mac version based on the pci id
 	 */
 	ah->ah_version = mac_version;
 
@@ -160,87 +160,132 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 			0xffffffff;
 	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
 			CHANNEL_5GHZ);
+	ah->ah_phy = AR5K_PHY(0);
 
-	if (ah->ah_version == AR5K_AR5210)
-		ah->ah_radio_2ghz_revision = 0;
-	else
-		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
-				CHANNEL_2GHZ);
-
-	/* Return on unsuported chips (unsupported eeprom etc) */
-	if ((srev >= AR5K_SREV_AR5416) &&
-	(srev < AR5K_SREV_AR2425)) {
-		ATH5K_ERR(sc, "Device not yet supported.\n");
-		ret = -ENODEV;
-		goto err_free;
-	} else if (srev == AR5K_SREV_AR2425) {
-		ATH5K_WARN(sc, "Support for RF2425 is under development.\n");
-	}
-
-	/* Identify single chip solutions */
-	if (((srev <= AR5K_SREV_AR5414) &&
-	(srev >= AR5K_SREV_AR2413)) ||
-	(srev == AR5K_SREV_AR2425)) {
-		ah->ah_single_chip = true;
-	} else {
-		ah->ah_single_chip = false;
-	}
-
-	/* Single chip radio */
-	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
-		ah->ah_radio_2ghz_revision = 0;
-
-	/* Identify the radio chip*/
-	if (ah->ah_version == AR5K_AR5210) {
-		ah->ah_radio = AR5K_RF5110;
-	/*
-	 * Register returns 0x0/0x04 for radio revision
-	 * so ath5k_hw_radio_revision doesn't parse the value
-	 * correctly. For now we are based on mac's srev to
-	 * identify RF2425 radio.
-	 */
-	} else if (srev == AR5K_SREV_AR2425) {
-		ah->ah_radio = AR5K_RF2425;
-		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
+	/* Try to identify radio chip based on it's srev */
+	switch (ah->ah_radio_5ghz_revision & 0xf0) {
+	case AR5K_SREV_RAD_5111:
 		ah->ah_radio = AR5K_RF5111;
+		ah->ah_single_chip = false;
+		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
+							CHANNEL_2GHZ);
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5111;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_2413) {
+		break;
+	case AR5K_SREV_RAD_5112:
+	case AR5K_SREV_RAD_2112:
 		ah->ah_radio = AR5K_RF5112;
+		ah->ah_single_chip = false;
+		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
+							CHANNEL_2GHZ);
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5413) {
+		break;
+	case AR5K_SREV_RAD_2413:
 		ah->ah_radio = AR5K_RF2413;
+		ah->ah_single_chip = true;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_2316) {
+		break;
+	case AR5K_SREV_RAD_5413:
 		ah->ah_radio = AR5K_RF5413;
+		ah->ah_single_chip = true;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5133) {
-		/* AR5424 */
-		if (srev >= AR5K_SREV_AR5424) {
+		break;
+	case AR5K_SREV_RAD_2316:
+		ah->ah_radio = AR5K_RF2316;
+		ah->ah_single_chip = true;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2316;
+		break;
+	case AR5K_SREV_RAD_2317:
+		ah->ah_radio = AR5K_RF2317;
+		ah->ah_single_chip = true;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2317;
+		break;
+	case AR5K_SREV_RAD_5424:
+		if (ah->ah_mac_version == AR5K_SREV_AR2425 ||
+		ah->ah_mac_version == AR5K_SREV_AR2417){
+			ah->ah_radio = AR5K_RF2425;
+			ah->ah_single_chip = true;
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
+		} else {
 			ah->ah_radio = AR5K_RF5413;
+			ah->ah_single_chip = true;
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
-		/* AR2424 */
-		} else {
-			ah->ah_radio = AR5K_RF2413; /* For testing */
+		}
+		break;
+	default:
+		/* Identify radio based on mac/phy srev */
+		if (ah->ah_version == AR5K_AR5210) {
+			ah->ah_radio = AR5K_RF5110;
+			ah->ah_single_chip = false;
+		} else if (ah->ah_version == AR5K_AR5211) {
+			ah->ah_radio = AR5K_RF5111;
+			ah->ah_single_chip = false;
+			ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
+								CHANNEL_2GHZ);
+		} else if (ah->ah_mac_version == (AR5K_SREV_AR2425 >> 4) ||
+		ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4) ||
+		ah->ah_phy_revision == AR5K_SREV_PHY_2425) {
+			ah->ah_radio = AR5K_RF2425;
+			ah->ah_single_chip = true;
+			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_2425;
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
+		} else if (srev == AR5K_SREV_AR5213A &&
+		ah->ah_phy_revision == AR5K_SREV_PHY_2112B) {
+			ah->ah_radio = AR5K_RF5112;
+			ah->ah_single_chip = false;
+			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_2112B;
+		} else if (ah->ah_mac_version == (AR5K_SREV_AR2415 >> 4)) {
+			ah->ah_radio = AR5K_RF2316;
+			ah->ah_single_chip = true;
+			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_2316;
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2316;
+		} else if (ah->ah_mac_version == (AR5K_SREV_AR5414 >> 4) ||
+		ah->ah_phy_revision == AR5K_SREV_PHY_5413) {
+			ah->ah_radio = AR5K_RF5413;
+			ah->ah_single_chip = true;
+			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_5413;
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
+		} else if (ah->ah_mac_version == (AR5K_SREV_AR2414 >> 4) ||
+		ah->ah_phy_revision == AR5K_SREV_PHY_2413) {
+			ah->ah_radio = AR5K_RF2413;
+			ah->ah_single_chip = true;
+			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_2413;
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
+		} else {
+			ATH5K_ERR(sc, "Couldn't identify radio revision.\n");
+			ret = -ENODEV;
+			goto err_free;
 		}
 	}
-	ah->ah_phy = AR5K_PHY(0);
+
+
+	/* Return on unsuported chips (unsupported eeprom etc) */
+	if ((srev >= AR5K_SREV_AR5416) &&
+	(srev < AR5K_SREV_AR2425)) {
+		ATH5K_ERR(sc, "Device not yet supported.\n");
+		ret = -ENODEV;
+		goto err_free;
+	}
 
 	/*
 	 * Write PCI-E power save settings
 	 */
 	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
-		ath5k_hw_reg_write(ah, 0x9248fc00, 0x4080);
-		ath5k_hw_reg_write(ah, 0x24924924, 0x4080);
-		ath5k_hw_reg_write(ah, 0x28000039, 0x4080);
-		ath5k_hw_reg_write(ah, 0x53160824, 0x4080);
-		ath5k_hw_reg_write(ah, 0xe5980579, 0x4080);
-		ath5k_hw_reg_write(ah, 0x001defff, 0x4080);
-		ath5k_hw_reg_write(ah, 0x1aaabe40, 0x4080);
-		ath5k_hw_reg_write(ah, 0xbe105554, 0x4080);
-		ath5k_hw_reg_write(ah, 0x000e3007, 0x4080);
-		ath5k_hw_reg_write(ah, 0x00000000, 0x4084);
+		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
+		/* Shut off RX when elecidle is asserted */
+		ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);
+		/* TODO: EEPROM work */
+		ath5k_hw_reg_write(ah, 0xe5980579, AR5K_PCIE_SERDES);
+		/* Shut off PLL and CLKREQ active in L1 */
+		ath5k_hw_reg_write(ah, 0x001defff, AR5K_PCIE_SERDES);
+		/* Preserce other settings */
+		ath5k_hw_reg_write(ah, 0x1aaabe40, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0xbe105554, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0x000e3007, AR5K_PCIE_SERDES);
+		/* Reset SERDES to load new settings */
+		ath5k_hw_reg_write(ah, 0x00000000, AR5K_PCIE_SERDES_RESET);
+		mdelay(1);
 	}
 
 	/*
@@ -250,14 +295,13 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	if (ret)
 		goto err_free;
 
-	/* Write AR5K_PCICFG_UNK on 2112B and later chips */
-	if (ah->ah_radio_5ghz_revision > AR5K_SREV_RAD_2112B ||
-	srev > AR5K_SREV_AR2413) {
+	/* Enable pci core retry fix on Hainan (5213A) and later chips */
+	if (srev >= AR5K_SREV_AR5213A)
 		ath5k_hw_reg_write(ah, AR5K_PCICFG_RETRY_FIX, AR5K_PCICFG);
-	}
 
 	/*
-	 * Get card capabilities, values, ...
+	 * Get card capabilities, calibration values etc
+	 * TODO: EEPROM work
 	 */
 	ret = ath5k_eeprom_init(ah);
 	if (ret) {
@@ -273,7 +317,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		goto err_free;
 	}
 
-	/* Get MAC address */
+	/* Set MAC address */
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
 		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
