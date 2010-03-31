Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:44073 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab0CaUyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 16:54:01 -0400
Received: by ey-out-2122.google.com with SMTP id 9so171921eyd.5
        for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 13:53:59 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] ssb: Fix order of definitions and some text space indents
Date: Wed, 31 Mar 2010 22:54:19 +0200
Message-Id: <1270068859-6185-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1270068859-6185-2-git-send-email-zajec5@gmail.com>
References: <1270068859-6185-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/ssb/ssb_regs.h |   58 +++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 8990e30..a6d5225 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -245,7 +245,6 @@
 #define SSB_SPROM2_CCODE		0x007C	/* Two char Country Code */
 
 /* SPROM Revision 3 (inherits most data from rev 2) */
-#define SSB_SPROM3_IL0MAC		0x004A	/* 6 bytes MAC address for 802.11b/g */
 #define SSB_SPROM3_OFDMAPO		0x002C	/* A-PHY OFDM Mid Power Offset (4 bytes, BigEndian) */
 #define SSB_SPROM3_OFDMALPO		0x0030	/* A-PHY OFDM Low Power Offset (4 bytes, BigEndian) */
 #define SSB_SPROM3_OFDMAHPO		0x0034	/* A-PHY OFDM High Power Offset (4 bytes, BigEndian) */
@@ -254,6 +253,7 @@
 #define  SSB_SPROM3_GPIOLDC_OFF_SHIFT	8
 #define  SSB_SPROM3_GPIOLDC_ON		0x00FF0000	/* On Count */
 #define  SSB_SPROM3_GPIOLDC_ON_SHIFT	16
+#define SSB_SPROM3_IL0MAC		0x004A	/* 6 bytes MAC address for 802.11b/g */
 #define SSB_SPROM3_CCKPO		0x0078	/* CCK Power Offset */
 #define  SSB_SPROM3_CCKPO_1M		0x000F	/* 1M Rate PO */
 #define  SSB_SPROM3_CCKPO_2M		0x00F0	/* 2M Rate PO */
@@ -265,20 +265,29 @@
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 
 /* SPROM Revision 4 */
+#define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
+#define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
 #define SSB_SPROM4_IL0MAC		0x004C	/* 6 byte MAC address for a/b/g/n */
+#define SSB_SPROM4_CCODE		0x0052	/* Country Code (2 bytes) */
+#define SSB_SPROM4_GPIOA		0x0056	/* Gen. Purpose IO # 0 and 1 */
+#define  SSB_SPROM4_GPIOA_P0		0x00FF	/* Pin 0 */
+#define  SSB_SPROM4_GPIOA_P1		0xFF00	/* Pin 1 */
+#define  SSB_SPROM4_GPIOA_P1_SHIFT	8
+#define SSB_SPROM4_GPIOB		0x0058	/* Gen. Purpose IO # 2 and 3 */
+#define  SSB_SPROM4_GPIOB_P2		0x00FF	/* Pin 2 */
+#define  SSB_SPROM4_GPIOB_P3		0xFF00	/* Pin 3 */
+#define  SSB_SPROM4_GPIOB_P3_SHIFT	8
 #define SSB_SPROM4_ETHPHY		0x005A	/* Ethernet PHY settings ?? */
 #define  SSB_SPROM4_ETHPHY_ET0A		0x001F	/* MII Address for enet0 */
 #define  SSB_SPROM4_ETHPHY_ET1A		0x03E0	/* MII Address for enet1 */
 #define  SSB_SPROM4_ETHPHY_ET1A_SHIFT	5
 #define  SSB_SPROM4_ETHPHY_ET0M		(1<<14)	/* MDIO for enet0 */
 #define  SSB_SPROM4_ETHPHY_ET1M		(1<<15)	/* MDIO for enet1 */
-#define SSB_SPROM4_CCODE		0x0052	/* Country Code (2 bytes) */
 #define SSB_SPROM4_ANTAVAIL		0x005D  /* Antenna available bitfields */
-#define SSB_SPROM4_ANTAVAIL_A		0x00FF	/* A-PHY bitfield */
-#define SSB_SPROM4_ANTAVAIL_A_SHIFT	0
-#define SSB_SPROM4_ANTAVAIL_BG		0xFF00	/* B-PHY and G-PHY bitfield */
-#define SSB_SPROM4_ANTAVAIL_BG_SHIFT	8
-#define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
+#define  SSB_SPROM4_ANTAVAIL_A		0x00FF	/* A-PHY bitfield */
+#define  SSB_SPROM4_ANTAVAIL_A_SHIFT	0
+#define  SSB_SPROM4_ANTAVAIL_BG		0xFF00	/* B-PHY and G-PHY bitfield */
+#define  SSB_SPROM4_ANTAVAIL_BG_SHIFT	8
 #define SSB_SPROM4_AGAIN01		0x005E	/* Antenna Gain (in dBm Q5.2) */
 #define  SSB_SPROM4_AGAIN0		0x00FF	/* Antenna 0 */
 #define  SSB_SPROM4_AGAIN0_SHIFT	0
@@ -289,7 +298,6 @@
 #define  SSB_SPROM4_AGAIN2_SHIFT	0
 #define  SSB_SPROM4_AGAIN3		0xFF00	/* Antenna 3 */
 #define  SSB_SPROM4_AGAIN3_SHIFT	8
-#define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
 #define SSB_SPROM4_MAXP_BG		0x0080  /* Max Power BG in path 1 */
 #define  SSB_SPROM4_MAXP_BG_MASK	0x00FF  /* Mask for Max Power BG */
 #define  SSB_SPROM4_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */
@@ -298,14 +306,6 @@
 #define  SSB_SPROM4_MAXP_A_MASK		0x00FF  /* Mask for Max Power A */
 #define  SSB_SPROM4_ITSSI_A		0xFF00	/* Mask for path 1 itssi_a */
 #define  SSB_SPROM4_ITSSI_A_SHIFT	8
-#define SSB_SPROM4_GPIOA		0x0056	/* Gen. Purpose IO # 0 and 1 */
-#define  SSB_SPROM4_GPIOA_P0		0x00FF	/* Pin 0 */
-#define  SSB_SPROM4_GPIOA_P1		0xFF00	/* Pin 1 */
-#define  SSB_SPROM4_GPIOA_P1_SHIFT	8
-#define SSB_SPROM4_GPIOB		0x0058	/* Gen. Purpose IO # 2 and 3 */
-#define  SSB_SPROM4_GPIOB_P2		0x00FF	/* Pin 2 */
-#define  SSB_SPROM4_GPIOB_P3		0xFF00	/* Pin 3 */
-#define  SSB_SPROM4_GPIOB_P3_SHIFT	8
 #define SSB_SPROM4_PA0B0		0x0082	/* The paXbY locations are */
 #define SSB_SPROM4_PA0B1		0x0084	/*   only guesses */
 #define SSB_SPROM4_PA0B2		0x0086
@@ -314,10 +314,10 @@
 #define SSB_SPROM4_PA1B2		0x0092
 
 /* SPROM Revision 5 (inherits most data from rev 4) */
+#define SSB_SPROM5_CCODE		0x0044	/* Country Code (2 bytes) */
 #define SSB_SPROM5_BFLLO		0x004A	/* Boardflags (low 16 bits) */
 #define SSB_SPROM5_BFLHI		0x004C  /* Board Flags Hi */
 #define SSB_SPROM5_IL0MAC		0x0052	/* 6 byte MAC address for a/b/g/n */
-#define SSB_SPROM5_CCODE		0x0044	/* Country Code (2 bytes) */
 #define SSB_SPROM5_GPIOA		0x0076	/* Gen. Purpose IO # 0 and 1 */
 #define  SSB_SPROM5_GPIOA_P0		0x00FF	/* Pin 0 */
 #define  SSB_SPROM5_GPIOA_P1		0xFF00	/* Pin 1 */
@@ -335,11 +335,19 @@
 #define SSB_SPROM8_BFL2HI		0x008A	/* Board flags (bits 48-63) */
 #define SSB_SPROM8_IL0MAC		0x008C	/* 6 byte MAC address */
 #define SSB_SPROM8_CCODE		0x0092	/* 2 byte country code */
+#define SSB_SPROM8_GPIOA		0x0096	/*Gen. Purpose IO # 0 and 1 */
+#define  SSB_SPROM8_GPIOA_P0		0x00FF	/* Pin 0 */
+#define  SSB_SPROM8_GPIOA_P1		0xFF00	/* Pin 1 */
+#define  SSB_SPROM8_GPIOA_P1_SHIFT	8
+#define SSB_SPROM8_GPIOB		0x0098	/* Gen. Purpose IO # 2 and 3 */
+#define  SSB_SPROM8_GPIOB_P2		0x00FF	/* Pin 2 */
+#define  SSB_SPROM8_GPIOB_P3		0xFF00	/* Pin 3 */
+#define  SSB_SPROM8_GPIOB_P3_SHIFT	8
 #define SSB_SPROM8_ANTAVAIL		0x009C  /* Antenna available bitfields*/
-#define SSB_SPROM8_ANTAVAIL_A		0xFF00	/* A-PHY bitfield */
-#define SSB_SPROM8_ANTAVAIL_A_SHIFT	8
-#define SSB_SPROM8_ANTAVAIL_BG		0x00FF	/* B-PHY and G-PHY bitfield */
-#define SSB_SPROM8_ANTAVAIL_BG_SHIFT	0
+#define  SSB_SPROM8_ANTAVAIL_A		0xFF00	/* A-PHY bitfield */
+#define  SSB_SPROM8_ANTAVAIL_A_SHIFT	8
+#define  SSB_SPROM8_ANTAVAIL_BG		0x00FF	/* B-PHY and G-PHY bitfield */
+#define  SSB_SPROM8_ANTAVAIL_BG_SHIFT	0
 #define SSB_SPROM8_AGAIN01		0x009E	/* Antenna Gain (in dBm Q5.2) */
 #define  SSB_SPROM8_AGAIN0		0x00FF	/* Antenna 0 */
 #define  SSB_SPROM8_AGAIN0_SHIFT	0
@@ -350,14 +358,6 @@
 #define  SSB_SPROM8_AGAIN2_SHIFT	0
 #define  SSB_SPROM8_AGAIN3		0xFF00	/* Antenna 3 */
 #define  SSB_SPROM8_AGAIN3_SHIFT	8
-#define SSB_SPROM8_GPIOA		0x0096	/*Gen. Purpose IO # 0 and 1 */
-#define  SSB_SPROM8_GPIOA_P0		0x00FF	/* Pin 0 */
-#define  SSB_SPROM8_GPIOA_P1		0xFF00	/* Pin 1 */
-#define  SSB_SPROM8_GPIOA_P1_SHIFT	8
-#define SSB_SPROM8_GPIOB		0x0098	/* Gen. Purpose IO # 2 and 3 */
-#define  SSB_SPROM8_GPIOB_P2		0x00FF	/* Pin 2 */
-#define  SSB_SPROM8_GPIOB_P3		0xFF00	/* Pin 3 */
-#define  SSB_SPROM8_GPIOB_P3_SHIFT	8
 #define SSB_SPROM8_RSSIPARM2G		0x00A4	/* RSSI params for 2GHz */
 #define  SSB_SPROM8_RSSISMF2G		0x000F
 #define  SSB_SPROM8_RSSISMC2G		0x00F0
-- 
1.6.4.2

