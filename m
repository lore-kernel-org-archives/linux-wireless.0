Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbeCZISG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 04:18:06 -0400
Date: Mon, 26 Mar 2018 11:17:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 4/9] staging: wilc1000: free memory allocated in add wep
 key functions
Message-ID: <20180326081748.srvuwoekodihtpfh@mwanda> (sfid-20180326_101810_323463_FD6D4D5E)
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
 <1521817738-7557-5-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521817738-7557-5-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2018 at 08:38:53PM +0530, Ajay Singh wrote:
> Free memory allocated for wep key when command enqueue is failed.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 1cc4c08..c958dd3 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2727,8 +2727,10 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
>  	msg.body.key_info.attr.wep.index = index;
>  
>  	result = wilc_enqueue_cmd(&msg);
> -	if (result)
> +	if (result) {
>  		netdev_err(vif->ndev, "STA - WEP Key\n");
> +		kfree(msg.body.key_info.attr.wep.key);

We should "return result;" here otherwise we'll hang when we
wait_for_completion().  This is the sort of bug why I always encourage
people to keep the error path and success path separate (unless they
both have to unlock or free the same resources).

> +	}
>  	wait_for_completion(&hif_drv->comp_test_key_block);
>  
>  	return result;

That way this becomes a "return 0;" instead of a "return result;".

> @@ -2763,10 +2765,12 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
>  
>  	result = wilc_enqueue_cmd(&msg);
>  
> -	if (result)
> +	if (result) {
>  		netdev_err(vif->ndev, "AP - WEP Key\n");
> -	else
> +		kfree(msg.body.key_info.attr.wep.key);
> +	} else {
>  		wait_for_completion(&hif_drv->comp_test_key_block);
> +	}
>  
>  	return result;
>  }

This code works, but it would look cleaner with "return result;".

	result = wilc_enqueue_cmd(&msg);
	if (result) {
		netdev_err(vif->ndev, "AP - WEP Key\n");
		kfree(msg.body.key_info.attr.wep.key);
		return result;
	}

	wait_for_completion(&hif_drv->comp_test_key_block);
	return 0;

I removed a blank line between the wilc_enqueue_cmd() and the error
handling because they're very connected.  All the success path is at
indent level one so you can just glance at the function and see what
it's supposed to do in the normal case.  The error handling is self
contained at indent level two.

regards,
dan carpenter
