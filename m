Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:17367 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbeEINoR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:44:17 -0400
Subject: Re: [PATCH 06/30] staging: wilc1000: fix line over 80 chars issue in
 host_int_handle_disconnect()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-7-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <f25c13fc-3dbb-cc17-7e37-ad72b69b0664@microchip.com> (sfid-20180509_154420_117248_1BB7161F)
Date: Wed, 9 May 2018 16:44:13 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-7-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Fix line over 80 char issue in host_int_handle_disconnect() by using
> temp variable to hold the 'wilc_connect_result' function pointer.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index a341ff1..0d84af9 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1401,6 +1401,7 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
>  {
>  	struct disconnect_info disconn_info;
>  	struct host_if_drv *hif_drv = vif->hif_drv;
> +	wilc_connect_result conn_result = hif_drv->usr_conn_req.conn_result;
>  

Is there a scenario you can end up here with a null hif_drv? I'm seeing that some
of the functions from this layer are checking for hif_drv at the beginning, some
are not.


>  	memset(&disconn_info, 0, sizeof(struct disconnect_info));
>  
> @@ -1413,13 +1414,12 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
>  	disconn_info.ie = NULL;
>  	disconn_info.ie_len = 0;
>  
> -	if (hif_drv->usr_conn_req.conn_result) {
> +	if (conn_result) {
>  		wilc_optaining_ip = false;
>  		wilc_set_power_mgmt(vif, 0, 0);
>  
> -		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF,
> -						  NULL, 0, &disconn_info,
> -						  hif_drv->usr_conn_req.arg);
> +		conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL, 0,
> +			    &disconn_info, hif_drv->usr_conn_req.arg);
>  	} else {
>  		netdev_err(vif->ndev, "Connect result NULL\n");
>  	}
> 
