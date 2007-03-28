Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:58141 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbXC1QIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 12:08:39 -0400
Date: Wed, 28 Mar 2007 11:07:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Change initialization for 2050 radios
Message-ID: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the changes in the specifications for 2050radio_init that
were recently posted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This material is for wireless-2.6 and the 'upstream' branch.

Larry


Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -1343,11 +1343,110 @@ u16 bcm43xx_radio_calibrationvalue(struc
 	return ret;
 }
 
+#define LPD(L, P, D)    (((L) << 2) | ((P) << 1) | ((D) << 0))
+static u16 bcm43xx_get_812_value(struct bcm43xx_private *bcm, u8 lpd)
+{
+	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
+	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
+	u16 loop_or = 0;
+	u16 adj_loopback_gain = phy->loopback_gain[0];
+	u8 loop;
+	u16 extern_lna_control;
+
+	if (!phy->connected)
+		return 0;
+	if (!has_loopback_gain(phy)) {
+		if (phy->rev < 7 || !(bcm->sprom.boardflags
+		    & BCM43xx_BFL_EXTLNA)) {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x0FB2;
+			case LPD(0, 0, 1):
+				return 0x00B2;
+			case LPD(1, 0, 1):
+				return 0x30B2;
+			case LPD(1, 0, 0):
+				return 0x30B3;
+			default:
+				assert(0);
+			}
+		} else {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x8FB2;
+			case LPD(0, 0, 1):
+				return 0x80B2;
+			case LPD(1, 0, 1):
+				return 0x20B2;
+			case LPD(1, 0, 0):
+				return 0x20B3;
+			default:
+				assert(0);
+			}
+		}
+	} else {
+		if (radio->revision == 8)
+			adj_loopback_gain += 0x003E;
+		else
+			adj_loopback_gain += 0x0026;
+		if (adj_loopback_gain >= 0x46) {
+			adj_loopback_gain -= 0x46;
+			extern_lna_control = 0x3000;
+		} else if (adj_loopback_gain >= 0x3A) {
+			adj_loopback_gain -= 0x3A;
+			extern_lna_control = 0x2000;
+		} else if (adj_loopback_gain >= 0x2E) {
+			adj_loopback_gain -= 0x2E;
+			extern_lna_control = 0x1000;
+		} else {
+			adj_loopback_gain -= 0x10;
+			extern_lna_control = 0x0000;
+		}
+		for (loop = 0; loop < 16; loop++) {
+			u16 tmp = adj_loopback_gain - 6 * loop;
+			if (tmp < 6)
+				break;
+		}
+
+		loop_or = (loop << 8) | extern_lna_control;
+		if (phy->rev >= 7 && bcm->sprom.boardflags
+		    & BCM43xx_BFL_EXTLNA) {
+			if (extern_lna_control)
+				loop_or |= 0x8000;
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x8F92;
+			case LPD(0, 0, 1):
+				return (0x8092 | loop_or);
+			case LPD(1, 0, 1):
+				return (0x2092 | loop_or);
+			case LPD(1, 0, 0):
+				return (0x2093 | loop_or);
+			default:
+				assert(0);
+			}
+		} else {
+			switch (lpd) {
+			case LPD(0, 1, 1):
+				return 0x0F92;
+			case LPD(0, 0, 1):
+			case LPD(1, 0, 1):
+				return (0x0092 | loop_or);
+			case LPD(1, 0, 0):
+				return (0x0093 | loop_or);
+			default:
+				assert(0);
+			}
+		}
+	}
+	return 0;
+}
+
 u16 bcm43xx_radio_init2050(struct bcm43xx_private *bcm)
 {
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	u16 backup[19] = { 0 };
+	u16 backup[21] = { 0 };
 	u16 ret;
 	u16 i, j;
 	u32 tmp1 = 0, tmp2 = 0;
@@ -1373,19 +1472,36 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 			backup[8] = bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS);
 			backup[9] = bcm43xx_phy_read(bcm, 0x0802);
 			bcm43xx_phy_write(bcm, 0x0814,
-			                  (bcm43xx_phy_read(bcm, 0x0814) | 0x0003));
+			                  (bcm43xx_phy_read(bcm, 0x0814)
+					  | 0x0003));
 			bcm43xx_phy_write(bcm, 0x0815,
-			                  (bcm43xx_phy_read(bcm, 0x0815) & 0xFFFC));	
+			                  (bcm43xx_phy_read(bcm, 0x0815)
+					  & 0xFFFC));
 			bcm43xx_phy_write(bcm, BCM43xx_PHY_G_CRS,
-			                  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS) & 0x7FFF));
+			                  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS)
+					  & 0x7FFF));
 			bcm43xx_phy_write(bcm, 0x0802,
 			                  (bcm43xx_phy_read(bcm, 0x0802) & 0xFFFC));
-			bcm43xx_phy_write(bcm, 0x0811, 0x01B3);
-			bcm43xx_phy_write(bcm, 0x0812, 0x0FB2);
+			if (phy->rev > 1) { /* loopback gain enabled */
+				backup[19] = bcm43xx_phy_read(bcm, 0x080F);
+				backup[20] = bcm43xx_phy_read(bcm, 0x0810);
+				if (phy->rev >= 3)
+					bcm43xx_phy_write(bcm, 0x080F, 0xC020);
+				else
+					bcm43xx_phy_write(bcm, 0x080F, 0x8020);
+				bcm43xx_phy_write(bcm, 0x0810, 0x0000);
+			}
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(0, 1, 1)));
+			if (phy->rev < 7 || !(bcm->sprom.boardflags
+			    & BCM43xx_BFL_EXTLNA))
+				bcm43xx_phy_write(bcm, 0x0811, 0x01B3);
+			else
+				bcm43xx_phy_write(bcm, 0x0811, 0x09B3);
 		}
-		bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
-		                (bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_RADIO) | 0x8000));
 	}
+	bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
+	                (bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_RADIO) | 0x8000));
 	backup[10] = bcm43xx_phy_read(bcm, 0x0035);
 	bcm43xx_phy_write(bcm, 0x0035,
 	                  (bcm43xx_phy_read(bcm, 0x0035) & 0xFF7F));
@@ -1397,10 +1513,12 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 		bcm43xx_write16(bcm, 0x03E6, 0x0122);
 	} else {
 		if (phy->analog >= 2)
-			bcm43xx_phy_write(bcm, 0x0003, (bcm43xx_phy_read(bcm, 0x0003)
-					& 0xFFBF) | 0x0040);
+			bcm43xx_phy_write(bcm, 0x0003,
+					  (bcm43xx_phy_read(bcm, 0x0003)
+					  & 0xFFBF) | 0x0040);
 		bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT,
-		                (bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT) | 0x2000));
+		                (bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT)
+				| 0x2000));
 	}
 
 	ret = bcm43xx_radio_calibrationvalue(bcm);
@@ -1408,16 +1526,25 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 	if (phy->type == BCM43xx_PHYTYPE_B)
 		bcm43xx_radio_write16(bcm, 0x0078, 0x0026);
 
+	if (phy->connected)
+		bcm43xx_phy_write(bcm, 0x0812,
+				  bcm43xx_get_812_value(bcm, LPD(0, 1, 1)));
 	bcm43xx_phy_write(bcm, 0x0015, 0xBFAF);
 	bcm43xx_phy_write(bcm, 0x002B, 0x1403);
 	if (phy->connected)
-		bcm43xx_phy_write(bcm, 0x0812, 0x00B2);
+		bcm43xx_phy_write(bcm, 0x0812,
+				  bcm43xx_get_812_value(bcm, LPD(0, 0, 1)));
 	bcm43xx_phy_write(bcm, 0x0015, 0xBFA0);
 	bcm43xx_radio_write16(bcm, 0x0051,
 	                      (bcm43xx_radio_read16(bcm, 0x0051) | 0x0004));
-	bcm43xx_radio_write16(bcm, 0x0052, 0x0000);
-	bcm43xx_radio_write16(bcm, 0x0043,
-			      (bcm43xx_radio_read16(bcm, 0x0043) & 0xFFF0) | 0x0009);
+	if (radio->revision == 8)
+		bcm43xx_radio_write16(bcm, 0x0043, 0x001F);
+	else {
+		bcm43xx_radio_write16(bcm, 0x0052, 0x0000);
+		bcm43xx_radio_write16(bcm, 0x0043,
+				      (bcm43xx_radio_read16(bcm, 0x0043) & 0xFFF0)
+				      | 0x0009);
+	}
 	bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 
 	for (i = 0; i < 16; i++) {
@@ -1425,21 +1552,25 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 		bcm43xx_phy_write(bcm, 0x0059, 0xC810);
 		bcm43xx_phy_write(bcm, 0x0058, 0x000D);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 1)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 		udelay(10);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 1)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xEFB0);
 		udelay(10);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 0)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xFFF0);
-		udelay(10);
+		udelay(20);
 		tmp1 += bcm43xx_phy_read(bcm, 0x002D);
 		bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 		if (phy->connected)
-			bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+			bcm43xx_phy_write(bcm, 0x0812,
+					  bcm43xx_get_812_value(bcm, LPD(1, 0, 1)));
 		bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 	}
 
@@ -1457,21 +1588,29 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 			bcm43xx_phy_write(bcm, 0x0059, 0xC810);
 			bcm43xx_phy_write(bcm, 0x0058, 0x000D);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 1)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 			udelay(10);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 1)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xEFB0);
 			udelay(10);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B3); /* 0x30B3 is not a typo */
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 0)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xFFF0);
 			udelay(10);
 			tmp2 += bcm43xx_phy_read(bcm, 0x002D);
 			bcm43xx_phy_write(bcm, 0x0058, 0x0000);
 			if (phy->connected)
-				bcm43xx_phy_write(bcm, 0x0812, 0x30B2);
+				bcm43xx_phy_write(bcm, 0x0812,
+						  bcm43xx_get_812_value(bcm,
+						  LPD(1, 0, 1)));
 			bcm43xx_phy_write(bcm, 0x0015, 0xAFB0);
 		}
 		tmp2++;
@@ -1497,15 +1636,20 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 		bcm43xx_phy_write(bcm, 0x0030, backup[2]);
 		bcm43xx_write16(bcm, 0x03EC, backup[3]);
 	} else {
-		bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
-				(bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_RADIO) & 0x7FFF));
 		if (phy->connected) {
+			bcm43xx_write16(bcm, BCM43xx_MMIO_PHY_RADIO,
+					(bcm43xx_read16(bcm,
+					BCM43xx_MMIO_PHY_RADIO) & 0x7FFF));
 			bcm43xx_phy_write(bcm, 0x0811, backup[4]);
 			bcm43xx_phy_write(bcm, 0x0812, backup[5]);
 			bcm43xx_phy_write(bcm, 0x0814, backup[6]);
 			bcm43xx_phy_write(bcm, 0x0815, backup[7]);
 			bcm43xx_phy_write(bcm, BCM43xx_PHY_G_CRS, backup[8]);
 			bcm43xx_phy_write(bcm, 0x0802, backup[9]);
+			if (phy->rev > 1) {
+				bcm43xx_phy_write(bcm, 0x080F, backup[19]);
+				bcm43xx_phy_write(bcm, 0x0810, backup[20]);
+			}
 		}
 	}
 	if (i >= 15)
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.h
@@ -48,6 +48,10 @@ void bcm43xx_raw_phy_unlock(struct bcm43
 		local_irq_restore(flags);	\
 	} while (0)
 
+/* Card uses the loopback gain stuff */
+#define has_loopback_gain(phy) \
+        (((phy)->rev > 1) || ((phy)->connected))
+
 u16 bcm43xx_phy_read(struct bcm43xx_private *bcm, u16 offset);
 void bcm43xx_phy_write(struct bcm43xx_private *bcm, u16 offset, u16 val);
 
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -300,16 +300,20 @@ static void bcm43xx_phy_agcsetup(struct 
 
 	if (phy->rev > 2) {
 		bcm43xx_phy_write(bcm, 0x0422, 0x287A);
-		bcm43xx_phy_write(bcm, 0x0420, (bcm43xx_phy_read(bcm, 0x0420) & 0x0FFF) | 0x3000); 
+		bcm43xx_phy_write(bcm, 0x0420, (bcm43xx_phy_read(bcm, 0x0420)
+				  & 0x0FFF) | 0x3000);
 	}
 		
-	bcm43xx_phy_write(bcm, 0x04A8, (bcm43xx_phy_read(bcm, 0x04A8) & 0x8080) | 0x7874);
+	bcm43xx_phy_write(bcm, 0x04A8, (bcm43xx_phy_read(bcm, 0x04A8) & 0x8080)
+					| 0x7874);
 	bcm43xx_phy_write(bcm, 0x048E, 0x1C00);
 
 	if (phy->rev == 1) {
-		bcm43xx_phy_write(bcm, 0x04AB, (bcm43xx_phy_read(bcm, 0x04AB) & 0xF0FF) | 0x0600);
+		bcm43xx_phy_write(bcm, 0x04AB, (bcm43xx_phy_read(bcm, 0x04AB)
+				  & 0xF0FF) | 0x0600);
 		bcm43xx_phy_write(bcm, 0x048B, 0x005E);
-		bcm43xx_phy_write(bcm, 0x048C, (bcm43xx_phy_read(bcm, 0x048C) & 0xFF00) | 0x001E);
+		bcm43xx_phy_write(bcm, 0x048C, (bcm43xx_phy_read(bcm, 0x048C)
+				  & 0xFF00) | 0x001E);
 		bcm43xx_phy_write(bcm, 0x048D, 0x0002);
 	}
 
@@ -335,7 +339,8 @@ static void bcm43xx_phy_setupg(struct bc
 	if (phy->rev == 1) {
 		bcm43xx_phy_write(bcm, 0x0406, 0x4F19);
 		bcm43xx_phy_write(bcm, BCM43xx_PHY_G_CRS,
-				  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS) & 0xFC3F) | 0x0340);
+				  (bcm43xx_phy_read(bcm, BCM43xx_PHY_G_CRS)
+				  & 0xFC3F) | 0x0340);
 		bcm43xx_phy_write(bcm, 0x042C, 0x005A);
 		bcm43xx_phy_write(bcm, 0x0427, 0x001A);
 
