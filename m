Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:48994 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754Ab1D2UJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:09:36 -0400
Received: by mail-ey0-f171.google.com with SMTP id d26so1710676eyd.2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:09:30 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: do not set queue_mapping directly
From: Luciano Coelho <coelho@ti.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303853264-2622-1-git-send-email-hauke@hauke-m.de>
References: <1303853264-2622-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:09:27 +0300
Message-ID: <1304107767.12586.165.camel@cumari> (sfid-20110429_220939_161621_02FE33BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 23:27 +0200, Hauke Mehrtens wrote:
> It is preferred to use the setter that to set queue_mapping directly.
> This also helps backporting in compat-wireless.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/wl12xx/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index dad81f6..9d1d4d6 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -1293,7 +1293,7 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
>  	skb->priority = WL1271_TID_MGMT;
>  
>  	/* Initialize all fields that might be used */
> -	skb->queue_mapping = 0;
> +	skb_set_queue_mapping(skb, 0);
>  	memset(IEEE80211_SKB_CB(skb), 0, sizeof(struct ieee80211_tx_info));
>  
>  	return skb;

Thanks Hauke! This is indeed better than having to hack compat-wireless
to get it to work.

Applied.

-- 
Cheers,
Luca.

