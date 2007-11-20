Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbXKTDJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 22:09:30 -0500
Date: Mon, 19 Nov 2007 21:06:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: icare40@hotmail.com, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [RFT] b43: patches to use 2.6.24-rc2 with BCM4311 rev 02
Message-ID: <47424f45.akrBdcMbF2XGmahx%Larry.Finger@lwfinger.net> (sfid-20071120_030938_104863_599C951F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch modifies the code in kernel 2.6.24-rc2 to implement the BCM94311MCG
rev 02.

This patch will apply to kernel 2.6.24-rc3; however, I am getting fatal DMA
errors. At the moment, it is not clear why. There is a single patch that "fixes"
b43 when it is reverted; however, it is clearly not the problem - it just exposes
whatever is the real cause. The problem may be a bug in the driver, a hardware
problem on my machine, or even a firmware bug. If others could verify that this
patch works on -rc2, and that it fails on -rc3, it would help isolate the problem.

This patch has extra debugging output that will not be in the final version.

Larry Finger

==================================================================

Index: linux-2.6/include/linux/ssb/ssb.h
===================================================================
--- linux-2.6.orig/include/linux/ssb/ssb.h
+++ linux-2.6/include/linux/ssb/ssb.h
@@ -15,22 +15,14 @@ struct pcmcia_device;
 struct ssb_bus;
 struct ssb_driver;
 
-
-struct ssb_sprom_r1 {
-	u16 pci_spid;		/* Subsystem Product ID for PCI */
-	u16 pci_svid;		/* Subsystem Vendor ID for PCI */
-	u16 pci_pid;		/* Product ID for PCI */
+struct ssb_sprom {
+	u8 revision;
 	u8 il0mac[6];		/* MAC address for 802.11b/g */
 	u8 et0mac[6];		/* MAC address for Ethernet */
 	u8 et1mac[6];		/* MAC address for 802.11a */
-	u8 et0phyaddr:5;	/* MII address for enet0 */
-	u8 et1phyaddr:5;	/* MII address for enet1 */
-	u8 et0mdcport:1;	/* MDIO for enet0 */
-	u8 et1mdcport:1;	/* MDIO for enet1 */
-	u8 board_rev;		/* Board revision */
-	u8 country_code:4;	/* Country Code */
-	u8 antenna_a:2;		/* Antenna 0/1 available for A-PHY */
-	u8 antenna_bg:2;	/* Antenna 0/1 available for B-PHY and G-PHY */
+	u8 et0phyaddr;		/* MII address for enet0 */
+	u8 et1phyaddr;		/* MII address for enet1 */
+	u8 country_code;	/* Country Code */
 	u16 pa0b0;
 	u16 pa0b1;
 	u16 pa0b2;
@@ -41,61 +33,15 @@ struct ssb_sprom_r1 {
 	u8 gpio1;		/* GPIO pin 1 */
 	u8 gpio2;		/* GPIO pin 2 */
 	u8 gpio3;		/* GPIO pin 3 */
-	u16 maxpwr_a;		/* A-PHY Power Amplifier Max Power (in dBm Q5.2) */
-	u16 maxpwr_bg;		/* B/G-PHY Power Amplifier Max Power (in dBm Q5.2) */
+	u16 maxpwr_a;		/* A-PHY Amplifier Max Power (in dBm Q5.2) */
+	u16 maxpwr_bg;		/* B/G-PHY Amplifier Max Power (in dBm Q5.2) */
 	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
 	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
 	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
 	u8 antenna_gain_a;	/* A-PHY Antenna gain (in dBm Q5.2) */
 	u8 antenna_gain_bg;	/* B/G-PHY Antenna gain (in dBm Q5.2) */
-	u8 oem[8];		/* OEM string (rev 1 only) */
-};
-
-struct ssb_sprom_r2 {
-	u16 boardflags_hi;	/* Boardflags (high 16 bits) */
-	u8 maxpwr_a_lo;		/* A-PHY Max Power Low */
-	u8 maxpwr_a_hi;		/* A-PHY Max Power High */
-	u16 pa1lob0;		/* A-PHY PA Low Settings */
-	u16 pa1lob1;		/* A-PHY PA Low Settings */
-	u16 pa1lob2;		/* A-PHY PA Low Settings */
-	u16 pa1hib0;		/* A-PHY PA High Settings */
-	u16 pa1hib1;		/* A-PHY PA High Settings */
-	u16 pa1hib2;		/* A-PHY PA High Settings */
-	u8 ofdm_pwr_off;	/* OFDM Power Offset from CCK Level */
-	u8 country_str[2];	/* Two char Country Code */
-};
 
-struct ssb_sprom_r3 {
-	u32 ofdmapo;		/* A-PHY OFDM Mid Power Offset */
-	u32 ofdmalpo;		/* A-PHY OFDM Low Power Offset */
-	u32 ofdmahpo;		/* A-PHY OFDM High Power Offset */
-	u8 gpioldc_on_cnt;	/* GPIO LED Powersave Duty Cycle ON count */
-	u8 gpioldc_off_cnt;	/* GPIO LED Powersave Duty Cycle OFF count */
-	u8 cckpo_1M:4;		/* CCK Power Offset for Rate 1M */
-	u8 cckpo_2M:4;		/* CCK Power Offset for Rate 2M */
-	u8 cckpo_55M:4;		/* CCK Power Offset for Rate 5.5M */
-	u8 cckpo_11M:4;		/* CCK Power Offset for Rate 11M */
-	u32 ofdmgpo;		/* G-PHY OFDM Power Offset */
-};
-
-struct ssb_sprom_r4 {
-	/* TODO */
-};
-
-struct ssb_sprom {
-	u8 revision;
-	u8 crc;
-	/* The valid r# fields are selected by the "revision".
-	 * Revision 3 and lower inherit from lower revisions.
-	 */
-	union {
-		struct {
-			struct ssb_sprom_r1 r1;
-			struct ssb_sprom_r2 r2;
-			struct ssb_sprom_r3 r3;
-		};
-		struct ssb_sprom_r4 r4;
-	};
+	/* TODO - add any parameters needed from rev 2, 3, or 4 SPROMs */
 };
 
 /* Information about the PCB the circuitry is soldered on. */
@@ -288,6 +234,7 @@ struct ssb_bus {
 	/* ID information about the Chip. */
 	u16 chip_id;
 	u16 chip_rev;
+	u16 sprom_size;		/* number of words in sprom */
 	u8 chip_package;
 
 	/* List of devices (cores) on the backplane. */
Index: linux-2.6/include/linux/ssb/ssb_regs.h
===================================================================
--- linux-2.6.orig/include/linux/ssb/ssb_regs.h
+++ linux-2.6/include/linux/ssb/ssb_regs.h
@@ -147,6 +147,10 @@
 #define  SSB_IDLOW_SSBREV	0xF0000000 /* Sonics Backplane Revision code */
 #define  SSB_IDLOW_SSBREV_22	0x00000000 /* <= 2.2 */
 #define  SSB_IDLOW_SSBREV_23	0x10000000 /* 2.3 */
+#define  SSB_IDLOW_SSBREV_24	0x40000000 /* ?? Found in BCM4328 */
+#define  SSB_IDLOW_SSBREV_25	0x50000000 /* ?? Not Found yet */
+#define  SSB_IDLOW_SSBREV_26	0x60000000 /* ?? Found in some BCM4311/2 */
+#define  SSB_IDLOW_SSBREV_27	0x70000000 /* ?? Found in some BCM4311/2 */
 #define SSB_IDHIGH		0x0FFC     /* SB Identification High */
 #define  SSB_IDHIGH_RCLO	0x0000000F /* Revision Code (low part) */
 #define  SSB_IDHIGH_CC		0x00008FF0 /* Core Code */
@@ -162,11 +166,16 @@
  */
 #define SSB_SPROMSIZE_WORDS		64
 #define SSB_SPROMSIZE_BYTES		(SSB_SPROMSIZE_WORDS * sizeof(u16))
+#define SSB_SPROMSIZE_WORDS_R123	64
+#define SSB_SPROMSIZE_WORDS_R4		220
+#define SSB_SPROMSIZE_BYTES_R123	(SSB_SPROMSIZE_WORDS_R123 * sizeof(u16))
+#define SSB_SPROMSIZE_BYTES_R4		(SSB_SPROMSIZE_WORDS_R4 * sizeof(u16))
 #define SSB_SPROM_BASE			0x1000
 #define SSB_SPROM_REVISION		0x107E
 #define  SSB_SPROM_REVISION_REV		0x00FF	/* SPROM Revision number */
 #define  SSB_SPROM_REVISION_CRC		0xFF00	/* SPROM CRC8 value */
 #define  SSB_SPROM_REVISION_CRC_SHIFT	8
+
 /* SPROM Revision 1 */
 #define SSB_SPROM1_SPID			0x1004	/* Subsystem Product ID for PCI */
 #define SSB_SPROM1_SVID			0x1006	/* Subsystem Vendor ID for PCI */
@@ -215,7 +224,7 @@
 #define  SSB_SPROM1_AGAIN_A		0x00FF	/* A-PHY */
 #define  SSB_SPROM1_AGAIN_BG		0xFF00	/* B-PHY and G-PHY */
 #define  SSB_SPROM1_AGAIN_BG_SHIFT	8
-#define SSB_SPROM1_OEM			0x1076	/* 8 bytes OEM string (rev 1 only) */
+
 /* SPROM Revision 2 (inherits from rev 1) */
 #define SSB_SPROM2_BFLHI		0x1038	/* Boardflags (high 16 bits) */
 #define SSB_SPROM2_MAXP_A		0x103A	/* A-PHY Max Power */
@@ -232,7 +241,11 @@
 #define  SSB_SPROM2_OPO_VALUE		0x00FF
 #define  SSB_SPROM2_OPO_UNUSED		0xFF00
 #define SSB_SPROM2_CCODE		0x107C	/* Two char Country Code */
-/* SPROM Revision 3 (inherits from rev 2) */
+
+/* SPROM Revision 3 (inherits most data from rev 2) */
+#define SSB_SPROM3_IL0MAC		0x104A	/* 6 bytes MAC address for 802.11b/g */
+#define SSB_SPROM3_ET0MAC		0x1050	/* 6 bytes MAC address for Ethernet ?? */
+#define SSB_SPROM3_ET1MAC		0x1050	/* 6 bytes MAC address for 802.11a ?? */
 #define SSB_SPROM3_OFDMAPO		0x102C	/* A-PHY OFDM Mid Power Offset (4 bytes, BigEndian) */
 #define SSB_SPROM3_OFDMALPO		0x1030	/* A-PHY OFDM Low Power Offset (4 bytes, BigEndian) */
 #define SSB_SPROM3_OFDMAHPO		0x1034	/* A-PHY OFDM High Power Offset (4 bytes, BigEndian) */
@@ -251,6 +264,48 @@
 #define  SSB_SPROM3_CCKPO_11M_SHIFT	12
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 
+/* SPROM Revision 4 		entries with ?? in comment are unknown */
+#define SSB_SPROM4_IL0MAC		0x104C	/* 6 byte MAC address for a/b/g/n */
+#define SSB_SPROM4_ET0MAC		0x1018	/* 6 bytes MAC address for Ethernet ?? */
+#define SSB_SPROM4_ET1MAC		0x1018	/* 6 bytes MAC address for 802.11a ?? */
+#define SSB_SPROM4_ETHPHY		0x105A	/* Ethernet PHY settings ?? */
+#define  SSB_SPROM4_ETHPHY_ET0A		0x001F	/* MII Address for enet0 */
+#define  SSB_SPROM4_ETHPHY_ET1A		0x03E0	/* MII Address for enet1 */
+#define  SSB_SPROM4_ETHPHY_ET1A_SHIFT	5
+#define  SSB_SPROM4_ETHPHY_ET0M		(1<<14)	/* MDIO for enet0 */
+#define  SSB_SPROM4_ETHPHY_ET1M		(1<<15)	/* MDIO for enet1 */
+#define SSB_SPROM4_CCODE		0x1052	/* Country Code (2 bytes) */
+#define SSB_SPROM4_ANT_A		0x105D  /* A Antennas */
+#define SSB_SPROM4_ANT_BG		0x105C  /* B/G Antennas */
+#define SSB_SPROM4_BFLLO		0x1044	/* Boardflags (low 16 bits) */
+#define SSB_SPROM4_AGAIN		0x105E	/* Antenna Gain (in dBm Q5.2) */
+#define  SSB_SPROM4_AGAIN_0		0x00FF	/* Antenna 0 */
+#define  SSB_SPROM4_AGAIN_1		0xFF00	/* Antenna 1 */
+#define  SSB_SPROM4_AGAIN_1_SHIFT	8
+#define SSB_SPROM4_BFLHI		0x1046  /* Board Flags Hi */
+#define SSB_SPROM4_MAXP_BG		0x1080  /* Max Power BG in path 1 */
+#define  SSB_SPROM4_MAXP_BG_MASK	0x00FF  /* Mask for Max Power BG */
+#define  SSB_SPROM4_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */
+#define  SSB_SPROM4_ITSSI_BG_SHIFT	8
+#define SSB_SPROM4_MAXP_A		0x108A  /* Max Power A in path 1 */
+#define  SSB_SPROM4_MAXP_A_MASK		0x00FF  /* Mask for Max Power A */
+#define  SSB_SPROM4_ITSSI_A		0xFF00	/* Mask for path 1 itssi_a */
+#define  SSB_SPROM4_ITSSI_A_SHIFT	8
+#define SSB_SPROM4_GPIOA		0x1056	/* Gen. Purpose IO # 0 and 1 */
+#define  SSB_SPROM4_GPIOA_P0		0x00FF	/* Pin 0 */
+#define  SSB_SPROM4_GPIOA_P1		0xFF00	/* Pin 1 */
+#define  SSB_SPROM4_GPIOA_P1_SHIFT	8
+#define SSB_SPROM4_GPIOB		0x1058	/* Gen. Purpose IO # 2 and 3 */
+#define  SSB_SPROM4_GPIOB_P2		0x00FF	/* Pin 2 */
+#define  SSB_SPROM4_GPIOB_P3		0xFF00	/* Pin 3 */
+#define  SSB_SPROM4_GPIOB_P3_SHIFT	8
+#define SSB_SPROM4_PA0B0		0x1082	/* The paXbY locations are */
+#define SSB_SPROM4_PA0B1		0x1084	/*   only guesses */
+#define SSB_SPROM4_PA0B2		0x1086
+#define SSB_SPROM4_PA1B0		0x108E
+#define SSB_SPROM4_PA1B1		0x1090
+#define SSB_SPROM4_PA1B2		0x1092
+
 /* Values for SSB_SPROM1_BINF_CCODE */
 enum {
 	SSB_SPROM1CCODE_WORLD = 0,
Index: linux-2.6/drivers/ssb/pci.c
===================================================================
--- linux-2.6.orig/drivers/ssb/pci.c
+++ linux-2.6/drivers/ssb/pci.c
@@ -212,29 +212,29 @@ static inline u8 ssb_crc8(u8 crc, u8 dat
 	return t[crc ^ data];
 }
 
-static u8 ssb_sprom_crc(const u16 *sprom)
+static u8 ssb_sprom_crc(const u16 *sprom, u16 size)
 {
 	int word;
 	u8 crc = 0xFF;
 
-	for (word = 0; word < SSB_SPROMSIZE_WORDS - 1; word++) {
+	for (word = 0; word < size - 1; word++) {
 		crc = ssb_crc8(crc, sprom[word] & 0x00FF);
 		crc = ssb_crc8(crc, (sprom[word] & 0xFF00) >> 8);
 	}
-	crc = ssb_crc8(crc, sprom[SPOFF(SSB_SPROM_REVISION)] & 0x00FF);
+	crc = ssb_crc8(crc, sprom[size - 1] & 0x00FF);
 	crc ^= 0xFF;
 
 	return crc;
 }
 
-static int sprom_check_crc(const u16 *sprom)
+static int sprom_check_crc(const u16 *sprom, u16 size)
 {
 	u8 crc;
 	u8 expected_crc;
 	u16 tmp;
 
-	crc = ssb_sprom_crc(sprom);
-	tmp = sprom[SPOFF(SSB_SPROM_REVISION)] & SSB_SPROM_REVISION_CRC;
+	crc = ssb_sprom_crc(sprom, size);
+	tmp = sprom[size - 1] & SSB_SPROM_REVISION_CRC;
 	expected_crc = tmp >> SSB_SPROM_REVISION_CRC_SHIFT;
 	if (crc != expected_crc)
 		return -EPROTO;
@@ -246,7 +246,7 @@ static void sprom_do_read(struct ssb_bus
 {
 	int i;
 
-	for (i = 0; i < SSB_SPROMSIZE_WORDS; i++)
+	for (i = 0; i < bus->sprom_size; i++)
 		sprom[i] = readw(bus->mmio + SSB_SPROM_BASE + (i * 2));
 }
 
@@ -255,6 +255,7 @@ static int sprom_do_write(struct ssb_bus
 	struct pci_dev *pdev = bus->host_pci;
 	int i, err;
 	u32 spromctl;
+	u16 size = bus->sprom_size;
 
 	ssb_printk(KERN_NOTICE PFX "Writing SPROM. Do NOT turn off the power! Please stand by...\n");
 	err = pci_read_config_dword(pdev, SSB_SPROMCTL, &spromctl);
@@ -266,12 +267,12 @@ static int sprom_do_write(struct ssb_bus
 		goto err_ctlreg;
 	ssb_printk(KERN_NOTICE PFX "[ 0%%");
 	msleep(500);
-	for (i = 0; i < SSB_SPROMSIZE_WORDS; i++) {
-		if (i == SSB_SPROMSIZE_WORDS / 4)
+	for (i = 0; i < size; i++) {
+		if (i == size / 4)
 			ssb_printk("25%%");
-		else if (i == SSB_SPROMSIZE_WORDS / 2)
+		else if (i == size / 2)
 			ssb_printk("50%%");
-		else if (i == (SSB_SPROMSIZE_WORDS / 4) * 3)
+		else if (i == (size * 3) / 4)
 			ssb_printk("75%%");
 		else if (i % 2)
 			ssb_printk(".");
@@ -296,38 +297,38 @@ err_ctlreg:
 	return err;
 }
 
-static void sprom_extract_r1(struct ssb_sprom_r1 *out, const u16 *in)
+static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
 {
 	int i;
 	u16 v;
+	u16 loc[3];
 
-	SPEX(pci_spid, SSB_SPROM1_SPID, 0xFFFF, 0);
-	SPEX(pci_svid, SSB_SPROM1_SVID, 0xFFFF, 0);
-	SPEX(pci_pid, SSB_SPROM1_PID, 0xFFFF, 0);
+	if (out->revision == 3) {			/* rev 3 moved MAC */
+		loc[0] = SSB_SPROM3_IL0MAC;
+		loc[1] = SSB_SPROM3_ET0MAC;
+		loc[2] = SSB_SPROM3_ET1MAC;
+	} else {
+		loc[0] = SSB_SPROM1_IL0MAC;
+		loc[1] = SSB_SPROM1_ET0MAC;
+		loc[2] = SSB_SPROM1_ET1MAC;
+	}
 	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
+		v = in[SPOFF(loc[0]) + i];
 		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
 	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_ET0MAC) + i];
+		v = in[SPOFF(loc[1]) + i];
 		*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
 	}
 	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_ET1MAC) + i];
+		v = in[SPOFF(loc[2]) + i];
 		*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
 	}
 	SPEX(et0phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1A,
 	     SSB_SPROM1_ETHPHY_ET1A_SHIFT);
-	SPEX(et0mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0M, 14);
-	SPEX(et1mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1M, 15);
-	SPEX(board_rev, SSB_SPROM1_BINF, SSB_SPROM1_BINF_BREV, 0);
 	SPEX(country_code, SSB_SPROM1_BINF, SSB_SPROM1_BINF_CCODE,
 	     SSB_SPROM1_BINF_CCODE_SHIFT);
-	SPEX(antenna_a, SSB_SPROM1_BINF, SSB_SPROM1_BINF_ANTA,
-	     SSB_SPROM1_BINF_ANTA_SHIFT);
-	SPEX(antenna_bg, SSB_SPROM1_BINF, SSB_SPROM1_BINF_ANTBG,
-	     SSB_SPROM1_BINF_ANTBG_SHIFT);
 	SPEX(pa0b0, SSB_SPROM1_PA0B0, 0xFFFF, 0);
 	SPEX(pa0b1, SSB_SPROM1_PA0B1, 0xFFFF, 0);
 	SPEX(pa0b2, SSB_SPROM1_PA0B2, 0xFFFF, 0);
@@ -350,97 +351,75 @@ static void sprom_extract_r1(struct ssb_
 	SPEX(antenna_gain_a, SSB_SPROM1_AGAIN, SSB_SPROM1_AGAIN_A, 0);
 	SPEX(antenna_gain_bg, SSB_SPROM1_AGAIN, SSB_SPROM1_AGAIN_BG,
 	     SSB_SPROM1_AGAIN_BG_SHIFT);
-	for (i = 0; i < 4; i++) {
-		v = in[SPOFF(SSB_SPROM1_OEM) + i];
-		*(((__le16 *)out->oem) + i) = cpu_to_le16(v);
-	}
 }
 
-static void sprom_extract_r2(struct ssb_sprom_r2 *out, const u16 *in)
+static void sprom_extract_r4(struct ssb_sprom *out, const u16 *in)
 {
 	int i;
 	u16 v;
 
-	SPEX(boardflags_hi, SSB_SPROM2_BFLHI,  0xFFFF, 0);
-	SPEX(maxpwr_a_hi, SSB_SPROM2_MAXP_A, SSB_SPROM2_MAXP_A_HI, 0);
-	SPEX(maxpwr_a_lo, SSB_SPROM2_MAXP_A, SSB_SPROM2_MAXP_A_LO,
-	     SSB_SPROM2_MAXP_A_LO_SHIFT);
-	SPEX(pa1lob0, SSB_SPROM2_PA1LOB0, 0xFFFF, 0);
-	SPEX(pa1lob1, SSB_SPROM2_PA1LOB1, 0xFFFF, 0);
-	SPEX(pa1lob2, SSB_SPROM2_PA1LOB2, 0xFFFF, 0);
-	SPEX(pa1hib0, SSB_SPROM2_PA1HIB0, 0xFFFF, 0);
-	SPEX(pa1hib1, SSB_SPROM2_PA1HIB1, 0xFFFF, 0);
-	SPEX(pa1hib2, SSB_SPROM2_PA1HIB2, 0xFFFF, 0);
-	SPEX(ofdm_pwr_off, SSB_SPROM2_OPO, SSB_SPROM2_OPO_VALUE, 0);
-	for (i = 0; i < 4; i++) {
-		v = in[SPOFF(SSB_SPROM2_CCODE) + i];
-		*(((__le16 *)out->country_str) + i) = cpu_to_le16(v);
+	/* extract the equivalent of the r1 variables */
+	for (i = 0; i < 3; i++) {
+		v = in[SPOFF(SSB_SPROM4_IL0MAC) + i];
+		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
+	for (i = 0; i < 3; i++) {
+		v = in[SPOFF(SSB_SPROM4_ET0MAC) + i];
+		*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
+	}
+	for (i = 0; i < 3; i++) {
+		v = in[SPOFF(SSB_SPROM4_ET1MAC) + i];
+		*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
+	}
+	SPEX(et0phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET0A, 0);
+	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
+	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
+	SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
+	SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
+	SPEX(antenna_gain_a, SSB_SPROM4_AGAIN, SSB_SPROM4_AGAIN_0, 0);
+	SPEX(antenna_gain_bg, SSB_SPROM4_AGAIN, SSB_SPROM4_AGAIN_1,
+	     SSB_SPROM4_AGAIN_1_SHIFT);
+	SPEX(maxpwr_bg, SSB_SPROM4_MAXP_BG, SSB_SPROM4_MAXP_BG_MASK, 0);
+	SPEX(itssi_bg, SSB_SPROM4_MAXP_BG, SSB_SPROM4_ITSSI_BG,
+	     SSB_SPROM4_ITSSI_BG_SHIFT);
+	SPEX(maxpwr_a, SSB_SPROM4_MAXP_A, SSB_SPROM4_MAXP_A_MASK, 0);
+	SPEX(itssi_a, SSB_SPROM4_MAXP_A, SSB_SPROM4_ITSSI_A,
+	     SSB_SPROM4_ITSSI_A_SHIFT);
+	SPEX(gpio0, SSB_SPROM4_GPIOA, SSB_SPROM4_GPIOA_P0, 0);
+	SPEX(gpio1, SSB_SPROM4_GPIOA, SSB_SPROM4_GPIOA_P1,
+	     SSB_SPROM4_GPIOA_P1_SHIFT);
+	SPEX(gpio2, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P2, 0);
+	SPEX(gpio3, SSB_SPROM4_GPIOB, SSB_SPROM4_GPIOB_P3,
+	     SSB_SPROM4_GPIOB_P3_SHIFT);
+	/* TODO - get remaining rev 4 stuff needed */
 }
 
-static void sprom_extract_r3(struct ssb_sprom_r3 *out, const u16 *in)
-{
-	out->ofdmapo  = (in[SPOFF(SSB_SPROM3_OFDMAPO) + 0] & 0xFF00) >> 8;
-	out->ofdmapo |= (in[SPOFF(SSB_SPROM3_OFDMAPO) + 0] & 0x00FF) << 8;
-	out->ofdmapo <<= 16;
-	out->ofdmapo |= (in[SPOFF(SSB_SPROM3_OFDMAPO) + 1] & 0xFF00) >> 8;
-	out->ofdmapo |= (in[SPOFF(SSB_SPROM3_OFDMAPO) + 1] & 0x00FF) << 8;
-
-	out->ofdmalpo  = (in[SPOFF(SSB_SPROM3_OFDMALPO) + 0] & 0xFF00) >> 8;
-	out->ofdmalpo |= (in[SPOFF(SSB_SPROM3_OFDMALPO) + 0] & 0x00FF) << 8;
-	out->ofdmalpo <<= 16;
-	out->ofdmalpo |= (in[SPOFF(SSB_SPROM3_OFDMALPO) + 1] & 0xFF00) >> 8;
-	out->ofdmalpo |= (in[SPOFF(SSB_SPROM3_OFDMALPO) + 1] & 0x00FF) << 8;
-
-	out->ofdmahpo  = (in[SPOFF(SSB_SPROM3_OFDMAHPO) + 0] & 0xFF00) >> 8;
-	out->ofdmahpo |= (in[SPOFF(SSB_SPROM3_OFDMAHPO) + 0] & 0x00FF) << 8;
-	out->ofdmahpo <<= 16;
-	out->ofdmahpo |= (in[SPOFF(SSB_SPROM3_OFDMAHPO) + 1] & 0xFF00) >> 8;
-	out->ofdmahpo |= (in[SPOFF(SSB_SPROM3_OFDMAHPO) + 1] & 0x00FF) << 8;
-
-	SPEX(gpioldc_on_cnt, SSB_SPROM3_GPIOLDC, SSB_SPROM3_GPIOLDC_ON,
-	     SSB_SPROM3_GPIOLDC_ON_SHIFT);
-	SPEX(gpioldc_off_cnt, SSB_SPROM3_GPIOLDC, SSB_SPROM3_GPIOLDC_OFF,
-	     SSB_SPROM3_GPIOLDC_OFF_SHIFT);
-	SPEX(cckpo_1M, SSB_SPROM3_CCKPO, SSB_SPROM3_CCKPO_1M, 0);
-	SPEX(cckpo_2M, SSB_SPROM3_CCKPO, SSB_SPROM3_CCKPO_2M,
-	     SSB_SPROM3_CCKPO_2M_SHIFT);
-	SPEX(cckpo_55M, SSB_SPROM3_CCKPO, SSB_SPROM3_CCKPO_55M,
-	     SSB_SPROM3_CCKPO_55M_SHIFT);
-	SPEX(cckpo_11M, SSB_SPROM3_CCKPO, SSB_SPROM3_CCKPO_11M,
-	     SSB_SPROM3_CCKPO_11M_SHIFT);
-
-	out->ofdmgpo  = (in[SPOFF(SSB_SPROM3_OFDMGPO) + 0] & 0xFF00) >> 8;
-	out->ofdmgpo |= (in[SPOFF(SSB_SPROM3_OFDMGPO) + 0] & 0x00FF) << 8;
-	out->ofdmgpo <<= 16;
-	out->ofdmgpo |= (in[SPOFF(SSB_SPROM3_OFDMGPO) + 1] & 0xFF00) >> 8;
-	out->ofdmgpo |= (in[SPOFF(SSB_SPROM3_OFDMGPO) + 1] & 0x00FF) << 8;
-}
-
-static int sprom_extract(struct ssb_bus *bus,
-			 struct ssb_sprom *out, const u16 *in)
+static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
+			 const u16 *in, u16 size)
 {
 	memset(out, 0, sizeof(*out));
 
-	SPEX(revision, SSB_SPROM_REVISION, SSB_SPROM_REVISION_REV, 0);
-	SPEX(crc, SSB_SPROM_REVISION, SSB_SPROM_REVISION_CRC,
-	     SSB_SPROM_REVISION_CRC_SHIFT);
-
+	out->revision = in[size - 1] & 0x00FF;
+	ssb_printk(KERN_INFO PFX "SPROM revision %d detected.\n", out->revision);
 	if ((bus->chip_id & 0xFF00) == 0x4400) {
 		/* Workaround: The BCM44XX chip has a stupid revision
 		 * number stored in the SPROM.
 		 * Always extract r1. */
-		sprom_extract_r1(&out->r1, in);
+		out->revision = 1;
+		sprom_extract_r123(out, in);
+	} else if (bus->chip_id == 0x4321) {
+		/* the BCM4328 has a chipid == 0x4321 and a rev 4 SPROM */
+		out->revision = 4;
+		sprom_extract_r4(out, in);
 	} else {
 		if (out->revision == 0)
 			goto unsupported;
-		if (out->revision >= 1 && out->revision <= 3)
-			sprom_extract_r1(&out->r1, in);
-		if (out->revision >= 2 && out->revision <= 3)
-			sprom_extract_r2(&out->r2, in);
-		if (out->revision == 3)
-			sprom_extract_r3(&out->r3, in);
-		if (out->revision >= 4)
+		if (out->revision >= 1 && out->revision <= 3) {
+			sprom_extract_r123(out, in);
+		}
+		if (out->revision == 4)
+			sprom_extract_r4(out, in);
+		if (out->revision >= 5)
 			goto unsupported;
 	}
 
@@ -448,7 +427,7 @@ static int sprom_extract(struct ssb_bus 
 unsupported:
 	ssb_printk(KERN_WARNING PFX "Unsupported SPROM revision %d "
 		   "detected. Will extract v1\n", out->revision);
-	sprom_extract_r1(&out->r1, in);
+	sprom_extract_r123(out, in);
 	return 0;
 }
 
@@ -458,16 +437,31 @@ static int ssb_pci_sprom_get(struct ssb_
 	int err = -ENOMEM;
 	u16 *buf;
 
-	buf = kcalloc(SSB_SPROMSIZE_WORDS, sizeof(u16), GFP_KERNEL);
+	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
 		goto out;
+	bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
 	sprom_do_read(bus, buf);
-	err = sprom_check_crc(buf);
+	err = sprom_check_crc(buf, bus->sprom_size);
 	if (err) {
-		ssb_printk(KERN_WARNING PFX
-			   "WARNING: Invalid SPROM CRC (corrupt SPROM)\n");
+		/* check for rev 4 sprom - has special signature */
+		if (buf [32] == 0x5372) {
+			ssb_printk(KERN_WARNING PFX "Extracting a rev 4"
+				   " SPROM\n");
+			kfree(buf);
+			buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
+				      GFP_KERNEL);
+			if (!buf)
+				goto out;
+			bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
+			sprom_do_read(bus, buf);
+			err = sprom_check_crc(buf, bus->sprom_size);
+		}
+		if (err)
+			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
+				   " SPROM CRC (corrupt SPROM)\n");
 	}
-	err = sprom_extract(bus, sprom, buf);
+	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
 
 	kfree(buf);
 out:
@@ -581,29 +575,28 @@ const struct ssb_bus_ops ssb_pci_ops = {
 	.write32	= ssb_pci_write32,
 };
 
-static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len)
+static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len, u16 size)
 {
 	int i, pos = 0;
 
-	for (i = 0; i < SSB_SPROMSIZE_WORDS; i++) {
+	for (i = 0; i < size; i++)
 		pos += snprintf(buf + pos, buf_len - pos - 1,
 				"%04X", swab16(sprom[i]) & 0xFFFF);
-	}
 	pos += snprintf(buf + pos, buf_len - pos - 1, "\n");
 
 	return pos + 1;
 }
 
-static int hex2sprom(u16 *sprom, const char *dump, size_t len)
+static int hex2sprom(u16 *sprom, const char *dump, size_t len, u16 size)
 {
 	char tmp[5] = { 0 };
 	int cnt = 0;
 	unsigned long parsed;
 
-	if (len < SSB_SPROMSIZE_BYTES * 2)
+	if (len < size * 2)
 		return -EINVAL;
 
-	while (cnt < SSB_SPROMSIZE_WORDS) {
+	while (cnt < size) {
 		memcpy(tmp, dump, 4);
 		dump += 4;
 		parsed = simple_strtoul(tmp, NULL, 16);
@@ -627,7 +620,7 @@ static ssize_t ssb_pci_attr_sprom_show(s
 	if (!bus)
 		goto out;
 	err = -ENOMEM;
-	sprom = kcalloc(SSB_SPROMSIZE_WORDS, sizeof(u16), GFP_KERNEL);
+	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
 	if (!sprom)
 		goto out;
 
@@ -640,7 +633,7 @@ static ssize_t ssb_pci_attr_sprom_show(s
 	sprom_do_read(bus, sprom);
 	mutex_unlock(&bus->pci_sprom_mutex);
 
-	count = sprom2hex(sprom, buf, PAGE_SIZE);
+	count = sprom2hex(sprom, buf, PAGE_SIZE, bus->sprom_size);
 	err = 0;
 
 out_kfree:
@@ -662,15 +655,15 @@ static ssize_t ssb_pci_attr_sprom_store(
 	if (!bus)
 		goto out;
 	err = -ENOMEM;
-	sprom = kcalloc(SSB_SPROMSIZE_WORDS, sizeof(u16), GFP_KERNEL);
+	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
 	if (!sprom)
 		goto out;
-	err = hex2sprom(sprom, buf, count);
+	err = hex2sprom(sprom, buf, count, bus->sprom_size);
 	if (err) {
 		err = -EINVAL;
 		goto out_kfree;
 	}
-	err = sprom_check_crc(sprom);
+	err = sprom_check_crc(sprom, bus->sprom_size);
 	if (err) {
 		err = -EINVAL;
 		goto out_kfree;
Index: linux-2.6/drivers/ssb/main.c
===================================================================
--- linux-2.6.orig/drivers/ssb/main.c
+++ linux-2.6/drivers/ssb/main.c
@@ -872,14 +872,22 @@ EXPORT_SYMBOL(ssb_clockspeed);
 
 static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
 {
+	u32 rev = ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_SSBREV;
+
 	/* The REJECT bit changed position in TMSLOW between
 	 * Backplane revisions. */
-	switch (ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_SSBREV) {
+	switch (rev) {
 	case SSB_IDLOW_SSBREV_22:
 		return SSB_TMSLOW_REJECT_22;
 	case SSB_IDLOW_SSBREV_23:
 		return SSB_TMSLOW_REJECT_23;
+	case SSB_IDLOW_SSBREV_24:     /* TODO - find the proper REJECT bits */
+	case SSB_IDLOW_SSBREV_25:     /* same here */
+	case SSB_IDLOW_SSBREV_26:     /* same here */
+	case SSB_IDLOW_SSBREV_27:     /* same here */
+		return SSB_TMSLOW_REJECT_23;	/* this is a guess */
 	default:
+		printk(KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
 		WARN_ON(1);
 	}
 	return (SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23);
@@ -1010,7 +1018,7 @@ int ssb_dma_set_mask(struct ssb_device *
 
 #ifdef CONFIG_SSB_PCIHOST
 	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI &&
-	    !dma_supported(dev, mask))
+	    !dma_set_mask(dev, mask))
 		return -EIO;
 #endif
 	dev->coherent_dma_mask = mask;
Index: linux-2.6/drivers/ssb/b43_pci_bridge.c
===================================================================
--- linux-2.6.orig/drivers/ssb/b43_pci_bridge.c
+++ linux-2.6/drivers/ssb/b43_pci_bridge.c
@@ -27,6 +27,7 @@ static const struct pci_device_id b43_pc
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4328) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);
Index: linux-2.6/drivers/net/b44.c
===================================================================
--- linux-2.6.orig/drivers/net/b44.c
+++ linux-2.6/drivers/net/b44.c
@@ -2060,11 +2060,11 @@ static int __devinit b44_get_invariants(
 
 	if (sdev->bus->bustype == SSB_BUSTYPE_SSB &&
 	    instance > 1) {
-		addr = sdev->bus->sprom.r1.et1mac;
-		bp->phy_addr = sdev->bus->sprom.r1.et1phyaddr;
+		addr = sdev->bus->sprom.et1mac;
+		bp->phy_addr = sdev->bus->sprom.et1phyaddr;
 	} else {
-		addr = sdev->bus->sprom.r1.et0mac;
-		bp->phy_addr = sdev->bus->sprom.r1.et0phyaddr;
+		addr = sdev->bus->sprom.et0mac;
+		bp->phy_addr = sdev->bus->sprom.et0phyaddr;
 	}
 	memcpy(bp->dev->dev_addr, addr, 6);
 
Index: linux-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/leds.c
+++ linux-2.6/drivers/net/wireless/b43/leds.c
@@ -187,10 +187,10 @@ void b43_leds_init(struct b43_wldev *dev
 	enum b43_led_behaviour behaviour;
 	bool activelow;
 
-	sprom[0] = bus->sprom.r1.gpio0;
-	sprom[1] = bus->sprom.r1.gpio1;
-	sprom[2] = bus->sprom.r1.gpio2;
-	sprom[3] = bus->sprom.r1.gpio3;
+	sprom[0] = bus->sprom.gpio0;
+	sprom[1] = bus->sprom.gpio1;
+	sprom[2] = bus->sprom.gpio2;
+	sprom[3] = bus->sprom.gpio3;
 
 	for (i = 0; i < 4; i++) {
 		if (sprom[i] == 0xFF) {
Index: linux-2.6/drivers/net/wireless/b43/lo.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/lo.c
+++ linux-2.6/drivers/net/wireless/b43/lo.c
@@ -264,8 +264,8 @@ static u16 lo_measure_feedthrough(struct
 		rfover |= pga;
 		rfover |= lna;
 		rfover |= trsw_rx;
-		if ((dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_EXTLNA) &&
-		    phy->rev > 6)
+		if ((dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA)
+		    && phy->rev > 6)
 			rfover |= B43_PHY_RFOVERVAL_EXTLNA;
 
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xE300);
@@ -634,7 +634,7 @@ static void lo_measure_setup(struct b43_
 			      & 0xFFFC);
 		if (phy->type == B43_PHYTYPE_G) {
 			if ((phy->rev >= 7) &&
-			    (sprom->r1.boardflags_lo & B43_BFL_EXTLNA)) {
+			    (sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 				b43_phy_write(dev, B43_PHY_RFOVER, 0x933);
 			} else {
 				b43_phy_write(dev, B43_PHY_RFOVER, 0x133);
Index: linux-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/main.c
+++ linux-2.6/drivers/net/wireless/b43/main.c
@@ -101,6 +101,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
 
@@ -1380,6 +1381,8 @@ static void handle_irq_ucode_debug(struc
 	//TODO
 }
 
+void b43_dump_dma_regs(struct b43_wldev *dev);
+
 /* Interrupt handler bottom-half */
 static void b43_interrupt_tasklet(struct b43_wldev *dev)
 {
@@ -1414,6 +1417,7 @@ static void b43_interrupt_tasklet(struct
 			       dma_reason[0], dma_reason[1],
 			       dma_reason[2], dma_reason[3],
 			       dma_reason[4], dma_reason[5]);
+			b43_dump_dma_regs(dev);
 			b43_controller_restart(dev, "DMA error");
 			mmiowb();
 			spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
@@ -1932,7 +1936,7 @@ static int b43_gpio_init(struct b43_wlde
 		mask |= 0x0180;
 		set |= 0x0180;
 	}
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_PACTRL) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0200);
@@ -2297,7 +2301,7 @@ static void b43_periodic_every60sec(stru
 
 	if (!b43_has_hardware_pctl(phy))
 		b43_lo_g_ctl_mark_all_unused(dev);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 		b43_mac_suspend(dev);
 		b43_calc_nrssi_slope(dev);
 		if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 8)) {
@@ -3070,7 +3074,7 @@ static int b43_phy_versioning(struct b43
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (phy_rev > 8)
+		if (phy_rev > 9)
 			unsupported = 1;
 		break;
 	default:
@@ -3217,13 +3221,13 @@ static void b43_bluetooth_coext_enable(s
 	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
 	u32 hf;
 
-	if (!(sprom->r1.boardflags_lo & B43_BFL_BTCOEXIST))
+	if (!(sprom->boardflags_lo & B43_BFL_BTCOEXIST))
 		return;
 	if (dev->phy.type != B43_PHYTYPE_B && !dev->phy.gmode)
 		return;
 
 	hf = b43_hf_read(dev);
-	if (sprom->r1.boardflags_lo & B43_BFL_BTCMOD)
+	if (sprom->boardflags_lo & B43_BFL_BTCMOD)
 		hf |= B43_HF_BTCOEXALT;
 	else
 		hf |= B43_HF_BTCOEX;
@@ -3341,7 +3345,7 @@ static int b43_wireless_core_init(struct
 		hf |= B43_HF_SYMW;
 		if (phy->rev == 1)
 			hf |= B43_HF_GDCW;
-		if (sprom->r1.boardflags_lo & B43_BFL_PACTRL)
+		if (sprom->boardflags_lo & B43_BFL_PACTRL)
 			hf |= B43_HF_OFDMPABOOST;
 	} else if (phy->type == B43_PHYTYPE_B) {
 		hf |= B43_HF_SYMW;
@@ -3838,20 +3842,20 @@ static void b43_sprom_fixup(struct ssb_b
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
 	    bus->chip_id == 0x4301 && bus->boardinfo.rev == 0x74)
-		bus->sprom.r1.boardflags_lo |= B43_BFL_BTCOEXIST;
+		bus->sprom.boardflags_lo |= B43_BFL_BTCOEXIST;
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
-		bus->sprom.r1.boardflags_lo |= B43_BFL_PACTRL;
+		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
 
 	/* Handle case when gain is not set in sprom */
-	if (bus->sprom.r1.antenna_gain_a == 0xFF)
-		bus->sprom.r1.antenna_gain_a = 2;
-	if (bus->sprom.r1.antenna_gain_bg == 0xFF)
-		bus->sprom.r1.antenna_gain_bg = 2;
+	if (bus->sprom.antenna_gain_a == 0xFF)
+		bus->sprom.antenna_gain_a = 2;
+	if (bus->sprom.antenna_gain_bg == 0xFF)
+		bus->sprom.antenna_gain_bg = 2;
 
 	/* Convert Antennagain values to Q5.2 */
-	bus->sprom.r1.antenna_gain_a <<= 2;
-	bus->sprom.r1.antenna_gain_bg <<= 2;
+	bus->sprom.antenna_gain_a <<= 2;
+	bus->sprom.antenna_gain_bg <<= 2;
 }
 
 static void b43_wireless_exit(struct ssb_device *dev, struct b43_wl *wl)
@@ -3884,10 +3888,10 @@ static int b43_wireless_init(struct ssb_
 	hw->max_noise = -110;
 	hw->queues = 1;		/* FIXME: hardware has more queues */
 	SET_IEEE80211_DEV(hw, dev->dev);
-	if (is_valid_ether_addr(sprom->r1.et1mac))
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
+	if (is_valid_ether_addr(sprom->et1mac))
+		SET_IEEE80211_PERM_ADDR(hw, sprom->et1mac);
 	else
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
+		SET_IEEE80211_PERM_ADDR(hw, sprom->il0mac);
 
 	/* Get and initialize struct b43_wl */
 	wl = hw_to_b43_wl(hw);
Index: linux-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/phy.c
+++ linux-2.6/drivers/net/wireless/b43/phy.c
@@ -1139,7 +1139,7 @@ static void b43_phy_inita(struct b43_wld
 	} else {
 		b43_phy_setupg(dev);
 		if (phy->gmode &&
-		    (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_PACTRL))
+		    (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL))
 			b43_phy_write(dev, 0x046E, 0x03CF);
 		return;
 	}
@@ -1286,7 +1286,7 @@ static void b43_phy_initb4(struct b43_wl
 	if (phy->radio_ver == 0x2050)
 		b43_phy_write(dev, 0x002A, 0x88C2);
 	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 		b43_calc_nrssi_slope(dev);
 		b43_calc_nrssi_threshold(dev);
 	}
@@ -1433,7 +1433,7 @@ static void b43_phy_initb6(struct b43_wl
 		b43_radio_write16(dev, 0x5A, 0x88);
 		b43_radio_write16(dev, 0x5B, 0x6B);
 		b43_radio_write16(dev, 0x5C, 0x0F);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_ALTIQ) {
+		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_ALTIQ) {
 			b43_radio_write16(dev, 0x5D, 0xFA);
 			b43_radio_write16(dev, 0x5E, 0xD8);
 		} else {
@@ -1525,7 +1525,7 @@ static void b43_phy_initb6(struct b43_wl
 		b43_phy_write(dev, 0x0062, 0x0007);
 		b43_radio_init2050(dev);
 		b43_lo_g_measure(dev);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
+		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 			b43_calc_nrssi_slope(dev);
 			b43_calc_nrssi_threshold(dev);
 		}
@@ -1645,7 +1645,7 @@ static void b43_calc_loopback_gain(struc
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xCFFF);
 
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_EXTLNA) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
 			b43_phy_write(dev, B43_PHY_RFOVER,
 				      b43_phy_read(dev, B43_PHY_RFOVER)
@@ -1812,7 +1812,7 @@ static void b43_phy_initg(struct b43_wld
 				       & 0x0FFF) | (phy->lo_control->
 						    tx_bias << 12));
 		}
-		if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_PACTRL)
+		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
 			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x8075);
 		else
 			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x807F);
@@ -1826,7 +1826,7 @@ static void b43_phy_initg(struct b43_wld
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
 	}
 
-	if (!(dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI)) {
+	if (!(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
 		/* The specs state to update the NRSSI LT with
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
@@ -2036,16 +2036,15 @@ void b43_phy_xmitpower(struct b43_wldev 
 			estimated_pwr =
 			    b43_phy_estimate_power_out(dev, average);
 
-			max_pwr = dev->dev->bus->sprom.r1.maxpwr_bg;
-			if ((dev->dev->bus->sprom.r1.
-			     boardflags_lo & B43_BFL_PACTRL)
-			    && (phy->type == B43_PHYTYPE_G))
+			max_pwr = dev->dev->bus->sprom.maxpwr_bg;
+			if ((dev->dev->bus->sprom.boardflags_lo
+			    & B43_BFL_PACTRL) && (phy->type == B43_PHYTYPE_G))
 				max_pwr -= 0x3;
 			if (unlikely(max_pwr <= 0)) {
 				b43warn(dev->wl,
 					"Invalid max-TX-power value in SPROM.\n");
 				max_pwr = 60;	/* fake it */
-				dev->dev->bus->sprom.r1.maxpwr_bg = max_pwr;
+				dev->dev->bus->sprom.maxpwr_bg = max_pwr;
 			}
 
 			/*TODO:
@@ -2103,7 +2102,7 @@ void b43_phy_xmitpower(struct b43_wldev 
 						    B43_TXCTL_TXMIX;
 						rfatt += 2;
 						bbatt += 2;
-					} else if (dev->dev->bus->sprom.r1.
+					} else if (dev->dev->bus->sprom.
 						   boardflags_lo &
 						   B43_BFL_PACTRL) {
 						bbatt += 4 * (rfatt - 2);
@@ -2179,13 +2178,13 @@ int b43_phy_init_tssi2dbm_table(struct b
 	s8 *dyn_tssi2dbm;
 
 	if (phy->type == B43_PHYTYPE_A) {
-		pab0 = (s16) (dev->dev->bus->sprom.r1.pa1b0);
-		pab1 = (s16) (dev->dev->bus->sprom.r1.pa1b1);
-		pab2 = (s16) (dev->dev->bus->sprom.r1.pa1b2);
+		pab0 = (s16) (dev->dev->bus->sprom.pa1b0);
+		pab1 = (s16) (dev->dev->bus->sprom.pa1b1);
+		pab2 = (s16) (dev->dev->bus->sprom.pa1b2);
 	} else {
-		pab0 = (s16) (dev->dev->bus->sprom.r1.pa0b0);
-		pab1 = (s16) (dev->dev->bus->sprom.r1.pa0b1);
-		pab2 = (s16) (dev->dev->bus->sprom.r1.pa0b2);
+		pab0 = (s16) (dev->dev->bus->sprom.pa0b0);
+		pab1 = (s16) (dev->dev->bus->sprom.pa0b1);
+		pab2 = (s16) (dev->dev->bus->sprom.pa0b2);
 	}
 
 	if ((dev->dev->bus->chip_id == 0x4301) && (phy->radio_ver != 0x2050)) {
@@ -2198,17 +2197,17 @@ int b43_phy_init_tssi2dbm_table(struct b
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
 		if (phy->type == B43_PHYTYPE_A) {
-			if ((s8) dev->dev->bus->sprom.r1.itssi_a != 0 &&
-			    (s8) dev->dev->bus->sprom.r1.itssi_a != -1)
+			if ((s8) dev->dev->bus->sprom.itssi_a != 0 &&
+			    (s8) dev->dev->bus->sprom.itssi_a != -1)
 				phy->tgt_idle_tssi =
-				    (s8) (dev->dev->bus->sprom.r1.itssi_a);
+				    (s8) (dev->dev->bus->sprom.itssi_a);
 			else
 				phy->tgt_idle_tssi = 62;
 		} else {
-			if ((s8) dev->dev->bus->sprom.r1.itssi_bg != 0 &&
-			    (s8) dev->dev->bus->sprom.r1.itssi_bg != -1)
+			if ((s8) dev->dev->bus->sprom.itssi_bg != 0 &&
+			    (s8) dev->dev->bus->sprom.itssi_bg != -1)
 				phy->tgt_idle_tssi =
-				    (s8) (dev->dev->bus->sprom.r1.itssi_bg);
+				    (s8) (dev->dev->bus->sprom.itssi_bg);
 			else
 				phy->tgt_idle_tssi = 62;
 		}
@@ -3114,7 +3113,7 @@ void b43_calc_nrssi_threshold(struct b43
 			if (phy->radio_ver != 0x2050)
 				return;
 			if (!
-			    (dev->dev->bus->sprom.r1.
+			    (dev->dev->bus->sprom.
 			     boardflags_lo & B43_BFL_RSSI))
 				return;
 
@@ -3145,7 +3144,7 @@ void b43_calc_nrssi_threshold(struct b43
 		}
 	case B43_PHYTYPE_G:
 		if (!phy->gmode ||
-		    !(dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI)) {
+		    !(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
 			tmp16 = b43_nrssi_hw_read(dev, 0x20);
 			if (tmp16 >= 0x20)
 				tmp16 -= 0x40;
@@ -3667,7 +3666,7 @@ static u16 radio2050_rfover_val(struct b
 		}
 
 		if ((phy->rev < 7) ||
-		    !(sprom->r1.boardflags_lo & B43_BFL_EXTLNA)) {
+		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
 				return 0x1B3;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
@@ -3707,7 +3706,7 @@ static u16 radio2050_rfover_val(struct b
 		}
 	} else {
 		if ((phy->rev < 7) ||
-		    !(sprom->r1.boardflags_lo & B43_BFL_EXTLNA)) {
+		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
 				return 0x1B3;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
@@ -4186,7 +4185,7 @@ int b43_radio_selectchannel(struct b43_w
 		b43_write16(dev, B43_MMIO_CHANNEL, channel2freq_bg(channel));
 
 		if (channel == 14) {
-			if (dev->dev->bus->sprom.r1.country_code ==
+			if (dev->dev->bus->sprom.country_code ==
 			    SSB_SPROM1CCODE_JAPAN)
 				b43_hf_write(dev,
 					     b43_hf_read(dev) & ~B43_HF_ACPR);
Index: linux-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/xmit.c
+++ linux-2.6/drivers/net/wireless/b43/xmit.c
@@ -384,7 +384,7 @@ static s8 b43_rssi_postprocess(struct b4
 			else
 				tmp -= 3;
 		} else {
-			if (dev->dev->bus->sprom.r1.
+			if (dev->dev->bus->sprom.
 			    boardflags_lo & B43_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;
Index: linux-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/dma.c
+++ linux-2.6/drivers/net/wireless/b43/dma.c
@@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct 
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ssb_dma_translation(ring->dev->dev);
+	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -183,6 +183,8 @@ static void op64_fill_descriptor(struct 
 	desc->dma64.control1 = cpu_to_le32(ctl1);
 	desc->dma64.address_low = cpu_to_le32(addrlo);
 	desc->dma64.address_high = cpu_to_le32(addrhi);
+//	printk(KERN_INFO "b43: 64-bit descriptor - slot, address, ctrl0,"
+//		" ctrl1: %d 0x%.8X 0x%.8x 0x%.8X 0x%.8x\n", slot, addrhi, addrlo, ctl0, ctl1);
 }
 
 static void op64_poke_tx(struct b43_dmaring *ring, int slot)
@@ -289,6 +291,61 @@ static inline int request_slot(struct b4
 	return slot;
 }
 
+void b43_dump_dma_regs(struct b43_wldev *dev)
+{
+	struct b43_dmaring *ring;
+	u16 mmio_base;
+
+	ring = dev->dma.tx_ring0;
+	mmio_base = 0x200;
+	printk(KERN_INFO "b43: ring 0: TX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base), b43_read32(dev, mmio_base + 4), b43_read32(dev, mmio_base + 8),
+		b43_read32(dev, mmio_base + 12), b43_read32(dev, mmio_base + 16), b43_read32(dev, mmio_base + 20));	
+	printk(KERN_INFO "b43: ring 0: RX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base + 0x20), b43_read32(dev, mmio_base + 0x24), b43_read32(dev, mmio_base + 0x28),
+		b43_read32(dev, mmio_base + 0x2C), b43_read32(dev, mmio_base + 0x30), b43_read32(dev, mmio_base + 0x34));
+	ring = dev->dma.tx_ring1;
+	mmio_base = 0x240;
+	printk(KERN_INFO "b43: ring 1: TX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base), b43_read32(dev, mmio_base + 4), b43_read32(dev, mmio_base + 8),
+		b43_read32(dev, mmio_base + 12), b43_read32(dev, mmio_base + 16), b43_read32(dev, mmio_base + 20));	
+	printk(KERN_INFO "b43: ring 1: RX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base + 0x20), b43_read32(dev, mmio_base + 0x24), b43_read32(dev, mmio_base + 0x28),
+		b43_read32(dev, mmio_base + 0x2C), b43_read32(dev, mmio_base + 0x30), b43_read32(dev, mmio_base + 0x34));
+	ring = dev->dma.tx_ring2;
+	mmio_base = 0x280;
+	printk(KERN_INFO "b43: ring 2: TX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base), b43_read32(dev, mmio_base + 4), b43_read32(dev, mmio_base + 8),
+		b43_read32(dev, mmio_base + 12), b43_read32(dev, mmio_base + 16), b43_read32(dev, mmio_base + 20));	
+	printk(KERN_INFO "b43: ring 2: RX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base + 0x20), b43_read32(dev, mmio_base + 0x24), b43_read32(dev, mmio_base + 0x28),
+		b43_read32(dev, mmio_base + 0x2C), b43_read32(dev, mmio_base + 0x30), b43_read32(dev, mmio_base + 0x34));
+	ring = dev->dma.tx_ring3;
+	mmio_base = 0x2C0;
+	printk(KERN_INFO "b43: ring 3: TX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base), b43_read32(dev, mmio_base + 4), b43_read32(dev, mmio_base + 8),
+		b43_read32(dev, mmio_base + 12), b43_read32(dev, mmio_base + 16), b43_read32(dev, mmio_base + 20));	
+	printk(KERN_INFO "b43: ring 3: RX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base + 0x20), b43_read32(dev, mmio_base + 0x24), b43_read32(dev, mmio_base + 0x28),
+		b43_read32(dev, mmio_base + 0x2C), b43_read32(dev, mmio_base + 0x30), b43_read32(dev, mmio_base + 0x34));
+	ring = dev->dma.tx_ring4;
+	mmio_base = 0x300;
+	printk(KERN_INFO "b43: ring 4: TX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base), b43_read32(dev, mmio_base + 4), b43_read32(dev, mmio_base + 8),
+		b43_read32(dev, mmio_base + 12), b43_read32(dev, mmio_base + 16), b43_read32(dev, mmio_base + 20));	
+	printk(KERN_INFO "b43: ring 4: RX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base + 0x20), b43_read32(dev, mmio_base + 0x24), b43_read32(dev, mmio_base + 0x28),
+		b43_read32(dev, mmio_base + 0x2C), b43_read32(dev, mmio_base + 0x30), b43_read32(dev, mmio_base + 0x34));
+	ring = dev->dma.tx_ring5;
+	mmio_base = 0x340;
+	printk(KERN_INFO "b43: ring 5: TX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base), b43_read32(dev, mmio_base + 4), b43_read32(dev, mmio_base + 8),
+		b43_read32(dev, mmio_base + 12), b43_read32(dev, mmio_base + 16), b43_read32(dev, mmio_base + 20));	
+	printk(KERN_INFO "b43: ring 5: RX  0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X 0x%.8X\n",
+		b43_read32(dev, mmio_base + 0x20), b43_read32(dev, mmio_base + 0x24), b43_read32(dev, mmio_base + 0x28),
+		b43_read32(dev, mmio_base + 0x2C), b43_read32(dev, mmio_base + 0x30), b43_read32(dev, mmio_base + 0x34));
+}
+
 /* Mac80211-queue to b43-ring mapping */
 static struct b43_dmaring *priority_to_txring(struct b43_wldev *dev,
 					      int queue_priority)
@@ -426,14 +483,15 @@ static inline
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev = ring->dev->dev->dev;
+	int size = (ring->dma64) ? 8192 : B43_DMA_RINGMEMSIZE;
 
-	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
+	ring->descbase = dma_alloc_coherent(dev, size,
 					    &(ring->dmabase), GFP_KERNEL);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
 	}
-	memset(ring->descbase, 0, B43_DMA_RINGMEMSIZE);
+	memset(ring->descbase, 0, size);
 
 	return 0;
 }
@@ -441,8 +499,9 @@ static int alloc_ringmemory(struct b43_d
 static void free_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev = ring->dev->dev->dev;
+	int size = (ring->dma64) ? 8192 : B43_DMA_RINGMEMSIZE;
 
-	dma_free_coherent(dev, B43_DMA_RINGMEMSIZE,
+	dma_free_coherent(dev, size,
 			  ring->descbase, ring->dmabase);
 }
 
@@ -483,7 +542,7 @@ int b43_dmacontroller_rx_reset(struct b4
 	return 0;
 }
 
-/* Reset the RX DMA channel */
+/* Reset the TX DMA channel */
 int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
 {
 	int i;
@@ -636,18 +695,12 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase = (u64) (ring->dmabase);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value = B43_DMA64_TXENABLE;
-			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
-			    & B43_DMA64_TXADDREXT_MASK;
-			b43_dma_write(ring, B43_DMA64_TXCTL, value);
+			b43_dma_write(ring, B43_DMA64_TXCTL,
+				      B43_DMA64_TXENABLE);
 			b43_dma_write(ring, B43_DMA64_TXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+				      (ringbase >> 32));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -668,20 +721,15 @@ static int dmacontroller_setup(struct b4
 		if (ring->dma64) {
 			u64 ringbase = (u64) (ring->dmabase);
 
-			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
-			    >> SSB_DMA_TRANSLATION_SHIFT;
-			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
-			value |= B43_DMA64_RXENABLE;
-			value |= (addrext << B43_DMA64_RXADDREXT_SHIFT)
-			    & B43_DMA64_RXADDREXT_MASK;
+			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
+				| B43_DMA64_RXENABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
-				      ((ringbase >> 32) &
-				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
+				      (ringbase >> 32));
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -695,11 +743,12 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA32_RXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
 				      | trans);
-			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
+			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc32));
 		}
 	}
 
-      out:
+out:
 	return err;
 }
 
Index: linux-2.6/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/leds.c
+++ linux-2.6/drivers/net/wireless/b43legacy/leds.c
@@ -134,10 +134,10 @@ int b43legacy_leds_init(struct b43legacy
 	u8 sprom[4];
 	int i;
 
-	sprom[0] = dev->dev->bus->sprom.r1.gpio0;
-	sprom[1] = dev->dev->bus->sprom.r1.gpio1;
-	sprom[2] = dev->dev->bus->sprom.r1.gpio2;
-	sprom[3] = dev->dev->bus->sprom.r1.gpio3;
+	sprom[0] = dev->dev->bus->sprom.gpio0;
+	sprom[1] = dev->dev->bus->sprom.gpio1;
+	sprom[2] = dev->dev->bus->sprom.gpio2;
+	sprom[3] = dev->dev->bus->sprom.gpio3;
 
 	for (i = 0; i < B43legacy_NR_LEDS; i++) {
 		led = &(dev->leds[i]);
Index: linux-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1767,7 +1767,7 @@ static int b43legacy_gpio_init(struct b4
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_PACTRL) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43legacy_BFL_PACTRL) {
 		b43legacy_write16(dev, B43legacy_MMIO_GPIO_MASK,
 				  b43legacy_read16(dev,
 				  B43legacy_MMIO_GPIO_MASK)
@@ -2140,7 +2140,7 @@ static void b43legacy_periodic_every120s
 static void b43legacy_periodic_every60sec(struct b43legacy_wldev *dev)
 {
 	b43legacy_phy_lo_mark_all_unused(dev);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_RSSI) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43legacy_BFL_RSSI) {
 		b43legacy_mac_suspend(dev);
 		b43legacy_calc_nrssi_slope(dev);
 		b43legacy_mac_enable(dev);
@@ -3153,7 +3153,7 @@ static int b43legacy_wireless_core_init(
 		hf |= B43legacy_HF_SYMW;
 		if (phy->rev == 1)
 			hf |= B43legacy_HF_GDCW;
-		if (sprom->r1.boardflags_lo & B43legacy_BFL_PACTRL)
+		if (sprom->boardflags_lo & B43legacy_BFL_PACTRL)
 			hf |= B43legacy_HF_OFDMPABOOST;
 	} else if (phy->type == B43legacy_PHYTYPE_B) {
 		hf |= B43legacy_HF_SYMW;
@@ -3637,12 +3637,12 @@ static void b43legacy_sprom_fixup(struct
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E &&
 	    bus->boardinfo.rev > 0x40)
-		bus->sprom.r1.boardflags_lo |= B43legacy_BFL_PACTRL;
+		bus->sprom.boardflags_lo |= B43legacy_BFL_PACTRL;
 
 	/* Convert Antennagain values to Q5.2 */
-	if (bus->sprom.r1.antenna_gain_bg == 0xFF)
-		bus->sprom.r1.antenna_gain_bg = 2; /* if unset, use 2 dBm */
-	bus->sprom.r1.antenna_gain_bg <<= 2;
+	if (bus->sprom.antenna_gain_bg == 0xFF)
+		bus->sprom.antenna_gain_bg = 2; /* if unset, use 2 dBm */
+	bus->sprom.antenna_gain_bg <<= 2;
 }
 
 static void b43legacy_wireless_exit(struct ssb_device *dev,
@@ -3677,10 +3677,10 @@ static int b43legacy_wireless_init(struc
 	hw->max_noise = -110;
 	hw->queues = 1; /* FIXME: hardware has more queues */
 	SET_IEEE80211_DEV(hw, dev->dev);
-	if (is_valid_ether_addr(sprom->r1.et1mac))
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
+	if (is_valid_ether_addr(sprom->et1mac))
+		SET_IEEE80211_PERM_ADDR(hw, sprom->et1mac);
 	else
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
+		SET_IEEE80211_PERM_ADDR(hw, sprom->il0mac);
 
 	/* Get and initialize struct b43legacy_wl */
 	wl = hw_to_b43legacy_wl(hw);
Index: linux-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/phy.c
+++ linux-2.6/drivers/net/wireless/b43legacy/phy.c
@@ -441,7 +441,7 @@ static void b43legacy_phy_inita(struct b
 	might_sleep();
 
 	b43legacy_phy_setupg(dev);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_PACTRL)
+	if (dev->dev->bus->sprom.boardflags_lo & B43legacy_BFL_PACTRL)
 		b43legacy_phy_write(dev, 0x046E, 0x03CF);
 }
 
@@ -543,7 +543,7 @@ static void b43legacy_phy_initb4(struct 
 	if (phy->radio_ver == 0x2050)
 		b43legacy_phy_write(dev, 0x002A, 0x88C2);
 	b43legacy_radio_set_txpower_bg(dev, 0xFFFF, 0xFFFF, 0xFFFF);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_RSSI) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43legacy_BFL_RSSI) {
 		b43legacy_calc_nrssi_slope(dev);
 		b43legacy_calc_nrssi_threshold(dev);
 	}
@@ -699,7 +699,7 @@ static void b43legacy_phy_initb6(struct 
 		b43legacy_radio_write16(dev, 0x005A, 0x0088);
 		b43legacy_radio_write16(dev, 0x005B, 0x006B);
 		b43legacy_radio_write16(dev, 0x005C, 0x000F);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & 0x8000) {
+		if (dev->dev->bus->sprom.boardflags_lo & 0x8000) {
 			b43legacy_radio_write16(dev, 0x005D, 0x00FA);
 			b43legacy_radio_write16(dev, 0x005E, 0x00D8);
 		} else {
@@ -797,7 +797,7 @@ static void b43legacy_phy_initb6(struct 
 		b43legacy_phy_write(dev, 0x0062, 0x0007);
 		b43legacy_radio_init2050(dev);
 		b43legacy_phy_lo_g_measure(dev);
-		if (dev->dev->bus->sprom.r1.boardflags_lo &
+		if (dev->dev->bus->sprom.boardflags_lo &
 		    B43legacy_BFL_RSSI) {
 			b43legacy_calc_nrssi_slope(dev);
 			b43legacy_calc_nrssi_threshold(dev);
@@ -921,7 +921,7 @@ static void b43legacy_calc_loopback_gain
 			    b43legacy_phy_read(dev, 0x0811) | 0x0100);
 	b43legacy_phy_write(dev, 0x0812,
 			    b43legacy_phy_read(dev, 0x0812) & 0xCFFF);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_EXTLNA) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43legacy_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
 			b43legacy_phy_write(dev, 0x0811,
 					    b43legacy_phy_read(dev, 0x0811)
@@ -1072,7 +1072,7 @@ static void b43legacy_phy_initg(struct b
 			b43legacy_phy_write(dev, 0x0036,
 					    (b43legacy_phy_read(dev, 0x0036)
 					     & 0x0FFF) | (phy->txctl2 << 12));
-		if (dev->dev->bus->sprom.r1.boardflags_lo &
+		if (dev->dev->bus->sprom.boardflags_lo &
 		    B43legacy_BFL_PACTRL)
 			b43legacy_phy_write(dev, 0x002E, 0x8075);
 		else
@@ -1087,7 +1087,7 @@ static void b43legacy_phy_initg(struct b
 		b43legacy_phy_write(dev, 0x080F, 0x8078);
 	}
 
-	if (!(dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_RSSI)) {
+	if (!(dev->dev->bus->sprom.boardflags_lo & B43legacy_BFL_RSSI)) {
 		/* The specs state to update the NRSSI LT with
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
@@ -1838,9 +1838,9 @@ void b43legacy_phy_xmitpower(struct b43l
 
 	estimated_pwr = b43legacy_phy_estimate_power_out(dev, average);
 
-	max_pwr = dev->dev->bus->sprom.r1.maxpwr_bg;
+	max_pwr = dev->dev->bus->sprom.maxpwr_bg;
 
-	if ((dev->dev->bus->sprom.r1.boardflags_lo
+	if ((dev->dev->bus->sprom.boardflags_lo
 	     & B43legacy_BFL_PACTRL) &&
 	    (phy->type == B43legacy_PHYTYPE_G))
 		max_pwr -= 0x3;
@@ -1848,7 +1848,7 @@ void b43legacy_phy_xmitpower(struct b43l
 		b43legacywarn(dev->wl, "Invalid max-TX-power value in SPROM."
 			"\n");
 		max_pwr = 74; /* fake it */
-		dev->dev->bus->sprom.r1.maxpwr_bg = max_pwr;
+		dev->dev->bus->sprom.maxpwr_bg = max_pwr;
 	}
 
 	/* Use regulatory information to get the maximum power.
@@ -1858,7 +1858,7 @@ void b43legacy_phy_xmitpower(struct b43l
 	 * and 1.5 dBm (a safety factor??). The result is in Q5.2 format
 	 * which accounts for the factor of 4 */
 #define REG_MAX_PWR 20
-	max_pwr = min(REG_MAX_PWR * 4 - dev->dev->bus->sprom.r1.antenna_gain_bg
+	max_pwr = min(REG_MAX_PWR * 4 - dev->dev->bus->sprom.antenna_gain_bg
 		      - 0x6, max_pwr);
 
 	/* find the desired power in Q5.2 - power_level is in dBm
@@ -1918,7 +1918,7 @@ void b43legacy_phy_xmitpower(struct b43l
 				txpower = 3;
 				radio_attenuation += 2;
 				baseband_attenuation += 2;
-			} else if (dev->dev->bus->sprom.r1.boardflags_lo
+			} else if (dev->dev->bus->sprom.boardflags_lo
 				   & B43legacy_BFL_PACTRL) {
 				baseband_attenuation += 4 *
 						     (radio_attenuation - 2);
@@ -2000,9 +2000,9 @@ int b43legacy_phy_init_tssi2dbm_table(st
 
 	B43legacy_WARN_ON(!(phy->type == B43legacy_PHYTYPE_B ||
 			  phy->type == B43legacy_PHYTYPE_G));
-	pab0 = (s16)(dev->dev->bus->sprom.r1.pa0b0);
-	pab1 = (s16)(dev->dev->bus->sprom.r1.pa0b1);
-	pab2 = (s16)(dev->dev->bus->sprom.r1.pa0b2);
+	pab0 = (s16)(dev->dev->bus->sprom.pa0b0);
+	pab1 = (s16)(dev->dev->bus->sprom.pa0b1);
+	pab2 = (s16)(dev->dev->bus->sprom.pa0b2);
 
 	if ((dev->dev->bus->chip_id == 0x4301) && (phy->radio_ver != 0x2050)) {
 		phy->idle_tssi = 0x34;
@@ -2013,9 +2013,9 @@ int b43legacy_phy_init_tssi2dbm_table(st
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
-		if ((s8)dev->dev->bus->sprom.r1.itssi_bg != 0 &&
-		    (s8)dev->dev->bus->sprom.r1.itssi_bg != -1)
-			phy->idle_tssi = (s8)(dev->dev->bus->sprom.r1.itssi_bg);
+		if ((s8)dev->dev->bus->sprom.itssi_bg != 0 &&
+		    (s8)dev->dev->bus->sprom.itssi_bg != -1)
+			phy->idle_tssi = (s8)(dev->dev->bus->sprom.itssi_bg);
 		else
 			phy->idle_tssi = 62;
 		dyn_tssi2dbm = kmalloc(64, GFP_KERNEL);
Index: linux-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/radio.c
+++ linux-2.6/drivers/net/wireless/b43legacy/radio.c
@@ -827,7 +827,7 @@ void b43legacy_calc_nrssi_threshold(stru
 	case B43legacy_PHYTYPE_B: {
 		if (phy->radio_ver != 0x2050)
 			return;
-		if (!(dev->dev->bus->sprom.r1.boardflags_lo &
+		if (!(dev->dev->bus->sprom.boardflags_lo &
 		    B43legacy_BFL_RSSI))
 			return;
 
@@ -857,7 +857,7 @@ void b43legacy_calc_nrssi_threshold(stru
 	}
 	case B43legacy_PHYTYPE_G:
 		if (!phy->gmode ||
-		    !(dev->dev->bus->sprom.r1.boardflags_lo &
+		    !(dev->dev->bus->sprom.boardflags_lo &
 		    B43legacy_BFL_RSSI)) {
 			tmp16 = b43legacy_nrssi_hw_read(dev, 0x20);
 			if (tmp16 >= 0x20)
@@ -1406,7 +1406,7 @@ static u16 b43legacy_get_812_value(struc
 	if (!phy->gmode)
 		return 0;
 	if (!has_loopback_gain(phy)) {
-		if (phy->rev < 7 || !(dev->dev->bus->sprom.r1.boardflags_lo
+		if (phy->rev < 7 || !(dev->dev->bus->sprom.boardflags_lo
 		    & B43legacy_BFL_EXTLNA)) {
 			switch (lpd) {
 			case LPD(0, 1, 1):
@@ -1459,7 +1459,7 @@ static u16 b43legacy_get_812_value(struc
 		}
 
 		loop_or = (loop << 8) | extern_lna_control;
-		if (phy->rev >= 7 && dev->dev->bus->sprom.r1.boardflags_lo
+		if (phy->rev >= 7 && dev->dev->bus->sprom.boardflags_lo
 		    & B43legacy_BFL_EXTLNA) {
 			if (extern_lna_control)
 				loop_or |= 0x8000;
@@ -1550,7 +1550,7 @@ u16 b43legacy_radio_init2050(struct b43l
 					    b43legacy_get_812_value(dev,
 					    LPD(0, 1, 1)));
 			if (phy->rev < 7 ||
-			    !(dev->dev->bus->sprom.r1.boardflags_lo
+			    !(dev->dev->bus->sprom.boardflags_lo
 			    & B43legacy_BFL_EXTLNA))
 				b43legacy_phy_write(dev, 0x0811, 0x01B3);
 			else
@@ -1786,7 +1786,7 @@ int b43legacy_radio_selectchannel(struct
 			  channel2freq_bg(channel));
 
 	if (channel == 14) {
-		if (dev->dev->bus->sprom.r1.country_code == 5)   /* JAPAN) */
+		if (dev->dev->bus->sprom.country_code == 5)   /* JAPAN) */
 			b43legacy_shm_write32(dev, B43legacy_SHM_SHARED,
 					      B43legacy_UCODEFLAGS_OFFSET,
 					      b43legacy_shm_read32(dev,
Index: linux-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ linux-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -378,7 +378,7 @@ static s8 b43legacy_rssi_postprocess(str
 			else
 				tmp -= 3;
 		} else {
-			if (dev->dev->bus->sprom.r1.boardflags_lo
+			if (dev->dev->bus->sprom.boardflags_lo
 			    & B43legacy_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;

