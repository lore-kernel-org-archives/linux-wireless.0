Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:36462 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbXLPBKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 20:10:31 -0500
Date: Sun, 16 Dec 2007 03:10:27 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 8/9] ath5k: Update initvals.c from recent regdumps
Message-ID: <20071216011027.GH5482@makis.domain.invalid> (sfid-20071216_011035_926048_8E95E3C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Update initvals.c from recent regdumps.
* RF5413 and later have a different base address for pcdac table so update reg.h.
* Remove static pcdac tables, we'll come up with a better solution (works for me).

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index c9b3753..d029200 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -20,6 +20,7 @@
  */
 
 #include "ath5k.h"
+#include "base.h"
 #include "reg.h"
 
 /*
@@ -339,7 +340,11 @@ static const struct ath5k_ini ar5211_ini[] = {
 	{ AR5K_PHY_RADAR, 0x5d50f14c },
 	{ AR5K_PHY(86),	0x00000018 },
 	{ AR5K_PHY(87),	0x004b6a8e },
-	/* Power table (32bytes) */
+	/* Initial Power table (32bytes)
+	 * common on all cards/modes.
+	 * Note: Table is rewritten during
+	 * txpower setup later using calibration
+	 * data etc. so next write is non-common 
 	{ AR5K_PHY_PCDAC_TXPOWER(1), 0x06ff05ff },
 	{ AR5K_PHY_PCDAC_TXPOWER(2), 0x07ff07ff },
 	{ AR5K_PHY_PCDAC_TXPOWER(3), 0x08ff08ff },
@@ -370,7 +375,7 @@ static const struct ath5k_ini ar5211_ini[] = {
 	{ AR5K_PHY_PCDAC_TXPOWER(28), 0x3aff3aff },
 	{ AR5K_PHY_PCDAC_TXPOWER(29), 0x3aff3aff },
 	{ AR5K_PHY_PCDAC_TXPOWER(30), 0x3aff3aff },
-	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x3aff3aff },*/
 	{ AR5K_PHY_CCKTXCTL, 0x00000000 },
 	{ AR5K_PHY(642), 0x503e4646 },
 	{ AR5K_PHY_GAIN_2GHZ, 0x6480416c },
@@ -385,80 +390,81 @@ static const struct ath5k_ini ar5211_ini[] = {
 };
 
 /* Initial mode-specific settings for AR5211
- * XXX: how about gTurbo ? RF5111 supports it, how about AR5211 ?
+ * XXX: how about g / gTurbo ? RF5111 supports it, how about AR5211 ?
+ * Maybe 5211 supports OFDM-only g but we need to test it !
  */
 static const struct ath5k_ini_mode ar5211_ini_mode[] = {
 	{ AR5K_TXCFG,
-	/*	  a/XR	      aTurbo	  b	      g(OFDM?)	  gTurbo (N/A) */
-		{ 0x00000017, 0x00000017, 0x00000017, 0x00000017, 0x00000017 } },
+	/*	  a	      aTurbo	  b		*/
+		{ 0x00000015, 0x00000015, 0x0000001d } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f } },
 	{ AR5K_DCU_GBL_IFS_SLOT,
-		{ 0x00000168, 0x000001e0, 0x000001b8, 0x00000168, 0x00000168 } },
+		{ 0x00000168, 0x000001e0, 0x000001b8 } },
 	{ AR5K_DCU_GBL_IFS_SIFS,
-		{ 0x00000230, 0x000001e0, 0x000000b0, 0x00000230, 0x00000230 } },
+		{ 0x00000230, 0x000001e0, 0x000000b0 } },
 	{ AR5K_DCU_GBL_IFS_EIFS,
-		{ 0x00000d98, 0x00001180, 0x00001f48, 0x00000d98, 0x00000d98 } },
+		{ 0x00000d98, 0x00001180, 0x00001f48 } },
 	{ AR5K_DCU_GBL_IFS_MISC,
-		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000a0e0, 0x0000a0e0 } },
+		{ 0x0000a0e0, 0x00014068, 0x00005880 } },
 	{ AR5K_TIME_OUT,
-		{ 0x04000400, 0x08000800, 0x20003000, 0x04000400, 0x04000400 } },
+		{ 0x04000400, 0x08000800, 0x20003000 } },
 	{ AR5K_USEC_5211,
-		{ 0x0e8d8fa7, 0x0e8d8fcf, 0x01608f95, 0x0e8d8fa7, 0x0e8d8fa7 } },
+		{ 0x0e8d8fa7, 0x0e8d8fcf, 0x01608f95 } },
 	{ AR5K_PHY_TURBO,
-		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000000 } },
-	{ 0x9820,
-		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
-	{ 0x9824,
-		{ 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },
-	{ 0x9828,
-		{ 0x0a020001, 0x0a020001, 0x05010000, 0x0a020001, 0x0a020001 } },
-	{ 0x9834,
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
-	{ 0x9838,
-		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
-	{ 0x9844,
-		{ 0x1372169c, 0x137216a5, 0x137216a8, 0x1372169c, 0x1372169c } },
-	{ 0x9848,
-		{ 0x0018ba67, 0x0018ba67, 0x0018ba69, 0x0018ba69, 0x0018ba69 } },
-	{ 0x9850,
-		{ 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0 } },
+		{ 0x00000000, 0x00000003, 0x00000000 } },
+	{ AR5K_PHY(8),
+		{ 0x02020200, 0x02020200, 0x02010200 } },
+	{ AR5K_PHY(9),
+		{ 0x00000e0e, 0x00000e0e, 0x00000707 } },
+	{ AR5K_PHY(10),
+		{ 0x0a020001, 0x0a020001, 0x05010000 } },
+	{ AR5K_PHY(13),
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ AR5K_PHY(14),
+		{ 0x00000007, 0x00000007, 0x0000000b } },
+	{ AR5K_PHY(17),
+		{ 0x1372169c, 0x137216a5, 0x137216a8 } },
+	{ AR5K_PHY(18),
+		{ 0x0018ba67, 0x0018ba67, 0x0018ba69 } },
+	{ AR5K_PHY(20),
+		{ 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0 } },
 	{ AR5K_PHY_SIG,
-		{ 0x7e800d2e, 0x7e800d2e, 0x7ec00d2e, 0x7e800d2e, 0x7e800d2e } },
+		{ 0x7e800d2e, 0x7e800d2e, 0x7ec00d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-		{ 0x31375d5e, 0x31375d5e, 0x313a5d5e, 0x31375d5e, 0x31375d5e } },
+		{ 0x31375d5e, 0x31375d5e, 0x313a5d5e } },
 	{ AR5K_PHY_AGCCTL,
-		{ 0x0000bd10, 0x0000bd10, 0x0000bd38, 0x0000bd10, 0x0000bd10 } },
+		{ 0x0000bd10, 0x0000bd10, 0x0000bd38 } },
 	{ AR5K_PHY_NF,
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+		{ 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
 	{ AR5K_PHY_RX_DELAY,
-		{ 0x00002710, 0x00002710, 0x0000157c, 0x00002710, 0x00002710 } },
-	{ 0x9918,
-		{ 0x00000190, 0x00000190, 0x00000084, 0x00000190, 0x00000190 } },
+		{ 0x00002710, 0x00002710, 0x0000157c } },
+	{ AR5K_PHY(70),
+		{ 0x00000190, 0x00000190, 0x00000084 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-		{ 0x6fe01020, 0x6fe01020, 0x6fe00920, 0x6fe01020, 0x6fe01020 } },
-	{ AR5K_PHY_PCDAC_TXPOWER(0),
-		{ 0x05ff14ff, 0x05ff14ff, 0x05ff14ff, 0x05ff19ff, 0x05ff19ff } },
+		{ 0x6fe01020, 0x6fe01020, 0x6fe00920 } },
+	{ AR5K_PHY_PCDAC_TXPOWER_BASE_5211,
+		{ 0x05ff14ff, 0x05ff14ff, 0x05ff14ff } },
 	{ AR5K_RF_BUFFER_CONTROL_4,
-		{ 0x00000010, 0x00000014, 0x00000010, 0x00000010, 0x00000010 } },
+		{ 0x00000010, 0x00000014, 0x00000010 } },
 };
 
 /* Initial register settings for AR5212 */
@@ -534,37 +540,40 @@ static const struct ath5k_ini ar5212_ini[] = {
 	{ 0x13fc, 0x00000000 },
 	{ 0x143c, 0x00000000 },
 	{ 0x147c, 0x00000000 },
+	{ AR5K_DCU_TX_FILTER_CLR, 0x00000000 },
+	{ AR5K_DCU_TX_FILTER_SET, 0x00000000 },
 	{ AR5K_STA_ID1,		0x00000000 },
 	{ AR5K_BSS_ID0,		0x00000000 },
 	{ AR5K_BSS_ID1,		0x00000000 },
-	{ AR5K_RSSI_THR,	0x00000000 },
-	{ AR5K_BEACON_5211,	0x00000000 },
-	{ AR5K_CFP_PERIOD_5211,	0x00000000 },
-	{ AR5K_TIMER0_5211,	0x00000030 },
-	{ AR5K_TIMER1_5211,	0x0007ffff },
-	{ AR5K_TIMER2_5211,	0x01ffffff },
-	{ AR5K_TIMER3_5211,	0x00000031 },
-	{ AR5K_CFP_DUR_5211,	0x00000000 },
+	/*{ AR5K_RSSI_THR,	0x00000000 },*/	/* Found on SuperAG cards */
+	{ AR5K_BEACON_5211,	0x00000000 },	/* Found on SuperAG cards */
+	{ AR5K_CFP_PERIOD_5211, 0x00000000 },	/* Found on SuperAG cards */
+	{ AR5K_TIMER0_5211,	0x00000030 },	/* Found on SuperAG cards */
+	{ AR5K_TIMER1_5211,	0x0007ffff },	/* Found on SuperAG cards */
+	{ AR5K_TIMER2_5211,	0x01ffffff },	/* Found on SuperAG cards */
+	{ AR5K_TIMER3_5211,	0x00000031 },	/* Found on SuperAG cards */
+	{ AR5K_CFP_DUR_5211,	0x00000000 },	/* Found on SuperAG cards */
 	{ AR5K_RX_FILTER_5211,	0x00000000 },
 	{ AR5K_DIAG_SW_5211,	0x00000000 },
 	{ AR5K_ADDAC_TEST,	0x00000000 },
 	{ AR5K_DEFAULT_ANTENNA,	0x00000000 },
-	{ 0x805c, 0xffffc7ff },
 	{ 0x8080, 0x00000000 },
-	{ AR5K_NAV_5211,	0x00000000 },
-	{ AR5K_RTS_OK_5211,	0x00000000 },
-	{ AR5K_RTS_FAIL_5211,	0x00000000 },
-	{ AR5K_ACK_FAIL_5211,	0x00000000 },
-	{ AR5K_FCS_FAIL_5211,	0x00000000 },
-	{ AR5K_BEACON_CNT_5211,	0x00000000 },
+	/*{ 0x805c, 0xffffc7ff },*/ /* Old value */
+	{ 0x805c, 0x000fc78f },
+	{ AR5K_NAV_5211,	0x00000000 },	/* Not found on recent */
+	{ AR5K_RTS_OK_5211,	0x00000000 },	/* dumps but it makes  */
+	{ AR5K_RTS_FAIL_5211,	0x00000000 },	/* sense to reset counters */
+	{ AR5K_ACK_FAIL_5211,	0x00000000 },	/* since pcu registers */
+	{ AR5K_FCS_FAIL_5211,	0x00000000 },	/* are skiped during chan*/
+	{ AR5K_BEACON_CNT_5211, 0x00000000 },	/* change */
 	{ AR5K_XRMODE,		0x2a82301a },
 	{ AR5K_XRDELAY,		0x05dc01e0 },
 	{ AR5K_XRTIMEOUT,	0x1f402710 },
 	{ AR5K_XRCHIRP,		0x01f40000 },
 	{ AR5K_XRSTOMP,		0x00001e1c },
-	{ AR5K_SLEEP0,		0x0002aaaa },
-	{ AR5K_SLEEP1,		0x02005555 },
-	{ AR5K_SLEEP2,		0x00000000 },
+	{ AR5K_SLEEP0,		0x0002aaaa },	/* Found on SuperAG cards */
+	{ AR5K_SLEEP1,		0x02005555 },	/* Found on SuperAG cards */
+	{ AR5K_SLEEP2,		0x00000000 },	/* Found on SuperAG cards */
 	{ AR5K_BSS_IDM0,	0xffffffff },
 	{ AR5K_BSS_IDM1,	0x0000ffff },
 	{ AR5K_TXPC,		0x00000000 },
@@ -631,92 +640,66 @@ static const struct ath5k_ini ar5212_ini[] = {
 	{ 0x87f8, 0x1b1a1918 },
 	{ 0x87fc, 0x1f1e1d1c },
 	/* PHY registers */
-	{ AR5K_PHY_AGC,	0x00000000 },
+	/*{ AR5K_PHY_AGC, 0x00000000 },*/
 	{ AR5K_PHY(3),	0xad848e19 },
 	{ AR5K_PHY(4),	0x7d28e000 },
 	{ AR5K_PHY_TIMING_3, 0x9c0a9f6b },
 	{ AR5K_PHY_ACT,	0x00000000 },
-	{ AR5K_PHY(11),	0x00022ffe },
-	{ AR5K_PHY(15),	0x00020100 },
+	/*{ AR5K_PHY(11), 0x00022ffe },*/
+	/*{ AR5K_PHY(15), 0x00020100 },*/
 	{ AR5K_PHY(16),	0x206a017a },
-	{ AR5K_PHY(19),	0x1284613c },
+	/*{ AR5K_PHY(19), 0x1284613c },*/
 	{ AR5K_PHY(21),	0x00000859 },
 	{ AR5K_PHY(64),	0x00000000 },
 	{ AR5K_PHY(65),	0x00000000 },
 	{ AR5K_PHY(66),	0x00000000 },
 	{ AR5K_PHY(67),	0x00800000 },
 	{ AR5K_PHY(68),	0x00000001 },
-	{ AR5K_PHY(71),	0x0000092a },
+	/*{ AR5K_PHY(71), 0x0000092a },*/ /* Old value */
+	{ AR5K_PHY(71),	0x00000c80 },
 	{ AR5K_PHY_IQ,	0x05100000 },
 	{ AR5K_PHY(74), 0x00000001 },
 	{ AR5K_PHY(75), 0x00000004 },
 	{ AR5K_PHY_TXPOWER_RATE1, 0x1e1f2022 },
 	{ AR5K_PHY_TXPOWER_RATE2, 0x0a0b0c0d },
 	{ AR5K_PHY_TXPOWER_RATE_MAX, 0x0000003f },
-	{ AR5K_PHY(80), 0x00000004 },
+	/*{ AR5K_PHY(80), 0x00000004 },*/
 	{ AR5K_PHY(82), 0x9280b212 },
 	{ AR5K_PHY_RADAR, 0x5d50e188 },
-	{ AR5K_PHY(86),	0x000000ff },
-	{ AR5K_PHY(87),	0x004b6a8e },
+	/*{ AR5K_PHY(86), 0x000000ff },*/
+	{ AR5K_PHY(87), 0x004b6a8e },
 	{ AR5K_PHY(90),	0x000003ce },
 	{ AR5K_PHY(92),	0x192fb515 },
-	{ AR5K_PHY(93),	0x00000000 },
+	/*{ AR5K_PHY(93), 0x00000000 },*/
 	{ AR5K_PHY(94),	0x00000001 },
 	{ AR5K_PHY(95),	0x00000000 },
-	/* Power table (32bytes) */
-	{ AR5K_PHY_PCDAC_TXPOWER(1), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(2), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(3), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(4), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(5), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(6), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(7), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(8), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(9), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(10), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(11), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(12), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(13), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(14), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(15), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(16), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(17), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(18), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(19), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(20), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(21), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(22), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(23), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(24), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(25), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(26), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(27), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(28), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(29), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(30), 0x10ff10ff },
-	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x10ff10ff },
-	{ AR5K_PHY(644), 0x0080a333 },
-	{ AR5K_PHY(645), 0x00206c10 },
+	/*{ AR5K_PHY(644), 0x0080a333 },*/ /* Old value */
+	/*{ AR5K_PHY(645), 0x00206c10 },*/ /* Old value */
+	{ AR5K_PHY(644), 0x00806333 },
+	{ AR5K_PHY(645), 0x00106c10 },
 	{ AR5K_PHY(646), 0x009c4060 },
+	/*{ AR5K_PHY(647), 0x1483800a },*/ /* Old value */
 	{ AR5K_PHY(647), 0x1483800a },
 	{ AR5K_PHY(648), 0x01831061 },
 	{ AR5K_PHY(649), 0x00000400 },
-	{ AR5K_PHY(650), 0x000001b5 },
+	/*{ AR5K_PHY(650), 0x000001b5 },*/
 	{ AR5K_PHY(651), 0x00000000 },
 	{ AR5K_PHY_TXPOWER_RATE3, 0x20202020 },
 	{ AR5K_PHY_TXPOWER_RATE2, 0x20202020 },
-	{ AR5K_PHY(655), 0x13c889af },
+	/*{ AR5K_PHY(655), 0x13c889af },*/
 	{ AR5K_PHY(656), 0x38490a20 },
 	{ AR5K_PHY(657), 0x00007bb6 },
 	{ AR5K_PHY(658), 0x0fff3ffc },
-	{ AR5K_PHY_CCKTXCTL, 0x00000000 },
+	/*{ AR5K_PHY_CCKTXCTL, 0x00000000 },*/
 };
 
-/* Initial mode-specific settings for AR5212 */
-static const struct ath5k_ini_mode ar5212_ini_mode[] = {
-	{ AR5K_TXCFG,
+/* Initial mode-specific settings for AR5212 (Written before ar5212_ini) */
+static const struct ath5k_ini_mode ar5212_ini_mode_start[] = {
+	{ AR5K_PHY(640),
 	/*	  a/XR	      aTurbo	  b	      g (DYN)	  gTurbo */
-		{ 0x00008107, 0x00008107, 0x00008107, 0x00008107, 0x00008107 } },
+		{ 0x00000008, 0x00000008, 0x0000000b, 0x0000000e, 0x0000000e } },
+	{ AR5K_PHY(0),
+		{ 0x00000007, 0x00000007, 0x00000007, 0x00000007, 0x00000007 } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
 		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),
@@ -747,341 +730,360 @@ static const struct ath5k_ini_mode ar5212_ini_mode[] = {
 		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000b0e0, 0x00014068 } },
 	{ AR5K_TIME_OUT,
 		{ 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840, 0x06e006e0 } },
-};
-
-/* Initial mode-specific settings for AR5212 + RF5111 */
-static const struct ath5k_ini_mode ar5212_rf5111_ini_mode[] = {
-	{ AR5K_USEC_5211,
-	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */
-		{ 0x128d8fa7, 0x09880fcf, 0x04e00f95, 0x128d8fab, 0x09880fcf } },
 	{ AR5K_PHY_TURBO,
 		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },
-	{ 0x9820,
+	{ AR5K_PHY(8),
 		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
-	{ 0x9824,
+	{ AR5K_PHY(9),
 		{ 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },
-	{ 0x9828,
+	{ AR5K_PHY(17),
+		{ 0x1372161c, 0x13721c25, 0x13721722, 0x137216a2, 0x13721c25 } },
+	{ AR5K_PHY_AGCCTL,
+		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d18, 0x00009d18 } },
+	{ AR5K_PHY_NF,
+		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	{ AR5K_PHY(26),
+		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
+	{ AR5K_PHY(70),
+		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
+	{ AR5K_PHY(73),
+		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
+	{ 0xa230,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
+};
+
+/* Initial mode-specific settings for AR5212 + RF5111 (Written after ar5212_ini) */
+/* New dump pending */
+static const struct ath5k_ini_mode ar5212_rf5111_ini_mode_end[] = {
+	{ AR5K_PHY(640), /* This one differs from ar5212_ini_mode_start ! */
+	/*	  a/XR	      aTurbo	  b	      g (DYN)	  gTurbo */
+		{ 0x00000000, 0x00000000, 0x00000003, 0x00000006, 0x00000006 } },
+	{ AR5K_TXCFG,
+		{ 0x00008015, 0x00008015, 0x00008015, 0x00008015, 0x00008015 } },
+	{ AR5K_USEC_5211,
+		{ 0x128d8fa7, 0x09880fcf, 0x04e00f95, 0x12e00fab, 0x09880fcf } },
+	{ AR5K_PHY(10),
 		{ 0x0a020001, 0x0a020001, 0x05010100, 0x0a020001, 0x0a020001 } },
-	{ 0x9834,
+	{ AR5K_PHY(13),
 		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
-	{ 0x9838,
+	{ AR5K_PHY(14),
 		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
-	{ 0x9844,
-		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },
-	{ 0x9848,
+	{ AR5K_PHY(18),
 		{ 0x0018da5a, 0x0018da5a, 0x0018ca69, 0x0018ca69, 0x0018ca69 } },
-	{ 0x9850,
+	{ AR5K_PHY(20),
 		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
 	{ AR5K_PHY_SIG,
 		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },
 	{ AR5K_PHY_AGCCOARSE,
 		{ 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137615e } },
-	{ AR5K_PHY_AGCCTL,
-		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },
-	{ AR5K_PHY_NF,
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
-	{ AR5K_PHY_ADCSAT,
-		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
-	{ 0x986c,
+	{ AR5K_PHY(27),
 		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb080, 0x050cb080 } },
 	{ AR5K_PHY_RX_DELAY,
 		{ 0x00002710, 0x00002710, 0x0000157c, 0x00002af8, 0x00002710 } },
-	{ 0x9918,
-		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
-	{ 0x9924,
-		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-		{ 0xffb81020, 0xffb81020, 0xffb80d20, 0xffb81020, 0xffb81020 } },
-	{ AR5K_PHY_PCDAC_TXPOWER(0),
-		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },
-	{ 0xa230,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
-	{ 0xa208,
+		{ 0xf7b81020, 0xf7b81020, 0xf7b80d20, 0xf7b81020, 0xf7b81020 } },
+	{ AR5K_PHY_GAIN_2GHZ,
+		{ 0x642c416a, 0x642c416a, 0x6440416a, 0x6440416a, 0x6440416a } },
+	{ 0xa21c,
+		{ 0x1883800a, 0x1883800a, 0x1873800a, 0x1883800a, 0x1883800a } },
+	{ AR5K_DCU_FP,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY_AGC,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(11),
+		{ 0x00022ffe, 0x00022ffe, 0x00022ffe, 0x00022ffe, 0x00022ffe } },
+	{ AR5K_PHY(15),
+		{ 0x00020100, 0x00020100, 0x00020100, 0x00020100, 0x00020100 } },
+	{ AR5K_PHY(19),
+		{ 0x1284613c, 0x1284613c, 0x1284613c, 0x1284613c, 0x1284613c } },
+	{ AR5K_PHY_PAPD_PROBE,
+		{ 0x00004883, 0x00004883, 0x00004883, 0x00004883, 0x00004883 } },
+	{ AR5K_PHY(80),
+		{ 0x00000004, 0x00000004, 0x00000004, 0x00000004, 0x00000004 } },
+	{ AR5K_PHY(86),
+		{ 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff } },
+	{ AR5K_PHY(93),
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY_SPENDING,
+		{ 0x00000018, 0x00000018, 0x00000018, 0x00000018, 0x00000018 } },
+	{ AR5K_PHY_CCKTXCTL,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(642),
 		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	{ 0xa23c,
+		{ 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
 };
 
-/* Initial mode-specific settings for AR5212 + RF5112 */
-static const struct ath5k_ini_mode ar5212_rf5112_ini_mode[] = {
+/* Initial mode-specific settings for AR5212 + RF5112 (Written after ar5212_ini) */
+/* XXX: No dumps for turbog yet, but i found settings from old values so it should be ok */
+static const struct ath5k_ini_mode ar5212_rf5112_ini_mode_end[] = {
+	{ AR5K_TXCFG,
+	/*	  a/XR	      aTurbo	  b	      g (DYN)	  gTurbo */
+		{ 0x00008015, 0x00008015, 0x00008015, 0x00008015, 0x00008015 } },
 	{ AR5K_USEC_5211,
-	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */
-		{ 0x128d93a7, 0x098813cf, 0x04e01395, 0x128d93ab, 0x098813cf } },
-	{ AR5K_PHY_TURBO,
-		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },
-	{ 0x9820,
-		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
-	{ 0x9824,
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
-	{ 0x9828,
+		{ 0x128d93a7, 0x098813cf, 0x04e01395, 0x12e013ab, 0x098813cf } },
+	{ AR5K_PHY(10),
 		{ 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },
-	{ 0x9834,
+	{ AR5K_PHY(13),
 		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
-	{ 0x9838,
+	{ AR5K_PHY(14),
 		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
-	{ 0x9844,
-		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },
-	{ 0x9848,
+	{ AR5K_PHY(18),
 		{ 0x0018da6d, 0x0018da6d, 0x0018ca75, 0x0018ca75, 0x0018ca75 } },
-	{ 0x9850,
+	{ AR5K_PHY(20),
 		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
 	{ AR5K_PHY_SIG,
-		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },
+		{ 0x7e800d2e, 0x7e800d2e, 0x7ee80d2e, 0x7ee80d2e, 0x7ee80d2e } },
 	{ AR5K_PHY_AGCCOARSE,
 		{ 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e } },
-	{ AR5K_PHY_AGCCTL,
-		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },
-	{ AR5K_PHY_NF,
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
-	{ AR5K_PHY_ADCSAT,
-		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
-	{ 0x986c,
+	{ AR5K_PHY(27),
 		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
 	{ AR5K_PHY_RX_DELAY,
 		{ 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
-	{ 0x9918,
-		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
-	{ 0x9924,
-		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-		{ 0xffb81020, 0xffb81020, 0xffb80d10, 0xffb81010, 0xffb81010 } },
-	{ AR5K_PHY_PCDAC_TXPOWER(0),
-		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },
-	{ 0xa230,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
+		{ 0xf7b81020, 0xf7b81020, 0xf7b80d10, 0xf7b81010, 0xf7b81010 } },
 	{ AR5K_PHY_CCKTXCTL,
-		{ 0x00000000, 0x00000000, 0x00000004, 0x00000004, 0x00000004 } },
-	{ 0xa208,
+		{ 0x00000000, 0x00000000, 0x00000008, 0x00000008, 0x00000008 } },
+	{ AR5K_PHY(642),
 		{ 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
 	{ AR5K_PHY_GAIN_2GHZ,
 		{ 0x642c0140, 0x642c0140, 0x6442c160, 0x6442c160, 0x6442c160 } },
+	{ 0xa21c,
+		{ 0x1883800a, 0x1883800a, 0x1873800a, 0x1883800a, 0x1883800a } },
+	{ AR5K_DCU_FP,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY_AGC,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(11),
+		{ 0x00022ffe, 0x00022ffe, 0x00022ffe, 0x00022ffe, 0x00022ffe } },
+	{ AR5K_PHY(15),
+		{ 0x00020100, 0x00020100, 0x00020100, 0x00020100, 0x00020100 } },
+	{ AR5K_PHY(19),
+		{ 0x1284613c, 0x1284613c, 0x1284613c, 0x1284613c, 0x1284613c } },
+	{ AR5K_PHY_PAPD_PROBE,
+		{ 0x00004882, 0x00004882, 0x00004882, 0x00004882, 0x00004882 } },
+	{ AR5K_PHY(80),
+		{ 0x00000004, 0x00000004, 0x00000004, 0x00000004, 0x00000004 } },
+	{ AR5K_PHY(86),
+		{ 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff } },
+	{ AR5K_PHY(93),
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0xa228,
+		{ 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5 } },
+	{ 0xa23c,
+		{ 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
 };
 
-/* Initial mode-specific settings for RF5413/5414 */
-static const struct ath5k_ini_mode rf5413_ini_mode[] = {
+/* Initial mode-specific settings for RF5413/5414 (Written after ar5212_ini) */
+/* XXX: No dumps for turbog yet, so turbog is the same with g here with some
+ * minor tweaking based on dumps from other chips */
+static const struct ath5k_ini_mode rf5413_ini_mode_end[] = {
 	{ AR5K_TXCFG,
-		{ 0x00000015, 0x00000015, 0x00000015, 0x00000015, 0x00000015, } },
+	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */
+		{ 0x00000015, 0x00000015, 0x00000015, 0x00000015, 0x00000015 } },
 	{ AR5K_USEC_5211,
-		{ 0x128d93a7, 0x128d93a7, 0x04e01395, 0x12e013ab, 0x12e013ab, } },
-	{ AR5K_PHY_TURBO,
-		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003, } },
-	{ 0x9820,
-		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200, } },
-	{ 0x9824,
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, } },
-	{ 0x9828,
-		{ 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001, } },
-	{ 0x9834,
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, } },
-	{ 0x9838,
-		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b, } },
-	{ 0x9844,
-		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25, } },
-	{ 0x9848,
-		{ 0x0018fa61, 0x0018fa61, 0x001a1a63, 0x001a1a63, 0x001a1a63, } },
-	{ 0x9850,
-		{ 0x0c98b4e0, 0x0c98b4e0, 0x0c98b0da, 0x0c98b0da, 0x0c98b0da, } },
+		{ 0x128d93a7, 0x098813cf, 0x04e01395, 0x12e013ab, 0x098813cf } },
+	{ AR5K_PHY(10),
+		{ 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },
+	{ AR5K_PHY(13),
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ AR5K_PHY(14),
+		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	{ AR5K_PHY(18),
+		{ 0x0018fa61, 0x0018fa61, 0x001a1a63, 0x001a1a63, 0x001a1a63 } },
+	{ AR5K_PHY(20),
+		{ 0x0c98b4e0, 0x0c98b4e0, 0x0c98b0da, 0x0c98b0da, 0x0c98b0da } },
 	{ AR5K_PHY_SIG,
-		{ 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, } },
+		{ 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-		{ 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e, } },
-	{ AR5K_PHY_AGCCTL,
-		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10, } },
-	{ AR5K_PHY_NF,
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, } },
-	{ AR5K_PHY_ADCSAT,
-		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, } },
-	{ 0x986c,
-		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, } },
+		{ 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e } },
+	{ AR5K_PHY(27),
+		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
 	{ AR5K_PHY_RX_DELAY,
-		{ 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x00000898, } },
-	{ 0x9918,
-		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8, } },
-	{ 0x9924,
-		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, } },
+		{ 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-		{ 0xf7b81000, 0xf7b81000, 0xf7b80d00, 0xf7b81000, 0xf7b81000, } },
-	{ 0xa230,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000, } },
+		{ 0xf7b81000, 0xf7b81000, 0xf7b80d00, 0xf7b81000, 0xf7b81000 } },
 	{ AR5K_PHY_CCKTXCTL,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
-	{ 0xa208,
-		{ 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(642),
+		{ 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
 	{ AR5K_PHY_GAIN_2GHZ,
-		{ 0x002ec1e0, 0x002ec1e0, 0x002ac120, 0x002ac120, 0x002ac120, } },
+		{ 0x002ec1e0, 0x002ec1e0, 0x002ac120, 0x002ac120, 0x002ac120 } },
 	{ 0xa21c,
-		{ 0x1883800a, 0x1883800a, 0x1863800a, 0x1883800a, 0x1883800a, } },
+		{ 0x1883800a, 0x1883800a, 0x1863800a, 0x1883800a, 0x1883800a } },
 	{ 0xa300,
-		{ 0x18010000, 0x18010000, 0x18010000, 0x18010000, 0x18010000, } },
+		{ 0x18010000, 0x18010000, 0x18010000, 0x18010000, 0x18010000 } },
 	{ 0xa304,
-		{ 0x30032602, 0x30032602, 0x30032602, 0x30032602, 0x30032602, } },
+		{ 0x30032602, 0x30032602, 0x30032602, 0x30032602, 0x30032602 } },
 	{ 0xa308,
-		{ 0x48073e06, 0x48073e06, 0x48073e06, 0x48073e06, 0x48073e06, } },
+		{ 0x48073e06, 0x48073e06, 0x48073e06, 0x48073e06, 0x48073e06 } },
 	{ 0xa30c,
-		{ 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, } },
+		{ 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, 0x560b4c0a } },
 	{ 0xa310,
-		{ 0x641a600f, 0x641a600f, 0x641a600f, 0x641a600f, 0x641a600f, } },
+		{ 0x641a600f, 0x641a600f, 0x641a600f, 0x641a600f, 0x641a600f } },
 	{ 0xa314,
-		{ 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, } },
+		{ 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, 0x784f6e1b } },
 	{ 0xa318,
-		{ 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, } },
+		{ 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, 0x868f7c5a } },
 	{ 0xa31c,
-		{ 0x90cf865b, 0x90cf865b, 0x8ecf865b, 0x8ecf865b, 0x8ecf865b, } },
+		{ 0x90cf865b, 0x90cf865b, 0x8ecf865b, 0x8ecf865b, 0x8ecf865b } },
 	{ 0xa320,
-		{ 0x9d4f970f, 0x9d4f970f, 0x9b4f970f, 0x9b4f970f, 0x9b4f970f, } },
+		{ 0x9d4f970f, 0x9d4f970f, 0x9b4f970f, 0x9b4f970f, 0x9b4f970f } },
 	{ 0xa324,
-		{ 0xa7cfa38f, 0xa7cfa38f, 0xa3cf9f8f, 0xa3cf9f8f, 0xa3cf9f8f, } },
+		{ 0xa7cfa38f, 0xa7cfa38f, 0xa3cf9f8f, 0xa3cf9f8f, 0xa3cf9f8f } },
 	{ 0xa328,
-		{ 0xb55faf1f, 0xb55faf1f, 0xb35faf1f, 0xb35faf1f, 0xb35faf1f, } },
+		{ 0xb55faf1f, 0xb55faf1f, 0xb35faf1f, 0xb35faf1f, 0xb35faf1f } },
 	{ 0xa32c,
-		{ 0xbddfb99f, 0xbddfb99f, 0xbbdfb99f, 0xbbdfb99f, 0xbbdfb99f, } },
+		{ 0xbddfb99f, 0xbddfb99f, 0xbbdfb99f, 0xbbdfb99f, 0xbbdfb99f } },
 	{ 0xa330,
-		{ 0xcb7fc53f, 0xcb7fc53f, 0xcb7fc73f, 0xcb7fc73f, 0xcb7fc73f, } },
+		{ 0xcb7fc53f, 0xcb7fc53f, 0xcb7fc73f, 0xcb7fc73f, 0xcb7fc73f } },
 	{ 0xa334,
-		{ 0xd5ffd1bf, 0xd5ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf, } },
+		{ 0xd5ffd1bf, 0xd5ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf } },
 	{ AR5K_DCU_FP,
-		{ 0x000003e0, 0x000003e0, 0x000003e0, 0x000003e0, 0x000003e0, } },
+		{ 0x000003e0, 0x000003e0, 0x000003e0, 0x000003e0, 0x000003e0 } },
 	{ 0x4068,
-		{ 0x00000010, 0x00000010, 0x00000010, 0x00000010, 0x00000010, } },
+		{ 0x00000010, 0x00000010, 0x00000010, 0x00000010, 0x00000010 } },
 	{ 0x8060,
-		{ 0x0000000f, 0x0000000f, 0x0000000f, 0x0000000f, 0x0000000f, } },
+		{ 0x0000000f, 0x0000000f, 0x0000000f, 0x0000000f, 0x0000000f } },
 	{ 0x809c,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x80a0,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8118,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x811c,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8120,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8124,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8128,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x812c,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8130,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8134,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8138,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x813c,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0x8140,
-		{ 0x800003f9, 0x800003f9, 0x800003f9, 0x800003f9, 0x800003f9, } },
+		{ 0x800003f9, 0x800003f9, 0x800003f9, 0x800003f9, 0x800003f9 } },
 	{ 0x8144,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY_AGC,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
-	{ 0x982c,
-		{ 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, } },
-	{ 0x983c,
-		{ 0x00200400, 0x00200400, 0x00200400, 0x00200400, 0x00200400, } },
-	{ 0x984c,
-		{ 0x1284233c, 0x1284233c, 0x1284233c, 0x1284233c, 0x1284233c, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(11),
+		{ 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000 } },
+	{ AR5K_PHY(15),
+		{ 0x00200400, 0x00200400, 0x00200400, 0x00200400, 0x00200400 } },
+	{ AR5K_PHY(19),
+		{ 0x1284233c, 0x1284233c, 0x1284233c, 0x1284233c, 0x1284233c } },
 	{ AR5K_PHY_SCR,
-		{ 0x0000001f, 0x0000001f, 0x0000001f, 0x0000001f, 0x0000001f, } },
+		{ 0x0000001f, 0x0000001f, 0x0000001f, 0x0000001f, 0x0000001f } },
 	{ AR5K_PHY_SLMT,
-		{ 0x00000080, 0x00000080, 0x00000080, 0x00000080, 0x00000080, } },
+		{ 0x00000080, 0x00000080, 0x00000080, 0x00000080, 0x00000080 } },
 	{ AR5K_PHY_SCAL,
-		{ 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e, } },
-	{ 0x9958,
-		{ 0x00081fff, 0x00081fff, 0x00081fff, 0x00081fff, 0x00081fff, } },
-	{ 0x9980,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
-	{ 0x9984,
-		{ 0x02800000, 0x02800000, 0x02800000, 0x02800000, 0x02800000, } },
-	{ 0x99a0,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
-	{ 0x99e0,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
-	{ 0x99e4,
-		{ 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, } },
-	{ 0x99e8,
-		{ 0x3c466478, 0x3c466478, 0x3c466478, 0x3c466478, 0x3c466478, } },
-	{ 0x99ec,
-		{ 0x000000aa, 0x000000aa, 0x000000aa, 0x000000aa, 0x000000aa, } },
+		{ 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e, 0x0000000e } },
+	{ AR5K_PHY(86),
+		{ 0x00081fff, 0x00081fff, 0x00081fff, 0x00081fff, 0x00081fff } },
+	{ AR5K_PHY(96),
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(97),
+		{ 0x02800000, 0x02800000, 0x02800000, 0x02800000, 0x02800000 } },
+	{ AR5K_PHY(104),
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(120),
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ AR5K_PHY(121),
+		{ 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa } },
+	{ AR5K_PHY(122),
+		{ 0x3c466478, 0x3c466478, 0x3c466478, 0x3c466478, 0x3c466478 } },
+	{ AR5K_PHY(123),
+		{ 0x000000aa, 0x000000aa, 0x000000aa, 0x000000aa, 0x000000aa } },
 	{ AR5K_PHY_SCLOCK,
-		{ 0x0000000c, 0x0000000c, 0x0000000c, 0x0000000c, 0x0000000c, } },
+		{ 0x0000000c, 0x0000000c, 0x0000000c, 0x0000000c, 0x0000000c } },
 	{ AR5K_PHY_SDELAY,
-		{ 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff, } },
+		{ 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff } },
 	{ AR5K_PHY_SPENDING,
-		{ 0x00000014, 0x00000014, 0x00000014, 0x00000014, 0x00000014, } },
+		{ 0x00000014, 0x00000014, 0x00000014, 0x00000014, 0x00000014 } },
 	{ 0xa228,
-		{ 0x000009b5, 0x000009b5, 0x000009b5, 0x000009b5, 0x000009b5, } },
+		{ 0x000009b5, 0x000009b5, 0x000009b5, 0x000009b5, 0x000009b5 } },
 	{ 0xa23c,
-		{ 0x93c889af, 0x93c889af, 0x93c889af, 0x93c889af, 0x93c889af, } },
+		{ 0x93c889af, 0x93c889af, 0x93c889af, 0x93c889af, 0x93c889af } },
 	{ 0xa24c,
-		{ 0x00000001, 0x00000001, 0x00000001, 0x00000001, 0x00000001, } },
+		{ 0x00000001, 0x00000001, 0x00000001, 0x00000001, 0x00000001 } },
 	{ 0xa250,
-		{ 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, } },
+		{ 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000 } },
 	{ 0xa254,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0xa258,
-		{ 0x0cc75380, 0x0cc75380, 0x0cc75380, 0x0cc75380, 0x0cc75380, } },
+		{ 0x0cc75380, 0x0cc75380, 0x0cc75380, 0x0cc75380, 0x0cc75380 } },
 	{ 0xa25c,
-		{ 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, } },
+		{ 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01 } },
 	{ 0xa260,
-		{ 0x5f690f01, 0x5f690f01, 0x5f690f01, 0x5f690f01, 0x5f690f01, } },
+		{ 0x5f690f01, 0x5f690f01, 0x5f690f01, 0x5f690f01, 0x5f690f01 } },
 	{ 0xa264,
-		{ 0x00418a11, 0x00418a11, 0x00418a11, 0x00418a11, 0x00418a11, } },
+		{ 0x00418a11, 0x00418a11, 0x00418a11, 0x00418a11, 0x00418a11 } },
 	{ 0xa268,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0xa26c,
-		{ 0x0c30c16a, 0x0c30c16a, 0x0c30c16a, 0x0c30c16a, 0x0c30c16a, } },
+		{ 0x0c30c16a, 0x0c30c16a, 0x0c30c16a, 0x0c30c16a, 0x0c30c16a } },
 	{ 0xa270,
-		{ 0x00820820, 0x00820820, 0x00820820, 0x00820820, 0x00820820, } },
+		{ 0x00820820, 0x00820820, 0x00820820, 0x00820820, 0x00820820 } },
 	{ 0xa274,
-		{ 0x081b7caa, 0x081b7caa, 0x081b7caa, 0x081b7caa, 0x081b7caa, } },
+		{ 0x081b7caa, 0x081b7caa, 0x081b7caa, 0x081b7caa, 0x081b7caa } },
 	{ 0xa278,
-		{ 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, } },
+		{ 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce } },
 	{ 0xa27c,
-		{ 0x051701ce, 0x051701ce, 0x051701ce, 0x051701ce, 0x051701ce, } },
+		{ 0x051701ce, 0x051701ce, 0x051701ce, 0x051701ce, 0x051701ce } },
 	{ 0xa338,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0xa33c,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0xa340,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0xa344,
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, } },
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ 0xa348,
-		{ 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, } },
+		{ 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff } },
 	{ 0xa34c,
-		{ 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, } },
+		{ 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff } },
 	{ 0xa350,
-		{ 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, } },
+		{ 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff } },
 	{ 0xa354,
-		{ 0x0003ffff, 0x0003ffff, 0x0003ffff, 0x0003ffff, 0x0003ffff, } },
+		{ 0x0003ffff, 0x0003ffff, 0x0003ffff, 0x0003ffff, 0x0003ffff } },
 	{ 0xa358,
-		{ 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, } },
+		{ 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f } },
 	{ 0xa35c,
-		{ 0x066c420f, 0x066c420f, 0x066c420f, 0x066c420f, 0x066c420f, } },
+		{ 0x066c420f, 0x066c420f, 0x066c420f, 0x066c420f, 0x066c420f } },
 	{ 0xa360,
-		{ 0x0f282207, 0x0f282207, 0x0f282207, 0x0f282207, 0x0f282207, } },
+		{ 0x0f282207, 0x0f282207, 0x0f282207, 0x0f282207, 0x0f282207 } },
 	{ 0xa364,
-		{ 0x17601685, 0x17601685, 0x17601685, 0x17601685, 0x17601685, } },
+		{ 0x17601685, 0x17601685, 0x17601685, 0x17601685, 0x17601685 } },
 	{ 0xa368,
-		{ 0x1f801104, 0x1f801104, 0x1f801104, 0x1f801104, 0x1f801104, } },
+		{ 0x1f801104, 0x1f801104, 0x1f801104, 0x1f801104, 0x1f801104 } },
 	{ 0xa36c,
-		{ 0x37a00c03, 0x37a00c03, 0x37a00c03, 0x37a00c03, 0x37a00c03, } },
+		{ 0x37a00c03, 0x37a00c03, 0x37a00c03, 0x37a00c03, 0x37a00c03 } },
 	{ 0xa370,
-		{ 0x3fc40883, 0x3fc40883, 0x3fc40883, 0x3fc40883, 0x3fc40883, } },
+		{ 0x3fc40883, 0x3fc40883, 0x3fc40883, 0x3fc40883, 0x3fc40883 } },
 	{ 0xa374,
-		{ 0x57c00803, 0x57c00803, 0x57c00803, 0x57c00803, 0x57c00803, } },
+		{ 0x57c00803, 0x57c00803, 0x57c00803, 0x57c00803, 0x57c00803 } },
 	{ 0xa378,
-		{ 0x5fd80682, 0x5fd80682, 0x5fd80682, 0x5fd80682, 0x5fd80682, } },
+		{ 0x5fd80682, 0x5fd80682, 0x5fd80682, 0x5fd80682, 0x5fd80682 } },
 	{ 0xa37c,
-		{ 0x7fe00482, 0x7fe00482, 0x7fe00482, 0x7fe00482, 0x7fe00482, } },
+		{ 0x7fe00482, 0x7fe00482, 0x7fe00482, 0x7fe00482, 0x7fe00482 } },
 	{ 0xa380,
-		{ 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, } },
+		{ 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba } },
 	{ 0xa384,
-		{ 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, } },
+		{ 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0 } },
 };
 
 /*
- * Initial BaseBand Gain settings for RF5111/5112 (only AR5210 comes with
- * RF5110 so initial BB Gain settings are included in AR5K_AR5210_INI)
+ * Initial BaseBand Gain settings for RF5111/5112 (AR5210 comes with
+ * RF5110 only so initial BB Gain settings are included in AR5K_AR5210_INI)
  */
 
 /* RF5111 Initial BaseBand Gain settings */
@@ -1152,7 +1154,7 @@ static const struct ath5k_ini rf5111_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(63), 0x00000016 },
 };
 
-/* RF 5112 Initial BaseBand Gain settings */
+/* RF5112 Initial BaseBand Gain settings (Same for RF5413/5414) */
 static const struct ath5k_ini rf5112_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(0), 0x00000000 },
 	{ AR5K_BB_GAIN(1), 0x00000001 },
@@ -1220,6 +1222,7 @@ static const struct ath5k_ini rf5112_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(63), 0x0000001a },
 };
 
+
 /*
  * Write initial register dump
  */
@@ -1268,61 +1271,73 @@ static void ath5k_hw_ini_mode_registers(struct ath5k_hw *ah,
 int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 {
 	/*
-	 * Write initial mode-specific settings
+	 * Write initial register settings
 	 */
-	/*For 5212*/
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_mode_registers(ah, ARRAY_SIZE(ar5212_ini_mode),
-				ar5212_ini_mode, mode);
+
+	/* For AR5212 and combatible */
+	if (ah->ah_version == AR5K_AR5212){
+
+		/* First set of mode-specific settings */
+		ath5k_hw_ini_mode_registers(ah,
+			ARRAY_SIZE(ar5212_ini_mode_start), 
+			ar5212_ini_mode_start, mode);
+
+		/*
+		 * Write initial settings common for all modes
+		 */
+		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5212_ini),
+					ar5212_ini, change_channel);
+
+		/* Second set of mode-specific settings */
 		if (ah->ah_radio == AR5K_RF5111){
 			ath5k_hw_ini_mode_registers(ah,
-					ARRAY_SIZE(ar5212_rf5111_ini_mode),
-					ar5212_rf5111_ini_mode, mode);
+					ARRAY_SIZE(ar5212_rf5111_ini_mode_end),
+					ar5212_rf5111_ini_mode_end, mode);
+			/* Baseband gain table */
+			ath5k_hw_ini_registers(ah,
+					ARRAY_SIZE(rf5111_ini_bbgain),
+					rf5111_ini_bbgain, change_channel);
 		} else if (ah->ah_radio == AR5K_RF5112){
 			ath5k_hw_ini_mode_registers(ah,
-					ARRAY_SIZE(ar5212_rf5112_ini_mode),
-					ar5212_rf5112_ini_mode, mode);
+					ARRAY_SIZE(ar5212_rf5112_ini_mode_end),
+					ar5212_rf5112_ini_mode_end, mode);
+			/* Baseband gain table */
+			ath5k_hw_ini_registers(ah,
+					ARRAY_SIZE(rf5112_ini_bbgain),
+					rf5112_ini_bbgain, change_channel);
 		} else if (ah->ah_radio == AR5K_RF5413){
 			ath5k_hw_ini_mode_registers(ah,
-					ARRAY_SIZE(rf5413_ini_mode),
-					rf5413_ini_mode, mode);
-		}
-	}
-	/*For 5211*/
-	if (ah->ah_version == AR5K_AR5211)
-		ath5k_hw_ini_mode_registers(ah, ARRAY_SIZE(ar5211_ini_mode),
-				ar5211_ini_mode, mode);
-	/* For 5210 mode settings check out ath5k_hw_reset_tx_queue */
-
-	/*
-	 * Write initial settings common for all modes
-	 */
-	/*For 5212*/
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5212_ini),
-				ar5212_ini, change_channel);
-		if (ah->ah_radio >= AR5K_RF5112) {
-			ath5k_hw_reg_write(ah, AR5K_PHY_PAPD_PROBE_INI_5112,
-					AR5K_PHY_PAPD_PROBE);
-			/* Same for RF5413/5414 */
+					ARRAY_SIZE(rf5413_ini_mode_end),
+					rf5413_ini_mode_end, mode);
+			/* Baseband gain table */
 			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
-		} else if (ah->ah_radio == AR5K_RF5111) {
-			ath5k_hw_reg_write(ah, AR5K_PHY_GAIN_2GHZ_INI_5111,
-					AR5K_PHY_GAIN_2GHZ);
-			ath5k_hw_reg_write(ah, AR5K_PHY_PAPD_PROBE_INI_5111,
-					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(ah,
-					ARRAY_SIZE(rf5111_ini_bbgain),
-					rf5111_ini_bbgain, change_channel);
 		}
+	/* For AR5211 */
 	} else if (ah->ah_version == AR5K_AR5211) {
+
+		if(mode > 2){ /* AR5K_INI_VAL_11B */
+			ATH5K_ERR(ah->ah_sc,"unsupported channel mode: %d\n", mode);
+			return -EINVAL;
+		}
+	
+		/* Mode-specific settings */
+		ath5k_hw_ini_mode_registers(ah, ARRAY_SIZE(ar5211_ini_mode),
+				ar5211_ini_mode, mode);
+
+		/*
+		 * Write initial settings common for all modes
+		 */
 		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5211_ini),
 				ar5211_ini, change_channel);
+
 		/* AR5211 only comes with 5111 */
+
+		/* Baseband gain table */
 		ath5k_hw_ini_registers(ah, ARRAY_SIZE(rf5111_ini_bbgain),
 				rf5111_ini_bbgain, change_channel);
+	/* For AR5210 (for mode settings check out ath5k_hw_reset_tx_queue) */
 	} else if (ah->ah_version == AR5K_AR5210) {
 		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5210_ini),
 				ar5210_ini, change_channel);
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 7b75f14..bdd10a7 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1948,7 +1948,11 @@ after DFS is enabled */
 /*
  * PHY PCDAC TX power table
  */
-#define	AR5K_PHY_PCDAC_TXPOWER_BASE	0xa180
+#define	AR5K_PHY_PCDAC_TXPOWER_BASE_5211	0xa180
+#define AR5K_PHY_PCDAC_TXPOWER_BASE_5413	0xa280
+#define AR5K_PHY_PCDAC_TXPOWER_BASE	(ah->ah_radio >= AR5K_RF5413 ? \
+					AR5K_PHY_PCDAC_TXPOWER_BASE_5413 :\
+					AR5K_PHY_PCDAC_TXPOWER_BASE_5211)
 #define	AR5K_PHY_PCDAC_TXPOWER(_n)	(AR5K_PHY_PCDAC_TXPOWER_BASE + ((_n) << 2))
 
 /*



