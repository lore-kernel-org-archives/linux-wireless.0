Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:39350 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXDKQIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 12:08:43 -0400
Date: Wed, 11 Apr 2007 11:08:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev 1  PHYs
Message-ID: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On PPC architecture with phy->rev == 1, machine checks occur during
initialization of the "Extended G PHY registers". This problem was
also seen on bcm43xx-softmac, and was fixed by conditionally skipping
over certain reads/writes of these registers.  The same solution has been
applied here with testing by David Woodhouse.  Note: These modifications
are not found in the specifications, but are needed for PPC.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John and Michael,

This patch will apply to both the wireless-dev and the mb trees.

Larry

 bcm43xx_phy.c |   50 +++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
@@ -1362,7 +1362,7 @@ static void bcm43xx_phy_initb6(struct bc
 static void bcm43xx_calc_loopback_gain(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_phy *phy = &dev->phy;
-	u16 backup_phy[16];
+	u16 backup_phy[16] = {0};
 	u16 backup_radio[3];
 	u16 backup_bband;
 	u16 i, j, loop_i_max;
@@ -1373,8 +1373,10 @@ static void bcm43xx_calc_loopback_gain(s
 	backup_phy[1] = bcm43xx_phy_read(dev, BCM43xx_PHY_CCKBBANDCFG);
 	backup_phy[2] = bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVER);
 	backup_phy[3] = bcm43xx_phy_read(dev, BCM43xx_PHY_RFOVERVAL);
-	backup_phy[4] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER);
-	backup_phy[5] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL);
+	if (phy->rev != 1) {
+		backup_phy[4] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER);
+		backup_phy[5] = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL);
+	}
 	backup_phy[6] = bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x5A));
 	backup_phy[7] = bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x59));
 	backup_phy[8] = bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x58));
@@ -1402,14 +1404,16 @@ static void bcm43xx_calc_loopback_gain(s
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
+	if (phy->rev != 1) {
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
@@ -1426,10 +1430,12 @@ static void bcm43xx_calc_loopback_gain(s
 
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x0A),
 			  bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x0A)) | 0x2000);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0004);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
-			  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFB);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER) | 0x0004);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL,
+				  bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVERVAL) & 0xFFFB);
+	}
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x03),
 			  (bcm43xx_phy_read(dev, BCM43xx_PHY_BASE(0x03))
 			   & 0xFF9F) | 0x40);
@@ -1522,8 +1528,10 @@ exit_loop1:
 		trsw_rx = 0x18;
 exit_loop2:
 
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER, backup_phy[4]);
-	bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL, backup_phy[5]);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVER, backup_phy[4]);
+		bcm43xx_phy_write(dev, BCM43xx_PHY_ANALOGOVERVAL, backup_phy[5]);
+	}
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x5A), backup_phy[6]);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x59), backup_phy[7]);
 	bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x58), backup_phy[8]);
@@ -1576,7 +1584,7 @@ static void bcm43xx_phy_initg(struct bcm
 		bcm43xx_phy_write(dev, BCM43xx_PHY_RFOVER, 0x400);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, 0xC0);
 	}
-	if (phy->gmode) {
+	if (phy->gmode && phy->rev >= 2) {
 		tmp = bcm43xx_phy_read(dev, BCM43xx_PHY_VERSION_OFDM);
 		tmp &= BCM43xx_PHYVER_VERSION;
 		if (tmp == 3 || tmp == 5) {
@@ -1635,7 +1643,7 @@ static void bcm43xx_phy_initg(struct bcm
 		else
 			bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x2F), 0x202);
 	}
-	if (phy->gmode) {
+	if (phy->gmode && phy->rev != 1) {
 		bcm43xx_lo_adjust(dev);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_LO_MASK, 0x8078);
 	}
@@ -1649,8 +1657,8 @@ static void bcm43xx_phy_initg(struct bcm
 		 */
 		bcm43xx_nrssi_hw_update(dev, 0xFFFF);//FIXME?
 		bcm43xx_calc_nrssi_threshold(dev);
-	} else {
-		if (phy->gmode && phy->nrssi[0] == -1000) {
+	} else if (phy->gmode && phy->rev != 1) {
+		if (phy->nrssi[0] == -1000) {
 			assert(phy->nrssi[1] == -1000);
 			bcm43xx_calc_nrssi_slope(dev);
 		} else
