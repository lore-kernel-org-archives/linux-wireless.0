Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12542 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753592AbeD3O33 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:29:29 -0400
Date: Mon, 30 Apr 2018 19:59:16 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC: Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: fix infinite loop and out-of-bounds
 access
Message-ID: <20180430195916.596a93eb@ajaysk-VirtualBox> (sfid-20180430_162943_373770_2A10659B)
In-Reply-To: <20180430125040.GA19050@embeddedor.com>
References: <20180430125040.GA19050@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>

On Mon, 30 Apr 2018 07:50:40 -0500
"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> If i < slot_id is initially true then it will remain true. Also,
> as i is being decremented it will end up accessing memory out of
> bounds.
> 
> Fix this by incrementing *i* instead of decrementing it.

Nice catch!
Thanks for submitting the changes.

> 
> Addresses-Coverity-ID: 1468454 ("Infinite loop")
> Fixes: faa657641081 ("staging: wilc1000: refactor scan() to free
> kmalloc memory on failure cases")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> 
> BTW... at first sight it seems to me that variables slot_id
> and i should be of type unsigned instead of signed.

Yes, 'slot_id' & 'i' can be changed to unsigned int.

> 
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
> 3ca0c97..67104e8 100644 ---
> a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@ -608,7
> +608,7 @@ wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request
> *request, out_free:
>  
> -	for (i = 0; i < slot_id ; i--)
> +	for (i = 0; i < slot_id; i++)
>  		kfree(ntwk->net_info[i].ssid);
>  
>  	kfree(ntwk->net_info);



Regards,
Ajay
