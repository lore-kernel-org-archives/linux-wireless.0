Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:51886 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYBXEP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 23:15:29 -0500
Date: Sun, 24 Feb 2008 06:15:09 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 2/8] ath5k: Add RF2413 initial settings
Message-ID: <20080224041509.GA4426@makis.domain.invalid> (sfid-20080224_041532_855150_A3EEEC25)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Add initial settings for RF2413

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index cfcb1fe..f337563 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -678,8 +678,8 @@ static const struct ath5k_ini ar5212_ini[] = {
 	{ AR5K_PHY(644), 0x00806333 },
 	{ AR5K_PHY(645), 0x00106c10 },
 	{ AR5K_PHY(646), 0x009c4060 },
-	/*{ AR5K_PHY(647), 0x1483800a },*/ /* Old value */
 	{ AR5K_PHY(647), 0x1483800a },
+	/* { AR5K_PHY(648), 0x018830c6 },*/ /* 2413 */
 	{ AR5K_PHY(648), 0x01831061 },
 	{ AR5K_PHY(649), 0x00000400 },
 	/*{ AR5K_PHY(650), 0x000001b5 },*/
@@ -1081,6 +1081,207 @@ static const struct ath5k_ini_mode rf5413_ini_mode_end[] = {
 		{ 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0 } },
 };
 
+/* Initial mode-specific settings for RF2413/2414 (Written after ar5212_ini) */
+/* XXX: No dumps for turbog yet, so turbog is the same with g here with some
+ * minor tweaking based on dumps from other chips */
+static const struct ath5k_ini_mode rf2413_ini_mode_end[] = {
+	{ AR5K_TXCFG,
+	/*	      b		g	    gTurbo */
+		{ 0x00000015, 0x00000015, 0x00000015 } },
+	{ AR5K_USEC_5211,
+		{ 0x04e01395, 0x12e013ab, 0x098813cf } },
+	{ AR5K_PHY(10),
+		{ 0x05020000, 0x0a020001, 0x0a020001 } },
+	{ AR5K_PHY(13),
+		{ 0x00000e00, 0x00000e00, 0x00000e00 } },
+	{ AR5K_PHY(14),
+		{ 0x0000000a, 0x0000000a, 0x0000000a } },
+	{ AR5K_PHY(18),
+		{ 0x001a6a64, 0x001a6a64, 0x001a6a64 } },
+	{ AR5K_PHY(20),
+		{ 0x0de8b0da, 0x0c98b0da, 0x0c98b0da } },
+	{ AR5K_PHY_SIG,
+		{ 0x7ee80d2e, 0x7ec80d2e, 0x7ec80d2e } },
+	{ AR5K_PHY_AGCCOARSE,
+		{ 0x3137665e, 0x3139605e, 0x3139605e } },
+	{ AR5K_PHY(27),
+		{ 0x050cb081, 0x050cb081, 0x050cb081 } },
+	{ AR5K_PHY_RX_DELAY,
+		{ 0x0000044c, 0x00000898, 0x000007d0 } },
+	{ AR5K_PHY_FRAME_CTL_5211,
+		{ 0xf7b80d00, 0xf7b81000, 0xf7b81000 } },
+	{ AR5K_PHY_CCKTXCTL,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(642),
+		{ 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	{ AR5K_PHY_GAIN_2GHZ,
+		{ 0x0042c140, 0x0042c140, 0x0042c140 } },
+	{ 0xa21c,
+		{ 0x1863800a, 0x1883800a, 0x1883800a } },
+	{ AR5K_DCU_FP,
+		{ 0x000003e0, 0x000003e0, 0x000003e0 } },
+	{ 0x8060,
+		{ 0x0000000f, 0x0000000f, 0x0000000f } },
+	{ 0x8118,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x811c,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8120,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8124,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8128,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x812c,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8130,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8134,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8138,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x813c,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x8140,
+		{ 0x800000a8, 0x800000a8, 0x800000a8 } },
+	{ 0x8144,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY_AGC,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(11),
+		{ 0x0000a000, 0x0000a000, 0x0000a000 } },
+	{ AR5K_PHY(15),
+		{ 0x00200400, 0x00200400, 0x00200400 } },
+	{ AR5K_PHY(19),
+		{ 0x1284233c, 0x1284233c, 0x1284233c } },
+	{ AR5K_PHY_SCR,
+		{ 0x0000001f, 0x0000001f, 0x0000001f } },
+	{ AR5K_PHY_SLMT,
+		{ 0x00000080, 0x00000080, 0x00000080 } },
+	{ AR5K_PHY_SCAL,
+		{ 0x0000000e, 0x0000000e, 0x0000000e } },
+	{ AR5K_PHY(86),
+		{ 0x000000ff, 0x000000ff, 0x000000ff } },
+	{ AR5K_PHY(96),
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(97),
+		{ 0x02800000, 0x02800000, 0x02800000 } },
+	{ AR5K_PHY(104),
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(120),
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(121),
+		{ 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa } },
+	{ AR5K_PHY(122),
+		{ 0x3c466478, 0x3c466478, 0x3c466478 } },
+	{ AR5K_PHY(123),
+		{ 0x000000aa, 0x000000aa, 0x000000aa } },
+	{ AR5K_PHY_SCLOCK,
+		{ 0x0000000c, 0x0000000c, 0x0000000c } },
+	{ AR5K_PHY_SDELAY,
+		{ 0x000000ff, 0x000000ff, 0x000000ff } },
+	{ AR5K_PHY_SPENDING,
+		{ 0x00000014, 0x00000014, 0x00000014 } },
+	{ 0xa228,
+		{ 0x000009b5, 0x000009b5, 0x000009b5 } },
+	{ 0xa23c,
+		{ 0x93c889af, 0x93c889af, 0x93c889af } },
+	{ 0xa24c,
+		{ 0x00000001, 0x00000001, 0x00000001 } },
+	{ 0xa250,
+		{ 0x0000a000, 0x0000a000, 0x0000a000 } },
+	{ 0xa254,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa258,
+		{ 0x0cc75380, 0x0cc75380, 0x0cc75380 } },
+	{ 0xa25c,
+		{ 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01 } },
+	{ 0xa260,
+		{ 0x5f690f01, 0x5f690f01, 0x5f690f01 } },
+	{ 0xa264,
+		{ 0x00418a11, 0x00418a11, 0x00418a11 } },
+	{ 0xa268,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa26c,
+		{ 0x0c30c16a, 0x0c30c16a, 0x0c30c16a } },
+	{ 0xa270,
+		{ 0x00820820, 0x00820820, 0x00820820 } },
+	{ 0xa274,
+		{ 0x001b7caa, 0x001b7caa, 0x001b7caa } },
+	{ 0xa278,
+		{ 0x1ce739ce, 0x1ce739ce, 0x1ce739ce } },
+	{ 0xa27c,
+		{ 0x051701ce, 0x051701ce, 0x051701ce } },
+	{ 0xa300,
+		{ 0x18010000, 0x18010000, 0x18010000 } },
+	{ 0xa304,
+		{ 0x30032602, 0x30032602, 0x30032602 } },
+	{ 0xa308,
+		{ 0x48073e06, 0x48073e06, 0x48073e06 } },
+	{ 0xa30c,
+		{ 0x560b4c0a, 0x560b4c0a, 0x560b4c0a } },
+	{ 0xa310,
+		{ 0x641a600f, 0x641a600f, 0x641a600f } },
+	{ 0xa314,
+		{ 0x784f6e1b, 0x784f6e1b, 0x784f6e1b } },
+	{ 0xa318,
+		{ 0x868f7c5a, 0x868f7c5a, 0x868f7c5a } },
+	{ 0xa31c,
+		{ 0x8ecf865b, 0x8ecf865b, 0x8ecf865b } },
+	{ 0xa320,
+		{ 0x9d4f970f, 0x9d4f970f, 0x9d4f970f } },
+	{ 0xa324,
+		{ 0xa5cfa18f, 0xa5cfa18f, 0xa5cfa18f } },
+	{ 0xa328,
+		{ 0xb55faf1f, 0xb55faf1f, 0xb55faf1f } },
+	{ 0xa32c,
+		{ 0xbddfb99f, 0xbddfb99f, 0xbddfb99f } },
+	{ 0xa330,
+		{ 0xcd7fc73f, 0xcd7fc73f, 0xcd7fc73f } },
+	{ 0xa334,
+		{ 0xd5ffd1bf, 0xd5ffd1bf, 0xd5ffd1bf } },
+	{ 0xa338,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa33c,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa340,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa344,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa348,
+		{ 0x3fffffff, 0x3fffffff, 0x3fffffff } },
+	{ 0xa34c,
+		{ 0x3fffffff, 0x3fffffff, 0x3fffffff } },
+	{ 0xa350,
+		{ 0x3fffffff, 0x3fffffff, 0x3fffffff } },
+	{ 0xa354,
+		{ 0x0003ffff, 0x0003ffff, 0x0003ffff } },
+	{ 0xa358,
+		{ 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f } },
+	{ 0xa35c,
+		{ 0x066c420f, 0x066c420f, 0x066c420f } },
+	{ 0xa360,
+		{ 0x0f282207, 0x0f282207, 0x0f282207 } },
+	{ 0xa364,
+		{ 0x17601685, 0x17601685, 0x17601685 } },
+	{ 0xa368,
+		{ 0x1f801104, 0x1f801104, 0x1f801104 } },
+	{ 0xa36c,
+		{ 0x37a00c03, 0x37a00c03, 0x37a00c03 } },
+	{ 0xa370,
+		{ 0x3fc40883, 0x3fc40883, 0x3fc40883 } },
+	{ 0xa374,
+		{ 0x57c00803, 0x57c00803, 0x57c00803 } },
+	{ 0xa378,
+		{ 0x5fd80682, 0x5fd80682, 0x5fd80682 } },
+	{ 0xa37c,
+		{ 0x7fe00482, 0x7fe00482, 0x7fe00482 } },
+	{ 0xa380,
+		{ 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba } },
+	{ 0xa384,
+		{ 0xf3307ff0, 0xf3307ff0, 0xf3307ff0 } },
+};
+
 /*
  * Initial BaseBand Gain settings for RF5111/5112 (AR5210 comes with
  * RF5110 only so initial BB Gain settings are included in AR5K_AR5210_INI)
@@ -1290,29 +1491,56 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 
 		/* Second set of mode-specific settings */
 		if (ah->ah_radio == AR5K_RF5111){
+
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5111_ini_mode_end),
 					ar5212_rf5111_ini_mode_end, mode);
+
 			/* Baseband gain table */
 			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5111_ini_bbgain),
 					rf5111_ini_bbgain, change_channel);
+
 		} else if (ah->ah_radio == AR5K_RF5112){
+
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5112_ini_mode_end),
 					ar5212_rf5112_ini_mode_end, mode);
-			/* Baseband gain table */
+
 			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
+
 		} else if (ah->ah_radio == AR5K_RF5413){
+
 			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(rf5413_ini_mode_end),
 					rf5413_ini_mode_end, mode);
+
+			ath5k_hw_ini_registers(ah,
+					ARRAY_SIZE(rf5112_ini_bbgain),
+					rf5112_ini_bbgain, change_channel);
+
+		} else if (ah->ah_radio == AR5K_RF2413){
+
+			if(mode < 2){ /* AR5K_INI_VAL_11B */
+				ATH5K_ERR(ah->ah_sc,"unsupported channel mode: %d\n", mode);
+				return -EINVAL;
+			}
+			mode = mode - 2;
+
+			/* Override a setting from ar5212_ini */
+			ath5k_hw_reg_write(ah, 0x018830c6, AR5K_PHY(648));
+
+			ath5k_hw_ini_mode_registers(ah,
+					ARRAY_SIZE(rf2413_ini_mode_end),
+					rf2413_ini_mode_end, mode);
+
 			/* Baseband gain table */
 			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
+
 		}
 	/* For AR5211 */
 	} else if (ah->ah_version == AR5K_AR5211) {
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 405195f..e8378d1 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -666,6 +666,75 @@ static const struct ath5k_ini_rf rfregs_5413[] = {
 	    { 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e } },
 };
 
+/* RF2413/2414 mode-specific init registers */
+static const struct ath5k_ini_rf rfregs_2413[] = {
+	{ 1, AR5K_RF_BUFFER_CONTROL_4,
+		{ 0x00000020, 0x00000020, 0x00000020 } },
+	{ 2, AR5K_RF_BUFFER_CONTROL_3,
+		{ 0x02001408, 0x02001408, 0x02001408 } },
+	{ 3, AR5K_RF_BUFFER_CONTROL_6,
+		{ 0x00e020c0, 0x00e020c0, 0x00e020c0 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0xf0000000, 0xf0000000, 0xf0000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x03000000, 0x03000000, 0x03000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x40400000, 0x40400000, 0x40400000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x65050000, 0x65050000, 0x65050000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00420000, 0x00420000, 0x00420000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00b50000, 0x00b50000, 0x00b50000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00030000, 0x00030000, 0x00030000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00f70000, 0x00f70000, 0x00f70000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x009d0000, 0x009d0000, 0x009d0000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00220000, 0x00220000, 0x00220000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x04220000, 0x04220000, 0x04220000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00230018, 0x00230018, 0x00230018 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00280050, 0x00280050, 0x00280050 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x005000c3, 0x005000c3, 0x005000c3 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x0004007f, 0x0004007f, 0x0004007f } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000458, 0x00000458, 0x00000458 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, AR5K_RF_BUFFER,
+		{ 0x0000c000, 0x0000c000, 0x0000c000 } },
+	{ 6, AR5K_RF_BUFFER_CONTROL_5,
+		{ 0x00400230, 0x00400230, 0x00400230 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00006400, 0x00006400, 0x00006400 } },
+	{ 7, AR5K_RF_BUFFER,
+		{ 0x00000800, 0x00000800, 0x00000800 } },
+	{ 7, AR5K_RF_BUFFER_CONTROL_2,
+		{ 0x0000000e, 0x0000000e, 0x0000000e } },
+};
 
 /* Initial RF Gain settings for RF5112 */
 static const struct ath5k_ini_rfgain rfgain_5112[] = {
@@ -805,6 +874,74 @@ static const struct ath5k_ini_rfgain rfgain_5413[] = {
 	{ AR5K_RF_GAIN(63),	{ 0x000000f9, 0x000000f9 } },
 };
 
+/* Initial RF Gain settings for RF2413 */
+static const struct ath5k_ini_rfgain rfgain_2413[] = {
+	{ AR5K_RF_GAIN(0), { 0x00000000 } },
+	{ AR5K_RF_GAIN(1), { 0x00000040 } },
+	{ AR5K_RF_GAIN(2), { 0x00000080 } },
+	{ AR5K_RF_GAIN(3), { 0x00000181 } },
+	{ AR5K_RF_GAIN(4), { 0x000001c1 } },
+	{ AR5K_RF_GAIN(5), { 0x00000001 } },
+	{ AR5K_RF_GAIN(6), { 0x00000041 } },
+	{ AR5K_RF_GAIN(7), { 0x00000081 } },
+	{ AR5K_RF_GAIN(8), { 0x00000168 } },
+	{ AR5K_RF_GAIN(9), { 0x000001a8 } },
+	{ AR5K_RF_GAIN(10), { 0x000001e8 } },
+	{ AR5K_RF_GAIN(11), { 0x00000028 } },
+	{ AR5K_RF_GAIN(12), { 0x00000068 } },
+	{ AR5K_RF_GAIN(13), { 0x00000189 } },
+	{ AR5K_RF_GAIN(14), { 0x000001c9 } },
+	{ AR5K_RF_GAIN(15), { 0x00000009 } },
+	{ AR5K_RF_GAIN(16), { 0x00000049 } },
+	{ AR5K_RF_GAIN(17), { 0x00000089 } },
+	{ AR5K_RF_GAIN(18), { 0x00000190 } },
+	{ AR5K_RF_GAIN(19), { 0x000001d0 } },
+	{ AR5K_RF_GAIN(20), { 0x00000010 } },
+	{ AR5K_RF_GAIN(21), { 0x00000050 } },
+	{ AR5K_RF_GAIN(22), { 0x00000090 } },
+	{ AR5K_RF_GAIN(23), { 0x00000191 } },
+	{ AR5K_RF_GAIN(24), { 0x000001d1 } },
+	{ AR5K_RF_GAIN(25), { 0x00000011 } },
+	{ AR5K_RF_GAIN(26), { 0x00000051 } },
+	{ AR5K_RF_GAIN(27), { 0x00000091 } },
+	{ AR5K_RF_GAIN(28), { 0x00000178 } },
+	{ AR5K_RF_GAIN(29), { 0x000001b8 } },
+	{ AR5K_RF_GAIN(30), { 0x000001f8 } },
+	{ AR5K_RF_GAIN(31), { 0x00000038 } },
+	{ AR5K_RF_GAIN(32), { 0x00000078 } },
+	{ AR5K_RF_GAIN(33), { 0x00000199 } },
+	{ AR5K_RF_GAIN(34), { 0x000001d9 } },
+	{ AR5K_RF_GAIN(35), { 0x00000019 } },
+	{ AR5K_RF_GAIN(36), { 0x00000059 } },
+	{ AR5K_RF_GAIN(37), { 0x00000099 } },
+	{ AR5K_RF_GAIN(38), { 0x000000d9 } },
+	{ AR5K_RF_GAIN(39), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(40), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(41), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(42), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(43), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(44), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(45), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(46), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(47), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(48), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(49), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(50), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(51), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(52), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(53), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(54), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(55), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(56), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(57), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(58), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(59), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(60), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(61), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(62), { 0x000000f9 } },
+	{ AR5K_RF_GAIN(63), { 0x000000f9 } },
+};
+
 static const struct ath5k_gain_opt rfgain_opt_5112 = {
 	1,
 	8,
@@ -1226,8 +1363,20 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
 
 	rf = ah->ah_rf_banks;
 
-	rf_ini = rfregs_5413;
-	rf_size = ARRAY_SIZE(rfregs_5413);
+	if (ah->ah_radio == AR5K_RF5413) {
+		rf_ini = rfregs_5413;
+		rf_size = ARRAY_SIZE(rfregs_5413);
+	} else if (ah->ah_radio == AR5K_RF2413) {
+		rf_ini = rfregs_2413;
+		rf_size = ARRAY_SIZE(rfregs_2413);
+		if (mode < 2) {
+			ATH5K_ERR(ah->ah_sc,"invalid channel mode: %i\n",mode);
+			return -EINVAL;
+		}
+		mode = mode - 2;
+	} else {
+		return -EINVAL;
+	}
 
 	/* Copy values to modify them */
 	for (i = 0; i < rf_size; i++) {
@@ -1286,6 +1435,10 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		ah->ah_rf_banks_size = sizeof(rfregs_5413);
 		func = ath5k_hw_rf5413_rfregs;
 		break;
+	case AR5K_RF2413:
+		ah->ah_rf_banks_size = sizeof(rfregs_2413);
+		func = ath5k_hw_rf5413_rfregs;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1324,6 +1477,11 @@ int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq)
 		ath5k_rfg = rfgain_5413;
 		size = ARRAY_SIZE(rfgain_5413);
 		break;
+	case AR5K_RF2413:
+		ath5k_rfg = rfgain_2413;
+		size = ARRAY_SIZE(rfgain_2413);
+		freq = 0; /* only 2Ghz */
+		break;
 	default:
 		return -EINVAL;
 	}


