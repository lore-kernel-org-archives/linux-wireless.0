Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2IDONX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:13:23 -0400
Message-ID: <1346768152.26638.4.camel@dcbw.foobar.com> (sfid-20120904_161326_875515_70714FC0)
Subject: Re: [PATCH] libertas sdio: fix suspend when interface is down
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Tue, 04 Sep 2012 09:15:52 -0500
In-Reply-To: <20120903194909.A878DFAA0A@dev.laptop.org>
References: <20120903194909.A878DFAA0A@dev.laptop.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-03 at 15:49 -0400, Daniel Drake wrote:
> When the interface is down, the hardware is powered off.
> However, the suspend handler currently tries to send host sleep commands
> (when wakeup params are set) in this configuration, causing a system hang
> when going into suspend (the commands will never complete).
> 
> Avoid this by detecting this situation and simply returning from
> the suspend handler without doing anything special.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index e970897..4cb2343 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -1326,6 +1326,11 @@ static int if_sdio_suspend(struct device *dev)
>  
>  	mmc_pm_flag_t flags = sdio_get_host_pm_caps(func);
>  
> +	/* If we're powered off anyway, just let the mmc layer remove the
> +	 * card. */
> +	if (!lbs_iface_active(card->priv))
> +		return -ENOSYS;
> +
>  	dev_info(dev, "%s: suspend: PM flags = 0x%x\n",
>  		 sdio_func_id(func), flags);
>  


