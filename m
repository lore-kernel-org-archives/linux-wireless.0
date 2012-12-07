Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54878 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768Ab2LGMUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 07:20:01 -0500
Message-ID: <1354882758.31150.7.camel@cumari.coelho.fi> (sfid-20121207_132008_047324_9B083B26)
Subject: Re: [PATCH 13/20] wlcore: use link count for single-STA-PSM
 optimization
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 7 Dec 2012 14:19:18 +0200
In-Reply-To: <1354095769-8724-14-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-14-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> Only allow a PSM STA to congest FW memory when it is the single active
> link. Being a single STA doesn't imply a single link - there might be
> other links on other roles.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
> index 1fbee0d..28a3027 100644
> --- a/drivers/net/wireless/ti/wlcore/cmd.c
> +++ b/drivers/net/wireless/ti/wlcore/cmd.c
> @@ -328,6 +328,8 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
>  			wl->fw_status_2->counters.tx_lnk_free_pkts[link];
>  	wl->links[link].wlvif = wlvif;
>  	*hlid = link;
> +
> +	wl->active_link_count++;
>  	return 0;
>  }
>  
> @@ -357,6 +359,8 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
>  	wl->links[*hlid].wlvif = NULL;
>  
>  	*hlid = WL12XX_INVALID_LINK_ID;
> +	wl->active_link_count--;
> +	WARN_ON(wl->active_link_count < 0);

This could be WARN_ON_ONCE().  If we hit this once, it's highly likely
that we will keep hitting it later on, unless we have another bug that
would cancel this one out. ;)

I can convert this myself if you agree.

--
Luca.

