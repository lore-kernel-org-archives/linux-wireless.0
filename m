Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36394 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab2BBHnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 02:43:11 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id d3so1218830lah.26
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 23:43:10 -0800 (PST)
Subject: Re: [PATCH v2 3/7] wl12xx: add forced_ps mode
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328021048-8944-4-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-4-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 09:43:06 +0200
Message-ID: <1328168586.3626.245.camel@cumari> (sfid-20120202_084338_650094_5DD2E8F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote: 
> From: Eyal Shapira <eyal@wizery.com>
> 
> For certain WiFi certification tests forcing PS
> is necessary. Since DPS is now enabled in the FW
> and this can't be achieved by using netlatency
> this required a new config option.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
> index d97aad6..f29fbfd 100644
> --- a/drivers/net/wireless/wl12xx/conf.h
> +++ b/drivers/net/wireless/wl12xx/conf.h
> @@ -934,6 +934,12 @@ struct conf_conn_settings {
>  	u16 dynamic_ps_timeout;
>  
>  	/*
> +	 * Specifies whether dynamic PS should be disabled and PSM forced.
> +	 * This is required for certain WiFi certification tests.
> +	 */
> +	u8 forced_ps;
> +
> +	/*

We are kind of abusing the conf struct.  Originally it contained the
stuff that was coming from the INI file, now we're putting everything
there.  It's okay for now, but just a reminder that we need to clean all
this up at some point (soon!).


> diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
> index 15353fa..02da445 100644
> --- a/drivers/net/wireless/wl12xx/debugfs.c
> +++ b/drivers/net/wireless/wl12xx/debugfs.c
> @@ -358,7 +358,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
>          */
>  
>         wl12xx_for_each_wlvif_sta(wl, wlvif) {
> -               if (test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags))
> +               if (test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags))
>                         wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE);
>         }

Don't you want to change this file so that we can dynamically change from auto-PS to forced-PS?

> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 29a00fc..f2960df 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -244,6 +244,7 @@ static struct conf_drv_settings default_conf = {
>                 .psm_exit_retries            = 16,
>                 .psm_entry_nullfunc_retries  = 3,
>                 .dynamic_ps_timeout          = 100,
> +               .forced_ps                   = false,
>                 .keep_alive_interval         = 55000,
>                 .max_listen_interval         = 20,
>         },

This is hardcoded and would require the driver to be recompiled in order
to enable this feature.  Is that even allowed during certification (ie.
use two different binaries for different testcases)?


-- 
Cheers,
Luca.

