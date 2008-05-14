Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:33834 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbYENS4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:56:44 -0400
Received: by wf-out-1314.google.com with SMTP id 27so20423wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:56:44 -0700 (PDT)
Subject: [PATCH 3/5] b43: phy.c use b43_phy_maskset where possible
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 11:56:35 -0700
Message-Id: <1210791395.6191.38.camel@brick> (sfid-20080514_205649_755542_38DD1F15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  256 +++++++++++++---------------------------
 1 files changed, 82 insertions(+), 174 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 5bddd3d..0ddb5d8 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -585,10 +585,10 @@ static void hardware_pctl_init_gphy(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	b43_phy_write(dev, 0x0036, (b43_phy_read(dev, 0x0036) & 0xFFC0)
-		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
-	b43_phy_write(dev, 0x0478, (b43_phy_read(dev, 0x0478) & 0xFF00)
-		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
+	b43_phy_maskset(dev, 0x0036,
+		        0xFFC0, phy->tgt_idle_tssi - phy->cur_idle_tssi);
+	b43_phy_maskset(dev, 0x0478,
+		        0xFF00, phy->tgt_idle_tssi - phy->cur_idle_tssi);
 	b43_gphy_tssi_power_lt_init(dev);
 	b43_gphy_gain_lt_init(dev);
 	b43_phy_mask(dev, 0x0060, 0xFFBF);
@@ -641,11 +641,9 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 	b43_phy_set(dev, 0x047C, 0x0002);
 	b43_phy_set(dev, 0x047A, 0xF000);
 	if (phy->radio_ver == 0x2050 && phy->radio_rev == 8) {
-		b43_phy_write(dev, 0x047A, (b43_phy_read(dev, 0x047A)
-					    & 0xFF0F) | 0x0010);
+		b43_phy_maskset(dev, 0x047A, 0xFF0F, 0x0010);
 		b43_phy_set(dev, 0x005D, 0x8000);
-		b43_phy_write(dev, 0x004E, (b43_phy_read(dev, 0x004E)
-					    & 0xFFC0) | 0x0010);
+		b43_phy_maskset(dev, 0x004E, 0xFFC0, 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
 		b43_phy_set(dev, 0x0036, 0x0400);
 	} else {
@@ -653,11 +651,9 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 		b43_phy_set(dev, 0x0036, 0x0400);
 		b43_phy_mask(dev, 0x005D, 0x7FFF);
 		b43_phy_mask(dev, 0x004F, 0xFFFE);
-		b43_phy_write(dev, 0x004E, (b43_phy_read(dev, 0x004E)
-					    & 0xFFC0) | 0x0010);
+		b43_phy_maskset(dev, 0x004E, 0xFFC0, 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
-		b43_phy_write(dev, 0x047A, (b43_phy_read(dev, 0x047A)
-					    & 0xFF0F) | 0x0010);
+		b43_phy_maskset(dev, 0x047A, 0xFF0F, 0x0010);
 	}
 }
 
@@ -772,8 +768,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 
 	b43_phy_mask(dev, B43_PHY_CRS0, ~B43_PHY_CRS0_EN);
 	b43_phy_set(dev, B43_PHY_OFDM(0x1B), 0x1000);
-	b43_phy_write(dev, B43_PHY_OFDM(0x82),
-		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & 0xF0FF) | 0x0300);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), 0xF0FF, 0x0300);
 	b43_radio_write16(dev, 0x0009,
 		b43_radio_read16(dev, 0x0009) | 0x0080);
 	b43_radio_write16(dev, 0x0012,
@@ -805,14 +800,10 @@ static void b43_phy_ww(struct b43_wldev *dev)
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
@@ -867,9 +858,7 @@ static void b43_phy_inita(struct b43_wldev *dev)
 
 	if ((phy->type == B43_PHYTYPE_G) &&
 	    (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)) {
-		b43_phy_write(dev, B43_PHY_OFDM(0x6E),
-				  (b43_phy_read(dev, B43_PHY_OFDM(0x6E))
-				   & 0xE000) | 0x3CF);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0x6E), 0xE000, 0x3CF);
 	}
 }
 
@@ -892,8 +881,7 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 			value += 0x202;
 		}
 	}
-	b43_phy_write(dev, 0x0035, (b43_phy_read(dev, 0x0035) & 0xF0FF)
-		      | 0x0700);
+	b43_phy_maskset(dev, 0x0035, 0xF0FF, 0x0700);
 	if (phy->radio_ver == 0x2050)
 		b43_phy_write(dev, 0x0038, 0x0667);
 
@@ -913,12 +901,9 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 
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
 
 	if (dev->bad_frames_preempt)
@@ -1081,8 +1066,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0038, 0x0668);
 	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
 	if (phy->radio_rev <= 5) {
-		b43_phy_write(dev, 0x5D, (b43_phy_read(dev, 0x5D)
-					  & 0xFF80) | 0x0003);
+		b43_phy_maskset(dev, 0x5D, 0xFF80, 0x0003);
 	}
 	if (phy->radio_rev <= 2)
 		b43_radio_write16(dev, 0x005D, 0x000D);
@@ -1091,8 +1075,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 		b43_write16(dev, 0x3E4, 9);
 		b43_phy_mask(dev, 0x61, 0x0FFF);
 	} else {
-		b43_phy_write(dev, 0x0002, (b43_phy_read(dev, 0x0002) & 0xFFC0)
-			      | 0x0004);
+		b43_phy_maskset(dev, 0x0002, 0xFFC0, 0x0004);
 	}
 	if (phy->type == B43_PHYTYPE_B)
 		B43_WARN_ON(1);
@@ -1148,9 +1131,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x000C);
 	b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x000C);
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0030);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
-		       & 0xFFCF) | 0x10);
+	b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xFFCF, 0x0010);
 
 	b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0780);
 	b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
@@ -1162,9 +1143,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0004);
 		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFB);
 	}
-	b43_phy_write(dev, B43_PHY_CCK(0x03),
-		      (b43_phy_read(dev, B43_PHY_CCK(0x03))
-		       & 0xFF9F) | 0x40);
+	b43_phy_maskset(dev, B43_PHY_CCK(0x03), 0xFF9F, 0x0040);
 
 	if (phy->radio_rev == 8) {
 		b43_radio_write16(dev, 0x43, 0x000F);
@@ -1181,12 +1160,8 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8020);
 	b43_phy_write(dev, B43_PHY_LO_CTL, 0);
 
-	b43_phy_write(dev, B43_PHY_CCK(0x2B),
-		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
-		       & 0xFFC0) | 0x01);
-	b43_phy_write(dev, B43_PHY_CCK(0x2B),
-		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
-		       & 0xC0FF) | 0x800);
+	b43_phy_maskset(dev, B43_PHY_CCK(0x2B), 0xFFC0, 0x0001);
+	b43_phy_maskset(dev, B43_PHY_CCK(0x2B), 0xC0FF, 0x0800);
 
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0100);
 	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xCFFF);
@@ -1205,12 +1180,8 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	for (i = 0; i < loop_i_max; i++) {
 		for (j = 0; j < 16; j++) {
 			b43_radio_write16(dev, 0x43, i);
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
-				       & 0xF0FF) | (j << 8));
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      (b43_phy_read(dev, B43_PHY_PGACTL)
-				       & 0x0FFF) | 0xA000);
+			b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xF0FF, j << 8);
+			b43_phy_maskset(dev, B43_PHY_PGACTL, 0x0FFF, 0xA000);
 			b43_phy_set(dev, B43_PHY_PGACTL, 0xF000);
 			udelay(20);
 			if (b43_phy_read(dev, B43_PHY_LO_LEAKAGE) >= 0xDFC)
@@ -1224,12 +1195,8 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x0030);
 		trsw_rx = 0x1B;
 		for (j = j - 8; j < 16; j++) {
-			b43_phy_write(dev, B43_PHY_RFOVERVAL,
-				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
-				       & 0xF0FF) | (j << 8));
-			b43_phy_write(dev, B43_PHY_PGACTL,
-				      (b43_phy_read(dev, B43_PHY_PGACTL)
-				       & 0x0FFF) | 0xA000);
+			b43_phy_maskset(dev, B43_PHY_RFOVERVAL, 0xF0FF, j << 8);
+			b43_phy_maskset(dev, B43_PHY_PGACTL, 0x0FFF, 0xA000);
 			b43_phy_set(dev, B43_PHY_PGACTL, 0xF000);
 			udelay(20);
 			trsw_rx -= 3;
@@ -1305,9 +1272,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
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
@@ -1337,10 +1302,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
 				  | phy->lo_control->tx_bias);
 	}
 	if (phy->rev >= 6) {
-		b43_phy_write(dev, B43_PHY_CCK(0x36),
-			      (b43_phy_read(dev, B43_PHY_CCK(0x36))
-			       & 0x0FFF) | (phy->lo_control->
-					    tx_bias << 12));
+		b43_phy_maskset(dev, B43_PHY_CCK(0x36),
+				0x0FFF, phy->lo_control->tx_bias << 12);
 	}
 	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
 		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
@@ -1395,13 +1358,11 @@ void b43_phy_set_baseband_attenuation(struct b43_wldev *dev,
 						 & 0xFFF0) |
 			    baseband_attenuation);
 	} else if (phy->analog > 1) {
-		b43_phy_write(dev, B43_PHY_DACCTL,
-			      (b43_phy_read(dev, B43_PHY_DACCTL)
-			       & 0xFFC3) | (baseband_attenuation << 2));
+		b43_phy_maskset(dev, B43_PHY_DACCTL,
+				0xFFC3, baseband_attenuation << 2);
 	} else {
-		b43_phy_write(dev, B43_PHY_DACCTL,
-			      (b43_phy_read(dev, B43_PHY_DACCTL)
-			       & 0xFF87) | (baseband_attenuation << 3));
+		b43_phy_maskset(dev, B43_PHY_DACCTL,
+				0xFF87, baseband_attenuation << 3);
 	}
 }
 
@@ -2046,12 +2007,9 @@ static void b43_set_all_gains(struct b43_wldev *dev,
 
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
@@ -2082,12 +2040,9 @@ static void b43_set_original_gains(struct b43_wldev *dev)
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
 
@@ -2168,8 +2123,7 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 			ret[i - 1] = b43_radio_aci_detect(dev, i);
 	}
 	b43_radio_selectchannel(dev, channel, 0);
-	b43_phy_write(dev, 0x0802,
-		      (b43_phy_read(dev, 0x0802) & 0xFFFC) | 0x0003);
+	b43_phy_maskset(dev, 0x0802, 0xFFFC, 0x0003);
 	b43_phy_mask(dev, 0x0403, 0xFFF8);
 	b43_phy_write(dev, B43_PHY_G_CRS,
 		      b43_phy_read(dev, B43_PHY_G_CRS) | 0x8000);
@@ -2261,11 +2215,9 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	backup[11] = b43_radio_read16(dev, 0x0043);
 
 	b43_phy_mask(dev, 0x0429, 0x7FFF);
-	b43_phy_write(dev, 0x0001,
-		      (b43_phy_read(dev, 0x0001) & 0x3FFF) | 0x4000);
+	b43_phy_maskset(dev, 0x0001, 0x3FFF, 0x4000);
 	b43_phy_set(dev, 0x0811, 0x000C);
-	b43_phy_write(dev, 0x0812,
-		      (b43_phy_read(dev, 0x0812) & 0xFFF3) | 0x0004);
+	b43_phy_maskset(dev, 0x0812, 0xFFF3, 0x0004);
 	b43_phy_mask(dev, 0x0802, 0xFFFC);
 	if (phy->rev >= 6) {
 		backup[12] = b43_phy_read(dev, 0x002E);
@@ -2330,8 +2282,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 			b43_phy_set(dev, 0x0814, 0x0004);
 			b43_phy_mask(dev, 0x0815, 0xFFFB);
 		}
-		b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003) & 0xFF9F)
-			      | 0x0040);
+		b43_phy_maskset(dev, 0x0003, 0xFF9F, 0x0040);
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) | 0x000F);
 		b43_set_all_gains(dev, 3, 0, 1);
@@ -2527,12 +2478,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
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
@@ -2544,10 +2491,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 
 		b43_radio_write16(dev, 0x007A,
 				  b43_radio_read16(dev, 0x007A) & 0x007F);
-		if (phy->rev >= 2) {
-			b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003)
-						    & 0xFF9F) | 0x0040);
-		}
+		if (phy->rev >= 2)
+			b43_phy_maskset(dev, 0x0003, 0xFF9F, 0x0040);
 
 		b43_write16(dev, B43_MMIO_CHANNEL_EXT,
 			    b43_read16(dev, B43_MMIO_CHANNEL_EXT)
@@ -2556,12 +2501,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
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
@@ -2675,15 +2616,10 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 			tmp16 = b43_nrssi_hw_read(dev, 0x20);
 			if (tmp16 >= 0x20)
 				tmp16 -= 0x40;
-			if (tmp16 < 3) {
-				b43_phy_write(dev, 0x048A,
-					      (b43_phy_read(dev, 0x048A)
-					       & 0xF000) | 0x09EB);
-			} else {
-				b43_phy_write(dev, 0x048A,
-					      (b43_phy_read(dev, 0x048A)
-					       & 0xF000) | 0x0AED);
-			}
+			if (tmp16 < 3)
+				b43_phy_maskset(dev, 0x048A, 0xF000, 0x09EB);
+			else
+				b43_phy_maskset(dev, 0x048A, 0xF000, 0x0AED);
 		} else {
 			if (phy->interfmode == B43_INTERFMODE_NONWLAN) {
 				a = 0xE;
@@ -2830,20 +2766,15 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		b43_phy_set(dev, B43_PHY_RADIO_BITFIELD, 0x1000);
 
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
@@ -2900,9 +2831,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		phy_stacksave(0x048C);
 
 		b43_phy_mask(dev, B43_PHY_RADIO_BITFIELD, 0xEFFF);
-		b43_phy_write(dev, B43_PHY_G_CRS,
-			      (b43_phy_read(dev, B43_PHY_G_CRS)
-			       & 0xFFFC) | 0x0002);
+		b43_phy_maskset(dev, B43_PHY_G_CRS, 0xFFFC, 0x0002);
 
 		b43_phy_write(dev, 0x0033, 0x0800);
 		b43_phy_write(dev, 0x04A3, 0x2027);
@@ -2911,8 +2840,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		b43_phy_write(dev, 0x04AA, 0x1CA8);
 		b43_phy_write(dev, 0x04AC, 0x287A);
 
-		b43_phy_write(dev, 0x04A0, (b43_phy_read(dev, 0x04A0)
-					    & 0xFFC0) | 0x001A);
+		b43_phy_maskset(dev, 0x04A0, 0xFFC0, 0x001A);
 		b43_phy_write(dev, 0x04A7, 0x000D);
 
 		if (phy->rev < 2) {
@@ -2925,57 +2853,37 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
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
 			b43_phy_mask(dev, 0x048A, 0x7FFF);
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
 			b43_phy_set(dev, 0x048A, 0x1000);
-			b43_phy_write(dev, 0x048A, (b43_phy_read(dev, 0x048A)
-						    & 0x9FFF) | 0x2000);
+			b43_phy_maskset(dev, 0x048A, 0x9FFF, 0x2000);
 			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_ACIW);
 		}
 		if (phy->rev >= 2) {
 			b43_phy_set(dev, 0x042B, 0x0800);
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
-- 
1.5.5.1.482.g0f174


