Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbbGaUsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 16:48:41 -0400
Date: Fri, 31 Jul 2015 13:48:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 28/28] staging: wilc1000: change data type of variable
Message-ID: <20150731204840.GB1650@kroah.com> (sfid-20150731_224848_878279_1DC86600)
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
 <1438328316-30197-29-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1438328316-30197-29-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 04:38:36PM +0900, Tony Cho wrote:
> From: glen lee <glen.lee@atmel.com>
> 
> drvHandler of u32 type is used to handle integer type pointer operation which
> cause build warnings.
> To use integer type varialbe as pointer, drvHandler data type need to be changed
> with uintptr_t type.
> 
> drivers/staging/wilc1000/host_interface.c: In function ‘NetworkInfoReceived’:
> drivers/staging/wilc1000/host_interface.c:6767:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
>                ^
> drivers/staging/wilc1000/host_interface.c: In function ‘GnrlAsyncInfoReceived’:
> drivers/staging/wilc1000/host_interface.c:6819:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
>                ^
> drivers/staging/wilc1000/host_interface.c: In function ‘host_int_ScanCompleteReceived’:
> drivers/staging/wilc1000/host_interface.c:6878:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
> 
> Signed-off-by: glen lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index b36f98c..668e47e 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -6760,7 +6760,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
>  {
>  	s32 s32Error = WILC_SUCCESS;
>  	tstrHostIFmsg strHostIFmsg;
> -	u32 drvHandler;
> +	uintptr_t drvHandler;

This isn't a valid kernel type, use "unsigned int *" if that is what you mean.

thanks,

greg k-h
