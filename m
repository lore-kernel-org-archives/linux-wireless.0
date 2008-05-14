Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:33834 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbYENS4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 14:56:43 -0400
Received: by wf-out-1314.google.com with SMTP id 27so20423wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 11:56:42 -0700 (PDT)
Subject: [PATCH 2/5] b43: phy.c use b43_phy_mask where possible
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 11:56:35 -0700
Message-Id: <1210791395.6191.34.camel@brick> (sfid-20080514_205649_636201_12453AC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |  135 +++++++++++++--------------------------
 1 files changed, 45 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index f27eb5e..5bddd3d 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -591,15 +591,13 @@ static void hardware_pctl_init_gphy(struct b43_wldev *dev)
 		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
 	b43_gphy_tssi_power_lt_init(dev);
 	b43_gphy_gain_lt_init(dev);
-	b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060) & 0xFFBF);
+	b43_phy_mask(dev, 0x0060, 0xFFBF);
 	b43_phy_write(dev, 0x0014, 0x0000);
 
 	B43_WARN_ON(phy->rev < 6);
 	b43_phy_set(dev, 0x0478, 0x0800);
-	b43_phy_write(dev, 0x0478, b43_phy_read(dev, 0x0478)
-		      & 0xFEFF);
-	b43_phy_write(dev, 0x0801, b43_phy_read(dev, 0x0801)
-		      & 0xFFBF);
+	b43_phy_mask(dev, 0x0478, 0xFEFF);
+	b43_phy_mask(dev, 0x0801, 0xFFBF);
 
 	b43_gphy_dc_lt_init(dev, 1);
 }
@@ -638,7 +636,7 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 		return;
 	}
 
-	b43_phy_write(dev, 0x0036, b43_phy_read(dev, 0x0036) & 0xFEFF);
+	b43_phy_mask(dev, 0x0036, 0xFEFF);
 	b43_phy_write(dev, 0x002F, 0x0202);
 	b43_phy_set(dev, 0x047C, 0x0002);
 	b43_phy_set(dev, 0x047A, 0xF000);
@@ -653,10 +651,8 @@ static void b43_hardware_pctl_early_init(struct b43_wldev *dev)
 	} else {
 		b43_phy_set(dev, 0x0036, 0x0200);
 		b43_phy_set(dev, 0x0036, 0x0400);
-		b43_phy_write(dev, 0x005D, b43_phy_read(dev, 0x005D)
-			      & 0x7FFF);
-		b43_phy_write(dev, 0x004F, b43_phy_read(dev, 0x004F)
-			      & 0xFFFE);
+		b43_phy_mask(dev, 0x005D, 0x7FFF);
+		b43_phy_mask(dev, 0x004F, 0xFFFE);
 		b43_phy_write(dev, 0x004E, (b43_phy_read(dev, 0x004E)
 					    & 0xFFC0) | 0x0010);
 		b43_phy_write(dev, 0x002E, 0xC07F);
@@ -774,8 +770,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	u16 b, curr_s, best_s = 0xFFFF;
 	int i;
 
-	b43_phy_write(dev, B43_PHY_CRS0,
-		b43_phy_read(dev, B43_PHY_CRS0) & ~B43_PHY_CRS0_EN);
+	b43_phy_mask(dev, B43_PHY_CRS0, ~B43_PHY_CRS0_EN);
 	b43_phy_set(dev, B43_PHY_OFDM(0x1B), 0x1000);
 	b43_phy_write(dev, B43_PHY_OFDM(0x82),
 		(b43_phy_read(dev, B43_PHY_OFDM(0x82)) & 0xF0FF) | 0x0300);
@@ -838,13 +833,11 @@ static void b43_phy_inita(struct b43_wldev *dev)
 
 	if (phy->rev >= 6) {
 		if (phy->type == B43_PHYTYPE_A)
-			b43_phy_write(dev, B43_PHY_OFDM(0x1B),
-				b43_phy_read(dev, B43_PHY_OFDM(0x1B)) & ~0x1000);
+			b43_phy_mask(dev, B43_PHY_OFDM(0x1B), 0xEFFF);
 		if (b43_phy_read(dev, B43_PHY_ENCORE) & B43_PHY_ENCORE_EN)
 			b43_phy_set(dev, B43_PHY_ENCORE, 0x0010);
 		else
-			b43_phy_write(dev, B43_PHY_ENCORE,
-				b43_phy_read(dev, B43_PHY_ENCORE) & ~0x1010);
+			b43_phy_mask(dev, B43_PHY_ENCORE, 0xEFEF);
 	}
 
 	b43_wa_all(dev);
@@ -1096,8 +1089,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 
 	if (phy->analog == 4) {
 		b43_write16(dev, 0x3E4, 9);
-		b43_phy_write(dev, 0x61, b43_phy_read(dev, 0x61)
-			      & 0x0FFF);
+		b43_phy_mask(dev, 0x61, 0x0FFF);
 	} else {
 		b43_phy_write(dev, 0x0002, (b43_phy_read(dev, 0x0002) & 0xFFC0)
 			      | 0x0004);
@@ -1141,24 +1133,17 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	backup_radio[1] = b43_radio_read16(dev, 0x43);
 	backup_radio[2] = b43_radio_read16(dev, 0x7A);
 
-	b43_phy_write(dev, B43_PHY_CRS0,
-		      b43_phy_read(dev, B43_PHY_CRS0) & 0x3FFF);
+	b43_phy_mask(dev, B43_PHY_CRS0, 0x3FFF);
 	b43_phy_set(dev, B43_PHY_CCKBBANDCFG, 0x8000);
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0002);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xFFFD);
+	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xFFFD);
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0001);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xFFFE);
+	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xFFFE);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0001);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev,
-					   B43_PHY_ANALOGOVERVAL) & 0xFFFE);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFE);
 		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0002);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev,
-					   B43_PHY_ANALOGOVERVAL) & 0xFFFD);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFD);
 	}
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x000C);
 	b43_phy_set(dev, B43_PHY_RFOVERVAL, 0x000C);
@@ -1175,9 +1160,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		      b43_phy_read(dev, B43_PHY_CCK(0x0A)) | 0x2000);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0004);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev,
-					   B43_PHY_ANALOGOVERVAL) & 0xFFFB);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFB);
 	}
 	b43_phy_write(dev, B43_PHY_CCK(0x03),
 		      (b43_phy_read(dev, B43_PHY_CCK(0x03))
@@ -1206,8 +1189,7 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		       & 0xC0FF) | 0x800);
 
 	b43_phy_set(dev, B43_PHY_RFOVER, 0x0100);
-	b43_phy_write(dev, B43_PHY_RFOVERVAL,
-		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xCFFF);
+	b43_phy_mask(dev, B43_PHY_RFOVERVAL, 0xCFFF);
 
 	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
@@ -1397,11 +1379,8 @@ static void b43_phy_initg(struct b43_wldev *dev)
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
 
@@ -2177,9 +2156,8 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 
 	b43_phy_lock(dev);
 	b43_radio_lock(dev);
-	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & 0xFFFC);
-	b43_phy_write(dev, B43_PHY_G_CRS,
-		      b43_phy_read(dev, B43_PHY_G_CRS) & 0x7FFF);
+	b43_phy_mask(dev, 0x0802, 0xFFFC);
+	b43_phy_write(dev, B43_PHY_G_CRS, 0x7FFF);
 	b43_set_all_gains(dev, 3, 8, 1);
 
 	start = (channel - 5 > 0) ? channel - 5 : 1;
@@ -2192,7 +2170,7 @@ u8 b43_radio_aci_scan(struct b43_wldev * dev)
 	b43_radio_selectchannel(dev, channel, 0);
 	b43_phy_write(dev, 0x0802,
 		      (b43_phy_read(dev, 0x0802) & 0xFFFC) | 0x0003);
-	b43_phy_write(dev, 0x0403, b43_phy_read(dev, 0x0403) & 0xFFF8);
+	b43_phy_mask(dev, 0x0403, 0xFFF8);
 	b43_phy_write(dev, B43_PHY_G_CRS,
 		      b43_phy_read(dev, B43_PHY_G_CRS) | 0x8000);
 	b43_set_original_gains(dev);
@@ -2282,13 +2260,13 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	backup[10] = b43_radio_read16(dev, 0x007A);
 	backup[11] = b43_radio_read16(dev, 0x0043);
 
-	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) & 0x7FFF);
+	b43_phy_mask(dev, 0x0429, 0x7FFF);
 	b43_phy_write(dev, 0x0001,
 		      (b43_phy_read(dev, 0x0001) & 0x3FFF) | 0x4000);
 	b43_phy_set(dev, 0x0811, 0x000C);
 	b43_phy_write(dev, 0x0812,
 		      (b43_phy_read(dev, 0x0812) & 0xFFF3) | 0x0004);
-	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & ~(0x1 | 0x2));
+	b43_phy_mask(dev, 0x0802, 0xFFFC);
 	if (phy->rev >= 6) {
 		backup[12] = b43_phy_read(dev, 0x002E);
 		backup[13] = b43_phy_read(dev, 0x002F);
@@ -2333,8 +2311,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 				  b43_radio_read16(dev, 0x007A) & 0x007F);
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 			b43_phy_set(dev, 0x0814, 0x0001);
-			b43_phy_write(dev, 0x0815,
-				      b43_phy_read(dev, 0x0815) & 0xFFFE);
+			b43_phy_mask(dev, 0x0815, 0xFFFE);
 		}
 		b43_phy_set(dev, 0x0811, 0x000C);
 		b43_phy_set(dev, 0x0812, 0x000C);
@@ -2351,8 +2328,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 			b43_phy_set(dev, 0x0814, 0x0004);
-			b43_phy_write(dev, 0x0815,
-				      b43_phy_read(dev, 0x0815) & 0xFFFB);
+			b43_phy_mask(dev, 0x0815, 0xFFFB);
 		}
 		b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003) & 0xFF9F)
 			      | 0x0040);
@@ -2506,9 +2482,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
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
@@ -2540,9 +2515,7 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 				break;
 			case 3:
 			case 5:
-				b43_phy_write(dev, 0x0801,
-					      b43_phy_read(dev, 0x0801)
-					      & 0xFFBF);
+				b43_phy_mask(dev, 0x0801, 0xFFBF);
 				break;
 			}
 			b43_phy_set(dev, 0x0060, 0x0040);
@@ -2622,10 +2595,8 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
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
@@ -2836,9 +2807,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 	case B43_INTERFMODE_NONWLAN:
 		if (phy->rev != 1) {
 			b43_phy_set(dev, 0x042B, 0x0800);
-			b43_phy_write(dev, B43_PHY_G_CRS,
-				      b43_phy_read(dev,
-						   B43_PHY_G_CRS) & ~0x4000);
+			b43_phy_mask(dev, B43_PHY_G_CRS, 0xBFFF);
 			break;
 		}
 		radio_stacksave(0x0078);
@@ -2930,9 +2899,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		phy_stacksave(0x042B);
 		phy_stacksave(0x048C);
 
-		b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-			      b43_phy_read(dev, B43_PHY_RADIO_BITFIELD)
-			      & ~0x1000);
+		b43_phy_mask(dev, B43_PHY_RADIO_BITFIELD, 0xEFFF);
 		b43_phy_write(dev, B43_PHY_G_CRS,
 			      (b43_phy_read(dev, B43_PHY_G_CRS)
 			       & 0xFFFC) | 0x0002);
@@ -2986,8 +2953,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 					    & 0xFFF0) | 0x000B);
 
 		if (phy->rev >= 3) {
-			b43_phy_write(dev, 0x048A, b43_phy_read(dev, 0x048A)
-				      & ~0x8000);
+			b43_phy_mask(dev, 0x048A, 0x7FFF);
 			b43_phy_write(dev, 0x0415, (b43_phy_read(dev, 0x0415)
 						    & 0x8000) | 0x36D8);
 			b43_phy_write(dev, 0x0416, (b43_phy_read(dev, 0x0416)
@@ -3013,8 +2979,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		} else if (phy->rev >= 6) {
 			b43_ofdmtab_write16(dev, 0x1A00, 0x3, 0x007F);
 			b43_ofdmtab_write16(dev, 0x1A00, 0x2, 0x007F);
-			b43_phy_write(dev, 0x04AD, b43_phy_read(dev, 0x04AD)
-				      & 0x00FF);
+			b43_phy_mask(dev, 0x04AD, 0x00FF);
 		}
 		b43_calc_nrssi_slope(dev);
 		break;
@@ -3032,20 +2997,16 @@ b43_radio_interference_mitigation_disable(struct b43_wldev *dev, int mode)
 	switch (mode) {
 	case B43_INTERFMODE_NONWLAN:
 		if (phy->rev != 1) {
-			b43_phy_write(dev, 0x042B,
-				      b43_phy_read(dev, 0x042B) & ~0x0800);
+			b43_phy_mask(dev, 0x042B, 0xF7FF);
 			b43_phy_set(dev, B43_PHY_G_CRS, 0x4000);
 			break;
 		}
 		radio_stackrestore(0x0078);
 		b43_calc_nrssi_threshold(dev);
 		phy_stackrestore(0x0406);
-		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) & ~0x0800);
-		if (!dev->bad_frames_preempt) {
-			b43_phy_write(dev, B43_PHY_RADIO_BITFIELD,
-				      b43_phy_read(dev, B43_PHY_RADIO_BITFIELD)
-				      & ~(1 << 11));
-		}
+		b43_phy_mask(dev, 0x042B, 0xF7FF);
+		if (!dev->bad_frames_preempt)
+			b43_phy_mask(dev, B43_PHY_RADIO_BITFIELD, ~(1 << 11));
 		b43_phy_set(dev, B43_PHY_G_CRS, 0x4000);
 		phy_stackrestore(0x04A0);
 		phy_stackrestore(0x04A1);
@@ -3355,14 +3316,9 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 		sav.phy_classctl = b43_phy_read(dev, B43_PHY_CLASSCTL);
 
 		b43_phy_set(dev, B43_PHY_ANALOGOVER, 0x0003);
-		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
-			      b43_phy_read(dev, B43_PHY_ANALOGOVERVAL)
-			      & 0xFFFC);
-		b43_phy_write(dev, B43_PHY_CRS0, b43_phy_read(dev, B43_PHY_CRS0)
-			      & 0x7FFF);
-		b43_phy_write(dev, B43_PHY_CLASSCTL,
-			      b43_phy_read(dev, B43_PHY_CLASSCTL)
-			      & 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_ANALOGOVERVAL, 0xFFFC);
+		b43_phy_mask(dev, B43_PHY_CRS0, 0x7FFF);
+		b43_phy_mask(dev, B43_PHY_CLASSCTL, 0xFFFC);
 		if (has_loopback_gain(phy)) {
 			sav.phy_lo_mask = b43_phy_read(dev, B43_PHY_LO_MASK);
 			sav.phy_lo_ctl = b43_phy_read(dev, B43_PHY_LO_CTL);
@@ -3383,8 +3339,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 	b43_write16(dev, 0x3E2, b43_read16(dev, 0x3E2) | 0x8000);
 
 	sav.phy_syncctl = b43_phy_read(dev, B43_PHY_SYNCCTL);
-	b43_phy_write(dev, B43_PHY_SYNCCTL, b43_phy_read(dev, B43_PHY_SYNCCTL)
-		      & 0xFF7F);
+	b43_phy_mask(dev, B43_PHY_SYNCCTL, 0xFF7F);
 	sav.reg_3E6 = b43_read16(dev, 0x3E6);
 	sav.reg_3F4 = b43_read16(dev, 0x3F4);
 
@@ -3795,8 +3750,8 @@ void b43_radio_turn_on(struct b43_wldev *dev)
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
-- 
1.5.5.1.482.g0f174


