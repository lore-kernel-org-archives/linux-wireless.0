Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44094 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab2LELV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 06:21:59 -0500
Message-ID: <1354706476.6234.50.camel@cumari.coelho.fi> (sfid-20121205_122204_196084_A08F21A6)
Subject: Re: [PATCH 05/20] wlcore: increase scan dwell times if no activity
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Eyal Shapira <eyal@wizery.com>
Date: Wed, 5 Dec 2012 13:21:16 +0200
In-Reply-To: <1354095769-8724-6-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-6-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> There's a limit on scan dwell times of max 30ms in order
> to avoid degrading voip traffic which could be going on
> while scanning. However these dwell times increase the
> chance of missing out on nearby APs leading to partial
> scan results. Allow configuration of longer dwell times
> in case there no active interface (i.e. no STA associated
> or AP up).
> 
> [Arik - count started vifs using an in-driver function]
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
> index ad15cae..a4eb14c 100644
> --- a/drivers/net/wireless/ti/wlcore/conf.h
> +++ b/drivers/net/wireless/ti/wlcore/conf.h
> @@ -1097,6 +1097,24 @@ struct conf_scan_settings {
>  	 */
>  	u32 max_dwell_time_active;
>  
> +	/*
> +	 * The minimum time to wait on each channel for active scans
> +	 * when there's a concurrent active interface. This should
> +	 * lower than min_dwell_time_active usually in order to avoid
> +	 * interfering with possible voip traffic on another interface.
> +	 *
> +	 * Range: u32 tu/1000
> +	 */
> +	u32 min_dwell_time_active_conc;
> +
> +	/*
> +	 * The maximum time to wait on each channel for active scans
> +	 * See explanation about min_dwell_time_active_conc
> +	 *
> +	 * Range: u32 tu/1000
> +	 */
> +	u32 max_dwell_time_active_conc;
> +

IMO it would have been nicer to keep the existing ones as they are and
not change the semantics.  Then add the new ones with another name.
Maybe something like "max_dwell_time_active_long", which is more
generic.

It is possible that we will find more scenarios where this long scans
could be used (eg. if it would be possible to identify whether there are
any low latency TIDs running or not).

Also, the "concurrent" name here sounds strange, because the first thing
that comes to mind is concurrent scans and not started vifs.

--
Luca.

