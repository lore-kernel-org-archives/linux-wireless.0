Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:57386 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbeHWLj5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 07:39:57 -0400
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 12/24] staging: wilc1000: move static variable
 'terminated_handle' to wilc_vif struct
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-13-git-send-email-ajay.kathat@microchip.com>
Message-ID: <8e7928a5-1d9f-d36e-f7b2-dbbbddff94ae@microchip.com> (sfid-20180823_101352_186003_8A6DCB12)
Date: Thu, 23 Aug 2018 11:11:18 +0300
MIME-Version: 1.0
In-Reply-To: <1534229416-13254-13-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.08.2018 09:50, Ajay Singh wrote:
> Remove the use of static variable 'terminated_handle' and instead move
> in wilc_vif struct.
> After moving this variable to wilc_vif struct its not required to keep
> 'terminated_handle', so changed it to boolean type.

You can remove it at all and use wilc->hif_deinit_lock mutex also in
wilc_scan_complete_received() and wilc_network_info_received() it is used
in wilc_gnrl_async_info_received().

> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c     | 11 +++++------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index d5d81843..f71f451f 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -185,7 +185,6 @@ struct join_bss_param {
>  	u8 start_time[4];
>  };
>  
> -static struct host_if_drv *terminated_handle;
>  static u8 p2p_listen_state;
>  static struct timer_list periodic_rssi;
>  static struct wilc_vif *periodic_rssi_vif;
> @@ -3505,7 +3504,7 @@ int wilc_deinit(struct wilc_vif *vif)
>  
>  	mutex_lock(&vif->wilc->hif_deinit_lock);
>  
> -	terminated_handle = hif_drv;
> +	vif->is_termination_progress = true;
>  
>  	del_timer_sync(&hif_drv->scan_timer);
>  	del_timer_sync(&hif_drv->connect_timer);
> @@ -3543,7 +3542,7 @@ int wilc_deinit(struct wilc_vif *vif)
>  	kfree(hif_drv);
>  
>  	vif->wilc->clients_count--;
> -	terminated_handle = NULL;
> +	vif->is_termination_progress = false;
>  	mutex_unlock(&vif->wilc->hif_deinit_lock);
>  	return result;
>  }
> @@ -3565,7 +3564,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
>  		return;
>  	hif_drv = vif->hif_drv;
>  
> -	if (!hif_drv || hif_drv == terminated_handle) {
> +	if (!hif_drv || vif->is_termination_progress) {
>  		netdev_err(vif->ndev, "driver not init[%p]\n", hif_drv);
>  		return;
>  	}
> @@ -3611,7 +3610,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
>  
>  	hif_drv = vif->hif_drv;
>  
> -	if (!hif_drv || hif_drv == terminated_handle) {
> +	if (!hif_drv || vif->is_termination_progress) {
>  		mutex_unlock(&wilc->hif_deinit_lock);
>  		return;
>  	}
> @@ -3662,7 +3661,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
>  		return;
>  	hif_drv = vif->hif_drv;
>  
> -	if (!hif_drv || hif_drv == terminated_handle)
> +	if (!hif_drv || vif->is_termination_progress)
>  		return;
>  
>  	if (hif_drv->usr_scan_req.scan_result) {
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index eb00e42..ba606d0 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -121,6 +121,7 @@ struct wilc_vif {
>  	struct timer_list during_ip_timer;
>  	bool obtaining_ip;
>  	u8 mc_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
> +	bool is_termination_progress;
>  };
>  
>  struct wilc {
> 
