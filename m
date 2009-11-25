Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:24664 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000AbZKYXtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 18:49:39 -0500
Received: by ey-out-2122.google.com with SMTP id 4so80744eyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 15:49:44 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix padding bug on L2PAD devices.
Date: Thu, 26 Nov 2009 00:49:42 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1259100692-23315-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259100692-23315-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911260049.42577.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 November 2009, Gertjan van Wingerde wrote:
> While reviewing the l2pad function to align both the header and the payload
> on a DMA-capable boundary a bug was discovered where the payload would not
> be properly aligned. The header_align value was used where the payload_align
> value should have been used.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 32d4aea..239afc7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -214,7 +214,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>  		skb_push(skb, header_align);
>  		memmove(skb->data, skb->data + header_align, header_length);
>  		memmove(skb->data + header_length + l2pad,
> -			skb->data + header_length + l2pad + header_align,
> +			skb->data + header_length + l2pad + payload_align,
>  			frame_length - header_length);
>  		skbdesc->flags |= SKBDESC_L2_PADDED;
>  	}


