Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:18410 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbeC0FLC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 01:11:02 -0400
Date: Tue, 27 Mar 2018 10:40:54 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Colin King <colin.king@canonical.com>
CC: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: replace kmalloc + memcpy with
 kmemdup
Message-ID: <20180327104054.69479b47@ajaysk-VirtualBox> (sfid-20180327_071119_391830_C72D3B0F)
In-Reply-To: <20180326171629.28700-1-colin.king@canonical.com>
References: <20180326171629.28700-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Mar 2018 18:16:29 +0100
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Replace several allocation and memcpys with kmemdup and add in some
> missing memory allocation failure checks.  Also fix an incorrect 
> -EFAULT return with -ENOMEM.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 75 +++++++++++++++++++------------
>  1 file changed, 46 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 9b9b86654958..8fd367f87fa5 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -797,6 +797,10 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
>  	for (i = 0; i < hidden_net->n_ssids; i++)
>  		valuesize += ((hidden_net->net_info[i].ssid_len) + 1);
>  	hdn_ntwk_wid_val = kmalloc(valuesize + 1, GFP_KERNEL);
> +	if (!hdn_ntwk_wid_val) {
> +		result = -ENOMEM;
> +		goto error;
> +	}

Please do not apply this changes. It will change the code
flow differently. Check for NULl value in '(wid_list[index].val)' is 
already presented.  It has to proceed with the below flow instead of
returning from there.

>  	wid_list[index].val = hdn_ntwk_wid_val;
>  	if (wid_list[index].val) {
>  		buffer = wid_list[index].val;
> @@ -943,39 +947,35 @@ static s32 handle_connect(struct wilc_vif *vif,
>  	}
>  
>  	if (conn_attr->bssid) {
> -		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
> +		hif_drv->usr_conn_req.bssid = kmemdup(conn_attr->bssid, 6,
> +						      GFP_KERNEL);
>  		if (!hif_drv->usr_conn_req.bssid) {
>  			result = -ENOMEM;
>  			goto error;
>  		}
> -		memcpy(hif_drv->usr_conn_req.bssid, conn_attr->bssid, 6);
>  	}
>  
>  	hif_drv->usr_conn_req.ssid_len = conn_attr->ssid_len;
>  	if (conn_attr->ssid) {
> -		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
> +		hif_drv->usr_conn_req.ssid = kmemdup(conn_attr->ssid,
> +						     conn_attr->ssid_len + 1,
>  						     GFP_KERNEL);

Sorry, I too missed to see that scenario. As suggested, kmemdup can not be
used directly to replace kmalloc & memcpy in this case. The size used for
kmalloc is not equal to size of data copy in memcpy i.e kmalloc is done
for 1 byte extra to keep the NULL character. The direct replacement of
kmalloc with kmemdup is not applicable here.


>  		if (!hif_drv->usr_conn_req.ssid) {
>  			result = -ENOMEM;
>  			goto error;
>  		}
> -		memcpy(hif_drv->usr_conn_req.ssid,
> -		       conn_attr->ssid,
> -		       conn_attr->ssid_len);
>  		hif_drv->usr_conn_req.ssid[conn_attr->ssid_len] = '\0';
>  	}
>  
>  	hif_drv->usr_conn_req.ies_len = conn_attr->ies_len;
>  	if (conn_attr->ies) {
> -		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len,
> +		hif_drv->usr_conn_req.ies = kmemdup(conn_attr->ies,
> +						    conn_attr->ies_len,
>  						    GFP_KERNEL);
>  		if (!hif_drv->usr_conn_req.ies) {
>  			result = -ENOMEM;
>  			goto error;
>  		}
> -		memcpy(hif_drv->usr_conn_req.ies,
> -		       conn_attr->ies,
> -		       conn_attr->ies_len);
>  	}
>  
>  	hif_drv->usr_conn_req.security = conn_attr->security;
> @@ -1009,9 +1009,12 @@ static s32 handle_connect(struct wilc_vif *vif,
>  
>  	if (memcmp("DIRECT-", conn_attr->ssid, 7)) {
>  		info_element_size = hif_drv->usr_conn_req.ies_len;
> -		info_element = kmalloc(info_element_size, GFP_KERNEL);
> -		memcpy(info_element, hif_drv->usr_conn_req.ies,
> -		       info_element_size);
> +		info_element = kmemdup(hif_drv->usr_conn_req.ies,
> +				       info_element_size, GFP_KERNEL);
> +		if (!info_element) {
> +			result = -ENOMEM;
> +			goto error;
> +		}
>  	}

"info_element" variable was removed in my previous submitted patchset.
Those changes are still not included in Greg's staging repo. Few changes
in this patch are already included in previous patchset,which might give
conflict. But few changes are not present which can be applied like
returning -ENOMEM in case of allocation failure.


Regards,
Ajay
