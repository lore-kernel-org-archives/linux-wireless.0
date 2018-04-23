Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:50556 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755264AbeDWOmm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 10:42:42 -0400
Subject: Re: [PATCH] staging: wilc1000: fix NULL pointer exception in
 host_int_parse_assoc_resp_info()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1523521274-8719-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <8b68c05c-989f-a15c-4f40-af80317adbcf@microchip.com> (sfid-20180423_164246_159402_04C6A760)
Date: Mon, 23 Apr 2018 16:42:38 +0200
MIME-Version: 1.0
In-Reply-To: <1523521274-8719-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 12.04.2018 10:21, Ajay Singh wrote:
> Commit fe014d4e6b55 (staging: wilc1000: free memory allocated for general info
> message from firmware) introduced a bug by using wrong source address in
> kmemdup(). 'conn_info.req_ies' is used for source address in kempdup()
> instead of 'hif_drv->usr_conn_req.ies'.
> 
> This commit fixes the NULL pointer dereference issue in
> host_int_parse_assoc_resp_info() by using the correct source address in
> kmemdup().
> 
> Fixes: fe014d4e6b55 (staging: wilc1000: free memory allocated for
> general info message from firmware)
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 316d73c..302e3cb 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1387,7 +1387,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
>  	}
>  
>  	if (hif_drv->usr_conn_req.ies) {
> -		conn_info.req_ies = kmemdup(conn_info.req_ies,
> +		conn_info.req_ies = kmemdup(hif_drv->usr_conn_req.ies,
>  					    hif_drv->usr_conn_req.ies_len,
>  					    GFP_KERNEL);
>  		if (conn_info.req_ies)
> 
