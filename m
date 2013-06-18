Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41705 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3FREqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:46:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath9k: Add support for 5G-XLNA/AR9462
Date: Tue, 18 Jun 2013 10:13:42 +0530
Message-Id: <1371530623-15746-4-git-send-email-sujith@msujith.org> (sfid-20130618_064651_298694_DA886DF1)
In-Reply-To: <1371530623-15746-1-git-send-email-sujith@msujith.org>
References: <1371530623-15746-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  18 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  27 +++
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   | 265 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 4 files changed, 310 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index a3523c9..ce748af 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -627,9 +627,22 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 
 static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 {
-	if (AR_SREV_9462_20(ah))
+	if (AR_SREV_9462_20(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9462_common_mixed_rx_gain_table_2p0);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+			       ar9462_2p0_baseband_postamble_5g_xlna);
+	}
+}
+
+static void ar9003_rx_gain_table_mode3(struct ath_hw *ah)
+{
+	if (AR_SREV_9462_20(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9462_2p0_5g_xlna_only_rxgain);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+			       ar9462_2p0_baseband_postamble_5g_xlna);
+	}
 }
 
 static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
@@ -645,6 +658,9 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 	case 2:
 		ar9003_rx_gain_table_mode2(ah);
 		break;
+	case 3:
+		ar9003_rx_gain_table_mode3(ah);
+		break;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index bc48312..df919e2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -735,6 +735,9 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		return -EINVAL;
 	}
 
+	/*
+	 * SOC, MAC, BB, RADIO initvals.
+	 */
 	for (i = 0; i < ATH_INI_NUM_SPLIT; i++) {
 		ar9003_hw_prog_ini(ah, &ah->iniSOC[i], modesIndex);
 		ar9003_hw_prog_ini(ah, &ah->iniMac[i], modesIndex);
@@ -746,11 +749,29 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 					   modesIndex);
 	}
 
+	/*
+	 * RXGAIN initvals.
+	 */
 	REG_WRITE_ARRAY(&ah->iniModesRxGain, 1, regWrites);
+
+	if (AR_SREV_9462_20(ah)) {
+		/*
+		 * 5G-XLNA
+		 */
+		if ((ar9003_hw_get_rx_gain_idx(ah) == 2) ||
+		    (ar9003_hw_get_rx_gain_idx(ah) == 3)) {
+			REG_WRITE_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+					modesIndex, regWrites);
+		}
+	}
+
 	if (AR_SREV_9550(ah))
 		REG_WRITE_ARRAY(&ah->ini_modes_rx_gain_bounds, modesIndex,
 				regWrites);
 
+	/*
+	 * TXGAIN initvals.
+	 */
 	if (AR_SREV_9550(ah)) {
 		int modes_txgain_index;
 
@@ -772,8 +793,14 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE_ARRAY(&ah->iniModesFastClock,
 				modesIndex, regWrites);
 
+	/*
+	 * Clock frequency initvals.
+	 */
 	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
 
+	/*
+	 * JAPAN regulatory.
+	 */
 	if (chan->channel == 2484)
 		ar9003_hw_prog_ini(ah, &ah->iniCckfirJapan2484, 1);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index f00e945..bcd0cae 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -1449,4 +1449,269 @@ static const u32 ar9462_common_mixed_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
+static const u32 ar9462_2p0_baseband_postamble_5g_xlna[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
+};
+
+static const u32 ar9462_2p0_5g_xlna_only_rxgain[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a000, 0x00010000},
+	{0x0000a004, 0x00030002},
+	{0x0000a008, 0x00050004},
+	{0x0000a00c, 0x00810080},
+	{0x0000a010, 0x00830082},
+	{0x0000a014, 0x01810180},
+	{0x0000a018, 0x01830182},
+	{0x0000a01c, 0x01850184},
+	{0x0000a020, 0x01890188},
+	{0x0000a024, 0x018b018a},
+	{0x0000a028, 0x018d018c},
+	{0x0000a02c, 0x03820190},
+	{0x0000a030, 0x03840383},
+	{0x0000a034, 0x03880385},
+	{0x0000a038, 0x038a0389},
+	{0x0000a03c, 0x038c038b},
+	{0x0000a040, 0x0390038d},
+	{0x0000a044, 0x03920391},
+	{0x0000a048, 0x03940393},
+	{0x0000a04c, 0x03960395},
+	{0x0000a050, 0x00000000},
+	{0x0000a054, 0x00000000},
+	{0x0000a058, 0x00000000},
+	{0x0000a05c, 0x00000000},
+	{0x0000a060, 0x00000000},
+	{0x0000a064, 0x00000000},
+	{0x0000a068, 0x00000000},
+	{0x0000a06c, 0x00000000},
+	{0x0000a070, 0x00000000},
+	{0x0000a074, 0x00000000},
+	{0x0000a078, 0x00000000},
+	{0x0000a07c, 0x00000000},
+	{0x0000a080, 0x29292929},
+	{0x0000a084, 0x29292929},
+	{0x0000a088, 0x29292929},
+	{0x0000a08c, 0x29292929},
+	{0x0000a090, 0x22292929},
+	{0x0000a094, 0x1d1d2222},
+	{0x0000a098, 0x0c111117},
+	{0x0000a09c, 0x00030303},
+	{0x0000a0a0, 0x00000000},
+	{0x0000a0a4, 0x00000000},
+	{0x0000a0a8, 0x00000000},
+	{0x0000a0ac, 0x00000000},
+	{0x0000a0b0, 0x00000000},
+	{0x0000a0b4, 0x00000000},
+	{0x0000a0b8, 0x00000000},
+	{0x0000a0bc, 0x00000000},
+	{0x0000a0c0, 0x001f0000},
+	{0x0000a0c4, 0x01000101},
+	{0x0000a0c8, 0x011e011f},
+	{0x0000a0cc, 0x011c011d},
+	{0x0000a0d0, 0x02030204},
+	{0x0000a0d4, 0x02010202},
+	{0x0000a0d8, 0x021f0200},
+	{0x0000a0dc, 0x0302021e},
+	{0x0000a0e0, 0x03000301},
+	{0x0000a0e4, 0x031e031f},
+	{0x0000a0e8, 0x0402031d},
+	{0x0000a0ec, 0x04000401},
+	{0x0000a0f0, 0x041e041f},
+	{0x0000a0f4, 0x0502041d},
+	{0x0000a0f8, 0x05000501},
+	{0x0000a0fc, 0x051e051f},
+	{0x0000a100, 0x06010602},
+	{0x0000a104, 0x061f0600},
+	{0x0000a108, 0x061d061e},
+	{0x0000a10c, 0x07020703},
+	{0x0000a110, 0x07000701},
+	{0x0000a114, 0x00000000},
+	{0x0000a118, 0x00000000},
+	{0x0000a11c, 0x00000000},
+	{0x0000a120, 0x00000000},
+	{0x0000a124, 0x00000000},
+	{0x0000a128, 0x00000000},
+	{0x0000a12c, 0x00000000},
+	{0x0000a130, 0x00000000},
+	{0x0000a134, 0x00000000},
+	{0x0000a138, 0x00000000},
+	{0x0000a13c, 0x00000000},
+	{0x0000a140, 0x001f0000},
+	{0x0000a144, 0x01000101},
+	{0x0000a148, 0x011e011f},
+	{0x0000a14c, 0x011c011d},
+	{0x0000a150, 0x02030204},
+	{0x0000a154, 0x02010202},
+	{0x0000a158, 0x021f0200},
+	{0x0000a15c, 0x0302021e},
+	{0x0000a160, 0x03000301},
+	{0x0000a164, 0x031e031f},
+	{0x0000a168, 0x0402031d},
+	{0x0000a16c, 0x04000401},
+	{0x0000a170, 0x041e041f},
+	{0x0000a174, 0x0502041d},
+	{0x0000a178, 0x05000501},
+	{0x0000a17c, 0x051e051f},
+	{0x0000a180, 0x06010602},
+	{0x0000a184, 0x061f0600},
+	{0x0000a188, 0x061d061e},
+	{0x0000a18c, 0x07020703},
+	{0x0000a190, 0x07000701},
+	{0x0000a194, 0x00000000},
+	{0x0000a198, 0x00000000},
+	{0x0000a19c, 0x00000000},
+	{0x0000a1a0, 0x00000000},
+	{0x0000a1a4, 0x00000000},
+	{0x0000a1a8, 0x00000000},
+	{0x0000a1ac, 0x00000000},
+	{0x0000a1b0, 0x00000000},
+	{0x0000a1b4, 0x00000000},
+	{0x0000a1b8, 0x00000000},
+	{0x0000a1bc, 0x00000000},
+	{0x0000a1c0, 0x00000000},
+	{0x0000a1c4, 0x00000000},
+	{0x0000a1c8, 0x00000000},
+	{0x0000a1cc, 0x00000000},
+	{0x0000a1d0, 0x00000000},
+	{0x0000a1d4, 0x00000000},
+	{0x0000a1d8, 0x00000000},
+	{0x0000a1dc, 0x00000000},
+	{0x0000a1e0, 0x00000000},
+	{0x0000a1e4, 0x00000000},
+	{0x0000a1e8, 0x00000000},
+	{0x0000a1ec, 0x00000000},
+	{0x0000a1f0, 0x00000396},
+	{0x0000a1f4, 0x00000396},
+	{0x0000a1f8, 0x00000396},
+	{0x0000a1fc, 0x00000196},
+	{0x0000b000, 0x00010000},
+	{0x0000b004, 0x00030002},
+	{0x0000b008, 0x00050004},
+	{0x0000b00c, 0x00810080},
+	{0x0000b010, 0x00830082},
+	{0x0000b014, 0x01810180},
+	{0x0000b018, 0x01830182},
+	{0x0000b01c, 0x01850184},
+	{0x0000b020, 0x02810280},
+	{0x0000b024, 0x02830282},
+	{0x0000b028, 0x02850284},
+	{0x0000b02c, 0x02890288},
+	{0x0000b030, 0x028b028a},
+	{0x0000b034, 0x0388028c},
+	{0x0000b038, 0x038a0389},
+	{0x0000b03c, 0x038c038b},
+	{0x0000b040, 0x0390038d},
+	{0x0000b044, 0x03920391},
+	{0x0000b048, 0x03940393},
+	{0x0000b04c, 0x03960395},
+	{0x0000b050, 0x00000000},
+	{0x0000b054, 0x00000000},
+	{0x0000b058, 0x00000000},
+	{0x0000b05c, 0x00000000},
+	{0x0000b060, 0x00000000},
+	{0x0000b064, 0x00000000},
+	{0x0000b068, 0x00000000},
+	{0x0000b06c, 0x00000000},
+	{0x0000b070, 0x00000000},
+	{0x0000b074, 0x00000000},
+	{0x0000b078, 0x00000000},
+	{0x0000b07c, 0x00000000},
+	{0x0000b080, 0x2a2d2f32},
+	{0x0000b084, 0x21232328},
+	{0x0000b088, 0x19191c1e},
+	{0x0000b08c, 0x12141417},
+	{0x0000b090, 0x07070e0e},
+	{0x0000b094, 0x03030305},
+	{0x0000b098, 0x00000003},
+	{0x0000b09c, 0x00000000},
+	{0x0000b0a0, 0x00000000},
+	{0x0000b0a4, 0x00000000},
+	{0x0000b0a8, 0x00000000},
+	{0x0000b0ac, 0x00000000},
+	{0x0000b0b0, 0x00000000},
+	{0x0000b0b4, 0x00000000},
+	{0x0000b0b8, 0x00000000},
+	{0x0000b0bc, 0x00000000},
+	{0x0000b0c0, 0x003f0020},
+	{0x0000b0c4, 0x00400041},
+	{0x0000b0c8, 0x0140005f},
+	{0x0000b0cc, 0x0160015f},
+	{0x0000b0d0, 0x017e017f},
+	{0x0000b0d4, 0x02410242},
+	{0x0000b0d8, 0x025f0240},
+	{0x0000b0dc, 0x027f0260},
+	{0x0000b0e0, 0x0341027e},
+	{0x0000b0e4, 0x035f0340},
+	{0x0000b0e8, 0x037f0360},
+	{0x0000b0ec, 0x04400441},
+	{0x0000b0f0, 0x0460045f},
+	{0x0000b0f4, 0x0541047f},
+	{0x0000b0f8, 0x055f0540},
+	{0x0000b0fc, 0x057f0560},
+	{0x0000b100, 0x06400641},
+	{0x0000b104, 0x0660065f},
+	{0x0000b108, 0x067e067f},
+	{0x0000b10c, 0x07410742},
+	{0x0000b110, 0x075f0740},
+	{0x0000b114, 0x077f0760},
+	{0x0000b118, 0x07800781},
+	{0x0000b11c, 0x07a0079f},
+	{0x0000b120, 0x07c107bf},
+	{0x0000b124, 0x000007c0},
+	{0x0000b128, 0x00000000},
+	{0x0000b12c, 0x00000000},
+	{0x0000b130, 0x00000000},
+	{0x0000b134, 0x00000000},
+	{0x0000b138, 0x00000000},
+	{0x0000b13c, 0x00000000},
+	{0x0000b140, 0x003f0020},
+	{0x0000b144, 0x00400041},
+	{0x0000b148, 0x0140005f},
+	{0x0000b14c, 0x0160015f},
+	{0x0000b150, 0x017e017f},
+	{0x0000b154, 0x02410242},
+	{0x0000b158, 0x025f0240},
+	{0x0000b15c, 0x027f0260},
+	{0x0000b160, 0x0341027e},
+	{0x0000b164, 0x035f0340},
+	{0x0000b168, 0x037f0360},
+	{0x0000b16c, 0x04400441},
+	{0x0000b170, 0x0460045f},
+	{0x0000b174, 0x0541047f},
+	{0x0000b178, 0x055f0540},
+	{0x0000b17c, 0x057f0560},
+	{0x0000b180, 0x06400641},
+	{0x0000b184, 0x0660065f},
+	{0x0000b188, 0x067e067f},
+	{0x0000b18c, 0x07410742},
+	{0x0000b190, 0x075f0740},
+	{0x0000b194, 0x077f0760},
+	{0x0000b198, 0x07800781},
+	{0x0000b19c, 0x07a0079f},
+	{0x0000b1a0, 0x07c107bf},
+	{0x0000b1a4, 0x000007c0},
+	{0x0000b1a8, 0x00000000},
+	{0x0000b1ac, 0x00000000},
+	{0x0000b1b0, 0x00000000},
+	{0x0000b1b4, 0x00000000},
+	{0x0000b1b8, 0x00000000},
+	{0x0000b1bc, 0x00000000},
+	{0x0000b1c0, 0x00000000},
+	{0x0000b1c4, 0x00000000},
+	{0x0000b1c8, 0x00000000},
+	{0x0000b1cc, 0x00000000},
+	{0x0000b1d0, 0x00000000},
+	{0x0000b1d4, 0x00000000},
+	{0x0000b1d8, 0x00000000},
+	{0x0000b1dc, 0x00000000},
+	{0x0000b1e0, 0x00000000},
+	{0x0000b1e4, 0x00000000},
+	{0x0000b1e8, 0x00000000},
+	{0x0000b1ec, 0x00000000},
+	{0x0000b1f0, 0x00000396},
+	{0x0000b1f4, 0x00000396},
+	{0x0000b1f8, 0x00000396},
+	{0x0000b1fc, 0x00000196},
+};
+
 #endif /* INITVALS_9462_2P0_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ed7d4fc..e076639 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -892,6 +892,7 @@ struct ath_hw {
 	struct ar5416IniArray iniCckfirJapan2484;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray ini_radio_post_sys2ant;
+	struct ar5416IniArray ini_modes_rxgain_5g_xlna;
 
 	struct ar5416IniArray iniMac[ATH_INI_NUM_SPLIT];
 	struct ar5416IniArray iniBB[ATH_INI_NUM_SPLIT];
-- 
1.8.3.1

