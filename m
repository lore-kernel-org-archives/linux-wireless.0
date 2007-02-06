Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49845 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbXBFUe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 15:34:27 -0500
Message-ID: <45C8E64B.1050605@lwfinger.net>
Date: Tue, 06 Feb 2007 14:34:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: RFT bcm43xx: Really _GOOD_ news
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have really _GOOD_ news!!!!! While reviewing the latest changes in the V4 specs, I found an
interchange of the PHY version and PHY revision fields, relative to the current V3 specs. Of the
three cards that I have, the 4306 had the same value for the PHY version and revision. In addition,
it was the only card of the 3 thaw would work at 11Mbs. A light went on!

After installing the patch listed below, both my 4318 and my 4311 will now run at 11Mbs. From tests
with iperf, I now get rates of 6.1 - 6.5 Mbs from all three.

Larry


==========

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3707,9 +3707,9 @@ static int bcm43xx_read_phyinfo(struct b

 	value = bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_VER);

-	phy_version = (value & 0xF000) >> 12;
+	phy_rev = (value & 0xF000) >> 12;
 	phy_type = (value & 0x0F00) >> 8;
-	phy_rev = (value & 0x000F);
+	phy_version = (value & 0x000F);

 	dprintk(KERN_INFO PFX "Detected PHY: Version: %x, Type %x, Revision %x\n",
 		phy_version, phy_type, phy_rev);


