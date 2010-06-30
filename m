Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0F3XcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 19:32:08 -0400
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
From: reinette chatre <reinette.chatre@intel.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C296F44.9050000@gmail.com>
References: <4C198EF0.5080807@gmail.com>
	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>
	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com>
	 <1277401731.25793.2391.camel@rchatre-DESK>  <4C24D926.7010806@gmail.com>
	 <1277492229.13673.1297.camel@rchatre-DESK>  <4C278704.5040604@gmail.com>
	 <1277742425.13673.1376.camel@rchatre-DESK>  <4C28D552.30000@gmail.com>
	 <1277757563.4197.11.camel@rchatre-DESK>  <4C296F44.9050000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 16:32:05 -0700
Message-ID: <1277940725.4197.86.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-28 at 20:57 -0700, Richard Farina wrote:
> [ 3091.463559] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 21 free buffers remaining.
> [ 3091.534626] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 0 free buffers remaining.
> [ 3593.179843] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 1 free buffers remaining.
> [ 3593.307837] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 26 free buffers remaining.
> [ 4091.542698] net_ratelimit: 34 callbacks suppressed
> [ 4091.542702] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 25 free buffers remaining.
> [ 4091.542724] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 3 free buffers remaining.
> [ 4091.555285] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 26 free buffers remaining.
> [ 4091.555305] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 0 free buffers remaining.
> [ 4258.724351] net_ratelimit: 2073 callbacks suppressed
> [ 4258.724372] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 0 free buffers remaining.
> [ 4258.753286] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 31 free buffers remaining.
> [ 4258.753309] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 2 free buffers remaining.
> [ 4258.774133] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 28 free buffers remaining.
> [ 5165.260524] net_ratelimit: 21 callbacks suppressed
> [ 5166.400305] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 4 free buffers remaining.
> [ 5167.126059] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 13 free buffers remaining.
> [ 5454.561708] net_ratelimit: 4 callbacks suppressed
> [ 5455.245019] iwlagn 0000:02:00.0: Failed to alloc_pages with 
> GFP_ATOMIC. Only 1 free buffers remaining.
> 
> 
> I'd certainly list it as improved as it hardly freezes and those aren't 
> kernel oops.

Some good news is always welcome.

>   However it should be noted that this test didn't seem to 
> have nearly the same speed as the previous test (which may well be due 
> to my internet connection or any number of things having nothing to do 
> with this patch). Point is, I'd definately like to get a faster test it 
> to see if it explodes.

I do not like the idea that this is making your connection slower
though ... this could be because we are not more likely to attempt
memory allocation when there is still a large number of buffers left ...
so we do memory allocation more (too?) often.

>   Assuming it doesn't, how can I help you find out 
> why it keeps running out of buffers? I'm guessing  this isn't expected 
> behavior...

Well, the good news seems to be that your system is not running out of
memory completely ... it is just that the memory available to atomic
allocations is not enough to satisfy all requests. This really sounds
like https://bugzilla.kernel.org/show_bug.cgi?id=14141 , which has
unfortunately not been resolved yet.

Since the patch below appears to be the one making your system
slower ... could you modify the patch to set RX_LOW_WATERMARK to 64? I
know it is what we had before, but hopefully that together with the the
other changes in this patch will help to make system faster as well as
less noisy.

Thank you

Reinette


> Thanks,
> Rick Farina
> 
> > >From 65c459c35332c7039cc84a980e6e04118ba81c04 Mon Sep 17 00:00:00 2001
> > From: Reinette Chatre <reinette.chatre@intel.com>
> > Date: Thu, 24 Jun 2010 10:48:59 -0700
> > Subject: [PATCH] increase low watermark
> >
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++--
> >  drivers/net/wireless/iwlwifi/iwl-fh.h      |    2 +-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> > index 0f292a2..2815ee7 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> > @@ -613,7 +613,8 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
> >  		}
> >  		spin_unlock_irqrestore(&rxq->lock, flags);
> >  
> > -		if (rxq->free_count > RX_LOW_WATERMARK)
> > +		if ((priority == GFP_ATOMIC) ||
> > +		    (rxq->free_count > RX_LOW_WATERMARK / 4))
> >  			gfp_mask |= __GFP_NOWARN;
> >  
> >  		if (priv->hw_params.rx_page_order > 0)
> > @@ -627,7 +628,7 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
> >  					       "order: %d\n",
> >  					       priv->hw_params.rx_page_order);
> >  
> > -			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
> > +			if ((rxq->free_count <= RX_LOW_WATERMARK / 4) &&
> >  			    net_ratelimit())
> >  				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
> >  					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
> > index 113c366..431bc58 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-fh.h
> > +++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
> > @@ -426,7 +426,7 @@
> >   * RX related structures and functions
> >   */
> >  #define RX_FREE_BUFFERS 64
> > -#define RX_LOW_WATERMARK 8
> > +#define RX_LOW_WATERMARK 128
> >  
> >  /* Size of one Rx buffer in host DRAM */
> >  #define IWL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
> >   
> 


