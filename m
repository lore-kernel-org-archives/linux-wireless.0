Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:62273 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXDGTNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 15:13:30 -0400
Date: Sat, 07 Apr 2007 14:11:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix PPC machine checks and update to match  loopback gain specifications
Message-ID: <4617ecc7.9X3JbqlkkIIRu2i3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The specifications for loopback_gain calculation and for G PHY initialization
have been updated. This patch implements them and fixes a machine check error
that occurs for PPC architecture with a phy->rev of 1.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This should be applied to wireless-2.6. Because of the machine check on PPC
that it fixes, I think it should also be sent to 'upstream-fixes'.

Larry

 bcm43xx_phy.c |   57 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -983,7 +983,7 @@ static void bcm43xx_calc_loopback_gain(s
 {
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	u16 backup_phy[15];
+	u16 backup_phy[15] = {0};
 	u16 backup_radio[3];
 	u16 backup_bband;
 	u16 i;
@@ -994,8 +994,10 @@ static void bcm43xx_calc_loopback_gain(s
 	backup_phy[1] = bcm43xx_phy_read(bcm, 0x0001);
 	backup_phy[2] = bcm43xx_phy_read(bcm, 0x0811);
 	backup_phy[3] = bcm43xx_phy_read(bcm, 0x0812);
-	backup_phy[4] = bcm43xx_phy_read(bcm, 0x0814);
-	backup_phy[5] = bcm43xx_phy_read(bcm, 0x0815);
+	if (phy->rev != 1) {
+		backup_phy[4] = bcm43xx_phy_read(bcm, 0x0814);
+		backup_phy[5] = bcm43xx_phy_read(bcm, 0x0815);
+	}
 	backup_phy[6] = bcm43xx_phy_read(bcm, 0x005A);
 	backup_phy[7] = bcm43xx_phy_read(bcm, 0x0059);
 	backup_phy[8] = bcm43xx_phy_read(bcm, 0x0058);
@@ -1023,14 +1025,16 @@ static void bcm43xx_calc_loopback_gain(s
 			  bcm43xx_phy_read(bcm, 0x0811) | 0x0001);
 	bcm43xx_phy_write(bcm, 0x0812,
 			  bcm43xx_phy_read(bcm, 0x0812) & 0xFFFE);
-	bcm43xx_phy_write(bcm, 0x0814,
-			  bcm43xx_phy_read(bcm, 0x0814) | 0x0001);
-	bcm43xx_phy_write(bcm, 0x0815,
-			  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFE);
-	bcm43xx_phy_write(bcm, 0x0814,
-			  bcm43xx_phy_read(bcm, 0x0814) | 0x0002);
-	bcm43xx_phy_write(bcm, 0x0815,
-			  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFD);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(bcm, 0x0814,
+				  bcm43xx_phy_read(bcm, 0x0814) | 0x0001);
+		bcm43xx_phy_write(bcm, 0x0815,
+				  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFE);
+		bcm43xx_phy_write(bcm, 0x0814,
+				  bcm43xx_phy_read(bcm, 0x0814) | 0x0002);
+		bcm43xx_phy_write(bcm, 0x0815,
+				  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFD);
+	}
 	bcm43xx_phy_write(bcm, 0x0811,
 			  bcm43xx_phy_read(bcm, 0x0811) | 0x000C);
 	bcm43xx_phy_write(bcm, 0x0812,
@@ -1053,10 +1057,12 @@ static void bcm43xx_calc_loopback_gain(s
 				  bcm43xx_phy_read(bcm, 0x000A)
 				  | 0x2000);
 	}
-	bcm43xx_phy_write(bcm, 0x0814,
-			  bcm43xx_phy_read(bcm, 0x0814) | 0x0004);
-	bcm43xx_phy_write(bcm, 0x0815,
-			  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFB);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(bcm, 0x0814,
+				  bcm43xx_phy_read(bcm, 0x0814) | 0x0004);
+		bcm43xx_phy_write(bcm, 0x0815,
+				  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFB);
+	}
 	bcm43xx_phy_write(bcm, 0x0003,
 			  (bcm43xx_phy_read(bcm, 0x0003)
 			   & 0xFF9F) | 0x0040);
@@ -1143,8 +1149,10 @@ static void bcm43xx_calc_loopback_gain(s
 		}
 	}
 
-	bcm43xx_phy_write(bcm, 0x0814, backup_phy[4]);
-	bcm43xx_phy_write(bcm, 0x0815, backup_phy[5]);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(bcm, 0x0814, backup_phy[4]);
+		bcm43xx_phy_write(bcm, 0x0815, backup_phy[5]);
+	}
 	bcm43xx_phy_write(bcm, 0x005A, backup_phy[6]);
 	bcm43xx_phy_write(bcm, 0x0059, backup_phy[7]);
 	bcm43xx_phy_write(bcm, 0x0058, backup_phy[8]);
@@ -1193,24 +1201,23 @@ static void bcm43xx_phy_initg(struct bcm
 		bcm43xx_phy_write(bcm, 0x0811, 0x0000);
 		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
 	}
-	if (phy->rev >= 3) {
+	if (phy->rev > 5) {
 		bcm43xx_phy_write(bcm, 0x0811, 0x0400);
 		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
 	}
 	if (phy->rev >= 2 && phy->connected) {
 		tmp = bcm43xx_phy_read(bcm, 0x0400) & 0xFF;
-		if (tmp < 6) {
+		if (tmp ==3 || tmp == 5) {
 			bcm43xx_phy_write(bcm, 0x04C2, 0x1816);
 			bcm43xx_phy_write(bcm, 0x04C3, 0x8006);
-			if (tmp != 3) {
+			if (tmp == 5) {
 				bcm43xx_phy_write(bcm, 0x04CC,
 						  (bcm43xx_phy_read(bcm, 0x04CC)
 						   & 0x00FF) | 0x1F00);
 			}
 		}
-	}
-	if (phy->rev < 3 && phy->connected)
 		bcm43xx_phy_write(bcm, 0x047E, 0x0078);
+	}
 	if (radio->revision == 8) {
 		bcm43xx_phy_write(bcm, 0x0801, bcm43xx_phy_read(bcm, 0x0801) | 0x0080);
 		bcm43xx_phy_write(bcm, 0x043E, bcm43xx_phy_read(bcm, 0x043E) | 0x0004);
@@ -1237,7 +1244,7 @@ static void bcm43xx_phy_initg(struct bcm
 		if (phy->rev >= 6) {
 			bcm43xx_phy_write(bcm, 0x0036,
 					  (bcm43xx_phy_read(bcm, 0x0036)
-					   & 0xF000) | (radio->txctl2 << 12));
+					   & 0x0FFF) | (radio->txctl2 << 12));
 		}
 		if (bcm->sprom.boardflags & BCM43xx_BFL_PACTRL)
 			bcm43xx_phy_write(bcm, 0x002E, 0x8075);
@@ -1248,7 +1255,7 @@ static void bcm43xx_phy_initg(struct bcm
 		else
 			bcm43xx_phy_write(bcm, 0x002F, 0x0202);
 	}
-	if (phy->connected) {
+	if (phy->connected || phy->rev >= 2) {
 		bcm43xx_phy_lo_adjust(bcm, 0);
 		bcm43xx_phy_write(bcm, 0x080F, 0x8078);
 	}
@@ -1262,7 +1269,7 @@ static void bcm43xx_phy_initg(struct bcm
 		 */
 		bcm43xx_nrssi_hw_update(bcm, 0xFFFF);
 		bcm43xx_calc_nrssi_threshold(bcm);
-	} else if (phy->connected) {
+	} else if (phy->connected || phy->rev >= 2) {
 		if (radio->nrssi[0] == -1000) {
 			assert(radio->nrssi[1] == -1000);
 			bcm43xx_calc_nrssi_slope(bcm);
