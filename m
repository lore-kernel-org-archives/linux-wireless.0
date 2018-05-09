Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:45292 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934726AbeEINnD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:43:03 -0400
Subject: Re: [PATCH 15/30] staging: wilc1000: use kmemdup instead of kmalloc
 in add_network_to_shadow()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-16-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <e90398be-e387-1d5e-071f-b0863c249870@microchip.com> (sfid-20180509_154306_013946_7CC318C9)
Date: Wed, 9 May 2018 16:42:59 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-16-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Use kmemdup instead of kmalloc & memcpy in add_network_to_shadow().
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 0ae2065..ca221f1 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -331,8 +331,8 @@ static void add_network_to_shadow(struct network_info *nw_info,
>  	shadow_nw_info->tsf_hi = nw_info->tsf_hi;
>  	if (ap_found != -1)
>  		kfree(shadow_nw_info->ies);
> -	shadow_nw_info->ies = kmalloc(nw_info->ies_len, GFP_KERNEL);
> -	memcpy(shadow_nw_info->ies, nw_info->ies, nw_info->ies_len);
> +	shadow_nw_info->ies = kmemdup(nw_info->ies, nw_info->ies_len,
> +				      GFP_KERNEL);

Maybe, in case of NULL, you will want to set ies_len = 0 ?

>  	shadow_nw_info->time_scan = jiffies;
>  	shadow_nw_info->time_scan_cached = jiffies;
>  	shadow_nw_info->found = 1;
> 
