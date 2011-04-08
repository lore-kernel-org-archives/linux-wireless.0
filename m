Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55484 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab1DHRjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 13:39:07 -0400
Received: by mail-qw0-f41.google.com with SMTP id 26so2957157qwa.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 10:39:06 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: use 2 spare TX blocks for GEM cipher
From: Luciano Coelho <coelho@ti.com>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301834245-16679-1-git-send-email-guy@wizery.com>
References: <1301834245-16679-1-git-send-email-guy@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 10:38:58 -0700
Message-ID: <1302284338.2031.21.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-03 at 15:37 +0300, Guy Eilam wrote:
> Add tx_spare_blocks member to the wl1271 struct
> for more generic configuration of the amount
> of spare TX blocks that should be used.
> The default value is 1.
> in case GEM cipher is used by the STA, we need
> 2 spare TX blocks instead of just 1.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---

Looks good, but I have a couple of comments.


> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 85cb4da..f962e43 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c

[..]

> @@ -2039,6 +2043,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
>  			0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  		};
>  
> +		/*
> +		 * A STA set to GEM cipher requires 2 tx spare blocks.
> +		 * Return to default value when GEM cipher key is removed
> +		 */
> +		if (key_type == KEY_GEM) {
> +			if (action == KEY_ADD_OR_REPLACE)
> +				wl->tx_spare_blocks = 2;
> +			else
> +				wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
> +		}
> +

This won't make a real difference in the code flow, but wouldn't it be
better to make it explicit that the "else" case is KEY_REMOVE? There is
also KEY_SET_ID, which is only used with WEP, so it doesn't matter now.
But I think it's more consistent to be clear about it.



> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> index db9e47e..2c79b6e 100644
> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -135,12 +135,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
>  	u32 len;
>  	u32 total_blocks;
>  	int id, ret = -EBUSY;
> -	u32 spare_blocks;
> +	u32 spare_blocks = wl->tx_spare_blocks;
>  
>  	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
>  		spare_blocks = 2;
> -	else
> -		spare_blocks = 1;

Do we still need the quirk now? Wouldn't it be nicer to change the
wl->tx_spare_blocks value directly instead?


-- 
Cheers,
Luca.

