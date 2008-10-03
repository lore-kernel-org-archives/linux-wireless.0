Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:63136 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYJCUsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 16:48:51 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1801100wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 13:48:50 -0700 (PDT)
Subject: [PATCH 3/8] b43: remove b43_radio_{read|write}16 from lo.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 13:48:46 -0700
Message-Id: <1223066926.6512.28.camel@brick> (sfid-20081003_224858_513246_8D2259BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly by using the mask/set helpers. Some temporary variables have
also been eliminated.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/lo.c |   79 +++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 6a18a14..a6c185b 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -225,14 +225,12 @@ static void lo_measure_txctl_values(struct b43_wldev *dev)
 				radio_pctl_reg = tmp;
 		}
 	}
-	b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
-				      & 0xFFF0) | radio_pctl_reg);
+	b43_radio_maskset(dev, 0x43, 0xFFF0, radio_pctl_reg);
 	b43_gphy_set_baseband_attenuation(dev, 2);
 
 	reg = lo_txctl_register_table(dev, &mask, NULL);
 	mask = ~mask;
-	b43_radio_write16(dev, reg, b43_radio_read16(dev, reg)
-			  & mask);
+	b43_radio_mask(dev, reg, mask);
 
 	if (has_tx_magnification(phy)) {
 		int i, j;
@@ -242,14 +240,10 @@ static void lo_measure_txctl_values(struct b43_wldev *dev)
 
 		for (i = 0; i < ARRAY_SIZE(tx_magn_values); i++) {
 			tx_magn = tx_magn_values[i];
-			b43_radio_write16(dev, 0x52,
-					  (b43_radio_read16(dev, 0x52)
-					   & 0xFF0F) | tx_magn);
+			b43_radio_maskset(dev, 0x52, 0xFF0F, tx_magn);
 			for (j = 0; j < ARRAY_SIZE(tx_bias_values); j++) {
 				tx_bias = tx_bias_values[j];
-				b43_radio_write16(dev, 0x52,
-						  (b43_radio_read16(dev, 0x52)
-						   & 0xFFF0) | tx_bias);
+				b43_radio_maskset(dev, 0x52, 0xFFF0, tx_bias);
 				feedthrough =
 				    lo_measure_feedthrough(dev, 0, pga,
 							   trsw_rx);
@@ -261,16 +255,13 @@ static void lo_measure_txctl_values(struct b43_wldev *dev)
 				if (lo->tx_bias == 0)
 					break;
 			}
-			b43_radio_write16(dev, 0x52,
-					  (b43_radio_read16(dev, 0x52)
-					   & 0xFF00) | lo->tx_bias | lo->
-					  tx_magn);
+			b43_radio_maskset(dev, 0x52, 0xFF00,
+					  (lo->tx_bias | lo->tx_magn));
 		}
 	} else {
 		lo->tx_magn = 0;
 		lo->tx_bias = 0;
-		b43_radio_write16(dev, 0x52, b43_radio_read16(dev, 0x52)
-				  & 0xFFF0);	/* TX bias == 0 */
+		b43_radio_mask(dev, 0x52, 0xFFF0);	/* TX bias == 0 */
 	}
 	lo->txctl_measured_time = jiffies;
 }
@@ -301,7 +292,6 @@ static void lo_measure_gain_values(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
-	u16 tmp;
 
 	if (max_rx_gain < 0)
 		max_rx_gain = 0;
@@ -349,12 +339,10 @@ static void lo_measure_gain_values(struct b43_wldev *dev,
 		}
 	}
 
-	tmp = b43_radio_read16(dev, 0x7A);
 	if (gphy->lna_lod_gain == 0)
-		tmp &= ~0x0008;
+		b43_radio_mask(dev, 0x7A, ~0x0008);
 	else
-		tmp |= 0x0008;
-	b43_radio_write16(dev, 0x7A, tmp);
+		b43_radio_set(dev, 0x7A, 0x0008);
 }
 
 struct lo_g_saved_values {
@@ -397,7 +385,6 @@ static void lo_measure_setup(struct b43_wldev *dev,
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 	struct b43_txpower_lo_control *lo = gphy->lo_control;
-	u16 tmp;
 
 	if (b43_has_hardware_pctl(dev)) {
 		sav->phy_lo_mask = b43_phy_read(dev, B43_PHY_LO_MASK);
@@ -459,17 +446,16 @@ static void lo_measure_setup(struct b43_wldev *dev,
 	}
 	sav->reg_3F4 = b43_read16(dev, 0x3F4);
 	sav->reg_3E2 = b43_read16(dev, 0x3E2);
-	sav->radio_43 = b43_radio_read16(dev, 0x43);
-	sav->radio_7A = b43_radio_read16(dev, 0x7A);
+	sav->radio_43 = b43_radio_read(dev, 0x43);
+	sav->radio_7A = b43_radio_read(dev, 0x7A);
 	sav->phy_pgactl = b43_phy_read(dev, B43_PHY_PGACTL);
 	sav->phy_cck_2A = b43_phy_read(dev, B43_PHY_CCK(0x2A));
 	sav->phy_syncctl = b43_phy_read(dev, B43_PHY_SYNCCTL);
 	sav->phy_dacctl = b43_phy_read(dev, B43_PHY_DACCTL);
 
-	if (!has_tx_magnification(phy)) {
-		sav->radio_52 = b43_radio_read16(dev, 0x52);
-		sav->radio_52 &= 0x00F0;
-	}
+	if (!has_tx_magnification(phy))
+		sav->radio_52 = b43_radio_read(dev, 0x52) & 0x00F0;
+
 	if (phy->type == B43_PHYTYPE_B) {
 		sav->phy_cck_30 = b43_phy_read(dev, B43_PHY_CCK(0x30));
 		sav->phy_cck_06 = b43_phy_read(dev, B43_PHY_CCK(0x06));
@@ -482,14 +468,13 @@ static void lo_measure_setup(struct b43_wldev *dev,
 	b43_write16(dev, 0x3F4, b43_read16(dev, 0x3F4)
 		    & 0xF000);
 
-	tmp =
-	    (phy->type == B43_PHYTYPE_G) ? B43_PHY_LO_MASK : B43_PHY_CCK(0x2E);
-	b43_phy_write(dev, tmp, 0x007F);
+	if (phy->type == B43_PHYTYPE_G)
+		b43_phy_write(dev, B43_PHY_LO_MASK, 0x007F);
+	else
+		b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x007F);
 
-	tmp = sav->phy_syncctl;
-	b43_phy_write(dev, B43_PHY_SYNCCTL, tmp & 0xFF7F);
-	tmp = sav->radio_7A;
-	b43_radio_write16(dev, 0x007A, tmp & 0xFFF0);
+	b43_phy_write(dev, B43_PHY_SYNCCTL, sav->phy_syncctl & 0xFF7F);
+	b43_radio_write(dev, 0x007A, sav->radio_7A & 0xFFF0);
 
 	b43_phy_write(dev, B43_PHY_CCK(0x2A), 0x8A3);
 	if (phy->type == B43_PHYTYPE_G ||
@@ -501,7 +486,7 @@ static void lo_measure_setup(struct b43_wldev *dev,
 	if (phy->rev >= 2)
 		b43_dummy_transmission(dev);
 	b43_gphy_channel_switch(dev, 6, 0);
-	b43_radio_read16(dev, 0x51);	/* dummy read */
+	b43_radio_read(dev, 0x51);	/* dummy read */
 	if (phy->type == B43_PHYTYPE_G)
 		b43_phy_write(dev, B43_PHY_CCK(0x2F), 0);
 
@@ -554,13 +539,10 @@ static void lo_measure_restore(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_PHY_CCK(0x2A), sav->phy_cck_2A);
 	b43_phy_write(dev, B43_PHY_SYNCCTL, sav->phy_syncctl);
 	b43_phy_write(dev, B43_PHY_DACCTL, sav->phy_dacctl);
-	b43_radio_write16(dev, 0x43, sav->radio_43);
-	b43_radio_write16(dev, 0x7A, sav->radio_7A);
-	if (!has_tx_magnification(phy)) {
-		tmp = sav->radio_52;
-		b43_radio_write16(dev, 0x52, (b43_radio_read16(dev, 0x52)
-					      & 0xFF0F) | tmp);
-	}
+	b43_radio_write(dev, 0x43, sav->radio_43);
+	b43_radio_write(dev, 0x7A, sav->radio_7A);
+	if (!has_tx_magnification(phy))
+		b43_radio_maskset(dev, 0x52, 0xFF0F, sav->radio_52);
 	b43_write16(dev, 0x3E2, sav->reg_3E2);
 	if (phy->type == B43_PHYTYPE_B &&
 	    phy->radio_ver == 0x2050 && phy->radio_rev <= 5) {
@@ -778,12 +760,11 @@ struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
 
 	txctl_reg = lo_txctl_register_table(dev, &txctl_value, &pad_mix_gain);
 
-	b43_radio_write16(dev, 0x43,
-			  (b43_radio_read16(dev, 0x43) & 0xFFF0)
-			  | rfatt->att);
-	b43_radio_write16(dev, txctl_reg,
-			  (b43_radio_read16(dev, txctl_reg) & ~txctl_value)
-			  | (rfatt->with_padmix) ? txctl_value : 0);
+	b43_radio_maskset(dev, 0x43, 0xFFF0, rfatt->att);
+	if (rfatt->with_padmix)
+		b43_radio_maskset(dev, txctl_reg, ~txctl_value, txctl_value);
+	else
+		b43_radio_maskset(dev, txctl_reg, ~txctl_value, 0);
 
 	max_rx_gain = rfatt->att * 2;
 	max_rx_gain += bbatt->att / 2;
-- 
1.6.0.2.471.g47a76


