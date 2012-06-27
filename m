Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57041 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab2F0PtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:49:12 -0400
Received: by lboj14 with SMTP id j14so2494317lbo.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:49:09 -0700 (PDT)
Message-ID: <1340812144.1631.628.camel@cumari.coelho.fi> (sfid-20120627_174921_472054_2919BA47)
Subject: Re: [PATCH] cfg80211: don't allow WoWLAN support without CONFIG_PM
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 27 Jun 2012 18:49:04 +0300
In-Reply-To: <1340789200.11012.6.camel@jlt3.sipsolutions.net>
References: <1340789200.11012.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 11:26 +0200, Johannes Berg wrote:
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index 1156e3f..747a997 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5321,6 +5321,7 @@ int __devinit wlcore_probe(struct wl1271 *wl,
> struct platform_device *pdev)
>                 goto out_free_hw;
>         }
>  
> +#ifdef CONFIG_PM
>         ret = enable_irq_wake(wl->irq);
>         if (!ret) {
>                 wl->irq_wake_enabled = true;
> @@ -5334,6 +5335,7 @@ int __devinit wlcore_probe(struct wl1271 *wl,
> struct platform_device *pdev)
>                                 WL1271_RX_FILTER_MAX_PATTERN_SIZE;
>                 }
>         }
> +#endif
>         disable_irq(wl->irq);

I'm not the biggest fan of #ifdef's in the middle of functions, but I
guess it's clean enough here.  Maybe we split this out to a separate
function that can be #ifdef'ed entirely.

In any case, for the wlcore part:

Acked-by: Luciano Coelho <coelho@ti.com>

--
Cheers,
Luca.

