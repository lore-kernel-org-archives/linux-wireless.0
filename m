Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbeGSKKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 06:10:19 -0400
Date: Thu, 19 Jul 2018 12:27:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 05/23] staging: wilc1000: rename goto to avoid leading
 '_' in label name
Message-ID: <20180719092744.5gx2ctgj7etvk7uh@mwanda> (sfid-20180719_112805_764938_5B80AA64)
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
 <1531953919-20804-6-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1531953919-20804-6-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2018 at 04:15:01AM +0530, Ajay Singh wrote:
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 85af365..8e71c28 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -850,13 +850,13 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
>  		if (wilc->rx_buffer)
>  			buffer = &wilc->rx_buffer[offset];
>  		else
> -			goto _end_;
> +			goto end;

This isn't related to your patch but this goto doesn't appear to make
any sort of sense.  I have no idea what was intended.

>  
>  		wilc->hif_func->hif_clear_int_ext(wilc,
>  					      DATA_INT_CLR | ENABLE_RX_VMM);
>  		ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
>  
> -_end_:
> +end:
>  		if (ret) {
>  			offset += size;
>  			wilc->rx_buffer_offset = offset;

regards,
dan carpenter
