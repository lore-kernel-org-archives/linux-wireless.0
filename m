Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:49584 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965174AbeGBLaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 07:30:11 -0400
Date: Mon, 2 Jul 2018 04:30:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: Fix memory leak in
 wlcore_cmd_wait_for_event_or_timeout
Message-ID: <20180702113008.GV112168@atomide.com> (sfid-20180702_133049_077621_39CC7682)
References: <20180628130809.GA8147@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180628130809.GA8147@embeddedor.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Gustavo A. R. Silva <gustavo@embeddedor.com> [180628 13:11]:
> In case memory resources for *events_vector* were allocated, release
> them before return.
> 
> Addresses-Coverity-ID: 1470194 ("Resource leak")
> Fixes: 4ec7cece87b3 ("wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks for catching this one:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/net/wireless/ti/wlcore/cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
> index 836c616..9039687 100644
> --- a/drivers/net/wireless/ti/wlcore/cmd.c
> +++ b/drivers/net/wireless/ti/wlcore/cmd.c
> @@ -195,8 +195,7 @@ int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
>  	ret = pm_runtime_get_sync(wl->dev);
>  	if (ret < 0) {
>  		pm_runtime_put_noidle(wl->dev);
> -
> -		return ret;
> +		goto free_vector;
>  	}
>  
>  	do {
> @@ -232,6 +231,7 @@ int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
>  out:
>  	pm_runtime_mark_last_busy(wl->dev);
>  	pm_runtime_put_autosuspend(wl->dev);
> +free_vector:
>  	kfree(events_vector);
>  	return ret;
>  }
> -- 
> 2.7.4
> 
