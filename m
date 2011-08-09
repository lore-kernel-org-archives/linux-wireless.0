Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38434 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab1HIMDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 08:03:08 -0400
Received: by mail-ey0-f173.google.com with SMTP id 7so3963167eyb.18
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 05:03:06 -0700 (PDT)
Subject: Re: [PATCH 03/40] wl12xx: use 1 spare block in all cases
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-4-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-4-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 15:03:03 +0300
Message-ID: <1312891383.2407.164.camel@cumari> (sfid-20110809_140312_133418_D7123804)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> Remove support for firmwares that require 2 spare blocks for packet TX.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/tx.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> index 0696aed..c67340f 100644
> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -166,18 +166,15 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
>  {
>  	struct wl1271_tx_hw_descr *desc;
>  	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
>  	u32 len;
>  	u32 total_blocks;
>  	int id, ret = -EBUSY;
> -	u32 spare_blocks;
>  
> -	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
> -		spare_blocks = 2;
> -	else
> -		spare_blocks = 1;
> +	/* we use 1 spare block */
> +	u32 spare_blocks = 1;
>  
>  	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
>  		return -EAGAIN;
>  
>  	/* allocate free identifier for the packet */
>  	id = wl1271_alloc_tx_id(wl, skb);

Please, remove the quirk completely as it is not used anymore after this
patch.

-- 
Cheers,
Luca.

