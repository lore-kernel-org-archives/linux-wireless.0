Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1GSPbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 11:31:15 -0400
Subject: Re: [PATCH 4/4] libertas: reimplement mesh channel selection
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Tue, 19 Jul 2011 10:34:50 -0500
In-Reply-To: <20110717170346.45A739D401C@zog.reactivated.net>
References: <20110717170346.45A739D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311089696.2647.4.camel@dcbw.foobar.com> (sfid-20110719_173119_180261_377E4B9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-07-17 at 18:03 +0100, Daniel Drake wrote:
> This reimplements code allowing for mesh channel selection according
> to how NetworkManager expects.

Originally I was trying to get away from magical functions that used
variables of the internal private structure to change state, ie moving
most of the actual data for the firmware commands to the function
argument list instead of accessing priv->xxxx internally.  The idea
there was that it would be easier to follow the code flow through the
driver if you knew that these functions weren't touching all sorts of
internal variables.  Any chance we can preserve that?  Thoughts?  That
was my intent at least but it's not set in stone.

Dan

> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/dev.h  |    1 +
>  drivers/net/wireless/libertas/mesh.c |   79 ++++++++++++++++++++++++++++------
>  2 files changed, 67 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 8a43ec0..0329238 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -48,6 +48,7 @@ struct lbs_private {
>  	uint16_t mesh_tlv;
>  	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
>  	u8 mesh_ssid_len;
> +	short mesh_channel;
>  #endif
>  
>  	/* Debugfs */
> diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
> index be72c08..ade3770 100644
> --- a/drivers/net/wireless/libertas/mesh.c
> +++ b/drivers/net/wireless/libertas/mesh.c
> @@ -88,15 +88,14 @@ static int lbs_mesh_config_send(struct lbs_private *priv,
>   * are all handled by preparing a struct cmd_ds_mesh_config and passing it to
>   * lbs_mesh_config_send.
>   */
> -static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
> -		uint16_t chan)
> +static int lbs_mesh_config(struct lbs_private *priv, uint16_t action)
>  {
>  	struct cmd_ds_mesh_config cmd;
>  	struct mrvl_meshie *ie;
>  	DECLARE_SSID_BUF(ssid);
>  
>  	memset(&cmd, 0, sizeof(cmd));
> -	cmd.channel = cpu_to_le16(chan);
> +	cmd.channel = cpu_to_le16(priv->mesh_channel);
>  	ie = (struct mrvl_meshie *)cmd.data;
>  
>  	switch (action) {
> @@ -123,7 +122,7 @@ static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
>  		return -1;
>  	}
>  	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
> -		    action, priv->mesh_tlv, chan,
> +		    action, priv->mesh_tlv, priv->mesh_channel,
>  		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
>  
>  	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
> @@ -803,6 +802,61 @@ static void lbs_persist_config_remove(struct net_device *dev)
>  
> 
>  /***************************************************************************
> + * WEXT handlers
> + */
> +
> +static int mesh_get_name(struct net_device *dev,
> +    struct iw_request_info *info, char *name, char *extra)
> +{
> +	strcpy(name, "IEEE 802.11b/g OLPC Mesh");
> +	return 0;
> +}
> +
> +static int mesh_get_freq(struct net_device *dev,
> +    struct iw_request_info *info, struct iw_freq *freq, char *extra)
> +{
> +	struct lbs_private *priv = dev->ml_priv;
> +	freq->e = 0;
> +	freq->m = priv->mesh_channel;
> +	return 0;
> +}
> +
> +static int mesh_set_freq(struct net_device *dev,
> +    struct iw_request_info *info, struct iw_freq *freq, char *extra)
> +{
> +	struct lbs_private *priv = dev->ml_priv;
> +	short channel = 0;
> +
> +	if (freq->e == 0)
> +		channel = freq->m;
> +	else {
> +		channel = ieee80211_freq_to_dsss_chan(freq->m);
> +		if (channel < 0)
> +			channel = 1;
> +	}
> +
> +	priv->mesh_channel = channel;
> +
> +	if (netif_running(dev))
> +		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START);
> +
> +	return 0;
> +}
> +
> +static const iw_handler mesh_iw_handler[] =
> +{
> +	IW_HANDLER(SIOCGIWNAME, (iw_handler) mesh_get_name),
> +	IW_HANDLER(SIOCGIWFREQ, (iw_handler) mesh_get_freq),
> +	IW_HANDLER(SIOCSIWFREQ, (iw_handler) mesh_set_freq),
> +};
> +
> +static const struct iw_handler_def mesh_iw_handler_def = {
> +	.num_standard	= ARRAY_SIZE(mesh_iw_handler),
> +	.standard 	= mesh_iw_handler,
> +};
> +
> +
> +/***************************************************************************
>   * Initializing and starting, stopping mesh
>   */
>  
> @@ -837,11 +891,9 @@ int lbs_init_mesh(struct lbs_private *priv)
>  		   useful */
>  
>  		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
> -		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
> -				    priv->channel)) {
> +		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START)) {
>  			priv->mesh_tlv = TLV_TYPE_MESH_ID;
> -			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
> -					    priv->channel))
> +			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START))
>  				priv->mesh_tlv = 0;
>  		}
>  	} else
> @@ -851,13 +903,12 @@ int lbs_init_mesh(struct lbs_private *priv)
>  		 * 0x100+37; Do not invoke command with old TLV.
>  		 */
>  		priv->mesh_tlv = TLV_TYPE_MESH_ID;
> -		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
> -				    priv->channel))
> +		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START))
>  			priv->mesh_tlv = 0;
>  	}
>  
>  	/* Stop meshing until interface is brought up */
> -	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
> +	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP);
>  
>  	if (priv->mesh_tlv) {
>  		sprintf(priv->mesh_ssid, "mesh");
> @@ -904,7 +955,7 @@ static int lbs_mesh_stop(struct net_device *dev)
>  	struct lbs_private *priv = dev->ml_priv;
>  
>  	lbs_deb_enter(LBS_DEB_MESH);
> -	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
> +	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP);
>  
>  	spin_lock_irq(&priv->driver_lock);
>  
> @@ -947,7 +998,7 @@ static int lbs_mesh_dev_open(struct net_device *dev)
>  
>  	spin_unlock_irq(&priv->driver_lock);
>  
> -	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, priv->channel);
> +	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START);
>  
>  out:
>  	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
> @@ -984,8 +1035,10 @@ static int lbs_add_mesh(struct lbs_private *priv)
>  	}
>  	mesh_dev->ml_priv = priv;
>  	priv->mesh_dev = mesh_dev;
> +	priv->mesh_channel = 1;
>  
>  	mesh_dev->netdev_ops = &mesh_netdev_ops;
> +	mesh_dev->wireless_handlers = &mesh_iw_handler_def;
>  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
>  	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
>  


