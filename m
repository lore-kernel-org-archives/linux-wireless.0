Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:52813 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab1ANNQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 08:16:36 -0500
Subject: Re: [PATCH] wl12xx: Cleanup PLT mode when module is removed
From: Luciano Coelho <coelho@ti.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 15:16:53 +0200
Message-ID: <1295011013.1960.269.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Juuso,

On Fri, 2011-01-14 at 12:48 +0100, juuso.oikarinen@nokia.com wrote:
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 9076555..863e660 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -917,12 +917,10 @@ out:
>  	return ret;
>  }
>  
> -int wl1271_plt_stop(struct wl1271 *wl)
> +int __wl1271_plt_stop(struct wl1271 *wl)
>  {
>  	int ret = 0;
>  
> -	mutex_lock(&wl->mutex);
> -
>  	wl1271_notice("power down");
>  
>  	if (wl->state != WL1271_STATE_PLT) {
> @@ -938,12 +936,21 @@ int wl1271_plt_stop(struct wl1271 *wl)
>  	wl->state = WL1271_STATE_OFF;
>  	wl->rx_counter = 0;
>  
> -out:
>  	mutex_unlock(&wl->mutex);
> -
>  	cancel_work_sync(&wl->irq_work);
>  	cancel_work_sync(&wl->recovery_work);
> +	mutex_lock(&wl->mutex);
> +out:
> +	return ret;
> +}

Again we have this kind of unlock-lock case.  Wouldn't it be better to
move the cancel_work calls outside this function and call them after
__wl1271_plt_stop() has returned? Yeah, there will be duplicate code if
we do this, but I think it's a bit safer, isn't it?

-- 
Cheers,
Luca.

