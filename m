Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbXKFTPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:15:32 -0500
Date: Tue, 06 Nov 2007 13:15:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 3 of 6] b44: Convert to use of the new SPROM structure
Message-ID: <4730bd53.yVvid0NgFQXoiJkE%Larry.Finger@lwfinger.net> (sfid-20071106_191533_974784_BF1BD5E1)
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
+		addr = sdev->bus->sprom.data.et1mac;
+		bp->phy_addr = sdev->bus->sprom.data.et1phyaddr;
 	} else {
-		addr = sdev->bus->sprom.r1.et0mac;
-		bp->phy_addr = sdev->bus->sprom.r1.et0phyaddr;
+		addr = sdev->bus->sprom.data.et0mac;
+		bp->phy_addr = sdev->bus->sprom.data.et0phyaddr;
 	}
 	memcpy(bp->dev->dev_addr, addr, 6);
 
