Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1AQNFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 08:05:32 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.32.y] hostap_cs: fix sleeping function called from invalid context
Date: Mon, 17 Jan 2011 14:05:24 +0100
Message-Id: <1295269524-4937-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 4e5518ca53be29c1ec3c00089c97bef36bfed515 upstream.

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
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/hostap/hostap_cs.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index b4ff1dc..6992f8f 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -662,12 +662,6 @@ static int prism2_config(struct pcmcia_device *link)
 	link->dev_node = &hw_priv->node;
 
 	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
-	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
-	/*
 	 * Allocate an interrupt line.  Note that this does not assign a
 	 * handler to the interrupt, unless the 'Handler' member of the
 	 * irq structure is initialized.
@@ -690,9 +684,10 @@ static int prism2_config(struct pcmcia_device *link)
 	CS_CHECK(RequestConfiguration,
 		 pcmcia_request_configuration(link, &link->conf));
 
+	/* IRQ handler cannot proceed until at dev->base_addr is initialized */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	/* Finally, report what we've done */
@@ -724,7 +719,6 @@ static int prism2_config(struct pcmcia_device *link)
 	return ret;
 
  cs_failed:
-	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 	cs_error(link, last_fn, last_ret);
 
  failed:
-- 
1.7.1

