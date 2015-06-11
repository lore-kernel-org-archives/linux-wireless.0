Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbFKDui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 23:50:38 -0400
Date: Wed, 10 Jun 2015 20:50:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	rachel.kim@atmel.com, chris.park@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: modify odd print message
Message-ID: <20150611035037.GA22550@kroah.com> (sfid-20150611_055041_341252_6B446F61)
References: <1433994264-26509-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433994264-26509-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2015 at 12:44:24PM +0900, Dean Lee wrote:
> This driver has odd message in print string.
> So this patch removes the data type.
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 1ecb373..9e055c4 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -703,7 +703,7 @@ static WILC_Sint32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperat
>  	strWID.s32ValueSize = sizeof(WILC_Uint32);
>  
>  	/*Sending Cfg*/
> -	PRINT_INFO(HOSTINF_DBG, "(size_t)pstrWFIDrv= %p \n", pstrWFIDrv);
> +	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);

Why are you printing a kernel pointer to userspace always?  That's not a
good idea, why not just delete this line, how useful is it?

thanks,

greg k-h
