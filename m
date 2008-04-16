Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:41106 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYDPQJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 12:09:38 -0400
Date: Wed, 16 Apr 2008 18:42:48 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 1/2] ath5k: Add RF2425 initvals
Message-ID: <20080416154247.GA4741@makis.domain.invalid> (sfid-20080416_170943_655143_80041BE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 *Add RF2425 initvals (still no rx/tx)

 This was on my laptop for a long time so it has to go out even if it still doesn't work,
 i hope i'll get my hands on an eeepc so i can work this out.

 base.c
 Changes-licensed-under: 3-clause-BSD

 rest
 Changes-licensed-under: ISC

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index b218307..d0d70b3 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -142,6 +142,7 @@ enum ath5k_radio {
 	AR5K_RF5112	= 2,
 	AR5K_RF2413	= 3,
 	AR5K_RF5413	= 4,
+	AR5K_RF2425	= 5,
 };
 
 /*
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 8862d24..dfd202d 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -126,6 +126,7 @@ static struct ath5k_srev_name srev_names[] = {
 	{ "5414",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5414 },
 	{ "5416",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5416 },
 	{ "5418",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5418 },
+	{ "2425",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2425 },
 	{ "xxxxx",	AR5K_VERSION_VER,	AR5K_SREV_UNKNOWN },
 	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
 	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ff579a2..9e16bc0 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -204,15 +204,16 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 				CHANNEL_2GHZ);
 
 	/* Return on unsuported chips (unsupported eeprom etc) */
-	if(srev >= AR5K_SREV_VER_AR5416){
+	if (srev >= AR5K_SREV_VER_AR5416) {
 		ATH5K_ERR(sc, "Device not yet supported.\n");
 		ret = -ENODEV;
 		goto err_free;
 	}
 
 	/* Identify single chip solutions */
-	if((srev <= AR5K_SREV_VER_AR5414) &&
-	(srev >= AR5K_SREV_VER_AR2413)) {
+	if (((srev <= AR5K_SREV_VER_AR5414) &&
+	(srev >= AR5K_SREV_VER_AR2413)) ||
+	(srev == AR5K_SREV_VER_AR2425)) {
 		ah->ah_single_chip = true;
 	} else {
 		ah->ah_single_chip = false;
@@ -241,19 +242,19 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
 		ah->ah_radio = AR5K_RF2413;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
-	} else {
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC2) {
 
 		ah->ah_radio = AR5K_RF5413;
 
 		if (ah->ah_mac_srev <= AR5K_SREV_VER_AR5424 &&
 			ah->ah_mac_srev >= AR5K_SREV_VER_AR2424)
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5424;
-		else if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2425)
-			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
 		else
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112A;
 
-
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5133) {
+		ah->ah_radio = AR5K_RF2425;
+		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
 	}
 
 	ah->ah_phy = AR5K_PHY(0);
@@ -391,7 +392,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
 		AR5K_RESET_CTL_BASEBAND | bus_flags);
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
+		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip\n");
 		return -EIO;
 	}
 
@@ -655,7 +656,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		if (ah->ah_radio != AR5K_RF5111 &&
 			ah->ah_radio != AR5K_RF5112 &&
 			ah->ah_radio != AR5K_RF5413 &&
-			ah->ah_radio != AR5K_RF2413) {
+			ah->ah_radio != AR5K_RF2413 &&
+			ah->ah_radio != AR5K_RF2425) {
 			ATH5K_ERR(ah->ah_sc,
 				"invalid phy radio: %u\n", ah->ah_radio);
 			return -EINVAL;
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index fdbab2f..04c84e9 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1282,6 +1282,213 @@ static const struct ath5k_ini_mode rf2413_ini_mode_end[] = {
 		{ 0xf3307ff0, 0xf3307ff0, 0xf3307ff0 } },
 };
 
+/* Initial mode-specific settings for RF2425 (Written after ar5212_ini) */
+/* XXX: No dumps for turbog yet, so turbog is the same with g here with some
+ * minor tweaking based on dumps from other chips */
+static const struct ath5k_ini_mode rf2425_ini_mode_end[] = {
+	{ AR5K_TXCFG,
+	/*	       g	gTurbo */
+		{ 0x00000015, 0x00000015 } },
+	{ AR5K_USEC_5211,
+		{ 0x12e013ab, 0x098813cf } },
+	{ AR5K_PHY_TURBO,
+		{ 0x00000000, 0x00000003 } },
+	{ AR5K_PHY(10),
+		{ 0x0a020001, 0x0a020001 } },
+	{ AR5K_PHY(13),
+		{ 0x00000e0e, 0x00000e0e } },
+	{ AR5K_PHY(14),
+		{ 0x0000000b, 0x0000000b } },
+	{ AR5K_PHY(17),
+		{ 0x13721422, 0x13721422 } },
+	{ AR5K_PHY(18),
+		{ 0x00199a65, 0x00199a65 } },
+	{ AR5K_PHY(20),
+		{ 0x0c98b0da, 0x0c98b0da } },
+	{ AR5K_PHY_SIG,
+		{ 0x7ec80d2e, 0x7ec80d2e } },
+	{ AR5K_PHY_AGCCOARSE,
+		{ 0x3139605e, 0x3139605e } },
+	{ AR5K_PHY(27),
+		{ 0x050cb081, 0x050cb081 } },
+	{ AR5K_PHY_RX_DELAY,
+		{ 0x00000898, 0x000007d0 } },
+	{ AR5K_PHY_FRAME_CTL_5211,
+		{ 0xf7b81000, 0xf7b81000 } },
+	{ AR5K_PHY_CCKTXCTL,
+		{ 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(642),
+		{ 0xd03e6788, 0xd03e6788 } },
+	{ AR5K_PHY_GAIN_2GHZ,
+		{ 0x0052c140, 0x0052c140 } },
+	{ 0xa21c,
+		{ 0x1883800a, 0x1883800a } },
+	{ 0xa324,
+		{ 0xa7cfa7cf, 0xa7cfa7cf } },
+	{ 0xa328,
+		{ 0xa7cfa7cf, 0xa7cfa7cf } },
+	{ 0xa32c,
+		{ 0xa7cfa7cf, 0xa7cfa7cf } },
+	{ 0xa330,
+		{ 0xa7cfa7cf, 0xa7cfa7cf } },
+	{ 0xa334,
+		{ 0xa7cfa7cf, 0xa7cfa7cf } },
+	{ AR5K_DCU_FP,
+		{ 0x000003e0, 0x000003e0 } },
+	{ 0x8060,
+		{ 0x0000000f, 0x0000000f } },
+	{ 0x809c,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x80a0,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8118,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x811c,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8120,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8124,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8128,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x812c,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8130,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8134,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8138,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x813c,
+		{ 0x00000000, 0x00000000 } },
+	{ 0x8140,
+		{ 0x800003f9, 0x800003f9 } },
+	{ 0x8144,
+		{ 0x00000000, 0x00000000 } },
+	{ AR5K_PHY_AGC,
+		{ 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(11),
+		{ 0x0000a000, 0x0000a000 } },
+	{ AR5K_PHY(15),
+		{ 0x00200400, 0x00200400 } },
+	{ AR5K_PHY(19),
+		{ 0x1284233c, 0x1284233c } },
+	{ AR5K_PHY_SCR,
+		{ 0x0000001f, 0x0000001f } },
+	{ AR5K_PHY_SLMT,
+		{ 0x00000080, 0x00000080 } },
+	{ AR5K_PHY_SCAL,
+		{ 0x0000000e, 0x0000000e } },
+	{ AR5K_PHY(86),
+		{ 0x00081fff, 0x00081fff } },
+	{ AR5K_PHY(96),
+		{ 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(97),
+		{ 0x02800000, 0x02800000 } },
+	{ AR5K_PHY(104),
+		{ 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(119),
+		{ 0xfebadbe8, 0xfebadbe8 } },
+	{ AR5K_PHY(120),
+		{ 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(121),
+		{ 0xaaaaaaaa, 0xaaaaaaaa } },
+	{ AR5K_PHY(122),
+		{ 0x3c466478, 0x3c466478 } },
+	{ AR5K_PHY(123),
+		{ 0x000000aa, 0x000000aa } },
+	{ AR5K_PHY_SCLOCK,
+		{ 0x0000000c, 0x0000000c } },
+	{ AR5K_PHY_SDELAY,
+		{ 0x000000ff, 0x000000ff } },
+	{ AR5K_PHY_SPENDING,
+		{ 0x00000014, 0x00000014 } },
+	{ 0xa228,
+		{ 0x000009b5, 0x000009b5 } },
+	{ AR5K_PHY_TXPOWER_RATE3,
+		{ 0x20202020, 0x20202020 } },
+	{ AR5K_PHY_TXPOWER_RATE4,
+		{ 0x20202020, 0x20202020 } },
+	{ 0xa23c,
+		{ 0x93c889af, 0x93c889af } },
+	{ 0xa24c,
+		{ 0x00000001, 0x00000001 } },
+	{ 0xa250,
+		{ 0x0000a000, 0x0000a000 } },
+	{ 0xa254,
+		{ 0x00000000, 0x00000000 } },
+	{ 0xa258,
+		{ 0x0cc75380, 0x0cc75380 } },
+	{ 0xa25c,
+		{ 0x0f0f0f01, 0x0f0f0f01 } },
+	{ 0xa260,
+		{ 0x5f690f01, 0x5f690f01 } },
+	{ 0xa264,
+		{ 0x00418a11, 0x00418a11 } },
+	{ 0xa268,
+		{ 0x00000000, 0x00000000 } },
+	{ 0xa26c,
+		{ 0x0c30c166, 0x0c30c166 } },
+	{ 0xa270,
+		{ 0x00820820, 0x00820820 } },
+	{ 0xa274,
+		{ 0x081a3caa, 0x081a3caa } },
+	{ 0xa278,
+		{ 0x1ce739ce, 0x1ce739ce } },
+	{ 0xa27c,
+		{ 0x051701ce, 0x051701ce } },
+	{ 0xa300,
+		{ 0x16010000, 0x16010000 } },
+	{ 0xa304,
+		{ 0x2c032402, 0x2c032402 } },
+	{ 0xa308,
+		{ 0x48433e42, 0x48433e42 } },
+	{ 0xa30c,
+		{ 0x5a0f500b, 0x5a0f500b } },
+	{ 0xa310,
+		{ 0x6c4b624a, 0x6c4b624a } },
+	{ 0xa314,
+		{ 0x7e8b748a, 0x7e8b748a } },
+	{ 0xa318,
+		{ 0x96cf8ccb, 0x96cf8ccb } },
+	{ 0xa31c,
+		{ 0xa34f9d0f, 0xa34f9d0f } },
+	{ 0xa320,
+		{ 0xa7cfa58f, 0xa7cfa58f } },
+	{ 0xa348,
+		{ 0x3fffffff, 0x3fffffff } },
+	{ 0xa34c,
+		{ 0x3fffffff, 0x3fffffff } },
+	{ 0xa350,
+		{ 0x3fffffff, 0x3fffffff } },
+	{ 0xa354,
+		{ 0x0003ffff, 0x0003ffff } },
+	{ 0xa358,
+		{ 0x79a8aa1f, 0x79a8aa1f } },
+	{ 0xa35c,
+		{ 0x066c420f, 0x066c420f } },
+	{ 0xa360,
+		{ 0x0f282207, 0x0f282207 } },
+	{ 0xa364,
+		{ 0x17601685, 0x17601685 } },
+	{ 0xa368,
+		{ 0x1f801104, 0x1f801104 } },
+	{ 0xa36c,
+		{ 0x37a00c03, 0x37a00c03 } },
+	{ 0xa370,
+		{ 0x3fc40883, 0x3fc40883 } },
+	{ 0xa374,
+		{ 0x57c00803, 0x57c00803 } },
+	{ 0xa378,
+		{ 0x5fd80682, 0x5fd80682 } },
+	{ 0xa37c,
+		{ 0x7fe00482, 0x7fe00482 } },
+	{ 0xa380,
+		{ 0x7f3c7bba, 0x7f3c7bba } },
+	{ 0xa384,
+		{ 0xf3307ff0, 0xf3307ff0 } },
+};
+
 /*
  * Initial BaseBand Gain settings for RF5111/5112 (AR5210 comes with
  * RF5110 only so initial BB Gain settings are included in AR5K_AR5210_INI)
@@ -1542,7 +1749,34 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
 
+		} else if (ah->ah_radio == AR5K_RF2425) {
+
+			if (mode < 2) {
+				ATH5K_ERR(ah->ah_sc,
+					"unsupported channel mode: %d\n", mode);
+				return -EINVAL;
+			}
+
+			/* Map b to g */
+			if (mode == 2)
+				mode = 0;
+			else
+				mode = mode - 3;
+
+			/* Override a setting from ar5212_ini */
+			ath5k_hw_reg_write(ah, 0x018830c6, AR5K_PHY(648));
+
+			ath5k_hw_ini_mode_registers(ah,
+					ARRAY_SIZE(rf2425_ini_mode_end),
+					rf2425_ini_mode_end, mode);
+
+			/* Baseband gain table */
+			ath5k_hw_ini_registers(ah,
+					ARRAY_SIZE(rf5112_ini_bbgain),
+					rf5112_ini_bbgain, change_channel);
+
 		}
+
 	/* For AR5211 */
 	} else if (ah->ah_version == AR5K_AR5211) {
 
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 890ecce..afd8689 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -669,6 +669,7 @@ static const struct ath5k_ini_rf rfregs_5413[] = {
 /* RF2413/2414 mode-specific init registers */
 static const struct ath5k_ini_rf rfregs_2413[] = {
 	{ 1, AR5K_RF_BUFFER_CONTROL_4,
+	/* 	   mode b      mode g     mode gTurbo */
 		{ 0x00000020, 0x00000020, 0x00000020 } },
 	{ 2, AR5K_RF_BUFFER_CONTROL_3,
 		{ 0x02001408, 0x02001408, 0x02001408 } },
@@ -736,6 +737,83 @@ static const struct ath5k_ini_rf rfregs_2413[] = {
 		{ 0x0000000e, 0x0000000e, 0x0000000e } },
 };
 
+/* RF2425 mode-specific init registers */
+static const struct ath5k_ini_rf rfregs_2425[] = {
+	{ 1, AR5K_RF_BUFFER_CONTROL_4,
+	/* 	   mode g     mode gTurbo */
+		{ 0x00000020, 0x00000020 } },
+	{ 2, AR5K_RF_BUFFER_CONTROL_3,
+		{ 0x02001408, 0x02001408 } },
+	{ 3, AR5K_RF_BUFFER_CONTROL_6,
+		{ 0x00e020c0, 0x00e020c0 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x10000000, 0x10000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x002a0000, 0x002a0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00100000, 0x00100000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00020000, 0x00020000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00730000, 0x00730000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00f80000, 0x00f80000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00e70000, 0x00e70000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00140000, 0x00140000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00910040, 0x00910040 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x0007001a, 0x0007001a } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00410000, 0x00410000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00810060, 0x00810060 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00020803, 0x00020803 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00001660, 0x00001660 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00001688, 0x00001688 } },
+	{ 6, AR5K_RF_BUFFER_CONTROL_1,
+		{ 0x00000001, 0x00000001 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00006400, 0x00006400 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000800, 0x00000800 } },
+	{ 7, AR5K_RF_BUFFER_CONTROL_2,
+		{ 0x0000000e, 0x0000000e } },
+};
+
 /* Initial RF Gain settings for RF5112 */
 static const struct ath5k_ini_rfgain rfgain_5112[] = {
 	/*			      5Ghz	2Ghz	*/
@@ -1348,7 +1426,8 @@ static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 }
 
 /*
- * Initialize RF5413/5414
+ * Initialize RF5413/5414 and future chips
+ * (until we come up with a better solution)
  */
 static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel, unsigned int mode)
@@ -1362,19 +1441,41 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
 
 	rf = ah->ah_rf_banks;
 
-	if (ah->ah_radio == AR5K_RF5413) {
+	switch (ah->ah_radio) {
+	case AR5K_RF5413:
 		rf_ini = rfregs_5413;
 		rf_size = ARRAY_SIZE(rfregs_5413);
-	} else if (ah->ah_radio == AR5K_RF2413) {
+		break;
+	case AR5K_RF2413:
 		rf_ini = rfregs_2413;
 		rf_size = ARRAY_SIZE(rfregs_2413);
+
 		if (mode < 2) {
 			ATH5K_ERR(ah->ah_sc,
 				"invalid channel mode: %i\n", mode);
 			return -EINVAL;
 		}
+
 		mode = mode - 2;
-	} else {
+		break;
+	case AR5K_RF2425:
+		rf_ini = rfregs_2425;
+		rf_size = ARRAY_SIZE(rfregs_2425);
+
+		if (mode < 2) {
+			ATH5K_ERR(ah->ah_sc,
+				"invalid channel mode: %i\n", mode);
+			return -EINVAL;
+		}
+
+		/* Map b to g */
+		if (mode == 2)
+			mode = 0;
+		else
+			mode = mode - 3;
+
+		break;
+	default:
 		return -EINVAL;
 	}
 
@@ -1439,6 +1540,10 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		ah->ah_rf_banks_size = sizeof(rfregs_2413);
 		func = ath5k_hw_rf5413_rfregs;
 		break;
+	case AR5K_RF2425:
+		ah->ah_rf_banks_size = sizeof(rfregs_2425);
+		func = ath5k_hw_rf5413_rfregs;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1482,6 +1587,11 @@ int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq)
 		size = ARRAY_SIZE(rfgain_2413);
 		freq = 0; /* only 2Ghz */
 		break;
+	case AR5K_RF2425:
+		ath5k_rfg = rfgain_2413;
+		size = ARRAY_SIZE(rfgain_2413);
+		freq = 0; /* only 2Ghz */
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2181,8 +2291,11 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	 * transmit anything if we call
 	 * this funtion, so we skip it
 	 * until we fix txpower.
+	 *
+	 * XXX: Assume same for RF2425
+	 * to be safe.
 	 */
-	if (ah->ah_radio == AR5K_RF2413)
+	if ((ah->ah_radio == AR5K_RF2413) || (ah->ah_radio == AR5K_RF2425))
 		return 0;
 
 	/* Reset TX power values */

