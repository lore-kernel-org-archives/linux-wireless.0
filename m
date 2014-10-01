Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaJAJPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 05:15:10 -0400
Date: Wed, 1 Oct 2014 11:12:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mark Asselstine <asselsm@gmail.com>
Cc: helmut.schaa@googlemail.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2x00queue: avoid using more headroom then
 driver requested
Message-ID: <20141001091240.GA2011@redhat.com> (sfid-20141001_111515_953481_65425D97)
References: <1412135157-13520-1-git-send-email-asselsm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412135157-13520-1-git-send-email-asselsm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2014 at 11:45:57PM -0400, Mark Asselstine wrote:
> 'struct ieee80211_hw' contains 'extra_tx_headroom' which it defines as
> "headroom to reserve in each transmit skb for use by the driver". This
> value is properly setup during rt2x00lib_probe_hw() to account for all
> the rt2x00lib's purposes, including DMA alignment and L2 pad if
> needed. As such under all circumstances the proper amount of headroom
> is allocated to a skb such that under any usage we would not ever use
> more headroom then is allotted.
> 
> However rt2x00queue_write_tx_frame() uses up the headroom (via calls
> to skb_push) allotted for L2 padding (with a potential call to
> rt2x00queue_insert_l2pad()) and uses up the headroom allotted to DMA
> alignment (with a potential call to rt2x00queue_align_frame()) and
> then proceeds to use up 'extra_tx_headroom' (in a call to
> rt2x00queue_write_tx_data())
> 
> So the driver has requested just 'extra_tx_headroom' worth of headroom
> and we have used up 'extra_tx_headroom' + DMA + L2PAD worth. As such
> it is possible to hit a 'skb_under_panic', where we have used up all
> the available headroom.
> 
> Since extra_tx_headroom was calculated as a function of winfo_size,
> desc_size, RT2X00_L2PAD_SIZE and RT2X00_ALIGN_SIZE we can simply
> remove the part for alignment and padding and we will know how much is
> left to use up (for txdesc) and only use that much. Keeping the
> driver's use of headroom to what it requested via extra_tx_headroom.
> 
> Signed-off-by: Mark Asselstine <asselsm@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 8e68f87..2a48bf5 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -522,6 +522,7 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
>  				     struct txentry_desc *txdesc)
>  {
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> +	unsigned int avail_extra_tx_headroom = rt2x00dev->extra_tx_headroom;
>  
>  	/*
>  	 * This should not happen, we already checked the entry
> @@ -538,10 +539,18 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
>  	}
>  
>  	/*
> -	 * Add the requested extra tx headroom in front of the skb.
> +	 * Add room for data at the front of the buffer for txdesc. The space
> +	 * needed for this was accounted for in extra_tx_headroom, we just
> +	 * need to remove the amount allocated for padding and alignment
> +	 * to get what is left for txdesc.
>  	 */
> -	skb_push(entry->skb, rt2x00dev->extra_tx_headroom);
> -	memset(entry->skb->data, 0, rt2x00dev->extra_tx_headroom);
> +	if (test_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags))
> +		avail_extra_tx_headroom -= RT2X00_L2PAD_SIZE;
> +	else if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags))
> +		avail_extra_tx_headroom -= RT2X00_ALIGN_SIZE;
> +
> +	skb_push(entry->skb, avail_extra_tx_headroom);
> +	memset(entry->skb->data, 0, avail_extra_tx_headroom);

I don't think patch is correct. 

We have rt2x00->extra_tx_headroom and rt2x00->hw->extra_tx_headroom.
Second value, which we provide as maximum needed headroom to mac80211
is rt2x00->extra_tx_headrom + RT2X00_L2PAD_SIZE + RT2X00_ALIGN_SIZE.

We really need to reserve rt2x00dev->extra_tx_headroom on TX skb, as
this is room for metadata needed by H/W and if needed we should reserve
RT2x00_L2PAD_SIZE and RTX00_ALIGN_SIZE. There should be room for that,
since we provide bigger rt2x00->hw->extra_tx_headroom to mac80211.

The only possibility to skb_under_panic I can see, is that we retransmit
frame and try to align it many times, but alignment should not be needed
once we aligned frame. Hence I'm not sure how those skb_under_panics can
happen.

Thanks
Stanislaw
