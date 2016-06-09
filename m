Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36018 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbcFIIL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 04:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <1465232558-31678-3-git-send-email-javier@osg.samsung.com>
References: <1465232558-31678-1-git-send-email-javier@osg.samsung.com> <1465232558-31678-3-git-send-email-javier@osg.samsung.com>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Thu, 9 Jun 2016 10:11:54 +0200
Message-ID: <CAFqH_51ysBHYfC9vTNDKFW9T9HX+LEf4-56xN56jf8Usz_gQ3Q@mail.gmail.com> (sfid-20160609_101233_391406_3DE347A4)
Subject: Re: [PATCH v2 2/3] mwifiex: move .get_tx_power logic to station ioctl file
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Julian Calaby <julian.calaby@gmail.com>,
	Shengzhen Li <szli@marvell.com>,
	Enric Balletbo i Serra <enric.balletbo@collabora.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-06-06 19:02 GMT+02:00 Javier Martinez Canillas <javier@osg.samsung.com>:
> From: Shengzhen Li <szli@marvell.com>
>
> Most cfg80211 operations are just a wrappers to functions defined in the
> sta_ioctl.c file, so for consistency move the .get_tx_power logic there.
>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> [javier: update the subject line and commit message]
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>
> ---
>
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 14 +++-----------
>  drivers/net/wireless/marvell/mwifiex/main.h      |  2 ++
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 18 ++++++++++++++++++
>  3 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index b17f3d09a2c7..ff3f63ed95e1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -385,18 +385,10 @@ mwifiex_cfg80211_get_tx_power(struct wiphy *wiphy,
>                               int *dbm)
>  {
>         struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
> -       struct mwifiex_private *priv = mwifiex_get_priv(adapter,
> -                                                       MWIFIEX_BSS_ROLE_ANY);
> -       int ret = mwifiex_send_cmd(priv, HostCmd_CMD_RF_TX_PWR,
> -                                  HostCmd_ACT_GEN_GET, 0, NULL, true);
> -
> -       if (ret < 0)
> -               return ret;
> -
> -       /* tx_power_level is set in HostCmd_CMD_RF_TX_PWR command handler */
> -       *dbm = priv->tx_power_level;
> +       struct mwifiex_private *priv;
>
> -       return 0;
> +       priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
> +       return mwifiex_get_tx_power(priv, dbm);
>  }
>
>  /*
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 0207af00be42..79c28cfb7780 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -1464,6 +1464,8 @@ int mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter,
>  int mwifiex_set_tx_power(struct mwifiex_private *priv,
>                          struct mwifiex_power_cfg *power_cfg);
>
> +int mwifiex_get_tx_power(struct mwifiex_private *priv, int *dbm);
> +
>  int mwifiex_main_process(struct mwifiex_adapter *);
>
>  int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb);
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> index 8e0862657122..70ff9b805b5b 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> @@ -775,6 +775,24 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
>  }
>
>  /*
> + * IOCTL request handler to get tx power configuration.
> + *
> + * This function prepares the correct firmware command and
> + * issues it.
> + */
> +int mwifiex_get_tx_power(struct mwifiex_private *priv, int *dbm)
> +{
> +       int ret;
> +
> +       ret = mwifiex_send_cmd(priv, HostCmd_CMD_TXPWR_CFG,
> +                              HostCmd_ACT_GEN_GET, 0, NULL, true);
> +
> +       *dbm = priv->tx_power_level;
> +
> +       return ret;
> +}
> +
> +/*
>   * IOCTL request handler to get power save mode.
>   *
>   * This function prepares the correct firmware command and
> --
> 2.5.5
>

Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
