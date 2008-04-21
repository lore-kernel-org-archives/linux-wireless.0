Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:56119 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYDUS3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 14:29:46 -0400
Date: Mon, 21 Apr 2008 21:28:24 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH] ath5k: Fix radio identification on AR5424/2424
Message-ID: <20080421182824.GA3026@makis> (sfid-20080421_203042_382678_FA4F3E4A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 *Fix radio chip identification on AR5424/2424 during ath5k_hw_attach
 *Try to assign an RF2413 radio on AR2424 for testing

 Changes-licensed-under: ISC

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 87e7822..5fb1ae6 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -304,14 +304,20 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		ah->ah_radio = AR5K_RF2413;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
 	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC2) {
-
 		ah->ah_radio = AR5K_RF5413;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5133) {
 
-		if (ah->ah_mac_srev <= AR5K_SREV_VER_AR5424 &&
-			ah->ah_mac_srev >= AR5K_SREV_VER_AR2424)
+		/* AR5424 */
+		if (srev >= AR5K_SREV_VER_AR5424) {
+			ah->ah_radio = AR5K_RF5413;
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5424;
-		else
+		/* AR2424 */
+		} else {
+			ah->ah_radio = AR5K_RF2413; /* For testing */
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
+		}
+
 	/*
 	 * Register returns 0x4 for radio revision
 	 * so ath5k_hw_radio_revision doesn't parse the value

