Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbZKSUkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 15:40:41 -0500
Date: Thu, 19 Nov 2009 14:40:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] ssb: Unconditionally log results of core scans
Message-ID: <4b05ad4e.6wyYtH5Wba7FJeft%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At present, the results of an SSB core scan are only logged when
CONFIG_SSB_DEBUG is "y". As this may not be set in a distro kernel,
it is difficult interpret many problems posted in bug reports or in
help forums.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - Change from KERN_INFO to KERN_DEBUG

Index: wireless-testing/drivers/ssb/scan.c
===================================================================
--- wireless-testing.orig/drivers/ssb/scan.c
+++ wireless-testing/drivers/ssb/scan.c
@@ -354,7 +354,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		dev->bus = bus;
 		dev->ops = bus->ops;
 
-		ssb_dprintk(KERN_INFO PFX
+		printk(KERN_DEBUG PFX
 			    "Core %d found: %s "
 			    "(cc 0x%03X, rev 0x%02X, vendor 0x%04X)\n",
 			    i, ssb_core_name(dev->id.coreid),
