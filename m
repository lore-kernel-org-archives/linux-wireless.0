Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:15250 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbeHWLkw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 07:40:52 -0400
Subject: Re: [PATCH 23/24] staging: wilc1000: move 'wilc_connecting' static
 variable to 'wilc_vif' struct
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-24-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <bfaca799-849e-3f73-8259-14f500a07344@microchip.com> (sfid-20180823_101234_722309_1A9D4B47)
Date: Thu, 23 Aug 2018 11:12:20 +0300
MIME-Version: 1.0
In-Reply-To: <1534229416-13254-24-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.08.2018 09:50, Ajay Singh wrote:
> Move static variable 'wilc_connecting' as part of 'wilc_vif' private
> struct. Remove "wilc_" prefix from name as its already part of wilc_vif
> struct.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c         |  4 ++--
>  drivers/staging/wilc1000/host_interface.h         |  2 --
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 ++++++++----------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
>  4 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index f37ba64..d8cc08b 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -720,7 +720,7 @@ static void handle_scan(struct work_struct *work)
>  		goto error;
>  	}
>  
> -	if (vif->obtaining_ip || wilc_connecting) {
> +	if (vif->obtaining_ip || vif->connecting) {

As far as I can tell this is also set/read from different contexts, so, it
should also be protected by a locking mechanism. If not in this patch then
in a future one...

>  		netdev_err(vif->ndev, "Don't do obss scan\n");
>  		result = -EBUSY;
>  		goto error;
> @@ -2326,7 +2326,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
>  		goto error;
>  	}
>  
> -	if (vif->obtaining_ip || wilc_connecting) {
> +	if (vif->obtaining_ip || vif->connecting) {
>  		result = -EBUSY;
>  		goto error;
>  	}
> diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
> index 0f0d509..4048eab 100644
> --- a/drivers/staging/wilc1000/host_interface.h
> +++ b/drivers/staging/wilc1000/host_interface.h
> @@ -361,6 +361,4 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
>  
>  extern u8 wilc_connected_ssid[6];
>  
> -extern int wilc_connecting;
> -
>  #endif
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 35a83d4..cc44640 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -453,8 +453,6 @@ static inline bool wilc_cfg_scan_time_expired(struct wilc_priv *priv, int i)
>  		return false;
>  }
>  
> -int wilc_connecting;
> -
>  static void cfg_connect_result(enum conn_event conn_disconn_evt,
>  			       struct connect_info *conn_info,
>  			       u8 mac_status,
> @@ -468,7 +466,7 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
>  	struct host_if_drv *wfi_drv = priv->hif_drv;
>  	u8 null_bssid[ETH_ALEN] = {0};
>  
> -	wilc_connecting = 0;
> +	vif->connecting = 0;
>  
>  	if (conn_disconn_evt == CONN_DISCONN_EVENT_CONN_RESP) {
>  		u16 connect_status;
> @@ -666,7 +664,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
>  	enum authtype auth_type = ANY;
>  	u32 cipher_group;
>  
> -	wilc_connecting = 1;
> +	vif->connecting = 1;
>  
>  	if (!(strncmp(sme->ssid, "DIRECT-", 7)))
>  		wfi_drv->p2p_connect = 1;
> @@ -698,7 +696,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
>  		nw_info = &priv->scanned_shadow[sel_bssi_idx];
>  	} else {
>  		ret = -ENOENT;
> -		wilc_connecting = 0;
> +		vif->connecting = 0;
>  		return ret;
>  	}
>  
> @@ -741,7 +739,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
>  			ret = -ENOTSUPP;
>  			netdev_err(dev, "%s: Unsupported cipher\n",
>  				   __func__);
> -			wilc_connecting = 0;
> +			vif->connecting = 0;
>  			return ret;
>  		}
>  	}
> @@ -792,7 +790,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
>  	if (ret != 0) {
>  		netdev_err(dev, "wilc_set_join_req(): Error\n");
>  		ret = -ENOENT;
> -		wilc_connecting = 0;
> +		vif->connecting = 0;
>  		return ret;
>  	}
>  
> @@ -809,7 +807,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev,
>  	int ret;
>  	u8 null_bssid[ETH_ALEN] = {0};
>  
> -	wilc_connecting = 0;
> +	vif->connecting = 0;
>  
>  	if (!wilc)
>  		return -EIO;
> @@ -1747,7 +1745,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
>  
>  	switch (type) {
>  	case NL80211_IFTYPE_STATION:
> -		wilc_connecting = 0;
> +		vif->connecting = 0;
>  		dev->ieee80211_ptr->iftype = type;
>  		priv->wdev->iftype = type;
>  		vif->monitor_flag = 0;
> @@ -1762,7 +1760,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
>  		break;
>  
>  	case NL80211_IFTYPE_P2P_CLIENT:
> -		wilc_connecting = 0;
> +		vif->connecting = 0;
>  		dev->ieee80211_ptr->iftype = type;
>  		priv->wdev->iftype = type;
>  		vif->monitor_flag = 0;
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index 9d57adb..fd3e69e 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -151,6 +151,7 @@ struct wilc_vif {
>  	struct timer_list periodic_rssi;
>  	struct rf_info periodic_stat;
>  	struct tcp_ack_filter ack_filter;
> +	int connecting;
>  };
>  
>  struct wilc {
> 
