Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYHSRud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 13:50:33 -0400
Date: Tue, 19 Aug 2008 12:50:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Update for Rev. 5 SPROM
Message-ID: <48ab07e7.X4EO+1uHeB9cIHfj%Larry.Finger@lwfinger.net> (sfid-20080819_195037_887618_E7CD1B8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although a revision 5 SPROM has not been seen in the wild, the
open-source portion of the MIPS driver 4.150.10.5 describes its
layout, which is mostly inherited from revision 4. This patch
implements the differences.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28 material. As we have not yet seen a rev 5 SPROM,
this material has only been compile tested, but it should be
put into the kernel before the stuff for rev 8 that will be
needed for the LP PHY.

Larry
---

Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -399,14 +399,19 @@ static void sprom_extract_r123(struct ss
 	out->antenna_gain.ghz5.a3 = gain;
 }
 
-static void sprom_extract_r4(struct ssb_sprom *out, const u16 *in)
+static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
 {
 	int i;
 	u16 v;
+	u16 il0mac_offset;
 
+	if (out->revision == 4)
+		il0mac_offset = SSB_SPROM4_IL0MAC;
+	else
+		il0mac_offset = SSB_SPROM5_IL0MAC;
 	/* extract the equivalent of the r1 variables */
 	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM4_IL0MAC) + i];
+		v = in[SPOFF(il0mac_offset) + i];
 		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
 	for (i = 0; i < 3; i++) {
@@ -420,9 +425,15 @@ static void sprom_extract_r4(struct ssb_
 	SPEX(et0phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
 	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
-	SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
-	SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
-	SPEX(boardflags_hi, SSB_SPROM4_BFLHI, 0xFFFF, 0);
+	if (out->revision == 4) {
+		SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
+		SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
+		SPEX(boardflags_hi, SSB_SPROM4_BFLHI, 0xFFFF, 0);
+	} else {
+		SPEX(country_code, SSB_SPROM5_CCODE, 0xFFFF, 0);
+		SPEX(boardflags_lo, SSB_SPROM5_BFLLO, 0xFFFF, 0);
+		SPEX(boardflags_hi, SSB_SPROM5_BFLHI, 0xFFFF, 0);
+	}
 	SPEX(ant_available_a, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_A,
 	     SSB_SPROM4_ANTAVAIL_A_SHIFT);
 	SPEX(ant_available_bg, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_BG,
@@ -433,12 +444,21 @@ static void sprom_extract_r4(struct ssb_
 	SPEX(maxpwr_a, SSB_SPROM4_MAXP_A, SSB_SPROM4_MAXP_A_MASK, 0);
 	SPEX(itssi_a, SSB_SPROM4_MAXP_A, SSB_SPROM4_ITSSI_A,
 	     SSB_SPROM4_ITSSI_A_SHIFT);
-	SPEX(gpio0, SSB_SPROM4_GPIOA, SSB_SPROM4_GPIOA_P0, 0);
-	SPEX(gpio1, SSB_SPROM4_GPIOA, SSB_SPROM4_GPIOA_P1,
-	     SSB_SPROM4_GPIOA_P1_SHIFT);
-	SPEX(gpio2, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P2, 0);
-	SPEX(gpio3, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P3,
-	     SSB_SPROM4_GPIOB_P3_SHIFT);
+	if (out->revision == 4) {
+		SPEX(gpio0, SSB_SPROM4_GPIOA, SSB_SPROM4_GPIOA_P0, 0);
+		SPEX(gpio1, SSB_SPROM4_GPIOA, SSB_SPROM4_GPIOA_P1,
+		     SSB_SPROM4_GPIOA_P1_SHIFT);
+		SPEX(gpio2, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P2, 0);
+		SPEX(gpio3, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P3,
+		     SSB_SPROM4_GPIOB_P3_SHIFT);
+	} else {
+		SPEX(gpio0, SSB_SPROM5_GPIOA, SSB_SPROM5_GPIOA_P0, 0);
+		SPEX(gpio1, SSB_SPROM5_GPIOA, SSB_SPROM5_GPIOA_P1,
+		     SSB_SPROM5_GPIOA_P1_SHIFT);
+		SPEX(gpio2, SSB_SPROM5_GPIOB, SSB_SPROM5_GPIOB_P2, 0);
+		SPEX(gpio3, SSB_SPROM5_GPIOB, SSB_SPROM5_GPIOB_P3,
+		     SSB_SPROM5_GPIOB_P3_SHIFT);
+	}
 
 	/* Extract the antenna gain values. */
 	SPEX(antenna_gain.ghz24.a0, SSB_SPROM4_AGAIN01,
@@ -471,16 +491,16 @@ static int sprom_extract(struct ssb_bus
 	} else if (bus->chip_id == 0x4321) {
 		/* the BCM4328 has a chipid == 0x4321 and a rev 4 SPROM */
 		out->revision = 4;
-		sprom_extract_r4(out, in);
+		sprom_extract_r45(out, in);
 	} else {
 		if (out->revision == 0)
 			goto unsupported;
 		if (out->revision >= 1 && out->revision <= 3) {
 			sprom_extract_r123(out, in);
 		}
-		if (out->revision == 4)
-			sprom_extract_r4(out, in);
-		if (out->revision >= 5)
+		if (out->revision == 4 || out->revision == 5)
+			sprom_extract_r45(out, in);
+		if (out->revision > 5)
 			goto unsupported;
 	}
 
Index: wireless-testing/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_regs.h
+++ wireless-testing/include/linux/ssb/ssb_regs.h
@@ -316,6 +316,21 @@
 #define SSB_SPROM4_PA1B1		0x1090
 #define SSB_SPROM4_PA1B2		0x1092
 
+/* SPROM Revision 5 (inherits most data from rev 4) */
+#define SSB_SPROM5_BFLLO		0x104A	/* Boardflags (low 16 bits) */
+#define SSB_SPROM5_BFLHI		0x104C  /* Board Flags Hi */
+#define SSB_SPROM5_IL0MAC		0x1052	/* 6 byte MAC address for a/b/g/n */
+#define SSB_SPROM5_CCODE		0x1044	/* Country Code (2 bytes) */
+#define SSB_SPROM5_GPIOA		0x1076	/* Gen. Purpose IO # 0 and 1 */
+#define  SSB_SPROM5_GPIOA_P0		0x00FF	/* Pin 0 */
+#define  SSB_SPROM5_GPIOA_P1		0xFF00	/* Pin 1 */
+#define  SSB_SPROM5_GPIOA_P1_SHIFT	8
+#define SSB_SPROM5_GPIOB		0x1078	/* Gen. Purpose IO # 2 and 3 */
+#define  SSB_SPROM5_GPIOB_P2		0x00FF	/* Pin 2 */
+#define  SSB_SPROM5_GPIOB_P3		0xFF00	/* Pin 3 */
+#define  SSB_SPROM5_GPIOB_P3_SHIFT	8
+
+
 /* Values for SSB_SPROM1_BINF_CCODE */
 enum {
 	SSB_SPROM1CCODE_WORLD = 0,
