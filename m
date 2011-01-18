Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4527 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab1ARVKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 16:10:24 -0500
Message-ID: <4D3601BA.8040907@canonical.com>
Date: Tue, 18 Jan 2011 14:10:18 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: stable@kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2.6.32.y] hostap_cs: fix sleeping function called from
 invalid context
References: <1295269524-4937-1-git-send-email-sgruszka@redhat.com> <4D35A87D.3020600@canonical.com> <20110118154305.GA2448@redhat.com>
In-Reply-To: <20110118154305.GA2448@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2011 08:43 AM, Stanislaw Gruszka wrote:
> On Tue, Jan 18, 2011 at 07:49:33AM -0700, Tim Gardner wrote:
>> Yes - I think this patch is correct. I didn't drill deep enough to
>> notice the GFP_KERNEL memory allocation. However, I think there is
>> still a problem with the interrupt handler which will only be
>> noticed if there is another active device on the same shared
>> interrupt. Shouldn't it return IRQ_NONE? See attached.
>
> I'm not sure. I think kernel could disable interrupt line when IRQ_NONE
> is returned, but line is not shared.
>

I believe it is a shared IRQ, but its been so long since I've worked 
with the PCMCIA version of the prism device that I can't remember for 
sure. The PCI flavor definitely requests a shared IRQ, and both PCI and 
PCMCIA use the same interrupt handler function.

> Generally hostap pcmcia initialization procedure does not look correct.
> It should be rahter rearranged to request irq when we are ready to
> receive it, like that:
>
>          ret = pcmcia_enable_device(link);
>          if (ret)
>                  goto failed;
>
>          dev->irq = link->irq;
>          dev->base_addr = link->resource[0]->start;
>
>          ret = pcmcia_request_irq(link, prism2_interrupt);
>          if (ret)
>                  goto failed;
>
> However I'm not sure if pcmcia_enable_device() does not require
> to have pcmcia_request_irq() before?
>

I don't know either, but this device is becoming rare enough that I'm 
not gonna lose any sleep over it.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
