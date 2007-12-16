Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:45300 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbXLPBHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 20:07:33 -0500
Date: Sun, 16 Dec 2007 03:07:33 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 7/9] ath5k: Fix support for RF2112A based b/g only cards
Message-ID: <20071216010733.GG5482@makis.domain.invalid> (sfid-20071216_010735_775548_1DB69BA2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Fix support for 2112A based b/g only cards (turbog needs review).
* Enable a part of rf5112_rfregs code that commits x_gain for testing.

Thanx to John who gave me his b/g card ;-)

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 4daccc8..b959417 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -24,7 +24,6 @@
 #include "ath5k.h"
 #include "reg.h"
 #include "base.h"
-#include "debug.h"
 
 /* Struct to hold initial RF register values (RF Banks) */
 struct ath5k_ini_rf {
@@ -459,6 +458,123 @@ static const struct ath5k_ini_rf rfregs_5112a[] = {
 	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } },
 };
 
+
+static const struct ath5k_ini_rf rfregs_2112a[] = {
+	{ 1, AR5K_RF_BUFFER_CONTROL_4,
+	/*	   mode b	mode g	  mode gTurbo */
+		{ 0x00000020, 0x00000020, 0x00000020 } },
+	{ 2, AR5K_RF_BUFFER_CONTROL_3,
+		{ 0x03060408, 0x03060408, 0x03070408 } },
+	{ 3, AR5K_RF_BUFFER_CONTROL_6,
+		{ 0x00e020c0, 0x00e020c0, 0x00e020c0 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x0a000000, 0x0a000000, 0x0a000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00800000, 0x00800000, 0x00800000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x002a0000, 0x002a0000, 0x002a0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00010000, 0x00010000, 0x00010000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00180000, 0x00180000, 0x00180000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x006e0000, 0x006e0000, 0x006e0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00c70000, 0x00c70000, 0x00c70000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x004b0000, 0x004b0000, 0x004b0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x04480000, 0x04480000, 0x04480000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x002a0000, 0x002a0000, 0x002a0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00e40000, 0x00e40000, 0x00e40000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00fc0000, 0x00fc0000, 0x00fc0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x043f0000, 0x043f0000, 0x043f0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x0c0c0000, 0x0c0c0000, 0x0c0c0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x02190000, 0x02190000, 0x02190000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00240000, 0x00240000, 0x00240000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00b40000, 0x00b40000, 0x00b40000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00990000, 0x00990000, 0x00990000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00500000, 0x00500000, 0x00500000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x002a0000, 0x002a0000, 0x002a0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00120000, 0x00120000, 0x00120000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0xc0320000, 0xc0320000, 0xc0320000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x01740000, 0x01740000, 0x01740000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00110000, 0x00110000, 0x00110000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x86280000, 0x86280000, 0x86280000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x31840000, 0x31840000, 0x31840000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00f20080, 0x00f20080, 0x00f20080 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00070019, 0x00070019, 0x00070019 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x000000b2, 0x000000b2, 0x000000b2 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00b02184, 0x00b02184, 0x00b02184 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x004125a4, 0x004125a4, 0x004125a4 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00119220, 0x00119220, 0x00119220 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x001a4800, 0x001a4800, 0x001a4800 } },
+	{ 6, AR5K_RF_BUFFER_CONTROL_5,
+		{ 0x000b0230, 0x000b0230, 0x000b0230 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000094, 0x00000094, 0x00000094 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000091, 0x00000091, 0x00000091 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000012, 0x00000012, 0x00000012 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000080, 0x00000080, 0x00000080 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x000000d9, 0x000000d9, 0x000000d9 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000060, 0x00000060, 0x00000060 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x000000f0, 0x000000f0, 0x000000f0 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x000000a2, 0x000000a2, 0x000000a2 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000052, 0x00000052, 0x00000052 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x000000d4, 0x000000d4, 0x000000d4 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x000014cc, 0x000014cc, 0x000014cc } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x0000048c, 0x0000048c, 0x0000048c } },
+	{ 7, AR5K_RF_BUFFER_CONTROL_1,
+		{ 0x00000003, 0x00000003, 0x00000003 } },
+};
+
 /* RF5413/5414 mode-specific init registers */
 static const struct ath5k_ini_rf rfregs_5413[] = {
 	{ 1, 0x98d4,
@@ -923,7 +1039,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 
 	/* Modify bank 0 */
 	if (channel->val & CHANNEL_2GHZ) {
-		if (channel->val & CHANNEL_B)
+		if (channel->val & CHANNEL_CCK)
 			ee_mode = AR5K_EEPROM_MODE_11B;
 		else
 			ee_mode = AR5K_EEPROM_MODE_11G;
@@ -1007,7 +1123,16 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 
 	rf = ah->ah_rf_banks;
 
-	if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
+	if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_2112A
+		&& !test_bit(MODE_IEEE80211A, ah->ah_capabilities.cap_mode)){
+		rf_ini = rfregs_2112a;
+		rf_size = ARRAY_SIZE(rfregs_5112a);
+		if (mode < 2) {
+			ATH5K_ERR(ah->ah_sc,"invalid channel mode: %i\n",mode);
+			return -EINVAL;
+		}
+		mode = mode - 2; /*no a/turboa modes for 2112*/
+	} else if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
 		rf_ini = rfregs_5112a;
 		rf_size = ARRAY_SIZE(rfregs_5112a);
 	} else {
@@ -1032,7 +1157,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 
 	/* Modify bank 6 */
 	if (channel->val & CHANNEL_2GHZ) {
-		if (channel->val & CHANNEL_G)
+		if (channel->val & CHANNEL_OFDM)
 			ee_mode = AR5K_EEPROM_MODE_11G;
 		else
 			ee_mode = AR5K_EEPROM_MODE_11B;
@@ -1062,12 +1187,10 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 			return -EINVAL;
 	}
 
-#ifdef notyet
 	ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 	    ee->ee_x_gain[ee_mode], 2, 270, 0, true);
 	ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 	    ee->ee_x_gain[ee_mode], 2, 257, 0, true);
-#endif
 
 	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 			ee->ee_xpd[ee_mode], 1, 302, 0, true))



