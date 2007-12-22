Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59154 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXLVUxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 15:53:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix extraction of values from SPROM
Date: Sat, 22 Dec 2007 21:51:30 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712222151.30575.mb@bu3sch.de> (sfid-20071222_205324_499065_84608ECE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes extraction of some values from the SPROM.
It mainly fixes extraction of antenna related values, which
is needed for another b43 fix sent later.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/ssb/pci.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/pci.c	2007-12-14 13:15:42.000000000 +0100
+++ wireless-2.6/drivers/ssb/pci.c	2007-12-20 18:58:49.000000000 +0100
@@ -247,7 +247,7 @@ static void sprom_do_read(struct ssb_bus
 	int i;
 
 	for (i = 0; i < bus->sprom_size; i++)
-		sprom[i] = readw(bus->mmio + SSB_SPROM_BASE + (i * 2));
+		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
 }
 
 static int sprom_do_write(struct ssb_bus *bus, const u16 *sprom)
@@ -297,10 +297,32 @@ err_ctlreg:
 	return err;
 }
 
+static s8 r123_extract_antgain(u8 sprom_revision, const u16 *in,
+			       u16 mask, u16 shift)
+{
+	u16 v;
+	u8 gain;
+
+	v = in[SPOFF(SSB_SPROM1_AGAIN)];
+	gain = (v & mask) >> shift;
+	if (gain == 0xFF)
+		gain = 2; /* If unset use 2dBm */
+	if (sprom_revision == 1) {
+		/* Convert to Q5.2 */
+		gain <<= 2;
+	} else {
+		/* Q5.2 Fractional part is stored in 0xC0 */
+		gain = ((gain & 0xC0) >> 6) | ((gain & 0x3F) << 2);
+	}
+
+	return (s8)gain;
+}
+
 static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 {
 	int i;
 	u16 v;
+	s8 gain;
 	u16 loc[3];
 
 	if (out->revision == 3) {			/* rev 3 moved MAC */
@@ -327,8 +349,15 @@ static void sprom_extract_r123(struct ss
 	SPEX(et0phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1A,
 	     SSB_SPROM1_ETHPHY_ET1A_SHIFT);
+	SPEX(et0mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0M, 14);
+	SPEX(et1mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1M, 15);
+	SPEX(board_rev, SSB_SPROM1_BINF, SSB_SPROM1_BINF_BREV, 0);
 	SPEX(country_code, SSB_SPROM1_BINF, SSB_SPROM1_BINF_CCODE,
 	     SSB_SPROM1_BINF_CCODE_SHIFT);
+	SPEX(ant_available_a, SSB_SPROM1_BINF, SSB_SPROM1_BINF_ANTA,
+	     SSB_SPROM1_BINF_ANTA_SHIFT);
+	SPEX(ant_available_bg, SSB_SPROM1_BINF, SSB_SPROM1_BINF_ANTBG,
+	     SSB_SPROM1_BINF_ANTBG_SHIFT);
 	SPEX(pa0b0, SSB_SPROM1_PA0B0, 0xFFFF, 0);
 	SPEX(pa0b1, SSB_SPROM1_PA0B1, 0xFFFF, 0);
 	SPEX(pa0b2, SSB_SPROM1_PA0B2, 0xFFFF, 0);
@@ -348,9 +377,22 @@ static void sprom_extract_r123(struct ss
 	     SSB_SPROM1_ITSSI_A_SHIFT);
 	SPEX(itssi_bg, SSB_SPROM1_ITSSI, SSB_SPROM1_ITSSI_BG, 0);
 	SPEX(boardflags_lo, SSB_SPROM1_BFLLO, 0xFFFF, 0);
-	SPEX(antenna_gain_a, SSB_SPROM1_AGAIN, SSB_SPROM1_AGAIN_A, 0);
-	SPEX(antenna_gain_bg, SSB_SPROM1_AGAIN, SSB_SPROM1_AGAIN_BG,
-	     SSB_SPROM1_AGAIN_BG_SHIFT);
+
+	/* Extract the antenna gain values. */
+	gain = r123_extract_antgain(out->revision, in,
+				    SSB_SPROM1_AGAIN_BG,
+				    SSB_SPROM1_AGAIN_BG_SHIFT);
+	out->antenna_gain.ghz24.a0 = gain;
+	out->antenna_gain.ghz24.a1 = gain;
+	out->antenna_gain.ghz24.a2 = gain;
+	out->antenna_gain.ghz24.a3 = gain;
+	gain = r123_extract_antgain(out->revision, in,
+				    SSB_SPROM1_AGAIN_A,
+				    SSB_SPROM1_AGAIN_A_SHIFT);
+	out->antenna_gain.ghz5.a0 = gain;
+	out->antenna_gain.ghz5.a1 = gain;
+	out->antenna_gain.ghz5.a2 = gain;
+	out->antenna_gain.ghz5.a3 = gain;
 }
 
 static void sprom_extract_r4(struct ssb_sprom *out, const u16 *in)
@@ -376,9 +418,10 @@ static void sprom_extract_r4(struct ssb_
 	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
 	SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
 	SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
-	SPEX(antenna_gain_a, SSB_SPROM4_AGAIN, SSB_SPROM4_AGAIN_0, 0);
-	SPEX(antenna_gain_bg, SSB_SPROM4_AGAIN, SSB_SPROM4_AGAIN_1,
-	     SSB_SPROM4_AGAIN_1_SHIFT);
+	SPEX(ant_available_a, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_A,
+	     SSB_SPROM4_ANTAVAIL_A_SHIFT);
+	SPEX(ant_available_bg, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_BG,
+	     SSB_SPROM4_ANTAVAIL_BG_SHIFT);
 	SPEX(maxpwr_bg, SSB_SPROM4_MAXP_BG, SSB_SPROM4_MAXP_BG_MASK, 0);
 	SPEX(itssi_bg, SSB_SPROM4_MAXP_BG, SSB_SPROM4_ITSSI_BG,
 	     SSB_SPROM4_ITSSI_BG_SHIFT);
@@ -391,6 +434,19 @@ static void sprom_extract_r4(struct ssb_
 	SPEX(gpio2, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P2, 0);
 	SPEX(gpio3, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P3,
 	     SSB_SPROM4_GPIOB_P3_SHIFT);
+
+	/* Extract the antenna gain values. */
+	SPEX(antenna_gain.ghz24.a0, SSB_SPROM4_AGAIN01,
+	     SSB_SPROM4_AGAIN0, SSB_SPROM4_AGAIN0_SHIFT);
+	SPEX(antenna_gain.ghz24.a1, SSB_SPROM4_AGAIN01,
+	     SSB_SPROM4_AGAIN1, SSB_SPROM4_AGAIN1_SHIFT);
+	SPEX(antenna_gain.ghz24.a2, SSB_SPROM4_AGAIN23,
+	     SSB_SPROM4_AGAIN2, SSB_SPROM4_AGAIN2_SHIFT);
+	SPEX(antenna_gain.ghz24.a3, SSB_SPROM4_AGAIN23,
+	     SSB_SPROM4_AGAIN3, SSB_SPROM4_AGAIN3_SHIFT);
+	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
+	       sizeof(out->antenna_gain.ghz5));
+
 	/* TODO - get remaining rev 4 stuff needed */
 }
 
@@ -400,7 +456,7 @@ static int sprom_extract(struct ssb_bus 
 	memset(out, 0, sizeof(*out));
 
 	out->revision = in[size - 1] & 0x00FF;
-	ssb_printk(KERN_INFO PFX "SPROM revision %d detected.\n", out->revision);
+	ssb_dprintk(KERN_DEBUG PFX "SPROM revision %d detected.\n", out->revision);
 	if ((bus->chip_id & 0xFF00) == 0x4400) {
 		/* Workaround: The BCM44XX chip has a stupid revision
 		 * number stored in the SPROM.
@@ -445,9 +501,7 @@ static int ssb_pci_sprom_get(struct ssb_
 	err = sprom_check_crc(buf, bus->sprom_size);
 	if (err) {
 		/* check for rev 4 sprom - has special signature */
-		if (buf [32] == 0x5372) {
-			ssb_printk(KERN_WARNING PFX "Extracting a rev 4"
-				   " SPROM\n");
+		if (buf[32] == 0x5372) {
 			kfree(buf);
 			buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
 				      GFP_KERNEL);
Index: wireless-2.6/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb_regs.h	2007-12-14 13:15:42.000000000 +0100
+++ wireless-2.6/include/linux/ssb/ssb_regs.h	2007-12-20 18:58:49.000000000 +0100
@@ -193,10 +193,10 @@
 #define  SSB_SPROM1_BINF_BREV		0x00FF	/* Board Revision */
 #define  SSB_SPROM1_BINF_CCODE		0x0F00	/* Country Code */
 #define  SSB_SPROM1_BINF_CCODE_SHIFT	8
-#define  SSB_SPROM1_BINF_ANTA		0x3000	/* Available A-PHY antennas */
-#define  SSB_SPROM1_BINF_ANTA_SHIFT	12
-#define  SSB_SPROM1_BINF_ANTBG		0xC000	/* Available B-PHY antennas */
-#define  SSB_SPROM1_BINF_ANTBG_SHIFT	14
+#define  SSB_SPROM1_BINF_ANTBG		0x3000	/* Available B-PHY and G-PHY antennas */
+#define  SSB_SPROM1_BINF_ANTBG_SHIFT	12
+#define  SSB_SPROM1_BINF_ANTA		0xC000	/* Available A-PHY antennas */
+#define  SSB_SPROM1_BINF_ANTA_SHIFT	14
 #define SSB_SPROM1_PA0B0		0x105E
 #define SSB_SPROM1_PA0B1		0x1060
 #define SSB_SPROM1_PA0B2		0x1062
@@ -221,9 +221,10 @@
 #define  SSB_SPROM1_ITSSI_A_SHIFT	8
 #define SSB_SPROM1_BFLLO		0x1072	/* Boardflags (low 16 bits) */
 #define SSB_SPROM1_AGAIN		0x1074	/* Antenna Gain (in dBm Q5.2) */
-#define  SSB_SPROM1_AGAIN_A		0x00FF	/* A-PHY */
-#define  SSB_SPROM1_AGAIN_BG		0xFF00	/* B-PHY and G-PHY */
-#define  SSB_SPROM1_AGAIN_BG_SHIFT	8
+#define  SSB_SPROM1_AGAIN_BG		0x00FF	/* B-PHY and G-PHY */
+#define  SSB_SPROM1_AGAIN_BG_SHIFT	0
+#define  SSB_SPROM1_AGAIN_A		0xFF00	/* A-PHY */
+#define  SSB_SPROM1_AGAIN_A_SHIFT	8
 
 /* SPROM Revision 2 (inherits from rev 1) */
 #define SSB_SPROM2_BFLHI		0x1038	/* Boardflags (high 16 bits) */
@@ -264,7 +265,7 @@
 #define  SSB_SPROM3_CCKPO_11M_SHIFT	12
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 
-/* SPROM Revision 4 		entries with ?? in comment are unknown */
+/* SPROM Revision 4 */
 #define SSB_SPROM4_IL0MAC		0x104C	/* 6 byte MAC address for a/b/g/n */
 #define SSB_SPROM4_ET0MAC		0x1018	/* 6 bytes MAC address for Ethernet ?? */
 #define SSB_SPROM4_ET1MAC		0x1018	/* 6 bytes MAC address for 802.11a ?? */
@@ -275,13 +276,22 @@
 #define  SSB_SPROM4_ETHPHY_ET0M		(1<<14)	/* MDIO for enet0 */
 #define  SSB_SPROM4_ETHPHY_ET1M		(1<<15)	/* MDIO for enet1 */
 #define SSB_SPROM4_CCODE		0x1052	/* Country Code (2 bytes) */
-#define SSB_SPROM4_ANT_A		0x105D  /* A Antennas */
-#define SSB_SPROM4_ANT_BG		0x105C  /* B/G Antennas */
+#define SSB_SPROM4_ANTAVAIL		0x105D  /* Antenna available bitfields */
+#define SSB_SPROM4_ANTAVAIL_A		0x00FF	/* A-PHY bitfield */
+#define SSB_SPROM4_ANTAVAIL_A_SHIFT	0
+#define SSB_SPROM4_ANTAVAIL_BG		0xFF00	/* B-PHY and G-PHY bitfield */
+#define SSB_SPROM4_ANTAVAIL_BG_SHIFT	8
 #define SSB_SPROM4_BFLLO		0x1044	/* Boardflags (low 16 bits) */
-#define SSB_SPROM4_AGAIN		0x105E	/* Antenna Gain (in dBm Q5.2) */
-#define  SSB_SPROM4_AGAIN_0		0x00FF	/* Antenna 0 */
-#define  SSB_SPROM4_AGAIN_1		0xFF00	/* Antenna 1 */
-#define  SSB_SPROM4_AGAIN_1_SHIFT	8
+#define SSB_SPROM4_AGAIN01		0x105E	/* Antenna Gain (in dBm Q5.2) */
+#define  SSB_SPROM4_AGAIN0		0x00FF	/* Antenna 0 */
+#define  SSB_SPROM4_AGAIN0_SHIFT	0
+#define  SSB_SPROM4_AGAIN1		0xFF00	/* Antenna 1 */
+#define  SSB_SPROM4_AGAIN1_SHIFT	8
+#define SSB_SPROM4_AGAIN23		0x1060
+#define  SSB_SPROM4_AGAIN2		0x00FF	/* Antenna 2 */
+#define  SSB_SPROM4_AGAIN2_SHIFT	0
+#define  SSB_SPROM4_AGAIN3		0xFF00	/* Antenna 3 */
+#define  SSB_SPROM4_AGAIN3_SHIFT	8
 #define SSB_SPROM4_BFLHI		0x1046  /* Board Flags Hi */
 #define SSB_SPROM4_MAXP_BG		0x1080  /* Max Power BG in path 1 */
 #define  SSB_SPROM4_MAXP_BG_MASK	0x00FF  /* Mask for Max Power BG */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-20 18:53:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-20 18:58:49.000000000 +0100
@@ -3885,16 +3885,6 @@ static void b43_sprom_fixup(struct ssb_b
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
 		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
-
-	/* Handle case when gain is not set in sprom */
-	if (bus->sprom.antenna_gain_a == 0xFF)
-		bus->sprom.antenna_gain_a = 2;
-	if (bus->sprom.antenna_gain_bg == 0xFF)
-		bus->sprom.antenna_gain_bg = 2;
-
-	/* Convert Antennagain values to Q5.2 */
-	bus->sprom.antenna_gain_a <<= 2;
-	bus->sprom.antenna_gain_bg <<= 2;
 }
 
 static void b43_wireless_exit(struct ssb_device *dev, struct b43_wl *wl)
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c	2007-12-20 18:53:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c	2007-12-20 18:58:49.000000000 +0100
@@ -3573,11 +3573,6 @@ static void b43legacy_sprom_fixup(struct
 	    bus->boardinfo.type == 0x4E &&
 	    bus->boardinfo.rev > 0x40)
 		bus->sprom.boardflags_lo |= B43legacy_BFL_PACTRL;
-
-	/* Convert Antennagain values to Q5.2 */
-	if (bus->sprom.antenna_gain_bg == 0xFF)
-		bus->sprom.antenna_gain_bg = 2; /* if unset, use 2 dBm */
-	bus->sprom.antenna_gain_bg <<= 2;
 }
 
 static void b43legacy_wireless_exit(struct ssb_device *dev,
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.c	2007-12-14 13:15:42.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.c	2007-12-20 18:58:49.000000000 +0100
@@ -1859,7 +1859,7 @@ void b43legacy_phy_xmitpower(struct b43l
 	 * which accounts for the factor of 4 */
 #define REG_MAX_PWR 20
 	max_pwr = min(REG_MAX_PWR * 4
-		      - dev->dev->bus->sprom.antenna_gain_bg
+		      - dev->dev->bus->sprom.antenna_gain.ghz24.a0
 		      - 0x6, max_pwr);
 
 	/* find the desired power in Q5.2 - power_level is in dBm
Index: wireless-2.6/include/linux/ssb/ssb.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb.h	2007-12-14 13:15:42.000000000 +0100
+++ wireless-2.6/include/linux/ssb/ssb.h	2007-12-20 18:58:49.000000000 +0100
@@ -22,7 +22,12 @@ struct ssb_sprom {
 	u8 et1mac[6];		/* MAC address for 802.11a */
 	u8 et0phyaddr;		/* MII address for enet0 */
 	u8 et1phyaddr;		/* MII address for enet1 */
+	u8 et0mdcport;		/* MDIO for enet0 */
+	u8 et1mdcport;		/* MDIO for enet1 */
+	u8 board_rev;		/* Board revision number from SPROM. */
 	u8 country_code;	/* Country Code */
+	u8 ant_available_a;	/* A-PHY antenna available bits (up to 4) */
+	u8 ant_available_bg;	/* B/G-PHY antenna available bits (up to 4) */
 	u16 pa0b0;
 	u16 pa0b1;
 	u16 pa0b2;
@@ -38,8 +43,18 @@ struct ssb_sprom {
 	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
 	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
 	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
-	u8 antenna_gain_a;	/* A-PHY Antenna gain (in dBm Q5.2) */
-	u8 antenna_gain_bg;	/* B/G-PHY Antenna gain (in dBm Q5.2) */
+
+	/* Antenna gain values for up to 4 antennas
+	 * on each band. Values in dBm/4 (Q5.2). Negative gain means the
+	 * loss in the connectors is bigger than the gain. */
+	struct {
+		struct {
+			s8 a0, a1, a2, a3;
+		} ghz24;	/* 2.4GHz band */
+		struct {
+			s8 a0, a1, a2, a3;
+		} ghz5;		/* 5GHz band */
+	} antenna_gain;
 
 	/* TODO - add any parameters needed from rev 2, 3, or 4 SPROMs */
 };
