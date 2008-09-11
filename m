Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYIKPeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 11:34:14 -0400
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
From: Dan Williams <dcbw@redhat.com>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <48c86ed3.16be600a.2bc8.4c4e@mx.google.com>
References: <48c86ed3.16be600a.2bc8.4c4e@mx.google.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 11:34:59 -0400
Message-Id: <1221147299.771.24.camel@localhost.localdomain> (sfid-20080911_173419_091055_192E3942)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-10 at 16:45 -0700, Anna Neal wrote:
> Improved the tx power control configuration per Dan Williams suggestions. Added
> a firmware version check because the current implementation will only work for
> below version 9.
> 
> Signed-off-by: Anna Neal <anna@cozybit.com>

One more round, sorry! :)

First, until the patch has actually been applied, could you post
complete diffs?  This is a patch against the previous patch, but it's
best to keep the whole patch together until it's committed by John to
the master wireless tree.

Second, since you get to respin the patch anyway for this, the TPC
Config stuff should be just fine on V9+ firmware, only the
POWER_ADAPT_CFG command is incompatible on V9+.  I probably wasn't clear
enough about this yesterday.  Any chance you could move the TPC config
commands out of the firmware check and just the PACFG ones < V9?

Thanks!
Dan

> ---
>  drivers/net/wireless/libertas/cmd.c  |    4 +-
>  drivers/net/wireless/libertas/cmd.h  |    4 +-
>  drivers/net/wireless/libertas/wext.c |   44 +++++++++++++++++++++------------
>  3 files changed, 32 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 6cc4858..5fef05f 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -1983,7 +1983,7 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv)
>   *
>   * @return 0 on success
>   */
> -int lbs_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
> +int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
>  		int8_t p2, int usesnr)
>  {
>  	struct cmd_ds_802_11_tpc_cfg cmd;
> @@ -2015,7 +2015,7 @@ int lbs_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
>   * @return 0 on Success
>   */
>  
> -int lbs_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
> +int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
>  		int8_t p1, int8_t p2)
>  {
>  	struct cmd_ds_802_11_pa_cfg cmd;
> diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
> index 77bd070..336a181 100644
> --- a/drivers/net/wireless/libertas/cmd.h
> +++ b/drivers/net/wireless/libertas/cmd.h
> @@ -26,10 +26,10 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
>  	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
>  	      unsigned long callback_arg);
>  
> -int lbs_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
> +int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
>  		int8_t p1, int8_t p2);
>  
> -int lbs_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
> +int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
>  		int8_t p2, int usesnr);
>  
>  int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index b08bad8..8a81aca 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1823,14 +1823,20 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
>  		/* User requests automatic tx power control, however there are
>  		 * many auto tx settings.  For now use firmware defaults until
>  		 * we come up with a good way to expose these to the user. */
> -		ret = lbs_power_adapt_cfg(priv, 1, POW_ADAPT_DEFAULT_P0,
> -				POW_ADAPT_DEFAULT_P1, POW_ADAPT_DEFAULT_P2);
> -		if (ret)
> -			goto out;
> -		ret = lbs_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
> -				TPC_DEFAULT_P2, 1);
> -		if (ret)
> -			goto out;
> +		if (priv->fwrelease < 0x09000000) {
> +			ret = lbs_set_power_adapt_cfg(priv, 1,
> +					POW_ADAPT_DEFAULT_P0,
> +					POW_ADAPT_DEFAULT_P1,
> +					POW_ADAPT_DEFAULT_P2);
> +			if (ret)
> +				goto out;
> +			ret = lbs_set_tpc_cfg(priv, 0,
> +					TPC_DEFAULT_P0,
> +					TPC_DEFAULT_P1,
> +					TPC_DEFAULT_P2, 1);
> +			if (ret)
> +				goto out;
> +		}
>  		dbm = priv->txpower_max;
>  	} else {
>  		/* Userspace check in iwrange if it should use dBm or mW,
> @@ -1851,14 +1857,20 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
>  			ret = -EINVAL;
>  			goto out;
>  		}
> -		ret = lbs_power_adapt_cfg(priv, 0, POW_ADAPT_DEFAULT_P0,
> -				POW_ADAPT_DEFAULT_P1, POW_ADAPT_DEFAULT_P2);
> -		if (ret)
> -			goto out;
> -		ret = lbs_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
> -				TPC_DEFAULT_P2, 1);
> -		if (ret)
> -			goto out;
> +		if (priv->fwrelease < 0x09000000) {
> +			ret = lbs_set_power_adapt_cfg(priv, 0,
> +					POW_ADAPT_DEFAULT_P0,
> +					POW_ADAPT_DEFAULT_P1,
> +					POW_ADAPT_DEFAULT_P2);
> +			if (ret)
> +				goto out;
> +			ret = lbs_set_tpc_cfg(priv, 0,
> +					TPC_DEFAULT_P0,
> +					TPC_DEFAULT_P1,
> +					TPC_DEFAULT_P2, 1);
> +			if (ret)
> +				goto out;
> +		}
>  	}
>  
>  	/* If the radio was off, turn it on */

