Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYHTWpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 18:45:07 -0400
Date: Wed, 20 Aug 2008 17:45:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Clean up extraction of MAC addresses from SPROM
Message-ID: <48ac9e72.4qL3A3C1AOiGC/YJ%Larry.Finger@lwfinger.net> (sfid-20080821_004512_062410_38469937)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only rev 1 and 2 ssb SPROMs have fields named et0mac and et1mac;
however, all of the extraction routines extract pseudo data for these
fields from regions that are all 1's resulting in a hardware address
of FF:FF:FF:FF:FF:FF. This patch forces such a fill at the beginning of
the data extraction process, and only does the formal extraction if the
SPROM rev is 1 or 2.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28 material.

Larry
---

Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -327,11 +327,9 @@ static void sprom_extract_r123(struct ss
 	s8 gain;
 	u16 loc[3];
 
-	if (out->revision == 3) {			/* rev 3 moved MAC */
+	if (out->revision == 3)			/* rev 3 moved MAC */
 		loc[0] = SSB_SPROM3_IL0MAC;
-		loc[1] = SSB_SPROM3_ET0MAC;
-		loc[2] = SSB_SPROM3_ET1MAC;
-	} else {
+	else {
 		loc[0] = SSB_SPROM1_IL0MAC;
 		loc[1] = SSB_SPROM1_ET0MAC;
 		loc[2] = SSB_SPROM1_ET1MAC;
@@ -340,13 +338,15 @@ static void sprom_extract_r123(struct ss
 		v = in[SPOFF(loc[0]) + i];
 		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(loc[1]) + i];
-		*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
-	}
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(loc[2]) + i];
-		*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
+	if (out->revision < 3) { 	/* only rev 1-2 have et0, et1 */
+		for (i = 0; i < 3; i++) {
+			v = in[SPOFF(loc[1]) + i];
+			*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
+		}
+		for (i = 0; i < 3; i++) {
+			v = in[SPOFF(loc[2]) + i];
+			*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
+		}
 	}
 	SPEX(et0phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1A,
@@ -409,19 +409,11 @@ static void sprom_extract_r45(struct ssb
 		il0mac_offset = SSB_SPROM4_IL0MAC;
 	else
 		il0mac_offset = SSB_SPROM5_IL0MAC;
-	/* extract the equivalent of the r1 variables */
+	/* extract the MAC address */
 	for (i = 0; i < 3; i++) {
 		v = in[SPOFF(il0mac_offset) + i];
 		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM4_ET0MAC) + i];
-		*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
-	}
-	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM4_ET1MAC) + i];
-		*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
-	}
 	SPEX(et0phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET0A, 0);
 	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
 	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
@@ -482,6 +474,8 @@ static int sprom_extract(struct ssb_bus
 
 	out->revision = in[size - 1] & 0x00FF;
 	ssb_dprintk(KERN_DEBUG PFX "SPROM revision %d detected.\n", out->revision);
+	memset(out->et0mac, 0xFF, 6);		/* preset et0 and et1 mac */
+	memset(out->et1mac, 0xFF, 6);
 	if ((bus->chip_id & 0xFF00) == 0x4400) {
 		/* Workaround: The BCM44XX chip has a stupid revision
 		 * number stored in the SPROM.
Index: wireless-testing/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_regs.h
+++ wireless-testing/include/linux/ssb/ssb_regs.h
@@ -245,8 +245,6 @@
 
 /* SPROM Revision 3 (inherits most data from rev 2) */
 #define SSB_SPROM3_IL0MAC		0x104A	/* 6 bytes MAC address for 802.11b/g */
-#define SSB_SPROM3_ET0MAC		0x1050	/* 6 bytes MAC address for Ethernet ?? */
-#define SSB_SPROM3_ET1MAC		0x1050	/* 6 bytes MAC address for 802.11a ?? */
 #define SSB_SPROM3_OFDMAPO		0x102C	/* A-PHY OFDM Mid Power Offset (4 bytes, BigEndian) */
 #define SSB_SPROM3_OFDMALPO		0x1030	/* A-PHY OFDM Low Power Offset (4 bytes, BigEndian) */
 #define SSB_SPROM3_OFDMAHPO		0x1034	/* A-PHY OFDM High Power Offset (4 bytes, BigEndian) */
@@ -267,8 +265,6 @@
 
 /* SPROM Revision 4 */
 #define SSB_SPROM4_IL0MAC		0x104C	/* 6 byte MAC address for a/b/g/n */
-#define SSB_SPROM4_ET0MAC		0x1018	/* 6 bytes MAC address for Ethernet ?? */
-#define SSB_SPROM4_ET1MAC		0x1018	/* 6 bytes MAC address for 802.11a ?? */
 #define SSB_SPROM4_ETHPHY		0x105A	/* Ethernet PHY settings ?? */
 #define  SSB_SPROM4_ETHPHY_ET0A		0x001F	/* MII Address for enet0 */
 #define  SSB_SPROM4_ETHPHY_ET1A		0x03E0	/* MII Address for enet1 */

