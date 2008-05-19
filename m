Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYESPxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 11:53:34 -0400
Subject: Re: [PATCH] libertas: fix multicast filtering on eth and msh
	interfaces.
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211208955.21380.163.camel@pmac.infradead.org>
References: <1211208955.21380.163.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Mon, 19 May 2008 11:53:21 -0400
Message-Id: <1211212401.12187.11.camel@localhost.localdomain> (sfid-20080519_175338_653618_9410FE2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-19 at 15:55 +0100, David Woodhouse wrote:
> We weren't properly handling multicast on the mesh interface. Fix that,
> which involves setting up the hardware to use the union of dev->mc_list
> for both eth%d and msh%d devices.
> 
> This means we can't do it directly from ->set_multicast_list() because
> we'd need to lock the other device to read its list, and we can't do
> that because it might deadlock. So punt the actual work to keventd. 
> 
> Also, invoke the same when taking an interface down; for some reason the
> core calls ->set_multicast_list while IFF_UP is still set in dev->flags
> when we're taking it down, so its addresses don't get removed then.
> 
> We also convert MAC_MULTICAST_ADR to a direct command while we're at it,
> removing one more entry from the big switch statement in the deprecated
> lbs_prepare_and_send_command() function. Change the priority of the
> 'unknown command' warnings in that switch statement too, because we
> really do want to know about it if it happens.
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Looks OK to me.  Nothing obvious.

Acked-by: Dan Williams <dcbw@redhat.com>

> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 6328b95..2473ba8 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -778,28 +778,6 @@ out:
>  	return ret;
>  }
>  
> -static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
> -				      struct cmd_ds_command *cmd,
> -				      u16 cmd_action)
> -{
> -	struct cmd_ds_mac_multicast_adr *pMCastAdr = &cmd->params.madr;
> -
> -	lbs_deb_enter(LBS_DEB_CMD);
> -	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_multicast_adr) +
> -			     S_DS_GEN);
> -	cmd->command = cpu_to_le16(CMD_MAC_MULTICAST_ADR);
> -
> -	lbs_deb_cmd("MULTICAST_ADR: setting %d addresses\n", pMCastAdr->nr_of_adrs);
> -	pMCastAdr->action = cpu_to_le16(cmd_action);
> -	pMCastAdr->nr_of_adrs =
> -	    cpu_to_le16((u16) priv->nr_of_multicastmacaddr);
> -	memcpy(pMCastAdr->maclist, priv->multicastlist,
> -	       priv->nr_of_multicastmacaddr * ETH_ALEN);
> -
> -	lbs_deb_leave(LBS_DEB_CMD);
> -	return 0;
> -}
> -
>  /**
>   *  @brief Get the radio channel
>   *
> @@ -1279,8 +1257,7 @@ void lbs_set_mac_control(struct lbs_private *priv)
>  	cmd.action = cpu_to_le16(priv->mac_control);
>  	cmd.reserved = 0;
>  
> -	lbs_cmd_async(priv, CMD_MAC_CONTROL,
> -		&cmd.hdr, sizeof(cmd));
> +	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
>  
>  	lbs_deb_leave(LBS_DEB_CMD);
>  }
> @@ -1392,10 +1369,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
>  							 cmdptr, cmd_action);
>  		break;
>  
> -	case CMD_MAC_MULTICAST_ADR:
> -		ret = lbs_cmd_mac_multicast_adr(priv, cmdptr, cmd_action);
> -		break;
> -
>  	case CMD_802_11_MONITOR_MODE:
>  		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
>  				          cmd_action, pdata_buf);
> @@ -1484,7 +1457,7 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
>  		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
>  		break;
>  	default:
> -		lbs_deb_host("PREP_CMD: unknown command 0x%04x\n", cmd_no);
> +		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
>  		ret = -1;
>  		break;
>  	}
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index 5abecb7..4c3c5ec 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -316,7 +316,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
>  
>  		break;
>  
> -	case CMD_RET(CMD_MAC_MULTICAST_ADR):
>  	case CMD_RET(CMD_802_11_RESET):
>  	case CMD_RET(CMD_802_11_AUTHENTICATE):
>  	case CMD_RET(CMD_802_11_BEACON_STOP):
> @@ -376,8 +375,8 @@ static inline int handle_cmd_response(struct lbs_private *priv,
>  		break;
>  
>  	default:
> -		lbs_deb_host("CMD_RESP: unknown cmd response 0x%04x\n",
> -			     le16_to_cpu(resp->command));
> +		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
> +			   le16_to_cpu(resp->command));
>  		break;
>  	}
>  	lbs_deb_leave(LBS_DEB_HOST);
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 0d9edb9..e12ce65 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -140,6 +140,8 @@ struct lbs_private {
>  	wait_queue_head_t waitq;
>  	struct workqueue_struct *work_thread;
>  
> +	struct work_struct mcast_work;
> +
>  	/** Scanning */
>  	struct delayed_work scan_work;
>  	struct delayed_work assoc_work;
> diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> index f29bc5b..c36ab31 100644
> --- a/drivers/net/wireless/libertas/hostcmd.h
> +++ b/drivers/net/wireless/libertas/hostcmd.h
> @@ -219,6 +219,7 @@ struct cmd_ds_mac_control {
>  };
>  
>  struct cmd_ds_mac_multicast_adr {
> +	struct cmd_header hdr;
>  	__le16 action;
>  	__le16 nr_of_adrs;
>  	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
> @@ -703,7 +704,6 @@ struct cmd_ds_command {
>  		struct cmd_ds_802_11_rf_antenna rant;
>  		struct cmd_ds_802_11_monitor_mode monitor;
>  		struct cmd_ds_802_11_rate_adapt_rateset rateset;
> -		struct cmd_ds_mac_multicast_adr madr;
>  		struct cmd_ds_802_11_ad_hoc_join adj;
>  		struct cmd_ds_802_11_rssi rssi;
>  		struct cmd_ds_802_11_rssi_rsp rssirsp;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 406f54d..80b35da 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -11,6 +11,7 @@
>  #include <linux/if_arp.h>
>  #include <linux/kthread.h>
>  #include <linux/kfifo.h>
> +#include <linux/stddef.h>
>  
>  #include <net/iw_handler.h>
>  #include <net/ieee80211.h>
> @@ -425,6 +426,7 @@ static int lbs_dev_open(struct net_device *dev)
>  	return ret;
>  }
>  
> +static void lbs_set_multicast_list(struct net_device *dev);
>  /**
>   *  @brief This function closes the mshX interface
>   *
> @@ -446,6 +448,8 @@ static int lbs_mesh_stop(struct net_device *dev)
>  
>  	spin_unlock_irq(&priv->driver_lock);
>  
> +	schedule_work(&priv->mcast_work);
> +
>  	lbs_deb_leave(LBS_DEB_MESH);
>  	return 0;
>  }
> @@ -467,6 +471,8 @@ static int lbs_eth_stop(struct net_device *dev)
>  	netif_stop_queue(dev);
>  	spin_unlock_irq(&priv->driver_lock);
>  
> +	schedule_work(&priv->mcast_work);
> +
>  	lbs_deb_leave(LBS_DEB_NET);
>  	return 0;
>  }
> @@ -563,89 +569,115 @@ done:
>  	return ret;
>  }
>  
> -static int lbs_copy_multicast_address(struct lbs_private *priv,
> -				     struct net_device *dev)
> -{
> -	int i = 0;
> -	struct dev_mc_list *mcptr = dev->mc_list;
>  
> -	for (i = 0; i < dev->mc_count; i++) {
> -		memcpy(&priv->multicastlist[i], mcptr->dmi_addr, ETH_ALEN);
> -		mcptr = mcptr->next;
> +static inline int mac_in_list(unsigned char *list, int list_len,
> +			      unsigned char *mac)
> +{
> +	while (list_len) {
> +		if (!memcmp(list, mac, ETH_ALEN))
> +			return 1;
> +		list += ETH_ALEN;
> +		list_len--;
>  	}
> -	return i;
> +	return 0;
>  }
>  
> -static void lbs_set_multicast_list(struct net_device *dev)
> +static void lbs_set_mcast_worker(struct work_struct *work)
>  {
> -	struct lbs_private *priv = dev->priv;
> -	int old_mac_control;
> +	struct lbs_private *priv = container_of(work, struct lbs_private, mcast_work);
> +	struct cmd_ds_mac_multicast_adr mcast_cmd;
> +	struct net_device *dev;
> +	struct dev_mc_list *mc_list;
>  	DECLARE_MAC_BUF(mac);
> +	int dev_flags;
> +	int i, nr_eth_addrs;
> +	int old_mac_control = priv->mac_control;
>  
> -	lbs_deb_enter(LBS_DEB_NET);
> +	lbs_deb_enter(LBS_DEB_MAIN);
>  
> -	old_mac_control = priv->mac_control;
> +	dev_flags = dev_get_flags(priv->dev);
> +	if (priv->mesh_dev)
> +		dev_flags |= dev_get_flags(priv->mesh_dev);
> +
> +	if (dev_flags & IFF_PROMISC) {
> +		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
> +		priv->mac_control &= ~(CMD_ACT_MAC_ALL_MULTICAST_ENABLE |
> +				       CMD_ACT_MAC_MULTICAST_ENABLE);
> +		goto out_set_mac_control;
> +	} else if (dev_flags & IFF_ALLMULTI) {
> +	do_allmulti:
> +		priv->mac_control |= CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
> +		priv->mac_control &= ~(CMD_ACT_MAC_PROMISCUOUS_ENABLE |
> +				       CMD_ACT_MAC_MULTICAST_ENABLE);
> +		goto out_set_mac_control;
> +	}
>  
> -	if (dev->flags & IFF_PROMISC) {
> -		lbs_deb_net("enable promiscuous mode\n");
> -		priv->mac_control |=
> -		    CMD_ACT_MAC_PROMISCUOUS_ENABLE;
> -		priv->mac_control &=
> -		    ~(CMD_ACT_MAC_ALL_MULTICAST_ENABLE |
> -		      CMD_ACT_MAC_MULTICAST_ENABLE);
> -	} else {
> -		/* Multicast */
> -		priv->mac_control &=
> -		    ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
> -
> -		if (dev->flags & IFF_ALLMULTI || dev->mc_count >
> -		    MRVDRV_MAX_MULTICAST_LIST_SIZE) {
> -			lbs_deb_net( "enabling all multicast\n");
> -			priv->mac_control |=
> -			    CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
> -			priv->mac_control &=
> -			    ~CMD_ACT_MAC_MULTICAST_ENABLE;
> -		} else {
> -			priv->mac_control &=
> -			    ~CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
> -
> -			if (!dev->mc_count) {
> -				lbs_deb_net("no multicast addresses, "
> -				       "disabling multicast\n");
> -				priv->mac_control &=
> -				    ~CMD_ACT_MAC_MULTICAST_ENABLE;
> -			} else {
> -				int i;
> -
> -				priv->mac_control |=
> -				    CMD_ACT_MAC_MULTICAST_ENABLE;
> -
> -				priv->nr_of_multicastmacaddr =
> -				    lbs_copy_multicast_address(priv, dev);
> -
> -				lbs_deb_net("multicast addresses: %d\n",
> -				       dev->mc_count);
> -
> -				for (i = 0; i < dev->mc_count; i++) {
> -					lbs_deb_net("Multicast address %d: %s\n",
> -					       i, print_mac(mac,
> -					       priv->multicastlist[i]));
> -				}
> -				/* send multicast addresses to firmware */
> -				lbs_prepare_and_send_command(priv,
> -						      CMD_MAC_MULTICAST_ADR,
> -						      CMD_ACT_SET, 0, 0,
> -						      NULL);
> +	i = 0;
> +	nr_eth_addrs = 0;
> +
> +	/* Once for priv->dev, again for priv->mesh_dev if it exists */
> +	for (dev = priv->dev; dev;
> +	     dev = (dev==priv->mesh_dev?NULL:priv->mesh_dev)) {
> +		if ((dev_get_flags(dev) & (IFF_UP|IFF_MULTICAST)) != 
> +		    (IFF_UP|IFF_MULTICAST))
> +			continue;
> +
> +		netif_tx_lock_bh(dev);		
> +		for (mc_list = dev->mc_list; mc_list; mc_list = mc_list->next) {
> +
> +			if (mac_in_list(mcast_cmd.maclist, nr_eth_addrs,
> +					mc_list->dmi_addr)) {
> +				lbs_deb_net("mcast address %s:%s skipped\n",
> +					    dev->name,
> +					    print_mac(mac, mc_list->dmi_addr));
> +				continue;
>  			}
> +
> +			if (i == MRVDRV_MAX_MULTICAST_LIST_SIZE)
> +				break;
> +			memcpy(&mcast_cmd.maclist[6*i], mc_list->dmi_addr,
> +			       ETH_ALEN);
> +			lbs_deb_net("mcast address %s:%s added to filter\n",
> +				    dev->name,
> +				    print_mac(mac, mc_list->dmi_addr));
> +			i++;
>  		}
> +		netif_tx_unlock_bh(dev);
> +		if (mc_list)
> +			goto do_allmulti;
> +
> +		nr_eth_addrs = i;
>  	}
>  
> +	if (i) {
> +		int size = offsetof(struct cmd_ds_mac_multicast_adr, maclist[6*i]);
> +		
> +		mcast_cmd.action = cpu_to_le16(CMD_ACT_SET);
> +		mcast_cmd.hdr.size = cpu_to_le16(size);
> +		mcast_cmd.nr_of_adrs = cpu_to_le16(i);
> +
> +		lbs_cmd_async(priv, CMD_MAC_MULTICAST_ADR, &mcast_cmd.hdr, size);
> +
> +		priv->mac_control |= CMD_ACT_MAC_MULTICAST_ENABLE;
> +	} else
> +		priv->mac_control &= ~CMD_ACT_MAC_MULTICAST_ENABLE;
> +
> +	priv->mac_control &= ~(CMD_ACT_MAC_PROMISCUOUS_ENABLE |
> +			       CMD_ACT_MAC_ALL_MULTICAST_ENABLE);
> + out_set_mac_control:
>  	if (priv->mac_control != old_mac_control)
>  		lbs_set_mac_control(priv);
>  
>  	lbs_deb_leave(LBS_DEB_NET);
>  }
>  
> +static void lbs_set_multicast_list(struct net_device *dev)
> +{
> +	struct lbs_private *priv = dev->priv;
> +
> +	schedule_work(&priv->mcast_work);
> +}
> +
>  /**
>   *  @brief This function handles the major jobs in the LBS driver.
>   *  It handles all events generated by firmware, RX data received
> @@ -1133,6 +1165,7 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
>  	priv->work_thread = create_singlethread_workqueue("lbs_worker");
>  	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
>  	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
> +	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
>  	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
>  
>  	sprintf(priv->mesh_ssid, "mesh");
> @@ -1169,6 +1202,7 @@ int lbs_remove_card(struct lbs_private *priv)
>  
>  	cancel_delayed_work(&priv->scan_work);
>  	cancel_delayed_work(&priv->assoc_work);
> +	cancel_work_sync(&priv->mcast_work);
>  	destroy_workqueue(priv->work_thread);
>  
>  	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
> @@ -1331,6 +1365,8 @@ static int lbs_add_mesh(struct lbs_private *priv)
>  #ifdef	WIRELESS_EXT
>  	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
>  #endif
> +	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
> +	mesh_dev->set_multicast_list = lbs_set_multicast_list;
>  	/* Register virtual mesh interface */
>  	ret = register_netdev(mesh_dev);
>  	if (ret) {
> @@ -1562,7 +1598,6 @@ static int lbs_add_rtap(struct lbs_private *priv)
>  	rtap_dev->stop = lbs_rtap_stop;
>  	rtap_dev->get_stats = lbs_rtap_get_stats;
>  	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
> -	rtap_dev->set_multicast_list = lbs_set_multicast_list;
>  	rtap_dev->priv = priv;
>  
>  	ret = register_netdev(rtap_dev);
> 

