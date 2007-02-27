Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:33856 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXB0Vgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 16:36:45 -0500
Date: Tue, 27 Feb 2007 15:35:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix errors in specs to code translation in B6PHY init
Message-ID: <45e4a43f.BEt7jx5dMLQiM3wz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are three errors in the transcription of the latest revision to the
B6PHY init specifications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch should be applied to wireless-2.6 and sent upstream to 2.6.21-rcX.

Larry

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -859,6 +859,9 @@ static void bcm43xx_phy_initb6(struct bc
 		bcm43xx_radio_write16(bcm, 0x005D, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x005E, 0x0088);
 		bcm43xx_radio_write16(bcm, 0x007D, 0x0088);
+		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
+				bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
+				| 0x00000200);
 	}
 	if (radio->revision == 8) {
 		bcm43xx_radio_write16(bcm, 0x0051, 0x0000);
@@ -941,7 +944,8 @@ static void bcm43xx_phy_initb6(struct bc
 	bcm43xx_phy_write(bcm, 0x0038, 0x0668);
 	bcm43xx_radio_set_txpower_bg(bcm, 0xFFFF, 0xFFFF, 0xFFFF);
 	if (radio->revision <= 5)
-		bcm43xx_phy_write(bcm, 0x005D, bcm43xx_phy_read(bcm, 0x005D) | 0x0003);
+		bcm43xx_phy_write(bcm, 0x005D, (bcm43xx_phy_read(bcm, 0x005D)
+			          & 0xFF80) | 0x0003);
 	if (radio->revision <= 2)
 		bcm43xx_radio_write16(bcm, 0x005D, 0x000D);
 	
@@ -958,7 +962,7 @@ static void bcm43xx_phy_initb6(struct bc
 		bcm43xx_phy_write(bcm, 0x0016, 0x0410);
 		bcm43xx_phy_write(bcm, 0x0017, 0x0820);
 		bcm43xx_phy_write(bcm, 0x0062, 0x0007);
-		(void) bcm43xx_radio_calibrationvalue(bcm);
+		bcm43xx_radio_init2050(bcm);
 		bcm43xx_phy_lo_g_measure(bcm);
 		if (bcm->sprom.boardflags & BCM43xx_BFL_RSSI) {
 			bcm43xx_calc_nrssi_slope(bcm);
