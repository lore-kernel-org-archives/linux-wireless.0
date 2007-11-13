Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbXKMSZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 13:25:19 -0500
From: Oliver Neukum <oneukum@suse.de>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: [PATCH]iwlwifi not correctly dealing with hotunplug
MIME-Version: 1.0
Date: Tue, 13 Nov 2007 19:26:53 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711131926.53732.oneukum@suse.de> (sfid-20071113_182525_069813_860862FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It makes no sense to enable interrupts if a device has been unplugged.
In addition if in doubt IRQ_HANDLED should be returned.

Signed-off-by: Oliver Neukum <oneukum@suse.de>

	Regards
		Oliver

----

--- linux-2.6.24-rc1/drivers/net/wireless/iwlwifi/iwl3945-base.c.alt	2007-11-13 12:23:07.000000000 +0100
+++ linux-2.6.24-rc1/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-13 12:26:00.000000000 +0100
@@ -4850,7 +4850,7 @@ static irqreturn_t iwl_isr(int irq, void
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared */
 		IWL_WARNING("HARDWARE GONE?? INTA == 0x%080x\n", inta);
-		goto none;
+		goto unplugged;
 	}
 
 	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
@@ -4858,6 +4858,7 @@ static irqreturn_t iwl_isr(int irq, void
 
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	tasklet_schedule(&priv->irq_tasklet);
+unplugged:
 	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
