Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46554 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbXJNTqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 15:46:21 -0400
Message-ID: <47126836.5000906@openwrt.org> (sfid-20071014_204636_186040_E142AA77)
Date: Sun, 14 Oct 2007 21:04:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] Fix a null pointer check in ssb mipscore init
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a null pointer check in ssb mipscore init

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -171,20 +171,21 @@ u32 ssb_cpu_clock(struct ssb_mipscore *mcore)
 	return rate;
 }

 void ssb_mipscore_init(struct ssb_mipscore *mcore)
 {
-	struct ssb_bus *bus = mcore->dev->bus;
+	struct ssb_bus *bus;
 	struct ssb_device *dev;
 	unsigned long hz, ns;
 	unsigned int irq, i;

 	if (!mcore->dev)
 		return; /* We don't have a MIPS core */

 	ssb_dprintk(KERN_INFO PFX "Initializing MIPS core...\n");

+	bus = mcore->dev->bus;
 	hz = ssb_clockspeed(bus);
 	if (!hz)
 		hz = 100000000;
 	ns = 1000000000 / hz;


