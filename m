Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:60983 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161497AbXDSNp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 09:45:26 -0400
Date: Thu, 19 Apr 2007 08:47:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] bcm43xx-mac80211: Fix machine check on PPC for  phy->rev == 1
Message-ID: <462772da.WTFJ4M8EynD9kYbu%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 2/3: There are recent changes to the specs that eliminate a
number of machine check errors on PPC architecture when used with
phy->rev == 1 chips.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is for the wireless-dev tree. A separate one will be prepared
for the mb tree.

Larry


Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
@@ -599,16 +599,16 @@ static void bcm43xx_phy_agcsetup(struct 
 	bcm43xx_phy_write(dev, 0x04A1,
 			  (bcm43xx_phy_read(dev, 0x04A1)
 			   & 0xF0FF) | 0x0600);
-	bcm43xx_phy_write(dev, 0x04A2,
-			  (bcm43xx_phy_read(dev, 0x04A2)
+	bcm43xx_phy_write(dev, 0x0412,
+			  (bcm43xx_phy_read(dev, 0x0412)
 			   & 0xF0FF) | 0x0700);
-	bcm43xx_phy_write(dev, 0x04A0,
-			  (bcm43xx_phy_read(dev, 0x04A0)
+	bcm43xx_phy_write(dev, 0x0410,
+			  (bcm43xx_phy_read(dev, 0x0410)
 			   & 0xF0FF) | 0x0100);
 
 	if (phy->rev == 1) {
-		bcm43xx_phy_write(dev, 0x04A2,
-				  (bcm43xx_phy_read(dev, 0x04A2)
+		bcm43xx_phy_write(dev, 0x0412,
+				  (bcm43xx_phy_read(dev, 0x0412)
 				   & 0xFFF0) | 0x0007);
 	}
 
@@ -955,7 +955,7 @@ static void bcm43xx_phy_inita(struct bcm
 		bcm43xx_phy_setupa(dev);
 	} else {
 		bcm43xx_phy_setupg(dev);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & BCM43xx_BFL_PACTRL)
+		if (phy->gmode && dev->dev->bus->sprom.r1.boardflags_lo & BCM43xx_BFL_PACTRL)
 			bcm43xx_phy_write(dev, 0x046E, 0x03CF);
 		return;
 	}
@@ -1139,7 +1139,7 @@ static void bcm43xx_phy_initb5(struct bc
 	if (phy->radio_ver == 0x2050)
 		bcm43xx_phy_write(dev, 0x0038, 0x0667);
 
-	if (phy->type == BCM43xx_PHYTYPE_G) {
+	if (phy->gmode || phy->rev >= 2) {
 		if (phy->radio_ver == 0x2050) {
 			bcm43xx_radio_write16(dev, 0x007A,
 					      bcm43xx_radio_read16(dev, 0x007A)
@@ -1560,7 +1560,7 @@ static void bcm43xx_phy_initg(struct bcm
 	else
 		bcm43xx_phy_initb6(dev);
 
-	if (has_loopback_gain(phy))
+	if (phy->rev >= 2 || phy->gmode)
 		bcm43xx_phy_inita(dev);
 
 	if (phy->rev >= 2) {
@@ -1575,7 +1575,7 @@ static void bcm43xx_phy_initg(struct bcm
 		bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVER, 0x400);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xC0);
 	}
-	if (phy->gmode) {
+	if (phy->gmode || phy->rev >= 2) {
 		tmp = bcm43xx_phy_read(dev, BCM43xx_PHY_VERSION_OFDM);
 		tmp &= BCM43xx_PHYVER_VERSION;
 		if (tmp == 3 || tmp == 5) {
@@ -1588,7 +1588,7 @@ static void bcm43xx_phy_initg(struct bcm
 					   & 0x00FF) | 0x1F00);
 		}
 	}
-	if (phy->rev <= 2 && phy->gmode)
+	if ((phy->rev <= 2 && phy->gmode) || phy->rev >= 2)
 		bcm43xx_phy_write(dev, BCM43xx_PHY_OFDM(0x7E), 0x78);
 	if (phy->radio_rev == 8) {
 		bcm43xx_phy_write(dev, BCM43xx_PHY_EXTG(0x01),
@@ -1634,7 +1634,7 @@ static void bcm43xx_phy_initg(struct bcm
 		else
 			bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x2F), 0x202);
 	}
-	if (phy->gmode) {
+	if (phy->gmode || phy->rev >= 2) {
 		bcm43xx_lo_adjust(dev);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_LO_MASK, 0x8078);
 	}
@@ -1648,8 +1648,8 @@ static void bcm43xx_phy_initg(struct bcm
 		 */
 		bcm43xx_nrssi_hw_update(dev, 0xFFFF);//FIXME?
 		bcm43xx_calc_nrssi_threshold(dev);
-	} else {
-		if (phy->gmode && phy->nrssi[0] == -1000) {
+	} else if (phy->gmode || phy->rev >= 2) {
+		if (phy->nrssi[0] == -1000) {
 			assert(phy->nrssi[1] == -1000);
 			bcm43xx_calc_nrssi_slope(dev);
 		} else
@@ -1658,7 +1658,10 @@ static void bcm43xx_phy_initg(struct bcm
 	if (phy->radio_rev == 8)
 		bcm43xx_phy_write(dev, BCM43xx_PHY_EXTG(0x05), 0x3230);
 	bcm43xx_phy_init_pctl(dev);
-	if (0 /*FIXME: OFDM may not be used in the current locale*/) {
+	/* FIXME: The spec says in the following if, the 0 should be replaced
+                  'if OFDM may not be used in the current locale'
+		  but OFDM is legal everywhere */
+	if ((dev->dev->bus->chip_id == 0x4306 && dev->dev->bus->chip_package == 2) || 0) {
 		bcm43xx_phy_write(dev, BCM43xx_PHY_CRS0,
 				  bcm43xx_phy_read(dev, BCM43xx_PHY_CRS0)
 				  & 0xBFFF);
@@ -3299,7 +3302,7 @@ bcm43xx_radio_interference_mitigation_di
 			ofdmtab_stackrestore(0x1A00, 0x3);
 		}
 		phy_stackrestore(0x04A2);
-		phy_stackrestore(0x04A8);
+		phy_stackrestore(0x048A);
 		phy_stackrestore(0x042B);
 		phy_stackrestore(0x048C);
 		bcm43xx_hf_write(dev, bcm43xx_hf_read(dev) & ~BCM43xx_HF_ACIW);
@@ -3553,7 +3556,7 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x30), 0xFF);
 		bcm43xx_write16(dev, 0x3EC, 0x3F3F);
-	} else if (phy->gmode) {
+	} else if (phy->gmode || phy->rev >= 2) {
 		sav.phy_rfover = bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVER);
 		sav.phy_rfoverval = bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVERVAL);
 		sav.phy_analogover = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER);
@@ -3615,14 +3618,14 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 
 	if (phy->type == BCM43xx_PHYTYPE_B)
 		bcm43xx_radio_write16(dev, 0x78, 0x26);
-	if (phy->gmode) {
+	if (phy->gmode || phy->rev >= 2) {
 		bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 				  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 						       LPD(0, 1, 1)));
 	}
 	bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xBFAF);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x2B), 0x1403);
-	if (phy->gmode) {
+	if (phy->gmode || phy->rev >= 2) {
 		bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 				  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 						       LPD(0, 0, 1)));
@@ -3645,21 +3648,21 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x5A), 0x0480);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x59), 0xC810);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x58), 0x000D);
-		if (phy->gmode) {
+		if (phy->gmode || phy->rev >= 2) {
 			bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 					  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 							       LPD(1, 0, 1)));
 		}
 		bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xAFB0);
 		udelay(10);
-		if (phy->gmode) {
+		if (phy->gmode || phy->rev >= 2) {
 			bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 					  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 							       LPD(1, 0, 1)));
 		}
 		bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xEFB0);
 		udelay(10);
-		if (phy->gmode) {
+		if (phy->gmode || phy->rev >= 2) {
 			bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 					  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 							       LPD(1, 0, 0)));
@@ -3668,7 +3671,7 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 		udelay(20);
 		tmp1 += bcm43xx_phy_read(dev, BCM43xx_PHY_LO_LEAKAGE);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x58), 0);
-		if (phy->gmode) {
+		if (phy->gmode || phy->rev >= 2) {
 			bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 					  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 							       LPD(1, 0, 1)));
@@ -3689,21 +3692,21 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 			bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x5A), 0x0D80);
 			bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x59), 0xC810);
 			bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x58), 0x000D);
-			if (phy->gmode) {
+			if (phy->gmode || phy->rev >= 2) {
 				bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 						  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 								       LPD(1, 0, 1)));
 			}
 			bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xAFB0);
 			udelay(10);
-			if (phy->gmode) {
+			if (phy->gmode || phy->rev >= 2) {
 				bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 						  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 								       LPD(1, 0, 1)));
 			}
 			bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xEFB0);
 			udelay(10);
-			if (phy->gmode) {
+			if (phy->gmode || phy->rev >= 2) {
 				bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 						  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 								       LPD(1, 0, 0)));
@@ -3712,7 +3715,7 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 			udelay(10);
 			tmp2 += bcm43xx_phy_read(dev, BCM43xx_PHY_LO_LEAKAGE);
 			bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x58), 0);
-			if (phy->gmode) {
+			if (phy->gmode || phy->rev >= 2) {
 				bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 						  radio2050_rfover_val(dev, BCM43xx_PHY_RFOVERVAL,
 								       LPD(1, 0, 1)));
