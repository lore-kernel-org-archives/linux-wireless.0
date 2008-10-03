Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60844 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbYJCUs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:56 -0400
Received: by gxk9 with SMTP id 9so3172308gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:55 -0700 (PDT)
Subject: [PATCH 6/8] b43: use the phy set/mask helpers in phy_a.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:48 -0700
Message-Id: <1223066928.6512.31.camel@brick> (sfid-20081003_224909_785455_5F6CC140)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also eliminate a tmp variable.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy_a.c |   95 +++++++++++++------------------------
 1 files changed, 34 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index aafd5f6..3efa49d 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -210,12 +210,9 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	u16 b, curr_s, best_s = 0xFFFF;
 	int i;
 
-	b43_phy_write(dev, B43_PHY_CRS0,
-		b43_phy_read(dev, B43_PHY_CRS0) & ~B43_PHY_CRS0_EN);
-	b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-		b43_phy_read(dev, B43_PHY_OFDM(0x1B)) | 0x1000);
-	b43_phy_write(dev, B43_PHY_OFDM(0x82),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & 0xF0FF) | 0x0300);
+	b43_phy_mask(dev, B43_PHY_CRS0, ~B43_PHY_CRS0_EN);
+	b43_phy_set(dev, B43_PHY_OFDM(0x1B), 0x1000);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), 0xF0FF, 0x0300);
 	b43_radio_set(dev, 0x0009, 0x0080);
 	b43_radio_maskset(dev, 0x0012, 0xFFFC, 0x0002);
 	b43_wa_initgains(dev);
@@ -243,14 +240,10 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_OFDM(0xB5), 0x0EC0);
 	b43_phy_write(dev, B43_PHY_OFDM(0xB2), 0x00C0);
 	b43_phy_write(dev, B43_PHY_OFDM(0xB9), 0x1FFF);
-	b43_phy_write(dev, B43_PHY_OFDM(0xBB),
-		(b43_phy_read(dev, B43_PHY_OFDM(0xBB)) & 0xF000) | 0x0053);
-	b43_phy_write(dev, B43_PHY_OFDM61,
-		(b43_phy_read(dev, B43_PHY_OFDM61) & 0xFE1F) | 0x0120);
-	b43_phy_write(dev, B43_PHY_OFDM(0x13),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x13)) & 0x0FFF) | 0x3000);
-	b43_phy_write(dev, B43_PHY_OFDM(0x14),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x14)) & 0x0FFF) | 0x3000);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xBB), 0xF000, 0x0053);
+	b43_phy_maskset(dev, B43_PHY_OFDM61, 0xFE1F, 0x0120);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x13), 0x0FFF, 0x3000);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x14), 0x0FFF, 0x3000);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 6, 0x0017);
 	for (i = 0; i < 6; i++)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, i, 0x000F);
@@ -258,8 +251,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0x0E, 0x0011);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0x0F, 0x0013);
 	b43_phy_write(dev, B43_PHY_OFDM(0x33), 0x5030);
-	b43_phy_write(dev, B43_PHY_CRS0,
-		b43_phy_read(dev, B43_PHY_CRS0) | B43_PHY_CRS0_EN);
+	b43_phy_set(dev, B43_PHY_CRS0, B43_PHY_CRS0_EN);
 }
 
 static void hardware_pctl_init_aphy(struct b43_wldev *dev)
@@ -282,26 +274,21 @@ void b43_phy_inita(struct b43_wldev *dev)
 
 	if (phy->rev >= 6) {
 		if (phy->type == B43_PHYTYPE_A)
-			b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-				b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x1000);
+			b43_phy_mask(dev, B43_PHY_OFDM(0x1B), ~0x1000);
 		if (b43_phy_read(dev, B43_PHY_ENCORE) & B43_PHY_ENCORE_EN)
-			b43_phy_write(dev, B43_PHY_ENCORE,
-				b43_phy_read(dev, B43_PHY_ENCORE) | 0x0010);
+			b43_phy_set(dev, B43_PHY_ENCORE, 0x0010);
 		else
-			b43_phy_write(dev, B43_PHY_ENCORE,
-				b43_phy_read(dev, B43_PHY_ENCORE) & ~0x1010);
+			b43_phy_mask(dev, B43_PHY_ENCORE, ~0x1010);
 	}
 
 	b43_wa_all(dev);
 
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
 
@@ -321,9 +308,7 @@ void b43_phy_inita(struct b43_wldev *dev)
 
 	if ((phy->type == B43_PHYTYPE_G) &&
 	    (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)) {
-		b43_phy_write(dev, B43_PHY_OFDM(0x6E),
-				  (b43_phy_read(dev, B43_PHY_OFDM(0x6E))
-				   & 0xE000) | 0x3CF);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x6E), 0xE000, 0x3CF);
 	}
 }
 
@@ -502,14 +487,14 @@ static void b43_aphy_op_software_rfkill(struct b43_wldev *dev,
 			return;
 		b43_radio_write(dev, 0x0004, 0x00C0);
 		b43_radio_write(dev, 0x0005, 0x0008);
-		b43_phy_write(dev, 0x0010, b43_phy_read(dev, 0x0010) & 0xFFF7);
-		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) & 0xFFF7);
+		b43_phy_mask(dev, 0x0010, 0xFFF7);
+		b43_phy_mask(dev, 0x0011, 0xFFF7);
 		b43_radio_init2060(dev);
 	} else {
 		b43_radio_write(dev, 0x0004, 0x00FF);
 		b43_radio_write(dev, 0x0005, 0x00FB);
-		b43_phy_write(dev, 0x0010, b43_phy_read(dev, 0x0010) | 0x0008);
-		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) | 0x0008);
+		b43_phy_set(dev, 0x0010, 0x0008);
+		b43_phy_set(dev, 0x0011, 0x0008);
 	}
 }
 
@@ -532,7 +517,6 @@ static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 {//TODO
 	struct b43_phy *phy = &dev->phy;
 	u64 hf;
-	u16 tmp;
 	int autodiv = 0;
 
 	if (antenna == B43_ANTENNA_AUTO0 || antenna == B43_ANTENNA_AUTO1)
@@ -542,42 +526,31 @@ static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 	hf &= ~B43_HF_ANTDIVHELP;
 	b43_hf_write(dev, hf);
 
-	tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
-	tmp &= ~B43_PHY_BBANDCFG_RXANT;
-	tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
-	    << B43_PHY_BBANDCFG_RXANT_SHIFT;
-	b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
+	if (autodiv)
+		b43_phy_maskset(dev, B43_PHY_BBANDCFG, ~B43_PHY_BBANDCFG_RXANT,
+				(B43_ANTENNA_AUTO0 << B43_PHY_BBANDCFG_RXANT_SHIFT));
+	else
+		b43_phy_maskset(dev, B43_PHY_BBANDCFG, ~B43_PHY_BBANDCFG_RXANT,
+				(antenna << B43_PHY_BBANDCFG_RXANT_SHIFT));
 
 	if (autodiv) {
-		tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
 		if (antenna == B43_ANTENNA_AUTO0)
-			tmp &= ~B43_PHY_ANTDWELL_AUTODIV1;
+			b43_phy_mask(dev, B43_PHY_ANTDWELL,
+				     ~B43_PHY_ANTDWELL_AUTODIV1);
 		else
-			tmp |= B43_PHY_ANTDWELL_AUTODIV1;
-		b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
+			b43_phy_set(dev, B43_PHY_ANTDWELL,
+				    B43_PHY_ANTDWELL_AUTODIV1);
 	}
 	if (phy->rev < 3) {
-		tmp = b43_phy_read(dev, B43_PHY_ANTDWELL);
-		tmp = (tmp & 0xFF00) | 0x24;
-		b43_phy_write(dev, B43_PHY_ANTDWELL, tmp);
+		b43_phy_maskset(dev, B43_PHY_ANTDWELL, 0xFF00, 0x24);
 	} else {
-		tmp = b43_phy_read(dev, B43_PHY_OFDM61);
-		tmp |= 0x10;
-		b43_phy_write(dev, B43_PHY_OFDM61, tmp);
+		b43_phy_set(dev, B43_PHY_OFDM61, 0x10);
 		if (phy->analog == 3) {
-			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT,
-				      0x1D);
-			b43_phy_write(dev, B43_PHY_ADIVRELATED,
-				      8);
+			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT, 0x1D);
+			b43_phy_write(dev, B43_PHY_ADIVRELATED, 8);
 		} else {
-			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT,
-				      0x3A);
-			tmp =
-			    b43_phy_read(dev,
-					 B43_PHY_ADIVRELATED);
-			tmp = (tmp & 0xFF00) | 8;
-			b43_phy_write(dev, B43_PHY_ADIVRELATED,
-				      tmp);
+			b43_phy_write(dev, B43_PHY_CLIPPWRDOWNT, 0x3A);
+			b43_phy_maskset(dev, B43_PHY_ADIVRELATED, 0xFF00, 8);
 		}
 	}
 
-- 
1.6.0.2.471.g47a76


