Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab1AJL4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 06:56:13 -0500
Date: Mon, 10 Jan 2011 12:56:05 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	Tim Gardner <tim.gardner@canonical.com>, stable@kernel.org
Subject: [PATCH] hostap_cs: fix sleeping function called from invalid context
Message-ID: <20110110115551.GA3227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pcmcia_request_irq() and pcmcia_enable_device() are intended
to be called from process context (first function allocate memory
with GFP_KERNEL, second take a mutex). We can not take spin lock
and call them.

It's safe to move spin lock after pcmcia_enable_device() as we
still hold off IRQ until dev->base_addr is 0 and driver will
not proceed with interrupts when is not ready.

Patch resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=643758

Reported-and-tested-by: rbugz@biobind.com
Cc: stable@kernel.org  # 2.6.34+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Stable note: patch does not apply on 2.6.34 and 2.6.35,
I will post separate patches when this one gets mainline

 drivers/net/wireless/hostap/hostap_cs.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index bd8a413..2176ede 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -518,22 +518,21 @@ static int prism2_config(struct pcmcia_device *link)
 	hw_priv->link = link;
 
 	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
+	 * We enable IRQ here, but IRQ handler will not proceed
+	 * until dev->base_addr is set below. This protect us from
+	 * receive interrupts when driver is not initialized.
 	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
 	ret = pcmcia_request_irq(link, prism2_interrupt);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
 	ret = pcmcia_enable_device(link);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq;
 	dev->base_addr = link->resource[0]->start;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	local->shutdown = 0;
@@ -546,8 +545,6 @@ static int prism2_config(struct pcmcia_device *link)
 
 	return ret;
 
- failed_unlock:
-	spin_unlock_irqrestore(&local->irq_init_lock, flags);
  failed:
 	kfree(hw_priv);
 	prism2_release((u_long)link);
-- 
1.7.1

