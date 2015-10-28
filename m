Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50070 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965732AbbJ1OHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 10:07:36 -0400
Date: Wed, 28 Oct 2015 17:07:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 17/80] staging: wilc1000: rename enuHostIFstate of struct
 host_if_drv
Message-ID: <20151028140726.GA18797@mwanda> (sfid-20151028_150746_149038_DBB17F25)
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
 <1446015640-29398-17-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446015640-29398-17-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 03:59:37PM +0900, Glen Lee wrote:
> @@ -1837,10 +1839,11 @@ static int Handle_Key(struct host_if_drv *hif_drv,
>  				goto _WPARxGtk_end_case_;
>  			}
>  
> -			if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
> +			if (hif_drv->hif_state == HOST_IF_CONNECTED)
>  				memcpy(pu8keybuf, hif_drv->au8AssociatedBSSID, ETH_ALEN);
>  			else
> -				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
> +				PRINT_ER("Couldn't handle WPARxGtk while \
> +					 state is not HOST_IF_CONNECTED\n");

This line break is not correct.  It adds unwanted indenting to the dmesg
output.

regards,
dan carpenter

