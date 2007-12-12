Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34750 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXLLVH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 16:07:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH #2] b43: Fix for broken transmission
Date: Wed, 12 Dec 2007 22:05:18 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712122205.19240.mb@bu3sch.de> (sfid-20071212_210728_949169_BE7BFDF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the transmission problems introduced by
commit f04b3787bbce4567e28069a9ec97dcd804626ac7

I'm not sure if the dummy read is really required.
The old code does it. I think it can't hurt and can possibly
fix some write posting problems (hardware bugs or whatever. Who knows).

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-2.6/drivers/net/wireless/b43/wa.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/wa.c	2007-12-11 01:08:40.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/wa.c	2007-12-11 16:18:44.000000000 +0100
@@ -123,17 +123,24 @@ static void b43_wa_rssi_lt(struct b43_wl
 {
 	int i;
 
-	for (i = 0; i < 8; i++)
-		b43_ofdmtab_write16(dev, B43_OFDMTAB_RSSI, i, i + 8);
-	for (i = 8; i < 16; i++)
-		b43_ofdmtab_write16(dev, B43_OFDMTAB_RSSI, i, i - 8);
+	if (0 /* FIXME: For APHY.rev=2 this might be needed */) {
+		for (i = 0; i < 8; i++)
+			b43_ofdmtab_write16(dev, B43_OFDMTAB_RSSI, i, i + 8);
+		for (i = 8; i < 16; i++)
+			b43_ofdmtab_write16(dev, B43_OFDMTAB_RSSI, i, i - 8);
+	} else {
+		for (i = 0; i < 64; i++)
+			b43_ofdmtab_write16(dev, B43_OFDMTAB_RSSI, i, i);
+	}
 }
 
 static void b43_wa_analog(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	u16 ofdmrev;
 
-	if (phy->analog > 2) {
+	ofdmrev = b43_phy_read(dev, B43_PHY_VERSION_OFDM) & B43_PHYVER_VERSION;
+	if (ofdmrev > 2) {
 		if (phy->type == B43_PHYTYPE_A)
 			b43_phy_write(dev, B43_PHY_PWRDOWN, 0x1808);
 		else
@@ -306,16 +313,16 @@ static void b43_wa_crs_ed(struct b43_wld
 	struct b43_phy *phy = &dev->phy;
 
 	if (phy->rev == 1) {
-		b43_phy_write(dev, B43_PHY_CRSTHRES1, 0x4F19);
+		b43_phy_write(dev, B43_PHY_CRSTHRES1_R1, 0x4F19);
 	} else if (phy->rev == 2) {
-		b43_phy_write(dev, B43_PHY_CRSTHRES1_R1, 0x1861);
-		b43_phy_write(dev, B43_PHY_CRSTHRES2_R1, 0x1861);
+		b43_phy_write(dev, B43_PHY_CRSTHRES1, 0x1861);
+		b43_phy_write(dev, B43_PHY_CRSTHRES2, 0x0271);
 		b43_phy_write(dev, B43_PHY_ANTDWELL,
 				  b43_phy_read(dev, B43_PHY_ANTDWELL)
 				  | 0x0800);
 	} else {
-		b43_phy_write(dev, B43_PHY_CRSTHRES1_R1, 0x0098);
-		b43_phy_write(dev, B43_PHY_CRSTHRES2_R1, 0x0070);
+		b43_phy_write(dev, B43_PHY_CRSTHRES1, 0x0098);
+		b43_phy_write(dev, B43_PHY_CRSTHRES2, 0x0070);
 		b43_phy_write(dev, B43_PHY_OFDM(0xC9), 0x0080);
 		b43_phy_write(dev, B43_PHY_ANTDWELL,
 				  b43_phy_read(dev, B43_PHY_ANTDWELL)
@@ -441,7 +448,7 @@ static void b43_wa_altagc(struct b43_wld
 		}
 	}
 	b43_phy_write(dev, B43_PHY_DIVSRCHIDX,
-		(b43_phy_read(dev, B43_PHY_DIVSRCHIDX) & 0x7F7F) | 0x7874);
+		(b43_phy_read(dev, B43_PHY_DIVSRCHIDX) & 0x8080) | 0x7874);
 	b43_phy_write(dev, B43_PHY_OFDM(0x8E), 0x1C00);
 	if (phy->rev == 1) {
 		b43_phy_write(dev, B43_PHY_DIVP1P2GAIN,
@@ -466,6 +473,7 @@ static void b43_wa_altagc(struct b43_wld
 		b43_phy_write(dev, B43_PHY_OFDM(0x26),
 			b43_phy_read(dev, B43_PHY_OFDM(0x26)) & ~0x1000);
 	}
+	b43_phy_read(dev, B43_PHY_VERSION_OFDM); /* Dummy read */
 }
 
 static void b43_wa_tr_ltov(struct b43_wldev *dev) /* TR Lookup Table Original Values */
Index: wireless-2.6/drivers/net/wireless/b43/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.h	2007-12-11 01:08:40.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/phy.h	2007-12-11 14:07:59.000000000 +0100
@@ -25,7 +25,7 @@ struct b43_phy;
 #define  B43_PHY_BBANDCFG_RXANT		0x180	/* RX Antenna selection */
 #define  B43_PHY_BBANDCFG_RXANT_SHIFT	7
 #define B43_PHY_PWRDOWN			B43_PHY_OFDM(0x03)	/* Powerdown */
-#define B43_PHY_CRSTHRES1		B43_PHY_OFDM(0x06)	/* CRS Threshold 1 */
+#define B43_PHY_CRSTHRES1_R1		B43_PHY_OFDM(0x06)	/* CRS Threshold 1 (phy.rev 1 only) */
 #define B43_PHY_LNAHPFCTL		B43_PHY_OFDM(0x1C)	/* LNA/HPF control */
 #define B43_PHY_LPFGAINCTL		B43_PHY_OFDM(0x20)	/* LPF Gain control */
 #define B43_PHY_ADIVRELATED		B43_PHY_OFDM(0x27)	/* FIXME rename */
@@ -69,8 +69,8 @@ struct b43_phy;
 #define B43_PHY_DIVP1P2GAIN		B43_PHY_OFDM(0xAB)
 #define B43_PHY_DIVSRCHGAINBACK		B43_PHY_OFDM(0xAD)	/* Divider search gain back */
 #define B43_PHY_DIVSRCHGAINCHNG		B43_PHY_OFDM(0xAE)	/* Divider search gain change */
-#define B43_PHY_CRSTHRES1_R1		B43_PHY_OFDM(0xC0)	/* CRS Threshold 1 (rev 1 only) */
-#define B43_PHY_CRSTHRES2_R1		B43_PHY_OFDM(0xC1)	/* CRS Threshold 2 (rev 1 only) */
+#define B43_PHY_CRSTHRES1		B43_PHY_OFDM(0xC0)	/* CRS Threshold 1 (phy.rev >= 2 only) */
+#define B43_PHY_CRSTHRES2		B43_PHY_OFDM(0xC1)	/* CRS Threshold 2 (phy.rev >= 2 only) */
 #define B43_PHY_TSSIP_LTBASE		B43_PHY_OFDM(0x380)	/* TSSI power lookup table base */
 #define B43_PHY_DC_LTBASE		B43_PHY_OFDM(0x3A0)	/* DC lookup table base */
 #define B43_PHY_GAIN_LTBASE		B43_PHY_OFDM(0x3C0)	/* Gain lookup table base */
Index: wireless-2.6/drivers/net/wireless/b43/tables.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/tables.c	2007-12-11 12:57:39.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/tables.c	2007-12-11 12:57:40.000000000 +0100
@@ -403,7 +403,7 @@ void b43_ofdmtab_write16(struct b43_wlde
 
 	addr = table + offset;
 	if ((phy->ofdmtab_addr_direction != B43_OFDMTAB_DIRECTION_WRITE) ||
-	    (addr -1 != phy->ofdmtab_addr)) {
+	    (addr - 1 != phy->ofdmtab_addr)) {
 		/* The hardware has a different address in memory. Update it. */
 		b43_phy_write(dev, B43_PHY_OTABLECTL, addr);
 		phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_WRITE;

-- 
Greetings Michael.
