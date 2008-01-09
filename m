Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57354 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYAIRqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 12:46:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix PHY register routing
Date: Wed, 9 Jan 2008 18:39:09 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801091839.10076.mb@bu3sch.de> (sfid-20080109_174658_392886_AE109213)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the PHY routing bit handling.
This is needed for N-PHY.
No functional change to A-PHY and G-PHY code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25.


Index: wireless-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.c	2008-01-09 17:51:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/phy.c	2008-01-09 18:30:13.000000000 +0100
@@ -271,21 +271,36 @@ void b43_raw_phy_unlock(struct b43_wldev
  */
 static inline u16 adjust_phyreg_for_phytype(struct b43_phy *phy,
 					    u16 offset, struct b43_wldev *dev)
 {
 	if (phy->type == B43_PHYTYPE_A) {
 		/* OFDM registers are base-registers for the A-PHY. */
-		offset &= ~B43_PHYROUTE_OFDM_GPHY;
+		if ((offset & B43_PHYROUTE) == B43_PHYROUTE_OFDM_GPHY) {
+			offset &= ~B43_PHYROUTE;
+			offset |= B43_PHYROUTE_BASE;
+		}
 	}
-	if (offset & B43_PHYROUTE_EXT_GPHY) {
+
+#if B43_DEBUG
+	if ((offset & B43_PHYROUTE) == B43_PHYROUTE_EXT_GPHY) {
 		/* Ext-G registers are only available on G-PHYs */
 		if (phy->type != B43_PHYTYPE_G) {
-			b43dbg(dev->wl, "EXT-G PHY access at "
-			       "0x%04X on %u type PHY\n", offset, phy->type);
+			b43err(dev->wl, "Invalid EXT-G PHY access at "
+			       "0x%04X on PHY type %u\n", offset, phy->type);
+			dump_stack();
+		}
+	}
+	if ((offset & B43_PHYROUTE) == B43_PHYROUTE_N_BMODE) {
+		/* N-BMODE registers are only available on N-PHYs */
+		if (phy->type != B43_PHYTYPE_N) {
+			b43err(dev->wl, "Invalid N-BMODE PHY access at "
+			       "0x%04X on PHY type %u\n", offset, phy->type);
+			dump_stack();
 		}
 	}
+#endif /* B43_DEBUG */
 
 	return offset;
 }
 
 u16 b43_phy_read(struct b43_wldev * dev, u16 offset)
 {
@@ -299,13 +314,12 @@ u16 b43_phy_read(struct b43_wldev * dev,
 void b43_phy_write(struct b43_wldev *dev, u16 offset, u16 val)
 {
 	struct b43_phy *phy = &dev->phy;
 
 	offset = adjust_phyreg_for_phytype(phy, offset, dev);
 	b43_write16(dev, B43_MMIO_PHY_CONTROL, offset);
-	mmiowb();
 	b43_write16(dev, B43_MMIO_PHY_DATA, val);
 }
 
 /* Adjust the transmission power output (G-PHY) */
 void b43_set_txpower_g(struct b43_wldev *dev,
 		       const struct b43_bbatt *bbatt,
@@ -1270,20 +1284,20 @@ static void b43_calc_loopback_gain(struc
 	backup_phy[2] = b43_phy_read(dev, B43_PHY_RFOVER);
 	backup_phy[3] = b43_phy_read(dev, B43_PHY_RFOVERVAL);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 		backup_phy[4] = b43_phy_read(dev, B43_PHY_ANALOGOVER);
 		backup_phy[5] = b43_phy_read(dev, B43_PHY_ANALOGOVERVAL);
 	}
-	backup_phy[6] = b43_phy_read(dev, B43_PHY_BASE(0x5A));
-	backup_phy[7] = b43_phy_read(dev, B43_PHY_BASE(0x59));
-	backup_phy[8] = b43_phy_read(dev, B43_PHY_BASE(0x58));
-	backup_phy[9] = b43_phy_read(dev, B43_PHY_BASE(0x0A));
-	backup_phy[10] = b43_phy_read(dev, B43_PHY_BASE(0x03));
+	backup_phy[6] = b43_phy_read(dev, B43_PHY_CCK(0x5A));
+	backup_phy[7] = b43_phy_read(dev, B43_PHY_CCK(0x59));
+	backup_phy[8] = b43_phy_read(dev, B43_PHY_CCK(0x58));
+	backup_phy[9] = b43_phy_read(dev, B43_PHY_CCK(0x0A));
+	backup_phy[10] = b43_phy_read(dev, B43_PHY_CCK(0x03));
 	backup_phy[11] = b43_phy_read(dev, B43_PHY_LO_MASK);
 	backup_phy[12] = b43_phy_read(dev, B43_PHY_LO_CTL);
-	backup_phy[13] = b43_phy_read(dev, B43_PHY_BASE(0x2B));
+	backup_phy[13] = b43_phy_read(dev, B43_PHY_CCK(0x2B));
 	backup_phy[14] = b43_phy_read(dev, B43_PHY_PGACTL);
 	backup_phy[15] = b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
 	backup_bband = phy->bbatt.att;
 	backup_radio[0] = b43_radio_read16(dev, 0x52);
 	backup_radio[1] = b43_radio_read16(dev, 0x43);
 	backup_radio[2] = b43_radio_read16(dev, 0x7A);
@@ -1319,27 +1333,27 @@ static void b43_calc_loopback_gain(struc
 	b43_phy_write(dev, B43_PHY_RFOVER,
 		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0030);
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      (b43_phy_read(dev, B43_PHY_RFOVERVAL)
 		       & 0xFFCF) | 0x10);
 
-	b43_phy_write(dev, B43_PHY_BASE(0x5A), 0x0780);
-	b43_phy_write(dev, B43_PHY_BASE(0x59), 0xC810);
-	b43_phy_write(dev, B43_PHY_BASE(0x58), 0x000D);
+	b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0780);
+	b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
+	b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 
-	b43_phy_write(dev, B43_PHY_BASE(0x0A),
-		      b43_phy_read(dev, B43_PHY_BASE(0x0A)) | 0x2000);
+	b43_phy_write(dev, B43_PHY_CCK(0x0A),
+		      b43_phy_read(dev, B43_PHY_CCK(0x0A)) | 0x2000);
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 		b43_phy_write(dev, B43_PHY_ANALOGOVER,
 			      b43_phy_read(dev, B43_PHY_ANALOGOVER) | 0x0004);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
 			      b43_phy_read(dev,
 					   B43_PHY_ANALOGOVERVAL) & 0xFFFB);
 	}
-	b43_phy_write(dev, B43_PHY_BASE(0x03),
-		      (b43_phy_read(dev, B43_PHY_BASE(0x03))
+	b43_phy_write(dev, B43_PHY_CCK(0x03),
+		      (b43_phy_read(dev, B43_PHY_CCK(0x03))
 		       & 0xFF9F) | 0x40);
 
 	if (phy->radio_rev == 8) {
 		b43_radio_write16(dev, 0x43, 0x000F);
 	} else {
 		b43_radio_write16(dev, 0x52, 0);
@@ -1351,17 +1365,17 @@ static void b43_calc_loopback_gain(struc
 	if (phy->rev >= 3)
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0xC020);
 	else
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8020);
 	b43_phy_write(dev, B43_PHY_LO_CTL, 0);
 
-	b43_phy_write(dev, B43_PHY_BASE(0x2B),
-		      (b43_phy_read(dev, B43_PHY_BASE(0x2B))
+	b43_phy_write(dev, B43_PHY_CCK(0x2B),
+		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
 		       & 0xFFC0) | 0x01);
-	b43_phy_write(dev, B43_PHY_BASE(0x2B),
-		      (b43_phy_read(dev, B43_PHY_BASE(0x2B))
+	b43_phy_write(dev, B43_PHY_CCK(0x2B),
+		      (b43_phy_read(dev, B43_PHY_CCK(0x2B))
 		       & 0xC0FF) | 0x800);
 
 	b43_phy_write(dev, B43_PHY_RFOVER,
 		      b43_phy_read(dev, B43_PHY_RFOVER) | 0x0100);
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xCFFF);
@@ -1426,20 +1440,20 @@ static void b43_calc_loopback_gain(struc
       exit_loop2:
 
 	if (phy->rev != 1) {	/* Not in specs, but needed to prevent PPC machine check */
 		b43_phy_write(dev, B43_PHY_ANALOGOVER, backup_phy[4]);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL, backup_phy[5]);
 	}
-	b43_phy_write(dev, B43_PHY_BASE(0x5A), backup_phy[6]);
-	b43_phy_write(dev, B43_PHY_BASE(0x59), backup_phy[7]);
-	b43_phy_write(dev, B43_PHY_BASE(0x58), backup_phy[8]);
-	b43_phy_write(dev, B43_PHY_BASE(0x0A), backup_phy[9]);
-	b43_phy_write(dev, B43_PHY_BASE(0x03), backup_phy[10]);
+	b43_phy_write(dev, B43_PHY_CCK(0x5A), backup_phy[6]);
+	b43_phy_write(dev, B43_PHY_CCK(0x59), backup_phy[7]);
+	b43_phy_write(dev, B43_PHY_CCK(0x58), backup_phy[8]);
+	b43_phy_write(dev, B43_PHY_CCK(0x0A), backup_phy[9]);
+	b43_phy_write(dev, B43_PHY_CCK(0x03), backup_phy[10]);
 	b43_phy_write(dev, B43_PHY_LO_MASK, backup_phy[11]);
 	b43_phy_write(dev, B43_PHY_LO_CTL, backup_phy[12]);
-	b43_phy_write(dev, B43_PHY_BASE(0x2B), backup_phy[13]);
+	b43_phy_write(dev, B43_PHY_CCK(0x2B), backup_phy[13]);
 	b43_phy_write(dev, B43_PHY_PGACTL, backup_phy[14]);
 
 	b43_phy_set_baseband_attenuation(dev, backup_bband);
 
 	b43_radio_write16(dev, 0x52, backup_radio[0]);
 	b43_radio_write16(dev, 0x43, backup_radio[1]);
@@ -1525,25 +1539,25 @@ static void b43_phy_initg(struct b43_wld
 		} else {
 			b43_radio_write16(dev, 0x52,
 					  (b43_radio_read16(dev, 0x52) & 0xFFF0)
 					  | phy->lo_control->tx_bias);
 		}
 		if (phy->rev >= 6) {
-			b43_phy_write(dev, B43_PHY_BASE(0x36),
-				      (b43_phy_read(dev, B43_PHY_BASE(0x36))
+			b43_phy_write(dev, B43_PHY_CCK(0x36),
+				      (b43_phy_read(dev, B43_PHY_CCK(0x36))
 				       & 0x0FFF) | (phy->lo_control->
 						    tx_bias << 12));
 		}
 		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
-			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x8075);
+			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8075);
 		else
-			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x807F);
+			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x807F);
 		if (phy->rev < 2)
-			b43_phy_write(dev, B43_PHY_BASE(0x2F), 0x101);
+			b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x101);
 		else
-			b43_phy_write(dev, B43_PHY_BASE(0x2F), 0x202);
+			b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x202);
 	}
 	if (phy->gmode || phy->rev >= 2) {
 		b43_lo_g_adjust(dev);
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
 	}
 
@@ -2165,15 +2179,18 @@ void b43_radio_unlock(struct b43_wldev *
 }
 
 u16 b43_radio_read16(struct b43_wldev *dev, u16 offset)
 {
 	struct b43_phy *phy = &dev->phy;
 
+	/* Offset 1 is a 32-bit register. */
+	B43_WARN_ON(offset == 1);
+
 	switch (phy->type) {
 	case B43_PHYTYPE_A:
-		offset |= 0x0040;
+		offset |= 0x40;
 		break;
 	case B43_PHYTYPE_B:
 		if (phy->radio_ver == 0x2053) {
 			if (offset < 0x70)
 				offset += 0x80;
 			else if (offset < 0x80)
@@ -2183,22 +2200,32 @@ u16 b43_radio_read16(struct b43_wldev *d
 		} else
 			B43_WARN_ON(1);
 		break;
 	case B43_PHYTYPE_G:
 		offset |= 0x80;
 		break;
+	case B43_PHYTYPE_N:
+		offset |= 0x100;
+		break;
+	case B43_PHYTYPE_LP:
+		/* No adjustment required. */
+		break;
+	default:
+		B43_WARN_ON(1);
 	}
 
 	b43_write16(dev, B43_MMIO_RADIO_CONTROL, offset);
 	return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
 }
 
 void b43_radio_write16(struct b43_wldev *dev, u16 offset, u16 val)
 {
+	/* Offset 1 is a 32-bit register. */
+	B43_WARN_ON(offset == 1);
+
 	b43_write16(dev, B43_MMIO_RADIO_CONTROL, offset);
-	mmiowb();
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, val);
 }
 
 static void b43_set_all_gains(struct b43_wldev *dev,
 			      s16 first, s16 second, s16 third)
 {
@@ -3477,16 +3504,16 @@ struct init2050_saved_values {
 	/* Radio registers */
 	u16 radio_43;
 	u16 radio_51;
 	u16 radio_52;
 	/* PHY registers */
 	u16 phy_pgactl;
-	u16 phy_base_5A;
-	u16 phy_base_59;
-	u16 phy_base_58;
-	u16 phy_base_30;
+	u16 phy_cck_5A;
+	u16 phy_cck_59;
+	u16 phy_cck_58;
+	u16 phy_cck_30;
 	u16 phy_rfover;
 	u16 phy_rfoverval;
 	u16 phy_analogover;
 	u16 phy_analogoverval;
 	u16 phy_crs0;
 	u16 phy_classctl;
@@ -3508,21 +3535,21 @@ u16 b43_radio_init2050(struct b43_wldev 
 	memset(&sav, 0, sizeof(sav));	/* get rid of "may be used uninitialized..." */
 
 	sav.radio_43 = b43_radio_read16(dev, 0x43);
 	sav.radio_51 = b43_radio_read16(dev, 0x51);
 	sav.radio_52 = b43_radio_read16(dev, 0x52);
 	sav.phy_pgactl = b43_phy_read(dev, B43_PHY_PGACTL);
-	sav.phy_base_5A = b43_phy_read(dev, B43_PHY_BASE(0x5A));
-	sav.phy_base_59 = b43_phy_read(dev, B43_PHY_BASE(0x59));
-	sav.phy_base_58 = b43_phy_read(dev, B43_PHY_BASE(0x58));
+	sav.phy_cck_5A = b43_phy_read(dev, B43_PHY_CCK(0x5A));
+	sav.phy_cck_59 = b43_phy_read(dev, B43_PHY_CCK(0x59));
+	sav.phy_cck_58 = b43_phy_read(dev, B43_PHY_CCK(0x58));
 
 	if (phy->type == B43_PHYTYPE_B) {
-		sav.phy_base_30 = b43_phy_read(dev, B43_PHY_BASE(0x30));
+		sav.phy_cck_30 = b43_phy_read(dev, B43_PHY_CCK(0x30));
 		sav.reg_3EC = b43_read16(dev, 0x3EC);
 
-		b43_phy_write(dev, B43_PHY_BASE(0x30), 0xFF);
+		b43_phy_write(dev, B43_PHY_CCK(0x30), 0xFF);
 		b43_write16(dev, 0x3EC, 0x3F3F);
 	} else if (phy->gmode || phy->rev >= 2) {
 		sav.phy_rfover = b43_phy_read(dev, B43_PHY_RFOVER);
 		sav.phy_rfoverval = b43_phy_read(dev, B43_PHY_RFOVERVAL);
 		sav.phy_analogover = b43_phy_read(dev, B43_PHY_ANALOGOVER);
 		sav.phy_analogoverval =
@@ -3567,14 +3594,14 @@ u16 b43_radio_init2050(struct b43_wldev 
 	sav.reg_3F4 = b43_read16(dev, 0x3F4);
 
 	if (phy->analog == 0) {
 		b43_write16(dev, 0x03E6, 0x0122);
 	} else {
 		if (phy->analog >= 2) {
-			b43_phy_write(dev, B43_PHY_BASE(0x03),
-				      (b43_phy_read(dev, B43_PHY_BASE(0x03))
+			b43_phy_write(dev, B43_PHY_CCK(0x03),
+				      (b43_phy_read(dev, B43_PHY_CCK(0x03))
 				       & 0xFFBF) | 0x40);
 		}
 		b43_write16(dev, B43_MMIO_CHANNEL_EXT,
 			    (b43_read16(dev, B43_MMIO_CHANNEL_EXT) | 0x2000));
 	}
 
@@ -3585,13 +3612,13 @@ u16 b43_radio_init2050(struct b43_wldev 
 	if (phy->gmode || phy->rev >= 2) {
 		b43_phy_write(dev, B43_PHY_RFOVERVAL,
 			      radio2050_rfover_val(dev, B43_PHY_RFOVERVAL,
 						   LPD(0, 1, 1)));
 	}
 	b43_phy_write(dev, B43_PHY_PGACTL, 0xBFAF);
-	b43_phy_write(dev, B43_PHY_BASE(0x2B), 0x1403);
+	b43_phy_write(dev, B43_PHY_CCK(0x2B), 0x1403);
 	if (phy->gmode || phy->rev >= 2) {
 		b43_phy_write(dev, B43_PHY_RFOVERVAL,
 			      radio2050_rfover_val(dev, B43_PHY_RFOVERVAL,
 						   LPD(0, 0, 1)));
 	}
 	b43_phy_write(dev, B43_PHY_PGACTL, 0xBFA0);
@@ -3601,18 +3628,18 @@ u16 b43_radio_init2050(struct b43_wldev 
 		b43_radio_write16(dev, 0x43, 0x1F);
 	} else {
 		b43_radio_write16(dev, 0x52, 0);
 		b43_radio_write16(dev, 0x43, (b43_radio_read16(dev, 0x43)
 					      & 0xFFF0) | 0x0009);
 	}
-	b43_phy_write(dev, B43_PHY_BASE(0x58), 0);
+	b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 
 	for (i = 0; i < 16; i++) {
-		b43_phy_write(dev, B43_PHY_BASE(0x5A), 0x0480);
-		b43_phy_write(dev, B43_PHY_BASE(0x59), 0xC810);
-		b43_phy_write(dev, B43_PHY_BASE(0x58), 0x000D);
+		b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0480);
+		b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
+		b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 		if (phy->gmode || phy->rev >= 2) {
 			b43_phy_write(dev, B43_PHY_RFOVERVAL,
 				      radio2050_rfover_val(dev,
 							   B43_PHY_RFOVERVAL,
 							   LPD(1, 0, 1)));
 		}
@@ -3632,35 +3659,35 @@ u16 b43_radio_init2050(struct b43_wldev 
 							   B43_PHY_RFOVERVAL,
 							   LPD(1, 0, 0)));
 		}
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xFFF0);
 		udelay(20);
 		tmp1 += b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
-		b43_phy_write(dev, B43_PHY_BASE(0x58), 0);
+		b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 		if (phy->gmode || phy->rev >= 2) {
 			b43_phy_write(dev, B43_PHY_RFOVERVAL,
 				      radio2050_rfover_val(dev,
 							   B43_PHY_RFOVERVAL,
 							   LPD(1, 0, 1)));
 		}
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xAFB0);
 	}
 	udelay(10);
 
-	b43_phy_write(dev, B43_PHY_BASE(0x58), 0);
+	b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 	tmp1++;
 	tmp1 >>= 9;
 
 	for (i = 0; i < 16; i++) {
 		radio78 = ((flip_4bit(i) << 1) | 0x20);
 		b43_radio_write16(dev, 0x78, radio78);
 		udelay(10);
 		for (j = 0; j < 16; j++) {
-			b43_phy_write(dev, B43_PHY_BASE(0x5A), 0x0D80);
-			b43_phy_write(dev, B43_PHY_BASE(0x59), 0xC810);
-			b43_phy_write(dev, B43_PHY_BASE(0x58), 0x000D);
+			b43_phy_write(dev, B43_PHY_CCK(0x5A), 0x0D80);
+			b43_phy_write(dev, B43_PHY_CCK(0x59), 0xC810);
+			b43_phy_write(dev, B43_PHY_CCK(0x58), 0x000D);
 			if (phy->gmode || phy->rev >= 2) {
 				b43_phy_write(dev, B43_PHY_RFOVERVAL,
 					      radio2050_rfover_val(dev,
 								   B43_PHY_RFOVERVAL,
 								   LPD(1, 0,
 								       1)));
@@ -3683,13 +3710,13 @@ u16 b43_radio_init2050(struct b43_wldev 
 								   LPD(1, 0,
 								       0)));
 			}
 			b43_phy_write(dev, B43_PHY_PGACTL, 0xFFF0);
 			udelay(10);
 			tmp2 += b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
-			b43_phy_write(dev, B43_PHY_BASE(0x58), 0);
+			b43_phy_write(dev, B43_PHY_CCK(0x58), 0);
 			if (phy->gmode || phy->rev >= 2) {
 				b43_phy_write(dev, B43_PHY_RFOVERVAL,
 					      radio2050_rfover_val(dev,
 								   B43_PHY_RFOVERVAL,
 								   LPD(1, 0,
 								       1)));
@@ -3704,22 +3731,22 @@ u16 b43_radio_init2050(struct b43_wldev 
 
 	/* Restore the registers */
 	b43_phy_write(dev, B43_PHY_PGACTL, sav.phy_pgactl);
 	b43_radio_write16(dev, 0x51, sav.radio_51);
 	b43_radio_write16(dev, 0x52, sav.radio_52);
 	b43_radio_write16(dev, 0x43, sav.radio_43);
-	b43_phy_write(dev, B43_PHY_BASE(0x5A), sav.phy_base_5A);
-	b43_phy_write(dev, B43_PHY_BASE(0x59), sav.phy_base_59);
-	b43_phy_write(dev, B43_PHY_BASE(0x58), sav.phy_base_58);
+	b43_phy_write(dev, B43_PHY_CCK(0x5A), sav.phy_cck_5A);
+	b43_phy_write(dev, B43_PHY_CCK(0x59), sav.phy_cck_59);
+	b43_phy_write(dev, B43_PHY_CCK(0x58), sav.phy_cck_58);
 	b43_write16(dev, 0x3E6, sav.reg_3E6);
 	if (phy->analog != 0)
 		b43_write16(dev, 0x3F4, sav.reg_3F4);
 	b43_phy_write(dev, B43_PHY_SYNCCTL, sav.phy_syncctl);
 	b43_synth_pu_workaround(dev, phy->channel);
 	if (phy->type == B43_PHYTYPE_B) {
-		b43_phy_write(dev, B43_PHY_BASE(0x30), sav.phy_base_30);
+		b43_phy_write(dev, B43_PHY_CCK(0x30), sav.phy_cck_30);
 		b43_write16(dev, 0x3EC, sav.reg_3EC);
 	} else if (phy->gmode) {
 		b43_write16(dev, B43_MMIO_PHY_RADIO,
 			    b43_read16(dev, B43_MMIO_PHY_RADIO)
 			    & 0x7FFF);
 		b43_phy_write(dev, B43_PHY_RFOVER, sav.phy_rfover);
Index: wireless-2.6/drivers/net/wireless/b43/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.h	2008-01-09 17:51:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/phy.h	2008-01-09 17:59:17.000000000 +0100
@@ -6,23 +6,27 @@
 struct b43_wldev;
 struct b43_phy;
 
 /*** PHY Registers ***/
 
 /* Routing */
-#define B43_PHYROUTE_OFDM_GPHY		0x0400 /* OFDM register routing for G-PHYs */
-#define B43_PHYROUTE_EXT_GPHY		0x0800 /* Extended G-PHY registers */
-#define B43_PHYROUTE_N_BMODE		0x3000 /* N-PHY BMODE registers */
+#define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
+#define  B43_PHYROUTE_BASE		0x0000 /* Base registers */
+#define  B43_PHYROUTE_OFDM_GPHY		0x0400 /* OFDM register routing for G-PHYs */
+#define  B43_PHYROUTE_EXT_GPHY		0x0800 /* Extended G-PHY registers */
+#define  B43_PHYROUTE_N_BMODE		0x0C00 /* N-PHY BMODE registers */
 
-/* Base registers. */
-#define B43_PHY_BASE(reg)		(reg)
+/* CCK (B-PHY) registers. */
+#define B43_PHY_CCK(reg)		((reg) | B43_PHYROUTE_BASE)
 /* N-PHY registers. */
-#define B43_PHY_N(reg)			(reg)
-/* OFDM (A) registers of a G-PHY */
+#define B43_PHY_N(reg)			((reg) | B43_PHYROUTE_BASE)
+/* N-PHY BMODE registers. */
+#define B43_PHY_N_BMODE(reg)		((reg) | B43_PHYROUTE_N_BMODE)
+/* OFDM (A-PHY) registers. */
 #define B43_PHY_OFDM(reg)		((reg) | B43_PHYROUTE_OFDM_GPHY)
-/* Extended G-PHY registers */
+/* Extended G-PHY registers. */
 #define B43_PHY_EXTG(reg)		((reg) | B43_PHYROUTE_EXT_GPHY)
 
 /* OFDM (A) PHY Registers */
 #define B43_PHY_VERSION_OFDM		B43_PHY_OFDM(0x00)	/* Versioning register for A-PHY */
 #define B43_PHY_BBANDCFG		B43_PHY_OFDM(0x01)	/* Baseband config */
 #define  B43_PHY_BBANDCFG_RXANT		0x180	/* RX Antenna selection */
@@ -76,26 +80,26 @@ struct b43_phy;
 #define B43_PHY_CRSTHRES2		B43_PHY_OFDM(0xC1)	/* CRS Threshold 2 (phy.rev >= 2 only) */
 #define B43_PHY_TSSIP_LTBASE		B43_PHY_OFDM(0x380)	/* TSSI power lookup table base */
 #define B43_PHY_DC_LTBASE		B43_PHY_OFDM(0x3A0)	/* DC lookup table base */
 #define B43_PHY_GAIN_LTBASE		B43_PHY_OFDM(0x3C0)	/* Gain lookup table base */
 
 /* CCK (B) PHY Registers */
-#define B43_PHY_VERSION_CCK		B43_PHY_BASE(0x00)	/* Versioning register for B-PHY */
-#define B43_PHY_CCKBBANDCFG		B43_PHY_BASE(0x01)	/* Contains antenna 0/1 control bit */
-#define B43_PHY_PGACTL			B43_PHY_BASE(0x15)	/* PGA control */
+#define B43_PHY_VERSION_CCK		B43_PHY_CCK(0x00)	/* Versioning register for B-PHY */
+#define B43_PHY_CCKBBANDCFG		B43_PHY_CCK(0x01)	/* Contains antenna 0/1 control bit */
+#define B43_PHY_PGACTL			B43_PHY_CCK(0x15)	/* PGA control */
 #define  B43_PHY_PGACTL_LPF		0x1000	/* Low pass filter (?) */
 #define  B43_PHY_PGACTL_LOWBANDW	0x0040	/* Low bandwidth flag */
 #define  B43_PHY_PGACTL_UNKNOWN		0xEFA0
-#define B43_PHY_FBCTL1			B43_PHY_BASE(0x18)	/* Frequency bandwidth control 1 */
-#define B43_PHY_ITSSI			B43_PHY_BASE(0x29)	/* Idle TSSI */
-#define B43_PHY_LO_LEAKAGE		B43_PHY_BASE(0x2D)	/* Measured LO leakage */
-#define B43_PHY_ENERGY			B43_PHY_BASE(0x33)	/* Energy */
-#define B43_PHY_SYNCCTL			B43_PHY_BASE(0x35)
-#define B43_PHY_FBCTL2			B43_PHY_BASE(0x38)	/* Frequency bandwidth control 2 */
-#define B43_PHY_DACCTL			B43_PHY_BASE(0x60)	/* DAC control */
-#define B43_PHY_RCCALOVER		B43_PHY_BASE(0x78)	/* RC calibration override */
+#define B43_PHY_FBCTL1			B43_PHY_CCK(0x18)	/* Frequency bandwidth control 1 */
+#define B43_PHY_ITSSI			B43_PHY_CCK(0x29)	/* Idle TSSI */
+#define B43_PHY_LO_LEAKAGE		B43_PHY_CCK(0x2D)	/* Measured LO leakage */
+#define B43_PHY_ENERGY			B43_PHY_CCK(0x33)	/* Energy */
+#define B43_PHY_SYNCCTL			B43_PHY_CCK(0x35)
+#define B43_PHY_FBCTL2			B43_PHY_CCK(0x38)	/* Frequency bandwidth control 2 */
+#define B43_PHY_DACCTL			B43_PHY_CCK(0x60)	/* DAC control */
+#define B43_PHY_RCCALOVER		B43_PHY_CCK(0x78)	/* RC calibration override */
 
 /* Extended G-PHY Registers */
 #define B43_PHY_CLASSCTL		B43_PHY_EXTG(0x02)	/* Classify control */
 #define B43_PHY_GTABCTL			B43_PHY_EXTG(0x03)	/* G-PHY table control (see below) */
 #define  B43_PHY_GTABOFF		0x03FF	/* G-PHY table offset (see below) */
 #define  B43_PHY_GTABNR			0xFC00	/* G-PHY table number (see below) */
Index: wireless-2.6/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/lo.c	2007-12-28 23:36:04.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/lo.c	2008-01-09 18:03:14.000000000 +0100
@@ -552,26 +552,26 @@ struct lo_g_saved_values {
 
 	/* PHY registers */
 	u16 phy_lo_mask;
 	u16 phy_extg_01;
 	u16 phy_dacctl_hwpctl;
 	u16 phy_dacctl;
-	u16 phy_base_14;
+	u16 phy_cck_14;
 	u16 phy_hpwr_tssictl;
 	u16 phy_analogover;
 	u16 phy_analogoverval;
 	u16 phy_rfover;
 	u16 phy_rfoverval;
 	u16 phy_classctl;
-	u16 phy_base_3E;
+	u16 phy_cck_3E;
 	u16 phy_crs0;
 	u16 phy_pgactl;
-	u16 phy_base_2A;
+	u16 phy_cck_2A;
 	u16 phy_syncctl;
-	u16 phy_base_30;
-	u16 phy_base_06;
+	u16 phy_cck_30;
+	u16 phy_cck_06;
 
 	/* Radio registers */
 	u16 radio_43;
 	u16 radio_7A;
 	u16 radio_52;
 };
@@ -585,43 +585,43 @@ static void lo_measure_setup(struct b43_
 	u16 tmp;
 
 	if (b43_has_hardware_pctl(phy)) {
 		sav->phy_lo_mask = b43_phy_read(dev, B43_PHY_LO_MASK);
 		sav->phy_extg_01 = b43_phy_read(dev, B43_PHY_EXTG(0x01));
 		sav->phy_dacctl_hwpctl = b43_phy_read(dev, B43_PHY_DACCTL);
-		sav->phy_base_14 = b43_phy_read(dev, B43_PHY_BASE(0x14));
+		sav->phy_cck_14 = b43_phy_read(dev, B43_PHY_CCK(0x14));
 		sav->phy_hpwr_tssictl = b43_phy_read(dev, B43_PHY_HPWR_TSSICTL);
 
 		b43_phy_write(dev, B43_PHY_HPWR_TSSICTL,
 			      b43_phy_read(dev, B43_PHY_HPWR_TSSICTL)
 			      | 0x100);
 		b43_phy_write(dev, B43_PHY_EXTG(0x01),
 			      b43_phy_read(dev, B43_PHY_EXTG(0x01))
 			      | 0x40);
 		b43_phy_write(dev, B43_PHY_DACCTL,
 			      b43_phy_read(dev, B43_PHY_DACCTL)
 			      | 0x40);
-		b43_phy_write(dev, B43_PHY_BASE(0x14),
-			      b43_phy_read(dev, B43_PHY_BASE(0x14))
+		b43_phy_write(dev, B43_PHY_CCK(0x14),
+			      b43_phy_read(dev, B43_PHY_CCK(0x14))
 			      | 0x200);
 	}
 	if (phy->type == B43_PHYTYPE_B &&
 	    phy->radio_ver == 0x2050 && phy->radio_rev < 6) {
-		b43_phy_write(dev, B43_PHY_BASE(0x16), 0x410);
-		b43_phy_write(dev, B43_PHY_BASE(0x17), 0x820);
+		b43_phy_write(dev, B43_PHY_CCK(0x16), 0x410);
+		b43_phy_write(dev, B43_PHY_CCK(0x17), 0x820);
 	}
 	if (!lo->rebuild && b43_has_hardware_pctl(phy))
 		lo_read_power_vector(dev);
 	if (phy->rev >= 2) {
 		sav->phy_analogover = b43_phy_read(dev, B43_PHY_ANALOGOVER);
 		sav->phy_analogoverval =
 		    b43_phy_read(dev, B43_PHY_ANALOGOVERVAL);
 		sav->phy_rfover = b43_phy_read(dev, B43_PHY_RFOVER);
 		sav->phy_rfoverval = b43_phy_read(dev, B43_PHY_RFOVERVAL);
 		sav->phy_classctl = b43_phy_read(dev, B43_PHY_CLASSCTL);
-		sav->phy_base_3E = b43_phy_read(dev, B43_PHY_BASE(0x3E));
+		sav->phy_cck_3E = b43_phy_read(dev, B43_PHY_CCK(0x3E));
 		sav->phy_crs0 = b43_phy_read(dev, B43_PHY_CRS0);
 
 		b43_phy_write(dev, B43_PHY_CLASSCTL,
 			      b43_phy_read(dev, B43_PHY_CLASSCTL)
 			      & 0xFFFC);
 		b43_phy_write(dev, B43_PHY_CRS0, b43_phy_read(dev, B43_PHY_CRS0)
@@ -639,68 +639,68 @@ static void lo_measure_setup(struct b43_
 			} else {
 				b43_phy_write(dev, B43_PHY_RFOVER, 0x133);
 			}
 		} else {
 			b43_phy_write(dev, B43_PHY_RFOVER, 0);
 		}
-		b43_phy_write(dev, B43_PHY_BASE(0x3E), 0);
+		b43_phy_write(dev, B43_PHY_CCK(0x3E), 0);
 	}
 	sav->reg_3F4 = b43_read16(dev, 0x3F4);
 	sav->reg_3E2 = b43_read16(dev, 0x3E2);
 	sav->radio_43 = b43_radio_read16(dev, 0x43);
 	sav->radio_7A = b43_radio_read16(dev, 0x7A);
 	sav->phy_pgactl = b43_phy_read(dev, B43_PHY_PGACTL);
-	sav->phy_base_2A = b43_phy_read(dev, B43_PHY_BASE(0x2A));
+	sav->phy_cck_2A = b43_phy_read(dev, B43_PHY_CCK(0x2A));
 	sav->phy_syncctl = b43_phy_read(dev, B43_PHY_SYNCCTL);
 	sav->phy_dacctl = b43_phy_read(dev, B43_PHY_DACCTL);
 
 	if (!has_tx_magnification(phy)) {
 		sav->radio_52 = b43_radio_read16(dev, 0x52);
 		sav->radio_52 &= 0x00F0;
 	}
 	if (phy->type == B43_PHYTYPE_B) {
-		sav->phy_base_30 = b43_phy_read(dev, B43_PHY_BASE(0x30));
-		sav->phy_base_06 = b43_phy_read(dev, B43_PHY_BASE(0x06));
-		b43_phy_write(dev, B43_PHY_BASE(0x30), 0x00FF);
-		b43_phy_write(dev, B43_PHY_BASE(0x06), 0x3F3F);
+		sav->phy_cck_30 = b43_phy_read(dev, B43_PHY_CCK(0x30));
+		sav->phy_cck_06 = b43_phy_read(dev, B43_PHY_CCK(0x06));
+		b43_phy_write(dev, B43_PHY_CCK(0x30), 0x00FF);
+		b43_phy_write(dev, B43_PHY_CCK(0x06), 0x3F3F);
 	} else {
 		b43_write16(dev, 0x3E2, b43_read16(dev, 0x3E2)
 			    | 0x8000);
 	}
 	b43_write16(dev, 0x3F4, b43_read16(dev, 0x3F4)
 		    & 0xF000);
 
 	tmp =
-	    (phy->type == B43_PHYTYPE_G) ? B43_PHY_LO_MASK : B43_PHY_BASE(0x2E);
+	    (phy->type == B43_PHYTYPE_G) ? B43_PHY_LO_MASK : B43_PHY_CCK(0x2E);
 	b43_phy_write(dev, tmp, 0x007F);
 
 	tmp = sav->phy_syncctl;
 	b43_phy_write(dev, B43_PHY_SYNCCTL, tmp & 0xFF7F);
 	tmp = sav->radio_7A;
 	b43_radio_write16(dev, 0x007A, tmp & 0xFFF0);
 
-	b43_phy_write(dev, B43_PHY_BASE(0x2A), 0x8A3);
+	b43_phy_write(dev, B43_PHY_CCK(0x2A), 0x8A3);
 	if (phy->type == B43_PHYTYPE_G ||
 	    (phy->type == B43_PHYTYPE_B &&
 	     phy->radio_ver == 0x2050 && phy->radio_rev >= 6)) {
-		b43_phy_write(dev, B43_PHY_BASE(0x2B), 0x1003);
+		b43_phy_write(dev, B43_PHY_CCK(0x2B), 0x1003);
 	} else
-		b43_phy_write(dev, B43_PHY_BASE(0x2B), 0x0802);
+		b43_phy_write(dev, B43_PHY_CCK(0x2B), 0x0802);
 	if (phy->rev >= 2)
 		b43_dummy_transmission(dev);
 	b43_radio_selectchannel(dev, 6, 0);
 	b43_radio_read16(dev, 0x51);	/* dummy read */
 	if (phy->type == B43_PHYTYPE_G)
-		b43_phy_write(dev, B43_PHY_BASE(0x2F), 0);
+		b43_phy_write(dev, B43_PHY_CCK(0x2F), 0);
 	if (lo->rebuild)
 		lo_measure_txctl_values(dev);
 	if (phy->type == B43_PHYTYPE_G && phy->rev >= 3) {
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0xC078);
 	} else {
 		if (phy->type == B43_PHYTYPE_B)
-			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x8078);
+			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8078);
 		else
 			b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
 	}
 }
 
 static void lo_measure_restore(struct b43_wldev *dev,
@@ -729,54 +729,54 @@ static void lo_measure_restore(struct b4
 			b43_lo_g_adjust_to(dev, 3, 2, 0);
 		else
 			b43_lo_g_adjust(dev);
 	}
 	if (phy->type == B43_PHYTYPE_G) {
 		if (phy->rev >= 3)
-			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0xC078);
+			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0xC078);
 		else
-			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x8078);
+			b43_phy_write(dev, B43_PHY_CCK(0x2E), 0x8078);
 		if (phy->rev >= 2)
-			b43_phy_write(dev, B43_PHY_BASE(0x2F), 0x0202);
+			b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x0202);
 		else
-			b43_phy_write(dev, B43_PHY_BASE(0x2F), 0x0101);
+			b43_phy_write(dev, B43_PHY_CCK(0x2F), 0x0101);
 	}
 	b43_write16(dev, 0x3F4, sav->reg_3F4);
 	b43_phy_write(dev, B43_PHY_PGACTL, sav->phy_pgactl);
-	b43_phy_write(dev, B43_PHY_BASE(0x2A), sav->phy_base_2A);
+	b43_phy_write(dev, B43_PHY_CCK(0x2A), sav->phy_cck_2A);
 	b43_phy_write(dev, B43_PHY_SYNCCTL, sav->phy_syncctl);
 	b43_phy_write(dev, B43_PHY_DACCTL, sav->phy_dacctl);
 	b43_radio_write16(dev, 0x43, sav->radio_43);
 	b43_radio_write16(dev, 0x7A, sav->radio_7A);
 	if (!has_tx_magnification(phy)) {
 		tmp = sav->radio_52;
 		b43_radio_write16(dev, 0x52, (b43_radio_read16(dev, 0x52)
 					      & 0xFF0F) | tmp);
 	}
 	b43_write16(dev, 0x3E2, sav->reg_3E2);
 	if (phy->type == B43_PHYTYPE_B &&
 	    phy->radio_ver == 0x2050 && phy->radio_rev <= 5) {
-		b43_phy_write(dev, B43_PHY_BASE(0x30), sav->phy_base_30);
-		b43_phy_write(dev, B43_PHY_BASE(0x06), sav->phy_base_06);
+		b43_phy_write(dev, B43_PHY_CCK(0x30), sav->phy_cck_30);
+		b43_phy_write(dev, B43_PHY_CCK(0x06), sav->phy_cck_06);
 	}
 	if (phy->rev >= 2) {
 		b43_phy_write(dev, B43_PHY_ANALOGOVER, sav->phy_analogover);
 		b43_phy_write(dev, B43_PHY_ANALOGOVERVAL,
 			      sav->phy_analogoverval);
 		b43_phy_write(dev, B43_PHY_CLASSCTL, sav->phy_classctl);
 		b43_phy_write(dev, B43_PHY_RFOVER, sav->phy_rfover);
 		b43_phy_write(dev, B43_PHY_RFOVERVAL, sav->phy_rfoverval);
-		b43_phy_write(dev, B43_PHY_BASE(0x3E), sav->phy_base_3E);
+		b43_phy_write(dev, B43_PHY_CCK(0x3E), sav->phy_cck_3E);
 		b43_phy_write(dev, B43_PHY_CRS0, sav->phy_crs0);
 	}
 	if (b43_has_hardware_pctl(phy)) {
 		tmp = (sav->phy_lo_mask & 0xBFFF);
 		b43_phy_write(dev, B43_PHY_LO_MASK, tmp);
 		b43_phy_write(dev, B43_PHY_EXTG(0x01), sav->phy_extg_01);
 		b43_phy_write(dev, B43_PHY_DACCTL, sav->phy_dacctl_hwpctl);
-		b43_phy_write(dev, B43_PHY_BASE(0x14), sav->phy_base_14);
+		b43_phy_write(dev, B43_PHY_CCK(0x14), sav->phy_cck_14);
 		b43_phy_write(dev, B43_PHY_HPWR_TSSICTL, sav->phy_hpwr_tssictl);
 	}
 	b43_radio_selectchannel(dev, sav->old_channel, 1);
 }
 
 struct b43_lo_g_statemachine {
