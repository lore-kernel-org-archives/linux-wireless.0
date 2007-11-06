Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37469 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbXKFTON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:14:13 -0500
Date: Tue, 06 Nov 2007 13:14:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 1 of 6] ssb: Add new SPROM structure while keeping the old
Message-ID: <4730bd03.rGmiNlJ18XBoW/Yb%Larry.Finger@lwfinger.net> (sfid-20071106_191415_354788_8566A20C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patch 1 of 6.

The SPROM's for various devices utilizing the Sonics Silicon Backplane come
with various revisions. The Revision 2 SPROM inherited the data layout of 1, and
Revision 3 inherited the layout of 2. The first instance of Revision 4 has
now been found in a BCM4328 wireless LAN card. This device does not inherit any
layout from previous versions. Although it was possible to create a data
structure that kept all the old layouts, we decided to start fresh, keep only
those SPROM variables that are used by the drivers that utilize ssb, and to
do the conversion in such a manner that neither compilation or execution will
be affected if a bisection lands in the middle of these changes, while keeping
the patches as small as possible.

In this patch, the sprom structures are changed while maintaining the old ones.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/include/linux/ssb/ssb.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb.h
+++ wireless-2.6/include/linux/ssb/ssb.h
@@ -78,8 +78,32 @@ struct ssb_sprom_r3 {
 	u32 ofdmgpo;		/* G-PHY OFDM Power Offset */
 };
 
-struct ssb_sprom_r4 {
-	/* TODO */
+struct ssb_sprom_data {
+	u8 il0mac[6];		/* MAC address for 802.11b/g */
+	u8 et0mac[6];		/* MAC address for Ethernet */
+	u8 et1mac[6];		/* MAC address for 802.11a */
+	u8 et0phyaddr:5;	/* MII address for enet0 */
+	u8 et1phyaddr:5;	/* MII address for enet1 */
+	u8 country_code;	/* Country Code */
+	u16 pa0b0;
+	u16 pa0b1;
+	u16 pa0b2;
+	u16 pa1b0;
+	u16 pa1b1;
+	u16 pa1b2;
+	u8 gpio0;		/* GPIO pin 0 */
+	u8 gpio1;		/* GPIO pin 1 */
+	u8 gpio2;		/* GPIO pin 2 */
+	u8 gpio3;		/* GPIO pin 3 */
+	u16 maxpwr_a;		/* A-PHY Amplifier Max Power (in dBm Q5.2) */
+	u16 maxpwr_bg;		/* B/G-PHY Amplifier Max Power (in dBm Q5.2) */
+	u8 itssi_a;		/* Idle TSSI Target for A-PHY */
+	u8 itssi_bg;		/* Idle TSSI Target for B/G-PHY */
+	u16 boardflags_lo;	/* Boardflags (low 16 bits) */
+	u8 antenna_gain_a;	/* A-PHY Antenna gain (in dBm Q5.2) */
+	u8 antenna_gain_bg;	/* B/G-PHY Antenna gain (in dBm Q5.2) */
+
+	/* TODO - add any parameters needed from rev 2, 3, or 4 SPROMs */
 };
 
 struct ssb_sprom {
@@ -94,8 +118,8 @@ struct ssb_sprom {
 			struct ssb_sprom_r2 r2;
 			struct ssb_sprom_r3 r3;
 		};
-		struct ssb_sprom_r4 r4;
 	};
+	struct ssb_sprom_data data;
 };
 
 /* Information about the PCB the circuitry is soldered on. */
Index: wireless-2.6/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb_regs.h
+++ wireless-2.6/include/linux/ssb/ssb_regs.h
@@ -250,6 +250,38 @@
 #define  SSB_SPROM3_CCKPO_11M		0xF000	/* 11M Rate PO */
 #define  SSB_SPROM3_CCKPO_11M_SHIFT	12
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
+/* SPROM Revision 4 */
+#define SSB_SPROM4_IL0MAC		0x104C	/* 6 byte MAC address for b/g */
+#define SSB_SPROM4_ETHPHY		0x105A	/* Ethernet PHY settings */
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
+#define SSB_SPROM4_BFLHI		0x1046  /* Board Flags Hi */
+#define SSB_SPROM4_MAXP_A		0x1000  /* Max Power A */
+#define SSB_SPROM4_MAXP_A_HI		0x00FF  /* Mask for Hi */
+#define SSB_SPROM4_MAXP_A_LO		0xFF00  /* Mask for Lo */
+#define SSB_SPROM4_MAXP_A_LO_SHIFT	16	/* Shift for Lo */
+#define SSB_SPROM4_PA1LOB0		0x1000
+#define SSB_SPROM4_PA1LOB1		0x1000
+#define SSB_SPROM4_PA1LOB2		0x1000
+#define SSB_SPROM4_PA1HIB0		0x1000
+#define SSB_SPROM4_PA1HIB1		0x1000
+#define SSB_SPROM4_PA1HIB2		0x1000
+#define SSB_SPROM4_OPO			0x1000
+#define SSB_SPROM4_OPO_VALUE		0x0000
+#define SSB_SPROM4_GPIOLDC		0x105A	/* LED Powersave Duty Cycle */
+#define  SSB_SPROM4_GPIOLDC_OFF		0x0000FF00	/* Off Count */
+#define  SSB_SPROM4_GPIOLDC_OFF_SHIFT	8
+#define  SSB_SPROM4_GPIOLDC_ON		0x00FF0000	/* On Count */
+#define  SSB_SPROM4_GPIOLDC_ON_SHIFT	16
+
 
 /* Values for SSB_SPROM1_BINF_CCODE */
 enum {
