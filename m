Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:60910 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3JWFY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 01:24:59 -0400
Message-ID: <1382505837.21526.12.camel@porter.coelho.fi> (sfid-20131023_072528_447293_AE73207D)
Subject: Re: [PATCH 11/13] wlcore: memset wl->rx_filter_enabled to zero
 after recovery
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 23 Oct 2013 08:23:57 +0300
In-Reply-To: <1378718684-14430-11-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
	 <1378718684-14430-11-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-09 at 12:24 +0300, Eliad Peller wrote:
> From: Nadim Zubidat <nadimz@ti.com>
> 
> zero rx_filter_enabled array after recovery to avoid
> cases were the driver will keep trying to clear a
> filter which is not configured in FW.
> 
> Such case will cause consecutive recoveries due to
> command execution failures.
> 
> Signed-off-by: Nadim Zubidat <nadimz@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 60b2113..acb3502 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -1915,6 +1915,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
>  	memset(wl->links_map, 0, sizeof(wl->links_map));
>  	memset(wl->roc_map, 0, sizeof(wl->roc_map));
>  	memset(wl->session_ids, 0, sizeof(wl->session_ids));
> +	memset(wl->rx_filter_enabled, 0, sizeof(wl->rx_filter_enabled));
>  	wl->active_sta_count = 0;
>  	wl->active_link_count = 0;

This causes a sparse warning:

drivers/net/wireless/ti/wlcore/main.c:1918:42: error: cannot size expression

Booleans cannot be sized. :(

I won't apply this patch.

--
Luca.



