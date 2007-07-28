Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:44168 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225AbXG1Dg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 23:36:28 -0400
Date: Fri, 27 Jul 2007 22:36:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: bcm43xx-mac80211: a fix for the shared interrupt problem
Message-ID: <46aab9a4.pmEWFfaWaaFDLvZd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I was in the right area with my previous fix to the "irq 11: nobody cared"
message. I think for shared interrupts, skipping out if the status is not
BCM43xx_STAT_STARTED is too severe. I added a message printing out the status
whenever it skipped out, and found many thousands of interrupts with the
status equal to BCM43xx_STAT_INITIALIZED. The patch below makes the necessary
change and modifies a couple of asserts that depend on it.

This patch has been tested on BCM4306 and BCM4318 with shared interrupts,
and BCM4311 without.

Thanks,

Larry
----


Index: wireless-mb/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-mb.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-mb/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -1374,7 +1374,7 @@ static void bcm43xx_interrupt_tasklet(st
 
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 
-	assert(bcm43xx_status(dev) == BCM43xx_STAT_STARTED);
+	assert(bcm43xx_status(dev) >= BCM43xx_STAT_INITIALIZED);
 
 	reason = dev->irq_reason;
 	for (i = 0; i < ARRAY_SIZE(dma_reason); i++) {
@@ -1512,7 +1512,7 @@ static irqreturn_t bcm43xx_interrupt_han
 
 	spin_lock(&dev->wl->irq_lock);
 
-	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED)
+	if (bcm43xx_status(dev) < BCM43xx_STAT_INITIALIZED)
 		goto out;
 	reason = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
 	if (reason == 0xffffffff) /* shared IRQ */
@@ -1522,7 +1522,7 @@ static irqreturn_t bcm43xx_interrupt_han
 	if (!reason)
 		goto out;
 
-	assert(bcm43xx_status(dev) == BCM43xx_STAT_STARTED);
+	assert(bcm43xx_status(dev) >= BCM43xx_STAT_INITIALIZED);
 
 	dev->dma_reason[0] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA0_REASON)
 			     & 0x0001DC00;
