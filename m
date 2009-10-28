Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41168 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbZJ1UiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 16:38:07 -0400
From: Christian Casteyde <casteyde.christian@free.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.32-rc5-git3: Reported regressions from 2.6.31
Date: Wed, 28 Oct 2009 21:38:37 +0100
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910262138.30396.mb@bu3sch.de> <20091028190547.GA2856@tuxdriver.com>
In-Reply-To: <20091028190547.GA2856@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910282138.37401.casteyde.christian@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've just tested the patch posted in bugzilla: it works.
That is, I do not manage to get the warning anymore in 3 boots in a row.

CC
Le mercredi 28 octobre 2009 20:05:47, John W. Linville a écrit :
> Christian,
> 
> Will you be able to test this patch for us?
> 
> Thanks,
> 
> John
> 
> On Mon, Oct 26, 2009 at 09:38:28PM +0100, Michael Buesch wrote:
> > On Monday 26 October 2009 20:37:33 Michael Buesch wrote:
> > > Ok, it just turns out this actually is a driver bug.
> > > Thanks to Johannes Berg for tracking it down.
> > >
> > > I think it's caused by the DMA bouncebuffer stuff that does not copy
> > > the skb->cb and does not adjust the "tx-info" pointer.
> > > I wonder why this didn't blow up easlier, because this bug is there
> > > since mac80211 switched to using the CB.
> > >
> > > Here's a completely untested patch.
> >
> > Here's a new version of the patch that also fixes queue mapping bugs:
> >
> > ---
> >  drivers/net/wireless/b43/dma.c |   15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > --- wireless-testing.orig/drivers/net/wireless/b43/dma.c
> > +++ wireless-testing/drivers/net/wireless/b43/dma.c
> > @@ -1157,8 +1157,9 @@ struct b43_dmaring *parse_cookie(struct
> >  }
> >
> >  static int dma_tx_fragment(struct b43_dmaring *ring,
> > -			   struct sk_buff *skb)
> > +			   struct sk_buff **in_skb)
> >  {
> > +	struct sk_buff *skb = *in_skb;
> >  	const struct b43_dma_ops *ops = ring->ops;
> >  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> >  	u8 *header;
> > @@ -1224,8 +1225,14 @@ static int dma_tx_fragment(struct b43_dm
> >  		}
> >
> >  		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
> > +		memcpy(bounce_skb->cb, skb->cb, sizeof(skb->cb));
> > +		bounce_skb->dev = skb->dev;
> > +		skb_set_queue_mapping(bounce_skb, skb_get_queue_mapping(skb));
> > +		info = IEEE80211_SKB_CB(bounce_skb);
> > +
> >  		dev_kfree_skb_any(skb);
> >  		skb = bounce_skb;
> > +		*in_skb = bounce_skb;
> >  		meta->skb = skb;
> >  		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
> >  		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
> > @@ -1355,7 +1362,11 @@ int b43_dma_tx(struct b43_wldev *dev, st
> >  	 * static, so we don't need to store it per frame. */
> >  	ring->queue_prio = skb_get_queue_mapping(skb);
> >
> > -	err = dma_tx_fragment(ring, skb);
> > +	/* dma_tx_fragment might reallocate the skb, so invalidate pointers
> > pointing +	 * into the skb data or cb now. */
> > +	hdr = NULL;
> > +	info = NULL;
> > +	err = dma_tx_fragment(ring, &skb);
> >  	if (unlikely(err == -ENOKEY)) {
> >  		/* Drop this packet, as we don't have the encryption key
> >  		 * anymore and must not transmit it unencrypted. */
> 
