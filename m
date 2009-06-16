Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43941 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762480AbZFPUAi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 16:00:38 -0400
Subject: Re: [PATCH] libertas: remove ps_supported flag, use fwcapinfo
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1244770812-14947-1-git-send-email-andrey@cozybit.com>
References: <1244770812-14947-1-git-send-email-andrey@cozybit.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 16:00:38 -0400
Message-Id: <1245182438.28992.21.camel@130.81.190.10.in-addr.arpa>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-11 at 18:40 -0700, Andrey Yurovsky wrote:
> Power save support depends on the firmware capabilities rather than the
> card's hardware interface.  Use the FW_CAPINFO_PS bit in the firmware
> capabilities mask throughout the driver in place of the redundant
> ps_supported flag and don't make decisions about PS support in the
> interface drivers (with the exception of a special case in the USB
> driver).
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> ---
>  drivers/net/wireless/libertas/dev.h     |    1 -
>  drivers/net/wireless/libertas/if_cs.c   |    3 ---
>  drivers/net/wireless/libertas/if_sdio.c |    3 ---
>  drivers/net/wireless/libertas/if_spi.c  |    1 -
>  drivers/net/wireless/libertas/if_usb.c  |    2 +-
>  drivers/net/wireless/libertas/wext.c    |    2 +-
>  6 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index f9ec69e..578c697 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -260,7 +260,6 @@ struct lbs_private {
>  	u16 psmode;		/* Wlan802_11PowermodeCAM=disable
>  				   Wlan802_11PowermodeMAX_PSP=enable */
>  	u32 psstate;
> -	char ps_supported;
>  	u8 needtowakeup;
>  
>  	struct assoc_request * pending_assoc_req;
> diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
> index 2a5b083..f658fd6 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -933,9 +933,6 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  		goto out3;
>  	}
>  
> -	/* The firmware for the CF card supports powersave */
> -	priv->ps_supported = 1;
> -
>  	ret = 0;
>  	goto out;
>  
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 8cdb88c..89396a7 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -1039,9 +1039,6 @@ static int if_sdio_probe(struct sdio_func *func,
>  	if (ret)
>  		goto err_activate_card;
>  
> -	if (priv->fwcapinfo & FW_CAPINFO_PS)
> -		priv->ps_supported = 1;
> -
>  out:
>  	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
>  
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index f8c2898..2045ac3 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -1117,7 +1117,6 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  	priv->card = card;
>  	priv->hw_host_to_card = if_spi_host_to_card;
>  	priv->fw_ready = 1;
> -	priv->ps_supported = 1;
>  
>  	/* Initialize interrupt handling stuff. */
>  	card->run_thread = 1;
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index ea3dc03..04da68e 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -188,7 +188,7 @@ static void if_usb_setup_firmware(struct lbs_private *priv)
>  	} else {
>  		if (le16_to_cpu(wake_method.method) == CMD_WAKE_METHOD_COMMAND_INT) {
>  			lbs_deb_usb("Firmware seems to support PS with wake-via-command\n");
> -			priv->ps_supported = 1;
> +			priv->fwcapinfo &= ~FW_CAPINFO_PS;

This seems odd; wouldn't

priv->fwcapinfo |= FW_CAPINFO_PS;

be the right thing to do here?

Dan

>  		} else {
>  			/* The versions which boot up this way don't seem to
>  			   work even if we set it to the command interrupt */
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index 8bc1907..e96451c 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -712,7 +712,7 @@ static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
>  
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
> -	if (!priv->ps_supported) {
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PS)) {
>  		if (vwrq->disabled)
>  			return 0;
>  		else

