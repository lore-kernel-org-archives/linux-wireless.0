Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39346 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755422AbeDYQLf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 12:11:35 -0400
Subject: Re: [PATCH] staging/wilc1000: fix wilc_mac_xmit()'s return type
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
References: <20180424131857.5668-1-luc.vanoostenryck@gmail.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <3c4bbd52-5af9-72b9-732b-f83f0bd23905@microchip.com> (sfid-20180425_181201_184977_95080D15)
Date: Wed, 25 Apr 2018 18:11:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180424131857.5668-1-luc.vanoostenryck@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luc,

I'm resending this since last time I only send it to staging ml.

Could you, please, change the "return 0;"s inside wilc_mac_xmit() with
"return NETDEV_TX_OK" ?

Thank you,
Claudiu

On 24.04.2018 15:18, Luc Van Oostenryck wrote:
> The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> which is a typedef for an enum type, but the implementation in this
> driver returns an 'int'.
> 
> Fix this by returning 'netdev_tx_t' in this driver too.
> 
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 2 +-
>  drivers/staging/wilc1000/wilc_wlan.h  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 38a83bd31..e06aaed5e 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -941,7 +941,7 @@ static void linux_wlan_tx_complete(void *priv, int status)
>  	kfree(pv_data);
>  }
>  
> -int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
> +netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
>  {
>  	struct wilc_vif *vif;
>  	struct tx_complete_data *tx_data = NULL;
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
