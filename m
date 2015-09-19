Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbbISE7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 00:59:23 -0400
Date: Fri, 18 Sep 2015 19:50:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH v2 1/4] staging: wilc1000: fix null check routine
Message-ID: <20150919025038.GA2889@kroah.com> (sfid-20150919_065929_128313_A68F3329)
References: <1442484140-13485-1-git-send-email-tony.cho@atmel.com>
 <1442484140-13485-2-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442484140-13485-2-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 07:02:17PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes the potential faults which may happen when unexpectedly
> getting access to invalid pointer. The pointer of pstrWFIDrv is unlikely
> to be invalid. However, it is safer to return error when the invalid
> memory is unfortunately accessed.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 6fdf392..151e8c4 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2403,8 +2403,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
>  	s32 s32Err = 0;
>  	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
>  
> -	if (pstrWFIDrv == NULL)
> +	if (unlikely(!pstrWFIDrv)) {

Can you measure the difference of using unlikely and not using it?  If
not, never use it, as odds are, the compiler and processor already
guessed it correctly and made the code faster.

If you can measure it, great, I'll be glad to take this patch, but you
need to show your measurements in the changelog comments.

>  		PRINT_ER("Driver handler is NULL\n");
> +		return -EFAULT;

-EFAULT is only for when we take a memory fault, which is not what is
happening here.  -ENODEV?

thanks,

greg k-h
