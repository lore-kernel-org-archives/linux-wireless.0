Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:36047 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab1GUANP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 20:13:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 20 Jul 2011 17:06:37 -0700
Subject: RE: [PATCH] mwifiex: disable auto deep sleep before unloading the
 driver
Message-ID: <477F20668A386D41ADCC57781B1F704307FFBB28A5@SC-VEXCH1.marvell.com> (sfid-20110721_021319_263691_45EAA059)
References: <1310615519-32112-1-git-send-email-bzhao@marvell.com>
 <1310615519-32112-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1310615519-32112-3-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Since the auto deep sleep mode has been enabled at driver init time
> we should disable it at driver unloading to shutdown the function
> gracefully.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

This patch and the following two patches

[PATCH] mwifiex: check SDIO multi-port aggregation buffer room correctly
[PATCH] mwifiex: put multicast/broadcast packets to the same RA

do not depend on the 'wireless.h' removal patch series.

If these 3 patches look OK could you please apply them?

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/ioctl.h     |    1 +
>  drivers/net/wireless/mwifiex/main.h      |    1 +
>  drivers/net/wireless/mwifiex/sdio.c      |    3 +++
>  drivers/net/wireless/mwifiex/sta_ioctl.c |   14 ++++++++++++++
>  4 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
> index 9929749..bd9e074 100644
> --- a/drivers/net/wireless/mwifiex/ioctl.h
> +++ b/drivers/net/wireless/mwifiex/ioctl.h
> @@ -249,6 +249,7 @@ struct mwifiex_ds_hs_cfg {
>  };
> 
>  #define DEEP_SLEEP_ON  1
> +#define DEEP_SLEEP_OFF 0
>  #define DEEP_SLEEP_IDLE_TIME	100
>  #define PS_MODE_AUTO		1
> 
> diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
> index 84f780d..e6db047 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -929,6 +929,7 @@ int mwifiex_set_hs_params(struct mwifiex_private *priv,
>  			      struct mwifiex_ds_hs_cfg *hscfg);
>  int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
>  int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
> +int mwifiex_disable_auto_ds(struct mwifiex_private *priv);
>  int mwifiex_get_signal_info(struct mwifiex_private *priv,
>  			    struct mwifiex_ds_get_signal *signal);
>  int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index f7105a9..82098ac 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -133,6 +133,9 @@ mwifiex_sdio_remove(struct sdio_func *func)
>  					adapter->priv[i]->media_connected)
>  				mwifiex_deauthenticate(adapter->priv[i], NULL);
> 
> +		mwifiex_disable_auto_ds(mwifiex_get_priv(adapter,
> +							 MWIFIEX_BSS_ROLE_ANY));
> +
>  		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
>  						MWIFIEX_BSS_ROLE_ANY),
>  					 MWIFIEX_FUNC_SHUTDOWN);
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index 6547013..10ef9e9 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -487,6 +487,20 @@ int mwifiex_set_radio_band_cfg(struct mwifiex_private *priv,
>  }
> 
>  /*
> + * The function disables auto deep sleep mode.
> + */
> +int mwifiex_disable_auto_ds(struct mwifiex_private *priv)
> +{
> +	struct mwifiex_ds_auto_ds auto_ds;
> +
> +	auto_ds.auto_ds = DEEP_SLEEP_OFF;
> +
> +	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
> +				     DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds);
> +}
> +EXPORT_SYMBOL_GPL(mwifiex_disable_auto_ds);
> +
> +/*
>   * IOCTL request handler to set/get active channel.
>   *
>   * This function performs validity checking on channel/frequency
> --
> 1.7.0.2

