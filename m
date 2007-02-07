Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:65534 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161AbXBGDcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 22:32:23 -0500
Date: Tue, 06 Feb 2007 21:31:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix incorrect definition of PHY revision
Message-ID: <45c94821.qjljSnUzfws7mU7T%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a typographical error in the spefications that interchange the PHY version
and revision. Fixing this error makes all BCM43xx varieties work at full CCCK rates.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---

John,

This patch should be put into wireless-2.6 and into 'upstream' as soon as possible.
I will be sending it to stable for inclusion in 2.6.20.1, and whatever other kernels
are still being maintained by -stable.

Larry
---
 
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3704,9 +3704,9 @@ static int bcm43xx_read_phyinfo(struct b
 
 	value = bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_VER);
 
-	phy_version = (value & 0xF000) >> 12;
+	phy_rev = (value & 0xF000) >> 12;
 	phy_type = (value & 0x0F00) >> 8;
-	phy_rev = (value & 0x000F);
+	phy_version = (value & 0x000F);
 
 	dprintk(KERN_INFO PFX "Detected PHY: Version: %x, Type %x, Revision %x\n",
 		phy_version, phy_type, phy_rev);

===

