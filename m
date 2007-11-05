Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXKEPWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 10:22:54 -0500
Subject: Re: [PATCH] libertas: Retry frame transmission when driver is busy.
From: Dan Williams <dcbw@redhat.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <472d2e3e.18b38c0a.2c31.1a76@mx.google.com>
References: <472d2e3e.18b38c0a.2c31.1a76@mx.google.com>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 10:20:41 -0500
Message-Id: <1194276041.18807.28.camel@localhost.localdomain> (sfid-20071105_152258_823599_9056EC0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-03 at 19:28 -0700, Ashish Shukla wrote:
> The driver silently discards frames when some command is pending -- returns
> NETDEV_TX_OK to kernel. The following patch fixes this problem.  This
> significantly improves file transfers while scanning (ticket #3341).
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> 
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 83d534b..f72ebe2 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -509,22 +509,25 @@ static int libertas_close(struct net_device *dev)
>  
>  static int libertas_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
> -	int ret = 0;
> +	int ret = NETDEV_TX_OK;
>  	wlan_private *priv = dev->priv;
>  
>  	lbs_deb_enter(LBS_DEB_NET);
>  
> -	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
> -		priv->stats.tx_dropped++;
> -		goto done;
> -	}
> -
>  	netif_stop_queue(priv->dev);
>  	if (priv->mesh_dev)
>  		netif_stop_queue(priv->mesh_dev);
>  
> -	if (libertas_process_tx(priv, skb) == 0)
> +	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
> +		ret = NETDEV_TX_BUSY;
> +		goto done;
> +	}
> +
> +	ret = libertas_process_tx(priv, skb);
> +	if (ret == NETDEV_TX_OK)
>  		dev->trans_start = jiffies;
> +	else if (ret == -1)
> +		ret = NETDEV_TX_OK;

The one concern I have here (and I admit I don't know much about network
driver TX paths) is that SendSinglePacket() will return -1 on error
(like adapter got removed), which returns to libertas_process_tx() which
returns here and would then return NETDEV_TX_OK.  Is that an OK thing to
do?

Dan

>  done:
>  	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
>  	return ret;
> diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
> index bc9c2e1..1dc92ee 100644
> --- a/drivers/net/wireless/libertas/tx.c
> +++ b/drivers/net/wireless/libertas/tx.c
> @@ -218,6 +218,7 @@ int libertas_process_tx(wlan_private * priv, struct sk_buff *skb)
>  	if (priv->dnld_sent) {
>  		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
>  		       priv->dnld_sent);
> +		ret = NETDEV_TX_BUSY;
>  		goto done;
>  	}
>  

