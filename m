Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1673 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1AROtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 09:49:39 -0500
Message-ID: <4D35A87D.3020600@canonical.com>
Date: Tue, 18 Jan 2011 07:49:33 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: stable@kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.32.y] hostap_cs: fix sleeping function called from
 invalid context
References: <1295269524-4937-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1295269524-4937-1-git-send-email-sgruszka@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010209070803070307000301"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010209070803070307000301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/17/2011 06:05 AM, Stanislaw Gruszka wrote:
> commit 4e5518ca53be29c1ec3c00089c97bef36bfed515 upstream.
>
> pcmcia_request_irq() and pcmcia_enable_device() are intended
> to be called from process context (first function allocate memory
> with GFP_KERNEL, second take a mutex). We can not take spin lock
> and call them.
>
> It's safe to move spin lock after pcmcia_enable_device() as we
> still hold off IRQ until dev->base_addr is 0 and driver will
> not proceed with interrupts when is not ready.
>
> Patch resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=643758
>
> Reported-and-tested-by: rbugz@biobind.com
> Signed-off-by: Stanislaw Gruszka<sgruszka@redhat.com>
> ---
>   drivers/net/wireless/hostap/hostap_cs.c |   10 ++--------
>   1 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
> index b4ff1dc..6992f8f 100644
> --- a/drivers/net/wireless/hostap/hostap_cs.c
> +++ b/drivers/net/wireless/hostap/hostap_cs.c
> @@ -662,12 +662,6 @@ static int prism2_config(struct pcmcia_device *link)
>   	link->dev_node =&hw_priv->node;
>
>   	/*
> -	 * Make sure the IRQ handler cannot proceed until at least
> -	 * dev->base_addr is initialized.
> -	 */
> -	spin_lock_irqsave(&local->irq_init_lock, flags);
> -
> -	/*
>   	 * Allocate an interrupt line.  Note that this does not assign a
>   	 * handler to the interrupt, unless the 'Handler' member of the
>   	 * irq structure is initialized.
> @@ -690,9 +684,10 @@ static int prism2_config(struct pcmcia_device *link)
>   	CS_CHECK(RequestConfiguration,
>   		 pcmcia_request_configuration(link,&link->conf));
>
> +	/* IRQ handler cannot proceed until at dev->base_addr is initialized */
> +	spin_lock_irqsave(&local->irq_init_lock, flags);
>   	dev->irq = link->irq.AssignedIRQ;
>   	dev->base_addr = link->io.BasePort1;
> -
>   	spin_unlock_irqrestore(&local->irq_init_lock, flags);
>
>   	/* Finally, report what we've done */
> @@ -724,7 +719,6 @@ static int prism2_config(struct pcmcia_device *link)
>   	return ret;
>
>    cs_failed:
> -	spin_unlock_irqrestore(&local->irq_init_lock, flags);
>   	cs_error(link, last_fn, last_ret);
>
>    failed:

Yes - I think this patch is correct. I didn't drill deep enough to 
notice the GFP_KERNEL memory allocation. However, I think there is still 
a problem with the interrupt handler which will only be noticed if there 
is another active device on the same shared interrupt. Shouldn't it 
return IRQ_NONE? See attached.

rtg

-- 
Tim Gardner tim.gardner@canonical.com

--------------010209070803070307000301
Content-Type: text/x-patch;
 name="0001-hostap-Return-IRQ_NONE-if-the-device-has-not-been-co.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-hostap-Return-IRQ_NONE-if-the-device-has-not-been-co.pa";
 filename*1="tch"

>From 638d3ea93e2a9cccb860d9e31c84e5d3a3eb38bd Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 18 Jan 2011 07:47:45 -0700
Subject: [PATCH] 2.6.32.y, hostap: Return IRQ_NONE if the device has not been configured

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/hostap/hostap_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 8721850..789a503 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2624,7 +2624,7 @@ static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 			printk(KERN_DEBUG "%s: Interrupt, but dev not configured\n",
 			       dev->name);
 		}
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 	}
 
 	iface = netdev_priv(dev);
-- 
1.7.0.4


--------------010209070803070307000301--
