Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55628 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2KVSoS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:44:18 -0500
Message-ID: <1353593475.27848.58.camel@cumari.coelho.fi> (sfid-20121122_194430_781596_50DD372E)
Subject: Re: [PATCH 04/13] wlcore: split 18xx and 12xx scan mechanism
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 22 Nov 2012 16:11:15 +0200
In-Reply-To: <1353585928-28666-5-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
	 <1353585928-28666-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-22 at 14:05 +0200, Eliad Peller wrote:
> The scan APIs of 12xx and 18xx are totally different.
> Use some common functions as much as possible (e.g.
> for setting scan channels), but split scan.c into
> chip-specific scan.c files, each implementing its
> own scan mechanism.
> 
> (in other words - move most of the current wlcore's
> scan.c into wl12xx, and implement a similar mechanism
> in 18xx, according to the new api)
> 
> New wlcore ops are introduced in order to call the
> chip-specific scan functions.
> 
> The template indices used for each scan (regular/scheduled)
> are also different between the chips, so set the correct
> indices used for each scan type after identifying the chip.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> +/* probe request rate */
> +enum
> +{
> +	WLCORE_SCAN_RATE_1	= 0,
> +	WLCORE_SCAN_RATE_5_5	= 1,
> +	WLCORE_SCAN_RATE_6	= 2,
> +};

WL18XX_SCAN_RATE_* instead?


> +
> +struct wl1271_cmd_scan_params {

wl18xx_cmd_scan_params is better.

[...]

> +struct wl12xx_cmd_scan_stop {

wl18xx_cmd_scan_stop instead?

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index ff9437a..77479cb 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c

[...]

> @@ -3820,10 +3817,8 @@ static int wlcore_set_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>  						wlvif->band);
>  
>  	/* we only support sched_scan while not connected */
> -	if (wl->sched_scanning) {
> -		wl1271_scan_sched_scan_stop(wl, wlvif);
> -		ieee80211_sched_scan_stopped(wl->hw);
> -	}
> +	if (wl->sched_scanning)
> +		wl->ops->sched_scan_stop(wl, wlvif);

What happened with the ieee80211_sched_scan_stopped()? 

--
Luca.

