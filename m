Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:34373 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752117AbYDFPFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 11:05:43 -0400
Date: Sun, 6 Apr 2008 17:05:07 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH] b43legacy: fix bcm4303 crash
Message-ID: <20080406170507.16992935@polimi.it> (sfid-20080406_160549_527515_284C2CCE)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes an hard crash which happened upon driver loading on bcm4303 rev.
2 devices.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
John, this is for 2.6.26.
---
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index e123719..4bc0e8b 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1101,6 +1101,12 @@ int ssb_bus_may_powerdown(struct ssb_bus *bus)
 		goto out;
 
 	cc = &bus->chipco;
+
+	if (!cc->dev)
+		goto out;
+	if (cc->dev->id.revision < 5)
+		goto out;
+
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
 	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
 	if (err)


--
Ciao
Stefano
