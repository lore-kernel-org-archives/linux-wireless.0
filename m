Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:52616 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYJCUs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:57 -0400
Received: by yx-out-2324.google.com with SMTP id 8so298717yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:56 -0700 (PDT)
Subject: [PATCH 7/8] b43: remove b43_radio_{read|write}16 from phy_g.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:48 -0700
Message-Id: <1223066928.6512.32.camel@brick> (sfid-20081003_224910_629375_3B4A6706)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the masking/setting helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy_g.c |  285 ++++++++++++++++---------------------
 1 files changed, 123 insertions(+), 162 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 232181f..20bef1f 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -249,20 +249,16 @@ void b43_set_txpower_g(struct b43_wldev *dev,
 	b43_gphy_set_baseband_attenuation(dev, bb);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_RFATT, rf);
 	if (phy->radio_ver == 0x2050 && phy->radio_rev == 8) {
-		b43_radio_write16(dev, 0x43,
+		b43_radio_write(dev, 0x43,
 				  (rf & 0x000F) | (tx_control & 0x0070));
 	} else {
-		b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
-					      & 0xFFF0) | (rf & 0x000F));
-		b43_radio_write16(dev, 0x52, (b43_radio_read16(dev, 0x52)
-					      & ~0x0070) | (tx_control &
-							    0x0070));
+		b43_radio_maskset(dev, 0x43, 0xFFF0, (rf & 0x000F));
+		b43_radio_maskset(dev, 0x52, ~0x0070, (tx_control & 0x0070));
 	}
 	if (has_tx_magnification(phy)) {
-		b43_radio_write16(dev, 0x52, tx_magn | tx_bias);
+		b43_radio_write(dev, 0x52, tx_magn | tx_bias);
 	} else {
-		b43_radio_write16(dev, 0x52, (b43_radio_read16(dev, 0x52)
-					      & 0xFFF0) | (tx_bias & 0x000F));
+		b43_radio_maskset(dev, 0x52, 0xFFF0, (tx_bias & 0x000F));
 	}
 	b43_lo_g_adjust(dev);
 }
@@ -451,8 +447,8 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	backup[7] = b43_phy_read(dev, 0x0058);
 	backup[8] = b43_phy_read(dev, 0x000A);
 	backup[9] = b43_phy_read(dev, 0x0003);
-	backup[10] = b43_radio_read16(dev, 0x007A);
-	backup[11] = b43_radio_read16(dev, 0x0043);
+	backup[10] = b43_radio_read(dev, 0x007A);
+	backup[11] = b43_radio_read(dev, 0x0043);
 
 	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) & 0x7FFF);
 	b43_phy_write(dev, 0x0001,
@@ -480,8 +476,8 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060) | 0x0040);
 		b43_phy_write(dev, 0x0014, b43_phy_read(dev, 0x0014) | 0x0200);
 	}
-	b43_radio_write16(dev, 0x007A, b43_radio_read16(dev, 0x007A) | 0x0070);
-	b43_radio_write16(dev, 0x007A, b43_radio_read16(dev, 0x007A) | 0x0080);
+	b43_radio_set(dev, 0x007A, 0x0070);
+	b43_radio_set(dev, 0x007A, 0x0080);
 	udelay(30);
 
 	v47F = (s16) ((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
@@ -489,7 +485,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		v47F -= 0x40;
 	if (v47F == 31) {
 		for (i = 7; i >= 4; i--) {
-			b43_radio_write16(dev, 0x007B, i);
+			b43_radio_write(dev, 0x007B, i);
 			udelay(20);
 			v47F =
 			    (s16) ((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
@@ -501,18 +497,15 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		if (saved == 0xFFFF)
 			saved = 4;
 	} else {
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) & 0x007F);
+		b43_radio_mask(dev, 0x007A, 0x007F);
 		if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
-			b43_phy_write(dev, 0x0814,
-				      b43_phy_read(dev, 0x0814) | 0x0001);
-			b43_phy_write(dev, 0x0815,
-				      b43_phy_read(dev, 0x0815) & 0xFFFE);
+			b43_phy_set(dev, 0x0814, 0x0001);
+			b43_phy_mask(dev, 0x0815, 0xFFFE);
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
@@ -530,18 +523,16 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		}
 		b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003) & 0xFF9F)
 			      | 0x0040);
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) | 0x000F);
+		b43_radio_set(dev, 0x007A, 0x000F);
 		b43_set_all_gains(dev, 3, 0, 1);
-		b43_radio_write16(dev, 0x0043, (b43_radio_read16(dev, 0x0043)
-						& 0x00F0) | 0x000F);
+		b43_radio_maskset(dev, 0x0043, 0x00F0, 0x000F);
 		udelay(30);
 		v47F = (s16) ((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
 		if (v47F >= 0x20)
 			v47F -= 0x40;
 		if (v47F == -32) {
 			for (i = 0; i < 4; i++) {
-				b43_radio_write16(dev, 0x007B, i);
+				b43_radio_write(dev, 0x007B, i);
 				udelay(20);
 				v47F =
 				    (s16) ((b43_phy_read(dev, 0x047F) >> 8) &
@@ -556,7 +547,7 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 		} else
 			saved = 0;
 	}
-	b43_radio_write16(dev, 0x007B, saved);
+	b43_radio_write(dev, 0x007B, saved);
 
 	if (phy->rev >= 6) {
 		b43_phy_write(dev, 0x002E, backup[12]);
@@ -573,8 +564,8 @@ static void b43_calc_nrssi_offset(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0058, backup[7]);
 	b43_phy_write(dev, 0x000A, backup[8]);
 	b43_phy_write(dev, 0x0003, backup[9]);
-	b43_radio_write16(dev, 0x0043, backup[11]);
-	b43_radio_write16(dev, 0x007A, backup[10]);
+	b43_radio_write(dev, 0x0043, backup[11]);
+	b43_radio_write(dev, 0x007A, backup[10]);
 	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) | 0x1 | 0x2);
 	b43_phy_write(dev, 0x0429, b43_phy_read(dev, 0x0429) | 0x8000);
 	b43_set_original_gains(dev);
@@ -594,7 +585,6 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	u16 backup[18] = { 0 };
-	u16 tmp;
 	s16 nrssi0, nrssi1;
 
 	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
@@ -609,9 +599,9 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & 0xFFFC);
 	backup[7] = b43_read16(dev, 0x03E2);
 	b43_write16(dev, 0x03E2, b43_read16(dev, 0x03E2) | 0x8000);
-	backup[0] = b43_radio_read16(dev, 0x007A);
-	backup[1] = b43_radio_read16(dev, 0x0052);
-	backup[2] = b43_radio_read16(dev, 0x0043);
+	backup[0] = b43_radio_read(dev, 0x007A);
+	backup[1] = b43_radio_read(dev, 0x0052);
+	backup[2] = b43_radio_read(dev, 0x0043);
 	backup[3] = b43_phy_read(dev, 0x0015);
 	backup[4] = b43_phy_read(dev, 0x005A);
 	backup[5] = b43_phy_read(dev, 0x0059);
@@ -652,11 +642,9 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 		b43_phy_write(dev, 0x0014, b43_phy_read(dev, 0x0014)
 			      | 0x0200);
 	}
-	b43_radio_write16(dev, 0x007A,
-			  b43_radio_read16(dev, 0x007A) | 0x0070);
+	b43_radio_set(dev, 0x007A, 0x0070);
 	b43_set_all_gains(dev, 0, 8, 0);
-	b43_radio_write16(dev, 0x007A,
-			  b43_radio_read16(dev, 0x007A) & 0x00F7);
+	b43_radio_mask(dev, 0x007A, 0x00F7);
 	if (phy->rev >= 2) {
 		b43_phy_write(dev, 0x0811,
 			      (b43_phy_read(dev, 0x0811) & 0xFFCF) |
@@ -665,16 +653,14 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 			      (b43_phy_read(dev, 0x0812) & 0xFFCF) |
 			      0x0010);
 	}
-	b43_radio_write16(dev, 0x007A,
-			  b43_radio_read16(dev, 0x007A) | 0x0080);
+	b43_radio_set(dev, 0x007A, 0x0080);
 	udelay(20);
 
 	nrssi0 = (s16) ((b43_phy_read(dev, 0x047F) >> 8) & 0x003F);
 	if (nrssi0 >= 0x0020)
 		nrssi0 -= 0x0040;
 
-	b43_radio_write16(dev, 0x007A,
-			  b43_radio_read16(dev, 0x007A) & 0x007F);
+	b43_radio_mask(dev, 0x007A, 0x007F);
 	if (phy->rev >= 2) {
 		b43_phy_write(dev, 0x0003, (b43_phy_read(dev, 0x0003)
 					    & 0xFF9F) | 0x0040);
@@ -683,8 +669,7 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 	b43_write16(dev, B43_MMIO_CHANNEL_EXT,
 		    b43_read16(dev, B43_MMIO_CHANNEL_EXT)
 		    | 0x2000);
-	b43_radio_write16(dev, 0x007A,
-			  b43_radio_read16(dev, 0x007A) | 0x000F);
+	b43_radio_set(dev, 0x007A, 0x000F);
 	b43_phy_write(dev, 0x0015, 0xF330);
 	if (phy->rev >= 2) {
 		b43_phy_write(dev, 0x0812,
@@ -697,12 +682,10 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 
 	b43_set_all_gains(dev, 3, 0, 1);
 	if (phy->radio_rev == 8) {
-		b43_radio_write16(dev, 0x0043, 0x001F);
+		b43_radio_write(dev, 0x0043, 0x001F);
 	} else {
-		tmp = b43_radio_read16(dev, 0x0052) & 0xFF0F;
-		b43_radio_write16(dev, 0x0052, tmp | 0x0060);
-		tmp = b43_radio_read16(dev, 0x0043) & 0xFFF0;
-		b43_radio_write16(dev, 0x0043, tmp | 0x0009);
+		b43_radio_maskset(dev, 0x0052, 0xFF0F, 0x0060);
+		b43_radio_maskset(dev, 0x0043, 0xFFF0, 0x0009);
 	}
 	b43_phy_write(dev, 0x005A, 0x0480);
 	b43_phy_write(dev, 0x0059, 0x0810);
@@ -732,9 +715,9 @@ void b43_calc_nrssi_slope(struct b43_wldev *dev)
 			      b43_phy_read(dev, 0x0811) & 0xFFCF);
 	}
 
-	b43_radio_write16(dev, 0x007A, backup[0]);
-	b43_radio_write16(dev, 0x0052, backup[1]);
-	b43_radio_write16(dev, 0x0043, backup[2]);
+	b43_radio_write(dev, 0x007A, backup[0]);
+	b43_radio_write(dev, 0x0052, backup[1]);
+	b43_radio_write(dev, 0x0043, backup[2]);
 	b43_write16(dev, 0x03E2, backup[7]);
 	b43_write16(dev, 0x03E6, backup[8]);
 	b43_write16(dev, B43_MMIO_CHANNEL_EXT, backup[9]);
@@ -869,11 +852,11 @@ static u16 _stack_restore(u32 * stackptr, u8 id, u16 offset)
 #define radio_stacksave(offset)						\
 	do {								\
 		_stack_save(stack, &stackidx, 0x2, (offset),		\
-			    b43_radio_read16(dev, (offset)));	\
+			    b43_radio_read(dev, (offset)));	\
 	} while (0)
 #define radio_stackrestore(offset)					\
 	do {								\
-		b43_radio_write16(dev, (offset),			\
+		b43_radio_write(dev, (offset),				\
 				      _stack_restore(stack, 0x2,	\
 						     (offset)));	\
 	} while (0)
@@ -909,7 +892,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 			break;
 		}
 		radio_stacksave(0x0078);
-		tmp = (b43_radio_read16(dev, 0x0078) & 0x001E);
+		tmp = (b43_radio_read(dev, 0x0078) & 0x001E);
 		B43_WARN_ON(tmp > 15);
 		flipped = bitrev4(tmp);
 		if (flipped < 10 && flipped >= 8)
@@ -917,7 +900,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		else if (flipped >= 10)
 			flipped -= 3;
 		flipped = (bitrev4(flipped) << 1) | 0x0020;
-		b43_radio_write16(dev, 0x0078, flipped);
+		b43_radio_write(dev, 0x0078, flipped);
 
 		b43_calc_nrssi_threshold(dev);
 
@@ -1199,7 +1182,7 @@ static u16 b43_radio_core_calibration_value(struct b43_wldev *dev)
 		0x0E, 0x0F, 0x0D, 0x0F,
 	};
 
-	reg = b43_radio_read16(dev, 0x60);
+	reg = b43_radio_read(dev, 0x60);
 	index = (reg & 0x001E) >> 1;
 	ret = rcc_table[index] << 1;
 	ret |= (reg & 0x0001);
@@ -1366,9 +1349,9 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 
 	memset(&sav, 0, sizeof(sav));	/* get rid of "may be used uninitialized..." */
 
-	sav.radio_43 = b43_radio_read16(dev, 0x43);
-	sav.radio_51 = b43_radio_read16(dev, 0x51);
-	sav.radio_52 = b43_radio_read16(dev, 0x52);
+	sav.radio_43 = b43_radio_read(dev, 0x43);
+	sav.radio_51 = b43_radio_read(dev, 0x51);
+	sav.radio_52 = b43_radio_read(dev, 0x52);
 	sav.phy_pgactl = b43_phy_read(dev, B43_PHY_PGACTL);
 	sav.phy_cck_5A = b43_phy_read(dev, B43_PHY_CCK(0x5A));
 	sav.phy_cck_59 = b43_phy_read(dev, B43_PHY_CCK(0x59));
@@ -1440,7 +1423,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 	rcc = b43_radio_core_calibration_value(dev);
 
 	if (phy->type == B43_PHYTYPE_B)
-		b43_radio_write16(dev, 0x78, 0x26);
+		b43_radio_write(dev, 0x78, 0x26);
 	if (phy->gmode || phy->rev >= 2) {
 		b43_phy_write(dev, B43_PHY_RFOVERVAL,
 			      radio2050_rfover_val(dev, B43_PHY_RFOVERVAL,
@@ -1454,14 +1437,12 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 						   LPD(0, 0, 1)));
 	}
 	b43_phy_write(dev, B43_PHY_PGACTL, 0xBFA0);
-	b43_radio_write16(dev, 0x51, b43_radio_read16(dev, 0x51)
-			  | 0x0004);
+	b43_radio_set(dev, 0x51, 0x0004);
 	if (phy->radio_rev == 8) {
-		b43_radio_write16(dev, 0x43, 0x1F);
+		b43_radio_write(dev, 0x43, 0x1F);
 	} else {
-		b43_radio_write16(dev, 0x52, 0);
-		b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
-					      & 0xFFF0) | 0x0009);
+		b43_radio_write(dev, 0x52, 0);
+		b43_radio_maskset(dev, 0x43, 0xFFF0, 0x0009);
 	}
 	b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 
@@ -1511,7 +1492,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 
 	for (i = 0; i < 16; i++) {
 		radio78 = (bitrev4(i) << 1) | 0x0020;
-		b43_radio_write16(dev, 0x78, radio78);
+		b43_radio_write(dev, 0x78, radio78);
 		udelay(10);
 		for (j = 0; j < 16; j++) {
 			b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0D80);
@@ -1563,9 +1544,9 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 
 	/* Restore the registers */
 	b43_phy_write(dev, B43_PHY_PGACTL, sav.phy_pgactl);
-	b43_radio_write16(dev, 0x51, sav.radio_51);
-	b43_radio_write16(dev, 0x52, sav.radio_52);
-	b43_radio_write16(dev, 0x43, sav.radio_43);
+	b43_radio_write(dev, 0x51, sav.radio_51);
+	b43_radio_write(dev, 0x52, sav.radio_52);
+	b43_radio_write(dev, 0x43, sav.radio_43);
 	b43_phy_write(dev, B43_PHY_CCK(0x5A), sav.phy_cck_5A);
 	b43_phy_write(dev, B43_PHY_CCK(0x59), sav.phy_cck_59);
 	b43_phy_write(dev, B43_PHY_CCK(0x58), sav.phy_cck_58);
@@ -1609,10 +1590,9 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 	u16 offset, value;
 	u8 old_channel;
 
-	if (phy->analog == 1) {
-		b43_radio_write16(dev, 0x007A, b43_radio_read16(dev, 0x007A)
-				  | 0x0050);
-	}
+	if (phy->analog == 1)
+		b43_radio_set(dev, 0x007A, 0x0050);
+
 	if ((bus->boardinfo.vendor != SSB_BOARDVENDOR_BCM) &&
 	    (bus->boardinfo.type != SSB_BOARD_BU4306)) {
 		value = 0x2120;
@@ -1628,12 +1608,8 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 
 	if (phy->gmode || phy->rev >= 2) {
 		if (phy->radio_ver == 0x2050) {
-			b43_radio_write16(dev, 0x007A,
-					  b43_radio_read16(dev, 0x007A)
-					  | 0x0020);
-			b43_radio_write16(dev, 0x0051,
-					  b43_radio_read16(dev, 0x0051)
-					  | 0x0004);
+			b43_radio_set(dev, 0x007A, 0x0020);
+			b43_radio_set(dev, 0x0051, 0x0004);
 		}
 		b43_write16(dev, B43_MMIO_PHY_RADIO, 0x0000);
 
@@ -1680,22 +1656,22 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 	b43_gphy_channel_switch(dev, 7, 0);
 
 	if (phy->radio_ver != 0x2050) {
-		b43_radio_write16(dev, 0x0075, 0x0080);
-		b43_radio_write16(dev, 0x0079, 0x0081);
+		b43_radio_write(dev, 0x0075, 0x0080);
+		b43_radio_write(dev, 0x0079, 0x0081);
 	}
 
-	b43_radio_write16(dev, 0x0050, 0x0020);
-	b43_radio_write16(dev, 0x0050, 0x0023);
+	b43_radio_write(dev, 0x0050, 0x0020);
+	b43_radio_write(dev, 0x0050, 0x0023);
 
 	if (phy->radio_ver == 0x2050) {
-		b43_radio_write16(dev, 0x0050, 0x0020);
-		b43_radio_write16(dev, 0x005A, 0x0070);
+		b43_radio_write(dev, 0x0050, 0x0020);
+		b43_radio_write(dev, 0x005A, 0x0070);
 	}
 
-	b43_radio_write16(dev, 0x005B, 0x007B);
-	b43_radio_write16(dev, 0x005C, 0x00B0);
+	b43_radio_write(dev, 0x005B, 0x007B);
+	b43_radio_write(dev, 0x005C, 0x00B0);
 
-	b43_radio_write16(dev, 0x007A, b43_radio_read16(dev, 0x007A) | 0x0007);
+	b43_radio_set(dev, 0x007A, 0x0007);
 
 	b43_gphy_channel_switch(dev, old_channel, 0);
 
@@ -1706,7 +1682,7 @@ static void b43_phy_initb5(struct b43_wldev *dev)
 	b43_set_txpower_g(dev, &gphy->bbatt, &gphy->rfatt, gphy->tx_control);
 
 	if (phy->radio_ver == 0x2050)
-		b43_radio_write16(dev, 0x005D, 0x000D);
+		b43_radio_write(dev, 0x005D, 0x000D);
 
 	b43_write16(dev, 0x03E4, (b43_read16(dev, 0x03E4) & 0xFFC0) | 0x0004);
 }
@@ -1719,41 +1695,40 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 	u8 old_channel;
 
 	b43_phy_write(dev, 0x003E, 0x817A);
-	b43_radio_write16(dev, 0x007A,
-			  (b43_radio_read16(dev, 0x007A) | 0x0058));
+	b43_radio_set(dev, 0x007A, 0x0058);
 	if (phy->radio_rev == 4 || phy->radio_rev == 5) {
-		b43_radio_write16(dev, 0x51, 0x37);
-		b43_radio_write16(dev, 0x52, 0x70);
-		b43_radio_write16(dev, 0x53, 0xB3);
-		b43_radio_write16(dev, 0x54, 0x9B);
-		b43_radio_write16(dev, 0x5A, 0x88);
-		b43_radio_write16(dev, 0x5B, 0x88);
-		b43_radio_write16(dev, 0x5D, 0x88);
-		b43_radio_write16(dev, 0x5E, 0x88);
-		b43_radio_write16(dev, 0x7D, 0x88);
+		b43_radio_write(dev, 0x51, 0x37);
+		b43_radio_write(dev, 0x52, 0x70);
+		b43_radio_write(dev, 0x53, 0xB3);
+		b43_radio_write(dev, 0x54, 0x9B);
+		b43_radio_write(dev, 0x5A, 0x88);
+		b43_radio_write(dev, 0x5B, 0x88);
+		b43_radio_write(dev, 0x5D, 0x88);
+		b43_radio_write(dev, 0x5E, 0x88);
+		b43_radio_write(dev, 0x7D, 0x88);
 		b43_hf_write(dev, b43_hf_read(dev)
 			     | B43_HF_TSSIRPSMW);
 	}
 	B43_WARN_ON(phy->radio_rev == 6 || phy->radio_rev == 7);	/* We had code for these revs here... */
 	if (phy->radio_rev == 8) {
-		b43_radio_write16(dev, 0x51, 0);
-		b43_radio_write16(dev, 0x52, 0x40);
-		b43_radio_write16(dev, 0x53, 0xB7);
-		b43_radio_write16(dev, 0x54, 0x98);
-		b43_radio_write16(dev, 0x5A, 0x88);
-		b43_radio_write16(dev, 0x5B, 0x6B);
-		b43_radio_write16(dev, 0x5C, 0x0F);
+		b43_radio_write(dev, 0x51, 0);
+		b43_radio_write(dev, 0x52, 0x40);
+		b43_radio_write(dev, 0x53, 0xB7);
+		b43_radio_write(dev, 0x54, 0x98);
+		b43_radio_write(dev, 0x5A, 0x88);
+		b43_radio_write(dev, 0x5B, 0x6B);
+		b43_radio_write(dev, 0x5C, 0x0F);
 		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_ALTIQ) {
-			b43_radio_write16(dev, 0x5D, 0xFA);
-			b43_radio_write16(dev, 0x5E, 0xD8);
+			b43_radio_write(dev, 0x5D, 0xFA);
+			b43_radio_write(dev, 0x5E, 0xD8);
 		} else {
-			b43_radio_write16(dev, 0x5D, 0xF5);
-			b43_radio_write16(dev, 0x5E, 0xB8);
+			b43_radio_write(dev, 0x5D, 0xF5);
+			b43_radio_write(dev, 0x5E, 0xB8);
 		}
-		b43_radio_write16(dev, 0x0073, 0x0003);
-		b43_radio_write16(dev, 0x007D, 0x00A8);
-		b43_radio_write16(dev, 0x007C, 0x0001);
-		b43_radio_write16(dev, 0x007E, 0x0008);
+		b43_radio_write(dev, 0x0073, 0x0003);
+		b43_radio_write(dev, 0x007D, 0x00A8);
+		b43_radio_write(dev, 0x007C, 0x0001);
+		b43_radio_write(dev, 0x007E, 0x0008);
 	}
 	val = 0x1E1F;
 	for (offset = 0x0088; offset < 0x0098; offset++) {
@@ -1771,10 +1746,8 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 		val += 0x0202;
 	}
 	if (phy->type == B43_PHYTYPE_G) {
-		b43_radio_write16(dev, 0x007A,
-				  b43_radio_read16(dev, 0x007A) | 0x0020);
-		b43_radio_write16(dev, 0x0051,
-				  b43_radio_read16(dev, 0x0051) | 0x0004);
+		b43_radio_set(dev, 0x007A, 0x0020);
+		b43_radio_set(dev, 0x0051, 0x0004);
 		b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) | 0x0100);
 		b43_phy_write(dev, 0x042B, b43_phy_read(dev, 0x042B) | 0x2000);
 		b43_phy_write(dev, 0x5B, 0);
@@ -1787,22 +1760,20 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 	else
 		b43_gphy_channel_switch(dev, 13, 0);
 
-	b43_radio_write16(dev, 0x0050, 0x0020);
-	b43_radio_write16(dev, 0x0050, 0x0023);
+	b43_radio_write(dev, 0x0050, 0x0020);
+	b43_radio_write(dev, 0x0050, 0x0023);
 	udelay(40);
 	if (phy->radio_rev < 6 || phy->radio_rev == 8) {
-		b43_radio_write16(dev, 0x7C, (b43_radio_read16(dev, 0x7C)
-					      | 0x0002));
-		b43_radio_write16(dev, 0x50, 0x20);
+		b43_radio_set(dev, 0x7C, 0x0002);
+		b43_radio_write(dev, 0x50, 0x20);
 	}
 	if (phy->radio_rev <= 2) {
-		b43_radio_write16(dev, 0x7C, 0x20);
-		b43_radio_write16(dev, 0x5A, 0x70);
-		b43_radio_write16(dev, 0x5B, 0x7B);
-		b43_radio_write16(dev, 0x5C, 0xB0);
+		b43_radio_write(dev, 0x7C, 0x20);
+		b43_radio_write(dev, 0x5A, 0x70);
+		b43_radio_write(dev, 0x5B, 0x7B);
+		b43_radio_write(dev, 0x5C, 0xB0);
 	}
-	b43_radio_write16(dev, 0x007A,
-			  (b43_radio_read16(dev, 0x007A) & 0x00F8) | 0x0007);
+	b43_radio_maskset(dev, 0x007A, 0x00F8, 0x0007);
 
 	b43_gphy_channel_switch(dev, old_channel, 0);
 
@@ -1818,7 +1789,7 @@ static void b43_phy_initb6(struct b43_wldev *dev)
 					  & 0xFF80) | 0x0003);
 	}
 	if (phy->radio_rev <= 2)
-		b43_radio_write16(dev, 0x005D, 0x000D);
+		b43_radio_write(dev, 0x005D, 0x000D);
 
 	if (phy->analog == 4) {
 		b43_write16(dev, 0x3E4, 9);
@@ -1864,9 +1835,9 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 	backup_phy[14] = b43_phy_read(dev, B43_PHY_PGACTL);
 	backup_phy[15] = b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
 	backup_bband = gphy->bbatt.att;
-	backup_radio[0] = b43_radio_read16(dev, 0x52);
-	backup_radio[1] = b43_radio_read16(dev, 0x43);
-	backup_radio[2] = b43_radio_read16(dev, 0x7A);
+	backup_radio[0] = b43_radio_read(dev, 0x52);
+	backup_radio[1] = b43_radio_read(dev, 0x43);
+	backup_radio[2] = b43_radio_read(dev, 0x7A);
 
 	b43_phy_write(dev, B43_PHY_CRS0,
 		      b43_phy_read(dev, B43_PHY_CRS0) & 0x3FFF);
@@ -1920,11 +1891,10 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 		       & 0xFF9F) | 0x40);
 
 	if (phy->radio_rev == 8) {
-		b43_radio_write16(dev, 0x43, 0x000F);
+		b43_radio_write(dev, 0x43, 0x000F);
 	} else {
-		b43_radio_write16(dev, 0x52, 0);
-		b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
-					      & 0xFFF0) | 0x9);
+		b43_radio_write(dev, 0x52, 0);
+		b43_radio_maskset(dev, 0x43, 0xFFF0, 0x9);
 	}
 	b43_gphy_set_baseband_attenuation(dev, 11);
 
@@ -1956,14 +1926,13 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 				      | 0x8000);
 		}
 	}
-	b43_radio_write16(dev, 0x7A, b43_radio_read16(dev, 0x7A)
-			  & 0x00F7);
+	b43_radio_mask(dev, 0x7A, 0x00F7);
 
 	j = 0;
 	loop_i_max = (phy->radio_rev == 8) ? 15 : 9;
 	for (i = 0; i < loop_i_max; i++) {
 		for (j = 0; j < 16; j++) {
-			b43_radio_write16(dev, 0x43, i);
+			b43_radio_write(dev, 0x43, i);
 			b43_phy_write(dev, B43_PHY_RFOVERVAL,
 				      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
 				       & 0xF0FF) | (j << 8));
@@ -2021,9 +1990,9 @@ static void b43_calc_loopback_gain(struct b43_wldev *dev)
 
 	b43_gphy_set_baseband_attenuation(dev, backup_bband);
 
-	b43_radio_write16(dev, 0x52, backup_radio[0]);
-	b43_radio_write16(dev, 0x43, backup_radio[1]);
-	b43_radio_write16(dev, 0x7A, backup_radio[2]);
+	b43_radio_write(dev, 0x52, backup_radio[0]);
+	b43_radio_write(dev, 0x43, backup_radio[1]);
+	b43_radio_write(dev, 0x7A, backup_radio[2]);
 
 	b43_phy_write(dev, B43_PHY_RFOVER, backup_phy[2] | 0x0003);
 	udelay(10);
@@ -2139,9 +2108,7 @@ static void b43_phy_init_pctl(struct b43_wldev *dev)
 	b43_hardware_pctl_early_init(dev);
 	if (gphy->cur_idle_tssi == 0) {
 		if (phy->radio_ver == 0x2050 && phy->analog == 0) {
-			b43_radio_write16(dev, 0x0076,
-					  (b43_radio_read16(dev, 0x0076)
-					   & 0x00F7) | 0x0084);
+			b43_radio_maskset(dev, 0x0076, 0x00F7, 0x0084);
 		} else {
 			struct b43_rfatt rfatt;
 			struct b43_bbatt bbatt;
@@ -2174,9 +2141,7 @@ static void b43_phy_init_pctl(struct b43_wldev *dev)
 			}
 		}
 		if (phy->radio_ver == 0x2050 && phy->analog == 0) {
-			b43_radio_write16(dev, 0x0076,
-					  b43_radio_read16(dev, 0x0076)
-					  & 0xFF7B);
+			b43_radio_mask(dev, 0x0076, 0xFF7B);
 		} else {
 			b43_set_txpower_g(dev, &old_bbatt,
 					  &old_rfatt, old_tx_control);
@@ -2242,18 +2207,14 @@ static void b43_phy_initg(struct b43_wldev *dev)
 		if (gphy->initval == 0xFFFF)
 			gphy->initval = b43_radio_init2050(dev);
 		else
-			b43_radio_write16(dev, 0x0078, gphy->initval);
+			b43_radio_write(dev, 0x0078, gphy->initval);
 	}
 	b43_lo_g_init(dev);
 	if (has_tx_magnification(phy)) {
-		b43_radio_write16(dev, 0x52,
-				  (b43_radio_read16(dev, 0x52) & 0xFF00)
-				  | gphy->lo_control->tx_bias | gphy->
-				  lo_control->tx_magn);
+		b43_radio_maskset(dev, 0x52, 0xFF00, (gphy->lo_control->tx_bias
+				  | gphy->lo_control->tx_magn));
 	} else {
-		b43_radio_write16(dev, 0x52,
-				  (b43_radio_read16(dev, 0x52) & 0xFFF0)
-				  | gphy->lo_control->tx_bias);
+		b43_radio_maskset(dev, 0x52, 0xFFF0, gphy->lo_control->tx_bias);
 	}
 	if (phy->rev >= 6) {
 		b43_phy_write(dev, B43_PHY_CCK(0x36),
-- 
1.6.0.2.471.g47a76


