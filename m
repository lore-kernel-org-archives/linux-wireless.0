Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50477 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031Ab2K0JXd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 04:23:33 -0500
Message-ID: <1354008173.950.60.camel@cumari.coelho.fi> (sfid-20121127_102338_834518_09C7EA2B)
Subject: Re: [PATCH 01/20] wl18xx: update default mac/phy parameters
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>
Date: Tue, 27 Nov 2012 11:22:53 +0200
In-Reply-To: <1353998701-18171-2-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> From: Ido Reis <idor@ti.com>
> 
> Update mac/phy paramters according to the default HP SISO boards.
> 
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  drivers/net/wireless/ti/wl18xx/conf.h |   17 +++++++++++------
>  drivers/net/wireless/ti/wl18xx/main.c |    7 ++++---
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
> index 4d426cc..f020c1c 100644
> --- a/drivers/net/wireless/ti/wl18xx/conf.h
> +++ b/drivers/net/wireless/ti/wl18xx/conf.h
> @@ -23,20 +23,21 @@
>  #define __WL18XX_CONF_H__
>  
>  #define WL18XX_CONF_MAGIC	0x10e100ca
> -#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0003)
> +#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0004)
>  #define WL18XX_CONF_MASK	0x0000ffff
>  #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
>  				 sizeof(struct wl18xx_priv_conf))
>  
>  #define NUM_OF_CHANNELS_11_ABG 150
>  #define NUM_OF_CHANNELS_11_P 7
> -#define WL18XX_NUM_OF_SUB_BANDS 9
>  #define SRF_TABLE_LEN 16
>  #define PIN_MUXING_SIZE 2
> +#define NUM_OF_TRACE_LOSS_GAPS_TX 10
> +#define NUM_OF_TRACE_LOSS_GAPS_RX 18

I'll s/NUM_OF/WL18XX/ here when I apply.


> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> index e71e2cf..30222cb 100644
> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c

[...]

> @@ -525,13 +524,15 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
>  		.enable_tx_low_pwr_on_siso_rdl	= 0x00,
>  		.rx_profile			= 0x00,
>  		.pwr_limit_reference_11_abg	= 0xc8,
> +		.pwr_limit_reference_11p	= 0xc8,
>  		.psat				= 0,
>  		.low_power_val			= 0x00,
> -		.med_power_val			= 0x0a,
> -		.high_power_val			= 0x1e,
> +		.med_power_val			= 0x0A,
> +		.high_power_val			= 0x11,

The change from 0x0a to 0x0A shouldn't be here.  I'll remove it.

--
Luca.

