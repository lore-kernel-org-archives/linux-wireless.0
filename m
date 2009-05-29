Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbZE2KeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 06:34:14 -0400
Subject: Re: [PATCH 9/10]: irda: Use SKB queue and list helpers instead of
	doing it by-hand.
From: Samuel Ortiz <samuel@sortiz.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20090529.014025.223389403.davem@davemloft.net>
References: <20090529.014025.223389403.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 29 May 2009 12:36:20 +0200
Message-Id: <1243593380.8750.0.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-29 at 01:40 -0700, David Miller wrote:
> Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Samuel Ortiz <samuel@sortiz.org>

Cheers,
Samuel.

> ---
>  net/irda/irlap_frame.c |   18 ++----------------
>  1 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/net/irda/irlap_frame.c b/net/irda/irlap_frame.c
> index 2562ebc..7af2e74 100644
> --- a/net/irda/irlap_frame.c
> +++ b/net/irda/irlap_frame.c
> @@ -982,17 +982,12 @@ void irlap_resend_rejected_frames(struct irlap_cb *self, int command)
>  {
>  	struct sk_buff *tx_skb;
>  	struct sk_buff *skb;
> -	int count;
>  
>  	IRDA_ASSERT(self != NULL, return;);
>  	IRDA_ASSERT(self->magic == LAP_MAGIC, return;);
>  
> -	/* Initialize variables */
> -	count = skb_queue_len(&self->wx_list);
> -
>  	/*  Resend unacknowledged frame(s) */
> -	skb = skb_peek(&self->wx_list);
> -	while (skb != NULL) {
> +	skb_queue_walk(&self->wx_list, skb) {
>  		irlap_wait_min_turn_around(self, &self->qos_tx);
>  
>  		/* We copy the skb to be retransmitted since we will have to
> @@ -1011,21 +1006,12 @@ void irlap_resend_rejected_frames(struct irlap_cb *self, int command)
>  		/*
>  		 *  Set poll bit on the last frame retransmitted
>  		 */
> -		if (count-- == 1)
> +		if (skb_queue_is_last(&self->wx_list, skb))
>  			tx_skb->data[1] |= PF_BIT; /* Set p/f bit */
>  		else
>  			tx_skb->data[1] &= ~PF_BIT; /* Clear p/f bit */
>  
>  		irlap_send_i_frame(self, tx_skb, command);
> -
> -		/*
> -		 *  If our skb is the last buffer in the list, then
> -		 *  we are finished, if not, move to the next sk-buffer
> -		 */
> -		if (skb == skb_peek_tail(&self->wx_list))
> -			skb = NULL;
> -		else
> -			skb = skb->next;
>  	}
>  #if 0 /* Not yet */
>  	/*

