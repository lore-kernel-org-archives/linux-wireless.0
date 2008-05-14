Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:33834 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYENS4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:56:41 -0400
Received: by wf-out-1314.google.com with SMTP id 27so20423wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:56:40 -0700 (PDT)
Subject: [PATCH 1/5] b43: phy.c use b43_phy_set where possible
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 11:56:34 -0700
Message-Id: <1210791394.6191.33.camel@brick> (sfid-20080514_205646_972689_12C6F93A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  197 ++++++++++++++--------------------------
 1 files changed, 70 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 8b3c24d..f27eb5e 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -595,8 +595,7 @@ static void hardware_pctl_init_gphy(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0014, 0x0000);
 
 	B43_WARN_ON(phy->rev < 6);
-	b43_phy_write(dev, 0x0478, b43_phy_read(dev, 0x0478)
-		      | 0x0800);
+	b43_phy_set(dev, 0x0478, 0x0800);
 	b43_phy_write(dev, 0x0478, b43_phy_read(dev, 0x0478)
 		      & 0xFEFF);
 	b43_phy_write(dev, 0x0801, b43_phy_read(dev, 0x0801)
@@ -641,23 +640,19 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 
 	b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036) & 0xFEFF);
 	b43_phy_write(dev, 0x002F, 0x0202);
-	b43_phy_write(dev, 0x047C, b43_phy_read(dev, 0x047C) | 0x0002);
-	b43_phy_write(dev, 0x047A, b43_phy_read(dev, 0x047A) | 0xF000);
+	b43_phy_set(dev, 0x047C, 0x0002);
+	b43_phy_set(dev, 0x047A, 0xF000);
 	if (phy->radio_ver == 0x2050 && phy->radio_rev == 8) {
 		b43_phy_write(dev, 0x047A, (b43_phy_read(dev, 0x047A)
 					    & 0xFF0F) | 0x0010);
-		b43_phy_write(dev, 0x005D, b43_phy_read(dev, 0x005D)
-			      | 0x8000);
+		b43_phy_set(dev, 0x005D, 0x8000);
 		b43_phy_write(dev, 0x004E, (b43_phy_read(dev, 0x004E)
 					    & 0xFFC0) | 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
-		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
-			      | 0x0400);
+		b43_phy_set(dev, 0x0036, 0x0400);
 	} else {
-		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
-			      | 0x0200);
-		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
-			      | 0x0400);
+		b43_phy_set(dev, 0x0036, 0x0200);
+		b43_phy_set(dev, 0x0036, 0x0400);
 		b43_phy_write(dev, 0x005D, b43_phy_read(dev, 0x005D)
 			      & 0x7FFF);
 		b43_phy_write(dev, 0x004F, b43_phy_read(dev, 0x004F)
@@ -781,8 +776,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 
 	b43_phy_write(dev, B43_PHY_CRS0,
 		b43_phy_read(dev, B43_PHY_CRS0) & ~B43_PHY_CRS0_EN);
-	b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-		b43_phy_read(dev, B43_PHY_OFDM(0x1B)) | 0x1000);
+	b43_phy_set(dev, B43_PHY_OFDM(0x1B), 0x1000);
 	b43_phy_write(dev, B43_PHY_OFDM(0x82),
 		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & 0xF0FF) | 0x0300);
 	b43_radio_write16(dev, 0x0009,
@@ -831,8 +825,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0x0E, 0x0011);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0x0F, 0x0013);
 	b43_phy_write(dev, B43_PHY_OFDM(0x33), 0x5030);
-	b43_phy_write(dev, B43_PHY_CRS0,
-		b43_phy_read(dev, B43_PHY_CRS0) | B43_PHY_CRS0_EN);
+	b43_phy_set(dev, B43_PHY_CRS0, B43_PHY_CRS0_EN);
 }
 
 /* Initialize APHY. This is also called for the GPHY in some cases. */
@@ -848,8 +841,7 @@ static void b43_phy_inita(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_OFDM(0x1B),
 				b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x1000);
 		if (b43_phy_read(dev, B43_PHY_ENCORE) & B43_PHY_ENCORE_EN)
-			b43_phy_write(dev, B43_PHY_ENCORE,
-				b43_phy_read(dev, B43_PHY_ENCORE) | 0x0010);
+			b43_phy_set(dev, B43_PHY_ENCORE, 0x0010);
 		else
 			b43_phy_write(dev, B43_PHY_ENCORE,
 				b43_phy_read(dev, B43_PHY_ENCORE) & ~0x1010);
@@ -859,12 +851,10 @@ static void b43_phy_inita(struct b43_wldev *dev)
 
 	if (phy->type == B43_PHYTYPE_A) {
 		if (phy->gmode && (phy->rev < 3))
-			b43_phy_write(dev, 0x0034,
-				b43_phy_read(dev, 0x0034) | 0x0001);
+			b43_phy_set(dev, 0x0034, 0x0001);
 		b43_phy_rssiagc(dev, 0);
 
-		b43_phy_write(dev, B43_PHY_CRS0,
-			b43_phy_read(dev, B43_PHY_CRS0) | B43_PHY_CRS0_EN);
+		b43_phy_set(dev, B43_PHY_CRS0, B43_PHY_CRS0_EN);
 
 		b43_radio_init2060(dev);
 
@@ -925,8 +915,8 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 		}
 		b43_write16(dev, B43_MMIO_PHY_RADIO, 0x0000);
 
-		b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) | 0x0100);
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) | 0x2000);
+		b43_phy_set(dev, 0x0802, 0x0100);
+		b43_phy_set(dev, 0x042B, 0x2000);
 
 		b43_phy_write(dev, 0x001C, 0x186A);
 
@@ -938,11 +928,8 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 			      (b43_phy_read(dev, 0x005D) & 0xFF80) | 0x000A);
 	}
 
-	if (dev->bad_frames_preempt) {
-		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-			      b43_phy_read(dev,
-					   B43_PHY_RADIO_BITFIELD) | (1 << 11));
-	}
+	if (dev->bad_frames_preempt)
+		b43_phy_set(dev, B43_PHY_RADIO_BITFIELD, (1 << 11));
 
 	if (phy->analog == 1) {
 		b43_phy_write(dev, 0x0026, 0xCE00);
@@ -1062,8 +1049,8 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 				  b43_radio_read16(dev, 0x007A) | 0x0020);
 		b43_radio_write16(dev, 0x0051,
 				  b43_radio_read16(dev, 0x0051) | 0x0004);
-		b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) | 0x0100);
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) | 0x2000);
+		b43_phy_set(dev, 0x0802, 0x0100);
+		b43_phy_set(dev, 0x042B, 0x2000);
 		b43_phy_write(dev, 0x5B, 0);
 		b43_phy_write(dev, 0x5C, 0);
 	}
@@ -1156,34 +1143,26 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 
 	b43_phy_write(dev, B43_PHY_CRS0,
 		      b43_phy_read(dev, B43_PHY_CRS0) & 0x3FFF);
-	b43_phy_write(dev, B43_PHY_CCKBBANDCFG,
-		      b43_phy_read(dev, B43_PHY_CCKBBANDCFG) | 0x8000);
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0002);
+	b43_phy_set(dev, B43_PHY_CCKBBANDCFG, 0x8000);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0002);
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xFFFD);
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0001);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0001);
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xFFFE);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0001);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0001);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
 			      b43_phy_read(dev,
 					   B43_PHY_ANALOGOVERVAL) & 0xFFFE);
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0002);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0002);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
 			      b43_phy_read(dev,
 					   B43_PHY_ANALOGOVERVAL) & 0xFFFD);
 	}
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x000C);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) | 0x000C);
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0030);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x000C);
+	b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x000C);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0030);
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
 		       & 0xFFCF) | 0x10);
@@ -1195,8 +1174,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_CCK(0x0A),
 		      b43_phy_read(dev, B43_PHY_CCK(0x0A)) | 0x2000);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0004);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0004);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
 			      b43_phy_read(dev,
 					   B43_PHY_ANALOGOVERVAL) & 0xFFFB);
@@ -1227,19 +1205,14 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
 		       & 0xC0FF) | 0x800);
 
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0100);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0100);
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xCFFF);
 
 	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
-			b43_phy_write(dev, B43_PHY_RFOVER,
-				      b43_phy_read(dev, B43_PHY_RFOVER)
-				      | 0x0800);
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      b43_phy_read(dev, B43_PHY_RFOVERVAL)
-				      | 0x8000);
+			b43_phy_set(dev, B43_PHY_RFOVER, 0x0800);
+			b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x8000);
 		}
 	}
 	b43_radio_write16(dev, 0x7A, b43_radio_read16(dev, 0x7A)
@@ -1256,9 +1229,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_PGACTL,
 				      (b43_phy_read(dev, B43_PHY_PGACTL)
 				       & 0x0FFF) | 0xA000);
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      b43_phy_read(dev, B43_PHY_PGACTL)
-				      | 0xF000);
+			b43_phy_set(dev, B43_PHY_PGACTL, 0xF000);
 			udelay(20);
 			if (b43_phy_read(dev, B43_PHY_LO_LEAKAGE) >= 0xDFC)
 				goto exit_loop1;
@@ -1268,9 +1239,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	loop1_outer_done = i;
 	loop1_inner_done = j;
 	if (j >= 8) {
-		b43_phy_write(dev, B43_PHY_RFOVERVAL,
-			      b43_phy_read(dev, B43_PHY_RFOVERVAL)
-			      | 0x30);
+		b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x0030);
 		trsw_rx = 0x1B;
 		for (j = j - 8; j < 16; j++) {
 			b43_phy_write(dev, B43_PHY_RFOVERVAL,
@@ -1279,9 +1248,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_PGACTL,
 				      (b43_phy_read(dev, B43_PHY_PGACTL)
 				       & 0x0FFF) | 0xA000);
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      b43_phy_read(dev, B43_PHY_PGACTL)
-				      | 0xF000);
+			b43_phy_set(dev, B43_PHY_PGACTL, 0xF000);
 			udelay(20);
 			trsw_rx -= 3;
 			if (b43_phy_read(dev, B43_PHY_LO_LEAKAGE) >= 0xDFC)
@@ -1364,12 +1331,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
 	if ((phy->rev <= 2 && phy->gmode) || phy->rev >= 2)
 		b43_phy_write(dev, B43_PHY_OFDM(0x7E), 0x78);
 	if (phy->radio_rev == 8) {
-		b43_phy_write(dev, B43_PHY_EXTG(0x01),
-			      b43_phy_read(dev, B43_PHY_EXTG(0x01))
-			      | 0x80);
-		b43_phy_write(dev, B43_PHY_OFDM(0x3E),
-			      b43_phy_read(dev, B43_PHY_OFDM(0x3E))
-			      | 0x4);
+		b43_phy_set(dev, B43_PHY_EXTG(0x01), 0x0080);
+		b43_phy_set(dev, B43_PHY_OFDM(0x3E), 0x0004);
 	}
 	if (has_loopback_gain(phy))
 		b43_calc_loopback_gain(dev);
@@ -2322,7 +2285,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) & 0x7FFF);
 	b43_phy_write(dev, 0x0001,
 		      (b43_phy_read(dev, 0x0001) & 0x3FFF) | 0x4000);
-	b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x000C);
+	b43_phy_set(dev, 0x0811, 0x000C);
 	b43_phy_write(dev, 0x0812,
 		      (b43_phy_read(dev, 0x0812) & 0xFFF3) | 0x0004);
 	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & ~(0x1 | 0x2));
@@ -2340,10 +2303,10 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x002F, 0);
 		b43_phy_write(dev, 0x080F, 0);
 		b43_phy_write(dev, 0x0810, 0);
-		b43_phy_write(dev, 0x0478, b43_phy_read(dev, 0x0478) | 0x0100);
-		b43_phy_write(dev, 0x0801, b43_phy_read(dev, 0x0801) | 0x0040);
-		b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060) | 0x0040);
-		b43_phy_write(dev, 0x0014, b43_phy_read(dev, 0x0014) | 0x0200);
+		b43_phy_set(dev, 0x0478, 0x0100);
+		b43_phy_set(dev, 0x0801, 0x0040);
+		b43_phy_set(dev, 0x0060, 0x0040);
+		b43_phy_set(dev, 0x0014, 0x0200);
 	}
 	b43_radio_write16(dev, 0x007A, b43_radio_read16(dev, 0x007A) | 0x0070);
 	b43_radio_write16(dev, 0x007A, b43_radio_read16(dev, 0x007A) | 0x0080);
@@ -2369,27 +2332,25 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) & 0x007F);
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-			b43_phy_write(dev, 0x0814,
-				      b43_phy_read(dev, 0x0814) | 0x0001);
+			b43_phy_set(dev, 0x0814, 0x0001);
 			b43_phy_write(dev, 0x0815,
 				      b43_phy_read(dev, 0x0815) & 0xFFFE);
 		}
-		b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x000C);
-		b43_phy_write(dev, 0x0812, b43_phy_read(dev, 0x0812) | 0x000C);
-		b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x0030);
-		b43_phy_write(dev, 0x0812, b43_phy_read(dev, 0x0812) | 0x0030);
+		b43_phy_set(dev, 0x0811, 0x000C);
+		b43_phy_set(dev, 0x0812, 0x000C);
+		b43_phy_set(dev, 0x0811, 0x0030);
+		b43_phy_set(dev, 0x0812, 0x0030);
 		b43_phy_write(dev, 0x005A, 0x0480);
 		b43_phy_write(dev, 0x0059, 0x0810);
 		b43_phy_write(dev, 0x0058, 0x000D);
-		if (phy->rev == 0) {
+
+		if (phy->rev == 0)
 			b43_phy_write(dev, 0x0003, 0x0122);
-		} else {
-			b43_phy_write(dev, 0x000A, b43_phy_read(dev, 0x000A)
-				      | 0x2000);
-		}
+		else
+			b43_phy_set(dev, 0x000A, 0x2000);
+
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-			b43_phy_write(dev, 0x0814,
-				      b43_phy_read(dev, 0x0814) | 0x0004);
+			b43_phy_set(dev, 0x0814, 0x0004);
 			b43_phy_write(dev, 0x0815,
 				      b43_phy_read(dev, 0x0815) & 0xFFFB);
 		}
@@ -2440,8 +2401,8 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0003, backup[9]);
 	b43_radio_write16(dev, 0x0043, backup[11]);
 	b43_radio_write16(dev, 0x007A, backup[10]);
-	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) | 0x1 | 0x2);
-	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) | 0x8000);
+	b43_phy_set(dev, 0x0802, 0x0003);
+	b43_phy_set(dev, 0x0429, 0x8000);
 	b43_set_original_gains(dev);
 	if (phy->rev >= 6) {
 		b43_phy_write(dev, 0x0801, backup[16]);
@@ -2484,7 +2445,7 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x0030, 0x00FF);
 		b43_write16(dev, 0x03EC, 0x7F7F);
 		b43_phy_write(dev, 0x0026, 0x0000);
-		b43_phy_write(dev, 0x0015, b43_phy_read(dev, 0x0015) | 0x0020);
+		b43_phy_set(dev, 0x0015, 0x0020);
 		b43_phy_write(dev, 0x002A, 0x08A3);
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) | 0x0080);
@@ -2574,12 +2535,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 			case 4:
 			case 6:
 			case 7:
-				b43_phy_write(dev, 0x0478,
-					      b43_phy_read(dev, 0x0478)
-					      | 0x0100);
-				b43_phy_write(dev, 0x0801,
-					      b43_phy_read(dev, 0x0801)
-					      | 0x0040);
+				b43_phy_set(dev, 0x0478, 0x0100);
+				b43_phy_set(dev, 0x0801, 0x0040);
 				break;
 			case 3:
 			case 5:
@@ -2588,10 +2545,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 					      & 0xFFBF);
 				break;
 			}
-			b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060)
-				      | 0x0040);
-			b43_phy_write(dev, 0x0014, b43_phy_read(dev, 0x0014)
-				      | 0x0200);
+			b43_phy_set(dev, 0x0060, 0x0040);
+			b43_phy_set(dev, 0x0014, 0x0200);
 		}
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) | 0x0070);
@@ -2684,11 +2639,9 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x0059, backup[5]);
 		b43_phy_write(dev, 0x0058, backup[6]);
 		b43_synth_pu_workaround(dev, phy->channel);
-		b43_phy_write(dev, 0x0802,
-			      b43_phy_read(dev, 0x0802) | (0x0001 | 0x0002));
+		b43_phy_set(dev, 0x0802, 0x0003);
 		b43_set_original_gains(dev);
-		b43_phy_write(dev, B43_PHY_G_CRS,
-			      b43_phy_read(dev, B43_PHY_G_CRS) | 0x8000);
+		b43_phy_set(dev, B43_PHY_G_CRS, 0x8000);
 		if (phy->rev >= 3) {
 			b43_phy_write(dev, 0x0801, backup[14]);
 			b43_phy_write(dev, 0x0060, backup[15]);
@@ -2882,8 +2835,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 	switch (mode) {
 	case B43_INTERFMODE_NONWLAN:
 		if (phy->rev != 1) {
-			b43_phy_write(dev, 0x042B,
-				      b43_phy_read(dev, 0x042B) | 0x0800);
+			b43_phy_set(dev, 0x042B, 0x0800);
 			b43_phy_write(dev, B43_PHY_G_CRS,
 				      b43_phy_read(dev,
 						   B43_PHY_G_CRS) & ~0x4000);
@@ -2905,10 +2857,8 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		phy_stacksave(0x0406);
 		b43_phy_write(dev, 0x0406, 0x7E28);
 
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) | 0x0800);
-		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-			      b43_phy_read(dev,
-					   B43_PHY_RADIO_BITFIELD) | 0x1000);
+		b43_phy_set(dev, 0x042B, 0x0800);
+		b43_phy_set(dev, B43_PHY_RADIO_BITFIELD, 0x1000);
 
 		phy_stacksave(0x04A0);
 		b43_phy_write(dev, 0x04A0,
@@ -3045,15 +2995,13 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 			b43_phy_write(dev, 0x0417, (b43_phy_read(dev, 0x0417)
 						    & 0xFE00) | 0x016D);
 		} else {
-			b43_phy_write(dev, 0x048A, b43_phy_read(dev, 0x048A)
-				      | 0x1000);
+			b43_phy_set(dev, 0x048A, 0x1000);
 			b43_phy_write(dev, 0x048A, (b43_phy_read(dev, 0x048A)
 						    & 0x9FFF) | 0x2000);
 			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_ACIW);
 		}
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B)
-				      | 0x0800);
+			b43_phy_set(dev, 0x042B, 0x0800);
 		}
 		b43_phy_write(dev, 0x048C, (b43_phy_read(dev, 0x048C)
 					    & 0xF0FF) | 0x0200);
@@ -3086,9 +3034,7 @@ b43_radio_interference_mitigation_disable(struct b43_wldev *dev, int mode)
 		if (phy->rev != 1) {
 			b43_phy_write(dev, 0x042B,
 				      b43_phy_read(dev, 0x042B) & ~0x0800);
-			b43_phy_write(dev, B43_PHY_G_CRS,
-				      b43_phy_read(dev,
-						   B43_PHY_G_CRS) | 0x4000);
+			b43_phy_set(dev, B43_PHY_G_CRS, 0x4000);
 			break;
 		}
 		radio_stackrestore(0x0078);
@@ -3100,8 +3046,7 @@ b43_radio_interference_mitigation_disable(struct b43_wldev *dev, int mode)
 				      b43_phy_read(dev, B43_PHY_RADIO_BITFIELD)
 				      & ~(1 << 11));
 		}
-		b43_phy_write(dev, B43_PHY_G_CRS,
-			      b43_phy_read(dev, B43_PHY_G_CRS) | 0x4000);
+		b43_phy_set(dev, B43_PHY_G_CRS, 0x4000);
 		phy_stackrestore(0x04A0);
 		phy_stackrestore(0x04A1);
 		phy_stackrestore(0x04A2);
@@ -3409,9 +3354,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 		sav.phy_crs0 = b43_phy_read(dev, B43_PHY_CRS0);
 		sav.phy_classctl = b43_phy_read(dev, B43_PHY_CLASSCTL);
 
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER)
-			      | 0x0003);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0003);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
 			      b43_phy_read(dev, B43_PHY_ANALOGOVERVAL)
 			      & 0xFFFC);
@@ -3897,8 +3840,8 @@ void b43_radio_turn_off(struct b43_wldev *dev, bool force)
 	case B43_PHYTYPE_A:
 		b43_radio_write16(dev, 0x0004, 0x00FF);
 		b43_radio_write16(dev, 0x0005, 0x00FB);
-		b43_phy_write(dev, 0x0010, b43_phy_read(dev, 0x0010) | 0x0008);
-		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) | 0x0008);
+		b43_phy_set(dev, 0x0010, 0x0008);
+		b43_phy_set(dev, 0x0011, 0x0008);
 		break;
 	case B43_PHYTYPE_G: {
 		u16 rfover, rfoverval;
-- 
1.5.5.1.482.g0f174


