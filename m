Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:58061 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYCRAre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 20:47:34 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6645297wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 17:47:33 -0700 (PDT)
Subject: [PATCH 1/5] b43: Use the b43_phy_maskset where possible
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:47:29 -0700
Message-Id: <1205801249.2329.49.camel@brick> (sfid-20080318_004751_084635_ADB5C0B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nested b43_phy_read|write with both masking and setting was
the easiest to get the bracketing incorrect.  Switch all of these
occurrences to b43_phy_maskset.

Make b43_phy_maskset avoid adjusting the offset twice by opencoding
the register read/writes done by b43_phy_read|write.  This maintains
all card register reads and writes, but it may be possible to eliminate
one write to the phy control register.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  262 ++++++++++++++--------------------------
 drivers/net/wireless/b43/wa.c  |   85 +++++---------
 2 files changed, 116 insertions(+), 231 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 71507b2..b3e369c 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -322,8 +322,14 @@ void b43_phy_set(struct b43_wldev *dev, u16 offset, u16 set)
 
 void b43_phy_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set)
 {
-	b43_phy_write(dev, offset,
-		      (b43_phy_read(dev, offset) & mask) | set);
+	struct b43_phy *phy = &dev->phy;
+	u16 data;
+
+	offset = adjust_phyreg_for_phytype(phy, offset, dev);
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, offset);
+	data = (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set;
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, offset);
+	b43_write16(dev, B43_MMIO_PHY_DATA, data);
 }
 
 /* Adjust the transmission power output (G-PHY) */
@@ -626,10 +632,10 @@ static void hardware_pctl_init_gphy(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	b43_phy_write(dev, 0x0036, (b43_phy_read(dev, 0x0036) & 0xFFC0)
-		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
-	b43_phy_write(dev, 0x0478, (b43_phy_read(dev, 0x0478) & 0xFF00)
-		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
+	b43_phy_maskset(dev, 0x0036, 0xFFC0,
+			(phy->tgt_idle_tssi - phy->cur_idle_tssi));
+	b43_phy_maskset(dev, 0x0478, 0xFF00,
+			(phy->tgt_idle_tssi - phy->cur_idle_tssi));
 	b43_gphy_tssi_power_lt_init(dev);
 	b43_gphy_gain_lt_init(dev);
 	b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060) & 0xFFBF);
@@ -685,12 +691,10 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x047C, b43_phy_read(dev, 0x047C) | 0x0002);
 	b43_phy_write(dev, 0x047A, b43_phy_read(dev, 0x047A) | 0xF000);
 	if (phy->radio_ver == 0x2050 && phy->radio_rev == 8) {
-		b43_phy_write(dev, 0x047A, (b43_phy_read(dev, 0x047A)
-					    & 0xFF0F) | 0x0010);
+		b43_phy_maskset(dev, 0x047A, 0xFF0F, 0x0010);
 		b43_phy_write(dev, 0x005D, b43_phy_read(dev, 0x005D)
 			      | 0x8000);
-		b43_phy_write(dev, 0x004E, (b43_phy_read(dev, 0x004E)
-					    & 0xFFC0) | 0x0010);
+		b43_phy_maskset(dev, 0x004E, 0xFFC0, 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
 		b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036)
 			      | 0x0400);
@@ -703,11 +707,9 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 			      & 0x7FFF);
 		b43_phy_write(dev, 0x004F, b43_phy_read(dev, 0x004F)
 			      & 0xFFFE);
-		b43_phy_write(dev, 0x004E, (b43_phy_read(dev, 0x004E)
-					    & 0xFFC0) | 0x0010);
+		b43_phy_maskset(dev, 0x004E, 0xFFC0, 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
-		b43_phy_write(dev, 0x047A, (b43_phy_read(dev, 0x047A)
-					    & 0xFF0F) | 0x0010);
+		b43_phy_maskset(dev, 0x047A, 0xFF0F, 0x0010);
 	}
 }
 
@@ -824,8 +826,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 		b43_phy_read(dev, B43_PHY_CRS0) & ~B43_PHY_CRS0_EN);
 	b43_phy_write(dev, B43_PHY_OFDM(0x1B),
 		b43_phy_read(dev, B43_PHY_OFDM(0x1B)) | 0x1000);
-	b43_phy_write(dev, B43_PHY_OFDM(0x82),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & 0xF0FF) | 0x0300);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), 0xF0FF, 0x0300);
 	b43_radio_write16(dev, 0x0009,
 		b43_radio_read16(dev, 0x0009) | 0x0080);
 	b43_radio_write16(dev, 0x0012,
@@ -857,14 +858,10 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_OFDM(0xB5), 0x0EC0);
 	b43_phy_write(dev, B43_PHY_OFDM(0xB2), 0x00C0);
 	b43_phy_write(dev, B43_PHY_OFDM(0xB9), 0x1FFF);
-	b43_phy_write(dev, B43_PHY_OFDM(0xBB),
-		(b43_phy_read(dev, B43_PHY_OFDM(0xBB)) & 0xF000) | 0x0053);
-	b43_phy_write(dev, B43_PHY_OFDM61,
-		(b43_phy_read(dev, B43_PHY_OFDM61 & 0xFE1F)) | 0x0120);
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
@@ -925,9 +922,7 @@ static void b43_phy_inita(struct b43_wldev *dev)
 
 	if ((phy->type == B43_PHYTYPE_G) &&
 	    (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)) {
-		b43_phy_write(dev, B43_PHY_OFDM(0x6E),
-				  (b43_phy_read(dev, B43_PHY_OFDM(0x6E))
-				   & 0xE000) | 0x3CF);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x6E), 0xE000, 0x3CF);
 	}
 }
 
@@ -1053,8 +1048,7 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 			value += 0x202;
 		}
 	}
-	b43_phy_write(dev, 0x0035, (b43_phy_read(dev, 0x0035) & 0xF0FF)
-		      | 0x0700);
+	b43_phy_maskset(dev, 0x0035, 0xF0FF, 0x0700);
 	if (phy->radio_ver == 0x2050)
 		b43_phy_write(dev, 0x0038, 0x0667);
 
@@ -1074,12 +1068,9 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 
 		b43_phy_write(dev, 0x001C, 0x186A);
 
-		b43_phy_write(dev, 0x0013,
-			      (b43_phy_read(dev, 0x0013) & 0x00FF) | 0x1900);
-		b43_phy_write(dev, 0x0035,
-			      (b43_phy_read(dev, 0x0035) & 0xFFC0) | 0x0064);
-		b43_phy_write(dev, 0x005D,
-			      (b43_phy_read(dev, 0x005D) & 0xFF80) | 0x000A);
+		b43_phy_maskset(dev, 0x0013, 0x00FF, 0x1900);
+		b43_phy_maskset(dev, 0x0035, 0xFFC0, 0x0064);
+		b43_phy_maskset(dev, 0x005D, 0xFF80, 0x000A);
 	}
 
 	if (dev->bad_frames_preempt) {
@@ -1245,8 +1236,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0038, 0x0668);
 	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
 	if (phy->radio_rev <= 5) {
-		b43_phy_write(dev, 0x5D, (b43_phy_read(dev, 0x5D)
-					  & 0xFF80) | 0x0003);
+		b43_phy_maskset(dev, 0x5D, 0xFF80, 0x0003);
 	}
 	if (phy->radio_rev <= 2)
 		b43_radio_write16(dev, 0x005D, 0x000D);
@@ -1256,8 +1246,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x61, b43_phy_read(dev, 0x61)
 			      & 0x0FFF);
 	} else {
-		b43_phy_write(dev, 0x0002, (b43_phy_read(dev, 0x0002) & 0xFFC0)
-			      | 0x0004);
+		b43_phy_maskset(dev, 0x0002, 0xFFC0, 0x0004);
 	}
 	if (phy->type == B43_PHYTYPE_B) {
 		b43_write16(dev, 0x03E6, 0x8140);
@@ -1338,9 +1327,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) | 0x000C);
 	b43_phy_write(dev, B43_PHY_RFOVER,
 		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0030);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
-		       & 0xFFCF) | 0x10);
+	b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xFFCF, 0x0010);
 
 	b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0780);
 	b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
@@ -1355,9 +1342,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 			      b43_phy_read(dev,
 					   B43_PHY_ANALOGOVERVAL) & 0xFFFB);
 	}
-	b43_phy_write(dev, B43_PHY_CCK(0x03),
-		      (b43_phy_read(dev, B43_PHY_CCK(0x03))
-		       & 0xFF9F) | 0x40);
+	b43_phy_maskset(dev, B43_PHY_CCK(0x03), 0xFF9F, 0x0040);
 
 	if (phy->radio_rev == 8) {
 		b43_radio_write16(dev, 0x43, 0x000F);
@@ -1374,12 +1359,8 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8020);
 	b43_phy_write(dev, B43_PHY_LO_CTL, 0);
 
-	b43_phy_write(dev, B43_PHY_CCK(0x2B),
-		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
-		       & 0xFFC0) | 0x01);
-	b43_phy_write(dev, B43_PHY_CCK(0x2B),
-		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
-		       & 0xC0FF) | 0x800);
+	b43_phy_maskset(dev, B43_PHY_CCK(0x2B), 0xFFC0, 0x01);
+	b43_phy_maskset(dev, B43_PHY_CCK(0x2B), 0xC0FF, 0x800);
 
 	b43_phy_write(dev, B43_PHY_RFOVER,
 		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0100);
@@ -1404,12 +1385,8 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	for (i = 0; i < loop_i_max; i++) {
 		for (j = 0; j < 16; j++) {
 			b43_radio_write16(dev, 0x43, i);
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
-				       & 0xF0FF) | (j << 8));
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      (b43_phy_read(dev, B43_PHY_PGACTL)
-				       & 0x0FFF) | 0xA000);
+			b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xF0FF, (j << 8));
+			b43_phy_maskset(dev, B43_PHY_PGACTL, 0x0FFF, 0xA000);
 			b43_phy_write(dev, B43_PHY_PGACTL,
 				      b43_phy_read(dev, B43_PHY_PGACTL)
 				      | 0xF000);
@@ -1427,12 +1404,8 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 			      | 0x30);
 		trsw_rx = 0x1B;
 		for (j = j - 8; j < 16; j++) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
-				       & 0xF0FF) | (j << 8));
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      (b43_phy_read(dev, B43_PHY_PGACTL)
-				       & 0x0FFF) | 0xA000);
+			b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xF0FF, (j << 8));
+			b43_phy_maskset(dev, B43_PHY_PGACTL, 0x0FFF, 0xA000);
 			b43_phy_write(dev, B43_PHY_PGACTL,
 				      b43_phy_read(dev, B43_PHY_PGACTL)
 				      | 0xF000);
@@ -1510,9 +1483,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_OFDM(0xC3), 0x8006);
 		}
 		if (tmp == 5) {
-			b43_phy_write(dev, B43_PHY_OFDM(0xCC),
-				      (b43_phy_read(dev, B43_PHY_OFDM(0xCC))
-				       & 0x00FF) | 0x1F00);
+			b43_phy_maskset(dev, B43_PHY_OFDM(0xCC), 0x00FF, 0x1F00);
 		}
 	}
 	if ((phy->rev <= 2 && phy->gmode) || phy->rev >= 2)
@@ -1548,10 +1519,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
 					  | phy->lo_control->tx_bias);
 		}
 		if (phy->rev >= 6) {
-			b43_phy_write(dev, B43_PHY_CCK(0x36),
-				      (b43_phy_read(dev, B43_PHY_CCK(0x36))
-				       & 0x0FFF) | (phy->lo_control->
-						    tx_bias << 12));
+			b43_phy_maskset(dev, B43_PHY_CCK(0x36), 0x0FFF,
+					(phy->lo_control->tx_bias << 12));
 		}
 		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
 			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
@@ -1610,13 +1579,11 @@ void b43_phy_set_baseband_attenuation(struct b43_wldev *dev,
 						 & 0xFFF0) |
 			    baseband_attenuation);
 	} else if (phy->analog > 1) {
-		b43_phy_write(dev, B43_PHY_DACCTL,
-			      (b43_phy_read(dev, B43_PHY_DACCTL)
-			       & 0xFFC3) | (baseband_attenuation << 2));
+		b43_phy_maskset(dev, B43_PHY_DACCTL, 0xFFC3,
+				(baseband_attenuation << 2));
 	} else {
-		b43_phy_write(dev, B43_PHY_DACCTL,
-			      (b43_phy_read(dev, B43_PHY_DACCTL)
-			       & 0xFF87) | (baseband_attenuation << 3));
+		b43_phy_maskset(dev, B43_PHY_DACCTL, 0xFF87,
+				(baseband_attenuation << 3));
 	}
 }
 
@@ -2282,12 +2249,9 @@ static void b43_set_all_gains(struct b43_wldev *dev,
 
 	if (third != -1) {
 		tmp = ((u16) third << 14) | ((u16) third << 6);
-		b43_phy_write(dev, 0x04A0,
-			      (b43_phy_read(dev, 0x04A0) & 0xBFBF) | tmp);
-		b43_phy_write(dev, 0x04A1,
-			      (b43_phy_read(dev, 0x04A1) & 0xBFBF) | tmp);
-		b43_phy_write(dev, 0x04A2,
-			      (b43_phy_read(dev, 0x04A2) & 0xBFBF) | tmp);
+		b43_phy_maskset(dev, 0x04A0, 0xBFBF, tmp);
+		b43_phy_maskset(dev, 0x04A1, 0xBFBF, tmp);
+		b43_phy_maskset(dev, 0x04A2, 0xBFBF, tmp);
 	}
 	b43_dummy_transmission(dev);
 }
@@ -2318,12 +2282,9 @@ static void b43_set_original_gains(struct b43_wldev *dev)
 	for (i = start; i < end; i++)
 		b43_ofdmtab_write16(dev, table, i, i - start);
 
-	b43_phy_write(dev, 0x04A0,
-		      (b43_phy_read(dev, 0x04A0) & 0xBFBF) | 0x4040);
-	b43_phy_write(dev, 0x04A1,
-		      (b43_phy_read(dev, 0x04A1) & 0xBFBF) | 0x4040);
-	b43_phy_write(dev, 0x04A2,
-		      (b43_phy_read(dev, 0x04A2) & 0xBFBF) | 0x4000);
+	b43_phy_maskset(dev, 0x04A0, 0xBFBF, 0x4040);
+	b43_phy_maskset(dev, 0x04A1, 0xBFBF, 0x4040);
+	b43_phy_maskset(dev, 0x04A2, 0xBFBF, 0x4000);
 	b43_dummy_transmission(dev);
 }
 
@@ -2405,8 +2366,7 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 			ret[i - 1] = b43_radio_aci_detect(dev, i);
 	}
 	b43_radio_selectchannel(dev, channel, 0);
-	b43_phy_write(dev, 0x0802,
-		      (b43_phy_read(dev, 0x0802) & 0xFFFC) | 0x0003);
+	b43_phy_maskset(dev, 0x0802, 0xFFFC, 0x0003);
 	b43_phy_write(dev, 0x0403, b43_phy_read(dev, 0x0403) & 0xFFF8);
 	b43_phy_write(dev, B43_PHY_G_CRS,
 		      b43_phy_read(dev, B43_PHY_G_CRS) | 0x8000);
@@ -2498,11 +2458,9 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	backup[11] = b43_radio_read16(dev, 0x0043);
 
 	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) & 0x7FFF);
-	b43_phy_write(dev, 0x0001,
-		      (b43_phy_read(dev, 0x0001) & 0x3FFF) | 0x4000);
+	b43_phy_maskset(dev, 0x0001, 0x3FFF, 0x4000);
 	b43_phy_write(dev, 0x0811, b43_phy_read(dev, 0x0811) | 0x000C);
-	b43_phy_write(dev, 0x0812,
-		      (b43_phy_read(dev, 0x0812) & 0xFFF3) | 0x0004);
+	b43_phy_maskset(dev, 0x0812, 0xFFF3, 0x0004);
 	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & ~(0x1 | 0x2));
 	if (phy->rev >= 6) {
 		backup[12] = b43_phy_read(dev, 0x002E);
@@ -2571,8 +2529,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 			b43_phy_write(dev, 0x0815,
 				      b43_phy_read(dev, 0x0815) & 0xFFFB);
 		}
-		b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003) & 0xFF9F)
-			      | 0x0040);
+		b43_phy_maskset(dev, 0x0003, 0xFF9F, 0x0040);
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) | 0x000F);
 		b43_set_all_gains(dev, 3, 0, 1);
@@ -2777,12 +2734,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) & 0x00F7);
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0811,
-				      (b43_phy_read(dev, 0x0811) & 0xFFCF) |
-				      0x0030);
-			b43_phy_write(dev, 0x0812,
-				      (b43_phy_read(dev, 0x0812) & 0xFFCF) |
-				      0x0010);
+			b43_phy_maskset(dev, 0x0811, 0xFFCF, 0x0030);
+			b43_phy_maskset(dev, 0x0812, 0xFFCF, 0x0010);
 		}
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) | 0x0080);
@@ -2795,8 +2748,7 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) & 0x007F);
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003)
-						    & 0xFF9F) | 0x0040);
+			b43_phy_maskset(dev, 0x0003, 0xFF9F, 0x0040);
 		}
 
 		b43_write16(dev, B43_MMIO_CHANNEL_EXT,
@@ -2806,12 +2758,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 				  b43_radio_read16(dev, 0x007A) | 0x000F);
 		b43_phy_write(dev, 0x0015, 0xF330);
 		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0812,
-				      (b43_phy_read(dev, 0x0812) & 0xFFCF) |
-				      0x0020);
-			b43_phy_write(dev, 0x0811,
-				      (b43_phy_read(dev, 0x0811) & 0xFFCF) |
-				      0x0020);
+			b43_phy_maskset(dev, 0x0812, 0xFFCF, 0x0020);
+			b43_phy_maskset(dev, 0x0811, 0xFFCF, 0x0020);
 		}
 
 		b43_set_all_gains(dev, 3, 0, 1);
@@ -2930,13 +2878,9 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 			if (tmp16 >= 0x20)
 				tmp16 -= 0x40;
 			if (tmp16 < 3) {
-				b43_phy_write(dev, 0x048A,
-					      (b43_phy_read(dev, 0x048A)
-					       & 0xF000) | 0x09EB);
+				b43_phy_maskset(dev, 0x048A, 0xF000, 0x09EB);
 			} else {
-				b43_phy_write(dev, 0x048A,
-					      (b43_phy_read(dev, 0x048A)
-					       & 0xF000) | 0x0AED);
+				b43_phy_maskset(dev, 0x048A, 0xF000, 0x0AED);
 			}
 		} else {
 			if (phy->interfmode == B43_INTERFMODE_NONWLAN) {
@@ -3089,20 +3033,15 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 					   B43_PHY_RADIO_BITFIELD) | 0x1000);
 
 		phy_stacksave(0x04A0);
-		b43_phy_write(dev, 0x04A0,
-			      (b43_phy_read(dev, 0x04A0) & 0xC0C0) | 0x0008);
+		b43_phy_maskset(dev, 0x04A0, 0xC0C0, 0x0008);
 		phy_stacksave(0x04A1);
-		b43_phy_write(dev, 0x04A1,
-			      (b43_phy_read(dev, 0x04A1) & 0xC0C0) | 0x0605);
+		b43_phy_maskset(dev, 0x04A1, 0xC0C0, 0x0605);
 		phy_stacksave(0x04A2);
-		b43_phy_write(dev, 0x04A2,
-			      (b43_phy_read(dev, 0x04A2) & 0xC0C0) | 0x0204);
+		b43_phy_maskset(dev, 0x04A2, 0xC0C0, 0x0204);
 		phy_stacksave(0x04A8);
-		b43_phy_write(dev, 0x04A8,
-			      (b43_phy_read(dev, 0x04A8) & 0xC0C0) | 0x0803);
+		b43_phy_maskset(dev, 0x04A8, 0xC0C0, 0x0803);
 		phy_stacksave(0x04AB);
-		b43_phy_write(dev, 0x04AB,
-			      (b43_phy_read(dev, 0x04AB) & 0xC0C0) | 0x0605);
+		b43_phy_maskset(dev, 0x04AB, 0xC0C0, 0x0605);
 
 		phy_stacksave(0x04A7);
 		b43_phy_write(dev, 0x04A7, 0x0002);
@@ -3161,9 +3100,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
 			      b43_phy_read(dev, B43_PHY_RADIO_BITFIELD)
 			      & ~0x1000);
-		b43_phy_write(dev, B43_PHY_G_CRS,
-			      (b43_phy_read(dev, B43_PHY_G_CRS)
-			       & 0xFFFC) | 0x0002);
+		b43_phy_maskset(dev, B43_PHY_G_CRS, 0xFFFC, 0x0002);
 
 		b43_phy_write(dev, 0x0033, 0x0800);
 		b43_phy_write(dev, 0x04A3, 0x2027);
@@ -3172,8 +3109,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		b43_phy_write(dev, 0x04AA, 0x1CA8);
 		b43_phy_write(dev, 0x04AC, 0x287A);
 
-		b43_phy_write(dev, 0x04A0, (b43_phy_read(dev, 0x04A0)
-					    & 0xFFC0) | 0x001A);
+		b43_phy_maskset(dev, 0x04A0, 0xFFC0, 0x001A);
 		b43_phy_write(dev, 0x04A7, 0x000D);
 
 		if (phy->rev < 2) {
@@ -3186,60 +3122,40 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 			b43_phy_write(dev, 0x04C1, 0x0059);
 		}
 
-		b43_phy_write(dev, 0x04A1, (b43_phy_read(dev, 0x04A1)
-					    & 0xC0FF) | 0x1800);
-		b43_phy_write(dev, 0x04A1, (b43_phy_read(dev, 0x04A1)
-					    & 0xFFC0) | 0x0015);
-		b43_phy_write(dev, 0x04A8, (b43_phy_read(dev, 0x04A8)
-					    & 0xCFFF) | 0x1000);
-		b43_phy_write(dev, 0x04A8, (b43_phy_read(dev, 0x04A8)
-					    & 0xF0FF) | 0x0A00);
-		b43_phy_write(dev, 0x04AB, (b43_phy_read(dev, 0x04AB)
-					    & 0xCFFF) | 0x1000);
-		b43_phy_write(dev, 0x04AB, (b43_phy_read(dev, 0x04AB)
-					    & 0xF0FF) | 0x0800);
-		b43_phy_write(dev, 0x04AB, (b43_phy_read(dev, 0x04AB)
-					    & 0xFFCF) | 0x0010);
-		b43_phy_write(dev, 0x04AB, (b43_phy_read(dev, 0x04AB)
-					    & 0xFFF0) | 0x0005);
-		b43_phy_write(dev, 0x04A8, (b43_phy_read(dev, 0x04A8)
-					    & 0xFFCF) | 0x0010);
-		b43_phy_write(dev, 0x04A8, (b43_phy_read(dev, 0x04A8)
-					    & 0xFFF0) | 0x0006);
-		b43_phy_write(dev, 0x04A2, (b43_phy_read(dev, 0x04A2)
-					    & 0xF0FF) | 0x0800);
-		b43_phy_write(dev, 0x04A0, (b43_phy_read(dev, 0x04A0)
-					    & 0xF0FF) | 0x0500);
-		b43_phy_write(dev, 0x04A2, (b43_phy_read(dev, 0x04A2)
-					    & 0xFFF0) | 0x000B);
+		b43_phy_maskset(dev, 0x04A1, 0xC0FF, 0x1800);
+		b43_phy_maskset(dev, 0x04A1, 0xFFC0, 0x0015);
+		b43_phy_maskset(dev, 0x04A8, 0xCFFF, 0x1000);
+		b43_phy_maskset(dev, 0x04A8, 0xF0FF, 0x0A00);
+		b43_phy_maskset(dev, 0x04AB, 0xCFFF, 0x1000);
+		b43_phy_maskset(dev, 0x04AB, 0xF0FF, 0x0800);
+		b43_phy_maskset(dev, 0x04AB, 0xFFCF, 0x0010);
+		b43_phy_maskset(dev, 0x04AB, 0xFFF0, 0x0005);
+		b43_phy_maskset(dev, 0x04A8, 0xFFCF, 0x0010);
+		b43_phy_maskset(dev, 0x04A8, 0xFFF0, 0x0006);
+		b43_phy_maskset(dev, 0x04A2, 0xF0FF, 0x0800);
+		b43_phy_maskset(dev, 0x04A0, 0xF0FF, 0x0500);
+		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
 
 		if (phy->rev >= 3) {
 			b43_phy_write(dev, 0x048A, b43_phy_read(dev, 0x048A)
 				      & ~0x8000);
-			b43_phy_write(dev, 0x0415, (b43_phy_read(dev, 0x0415)
-						    & 0x8000) | 0x36D8);
-			b43_phy_write(dev, 0x0416, (b43_phy_read(dev, 0x0416)
-						    & 0x8000) | 0x36D8);
-			b43_phy_write(dev, 0x0417, (b43_phy_read(dev, 0x0417)
-						    & 0xFE00) | 0x016D);
+			b43_phy_maskset(dev, 0x0415, 0x8000, 0x36D8);
+			b43_phy_maskset(dev, 0x0416, 0x8000, 0x36D8);
+			b43_phy_maskset(dev, 0x0417, 0xFE00, 0x016D);
 		} else {
 			b43_phy_write(dev, 0x048A, b43_phy_read(dev, 0x048A)
 				      | 0x1000);
-			b43_phy_write(dev, 0x048A, (b43_phy_read(dev, 0x048A)
-						    & 0x9FFF) | 0x2000);
+			b43_phy_maskset(dev, 0x048A, 0x9FFF, 0x2000);
 			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_ACIW);
 		}
 		if (phy->rev >= 2) {
 			b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B)
 				      | 0x0800);
 		}
-		b43_phy_write(dev, 0x048C, (b43_phy_read(dev, 0x048C)
-					    & 0xF0FF) | 0x0200);
+		b43_phy_maskset(dev, 0x048C, 0xF0FF, 0x0200);
 		if (phy->rev == 2) {
-			b43_phy_write(dev, 0x04AE, (b43_phy_read(dev, 0x04AE)
-						    & 0xFF00) | 0x007F);
-			b43_phy_write(dev, 0x04AD, (b43_phy_read(dev, 0x04AD)
-						    & 0x00FF) | 0x1300);
+			b43_phy_maskset(dev, 0x04AE, 0xFF00, 0x007F);
+			b43_phy_maskset(dev, 0x04AD, 0x00FF, 0x1300);
 		} else if (phy->rev >= 6) {
 			b43_ofdmtab_write16(dev, 0x1A00, 0x3, 0x007F);
 			b43_ofdmtab_write16(dev, 0x1A00, 0x2, 0x007F);
@@ -3627,9 +3543,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 		b43_write16(dev, 0x03E6, 0x0122);
 	} else {
 		if (phy->analog >= 2) {
-			b43_phy_write(dev, B43_PHY_CCK(0x03),
-				      (b43_phy_read(dev, B43_PHY_CCK(0x03))
-				       & 0xFFBF) | 0x40);
+			b43_phy_maskset(dev, B43_PHY_CCK(0x03), 0xFFBF, 0x0040);
 		}
 		b43_write16(dev, B43_MMIO_CHANNEL_EXT,
 			    (b43_read16(dev, B43_MMIO_CHANNEL_EXT) | 0x2000));
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index e632125..e7e532b 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -73,11 +73,9 @@ void b43_wa_initgains(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x001D, 0x0F40);
 	b43_phy_write(dev, 0x001F, 0x1C00);
 	if (phy->rev <= 3)
-		b43_phy_write(dev, 0x002A,
-			(b43_phy_read(dev, 0x002A) & 0x00FF) | 0x0400);
+		b43_phy_maskset(dev, 0x002A, 0x00FF, 0x0400);
 	else if (phy->rev == 5) {
-		b43_phy_write(dev, 0x002A,
-			(b43_phy_read(dev, 0x002A) & 0x00FF) | 0x1A00);
+		b43_phy_maskset(dev, 0x002A, 0x00FF, 0x1A00);
 		b43_phy_write(dev, 0x00CC, 0x2121);
 	}
 	if (phy->rev >= 3)
@@ -271,8 +269,7 @@ static void b43_wa_2060txlna_gain(struct b43_wldev *dev)
 
 static void b43_wa_lms(struct b43_wldev *dev)
 {
-	b43_phy_write(dev, 0x0055,
-		(b43_phy_read(dev, 0x0055) & 0xFFC0) | 0x0004);
+	b43_phy_maskset(dev, 0x0055, 0xFFC0, 0x0004);
 }
 
 static void b43_wa_mixedsignal(struct b43_wldev *dev)
@@ -332,8 +329,7 @@ static void b43_wa_crs_ed(struct b43_wldev *dev)
 
 static void b43_wa_crs_thr(struct b43_wldev *dev)
 {
-	b43_phy_write(dev, B43_PHY_CRS0,
-			(b43_phy_read(dev, B43_PHY_CRS0) & ~0x03C0) | 0xD000);
+	b43_phy_maskset(dev, B43_PHY_CRS0, ~0x03C0, 0xD000);
 }
 
 static void b43_wa_crs_blank(struct b43_wldev *dev)
@@ -390,72 +386,47 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 3, 25);
 	}
 
-	b43_phy_write(dev, B43_PHY_CCKSHIFTBITS_WA,
-		(b43_phy_read(dev, B43_PHY_CCKSHIFTBITS_WA) & ~0xFF00) | 0x5700);
-	b43_phy_write(dev, B43_PHY_OFDM(0x1A),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x1A)) & ~0x007F) | 0x000F);
-	b43_phy_write(dev, B43_PHY_OFDM(0x1A),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x1A)) & ~0x3F80) | 0x2B80);
-	b43_phy_write(dev, B43_PHY_ANTWRSETT,
-		(b43_phy_read(dev, B43_PHY_ANTWRSETT) & 0xF0FF) | 0x0300);
+	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, ~0xFF00, 0x5700);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x007F, 0x000F);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x3F80, 0x2B80);
+	b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xF0FF, 0x0300);
 	b43_radio_write16(dev, 0x7A,
 		b43_radio_read16(dev, 0x7A) | 0x0008);
-	b43_phy_write(dev, B43_PHY_N1P1GAIN,
-		(b43_phy_read(dev, B43_PHY_N1P1GAIN) & ~0x000F) | 0x0008);
-	b43_phy_write(dev, B43_PHY_P1P2GAIN,
-		(b43_phy_read(dev, B43_PHY_P1P2GAIN) & ~0x0F00) | 0x0600);
-	b43_phy_write(dev, B43_PHY_N1N2GAIN,
-		(b43_phy_read(dev, B43_PHY_N1N2GAIN) & ~0x0F00) | 0x0700);
-	b43_phy_write(dev, B43_PHY_N1P1GAIN,
-		(b43_phy_read(dev, B43_PHY_N1P1GAIN) & ~0x0F00) | 0x0100);
+	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, ~0x000F, 0x0008);
+	b43_phy_maskset(dev, B43_PHY_P1P2GAIN, ~0x0F00, 0x0600);
+	b43_phy_maskset(dev, B43_PHY_N1N2GAIN, ~0x0F00, 0x0700);
+	b43_phy_maskset(dev, B43_PHY_N1P1GAIN, ~0x0F00, 0x0100);
 	if (phy->rev == 1) {
-		b43_phy_write(dev, B43_PHY_N1N2GAIN,
-				  (b43_phy_read(dev, B43_PHY_N1N2GAIN)
-				   & ~0x000F) | 0x0007);
+		b43_phy_maskset(dev, B43_PHY_N1N2GAIN, ~0x000F, 0x0007);
 	}
-	b43_phy_write(dev, B43_PHY_OFDM(0x88),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x88)) & ~0x00FF) | 0x001C);
-	b43_phy_write(dev, B43_PHY_OFDM(0x88),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x88)) & ~0x3F00) | 0x0200);
-	b43_phy_write(dev, B43_PHY_OFDM(0x96),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x96)) & ~0x00FF) | 0x001C);
-	b43_phy_write(dev, B43_PHY_OFDM(0x89),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x89)) & ~0x00FF) | 0x0020);
-	b43_phy_write(dev, B43_PHY_OFDM(0x89),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x89)) & ~0x3F00) | 0x0200);
-	b43_phy_write(dev, B43_PHY_OFDM(0x82),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & ~0x00FF) | 0x002E);
-	b43_phy_write(dev, B43_PHY_OFDM(0x96),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x96)) & ~0xFF00) | 0x1A00);
-	b43_phy_write(dev, B43_PHY_OFDM(0x81),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x81)) & ~0x00FF) | 0x0028);
-	b43_phy_write(dev, B43_PHY_OFDM(0x81),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x81)) & ~0xFF00) | 0x2C00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), ~0x00FF, 0x001C);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x88), ~0x3F00, 0x0200);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), ~0x00FF, 0x001C);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x00FF, 0x0020);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x3F00, 0x0200);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), ~0x00FF, 0x002E);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), ~0xFF00, 0x1A00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0x00FF, 0x0028);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0xFF00, 0x2C00);
 	if (phy->rev == 1) {
 		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
-		b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-			(b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x001E) | 0x0002);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), ~0x001E, 0x0002);
 	} else {
 		b43_phy_write(dev, B43_PHY_OFDM(0x1B),
 			b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x001E);
 		b43_phy_write(dev, B43_PHY_OFDM(0x1F), 0x287A);
-		b43_phy_write(dev, B43_PHY_LPFGAINCTL,
-			(b43_phy_read(dev, B43_PHY_LPFGAINCTL) & ~0x000F) | 0x0004);
+		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0x000F, 0x0004);
 		if (phy->rev >= 6) {
 			b43_phy_write(dev, B43_PHY_OFDM(0x22), 0x287A);
-			b43_phy_write(dev, B43_PHY_LPFGAINCTL,
-				(b43_phy_read(dev, B43_PHY_LPFGAINCTL) & ~0xF000) | 0x3000);
+			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0xF000, 0x3000);
 		}
 	}
-	b43_phy_write(dev, B43_PHY_DIVSRCHIDX,
-		(b43_phy_read(dev, B43_PHY_DIVSRCHIDX) & 0x8080) | 0x7874);
+	b43_phy_maskset(dev, B43_PHY_DIVSRCHIDX, 0x8080, 0x7874);
 	b43_phy_write(dev, B43_PHY_OFDM(0x8E), 0x1C00);
 	if (phy->rev == 1) {
-		b43_phy_write(dev, B43_PHY_DIVP1P2GAIN,
-			(b43_phy_read(dev, B43_PHY_DIVP1P2GAIN) & ~0x0F00) | 0x0600);
+		b43_phy_maskset(dev, B43_PHY_DIVP1P2GAIN, ~0x0F00, 0x0600);
 		b43_phy_write(dev, B43_PHY_OFDM(0x8B), 0x005E);
-		b43_phy_write(dev, B43_PHY_ANTWRSETT,
-			(b43_phy_read(dev, B43_PHY_ANTWRSETT) & ~0x00FF) | 0x001E);
+		b43_phy_maskset(dev, B43_PHY_ANTWRSETT, ~0x00FF, 0x001E);
 		b43_phy_write(dev, B43_PHY_OFDM(0x8D), 0x0002);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC3_R1, 0, 0);
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC3_R1, 1, 7);
-- 
1.5.4.4.684.g0e08


