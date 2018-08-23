Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52139 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbeHWLi0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 07:38:26 -0400
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 09/24] staging: wilc1000: move static variable
 clients_count to 'wilc' structure
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-10-git-send-email-ajay.kathat@microchip.com>
Message-ID: <e56a014d-3df2-9977-8b5a-9793b2969ceb@microchip.com> (sfid-20180823_101017_732137_C0717C0E)
Date: Thu, 23 Aug 2018 11:09:56 +0300
MIME-Version: 1.0
In-Reply-To: <1534229416-13254-10-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.08.2018 09:50, Ajay Singh wrote:
> Avoid use of static variable 'clients_count' and move it part of 'wilc'
> structure.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c     | 9 ++++-----
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 6225e67..d930f06 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -199,7 +199,6 @@ static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
>  
>  static u8 set_ip[2][4];
>  static u8 get_ip[2][4];
> -static u32 clients_count;
>  
>  static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
>  
> @@ -3456,7 +3455,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
>  
>  	vif->obtaining_ip = false;
>  
> -	if (clients_count == 0) {
> +	if (wilc->clients_count == 0) {

The check of this should be mutex protected or a hif init/deinit should be
done in probe/remove code not not in open (I'm for the second approach).
Imagine this scenario:

vif 1: is down
vif 2: is down. "ifconfig vif2 up" is executed and the execution reach this
       point and then suspends after "if (wilc->clients_count == 0)" check
vif 1: "ifconfig vif1 up" and execution reach the end of this function and
       then the execution for vif 2 resumes. This will init twice the hif
       mutex, completion etc.

>  		init_completion(&hif_driver_comp);
>  		mutex_init(&hif_deinit_lock);
>  
> @@ -3490,7 +3489,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
>  
>  	mutex_unlock(&hif_drv->cfg_values_lock);
>  
> -	clients_count++;
> +	wilc->clients_count++;
>  
>  	return 0;
>  }
> @@ -3526,7 +3525,7 @@ int wilc_deinit(struct wilc_vif *vif)
>  
>  	hif_drv->hif_state = HOST_IF_IDLE;
>  
> -	if (clients_count == 1)	{
> +	if (vif->wilc->clients_count == 1) {
>  		struct host_if_msg *msg;
>  
>  		msg = wilc_alloc_work(vif, handle_hif_exit_work, true);
> @@ -3544,7 +3543,7 @@ int wilc_deinit(struct wilc_vif *vif)
>  
>  	kfree(hif_drv);
>  
> -	clients_count--;
> +	vif->wilc->clients_count--;
>  	terminated_handle = NULL;
>  	mutex_unlock(&hif_deinit_lock);
>  	return result;
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index 8e56a28..8cccbbc 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -171,6 +171,7 @@ struct wilc {
>  
>  	struct rf_info dummy_statistics;
>  	bool enable_ps;
> +	int clients_count;
>  };
>  
>  struct wilc_wfi_mon_priv {
> 
