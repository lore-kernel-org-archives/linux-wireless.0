Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46165 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZJBTwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 15:52:12 -0400
Date: Fri, 2 Oct 2009 20:52:04 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at drivers/net/wireless/b43/main.c:3923
 b43_wireless_core_stop+0x1c8/0x1d0()
Message-ID: <20091002195204.GA2779@plato.andrewprice.me.uk>
References: <20091002193042.GA3719@plato.andrewprice.me.uk>
 <200910022138.04296.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910022138.04296.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2009 at 09:38:02PM +0200, Michael Buesch wrote:
> On Friday 02 October 2009 21:30:43 Andrew Price wrote:
> > Hi,
> > 
> > I'm seeing this warning when I unplug my wireless card while the
> > network interface is still up. It doesn't seem to cause any permanent
> > damage - when I plug it back in I can use the wireless card again.
> > 
> > I'm using today's mainline kernel as of 0efe5e32 with Michael Buesch's
> > "b43: Don't use struct wldev after detach" patch added, though I don't
> > believe that patch is the culprit because the warning triggers without
> > it too.
> > 
> > The line it refers to is:
> >     B43_WARN_ON(b43_read32(dev, B43_MMIO_GEN_IRQ_MASK));
> 
> This should fix it

It does indeed,

Tested-by: Andrew Price <andy@andrewprice.me.uk>

(for this and the "b43: Don't use struct wldev after detach" patch).

Thanks.

> 
> ---
>  drivers/net/wireless/b43/main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -3874,6 +3874,7 @@ static struct b43_wldev * b43_wireless_c
>  {
>  	struct b43_wl *wl = dev->wl;
>  	struct b43_wldev *orig_dev;
> +	u32 mask;
>  
>  redo:
>  	if (!dev || b43_status(dev) < B43_STAT_STARTED)
> @@ -3920,7 +3921,8 @@ redo:
>  			goto redo;
>  		return dev;
>  	}
> -	B43_WARN_ON(b43_read32(dev, B43_MMIO_GEN_IRQ_MASK));
> +	mask = b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);
> +	B43_WARN_ON(mask != 0xFFFFFFFF && mask);
>  
>  	/* Drain the TX queue */
>  	while (skb_queue_len(&wl->tx_queue))
> 
> 
> 
> -- 
> Greetings, Michael.
