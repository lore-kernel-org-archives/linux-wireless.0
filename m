Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50334 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbbEEGps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 02:45:48 -0400
Message-ID: <1430808342.1950.6.camel@sipsolutions.net> (sfid-20150505_084551_551989_10A30E95)
Subject: Re: [PATCH 1/2] add mt7601u driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub =?UTF-8?Q?Kici=C5=84ski?= <moorray3@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Date: Tue, 05 May 2015 08:45:42 +0200
In-Reply-To: <20150505024949.0a672dd1@north>
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	 <1430571690-9054-2-git-send-email-moorray3@wp.pl>
	 <1430732248.2013.16.camel@sipsolutions.net> <20150504120401.30835e07@north>
	 <1430734511.2013.18.camel@sipsolutions.net> <20150505024949.0a672dd1@north>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-05 at 02:49 +0200, Jakub Kiciński wrote:
> On Mon, 04 May 2015 12:15:11 +0200, Johannes Berg wrote:
> > On Mon, 2015-05-04 at 12:04 +0200, Jakub Kiciński wrote:
> > 
> > > > Don't know how your buffers are set up, but if the DMA engine consumes
> > > > pages you could consider using paged RX instead of the memcpy().
> > > 
> > > DMA engine can concatenate multiple frames into a single USB bulk
> > > transfer to a large continuous buffer.  There is no way to request 
> > > any alignment of the frames within that large buffer so I think paged 
> > > RX is not an option.
> > 
> > You could probably still do it because the networking stack only
> > requires the *headers* to be aligned. But if they headers aren't in the
> > skb->data (skb->head) then they'll be pulled into that by the network
> > stack, where they'll be aligned.
> 
> I *think* I got it.  Would you care to take a look?  I basically
> allocate a compound page with dev_alloc_pages() and run get_page() for
> every fragment.

I think it looks fine - except the compound part. I'm pretty sure you
need to do references always with the pointer to the first page (and
consequently don't need to split on the page boundary, and use the same
page pointer just with a bigger offset)

> +static void mt7601u_rx_add_frags(struct mt7601u_dev *dev, struct sk_buff *skb,
> +				 void *data, u32 true_len, u32 truesize,
> +				 struct page *p)
> +{
> +	unsigned long addr = (unsigned long) data;
> +	u32 overpage = 0;
> +	u32 p_off = (data - page_address(p)) >> PAGE_SHIFT;

i.e. you shouldn't need p_off

> +	if ((addr & ~PAGE_MASK) + true_len > PAGE_SIZE)
> +		overpage = (addr & ~PAGE_MASK) + true_len - PAGE_SIZE;

nor overpage

> +	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, p + p_off,
> +			addr & ~PAGE_MASK, true_len - overpage, truesize);
> +	get_page(p + p_off);

Here just use

	skb_fill_page_desc(skb, i, p, data - page_address(p),
			 true_len, truesize);
	get_page(p);

I believe.

> +	/* Do we really need to split the buffer if it crosses a page boundary?
> +	 * Does networking code care?
> +	 */
> +	if (overpage) {
> +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, p + p_off + 1,
> +				0, overpage, 0);
> +		get_page(p + p_off + 1);
> +	}
> +}

and this goes away

> +static void mt7601u_rx_process_seg_paged(struct mt7601u_dev *dev, u8 *data,
> +					 u32 seg_len, struct page *p)

[...]

> +	skb = __netdev_alloc_skb(NULL, 256, GFP_ATOMIC);
> +	if (!skb)
> +		return;

We have a comment on this code (from Eric) saying

        /* Dont use dev_alloc_skb(), we'll have enough headroom once   
         * ieee80211_hdr pulled.

which probably applies here as well. We also just use 128 instead of 256
and haven't seen a need for more.

We also pull the entire frame only if it fits into those 128 bytes, and
we preload the 802.11 header + 8 bytes for snap and possibly crypto
headroom so we can do it all at once instead of later in multiple
places. You can check out iwl_mvm_pass_packet_to_mac80211() to see the
details.

johannes

