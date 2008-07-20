Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:42299 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbYGTDtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:49:09 -0400
Date: Sun, 20 Jul 2008 06:49:48 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 11/12] ath5k: Update rfregs functions
Message-ID: <20080720034948.GK7440@makis> (sfid-20080720_054912_454044_B23547E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Fix rf_size for RF2112A
 * Add some stuff i got from decompiling binary HAL (also work in progress)

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 5a9619b..da11ce6 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1385,6 +1385,7 @@ done:
 
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5111
+ * TODO: Gain optimization
  */
 static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel, unsigned int mode)
@@ -1475,6 +1476,24 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 			ee->ee_xpd[ee_mode], 1, 4, 0, true))
 		return -EINVAL;
 
+#ifdef notyet
+	if (channel->hw_value & (half_rate_chanel || quarter_rate_channel)) {
+
+		val = (channel->hw_value & half_rate_chanel) ? 16 : 31;
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
+					31, 5, 19, 0, true))
+			return -EINVAL;
+
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
+					val, 5, 24, 0, true))
+			return -EINVAL;
+
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
+					3, 2, 49, 0, true))
+			return -EINVAL;
+	}
+#endif
+
 	/* Write RF values */
 	for (i = 0; i < rf_size; i++) {
 		AR5K_REG_WAIT(i);
@@ -1486,6 +1505,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5112
+ * TODO: Gain optimization
  */
 static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel, unsigned int mode)
@@ -1504,7 +1524,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_2112A
 		&& !test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)) {
 		rf_ini = rfregs_2112a;
-		rf_size = ARRAY_SIZE(rfregs_5112a);
+		rf_size = ARRAY_SIZE(rfregs_2112a);
 		if (mode < 2) {
 			ATH5K_ERR(ah->ah_sc,"invalid channel mode: %i\n",mode);
 			return -EINVAL;
@@ -1552,9 +1572,9 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 		/* For 11a, Turbo and XR */
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		obdb = channel->center_freq >= 5725 ? 3 :
-		    (channel->center_freq >= 5500 ? 2 :
+			(channel->center_freq >= 5500 ? 2 :
 			(channel->center_freq >= 5260 ? 1 :
-			    (channel->center_freq > 4000 ? 0 : -1)));
+			(channel->center_freq > 4000 ? 0 : -1)));
 
 		if (obdb == -1)
 			return -EINVAL;
@@ -1569,9 +1589,55 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 	}
 
 	ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
-	    ee->ee_x_gain[ee_mode], 2, 270, 0, true);
+		ee->ee_x_gain[ee_mode], 2, 270, 0, true);
 	ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
-	    ee->ee_x_gain[ee_mode], 2, 257, 0, true);
+		ee->ee_x_gain[ee_mode], 2, 257, 0, true);
+
+#ifdef notyet
+	if (channel->hw_value & CHANNEL_OFDM) {
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				val, 1, 168, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				val, 1, 169, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				val, 1, 170, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				val, 1, 174, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				val, 1, 175, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				val, 1, 176, 3, true);
+	}
+
+	if (ah->ah_radio_5ghz_revision == AR5K_SREV_RAD_5112A ||
+		ah->ah_radio_5ghz_revision == AR5K_SREV_RAD_5112B ||
+		ah->ah_radio_5ghz_revision == AR5K_SREV_RAD_2112A ||
+		ah->ah_radio_5ghz_revision == AR5K_SREV_RAD_2112B) {
+
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				2, 2, 90, 2, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				2, 2, 92, 2, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				2, 2, 94, 2, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				2, 1, 254, 2, true);
+	}
+
+	if (ah->ah_phy_revision >= 0x41) {
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				1, 1, 281, 1, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				1, 2, 1, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				1, 2, 3, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				1, 1, 139, 3, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
+				1, 1, 140, 3, true);
+	}
+#endif
+
 
 	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 			ee->ee_xpd[ee_mode], 1, 302, 0, true))
@@ -1582,6 +1648,17 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 			ee->ee_i_gain[ee_mode], 6, 14, 0, true))
 		return -EINVAL;
 
+#ifdef notyet
+	if (channel->hw_value & (half_rate_chanel || quarter_rate_channel)) {
+
+		val = (channel->hw_value & half_rate_chanel) ? 8 : 15;
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
+				15, 4, 58, 0, true);
+		ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
+				val, 4, 70, 0, true);
+	}
+#endif
+
 	/* Write RF values */
 	for (i = 0; i < rf_size; i++)
 		ath5k_hw_reg_write(ah, rf[i], rf_ini[i].rf_register);
@@ -1666,6 +1743,19 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
 	 * is used because calibration data would be
 	 * different between different cards and would result
 	 * different RF_BUFFER settings)
+	 *
+	 * Update: This happens most of the times but disassembly
+	 * of binary HAL shows there are minor changes that we should
+	 * implement (check below).
+	 */
+
+	/* TODO:
+	 * Write 2GHz ob/db on 2413 (3,168,0 / 3,165,0)
+	 * Write 2GHz ob/db on 5413 (3,241,0 / 3,238,0)
+	 * Write 5GHz ob/db on 5413 (3,247,9 / 3,244,0)
+	 * Write 2GHz ob/db on 2425 (3,193,0 / 3,190,0)
+	 *
+	 * Figure out the rest...
 	 */
 
 	/* Write RF values */

