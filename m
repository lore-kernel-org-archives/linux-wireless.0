Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:44880 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbXBMW5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 17:57:16 -0500
Date: Tue, 13 Feb 2007 16:56:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: OFDM fix for rev 1 cards
Message-ID: <45d24215.ArbNyvChpk0vYXTg%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nearly all of the writes to the bcm43xx internal lookup tables (ilt)
involve 16-bit quantities. Accordingly, the ilt_write routine was coded to
pass a u16 value. For one early GPHY chip, 32-bit quantities are needed. For
those writes, the value was clipped to 16 bits. This patch adds an ilt_write32
routine that receives a 32-bit quantity and writes it to the appropriate
locations.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---


Nearly all of the writes to the bcm43xx internal lookup tables (ilt)
involve 16-bit quantities. Accordingly, the ilt_write routine was coded to
pass a u16 value. For one early GPHY chip, 32-bit quantities are needed. For
those writes, the value was clipped to 16 bits. This patch adds an ilt_write32
routine that receives a 32-bit quantity and writes it to the appropriate
locations.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---


Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.c
@@ -325,6 +325,21 @@ void bcm43xx_ilt_write(struct bcm43xx_pr
 	}
 }
 
+void bcm43xx_ilt_write32(struct bcm43xx_private *bcm, u16 offset, u32 val)
+{
+	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_CTRL, offset);
+		mmiowb();
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA2, (val & 0xFFFF0000) >> 16);
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_A_DATA1, val & 0x0000FFFF);
+	} else {
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_CTRL, offset);
+		mmiowb();
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA2, (val & 0xFFFF0000) >> 16);
+		bcm43xx_phy_write(bcm, BCM43xx_PHY_ILT_G_DATA1, val & 0x0000FFFF);
+	}
+}
+
 u16 bcm43xx_ilt_read(struct bcm43xx_private *bcm, u16 offset)
 {
 	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A) {
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -344,7 +344,7 @@ static void bcm43xx_phy_setupg(struct bc
 		for (i = 0; i < BCM43xx_ILT_NOISEG1_SIZE; i++)
 			bcm43xx_ilt_write(bcm, 0x1800 + i, bcm43xx_ilt_noiseg1[i]);
 		for (i = 0; i < BCM43xx_ILT_ROTOR_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
+			bcm43xx_ilt_write32(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
 	} else {
 		/* nrssi values are signed 6-bit values. Not sure why we write 0x7654 here... */
 		bcm43xx_nrssi_hw_write(bcm, 0xBA98, (s16)0x7654);
@@ -384,7 +384,7 @@ static void bcm43xx_phy_setupg(struct bc
 	
 	if (phy->rev == 1) {
 		for (i = 0; i < BCM43xx_ILT_RETARD_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
+			bcm43xx_ilt_write32(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
 		for (i = 0; i < 4; i++) {
 			bcm43xx_ilt_write(bcm, 0x5404 + i, 0x0020);
 			bcm43xx_ilt_write(bcm, 0x5408 + i, 0x0020);
@@ -507,10 +507,10 @@ static void bcm43xx_phy_setupa(struct bc
 		for (i = 0; i < BCM43xx_ILT_NOISEA2_SIZE; i++)
 			bcm43xx_ilt_write(bcm, 0x1800 + i, bcm43xx_ilt_noisea2[i]);
 		for (i = 0; i < BCM43xx_ILT_ROTOR_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
+			bcm43xx_ilt_write32(bcm, 0x2000 + i, bcm43xx_ilt_rotor[i]);
 		bcm43xx_phy_init_noisescaletbl(bcm);
 		for (i = 0; i < BCM43xx_ILT_RETARD_SIZE; i++)
-			bcm43xx_ilt_write(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
+			bcm43xx_ilt_write32(bcm, 0x2400 + i, bcm43xx_ilt_retard[i]);
 		break;
 	case 3:
 		for (i = 0; i < 64; i++)
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ilt.h
@@ -27,6 +27,7 @@ extern const u16 bcm43xx_ilt_sigmasqr2[B
 
 
 void bcm43xx_ilt_write(struct bcm43xx_private *bcm, u16 offset, u16 val);
+void bcm43xx_ilt_write32(struct bcm43xx_private *bcm, u16 offset, u32 val);
 u16 bcm43xx_ilt_read(struct bcm43xx_private *bcm, u16 offset);
 
 #endif /* BCM43xx_ILT_H_ */
