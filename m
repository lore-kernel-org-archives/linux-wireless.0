Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:43404 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbXKNQO2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:14:28 -0500
Date: Wed, 14 Nov 2007 18:14:40 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 2/4] ath5k: Fix device info reporting
Message-ID: <20071114161440.GB6365@localhost.domain.invalid> (sfid-20071114_161446_863437_89764AF2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*Fix device info code

Changes-licensed-under: 3-clause-BSD
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4c4837f..0d0e060 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -570,22 +570,40 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_ah;
 
-	dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
+	dev_info(&pdev->dev, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
 			ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
 					sc->ah->ah_mac_srev,
 					sc->ah->ah_phy_revision);
 
-	if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
-		dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
-			ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
-					sc->ah->ah_radio_5ghz_revision);
-	} else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
-		dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
-			ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
-					sc->ah->ah_radio_5ghz_revision);
-		dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
-			ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
-					sc->ah->ah_radio_2ghz_revision);
+	if(!sc->ah->ah_single_chip){
+		/* Single chip radio (!RF5111) */
+		if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision) {
+			/* No 5GHz support -> report 2GHz radio */
+			if(!test_bit(MODE_IEEE80211A, sc->ah->ah_capabilities.cap_mode)){
+				dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
+					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
+							sc->ah->ah_radio_5ghz_revision);
+			/* No 2GHz support (5110 and some 5Ghz only cards) -> report 5Ghz radio */
+			} else if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){
+				dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
+					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
+							sc->ah->ah_radio_5ghz_revision);
+			/* Multiband radio */
+			} else {
+				dev_info(&pdev->dev, "RF%s multiband radio found (0x%x)\n",
+					ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
+							sc->ah->ah_radio_5ghz_revision);
+			}
+		}
+		/* Multi chip radio (RF5111 - RF2111) -> report both 2GHz/5GHz radios */
+		else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
+			dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
+				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
+			dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
+				ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
+						sc->ah->ah_radio_2ghz_revision);
+		}
 	}
 
 


