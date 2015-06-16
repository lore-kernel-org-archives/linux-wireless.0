Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbFPNGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 09:06:44 -0400
Date: Tue, 16 Jun 2015 06:06:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	rachel.kim@atmel.com, chris.park@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 1/2] staging: wilc1000: modify type casting warning
Message-ID: <20150616130643.GB11143@kroah.com> (sfid-20150616_150647_515965_E051841E)
References: <1434438685-24336-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434438685-24336-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 04:11:24PM +0900, Dean Lee wrote:
> modify message "warning: cast from pointer to integer of different size".
> add type cast 'uintptr_t'.
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> ---
> Change Log:
>  add Signed-off-by line
> 
>  drivers/staging/wilc1000/host_interface.c         | 129 +++++++++++-----------
>  drivers/staging/wilc1000/linux_wlan.c             |   8 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  22 ++--
>  3 files changed, 80 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 3f139ae..358283f 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1,5 +1,6 @@
>  #include "host_interface.h"
>  #include "coreconfigurator.h"
> +#include <linux/types.h>
>  
>  extern s32 TransportInit(void);
>  extern s32 TransportDeInit(void);
> @@ -620,7 +621,7 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
>  
>  	PRINT_D(HOSTINF_DBG, "Setting channel\n");
>  	/*Sending Cfg*/
> -	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
> +	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);

This shows you are doing something really wrong here, why not just fix
the function type to be a real pointer to a real structure?  Or even
better, just remove the parameter as I don't think they are even used.

thanks,

greg k-h
