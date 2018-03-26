Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:22217 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeCZRuu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:50:50 -0400
Subject: Re: [PATCH] staging: wilc1000: replace kmalloc + memcpy with kmemdup
To: Colin King <colin.king@canonical.com>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180326171629.28700-1-colin.king@canonical.com>
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Message-ID: <c65d1ac5-d5bc-3703-9516-45173a37bac4@wanadoo.fr> (sfid-20180326_195104_574983_46E1D648)
Date: Mon, 26 Mar 2018 19:50:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180326171629.28700-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 26/03/2018 à 19:16, Colin King a écrit :
> From: Colin Ian King <colin.king@canonical.com>
> 
> Replace several allocation and memcpys with kmemdup and add in some
> missing memory allocation failure checks.  Also fix an incorrect
> -EFAULT return with -ENOMEM.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/staging/wilc1000/host_interface.c | 75 +++++++++++++++++++------------
>   1 file changed, 46 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 9b9b86654958..8fd367f87fa5 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
[...]
>   
>   	hif_drv->usr_conn_req.ssid_len = conn_attr->ssid_len;
>   	if (conn_attr->ssid) {
> -		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
> +		hif_drv->usr_conn_req.ssid = kmemdup(conn_attr->ssid,
> +						     conn_attr->ssid_len + 1,
>   						     GFP_KERNEL);
>   		if (!hif_drv->usr_conn_req.ssid) {
>   			result = -ENOMEM;
>   			goto error;
>   		}
> -		memcpy(hif_drv->usr_conn_req.ssid,
> -		       conn_attr->ssid,
> -		       conn_attr->ssid_len);
 >               hif_drv->usr_conn_req.ssid[conn_attr->ssid_len] = '\0';

I don't know if it is an issue, but now the memcpy is 1 more byte 
(conn_attr->ssid_len   vs   conn_attr->ssid_len + 1)

kmemdup_nul(conn_attr->ssid, conn_attr->ssid_len, GFP_KERNEL)
and remove hif_drv->usr_conn_req.ssid[conn_attr->ssid_len] = '\0'  ?

CJ

[...]
