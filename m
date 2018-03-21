Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:53752 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752954AbeCUUDX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 16:03:23 -0400
Message-ID: <1521662598.7999.33.camel@perches.com> (sfid-20180321_210346_479527_056BBF8A)
Subject: Re: [PATCH] staging: wilc1000: check for kmalloc allocation failures
From: Joe Perches <joe@perches.com>
To: Colin King <colin.king@canonical.com>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2018 13:03:18 -0700
In-Reply-To: <20180321191941.4126-1-colin.king@canonical.com>
References: <20180321191941.4126-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 19:19 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are three kmalloc allocations that are not null checked which
> potentially could lead to null pointer dereference issues. Fix this
> by adding null pointer return checks.

looks like all of these should be kmemdup or kstrdup

> Detected by CoverityScan, CID#1466025-27 ("Dereference null return")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 5082ede720f0..9b9b86654958 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -944,6 +944,10 @@ static s32 handle_connect(struct wilc_vif *vif,
>  
>  	if (conn_attr->bssid) {
>  		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
> +		if (!hif_drv->usr_conn_req.bssid) {
> +			result = -ENOMEM;
> +			goto error;
> +		}
>  		memcpy(hif_drv->usr_conn_req.bssid, conn_attr->bssid, 6);
>  	}
>  
> @@ -951,6 +955,10 @@ static s32 handle_connect(struct wilc_vif *vif,
>  	if (conn_attr->ssid) {
>  		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
>  						     GFP_KERNEL);
> +		if (!hif_drv->usr_conn_req.ssid) {
> +			result = -ENOMEM;
> +			goto error;
> +		}
>  		memcpy(hif_drv->usr_conn_req.ssid,
>  		       conn_attr->ssid,
>  		       conn_attr->ssid_len);
> @@ -961,6 +969,10 @@ static s32 handle_connect(struct wilc_vif *vif,
>  	if (conn_attr->ies) {
>  		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len,
>  						    GFP_KERNEL);
> +		if (!hif_drv->usr_conn_req.ies) {
> +			result = -ENOMEM;
> +			goto error;
> +		}
>  		memcpy(hif_drv->usr_conn_req.ies,
>  		       conn_attr->ies,
>  		       conn_attr->ies_len);
