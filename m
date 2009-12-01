Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63717 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZLATP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 14:15:59 -0500
Received: by ewy19 with SMTP id 19so5285756ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 11:16:05 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v3 4/4] rt2x00: Only remove L2 padding in received frames if there is payload.
Date: Tue, 1 Dec 2009 20:16:02 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <1259615298-2305-4-git-send-email-gwingerde@gmail.com> <1259615298-2305-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259615298-2305-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912012016.03145.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 November 2009, Gertjan van Wingerde wrote:
> L2 padding will only be present when there is actual payload present.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index ca2bcc0..b93731b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -401,7 +401,9 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
>  	    (rxdesc.flags & RX_FLAG_IV_STRIPPED))
>  		rt2x00crypto_rx_insert_iv(entry->skb, header_length,
>  					  &rxdesc);
> -	else if (rxdesc.dev_flags & RXDONE_L2PAD)
> +	else if (header_length &&
> +		 (rxdesc.size > header_length) &&
> +		 (rxdesc.dev_flags & RXDONE_L2PAD))
>  		rt2x00queue_remove_l2pad(entry->skb, header_length);
>  	else
>  		rt2x00queue_align_payload(entry->skb, header_length);

Is there a scenario where header_lenght can be 0?
And if there is, shouldn't we have bailed-out completely already?

Ivo
