Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbFKAmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 20:42:08 -0400
Date: Wed, 10 Jun 2015 17:42:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Rachel.kim@atmel.com, dean.lee@atmel.com, tony.cho@atmel.com,
	chris.park@atmel.com
Subject: Re: [PATCH 3/4] staging: wilc1000: modify printk format
Message-ID: <20150611004208.GB30902@kroah.com> (sfid-20150611_024212_248324_2E082061)
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
 <1433923607-20927-4-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433923607-20927-4-git-send-email-johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 05:06:46PM +0900, Johnny Kim wrote:
> This remove compile warnings about printk format.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c         | 8 ++++----
>  drivers/staging/wilc1000/linux_wlan.c             | 2 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 4b005fa..e4ad07a 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -703,7 +703,7 @@ static WILC_Sint32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperat
>  	strWID.s32ValueSize = sizeof(WILC_Uint32);
>  
>  	/*Sending Cfg*/
> -	PRINT_INFO(HOSTINF_DBG, "(WILC_Uint32)pstrWFIDrv= %x \n", (WILC_Uint32)pstrWFIDrv);
> +	PRINT_INFO(HOSTINF_DBG, "(size_t)pstrWFIDrv= %p \n", pstrWFIDrv);

why is size_t in the printk message, can't that just be dropped?

I'll take this, but it looks odd...

