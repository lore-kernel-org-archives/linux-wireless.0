Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXKIW4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 17:56:12 -0500
Date: Fri, 09 Nov 2007 16:56:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] b44: Convert to use of the new SPROM structure
Message-ID: <4734e58a.3cN0AKWadrMywLAZ%Larry.Finger@lwfinger.net> (sfid-20071109_225617_967121_C33F0B3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 3 of 6.

The b44 driver is changed to use the new SPROM data structure.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/b44.c
===================================================================
--- wireless-2.6.orig/drivers/net/b44.c
+++ wireless-2.6/drivers/net/b44.c
@@ -2060,11 +2060,11 @@ static int __devinit b44_get_invariants(
 
 	if (sdev->bus->bustype == SSB_BUSTYPE_SSB &&
 	    instance > 1) {
-		addr = sdev->bus->sprom.r1.et1mac;
-		bp->phy_addr = sdev->bus->sprom.r1.et1phyaddr;
+		addr = sdev->bus->sprom.et1mac;
+		bp->phy_addr = sdev->bus->sprom.et1phyaddr;
 	} else {
-		addr = sdev->bus->sprom.r1.et0mac;
-		bp->phy_addr = sdev->bus->sprom.r1.et0phyaddr;
+		addr = sdev->bus->sprom.et0mac;
+		bp->phy_addr = sdev->bus->sprom.et0phyaddr;
 	}
 	memcpy(bp->dev->dev_addr, addr, 6);
 
