Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4909 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbZAMP45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 10:56:57 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Date: Tue, 13 Jan 2009 10:56:37 -0500
Message-Id: <20090113154204.M52697@bobcopeland.com> (sfid-20090113_165718_781479_0E852233)
In-Reply-To: <Pine.LNX.4.64.0901131509080.9571@blonde.anvils>
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils> <1231426017.922.2.camel@maxim-laptop> <Pine.LNX.4.64.0901081603410.8411@blonde.anvils> <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com> <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet> <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> But I haven't seen any allocation failure for several days.
> I didn't get any while trying to simplify the reproduction,

Ok, well here's how I reproduced it manually.  Without the patch, you 
should see "can't alloc skbuff of size ...." followed shortly by the 
BUG.  With the patch, you see the same error but things proceed as 
normal.

(I chose 60 because anything < 40 will fail in probe).

I'll go ahead and push this upstream then today or tomorrow; let me 
know if you run into any problems with more testing.

> > +static
> > +struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t
*skb_addr)
> > +{
> > +	struct sk_buff *skb;
> > +	unsigned int off;

+    static int foo = 0; 

> > +	/*
> > +	 * Allocate buffer with headroom_needed space for the
> > +	 * fake physical layer header at the start.
> > +	 */
> > +	skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);

+    if (++foo == 60)
+        skb = NULL;

> > +
> > +	if (!skb) {
> > +		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
> > +				sc->rxbufsize + sc->cachelsz - 1);
> > +		return NULL;
> > +	}


> > Changes-licensed-under: 3-Clause-BSD
> 
> Hmm, I haven't noticed anyone doing that before: hope you're not
> starting a trend!  I think you'll find (Documentation/SubmittingPatches)
> that your Signed-off-by agrees to the Developer's Certificate of Origin
> 1.1, which would put your patch under the same open source licence(s) as
> drivers/net/wireless/ath5k/base.c already contains - that's the usual
> case.

I agree with all of the above, but the SFLC suggests we do it anyway.

http://kerneltrap.org/Linux/Wireless_Project_Suggests_Changes-licensed-under_Tag

-- 
Bob Copeland %% www.bobcopeland.com


