Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:43514 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbXKNQRZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:17:25 -0500
Date: Wed, 14 Nov 2007 18:17:37 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 3/4] ath5k: Add RF5413/5414 support
Message-ID: <20071114161737.GC6365@localhost.domain.invalid> (sfid-20071114_161734_490509_9D57CD58)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*Add support for RF5413/5414 single-chip solutions

This needs testing (also on 5424/2424) before we declare that's fully supported.
It works for me and the RF5413 i got ;-)

Changes-licensed-under: ISC
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 7058b0a..c5e37d2 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -131,6 +131,7 @@ enum ath5k_radio {
 	AR5K_RF5110	= 0,
 	AR5K_RF5111	= 1,
 	AR5K_RF5112	= 2,
+	AR5K_RF5413	= 3,
 };
 
 /*
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ead2d75..e7fecbb 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -226,11 +226,15 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		ah->ah_radio_2ghz_revision = 0;
 
 	/* Identify the radio chip*/
-	if (ah->ah_version == AR5K_AR5210)
+	if (ah->ah_version == AR5K_AR5210) {
 		ah->ah_radio = AR5K_RF5110;
-	else
-		ah->ah_radio = ah->ah_radio_5ghz_revision <
-			AR5K_SREV_RAD_5112 ? AR5K_RF5111 : AR5K_RF5112;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
+		ah->ah_radio = AR5K_RF5111;
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
+		ah->ah_radio = AR5K_RF5112;
+	} else {
+		ah->ah_radio = AR5K_RF5413;
+	}
 
 	ah->ah_phy = AR5K_PHY(0);
 
@@ -453,9 +457,9 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
 	kfree(ah);
 }
 
-/*
- * Reset function and helpers
- */
+/****************************\
+  Reset function and helpers 
+\****************************/
 
 /**
  * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
@@ -637,7 +641,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	 */
 	if (ah->ah_version != AR5K_AR5210) {
 		if (ah->ah_radio != AR5K_RF5111 &&
-				ah->ah_radio != AR5K_RF5112) {
+			ah->ah_radio != AR5K_RF5112 &&
+			ah->ah_radio != AR5K_RF5413) {
 			AR5K_PRINTF("invalid phy radio: %u\n", ah->ah_radio);
 			return -EINVAL;
 		}
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index ca12964..44c05f0 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1054,7 +1054,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5111_ini_mode),
 					ar5212_rf5111_ini_mode, mode);
-		else if (ah->ah_radio == AR5K_RF5112)
+		else if (ah->ah_radio >= AR5K_RF5112)
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5112_ini_mode),
 					ar5212_rf5112_ini_mode, mode);
@@ -1072,7 +1072,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 	if (ah->ah_version == AR5K_AR5212) {
 		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5212_ini),
 				ar5212_ini, change_channel);
-		if (ah->ah_radio == AR5K_RF5112) {
+		if (ah->ah_radio >= AR5K_RF5112) {
 			ath5k_hw_reg_write(ah, AR5K_PHY_PAPD_PROBE_INI_5112,
 					AR5K_PHY_PAPD_PROBE);
 			ath5k_hw_ini_registers(ah,
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 14520cd..79015ab 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -457,6 +457,97 @@ static const struct ath5k_ini_rf rfregs_5112a[] = {
 	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } },
 };
 
+/* RF5413/5414 mode-specific init registers */
+static const struct ath5k_ini_rf rfregs_5413[] = {
+	{ 1, 0x98d4,
+	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */
+	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } },
+	{ 2, 0x98d0,
+	    { 0x00000008, 0x00000008, 0x00000008, 0x00000008, 0x00000008 } },
+	{ 3, 0x98dc,
+	    { 0x00a000c0, 0x00a000c0, 0x00e000c0, 0x00e000c0, 0x00e000c0 } },
+	{ 6, 0x989c,
+	    { 0x33000000, 0x33000000, 0x33000000, 0x33000000, 0x33000000 } },
+	{ 6, 0x989c,
+	    { 0x01000000, 0x01000000, 0x01000000, 0x01000000, 0x01000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x1f000000, 0x1f000000, 0x1f000000, 0x1f000000, 0x1f000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00b80000, 0x00b80000, 0x00b80000, 0x00b80000, 0x00b80000 } },
+	{ 6, 0x989c,
+	    { 0x00b70000, 0x00b70000, 0x00b70000, 0x00b70000, 0x00b70000 } },
+	{ 6, 0x989c,
+	    { 0x00840000, 0x00840000, 0x00840000, 0x00840000, 0x00840000 } },
+	{ 6, 0x989c,
+	    { 0x00980000, 0x00980000, 0x00980000, 0x00980000, 0x00980000 } },
+	{ 6, 0x989c,
+	    { 0x00c00000, 0x00c00000, 0x00c00000, 0x00c00000, 0x00c00000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x00d70000, 0x00d70000, 0x00d70000, 0x00d70000, 0x00d70000 } },
+	{ 6, 0x989c,
+	    { 0x00610000, 0x00610000, 0x00610000, 0x00610000, 0x00610000 } },
+	{ 6, 0x989c,
+	    { 0x00fe0000, 0x00fe0000, 0x00fe0000, 0x00fe0000, 0x00fe0000 } },
+	{ 6, 0x989c,
+	    { 0x00de0000, 0x00de0000, 0x00de0000, 0x00de0000, 0x00de0000 } },
+	{ 6, 0x989c,
+	    { 0x007f0000, 0x007f0000, 0x007f0000, 0x007f0000, 0x007f0000 } },
+	{ 6, 0x989c,
+	    { 0x043d0000, 0x043d0000, 0x043d0000, 0x043d0000, 0x043d0000 } },
+	{ 6, 0x989c,
+	    { 0x00770000, 0x00770000, 0x00770000, 0x00770000, 0x00770000 } },
+	{ 6, 0x989c,
+	    { 0x00440000, 0x00440000, 0x00440000, 0x00440000, 0x00440000 } },
+	{ 6, 0x989c,
+	    { 0x00980000, 0x00980000, 0x00980000, 0x00980000, 0x00980000 } },
+	{ 6, 0x989c,
+	    { 0x00100080, 0x00100080, 0x00100080, 0x00100080, 0x00100080 } },
+	{ 6, 0x989c,
+	    { 0x0005c034, 0x0005c034, 0x0005c034, 0x0005c034, 0x0005c034 } },
+	{ 6, 0x989c,
+	    { 0x003100f0, 0x003100f0, 0x003100f0, 0x003100f0, 0x003100f0 } },
+	{ 6, 0x989c,
+	    { 0x000c011f, 0x000c011f, 0x000c011f, 0x000c011f, 0x000c011f } },
+	{ 6, 0x989c,
+	    { 0x00510040, 0x00510040, 0x005100a0, 0x005100a0, 0x005100a0 } },
+	{ 6, 0x989c,
+	    { 0x0050006a, 0x0050006a, 0x005000dd, 0x005000dd, 0x005000dd } },
+	{ 6, 0x989c,
+	    { 0x00000001, 0x00000001, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00004044, 0x00004044, 0x00004044, 0x00004044, 0x00004044 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x000060c0, 0x000060c0, 0x000060c0, 0x000060c0, 0x000060c0 } },
+	{ 6, 0x989c,
+	    { 0x00002c00, 0x00002c00, 0x00003600, 0x00003600, 0x00003600 } },
+	{ 6, 0x98c8,
+	    { 0x00000403, 0x00000403, 0x00040403, 0x00040403, 0x00040403 } },
+	{ 7, 0x989c,
+	    { 0x00006400, 0x00006400, 0x00006400, 0x00006400, 0x00006400 } },
+	{ 7, 0x989c,
+	    { 0x00000800, 0x00000800, 0x00000800, 0x00000800, 0x00000800 } },
+	{ 7, 0x98cc,
+	    { 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e } },
+};
+
 
 /* Initial RF Gain settings for RF5112 */
 static const struct ath5k_ini_rfgain rfgain_5112[] = {
@@ -527,6 +618,75 @@ static const struct ath5k_ini_rfgain rfgain_5112[] = {
 	{ AR5K_RF_GAIN(63),	{ 0x000000fc, 0x000000fc } },
 };
 
+/* Initial RF Gain settings for RF5413 */
+static const struct ath5k_ini_rfgain rfgain_5413[] = {
+	/*			      5Ghz	2Ghz	*/
+	{ AR5K_RF_GAIN(0),	{ 0x00000000, 0x00000000 } },
+	{ AR5K_RF_GAIN(1),	{ 0x00000040, 0x00000040 } },
+	{ AR5K_RF_GAIN(2),	{ 0x00000080, 0x00000080 } },
+	{ AR5K_RF_GAIN(3),	{ 0x000001a1, 0x00000161 } },
+	{ AR5K_RF_GAIN(4),	{ 0x000001e1, 0x000001a1 } },
+	{ AR5K_RF_GAIN(5),	{ 0x00000021, 0x000001e1 } },
+	{ AR5K_RF_GAIN(6),	{ 0x00000061, 0x00000021 } },
+	{ AR5K_RF_GAIN(7),	{ 0x00000188, 0x00000061 } },
+	{ AR5K_RF_GAIN(8),	{ 0x000001c8, 0x00000188 } },
+	{ AR5K_RF_GAIN(9),	{ 0x00000008, 0x000001c8 } },
+	{ AR5K_RF_GAIN(10),	{ 0x00000048, 0x00000008 } },
+	{ AR5K_RF_GAIN(11),	{ 0x00000088, 0x00000048 } },
+	{ AR5K_RF_GAIN(12),	{ 0x000001a9, 0x00000088 } },
+	{ AR5K_RF_GAIN(13),	{ 0x000001e9, 0x00000169 } },
+	{ AR5K_RF_GAIN(14),	{ 0x00000029, 0x000001a9 } },
+	{ AR5K_RF_GAIN(15),	{ 0x00000069, 0x000001e9 } },
+	{ AR5K_RF_GAIN(16),	{ 0x000001d0, 0x00000029 } },
+	{ AR5K_RF_GAIN(17),	{ 0x00000010, 0x00000069 } },
+	{ AR5K_RF_GAIN(18),	{ 0x00000050, 0x00000190 } },
+	{ AR5K_RF_GAIN(19),	{ 0x00000090, 0x000001d0 } },
+	{ AR5K_RF_GAIN(20),	{ 0x000001b1, 0x00000010 } },
+	{ AR5K_RF_GAIN(21),	{ 0x000001f1, 0x00000050 } },
+	{ AR5K_RF_GAIN(22),	{ 0x00000031, 0x00000090 } },
+	{ AR5K_RF_GAIN(23),	{ 0x00000071, 0x00000171 } },
+	{ AR5K_RF_GAIN(24),	{ 0x000001b8, 0x000001b1 } },
+	{ AR5K_RF_GAIN(25),	{ 0x000001f8, 0x000001f1 } },
+	{ AR5K_RF_GAIN(26),	{ 0x00000038, 0x00000031 } },
+	{ AR5K_RF_GAIN(27),	{ 0x00000078, 0x00000071 } },
+	{ AR5K_RF_GAIN(28),	{ 0x00000199, 0x00000198 } },
+	{ AR5K_RF_GAIN(29),	{ 0x000001d9, 0x000001d8 } },
+	{ AR5K_RF_GAIN(30),	{ 0x00000019, 0x00000018 } },
+	{ AR5K_RF_GAIN(31),	{ 0x00000059, 0x00000058 } },
+	{ AR5K_RF_GAIN(32),	{ 0x00000099, 0x00000098 } },
+	{ AR5K_RF_GAIN(33),	{ 0x000000d9, 0x00000179 } },
+	{ AR5K_RF_GAIN(34),	{ 0x000000f9, 0x000001b9 } },
+	{ AR5K_RF_GAIN(35),	{ 0x000000f9, 0x000001f9 } },
+	{ AR5K_RF_GAIN(36),	{ 0x000000f9, 0x00000039 } },
+	{ AR5K_RF_GAIN(37),	{ 0x000000f9, 0x00000079 } },
+	{ AR5K_RF_GAIN(38),	{ 0x000000f9, 0x000000b9 } },
+	{ AR5K_RF_GAIN(39),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(40),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(41),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(42),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(43),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(44),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(45),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(46),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(47),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(48),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(49),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(50),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(51),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(52),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(53),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(54),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(55),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(56),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(57),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(58),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(59),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(60),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(61),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(62),	{ 0x000000f9, 0x000000f9 } },
+	{ AR5K_RF_GAIN(63),	{ 0x000000f9, 0x000000f9 } },
+};
+
 static const struct ath5k_gain_opt rfgain_opt_5112 = {
 	1,
 	8,
@@ -677,6 +837,7 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath5k_hw *ah)
 		go = &rfgain_opt_5111;
 		break;
 	case AR5K_RF5112:
+	case AR5K_RF5413: /* ??? */
 		go = &rfgain_opt_5112;
 		break;
 	default:
@@ -924,6 +1085,56 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 }
 
 /*
+ * Initialize RF5413/5414
+ */
+static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
+		struct ieee80211_channel *channel, unsigned int mode)
+{
+	const struct ath5k_ini_rf *rf_ini;
+	u32 *rf;
+	unsigned int rf_size, i;
+	int bank = -1;
+
+	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
+
+	rf = ah->ah_rf_banks;
+
+	rf_ini = rfregs_5413;
+	rf_size = ARRAY_SIZE(rfregs_5413);
+
+	/* Copy values to modify them */
+	for (i = 0; i < rf_size; i++) {
+		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
+			AR5K_PRINT("invalid bank\n");
+			return -EINVAL;
+		}
+
+		if (bank != rf_ini[i].rf_bank) {
+			bank = rf_ini[i].rf_bank;
+			ah->ah_offset[bank] = i;
+		}
+
+		rf[i] = rf_ini[i].rf_value[mode];
+	}
+
+	/* 
+	 * After compairing dumps from different cards
+	 * we get the same RF_BUFFER settings (diff returns
+	 * 0 lines). It seems that RF_BUFFER settings are static
+	 * and are written unmodified (no EEPROM stuff
+	 * is used because calibration data would be
+	 * different between different cards and would result
+	 * different RF_BUFFER settings)
+	 */
+
+	/* Write RF values */
+	for (i = 0; i < rf_size; i++)
+		ath5k_hw_reg_write(ah, rf[i], rf_ini[i].rf_register);
+
+	return 0;
+}
+
+/*
  * Initialize RF
  */
 int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
@@ -944,6 +1155,10 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 			ah->ah_rf_banks_size = sizeof(rfregs_5112);
 		func = ath5k_hw_rf5112_rfregs;
 		break;
+	case AR5K_RF5413:
+		ah->ah_rf_banks_size = sizeof(rfregs_5413);
+		func = ath5k_hw_rf5413_rfregs;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -978,6 +1193,10 @@ int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq)
 		ath5k_rfg = rfgain_5112;
 		size = ARRAY_SIZE(rfgain_5112);
 		break;
+	case AR5K_RF5413:
+		ath5k_rfg = rfgain_5413;
+		size = ARRAY_SIZE(rfgain_5413);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1021,7 +1240,7 @@ enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah)
 		if (type == AR5K_PHY_PAPD_PROBE_TYPE_CCK)
 			ah->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
 
-		if (ah->ah_radio == AR5K_RF5112) {
+		if (ah->ah_radio >= AR5K_RF5112) {
 			ath5k_hw_rfregs_gainf_corr(ah);
 			ah->ah_gain.g_current =
 				ah->ah_gain.g_current>=ah->ah_gain.g_f_corr ?
@@ -1052,6 +1271,7 @@ int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah)
 		ah->ah_gain.g_active = 1;
 		break;
 	case AR5K_RF5112:
+	case AR5K_RF5413: /* ??? */
 		ah->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
 		ah->ah_gain.g_step =
 		    &rfgain_opt_5112.go_step[ah->ah_gain.g_step_idx];
@@ -1202,7 +1422,7 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 }
 
 /*
- * Set channel on 5112
+ * Set channel on 5112 and newer
  */
 static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)


