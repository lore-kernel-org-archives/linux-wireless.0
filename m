Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbXKFTRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:17:01 -0500
Date: Tue, 06 Nov 2007 13:17:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 6 of 6] ssb: Remove the old, now unused, data structure
Message-ID: <4730bdac.Oup0h41hJ0GHVCxr%Larry.Finger@lwfinger.net> (sfid-20071106_191706_185480_8B5F1424)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 6 of 6.

The old, now unused, data structures and SPROM extraction routines
are removed.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/include/linux/ssb/ssb.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb.h
+++ wireless-2.6/include/linux/ssb/ssb.h
@@ -15,69 +15,6 @@ struct pcmcia_device;
 struct ssb_bus;
 struct ssb_driver;
 
-
-struct ssb_sprom_r1 {
-	u16 pci_spid;		/* Subsystem Product ID for PCI */
-	u16 pci_svid;		/* Subsystem Vendor ID for PCI */
-	u16 pci_pid;		/* Product ID for PCI */
-	u8 il0mac[6];		/* MAC address for 802.11b/g */
-	u8 et0mac[6];		/* MAC address for Ethernet */
-	u8 et1mac[6];		/* MAC address for 802.11a */
-	u8 et0phyaddr:5;	/* MII address for enet0 */
-	u8 et1phyaddr:5;	/* MII address for enet1 */
-	u8 et0mdcport:1;	/* MDIO for enet0 */
-	u8 et1mdcport:1;	/* MDIO for enet1 */
-	u8 board_rev;		/* Board revision */
-	u8 country_code:4;	/* Country Code */
-	u8 antenna_a:2;		/* Antenna 0/1 available for A-PHY */
-	u8 antenna_bg:2;	/* Antenna 0/1 available for B-PHY and G-PHY */
-	u16 pa0b0;
-	u16 pa0b1;
-	u16 pa0b2;
-	u16 pa1b0;
-	u16 pa1b1;
-	u16 pa1b2;
-	u8 gpio0;		/* GPIO pin 0 */
-	u8 gpio1;		/* GPIO pin 1 */
-	u8 gpio2;		/* GPIO pin 2 */
-	u8 gpio3;		/* GPIO pin 3 */
-	u16 maxpwr_a;		/* A-PHY Power Amplifier Max Power (in dBm Q5.2) */
-	u16 maxpwr_bg;		/* B/G-PHY Power Amplifier Max Power (in dBm Q5.2) */
-	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
-	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
-	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
-	u8 antenna_gain_a;	/* A-PHY Antenna gain (in dBm Q5.2) */
-	u8 antenna_gain_bg;	/* B/G-PHY Antenna gain (in dBm Q5.2) */
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
-
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
 struct ssb_sprom_data {
 	u8 il0mac[6];		/* MAC address for 802.11b/g */
 	u8 et0mac[6];		/* MAC address for Ethernet */
@@ -109,16 +46,6 @@ struct ssb_sprom_data {
 struct ssb_sprom {
 	u8 revision;
 	u8 crc;
-	/* The valid r# fields are selected by the "revision".
-	 * Revision 3 and lower inherit from lower revisions.
-	 */
-	union {
-		struct {
-			struct ssb_sprom_r1 r1;
-			struct ssb_sprom_r2 r2;
-			struct ssb_sprom_r3 r3;
-		};
-	};
 	struct ssb_sprom_data data;
 };
 
Index: wireless-2.6/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb_regs.h
+++ wireless-2.6/include/linux/ssb/ssb_regs.h
@@ -173,10 +173,7 @@
 #define  SSB_SPROM_REVISION_REV		0x00FF	/* SPROM Revision number */
 #define  SSB_SPROM_REVISION_CRC		0xFF00	/* SPROM CRC8 value */
 #define  SSB_SPROM_REVISION_CRC_SHIFT	8
-/* SPROM Revision 1 */
-#define SSB_SPROM1_SPID			0x1004	/* Subsystem Product ID for PCI */
-#define SSB_SPROM1_SVID			0x1006	/* Subsystem Vendor ID for PCI */
-#define SSB_SPROM1_PID			0x1008	/* Product ID for PCI */
+/* SPROM Revision 1 - aslo used for Revisions 2 & 3 */
 #define SSB_SPROM1_IL0MAC		0x1048	/* 6 bytes MAC address for 802.11b/g */
 #define SSB_SPROM1_ET0MAC		0x104E	/* 6 bytes MAC address for Ethernet */
 #define SSB_SPROM1_ET1MAC		0x1054	/* 6 bytes MAC address for 802.11a */
@@ -184,8 +181,6 @@
 #define  SSB_SPROM1_ETHPHY_ET0A		0x001F	/* MII Address for enet0 */
 #define  SSB_SPROM1_ETHPHY_ET1A		0x03E0	/* MII Address for enet1 */
 #define  SSB_SPROM1_ETHPHY_ET1A_SHIFT	5
-#define  SSB_SPROM1_ETHPHY_ET0M		(1<<14)	/* MDIO for enet0 */
-#define  SSB_SPROM1_ETHPHY_ET1M		(1<<15)	/* MDIO for enet1 */
 #define SSB_SPROM1_BINF			0x105C	/* Board info */
 #define  SSB_SPROM1_BINF_BREV		0x00FF	/* Board Revision */
 #define  SSB_SPROM1_BINF_CCODE		0x0F00	/* Country Code */
@@ -221,41 +216,6 @@
 #define  SSB_SPROM1_AGAIN_A		0x00FF	/* A-PHY */
 #define  SSB_SPROM1_AGAIN_BG		0xFF00	/* B-PHY and G-PHY */
 #define  SSB_SPROM1_AGAIN_BG_SHIFT	8
-#define SSB_SPROM1_OEM			0x1076	/* 8 bytes OEM string (rev 1 only) */
-/* SPROM Revision 2 (inherits from rev 1) */
-#define SSB_SPROM2_BFLHI		0x1038	/* Boardflags (high 16 bits) */
-#define SSB_SPROM2_MAXP_A		0x103A	/* A-PHY Max Power */
-#define  SSB_SPROM2_MAXP_A_HI		0x00FF	/* Max Power High */
-#define  SSB_SPROM2_MAXP_A_LO		0xFF00	/* Max Power Low */
-#define  SSB_SPROM2_MAXP_A_LO_SHIFT	8
-#define SSB_SPROM2_PA1LOB0		0x103C	/* A-PHY PowerAmplifier Low Settings */
-#define SSB_SPROM2_PA1LOB1		0x103E	/* A-PHY PowerAmplifier Low Settings */
-#define SSB_SPROM2_PA1LOB2		0x1040	/* A-PHY PowerAmplifier Low Settings */
-#define SSB_SPROM2_PA1HIB0		0x1042	/* A-PHY PowerAmplifier High Settings */
-#define SSB_SPROM2_PA1HIB1		0x1044	/* A-PHY PowerAmplifier High Settings */
-#define SSB_SPROM2_PA1HIB2		0x1046	/* A-PHY PowerAmplifier High Settings */
-#define SSB_SPROM2_OPO			0x1078	/* OFDM Power Offset from CCK Level */
-#define  SSB_SPROM2_OPO_VALUE		0x00FF
-#define  SSB_SPROM2_OPO_UNUSED		0xFF00
-#define SSB_SPROM2_CCODE		0x107C	/* Two char Country Code */
-/* SPROM Revision 3 (inherits from rev 2) */
-#define SSB_SPROM3_OFDMAPO		0x102C	/* A-PHY OFDM Mid Power Offset (4 bytes, BigEndian) */
-#define SSB_SPROM3_OFDMALPO		0x1030	/* A-PHY OFDM Low Power Offset (4 bytes, BigEndian) */
-#define SSB_SPROM3_OFDMAHPO		0x1034	/* A-PHY OFDM High Power Offset (4 bytes, BigEndian) */
-#define SSB_SPROM3_GPIOLDC		0x1042	/* GPIO LED Powersave Duty Cycle (4 bytes, BigEndian) */
-#define  SSB_SPROM3_GPIOLDC_OFF		0x0000FF00	/* Off Count */
-#define  SSB_SPROM3_GPIOLDC_OFF_SHIFT	8
-#define  SSB_SPROM3_GPIOLDC_ON		0x00FF0000	/* On Count */
-#define  SSB_SPROM3_GPIOLDC_ON_SHIFT	16
-#define SSB_SPROM3_CCKPO		0x1078	/* CCK Power Offset */
-#define  SSB_SPROM3_CCKPO_1M		0x000F	/* 1M Rate PO */
-#define  SSB_SPROM3_CCKPO_2M		0x00F0	/* 2M Rate PO */
-#define  SSB_SPROM3_CCKPO_2M_SHIFT	4
-#define  SSB_SPROM3_CCKPO_55M		0x0F00	/* 5.5M Rate PO */
-#define  SSB_SPROM3_CCKPO_55M_SHIFT	8
-#define  SSB_SPROM3_CCKPO_11M		0xF000	/* 11M Rate PO */
-#define  SSB_SPROM3_CCKPO_11M_SHIFT	12
-#define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 /* SPROM Revision 4 */
 #define SSB_SPROM4_IL0MAC		0x104C	/* 6 byte MAC address for b/g */
 #define SSB_SPROM4_ETHPHY		0x105A	/* Ethernet PHY settings */
Index: wireless-2.6/drivers/ssb/pci.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/pci.c
+++ wireless-2.6/drivers/ssb/pci.c
@@ -297,62 +297,6 @@ err_ctlreg:
 	return err;
 }
 
-static void sprom_extract_r1(struct ssb_sprom_r1 *out, const u16 *in)
-{
-	int i;
-	u16 v;
-
-	SPEX(pci_spid, SSB_SPROM1_SPID, 0xFFFF, 0);
-	SPEX(pci_svid, SSB_SPROM1_SVID, 0xFFFF, 0);
-	SPEX(pci_pid, SSB_SPROM1_PID, 0xFFFF, 0);
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
-		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
-	}
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_ET0MAC) + i];
-		*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
-	}
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_ET1MAC) + i];
-		*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
-	}
-	SPEX(et0phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0A, 0);
-	SPEX(et1phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1A,
-	     SSB_SPROM1_ETHPHY_ET1A_SHIFT);
-	SPEX(et0mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0M, 14);
-	SPEX(et1mdcport, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1M, 15);
-	SPEX(board_rev, SSB_SPROM1_BINF, SSB_SPROM1_BINF_BREV, 0);
-	SPEX(country_code, SSB_SPROM1_BINF, SSB_SPROM1_BINF_CCODE,
-	     SSB_SPROM1_BINF_CCODE_SHIFT);
-	SPEX(antenna_a, SSB_SPROM1_BINF, SSB_SPROM1_BINF_ANTA,
-	     SSB_SPROM1_BINF_ANTA_SHIFT);
-	SPEX(antenna_bg, SSB_SPROM1_BINF, SSB_SPROM1_BINF_ANTBG,
-	     SSB_SPROM1_BINF_ANTBG_SHIFT);
-	SPEX(pa0b0, SSB_SPROM1_PA0B0, 0xFFFF, 0);
-	SPEX(pa0b1, SSB_SPROM1_PA0B1, 0xFFFF, 0);
-	SPEX(pa0b2, SSB_SPROM1_PA0B2, 0xFFFF, 0);
-	SPEX(pa1b0, SSB_SPROM1_PA1B0, 0xFFFF, 0);
-	SPEX(pa1b1, SSB_SPROM1_PA1B1, 0xFFFF, 0);
-	SPEX(pa1b2, SSB_SPROM1_PA1B2, 0xFFFF, 0);
-	SPEX(gpio0, SSB_SPROM1_GPIOA, SSB_SPROM1_GPIOA_P0, 0);
-	SPEX(gpio1, SSB_SPROM1_GPIOA, SSB_SPROM1_GPIOA_P1,
-	     SSB_SPROM1_GPIOA_P1_SHIFT);
-	SPEX(gpio2, SSB_SPROM1_GPIOB, SSB_SPROM1_GPIOB_P2, 0);
-	SPEX(gpio3, SSB_SPROM1_GPIOB, SSB_SPROM1_GPIOB_P3,
-	     SSB_SPROM1_GPIOB_P3_SHIFT);
-	SPEX(maxpwr_a, SSB_SPROM1_MAXPWR, SSB_SPROM1_MAXPWR_A,
-	     SSB_SPROM1_MAXPWR_A_SHIFT);
-	SPEX(maxpwr_bg, SSB_SPROM1_MAXPWR, SSB_SPROM1_MAXPWR_BG, 0);
-	SPEX(itssi_a, SSB_SPROM1_ITSSI, SSB_SPROM1_ITSSI_A,
-	     SSB_SPROM1_ITSSI_A_SHIFT);
-	SPEX(itssi_bg, SSB_SPROM1_ITSSI, SSB_SPROM1_ITSSI_BG, 0);
-	SPEX(boardflags_lo, SSB_SPROM1_BFLLO, 0xFFFF, 0);
-	SPEX(antenna_gain_a, SSB_SPROM1_AGAIN, SSB_SPROM1_AGAIN_A, 0);
-	SPEX(antenna_gain_bg, SSB_SPROM1_AGAIN, SSB_SPROM1_AGAIN_BG,
-	     SSB_SPROM1_AGAIN_BG_SHIFT);
-}
-
 static void sprom_extract_r123(struct ssb_sprom_data *out, const u16 *in,
 			       int rev)
 {
@@ -436,7 +380,6 @@ static int sprom_extract(struct ssb_bus 
 		/* Workaround: The BCM44XX chip has a stupid revision
 		 * number stored in the SPROM.
 		 * Always extract r1. */
-		sprom_extract_r1(&out->r1, in);
 		sprom_extract_r123(&out->data, in, out->revision);
 	} else if (bus->chip_id == 0x4321) {
 		/* the BCM4328 has a chipid == 0x4321 and a rev 4 SPROM */
@@ -445,10 +388,8 @@ static int sprom_extract(struct ssb_bus 
 	} else {
 		if (out->revision == 0)
 			goto unsupported;
-		if (out->revision >= 1 && out->revision <= 3) {
-			sprom_extract_r1(&out->r1, in);
+		if (out->revision >= 1 && out->revision <= 3)
 			sprom_extract_r123(&out->data, in, out->revision);
-		}
 		if (out->revision == 4)
 			sprom_extract_r4(&out->data, in);
 		if (out->revision >= 5)
@@ -459,7 +400,7 @@ static int sprom_extract(struct ssb_bus 
 unsupported:
 	ssb_printk(KERN_WARNING PFX "Unsupported SPROM revision %d "
 		   "detected. Will extract v1\n", out->revision);
-	sprom_extract_r1(&out->r1, in);
+	sprom_extract_r123(&out->data, in, 1);
 	return 0;
 }
 
