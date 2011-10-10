Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:45602 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297Ab1JJS2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 14:28:54 -0400
Received: by eyh5 with SMTP id 5so1916461eyh.21
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 11:28:51 -0700 (PDT)
Subject: Re: [PATCH 06/29] wl12xx: add vifs list
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-7-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 21:28:48 +0300
Message-ID: <1318271328.9690.381.camel@cumari> (sfid-20111010_202857_101499_A3CCA283)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote: 
> keep a list of all the vifs associated with our hw.
> it will be later used in order to iterate through vifs.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index 33ccdf8..55561c5 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -394,6 +394,8 @@ struct wl1271 {
>  	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
>  	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
>  
> +	struct list_head wlvif_list;
> +
>  	struct wl1271_acx_mem_map *target_mem_map;
>  
>  	/* Accounting for allocated / available TX blocks on HW */
> @@ -564,6 +566,7 @@ struct wl1271_station {
>  
>  struct wl12xx_vif {
>  	struct wl1271 *wl;
> +	struct list_head list;

I know we alredy call this kind of thing "list" struct wl1271 for the
ARP stuff, but I prefer "node" so it's easier to follow when calling
list_add and friends.  Mind changing?


> @@ -653,6 +656,9 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
>  	return container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
>  }
>  
> +#define wl12xx_for_each_wlvif(wl, wlvif) \
> +		list_for_each_entry(wlvif, &wl->wlvif_list, list)
> +

This looks fine, but is it really necessary? I think the call to
list_for_each_entry is clear enough already, isn't it?


-- 
Cheers,
Luca.

