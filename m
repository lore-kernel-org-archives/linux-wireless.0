Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbYGBRSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 13:18:10 -0400
Date: Wed, 2 Jul 2008 10:16:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Adrian Bunk <bunk@kernel.org>, dhowells@redhat.com,
	linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: +
 drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch
 added to -mm tree
Message-Id: <20080702101650.3f579d21.akpm@linux-foundation.org> (sfid-20080702_191814_126843_494AB55D)
In-Reply-To: <486BB332.6000703@lwfinger.net>
References: <200807020835.m628Zx2e007473@imap1.linux-foundation.org>
	<486BB332.6000703@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008 11:56:18 -0500 Larry Finger <Larry.Finger@lwfinger.net> wrote:

> akpm@linux-foundation.org wrote:
> > The patch titled
> >      drivers/net/wireless/b43legacy/dma.c: remove the switch in b43legacy_dma_init()
> > has been added to the -mm tree.  Its filename is
> >      drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch
> > 
> > ------------------------------------------------------
> > Subject: drivers/net/wireless/b43legacy/dma.c: remove the switch in b43legacy_dma_init()
> > From: Adrian Bunk <bunk@stusta.de>
> > 
> > The gcc 3.4 fork used to compile the MN10300 port emits unwanted
> > __ucmpdi2() calls for this switch on a 64bit value.
> > 
> > Fix it by transforming the switch to equivalent "if ... else if ..."
> > statements.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Stefano Brivio <stefano.brivio@polimi.it>
> > Cc: John W. Linville <linville@tuxdriver.com>
> > Cc: Michael Buesch <mb@bu3sch.de>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/net/wireless/b43legacy/dma.c |   16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> > 
> > diff -puN drivers/net/wireless/b43legacy/dma.c~drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init drivers/net/wireless/b43legacy/dma.c
> > --- a/drivers/net/wireless/b43legacy/dma.c~drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init
> > +++ a/drivers/net/wireless/b43legacy/dma.c
> > @@ -1027,19 +1027,15 @@ int b43legacy_dma_init(struct b43legacy_
> >  	enum b43legacy_dmatype type;
> >  
> >  	dmamask = supported_dma_mask(dev);
> > -	switch (dmamask) {
> > -	default:
> > -		B43legacy_WARN_ON(1);
> > -	case DMA_30BIT_MASK:
> > +
> > +	if (dmamask == DMA_30BIT_MASK)
> >  		type = B43legacy_DMA_30BIT;
> > -		break;
> > -	case DMA_32BIT_MASK:
> > +	else if (dmamask == DMA_32BIT_MASK)
> >  		type = B43legacy_DMA_32BIT;
> > -		break;
> > -	case DMA_64BIT_MASK:
> > +	else if (dmamask == DMA_64BIT_MASK)
> >  		type = B43legacy_DMA_64BIT;
> > -		break;
> > -	}
> > +	else
> > +		B43legacy_WARN_ON(1);
> >  
> >  	err = ssb_dma_set_mask(dev->dev, dmamask);
> >  	if (err) {
> > _
> 
> Andrew,
> 
> When I received your E-mail, I wondered why there was not a similar
> "fix" for b43. It was then I discovered how much b43 and b43legacy had
> diverged while I wasn't looking. I have no objections to your patch;
> however, I wonder if it might be better to fix b43legacy in the same
> way that b43 was changed. I have prepared and tested such a fix (shown
> below). The only problem with this is that the patch is much more
> intrusive than Adrian's and there may be a problem getting it into
> 2.6.26 before it is released, but then I do not think that you intend to
> send the -mm patch to 2.6.26.

I don't think we need to fix this in 2.6.26 - I doubt if anyone uses
this driver on frv - it's mainly a "make allmodconfig work on FRV"
thing.


