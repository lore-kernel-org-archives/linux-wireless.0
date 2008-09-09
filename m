Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbYIIViq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 17:38:46 -0400
Subject: Re: [PATCH] libertas: Enable/disable automatic tx power control
	via SIOCSIWTXPOW.
From: Dan Williams <dcbw@redhat.com>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <48c1c0c1.1b068e0a.343f.ffffcb0d@mx.google.com>
References: <48c1c0c1.1b068e0a.343f.ffffcb0d@mx.google.com>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 17:39:33 -0400
Message-Id: <1220996373.25237.18.camel@localhost.localdomain> (sfid-20080909_233851_239128_770BA78F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-05 at 15:56 -0700, Anna Neal wrote:
> iwconfig txpower can now be used to set tx power to fixed or auto. If set to
> auto the default firmware settings are used.
> 
> Signed-off-by: Anna Neal <anna@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/libertas/cmd.c     |   64 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/libertas/cmd.h     |    6 +++
>  drivers/net/wireless/libertas/defs.h    |    9 ++++
>  drivers/net/wireless/libertas/host.h    |    1 +
>  drivers/net/wireless/libertas/hostcmd.h |   24 +++++++++--
>  drivers/net/wireless/libertas/wext.c    |   23 ++++++++++-
>  6 files changed, 120 insertions(+), 7 deletions(-)

Thanks for the patch!  A few things...

> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 802547e..6cc4858 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -1971,6 +1971,70 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv)
>  }
>  
> 
> +/**
> + * @brief Configures the transmission power control functionality.
> + *
> + * @param priv		A pointer to struct lbs_private structure
> + * @param enable	Transmission power control enable
> + * @param p0		Power level when link quality is good (dBm).
> + * @param p1		Power level when link quality is fair (dBm).
> + * @param p2		Power level when link quality is poor (dBm).
> + * @param usesnr	Use Signal to Noise Ratio in TPC
> + *
> + * @return 0 on success
> + */
> +int lbs_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
> +		int8_t p2, int usesnr)

Can we rename this to lbs_set_tpc_cfg()?  It's a setter, and there could
be a getter later, best to be clear about this.

> +{
> +	struct cmd_ds_802_11_tpc_cfg cmd;
> +	int ret;
> +
> +	memset(&cmd, 0, sizeof(cmd));
> +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> +	cmd.action = cpu_to_le16(CMD_ACT_SET);
> +	cmd.enable = !!enable;
> +	cmd.usesnr = !!enable;
> +	cmd.P0 = p0;
> +	cmd.P1 = p1;
> +	cmd.P2 = p2;
> +
> +	ret = lbs_cmd_with_response(priv, CMD_802_11_TPC_CFG, &cmd);
> +
> +	return ret;
> +}
> +
> +/**
> + * @brief Configures the power adaptation settings.
> + *
> + * @param priv		A pointer to struct lbs_private structure
> + * @param enable	Power adaptation enable
> + * @param p0		Power level for 1, 2, 5.5 and 11 Mbps (dBm).
> + * @param p1		Power level for 6, 9, 12, 18, 22, 24 and 36 Mbps (dBm).
> + * @param p2		Power level for 48 and 54 Mbps (dBm).
> + *
> + * @return 0 on Success
> + */
> +
> +int lbs_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
> +		int8_t p1, int8_t p2)

Same here, can we change this to lbs_set_pa_cfg() or
lbs_set_power_adapt_cfg() ?

> +{
> +	struct cmd_ds_802_11_pa_cfg cmd;
> +	int ret;
> +
> +	memset(&cmd, 0, sizeof(cmd));
> +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> +	cmd.action = cpu_to_le16(CMD_ACT_SET);
> +	cmd.enable = !!enable;
> +	cmd.P0 = p0;
> +	cmd.P1 = p1;
> +	cmd.P2 = p2;

And this isn't compatible with the V9 and later firmware, which uses the
PowerAdapt_Group_t Marvell IE.  I'd suggest defining two different
commands, one for V8 and below which uses the format you have here, and
one for V9 and above which uses the new format.  I have no idea what the
fields in PA_Group_t are, but I'm sure you can find out since you're
from CozyBit :)

> +	ret = lbs_cmd_with_response(priv, CMD_802_11_PA_CFG , &cmd);
> +
> +	return ret;
> +}
> +
> +
>  static struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
>  	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
>  	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
> diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
> index 11ac996..77bd070 100644
> --- a/drivers/net/wireless/libertas/cmd.h
> +++ b/drivers/net/wireless/libertas/cmd.h
> @@ -26,6 +26,12 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
>  	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
>  	      unsigned long callback_arg);
>  
> +int lbs_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
> +		int8_t p1, int8_t p2);
> +
> +int lbs_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
> +		int8_t p2, int usesnr);
> +
>  int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
>  		     struct cmd_header *resp);
>  
> diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
> index 4b2428a..c89d7a1 100644
> --- a/drivers/net/wireless/libertas/defs.h
> +++ b/drivers/net/wireless/libertas/defs.h
> @@ -189,6 +189,15 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
>  #define MRVDRV_CMD_UPLD_RDY		0x0008
>  #define MRVDRV_CARDEVENT		0x0010
>  
> +
> +/* Automatic TX control default levels */
> +#define POW_ADAPT_DEFAULT_P0 13
> +#define POW_ADAPT_DEFAULT_P1 15
> +#define POW_ADAPT_DEFAULT_P2 18
> +#define TPC_DEFAULT_P0 5
> +#define TPC_DEFAULT_P1 10
> +#define TPC_DEFAULT_P2 13
> +
>  /** TxPD status */
>  
>  /*	Station firmware use TxPD status field to report final Tx transmit
> diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> index da618fc..a916bb9 100644
> --- a/drivers/net/wireless/libertas/host.h
> +++ b/drivers/net/wireless/libertas/host.h
> @@ -83,6 +83,7 @@
>  #define CMD_802_11_INACTIVITY_TIMEOUT		0x0067
>  #define CMD_802_11_SLEEP_PERIOD			0x0068
>  #define CMD_802_11_TPC_CFG			0x0072
> +#define CMD_802_11_PA_CFG			0x0073

Should also:

#define CMD_802_11_POWER_ADAPT_CFG_EXT  0x0073   /* v9 firmware and above */

and use that in the v9+ lbs_set_power_adapt_cfg_ext() function.

>  #define CMD_802_11_FW_WAKE_METHOD		0x0074
>  #define CMD_802_11_SUBSCRIBE_EVENT		0x0075
>  #define CMD_802_11_RATE_ADAPT_RATESET		0x0076
> diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> index d27c276..630b799 100644
> --- a/drivers/net/wireless/libertas/hostcmd.h
> +++ b/drivers/net/wireless/libertas/hostcmd.h
> @@ -607,14 +607,28 @@ struct cmd_ds_802_11_eeprom_access {
>  } __attribute__ ((packed));
>  
>  struct cmd_ds_802_11_tpc_cfg {
> +	struct cmd_header hdr;
> +
>  	__le16 action;
> -	u8 enable;
> -	s8 P0;
> -	s8 P1;
> -	s8 P2;
> -	u8 usesnr;
> +	uint8_t enable;
> +	int8_t P0;
> +	int8_t P1;
> +	int8_t P2;
> +	uint8_t usesnr;
>  } __attribute__ ((packed));
>  
> +
> +struct cmd_ds_802_11_pa_cfg {
> +	struct cmd_header hdr;
> +
> +	__le16 action;
> +	uint8_t enable;
> +	int8_t P0;
> +	int8_t P1;
> +	int8_t P2;
> +} __attribute__ ((packed));
> +
> +

And for v9:

struct pa_group {
	u16 level;
	u16 rate_map;
	u32 reserved;
}

struct mrvl_ie_pa_group {
	mrvlietypes_header hdr;
	struct pa_group groups[5];
}

struct cmd_ds_802_11_pa_cfg_ext {
	struct cmd_header hdr;

	__le16 action;
	u16 enable;
	struct mrvl_ie_pa_group pa_groups;
}

note that there isn't an existing GPL implementation of
POWER_ADAPT_CFG_EXT either at moblin or anywhere else, so I can't
suggest what to fill in for the rate_map and level of struct pa_group in
the implementation.  Ask Luis or Javier I guess since they probably have
access to that information.

>  struct cmd_ds_802_11_led_ctrl {
>  	__le16 action;
>  	__le16 numled;
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index 426f1fe..b08bad8 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1820,7 +1820,17 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
>  	}
>  
>  	if (vwrq->fixed == 0) {
> -		/* Auto power control */
> +		/* User requests automatic tx power control, however there are
> +		 * many auto tx settings.  For now use firmware defaults until
> +		 * we come up with a good way to expose these to the user. */
> +		ret = lbs_power_adapt_cfg(priv, 1, POW_ADAPT_DEFAULT_P0,
> +				POW_ADAPT_DEFAULT_P1, POW_ADAPT_DEFAULT_P2);

and do the firmware check right here and call lbs_set_power_adapt_cfg()
for V8 and lower, and lbs_set_power_adapt_cfg_ext() for v9 and higher
like so:

if (priv->fwrelease >= 0x09000000) {
	ret = lbs_power_adapt_cfg_ext(...);
} else {
	ret = lbs_power_adapt_cfg(...);
}

Thanks again!
Dan

> +		if (ret)
> +			goto out;
> +		ret = lbs_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
> +				TPC_DEFAULT_P2, 1);
> +		if (ret)
> +			goto out;
>  		dbm = priv->txpower_max;
>  	} else {
>  		/* Userspace check in iwrange if it should use dBm or mW,
> @@ -1830,7 +1840,8 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
>  			goto out;
>  		}
>  
> -		/* Validate requested power level against firmware allowed levels */
> +		/* Validate requested power level against firmware allowed
> +		 * levels */
>  		if (priv->txpower_min && (dbm < priv->txpower_min)) {
>  			ret = -EINVAL;
>  			goto out;
> @@ -1840,6 +1851,14 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
>  			ret = -EINVAL;
>  			goto out;
>  		}
> +		ret = lbs_power_adapt_cfg(priv, 0, POW_ADAPT_DEFAULT_P0,
> +				POW_ADAPT_DEFAULT_P1, POW_ADAPT_DEFAULT_P2);
> +		if (ret)
> +			goto out;
> +		ret = lbs_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
> +				TPC_DEFAULT_P2, 1);
> +		if (ret)
> +			goto out;
>  	}
>  
>  	/* If the radio was off, turn it on */

