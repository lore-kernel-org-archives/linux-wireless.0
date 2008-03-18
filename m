Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:58061 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYCRArv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 20:47:51 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6645297wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 17:47:51 -0700 (PDT)
Subject: [PATCH 5/5] b43: use b43_phy_mask/set helpers where possible
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:47:31 -0700
Message-Id: <1205801251.2329.55.camel@brick> (sfid-20080318_004802_414815_7094E8C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/lo.c  |   31 +---
 drivers/net/wireless/b43/phy.c |  324 ++++++++++++++--------------------------
 drivers/net/wireless/b43/wa.c  |   25 +--
 3 files changed, 128 insertions(+), 252 deletions(-)

diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index d890f36..3b0785a 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -591,18 +591,10 @@ static void lo_measure_setup(struct b43_wldev *dev,
 		sav->phy_cck_14 = b43_phy_read(dev, B43_PHY_CCK(0x14));
 		sav->phy_hpwr_tssictl = b43_phy_read(dev, B43_PHY_HPWR_TSSICTL);
 
-		b43_phy_write(dev, B43_PHY_HPWR_TSSICTL,
-			      b43_phy_read(dev, B43_PHY_HPWR_TSSICTL)
-			      | 0x100);
-		b43_phy_write(dev, B43_PHY_EXTG(0x01),
-			      b43_phy_read(dev, B43_PHY_EXTG(0x01))
-			      | 0x40);
-		b43_phy_write(dev, B43_PHY_DACCTL,
-			      b43_phy_read(dev, B43_PHY_DACCTL)
-			      | 0x40);
-		b43_phy_write(dev, B43_PHY_CCK(0x14),
-			      b43_phy_read(dev, B43_PHY_CCK(0x14))
-			      | 0x200);
+		b43_phy_set(dev, B43_PHY_HPWR_TSSICTL, 0x0100);
+		b43_phy_set(dev, B43_PHY_EXTG(0x01), 0x0040);
+		b43_phy_set(dev, B43_PHY_DACCTL, 0x0040);
+		b43_phy_set(dev, B43_PHY_CCK(0x14), 0x0200);
 	}
 	if (phy->type == B43_PHYTYPE_B &&
 	    phy->radio_ver == 0x2050 && phy->radio_rev < 6) {
@@ -621,17 +613,10 @@ static void lo_measure_setup(struct b43_wldev *dev,
 		sav->phy_cck_3E = b43_phy_read(dev, B43_PHY_CCK(0x3E));
 		sav->phy_crs0 = b43_phy_read(dev, B43_PHY_CRS0);
 
-		b43_phy_write(dev, B43_PHY_CLASSCTL,
-			      b43_phy_read(dev, B43_PHY_CLASSCTL)
-			      & 0xFFFC);
-		b43_phy_write(dev, B43_PHY_CRS0, b43_phy_read(dev, B43_PHY_CRS0)
-			      & 0x7FFF);
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER)
-			      | 0x0003);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVERVAL)
-			      & 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_CLASSCTL, 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_CRS0, 0x7FFF);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0003);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFC);
 		if (phy->type == B43_PHYTYPE_G) {
 			if ((phy->rev >= 7) &&
 			    (sprom->boardflags_lo & B43_BFL_EXTLNA)) {
diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 0e2b065..ab128a2 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -638,16 +638,13 @@ static void hardware_pctl_init_gphy(struct b43_wldev *dev)
 			(phy->tgt_idle_tssi - phy->cur_idle_tssi));
 	b43_gphy_tssi_power_lt_init(dev);
 	b43_gphy_gain_lt_init(dev);
-	b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060) & 0xFFBF);
+	b43_phy_mask(dev, 0x0060, 0xFFBF);
 	b43_phy_write(dev, 0x0014, 0x0000);
 
 	B43_WARN_ON(phy->rev < 6);
-	b43_phy_write(dev, 0x0478, b43_phy_read(dev, 0x0478)
-		      | 0x0800);
-	b43_phy_write(dev, 0x0478, b43_phy_read(dev, 0x0478)
-		      & 0xFEFF);
-	b43_phy_write(dev, 0x0801, b43_phy_read(dev, 0x0801)
-		      & 0xFFBF);
+	b43_phy_set(dev, 0x0478, 0x0800);
+	b43_phy_mask(dev, 0x0478, 0xFEFF);
+	b43_phy_mask(dev, 0x0801, 0xFFBF);
 
 	b43_gphy_dc_lt_init(dev);
 }
@@ -686,27 +683,21 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 		return;
 	}
 
-	b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036) & 0xFEFF);
+	b43_phy_mask(dev, 0x0036, 0xFEFF);
 	b43_phy_write(dev, 0x002F, 0x0202);
-	b43_phy_write(dev, 0x047C, b43_phy_read(dev, 0x047C) | 0x0002);
-	b43_phy_write(dev, 0x047A, b43_phy_read(dev, 0x047A) | 0xF000);
+	b43_phy_set(dev, 0x047C, 0x0002);
+	b43_phy_set(dev, 0x047A, 0xF000);
 	if (phy->radio_ver == 0x2050 && phy->radio_rev == 8) {
 		b43_phy_maskset(dev, 0x047A, 0xFF0F, 0x0010);
-		b43_phy_write(dev, 0x005D, b43_phy_read(dev, 0x005D)
-			      | 0x8000);
+		b43_phy_set(dev, 0x005D, 0x8000);
 		b43_phy_maskset(dev, 0x004E, 0xFFC0, 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
-		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
-			      | 0x0400);
+		b43_phy_set(dev, 0x0036, 0x0400);
 	} else {
-		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
-			      | 0x0200);
-		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
-			      | 0x0400);
-		b43_phy_write(dev, 0x005D, b43_phy_read(dev, 0x005D)
-			      & 0x7FFF);
-		b43_phy_write(dev, 0x004F, b43_phy_read(dev, 0x004F)
-			      & 0xFFFE);
+		b43_phy_set(dev, 0x0036, 0x0200);
+		b43_phy_set(dev, 0x0036, 0x0400);
+		b43_phy_mask(dev, 0x005D, 0x7FFF);
+		b43_phy_mask(dev, 0x004F, 0xFFFE);
 		b43_phy_maskset(dev, 0x004E, 0xFFC0, 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
 		b43_phy_maskset(dev, 0x047A, 0xFF0F, 0x0010);
@@ -822,10 +813,8 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	u16 b, curr_s, best_s = 0xFFFF;
 	int i;
 
-	b43_phy_write(dev, B43_PHY_CRS0,
-		b43_phy_read(dev, B43_PHY_CRS0) & ~B43_PHY_CRS0_EN);
-	b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-		b43_phy_read(dev, B43_PHY_OFDM(0x1B)) | 0x1000);
+	b43_phy_mask(dev, B43_PHY_CRS0, ~B43_PHY_CRS0_EN);
+	b43_phy_set(dev, B43_PHY_OFDM(0x1B), 0x1000);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), 0xF0FF, 0x0300);
 	b43_radio_write16(dev, 0x0009,
 		b43_radio_read16(dev, 0x0009) | 0x0080);
@@ -869,8 +858,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0x0E, 0x0011);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 0x0F, 0x0013);
 	b43_phy_write(dev, B43_PHY_OFDM(0x33), 0x5030);
-	b43_phy_write(dev, B43_PHY_CRS0,
-		b43_phy_read(dev, B43_PHY_CRS0) | B43_PHY_CRS0_EN);
+	b43_phy_set(dev, B43_PHY_CRS0, B43_PHY_CRS0_EN);
 }
 
 /* Initialize APHY. This is also called for the GPHY in some cases. */
@@ -883,26 +871,21 @@ static void b43_phy_inita(struct b43_wldev *dev)
 
 	if (phy->rev >= 6) {
 		if (phy->type == B43_PHYTYPE_A)
-			b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-				b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x1000);
+			b43_phy_mask(dev, B43_PHY_OFDM(0x1B), 0xEFFF);
 		if (b43_phy_read(dev, B43_PHY_ENCORE) & B43_PHY_ENCORE_EN)
-			b43_phy_write(dev, B43_PHY_ENCORE,
-				b43_phy_read(dev, B43_PHY_ENCORE) | 0x0010);
+			b43_phy_set(dev, B43_PHY_ENCORE, 0x0010);
 		else
-			b43_phy_write(dev, B43_PHY_ENCORE,
-				b43_phy_read(dev, B43_PHY_ENCORE) & ~0x1010);
+			b43_phy_mask(dev, B43_PHY_ENCORE, 0xEFEF);
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
 
@@ -1063,8 +1046,8 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 		}
 		b43_write16(dev, B43_MMIO_PHY_RADIO, 0x0000);
 
-		b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) | 0x0100);
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) | 0x2000);
+		b43_phy_set(dev, 0x0802, 0x0100);
+		b43_phy_set(dev, 0x042B, 0x2000);
 
 		b43_phy_write(dev, 0x001C, 0x186A);
 
@@ -1074,9 +1057,7 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 	}
 
 	if (dev->bad_frames_preempt) {
-		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-			      b43_phy_read(dev,
-					   B43_PHY_RADIO_BITFIELD) | (1 << 11));
+		b43_phy_set(dev, B43_PHY_RADIO_BITFIELD, (1 << 11));
 	}
 
 	if (phy->analog == 1) {
@@ -1197,8 +1178,8 @@ static void b43_phy_initb6(struct b43_wldev *dev)
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
@@ -1243,8 +1224,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 
 	if (phy->analog == 4) {
 		b43_write16(dev, 0x3E4, 9);
-		b43_phy_write(dev, 0x61, b43_phy_read(dev, 0x61)
-			      & 0x0FFF);
+		b43_phy_mask(dev, 0x61, 0x0FFF);
 	} else {
 		b43_phy_maskset(dev, 0x0002, 0xFFC0, 0x0004);
 	}
@@ -1297,50 +1277,32 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	backup_radio[1] = b43_radio_read16(dev, 0x43);
 	backup_radio[2] = b43_radio_read16(dev, 0x7A);
 
-	b43_phy_write(dev, B43_PHY_CRS0,
-		      b43_phy_read(dev, B43_PHY_CRS0) & 0x3FFF);
-	b43_phy_write(dev, B43_PHY_CCKBBANDCFG,
-		      b43_phy_read(dev, B43_PHY_CCKBBANDCFG) | 0x8000);
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0002);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xFFFD);
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0001);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
+	b43_phy_mask(dev, B43_PHY_CRS0, 0x3FFF);
+	b43_phy_set(dev, B43_PHY_CCKBBANDCFG, 0x8000);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0002);
+	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xFFFD);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0001);
+	b43_phy_mask(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xFFFE);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0001);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev,
-					   B43_PHY_ANALOGOVERVAL) & 0xFFFE);
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0002);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev,
-					   B43_PHY_ANALOGOVERVAL) & 0xFFFD);
-	}
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x000C);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) | 0x000C);
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0030);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0001);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFE);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0002);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFD);
+	}
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x000C);
+	b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x000C);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0030);
 	b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xFFCF, 0x0010);
 
 	b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0780);
 	b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
 	b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 
-	b43_phy_write(dev, B43_PHY_CCK(0x0A),
-		      b43_phy_read(dev, B43_PHY_CCK(0x0A)) | 0x2000);
+	b43_phy_set(dev, B43_PHY_CCK(0x0A), 0x2000);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0004);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev,
-					   B43_PHY_ANALOGOVERVAL) & 0xFFFB);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0004);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFB);
 	}
 	b43_phy_maskset(dev, B43_PHY_CCK(0x03), 0xFF9F, 0x0040);
 
@@ -1362,19 +1324,13 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_PHY_CCK(0x2B), 0xFFC0, 0x01);
 	b43_phy_maskset(dev, B43_PHY_CCK(0x2B), 0xC0FF, 0x800);
 
-	b43_phy_write(dev, B43_PHY_RFOVER,
-		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0100);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xCFFF);
+	b43_phy_set(dev, B43_PHY_RFOVER, 0x0100);
+	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xCFFF);
 
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
@@ -1399,16 +1355,12 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	loop1_outer_done = i;
 	loop1_inner_done = j;
 	if (j >= 8) {
-		b43_phy_write(dev, B43_PHY_RFOVERVAL,
-			      b43_phy_read(dev, B43_PHY_RFOVERVAL)
-			      | 0x30);
+		b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x30);
 		trsw_rx = 0x1B;
 		for (j = j - 8; j < 16; j++) {
 			b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xF0FF, (j << 8));
 			b43_phy_maskset(dev, B43_PHY_PGACTL, 0x0FFF, 0xA000);
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      b43_phy_read(dev, B43_PHY_PGACTL)
-				      | 0xF000);
+			b43_phy_set(dev, B43_PHY_PGACTL, 0xF000);
 			udelay(20);
 			trsw_rx -= 3;
 			if (b43_phy_read(dev, B43_PHY_LO_LEAKAGE) >= 0xDFC)
@@ -1489,12 +1441,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
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
@@ -1560,11 +1508,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
 	   but OFDM is legal everywhere */
 	if ((dev->dev->bus->chip_id == 0x4306
 	     && dev->dev->bus->chip_package == 2) || 0) {
-		b43_phy_write(dev, B43_PHY_CRS0, b43_phy_read(dev, B43_PHY_CRS0)
-			      & 0xBFFF);
-		b43_phy_write(dev, B43_PHY_OFDM(0xC3),
-			      b43_phy_read(dev, B43_PHY_OFDM(0xC3))
-			      & 0x7FFF);
+		b43_phy_mask(dev, B43_PHY_CRS0, 0xBFFF);
+		b43_phy_mask(dev, B43_PHY_OFDM(0xC3), 0x7FFF);
 	}
 }
 
@@ -2353,9 +2298,8 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 
 	b43_phy_lock(dev);
 	b43_radio_lock(dev);
-	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & 0xFFFC);
-	b43_phy_write(dev, B43_PHY_G_CRS,
-		      b43_phy_read(dev, B43_PHY_G_CRS) & 0x7FFF);
+	b43_phy_mask(dev, 0x0802, 0xFFFC);
+	b43_phy_mask(dev, B43_PHY_G_CRS, 0x7FFF);
 	b43_set_all_gains(dev, 3, 8, 1);
 
 	start = (channel - 5 > 0) ? channel - 5 : 1;
@@ -2367,9 +2311,8 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 	}
 	b43_radio_selectchannel(dev, channel, 0);
 	b43_phy_maskset(dev, 0x0802, 0xFFFC, 0x0003);
-	b43_phy_write(dev, 0x0403, b43_phy_read(dev, 0x0403) & 0xFFF8);
-	b43_phy_write(dev, B43_PHY_G_CRS,
-		      b43_phy_read(dev, B43_PHY_G_CRS) | 0x8000);
+	b43_phy_mask(dev, 0x0403, 0xFFF8);
+	b43_phy_set(dev, B43_PHY_G_CRS, 0x8000);
 	b43_set_original_gains(dev);
 	for (i = 0; i < 13; i++) {
 		if (!ret[i])
@@ -2457,11 +2400,11 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	backup[10] = b43_radio_read16(dev, 0x007A);
 	backup[11] = b43_radio_read16(dev, 0x0043);
 
-	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) & 0x7FFF);
+	b43_phy_mask(dev, 0x0429, 0x7FFF);
 	b43_phy_maskset(dev, 0x0001, 0x3FFF, 0x4000);
-	b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x000C);
+	b43_phy_set(dev, 0x0811, 0x000C);
 	b43_phy_maskset(dev, 0x0812, 0xFFF3, 0x0004);
-	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & ~(0x1 | 0x2));
+	b43_phy_mask(dev, 0x0802, 0xFFFC);
 	if (phy->rev >= 6) {
 		backup[12] = b43_phy_read(dev, 0x002E);
 		backup[13] = b43_phy_read(dev, 0x002F);
@@ -2476,10 +2419,10 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
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
@@ -2505,29 +2448,24 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) & 0x007F);
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-			b43_phy_write(dev, 0x0814,
-				      b43_phy_read(dev, 0x0814) | 0x0001);
-			b43_phy_write(dev, 0x0815,
-				      b43_phy_read(dev, 0x0815) & 0xFFFE);
-		}
-		b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x000C);
-		b43_phy_write(dev, 0x0812, b43_phy_read(dev, 0x0812) | 0x000C);
-		b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x0030);
-		b43_phy_write(dev, 0x0812, b43_phy_read(dev, 0x0812) | 0x0030);
+			b43_phy_set(dev, 0x0814, 0x0001);
+			b43_phy_mask(dev, 0x0815, 0xFFFE);
+		}
+		b43_phy_set(dev, 0x0811, 0x000C);
+		b43_phy_set(dev, 0x0812, 0x000C);
+		b43_phy_set(dev, 0x0811, 0x0030);
+		b43_phy_set(dev, 0x0812, 0x0030);
 		b43_phy_write(dev, 0x005A, 0x0480);
 		b43_phy_write(dev, 0x0059, 0x0810);
 		b43_phy_write(dev, 0x0058, 0x000D);
 		if (phy->rev == 0) {
 			b43_phy_write(dev, 0x0003, 0x0122);
 		} else {
-			b43_phy_write(dev, 0x000A, b43_phy_read(dev, 0x000A)
-				      | 0x2000);
+			b43_phy_set(dev, 0x000A, 0x2000);
 		}
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-			b43_phy_write(dev, 0x0814,
-				      b43_phy_read(dev, 0x0814) | 0x0004);
-			b43_phy_write(dev, 0x0815,
-				      b43_phy_read(dev, 0x0815) & 0xFFFB);
+			b43_phy_set(dev, 0x0814, 0x0004);
+			b43_phy_mask(dev, 0x0815, 0xFFFB);
 		}
 		b43_phy_maskset(dev, 0x0003, 0xFF9F, 0x0040);
 		b43_radio_write16(dev, 0x007A,
@@ -2575,8 +2513,8 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
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
@@ -2619,7 +2557,7 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x0030, 0x00FF);
 		b43_write16(dev, 0x03EC, 0x7F7F);
 		b43_phy_write(dev, 0x0026, 0x0000);
-		b43_phy_write(dev, 0x0015, b43_phy_read(dev, 0x0015) | 0x0020);
+		b43_phy_set(dev, 0x0015, 0x0020);
 		b43_phy_write(dev, 0x002A, 0x08A3);
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) | 0x0080);
@@ -2680,9 +2618,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		if (phy->radio_rev == 8)
 			b43_calc_nrssi_offset(dev);
 
-		b43_phy_write(dev, B43_PHY_G_CRS,
-			      b43_phy_read(dev, B43_PHY_G_CRS) & 0x7FFF);
-		b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_G_CRS, 0x7FFF);
+		b43_phy_mask(dev, 0x0802, 0xFFFC);
 		backup[7] = b43_read16(dev, 0x03E2);
 		b43_write16(dev, 0x03E2, b43_read16(dev, 0x03E2) | 0x8000);
 		backup[0] = b43_radio_read16(dev, 0x007A);
@@ -2709,24 +2646,16 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
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
-				b43_phy_write(dev, 0x0801,
-					      b43_phy_read(dev, 0x0801)
-					      & 0xFFBF);
+				b43_phy_mask(dev, 0x0801, 0xFFBF);
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
@@ -2793,10 +2722,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_G_LO_CONTROL, backup[13]);
 		}
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0812,
-				      b43_phy_read(dev, 0x0812) & 0xFFCF);
-			b43_phy_write(dev, 0x0811,
-				      b43_phy_read(dev, 0x0811) & 0xFFCF);
+			b43_phy_mask(dev, 0x0812, 0xFFCF);
+			b43_phy_mask(dev, 0x0811, 0xFFCF);
 		}
 
 		b43_radio_write16(dev, 0x007A, backup[0]);
@@ -2810,11 +2737,9 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
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
@@ -3004,11 +2929,8 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 	switch (mode) {
 	case B43_INTERFMODE_NONWLAN:
 		if (phy->rev != 1) {
-			b43_phy_write(dev, 0x042B,
-				      b43_phy_read(dev, 0x042B) | 0x0800);
-			b43_phy_write(dev, B43_PHY_G_CRS,
-				      b43_phy_read(dev,
-						   B43_PHY_G_CRS) & ~0x4000);
+			b43_phy_set(dev, 0x042B, 0x0800);
+			b43_phy_mask(dev, B43_PHY_G_CRS, 0xBFFF);
 			break;
 		}
 		radio_stacksave(0x0078);
@@ -3027,10 +2949,8 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		phy_stacksave(0x0406);
 		b43_phy_write(dev, 0x0406, 0x7E28);
 
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) | 0x0800);
-		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-			      b43_phy_read(dev,
-					   B43_PHY_RADIO_BITFIELD) | 0x1000);
+		b43_phy_set(dev, 0x042B, 0x0800);
+		b43_phy_set(dev, B43_PHY_RADIO_BITFIELD, 0x1000);
 
 		phy_stacksave(0x04A0);
 		b43_phy_maskset(dev, 0x04A0, 0xC0C0, 0x0008);
@@ -3097,9 +3017,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		phy_stacksave(0x042B);
 		phy_stacksave(0x048C);
 
-		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-			      b43_phy_read(dev, B43_PHY_RADIO_BITFIELD)
-			      & ~0x1000);
+		b43_phy_mask(dev, B43_PHY_RADIO_BITFIELD, 0xEFFF);
 		b43_phy_maskset(dev, B43_PHY_G_CRS, 0xFFFC, 0x0002);
 
 		b43_phy_write(dev, 0x0033, 0x0800);
@@ -3137,20 +3055,17 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
 
 		if (phy->rev >= 3) {
-			b43_phy_write(dev, 0x048A, b43_phy_read(dev, 0x048A)
-				      & ~0x8000);
+			b43_phy_mask(dev, 0x048A, 0x7FFF);
 			b43_phy_maskset(dev, 0x0415, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0416, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0417, 0xFE00, 0x016D);
 		} else {
-			b43_phy_write(dev, 0x048A, b43_phy_read(dev, 0x048A)
-				      | 0x1000);
+			b43_phy_set(dev, 0x048A, 0x1000);
 			b43_phy_maskset(dev, 0x048A, 0x9FFF, 0x2000);
 			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_ACIW);
 		}
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B)
-				      | 0x0800);
+			b43_phy_set(dev, 0x042B, 0x0800);
 		}
 		b43_phy_maskset(dev, 0x048C, 0xF0FF, 0x0200);
 		if (phy->rev == 2) {
@@ -3159,8 +3074,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		} else if (phy->rev >= 6) {
 			b43_ofdmtab_write16(dev, 0x1A00, 0x3, 0x007F);
 			b43_ofdmtab_write16(dev, 0x1A00, 0x2, 0x007F);
-			b43_phy_write(dev, 0x04AD, b43_phy_read(dev, 0x04AD)
-				      & 0x00FF);
+			b43_phy_mask(dev, 0x04AD, 0x00FF);
 		}
 		b43_calc_nrssi_slope(dev);
 		break;
@@ -3178,24 +3092,18 @@ b43_radio_interference_mitigation_disable(struct b43_wldev *dev, int mode)
 	switch (mode) {
 	case B43_INTERFMODE_NONWLAN:
 		if (phy->rev != 1) {
-			b43_phy_write(dev, 0x042B,
-				      b43_phy_read(dev, 0x042B) & ~0x0800);
-			b43_phy_write(dev, B43_PHY_G_CRS,
-				      b43_phy_read(dev,
-						   B43_PHY_G_CRS) | 0x4000);
+			b43_phy_mask(dev, 0x042B, 0xF7FF);
+			b43_phy_set(dev, B43_PHY_G_CRS, 0x4000);
 			break;
 		}
 		radio_stackrestore(0x0078);
 		b43_calc_nrssi_threshold(dev);
 		phy_stackrestore(0x0406);
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) & ~0x0800);
+		b43_phy_mask(dev, 0x042B, 0xF7FF);
 		if (!dev->bad_frames_preempt) {
-			b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-				      b43_phy_read(dev, B43_PHY_RADIO_BITFIELD)
-				      & ~(1 << 11));
+			b43_phy_mask(dev, B43_PHY_RADIO_BITFIELD, 0xF7FF);
 		}
-		b43_phy_write(dev, B43_PHY_G_CRS,
-			      b43_phy_read(dev, B43_PHY_G_CRS) | 0x4000);
+		b43_phy_set(dev, B43_PHY_G_CRS, 0x4000);
 		phy_stackrestore(0x04A0);
 		phy_stackrestore(0x04A1);
 		phy_stackrestore(0x04A2);
@@ -3486,17 +3394,10 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 		sav.phy_crs0 = b43_phy_read(dev, B43_PHY_CRS0);
 		sav.phy_classctl = b43_phy_read(dev, B43_PHY_CLASSCTL);
 
-		b43_phy_write(dev, B43_PHY_ANALOGOVER,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVER)
-			      | 0x0003);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVERVAL)
-			      & 0xFFFC);
-		b43_phy_write(dev, B43_PHY_CRS0, b43_phy_read(dev, B43_PHY_CRS0)
-			      & 0x7FFF);
-		b43_phy_write(dev, B43_PHY_CLASSCTL,
-			      b43_phy_read(dev, B43_PHY_CLASSCTL)
-			      & 0xFFFC);
+		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0003);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_CRS0, 0x7FFF);
+		b43_phy_mask(dev, B43_PHY_CLASSCTL, 0xFFFC);
 		if (has_loopback_gain(phy)) {
 			sav.phy_lo_mask = b43_phy_read(dev, B43_PHY_LO_MASK);
 			sav.phy_lo_ctl = b43_phy_read(dev, B43_PHY_LO_CTL);
@@ -3514,8 +3415,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 	b43_write16(dev, 0x3E2, b43_read16(dev, 0x3E2) | 0x8000);
 
 	sav.phy_syncctl = b43_phy_read(dev, B43_PHY_SYNCCTL);
-	b43_phy_write(dev, B43_PHY_SYNCCTL, b43_phy_read(dev, B43_PHY_SYNCCTL)
-		      & 0xFF7F);
+	b43_phy_mask(dev, B43_PHY_SYNCCTL, 0xFF7F);
 	sav.reg_3E6 = b43_read16(dev, 0x3E6);
 	sav.reg_3F4 = b43_read16(dev, 0x3F4);
 
@@ -3884,8 +3784,8 @@ void b43_radio_turn_on(struct b43_wldev *dev)
 	case B43_PHYTYPE_A:
 		b43_radio_write16(dev, 0x0004, 0x00C0);
 		b43_radio_write16(dev, 0x0005, 0x0008);
-		b43_phy_write(dev, 0x0010, b43_phy_read(dev, 0x0010) & 0xFFF7);
-		b43_phy_write(dev, 0x0011, b43_phy_read(dev, 0x0011) & 0xFFF7);
+		b43_phy_mask(dev, 0x0010, 0xFFF7);
+		b43_phy_mask(dev, 0x0011, 0xFFF7);
 		b43_radio_init2060(dev);
 		break;
 	case B43_PHYTYPE_B:
@@ -3929,8 +3829,8 @@ void b43_radio_turn_off(struct b43_wldev *dev, bool force)
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
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index b92e496..81aff6b 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -62,8 +62,7 @@ void b43_wa_initgains(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 
 	b43_phy_write(dev, B43_PHY_LNAHPFCTL, 0x1FF9);
-	b43_phy_write(dev, B43_PHY_LPFGAINCTL,
-		b43_phy_read(dev, B43_PHY_LPFGAINCTL) & 0xFF0F);
+	b43_phy_mask(dev, B43_PHY_LPFGAINCTL, 0xFF0F);
 	if (phy->rev <= 2)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_LPFGAIN, 0, 0x1FBF);
 	b43_radio_write16(dev, 0x0002, 0x1FBF);
@@ -84,7 +83,7 @@ void b43_wa_initgains(struct b43_wldev *dev)
 
 static void b43_wa_divider(struct b43_wldev *dev)
 {
-	b43_phy_write(dev, 0x002B, b43_phy_read(dev, 0x002B) & ~0x0100);
+	b43_phy_mask(dev, 0x002B, 0xFEFF);
 	b43_phy_write(dev, 0x008E, 0x58C1);
 }
 
@@ -314,16 +313,12 @@ static void b43_wa_crs_ed(struct b43_wldev *dev)
 	} else if (phy->rev == 2) {
 		b43_phy_write(dev, B43_PHY_CRSTHRES1, 0x1861);
 		b43_phy_write(dev, B43_PHY_CRSTHRES2, 0x0271);
-		b43_phy_write(dev, B43_PHY_ANTDWELL,
-				  b43_phy_read(dev, B43_PHY_ANTDWELL)
-				  | 0x0800);
+		b43_phy_set(dev, B43_PHY_ANTDWELL, 0x0800);
 	} else {
 		b43_phy_write(dev, B43_PHY_CRSTHRES1, 0x0098);
 		b43_phy_write(dev, B43_PHY_CRSTHRES2, 0x0070);
 		b43_phy_write(dev, B43_PHY_OFDM(0xC9), 0x0080);
-		b43_phy_write(dev, B43_PHY_ANTDWELL,
-				  b43_phy_read(dev, B43_PHY_ANTDWELL)
-				  | 0x0800);
+		b43_phy_set(dev, B43_PHY_ANTDWELL, 0x0800);
 	}
 }
 
@@ -412,8 +407,7 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), 0xFFE1, 0x0002);
 	} else {
-		b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-			b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x001E);
+		b43_phy_mask(dev, B43_PHY_OFDM(0x1B), 0xFFE1);
 		b43_phy_write(dev, B43_PHY_OFDM(0x1F), 0x287A);
 		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, 0xFFF0, 0x0004);
 		if (phy->rev >= 6) {
@@ -439,10 +433,8 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC3, 3, 28);
 	}
 	if (phy->rev >= 6) {
-		b43_phy_write(dev, B43_PHY_OFDM(0x26),
-			b43_phy_read(dev, B43_PHY_OFDM(0x26)) & ~0x0003);
-		b43_phy_write(dev, B43_PHY_OFDM(0x26),
-			b43_phy_read(dev, B43_PHY_OFDM(0x26)) & ~0x1000);
+		b43_phy_mask(dev, B43_PHY_OFDM(0x26), 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_OFDM(0x26), 0xEFFF);
 	}
 	b43_phy_read(dev, B43_PHY_VERSION_OFDM); /* Dummy read */
 }
@@ -508,8 +500,7 @@ static void b43_wa_boards_g(struct b43_wldev *dev)
 			b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 2, 0x0001);
 			if ((bus->sprom.boardflags_lo & B43_BFL_EXTLNA) &&
 			    (phy->rev >= 7)) {
-				b43_phy_write(dev, B43_PHY_EXTG(0x11),
-					b43_phy_read(dev, B43_PHY_EXTG(0x11)) & 0xF7FF);
+				b43_phy_mask(dev, B43_PHY_EXTG(0x11), 0xF7FF);
 				b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 0x0020, 0x0001);
 				b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 0x0021, 0x0001);
 				b43_ofdmtab_write16(dev, B43_OFDMTAB_GAINX, 0x0022, 0x0001);
-- 
1.5.4.4.684.g0e08

