Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from panicking.kicks-ass.org ([95.141.38.207]:41773 "EHLO
	panicking.kicks-ass.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1DHJnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 05:43:10 -0400
Subject: Re: [PATCH RFC 2/3] libertas: add set_power callback for iface
 subdrivers
From: Alberto Panizzo <alberto@amarulasolutions.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <1302207960-28536-3-git-send-email-anarsoul@gmail.com>
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
	 <1302207960-28536-3-git-send-email-anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 11:10:53 +0200
Message-ID: <1302253853.2649.28.camel@realization>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasily,

On Thu, 2011-04-07 at 23:25 +0300, Vasily Khoruzhick wrote:
> Add set_power callback, so driver can disable device when
> interface is down or before going into suspend
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  drivers/net/wireless/libertas/cmd.c  |   18 ++++-
>  drivers/net/wireless/libertas/dev.h  |    3 +-
>  drivers/net/wireless/libertas/main.c |  177 ++++++++++++++++++++++------------
>  3 files changed, 135 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 7e8a658..d0e7df6 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -84,6 +84,7 @@ static u8 is_command_allowed_in_ps(u16 cmd)
>  int lbs_update_hw_spec(struct lbs_private *priv)
>  {
>  	struct cmd_ds_get_hw_spec cmd;
> +	struct cmd_ds_802_11_mac_address hw_addr_cmd;
>  	int ret = -1;
>  	u32 i;
>  
> @@ -151,8 +152,20 @@ int lbs_update_hw_spec(struct lbs_private *priv)
>  			memcpy(priv->mesh_dev->dev_addr,
>  				priv->current_addr, ETH_ALEN);
>  		priv->copied_hwaddr = 1;
> +	} else {
> +		/* Copy addr back to hw */
> +		memcpy(priv->current_addr, priv->dev->dev_addr, ETH_ALEN);
> +		hw_addr_cmd.hdr.size = cpu_to_le16(sizeof(hw_addr_cmd));
> +		hw_addr_cmd.action = cpu_to_le16(CMD_ACT_SET);
> +		memcpy(hw_addr_cmd.macadd, priv->current_addr, ETH_ALEN);
> +
> +		ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS,
> +			&hw_addr_cmd);
> +		if (ret)
> +			lbs_deb_net("set MAC address failed\n");

Does this be really related to the subject of the patch?

>  	}
>  
> +

And this new line?

>  out:
>  	lbs_deb_leave(LBS_DEB_CMD);
>  	return ret;
> @@ -1111,6 +1124,7 @@ out:
>  
>  void lbs_set_mac_control(struct lbs_private *priv)
>  {
> +	int ret;
>  	struct cmd_ds_mac_control cmd;
>  
>  	lbs_deb_enter(LBS_DEB_CMD);
> @@ -1119,7 +1133,9 @@ void lbs_set_mac_control(struct lbs_private *priv)
>  	cmd.action = cpu_to_le16(priv->mac_control);
>  	cmd.reserved = 0;
>  
> -	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
> +	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
> +	if (ret)
> +		lbs_deb_net("set MAC control failed\n");

Same here.

>  
>  	lbs_deb_leave(LBS_DEB_CMD);
>  }
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index bc461eb..9a873bc 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -90,12 +90,13 @@ struct lbs_private {
>  	void *card;
>  	u8 fw_ready;
>  	u8 surpriseremoved;
> -	u8 setup_fw_on_resume;
> +	int power_on_cnt;
>  	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
>  	void (*reset_card) (struct lbs_private *priv);
>  	int (*enter_deep_sleep) (struct lbs_private *priv);
>  	int (*exit_deep_sleep) (struct lbs_private *priv);
>  	int (*reset_deep_sleep_wakeup) (struct lbs_private *priv);
> +	void (*set_power) (struct lbs_private *priv, int enable);
>  
>  	/* Adapter info (from EEPROM) */
>  	u32 fwrelease;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index ca8149c..7922ead 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -89,6 +89,73 @@ u8 lbs_data_rate_to_fw_index(u32 rate)
>  	return 0;
>  }
>  
> +/**
> + * @brief This function gets the HW spec from the firmware and sets
> + *        some basic parameters.
> + *
> + *  @param priv    A pointer to struct lbs_private structure
> + *  @return        0 or -1
> + */
> +static int lbs_setup_firmware(struct lbs_private *priv)
> +{
> +	int ret = -1;
> +	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
> +
> +	lbs_deb_enter(LBS_DEB_FW);
> +
> +	/* Read MAC address from firmware */
> +	memset(priv->current_addr, 0xff, ETH_ALEN);
> +	ret = lbs_update_hw_spec(priv);
> +	if (ret)
> +		goto done;
> +
> +	/* Read power levels if available */
> +	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
> +	if (ret == 0) {
> +		priv->txpower_cur = curlevel;
> +		priv->txpower_min = minlevel;
> +		priv->txpower_max = maxlevel;
> +	}
> +
> +	/* Send cmd to FW to enable 11D function */
> +	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
> +
> +	lbs_set_mac_control(priv);
> +done:
> +	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
> +	return ret;
> +

Same for this function

> }
> +
> +/**
> + *  @brief This function enables device
> + *
> + *  @param priv    A pointer to struct lbs_private structure
> + */
> +static void lbs_power_on(struct lbs_private *priv)
> +{
> +	if (priv->set_power) {
> +		priv->power_on_cnt++;
> +		if (priv->power_on_cnt == 1) {

Here you have room for race conditions. power_on_cnt should be 
protected by a mutex.

> +			priv->set_power(priv, 1);
> +			lbs_setup_firmware(priv);

Do you think that all users needs 8002.11D?

> +			lbs_init_mesh(priv);
> +		}
> +	}
> +}

Ah, now I understand why the previous.. 


> +
> +/**
> + *  @brief This function disables device
> + *
> + *  @param priv    A pointer to struct lbs_private structure
> + */
> +static void lbs_power_off(struct lbs_private *priv)
> +{
> +	if (priv->set_power) {
> +		priv->power_on_cnt--;
> +		if (priv->power_on_cnt == 0)

Same here for race conditions.

> +			priv->set_power(priv, 0);
> +	}
> +}
>  
>  /**
>   *  @brief This function opens the ethX interface
> @@ -103,6 +170,8 @@ static int lbs_dev_open(struct net_device *dev)
>  
>  	lbs_deb_enter(LBS_DEB_NET);
>  
> +	lbs_power_on(priv);
> +
>  	spin_lock_irq(&priv->driver_lock);
>  	priv->stopping = false;
>  
> @@ -136,13 +205,14 @@ static int lbs_eth_stop(struct net_device *dev)
>  	netif_stop_queue(dev);
>  	spin_unlock_irq(&priv->driver_lock);
>  
> -	schedule_work(&priv->mcast_work);
>  	cancel_delayed_work_sync(&priv->scan_work);
>  	if (priv->scan_req) {
>  		cfg80211_scan_done(priv->scan_req, false);
>  		priv->scan_req = NULL;
>  	}
>  
> +	lbs_power_off(priv);
> +
>  	lbs_deb_leave(LBS_DEB_NET);
>  	return 0;
>  }
> @@ -201,15 +271,16 @@ int lbs_set_mac_address(struct net_device *dev, void *addr)
>  
>  	/* In case it was called from the mesh device */
>  	dev = priv->dev;
> +	if (priv->power_on_cnt) {

Same here, you need at least a read lock.

> +		cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> +		cmd.action = cpu_to_le16(CMD_ACT_SET);
> +		memcpy(cmd.macadd, phwaddr->sa_data, ETH_ALEN);
>  
> -	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> -	cmd.action = cpu_to_le16(CMD_ACT_SET);
> -	memcpy(cmd.macadd, phwaddr->sa_data, ETH_ALEN);
> -
> -	ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS, &cmd);
> -	if (ret) {
> -		lbs_deb_net("set MAC address failed\n");
> -		goto done;
> +		ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS, &cmd);
> +		if (ret) {
> +			lbs_deb_net("set MAC address failed\n");
> +			goto done;
> +		}
>  	}
>  
>  	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
> @@ -539,59 +610,27 @@ static int lbs_thread(void *data)
>  	return 0;
>  }
>  
> -/**
> - * @brief This function gets the HW spec from the firmware and sets
> - *        some basic parameters.
> - *
> - *  @param priv    A pointer to struct lbs_private structure
> - *  @return        0 or -1
> - */
> -static int lbs_setup_firmware(struct lbs_private *priv)
> -{
> -	int ret = -1;
> -	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
> -
> -	lbs_deb_enter(LBS_DEB_FW);
> -
> -	/* Read MAC address from firmware */
> -	memset(priv->current_addr, 0xff, ETH_ALEN);
> -	ret = lbs_update_hw_spec(priv);
> -	if (ret)
> -		goto done;
> -
> -	/* Read power levels if available */
> -	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
> -	if (ret == 0) {
> -		priv->txpower_cur = curlevel;
> -		priv->txpower_min = minlevel;
> -		priv->txpower_max = maxlevel;
> -	}
> -
> -	/* Send cmd to FW to enable 11D function */
> -	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
> -
> -	lbs_set_mac_control(priv);
> -done:
> -	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
> -	return ret;
> -}
> -
>  int lbs_suspend(struct lbs_private *priv)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	lbs_deb_enter(LBS_DEB_FW);
>  
> -	if (priv->is_deep_sleep) {
> -		ret = lbs_set_deep_sleep(priv, 0);
> -		if (ret) {
> -			lbs_pr_err("deep sleep cancellation failed: %d\n", ret);
> -			return ret;
> +	if (priv->set_power)
> +		lbs_power_off(priv);

Do you really want to power off the chip on suspend only because 
set_power exist?
Is this something that should be driven by userspace?

And don't you want to setup any wake conditions?

> +	else {
> +		if (priv->is_deep_sleep) {
> +			ret = lbs_set_deep_sleep(priv, 0);
> +			if (ret) {
> +				lbs_pr_err(
> +				  "deep sleep cancellation failed: %d\n", ret);
> +				return ret;
> +			}
> +			priv->deep_sleep_required = 1;
>  		}
> -		priv->deep_sleep_required = 1;
> -	}
>  
> -	ret = lbs_set_host_sleep(priv, 1);
> +		ret = lbs_set_host_sleep(priv, 1);
> +	}
>  
>  	netif_device_detach(priv->dev);
>  	if (priv->mesh_dev)
> @@ -604,26 +643,26 @@ EXPORT_SYMBOL_GPL(lbs_suspend);
>  
>  int lbs_resume(struct lbs_private *priv)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	lbs_deb_enter(LBS_DEB_FW);
>  
> -	ret = lbs_set_host_sleep(priv, 0);
> +	if (priv->set_power)
> +		lbs_power_on(priv);
> +	else
> +		ret = lbs_set_host_sleep(priv, 0);
>  
>  	netif_device_attach(priv->dev);
>  	if (priv->mesh_dev)
>  		netif_device_attach(priv->mesh_dev);
>  
> -	if (priv->deep_sleep_required) {
> +	if (!priv->set_power && priv->deep_sleep_required) {
>  		priv->deep_sleep_required = 0;
>  		ret = lbs_set_deep_sleep(priv, 1);
>  		if (ret)
>  			lbs_pr_err("deep sleep activation failed: %d\n", ret);
>  	}
>  
> -	if (priv->setup_fw_on_resume)
> -		ret = lbs_setup_firmware(priv);
> -
>  	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
>  	return ret;
>  }
> @@ -917,6 +956,9 @@ void lbs_remove_card(struct lbs_private *priv)
>  	priv->surpriseremoved = 1;
>  	kthread_stop(priv->main_thread);
>  
> +	/* Disable card power if it's still on */
> +	lbs_power_off(priv);
> +
>  	lbs_free_adapter(priv);
>  	lbs_cfg_free(priv);
>  	free_netdev(dev);
> @@ -944,6 +986,16 @@ int lbs_start_card(struct lbs_private *priv)
>  
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  
> +	/* We're not using lbs_power_on here because we don't want
> +	 * to setup firmware twice.
> +	 * TODO: replace following code with lbs_power_on() when set_power
> +	 * callback become mandatory.
> +	 */
> +	if (priv->set_power) {
> +		priv->power_on_cnt++;
> +		priv->set_power(priv, 1);
> +	}
> +
>  	/* poke the firmware */
>  	ret = lbs_setup_firmware(priv);
>  	if (ret)
> @@ -964,6 +1016,9 @@ int lbs_start_card(struct lbs_private *priv)
>  
>  	ret = 0;
>  
> +	/* Init is done, so we can disable card power */
> +	lbs_power_off(priv);
> +
>  done:
>  	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
>  	return ret;


