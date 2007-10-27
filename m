Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34599 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXJ0XZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:25:01 -0400
Date: Sun, 28 Oct 2007 02:24:59 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 5/7] athk: Use SREV to identify single-chip solutions
Message-ID: <20071027232459.GE5973@localhost.domain.invalid> (sfid-20071028_002505_899736_FF479411)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use SREV instead of pci id to identify single chip solutions.

Srev is more accurate info to identify the chip + this makes 
it possible to identify some 5424 chips found on thinkpads with
faulty 5212 pci id.

Changes-licensed-under: ISC
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index c8d1fbd..1c10203 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -229,23 +229,6 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	ah->ah_software_retry = false;
 	ah->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
 
-	switch (device) {
-	case PCI_DEVICE_ID_ATHEROS_AR2413:
-	case PCI_DEVICE_ID_ATHEROS_AR5413:
-	case PCI_DEVICE_ID_ATHEROS_AR5424:
-		/*
-		 * Known single chip solutions
-		 */
-		ah->ah_single_chip = true;
-		break;
-	default:
-		/*
-		 * Multi chip solutions
-		 */
-		ah->ah_single_chip = false;
-		break;
-	}
-
 	/*
 	 * Set the mac revision based on the pci id
 	 */
@@ -295,6 +278,14 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
 				CHANNEL_2GHZ);
 
+	/* Identify single chip solutions */
+	if((srev <= AR5K_SREV_VER_AR5414) &&
+	(srev >= AR5K_SREV_VER_AR2424)) {
+		ah->ah_single_chip = true;
+	} else {
+		ah->ah_single_chip = false;
+	}
+
 	/* Single chip radio */
 	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
 		ah->ah_radio_2ghz_revision = 0;



