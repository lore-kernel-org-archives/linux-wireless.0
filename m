Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:57135 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZK1V0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:26:55 -0500
Received: by ewy7 with SMTP id 7so3003721ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 13:27:00 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Further L2 padding fixes.
Date: Sat, 28 Nov 2009 22:26:57 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Alban Browaeys <prahal@yahoo.com>
References: <1259433154-2587-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259433154-2587-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911282226.58091.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index b8f0954..562a344 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>  	unsigned int frame_length = skb->len;
>  	unsigned int header_align = ALIGN_SIZE(skb, 0);
>  	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
> -	unsigned int l2pad = 4 - (payload_align - header_align);
> +	unsigned int l2pad = 4 - (header_length & 3);

Not sure about this, the l2pad should be the total bytes between the header and payload.
What if we have a frame for which both the header and the payload should be moved?

The code in this function handles multiple scenarios, one where both the payload and
header must be moved or when only one of both should be moved. In each case the l2pad
depends on both the payload and header alignment sizes.

>  	if (header_align == payload_align) {
>  		/*
> @@ -216,6 +216,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>  		memmove(skb->data + header_length + l2pad,
>  			skb->data + header_length + l2pad + payload_align,
>  			frame_length - header_length);
> +		skb_trim(skb, frame_length + l2pad);
>  		skbdesc->flags |= SKBDESC_L2_PADDED;
>  	}
>  }
> @@ -346,7 +347,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
>  	 * Header and alignment information.
>  	 */
>  	txdesc->header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
> -	txdesc->l2pad = ALIGN_SIZE(entry->skb, txdesc->header_length);
> +	txdesc->l2pad = 4 - (txdesc->header_length & 3);

ALIGN_SIZE() depends on the actual address of the payload, and thus should be better
and indicating the amount of padding which is required. However the bug might be that we need
to do the same calculation as in rt2x00queue_insert_l2pad() and make it depend on the ALIGN_SIZE
values from header and payload.

Ivo
