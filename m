Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:57559 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965500AbXBGGCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 01:02:52 -0500
Message-ID: <45C96B8A.8010000@lwfinger.net>
Date: Wed, 07 Feb 2007 00:02:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: RFT: The real fix for BCM4311 and BCM4312
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch I sent out earlier was wrong; however, it provided a clue as to what was wrong in the
specs and in the code. As it turned out, the mistake I made earlier only affected 4 places in the
code and it was easy to test them in turn. According to Murphy's law, the wrong one was the last one
tested. If you don't know about Murphy, his law can be paraphrased as "Anything that can go wrong will".

The patch below will only affect cards with PHY revision 8, which I think are only BCM4311 and
BCM4312. At least those are the only ones in the database.

Sorry about the false step earlier, but I was so excited to get the 4311 working that I screwed up
the test of the 4318.

Larry

==============



Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -1225,7 +1225,7 @@ static void bcm43xx_phy_initg(struct bcm
 	}
 	if (phy->rev < 3 && phy->connected)
 		bcm43xx_phy_write(bcm, 0x047E, 0x0078);
-	if (phy->rev >= 6 && phy->rev <= 8) {
+	if (phy->rev >= 6 && phy->rev < 8) {
 		bcm43xx_phy_write(bcm, 0x0801, bcm43xx_phy_read(bcm, 0x0801) | 0x0080);
 		bcm43xx_phy_write(bcm, 0x043E, bcm43xx_phy_read(bcm, 0x043E) | 0x0004);
 	}


