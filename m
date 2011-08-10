Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49341 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab1HJPQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 11:16:11 -0400
Received: by mail-fx0-f48.google.com with SMTP id 7so1615723fxg.35
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 08:16:09 -0700 (PDT)
Subject: Re: [PATCH 20/40] wl12xx: update BT coex configuration params
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-21-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-21-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 18:16:06 +0300
Message-ID: <1312989366.2407.701.camel@cumari> (sfid-20110810_171621_275213_2CC8D211)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> -	 * Defines whether the SG will force WLAN host to enter/exit PSM
> +	 * The maximum time WLAN can gain the antenna for
> +	 * in WLAN PSM / BT master/slave BR

"WLAN can gain the antenna for"... for what?


> +	/*
> +	 * The maximum time WLAN can gain the antenna for
> +	 * in WLAN PSM / BT master/slave EDR

Same here.


> +	/* ??? */

[...]

> +	/* ??? */

Can you figure out what this is? If not, add a "TODO: explain these
values".


> +	 * The threshold (percent) of max consequtive beacon misses before

s/consequtive/consecutive/


> +	/* ??? */

Same as above.


> +	CONF_SG_GENERAL_USAGE_BIT_MAP,



> +	 * Number of consequent BT voice frames not interrupted by WLAN

s/consequent/consecutive/



> @@ -357,17 +354,12 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
>  
>  	/* Beacon filtering */
>  	ret = wl1271_init_beacon_filter(wl);
>  	if (ret < 0)
>  		return ret;
>  
> -	/* FM WLAN coexistence */
> -	ret = wl1271_acx_fm_coex(wl);
> -	if (ret < 0)
> -		return ret;
> -

I guess this means that FM/WLAN coex is not used anymore.  Can you say
it in the commit log too?

-- 
Cheers,
Luca.

