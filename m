Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45233 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbYB1W6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:58:46 -0500
Date: Thu, 28 Feb 2008 17:58:42 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 3/8] ath5k: Identify RF2413 and deal with PHY_SPENDING
Message-ID: <5c1454da60bece1cae6cab4e025b1126d6e28f49.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_225859_809401_62FD1638)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Attach RF2413.

 * Propertly handle different AR5K_PHY_SPENDING settings for each RF
chip by adding a field in ath5k_hw. This way we won't have to check
inside hw_reset (see next patch).

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/ath5k.h |    1 +
 drivers/net/wireless/ath5k/hw.c    |   27 +++++++++++++++++++++++++--
 drivers/net/wireless/ath5k/reg.h   |    4 +++-
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 25c8e98..c0b6596 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -966,6 +966,7 @@ struct ath5k_hw {
 	u16			ah_phy_revision;
 	u16			ah_radio_5ghz_revision;
 	u16			ah_radio_2ghz_revision;
+	u32			ah_phy_spending;
 
 	enum ath5k_version	ah_version;
 	enum ath5k_radio	ah_radio;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 998da6b..96b881d 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -208,7 +208,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	/* Identify single chip solutions */
 	if((srev <= AR5K_SREV_VER_AR5414) &&
-	(srev >= AR5K_SREV_VER_AR2424)) {
+	(srev >= AR5K_SREV_VER_AR2413)) {
 		ah->ah_single_chip = true;
 	} else {
 		ah->ah_single_chip = false;
@@ -223,10 +223,33 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		ah->ah_radio = AR5K_RF5110;
 	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
 		ah->ah_radio = AR5K_RF5111;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5111;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC0) {
+
 		ah->ah_radio = AR5K_RF5112;
+
+		if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112A) {
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
+		} else {
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
+		}
+
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
+		ah->ah_radio = AR5K_RF2413;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
 	} else {
+
 		ah->ah_radio = AR5K_RF5413;
+
+		if (ah->ah_mac_srev <= AR5K_SREV_VER_AR5424 &&
+			ah->ah_mac_srev >= AR5K_SREV_VER_AR2424)
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5424;
+		else if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2425)
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
+		else
+			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
+
+
 	}
 
 	ah->ah_phy = AR5K_PHY(0);
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 2f41c83..30629b3 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1923,7 +1923,9 @@ after DFS is enabled */
 #define AR5K_PHY_SDELAY_32MHZ		0x000000ff
 #define AR5K_PHY_SPENDING		0x99f8
 #define AR5K_PHY_SPENDING_RF5111	0x00000018
-#define AR5K_PHY_SPENDING_RF5112	0x00000014
+#define AR5K_PHY_SPENDING_RF5112	0x00000014 /* <- i 've only seen this on 2425 dumps ! */
+#define AR5K_PHY_SPENDING_RF5112A	0x0000000e /* but since i only have 5112A-based chips */
+#define AR5K_PHY_SPENDING_RF5424	0x00000012 /* to test it might be also for old 5112.  */
 
 /*
  * Misc PHY/radio registers [5110 - 5111]
-- 
1.5.3.7

