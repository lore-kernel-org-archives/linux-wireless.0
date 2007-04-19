Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:44404 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161505AbXDSNq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 09:46:26 -0400
Date: Thu, 19 Apr 2007 08:47:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] bcm43xx-mac80211: Fix machine check on PPC for  phy->rev == 1
Message-ID: <462772dd.XXaOmceDEQQJ3+9R%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 3/3: References to the Analog Override and Analog Override Value
Registers in the Extended G PHY Registers cause a machine check on
PPC architecture and a phy->rev == 1 chip. These patches skip over the
troublesome accesses. These changes do not conform with the specs,
but were found necessary for bcm43xx-softmac as well.

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
@@ -1361,7 +1361,7 @@ static void bcm43xx_phy_initb6(struct bc
 static void bcm43xx_calc_loopback_gain(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_phy *phy = &dev->phy;
-	u16 backup_phy[16];
+	u16 backup_phy[16] = {0};
 	u16 backup_radio[3];
 	u16 backup_bband;
 	u16 i, j, loop_i_max;
@@ -1372,8 +1372,10 @@ static void bcm43xx_calc_loopback_gain(s
 	backup_phy[1] = bcm43xx_phy_read(dev, BCM43xx_PHY_CCKBBANDCFG);
 	backup_phy[2] = bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVER);
 	backup_phy[3] = bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVERVAL);
-	backup_phy[4] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER);
-	backup_phy[5] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL);
+	if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+		backup_phy[4] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER);
+		backup_phy[5] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL);
+	}
 	backup_phy[6] = bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x5A));
 	backup_phy[7] = bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x59));
 	backup_phy[8] = bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x58));
@@ -1401,14 +1403,16 @@ static void bcm43xx_calc_loopback_gain(s
 			  bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVER) | 0x0001);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVERVAL,
 			  bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVERVAL) & 0xFFFE);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0001);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFE);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0002);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFD);
+	if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0001);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFE);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0002);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFD);
+	}
 	bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVER,
 			  bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVER) | 0x000C);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVER,
@@ -1425,10 +1429,12 @@ static void bcm43xx_calc_loopback_gain(s
 
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x0A),
 			  bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x0A)) | 0x2000);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0004);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFB);
+	if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0004);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFB);
+	}
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x03),
 			  (bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x03))
 			   & 0xFF9F) | 0x40);
@@ -1521,8 +1527,10 @@ exit_loop1:
 		trsw_rx = 0x18;
 exit_loop2:
 
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER, backup_phy[4]);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL, backup_phy[5]);
+	if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER, backup_phy[4]);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL, backup_phy[5]);
+	}
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x5A), backup_phy[6]);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x59), backup_phy[7]);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x58), backup_phy[8]);
@@ -2431,8 +2439,10 @@ static void bcm43xx_calc_nrssi_offset(st
 	backup[0] = bcm43xx_phy_read(dev, 0x0001);
 	backup[1] = bcm43xx_phy_read(dev, 0x0811);
 	backup[2] = bcm43xx_phy_read(dev, 0x0812);
-	backup[3] = bcm43xx_phy_read(dev, 0x0814);
-	backup[4] = bcm43xx_phy_read(dev, 0x0815);
+	if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+		backup[3] = bcm43xx_phy_read(dev, 0x0814);
+		backup[4] = bcm43xx_phy_read(dev, 0x0815);
+	}
 	backup[5] = bcm43xx_phy_read(dev, 0x005A);
 	backup[6] = bcm43xx_phy_read(dev, 0x0059);
 	backup[7] = bcm43xx_phy_read(dev, 0x0058);
@@ -2498,10 +2508,12 @@ static void bcm43xx_calc_nrssi_offset(st
 	} else {
 		bcm43xx_radio_write16(dev, 0x007A,
 				      bcm43xx_radio_read16(dev, 0x007A) & 0x007F);
-		bcm43xx_phy_write(dev, 0x0814,
-				  bcm43xx_phy_read(dev, 0x0814) | 0x0001);
-		bcm43xx_phy_write(dev, 0x0815,
-				  bcm43xx_phy_read(dev, 0x0815) & 0xFFFE);
+		if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+			bcm43xx_phy_write(dev, 0x0814,
+					  bcm43xx_phy_read(dev, 0x0814) | 0x0001);
+			bcm43xx_phy_write(dev, 0x0815,
+					  bcm43xx_phy_read(dev, 0x0815) & 0xFFFE);
+		}
 		bcm43xx_phy_write(dev, 0x0811,
 				  bcm43xx_phy_read(dev, 0x0811) | 0x000C);
 		bcm43xx_phy_write(dev, 0x0812,
@@ -2520,10 +2532,12 @@ static void bcm43xx_calc_nrssi_offset(st
 					  bcm43xx_phy_read(dev, 0x000A)
 					  | 0x2000);
 		}
-		bcm43xx_phy_write(dev, 0x0814,
-				  bcm43xx_phy_read(dev, 0x0814) | 0x0004);
-		bcm43xx_phy_write(dev, 0x0815,
-				  bcm43xx_phy_read(dev, 0x0815) & 0xFFFB);
+		if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+			bcm43xx_phy_write(dev, 0x0814,
+					  bcm43xx_phy_read(dev, 0x0814) | 0x0004);
+			bcm43xx_phy_write(dev, 0x0815,
+					  bcm43xx_phy_read(dev, 0x0815) & 0xFFFB);
+		}
 		bcm43xx_phy_write(dev, 0x0003,
 				  (bcm43xx_phy_read(dev, 0x0003) & 0xFF9F)
 				  | 0x0040);
@@ -2560,8 +2574,10 @@ static void bcm43xx_calc_nrssi_offset(st
 		bcm43xx_phy_write(dev, 0x080F, backup[14]);
 		bcm43xx_phy_write(dev, 0x0810, backup[15]);
 	}
-	bcm43xx_phy_write(dev, 0x0814, backup[3]);
-	bcm43xx_phy_write(dev, 0x0815, backup[4]);
+	if (phy->rev != 1) { /* Not in specs, but needed to prevent PPC machine check */
+		bcm43xx_phy_write(dev, 0x0814, backup[3]);
+		bcm43xx_phy_write(dev, 0x0815, backup[4]);
+	}
 	bcm43xx_phy_write(dev, 0x005A, backup[5]);
 	bcm43xx_phy_write(dev, 0x0059, backup[6]);
 	bcm43xx_phy_write(dev, 0x0058, backup[7]);
