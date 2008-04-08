Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51820 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYDHI3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 04:29:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb-pcicore: Fix IRQ TPS flag handling
Date: Tue, 8 Apr 2008 10:28:24 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804081028.25238.mb@bu3sch.de> (sfid-20080408_092914_119278_4F10DB35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <larry.finger@lwfinger.net>

This fixes the TPS flag handling for the SSB pcicore driver.
This fixes interrupts on some devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is an important bugfix for 2.6.25.


Index: wireless-testing/drivers/ssb/driver_pcicore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_pcicore.c	2008-04-08 00:39:12.000000000 +0200
+++ wireless-testing/drivers/ssb/driver_pcicore.c	2008-04-08 00:41:11.000000000 +0200
@@ -566,13 +566,13 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 			/* Workaround: On the BCM44XX the BPFLAG routing
 			 * bit is wrong. Use a hardcoded constant. */
 			intvec |= 0x00000002;
 		} else {
 			tmp = ssb_read32(dev, SSB_TPSFLAG);
 			tmp &= SSB_TPSFLAG_BPFLAG;
-			intvec |= tmp;
+			intvec |= (1 << tmp);
 		}
 		ssb_write32(pdev, SSB_INTVEC, intvec);
 	}
 
 	/* Setup PCIcore operation. */
 	if (pc->setup_done)
