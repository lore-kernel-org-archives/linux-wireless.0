Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:13000 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeEBIXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 04:23:07 -0400
Subject: Re: [PATCH v2] staging/wilc1000: fix wilc_mac_xmit()'s return type
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
CC: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>
References: <3c4bbd52-5af9-72b9-732b-f83f0bd23905@microchip.com>
 <20180426205433.30308-1-luc.vanoostenryck@gmail.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <9fffc7d3-3388-6bf1-402d-385eca7733e2@microchip.com> (sfid-20180502_102311_867450_C428A20A)
Date: Wed, 2 May 2018 11:23:02 +0300
MIME-Version: 1.0
In-Reply-To: <20180426205433.30308-1-luc.vanoostenryck@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 26.04.2018 23:54, Luc Van Oostenryck wrote:
> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.
> 
> Fix this by returning 'netdev_tx_t' in this driver too
> and accordingly change 'return 0;' by 'return NETDEV_TX_OK;'
> 
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 8 ++++----
>  drivers/staging/wilc1000/wilc_wlan.h  | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 38a83bd31..d95b9750b 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -941,7 +941,7 @@ static void linux_wlan_tx_complete(void *priv, int status)
>  	kfree(pv_data);
>  }
>  
> -int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
> +netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)

Greg already applied your first version of this patch
"staging/wilc1000: fix wilc_mac_xmit()'s return type" so I will send a new
patch with only the "return NETDEV_TX_OK" changes.

And you can also add:
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

>  {
>  	struct wilc_vif *vif;
>  	struct tx_complete_data *tx_data = NULL;
> @@ -956,14 +956,14 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
>  
>  	if (skb->dev != ndev) {
>  		netdev_err(ndev, "Packet not destined to this device\n");
> -		return 0;
> +		return NETDEV_TX_OK;
>  	}
>  
>  	tx_data = kmalloc(sizeof(*tx_data), GFP_ATOMIC);
>  	if (!tx_data) {
>  		dev_kfree_skb(skb);
>  		netif_wake_queue(ndev);
> -		return 0;
> +		return NETDEV_TX_OK;
>  	}
>  
>  	tx_data->buff = skb->data;
> @@ -994,7 +994,7 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
>  		netif_stop_queue(wilc->vif[1]->ndev);
>  	}
>  
> -	return 0;
> +	return NETDEV_TX_OK;
>  }
>  
>  static int wilc_mac_close(struct net_device *ndev)
> diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
> index fa157a67b..d3b5a6b38 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.h
> +++ b/drivers/staging/wilc1000/wilc_wlan.h
> @@ -298,7 +298,7 @@ void wilc_chip_sleep_manually(struct wilc *wilc);
>  
>  void wilc_enable_tcp_ack_filter(bool value);
>  int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc);
> -int wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
> +netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
>  
>  void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
>  void host_wakeup_notify(struct wilc *wilc);
> 
