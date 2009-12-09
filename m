Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbZLITZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 14:25:55 -0500
Date: Wed, 09 Dec 2009 13:25:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Remove reset after fatal DMA error
Message-ID: <4b1ff9c4.iIvEkDMkYFL2BtFk%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As shown in Kernel Bugzilla #14761, doing a controller restart after a
fatal DMA error does not accomplish anything other than consume the CPU
on an affected system. Accordingly, substitute a meaningful message for
the restart.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>        [2.6.32]
---

John,

If possible, this patch should be applied to 2.6.33. I made the message
be two parts as the second will be replaced once the patch to change PIO
from a compile-time to a run-time option is completed and tested.
It is working here, but needs further testing. I expected the performance
to be degraded, but it seems to be too much here.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -1784,7 +1784,10 @@ static void b43_do_interrupt_thread(stru
 			       dma_reason[0], dma_reason[1],
 			       dma_reason[2], dma_reason[3],
 			       dma_reason[4], dma_reason[5]);
-			b43_controller_restart(dev, "DMA error");
+			b43err(dev->wl, "This device does not support DMA "
+			       "on your system. Please use PIO instead.\n");
+			b43err(dev->wl, "CONFIG_B43_FORCE_PIO must be set in "
+			       "your kernel configuration.\n");
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
