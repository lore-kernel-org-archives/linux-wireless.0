Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:43839 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992664AbXCBRbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 12:31:14 -0500
Date: Fri, 02 Mar 2007 11:30:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
Message-ID: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was an error in the B5PHY init specifications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is meant for wireless-2.6, 'upstream', and 'upstream-fixes'.

Larry

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -806,7 +806,7 @@ static void bcm43xx_phy_initb5(struct bc
 	/* Force to channel 7, even if not supported. */
 	bcm43xx_radio_selectchannel(bcm, 7, 0);
 
-	if (radio->version != 0x2050) {
+	if (radio->version == 0x2050) {
 		bcm43xx_radio_write16(bcm, 0x0075, 0x0080);
 		bcm43xx_radio_write16(bcm, 0x0079, 0x0081);
 	}
