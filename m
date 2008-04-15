Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:40665 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbYDOTH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 15:07:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add fastpath to b43_mac_suspend()
Date: Tue, 15 Apr 2008 21:05:56 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804152105.57404.mb@bu3sch.de> (sfid-20080415_200733_360672_3B7289D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a fastpath for the common workloads to the
MAC suspend flushing.
In common workloads the FIFO flush will take between 100 and
200 microseconds. So we want to avoid calling msleep() in the
common case, as it will waste over 800 microseconds + scheduler
overhead.

This fastpath will hit in workloads where only small chunks
of data are transmitted (downloading a file) or when a TX rate bigger
or equal to 24MBit/s is used when transmitting lots of stuff (iperf).
So in the commonly used workloads it will basically always hit.

In case the fastpath is not hit, there's no real performance or latency
disadvantage from that.

And yes, I measured this. So this is not one of these
bad Programmer Likeliness Assumptions that are always wrong. ;)

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26
Stefano, you may port this, if you like to.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-15 19:52:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-15 20:46:36.000000000 +0200
@@ -2340,12 +2340,21 @@ static void b43_mac_suspend(struct b43_w
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
 		b43_write32(dev, B43_MMIO_MACCTL,
 			    b43_read32(dev, B43_MMIO_MACCTL)
 			    & ~B43_MACCTL_ENABLED);
 		/* force pci to flush the write */
 		b43_read32(dev, B43_MMIO_MACCTL);
+		/* Finally wait for the microcode to flush the fifos. */
+		for (i = 35; i; i--) {
+			tmp = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
+			if (tmp & B43_IRQ_MAC_SUSPENDED) {
+				goto out;
+			}
+			udelay(10);
+		}
+		/* Hm, it seems this will take some time. Use msleep(). */
 		for (i = 40; i; i--) {
 			tmp = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 			if (tmp & B43_IRQ_MAC_SUSPENDED)
 				goto out;
 			msleep(1);
 		}
