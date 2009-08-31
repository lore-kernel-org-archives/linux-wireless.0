Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2569 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZHaCSs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 22:18:48 -0400
To: j@w1.fi
Subject: [PATCH] wireless: hostap, fix oops due to early probing interrupt
Cc: linux-wireless@vger.kernel.org
Message-Id: <20090831021841.AE8FCF88F4@sepang.rtg.net>
Date: Sun, 30 Aug 2009 20:18:41 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni,

Did this ever get sent to you?

rtg

---------------------------------
>From a72eaafae9186632add4ed01a340b4f1b39cc672 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Wed, 19 Aug 2009 15:39:21 +0100
Subject: [PATCH] wireless: hostap, fix oops due to early probing interrupt

BugLink: https://bugs.launchpad.net/ubuntu/+bug/254837

Spurious shared interrupts or early probing interrupts can cause the
hostap interrupt handler to oops before the driver has fully configured
the IO base port addresses. In some cases the oops can be because
the hardware shares an interrupt line, on other cases it is due to a
race condition between probing for the hardware and configuring
the IO base port. The latter occurs because the probing is required to
determin the hardware port address which is only determined when the probe
can interrupt the hardware (catch 22).

This patch catches this pre-configured condition to avoid the oops.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/net/wireless/hostap/hostap_hw.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index d4d857e..0212ee3 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2628,6 +2628,15 @@ static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 	int events = 0;
 	u16 ev;
 
+	/* Detect early interrupt before driver is fully configued */
+	if (!dev->base_addr) {
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: Interrupt, but dev not configured\n",
+			       dev->name);
+		}
+		return IRQ_HANDLED;
+	}
+
 	iface = netdev_priv(dev);
 	local = iface->local;
 
-- 
1.6.2.4

