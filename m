Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1ARPn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 10:43:27 -0500
Date: Tue, 18 Jan 2011 16:43:05 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org, Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2.6.32.y] hostap_cs: fix sleeping function called from
 invalid context
Message-ID: <20110118154305.GA2448@redhat.com>
References: <1295269524-4937-1-git-send-email-sgruszka@redhat.com>
 <4D35A87D.3020600@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D35A87D.3020600@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 07:49:33AM -0700, Tim Gardner wrote:
> Yes - I think this patch is correct. I didn't drill deep enough to
> notice the GFP_KERNEL memory allocation. However, I think there is
> still a problem with the interrupt handler which will only be
> noticed if there is another active device on the same shared
> interrupt. Shouldn't it return IRQ_NONE? See attached.

I'm not sure. I think kernel could disable interrupt line when IRQ_NONE
is returned, but line is not shared.

Generally hostap pcmcia initialization procedure does not look correct.
It should be rahter rearranged to request irq when we are ready to
receive it, like that:

        ret = pcmcia_enable_device(link);
        if (ret)
                goto failed;

        dev->irq = link->irq;
        dev->base_addr = link->resource[0]->start;

        ret = pcmcia_request_irq(link, prism2_interrupt);
        if (ret)
                goto failed;

However I'm not sure if pcmcia_enable_device() does not require
to have pcmcia_request_irq() before?

Stanislaw

