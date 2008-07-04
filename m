Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57659 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbYGDVpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 17:45:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb-pcicore: Fix IRQ-vector init on embedded devices
Date: Fri, 4 Jul 2008 23:44:37 +0200
Cc: Steve Brown <sbrown@cortland.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807042344.38034.mb@bu3sch.de> (sfid-20080704_234556_710104_58A79824)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On embedded devices we must not route the interrupts through
the PCI core, if our host-bus is not PCI.

Reported-by: Steve Brown <sbrown@cortland.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, If still possible, please queue for 2.6.26.


Index: wireless-testing/drivers/ssb/driver_pcicore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_pcicore.c	2008-06-10 13:58:23.000000000 +0200
+++ wireless-testing/drivers/ssb/driver_pcicore.c	2008-07-04 23:16:02.000000000 +0200
@@ -537,6 +537,13 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 	int err = 0;
 	u32 tmp;
 
+	if (dev->bus->bustype != SSB_BUSTYPE_PCI) {
+		/* This SSB device is not on a PCI host-bus. So the IRQs are
+		 * not routed through the PCI core.
+		 * So we must not enable routing through the PCI core. */
+		goto out;
+	}
+
 	if (!pdev)
 		goto out;
 	bus = pdev->bus;

-- 
Greetings Michael.
