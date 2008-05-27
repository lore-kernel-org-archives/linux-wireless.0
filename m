Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYE0OM4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 10:12:56 -0400
Subject: Re: [PATCH] libertas: rate adaptation configuration via iwconfig.
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1211623189.540.2.camel@pmac.infradead.org>
References: <48375ef0.1ed6720a.75fe.ffff9c31@mx.google.com>
	 <1211623189.540.2.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Tue, 27 May 2008 10:11:04 -0400
Message-Id: <1211897464.1746.17.camel@localhost.localdomain> (sfid-20080527_161302_999547_F4765627)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-24 at 10:59 +0100, David Woodhouse wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> Implemented rate adaptation support via 'iwconfig rate' API.  It is now
> possible to specify a bit-rate value and append 'auto'.  That will configure
> rate adaptation to use all bit-rates equal or lower than than selected value.
> 
> Made lbs_cmd_802_11_rate_adapt_rateset a direct command.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> Restored the missing hunk from lbs_prepare_and_send_command() and made
> it apply to wireless-testing...
> 
>  drivers/net/wireless/libertas/assoc.c   |    2 
>  drivers/net/wireless/libertas/cmd.c     |   67 ++++++++++++++++++++++----------
>  drivers/net/wireless/libertas/cmd.h     |    2 
>  drivers/net/wireless/libertas/cmdresp.c |   20 ---------
>  drivers/net/wireless/libertas/dev.h     |    5 --
>  drivers/net/wireless/libertas/hostcmd.h |    2 
>  drivers/net/wireless/libertas/main.c    |    2 
>  drivers/net/wireless/libertas/rx.c      |    4 -
>  drivers/net/wireless/libertas/wext.c    |   27 ++++++++----
>  9 files changed, 75 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index 953a44f..a267d6e 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -1250,7 +1250,7 @@ static int get_common_rates(struct lbs_private *priv,
>  	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
>  	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
>  
> -	if (!priv->auto_rate) {
> +	if (!priv->enablehwauto) {
>  		for (i = 0; i < tmp_size; i++) {
>  			if (tmp[i] == priv->cur_rate)
>  				goto done;
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 2d9bbcc..e123ae0 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -676,26 +676,60 @@ static int lbs_cmd_802_11_monitor_mode(struct cmd_ds_command *cmd,
>  	return 0;
>  }
>  
> -static int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
> -					      struct cmd_ds_command *cmd,
> -					      u16 cmd_action)
> +static __le16 lbs_rate_to_fw_bitmap(int rate, int lower_rates_ok)
>  {
> -	struct cmd_ds_802_11_rate_adapt_rateset
> -	*rateadapt = &cmd->params.rateset;
> +/*		Bit  	Rate
> +*		15:13 Reserved
> +*		12    54 Mbps
> +*		11    48 Mbps
> +*		10    36 Mbps
> +*		9     24 Mbps
> +*		8     18 Mbps
> +*		7     12 Mbps
> +*		6     9 Mbps
> +*		5     6 Mbps
> +*		4     Reserved
> +*		3     11 Mbps
> +*		2     5.5 Mbps
> +*		1     2 Mbps
> +*		0     1 Mbps
> +**/
> +
> +	uint16_t ratemask;
> +	int i = lbs_data_rate_to_fw_index(rate);
> +	if (lower_rates_ok)
> +		ratemask = (0x1fef >> (12 - i));
> +	else
> +		ratemask = (1 << i);
> +	return cpu_to_le16(ratemask);
> +}
> +
> +int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
> +				      uint16_t cmd_action)
> +{
> +	struct cmd_ds_802_11_rate_adapt_rateset cmd;
> +	int ret;
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
> -	cmd->size =
> -	    cpu_to_le16(sizeof(struct cmd_ds_802_11_rate_adapt_rateset)
> -			     + S_DS_GEN);
> -	cmd->command = cpu_to_le16(CMD_802_11_RATE_ADAPT_RATESET);
>  
> -	rateadapt->action = cpu_to_le16(cmd_action);
> -	rateadapt->enablehwauto = cpu_to_le16(priv->enablehwauto);
> -	rateadapt->bitmap = cpu_to_le16(priv->ratebitmap);
> +	if (!priv->cur_rate && !priv->enablehwauto)
> +		return -EINVAL;
>  
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> +
> +	cmd.action = cpu_to_le16(cmd_action);
> +	cmd.enablehwauto = cpu_to_le16(priv->enablehwauto);
> +	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
> +	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
> +	if (!ret && cmd_action == CMD_ACT_GET) {
> +		priv->ratebitmap = le16_to_cpu(cmd.bitmap);
> +		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
> +	}
> +
> +	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
> +	return ret;
>  }
> +EXPORT_SYMBOL_GPL(lbs_cmd_802_11_rate_adapt_rateset);
>  
>  /**
>   *  @brief Set the data rate
> @@ -1378,11 +1412,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
>  						 cmd_action, pdata_buf);
>  		break;
>  
> -	case CMD_802_11_RATE_ADAPT_RATESET:
> -		ret = lbs_cmd_802_11_rate_adapt_rateset(priv,
> -							 cmdptr, cmd_action);
> -		break;
> -
>  	case CMD_802_11_MONITOR_MODE:
>  		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
>  				          cmd_action, pdata_buf);
> diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
> index 00d290e..a53b51f 100644
> --- a/drivers/net/wireless/libertas/cmd.h
> +++ b/drivers/net/wireless/libertas/cmd.h
> @@ -48,6 +48,8 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
>  int lbs_suspend(struct lbs_private *priv);
>  void lbs_resume(struct lbs_private *priv);
>  
> +int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
> +				      uint16_t cmd_action);
>  int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
>  				      uint16_t cmd_action, uint16_t *timeout);
>  int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index 4c3c5ec..24de3c3 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -203,22 +203,6 @@ static int lbs_ret_802_11_rf_tx_power(struct lbs_private *priv,
>  	return 0;
>  }
>  
> -static int lbs_ret_802_11_rate_adapt_rateset(struct lbs_private *priv,
> -					      struct cmd_ds_command *resp)
> -{
> -	struct cmd_ds_802_11_rate_adapt_rateset *rates = &resp->params.rateset;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -
> -	if (rates->action == CMD_ACT_GET) {
> -		priv->enablehwauto = le16_to_cpu(rates->enablehwauto);
> -		priv->ratebitmap = le16_to_cpu(rates->bitmap);
> -	}
> -
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  static int lbs_ret_802_11_rssi(struct lbs_private *priv,
>  				struct cmd_ds_command *resp)
>  {
> @@ -321,10 +305,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
>  	case CMD_RET(CMD_802_11_BEACON_STOP):
>  		break;
>  
> -	case CMD_RET(CMD_802_11_RATE_ADAPT_RATESET):
> -		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
> -		break;
> -
>  	case CMD_RET(CMD_802_11_RSSI):
>  		ret = lbs_ret_802_11_rssi(priv, resp);
>  		break;
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 0a9fc51..f5bb40c 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -237,8 +237,8 @@ struct lbs_private {
>  	/** 802.11 statistics */
>  //	struct cmd_DS_802_11_GET_STAT wlan802_11Stat;
>  
> -	u16 enablehwauto;
> -	u16 ratebitmap;
> +	uint16_t enablehwauto;
> +	uint16_t ratebitmap;
>  
>  	u32 fragthsd;
>  	u32 rtsthsd;
> @@ -296,7 +296,6 @@ struct lbs_private {
>  
>  	/** data rate stuff */
>  	u8 cur_rate;
> -	u8 auto_rate;
>  
>  	/** RF calibration data */
>  
> diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> index c36ab31..913b480 100644
> --- a/drivers/net/wireless/libertas/hostcmd.h
> +++ b/drivers/net/wireless/libertas/hostcmd.h
> @@ -500,6 +500,7 @@ struct cmd_ds_802_11_data_rate {
>  };
>  
>  struct cmd_ds_802_11_rate_adapt_rateset {
> +	struct cmd_header hdr;
>  	__le16 action;
>  	__le16 enablehwauto;
>  	__le16 bitmap;
> @@ -703,7 +704,6 @@ struct cmd_ds_command {
>  		struct cmd_ds_802_11_rf_tx_power txp;
>  		struct cmd_ds_802_11_rf_antenna rant;
>  		struct cmd_ds_802_11_monitor_mode monitor;
> -		struct cmd_ds_802_11_rate_adapt_rateset rateset;
>  		struct cmd_ds_802_11_ad_hoc_join adj;
>  		struct cmd_ds_802_11_rssi rssi;
>  		struct cmd_ds_802_11_rssi_rsp rssirsp;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index c37c15f..903e2df 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -1048,7 +1048,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
>  	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
>  	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
>  	priv->radioon = RADIO_ON;
> -	priv->auto_rate = 1;
> +	priv->enablehwauto = 1;
>  	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
>  	priv->psmode = LBS802_11POWERMODECAM;
>  	priv->psstate = PS_STATE_FULL_POWER;
> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index 05af731..5749f22 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
> @@ -237,7 +237,7 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>  	/* Take the data rate from the rxpd structure
>  	 * only if the rate is auto
>  	 */
> -	if (priv->auto_rate)
> +	if (priv->enablehwauto)
>  		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
>  
>  	lbs_compute_rssi(priv, p_rx_pd);
> @@ -383,7 +383,7 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
>  	/* Take the data rate from the rxpd structure
>  	 * only if the rate is auto
>  	 */
> -	if (priv->auto_rate)
> +	if (priv->enablehwauto)
>  		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
>  
>  	lbs_compute_rssi(priv, prxpd);
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index d4b19f1..8b3ed77 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -1021,29 +1021,38 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
>  
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  	lbs_deb_wext("vwrq->value %d\n", vwrq->value);
> +	lbs_deb_wext("vwrq->fixed %d\n", vwrq->fixed);
> +
> +	if (vwrq->fixed && vwrq->value == -1)
> +		goto out;
>  
>  	/* Auto rate? */
> -	if (vwrq->value == -1) {
> -		priv->auto_rate = 1;
> +	priv->enablehwauto = !vwrq->fixed;
> +
> +	if (vwrq->value == -1)
>  		priv->cur_rate = 0;
> -	} else {
> +	else {
>  		if (vwrq->value % 100000)
>  			goto out;
>  
> +		new_rate = vwrq->value / 500000;
> +		priv->cur_rate = new_rate;
> +		/* the rest is only needed for lbs_set_data_rate() */
>  		memset(rates, 0, sizeof(rates));
>  		copy_active_data_rates(priv, rates);
> -		new_rate = vwrq->value / 500000;
>  		if (!memchr(rates, new_rate, sizeof(rates))) {
>  			lbs_pr_alert("fixed data rate 0x%X out of range\n",
>  				new_rate);
>  			goto out;
>  		}
> -
> -		priv->cur_rate = new_rate;
> -		priv->auto_rate = 0;
>  	}
>  
> -	ret = lbs_set_data_rate(priv, new_rate);
> +	/* Try the newer command first (Firmware Spec 5.1 and above) */
> +	ret = lbs_cmd_802_11_rate_adapt_rateset(priv, CMD_ACT_SET);
> +
> +	/* Fallback to older version */
> +	if (ret)
> +		ret = lbs_set_data_rate(priv, new_rate);
>  
>  out:
>  	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
> @@ -1060,7 +1069,7 @@ static int lbs_get_rate(struct net_device *dev, struct iw_request_info *info,
>  	if (priv->connect_status == LBS_CONNECTED) {
>  		vwrq->value = priv->cur_rate * 500000;
>  
> -		if (priv->auto_rate)
> +		if (priv->enablehwauto)
>  			vwrq->fixed = 0;
>  		else
>  			vwrq->fixed = 1;
> 

