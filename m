Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbcBVKpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:45:32 -0500
Date: Mon, 22 Feb 2016 13:45:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Leo Kim <leo.kim@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	Chris.Park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	tony.cho@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary
 wilc_debug print log
Message-ID: <20160222104519.GR32153@mwanda> (sfid-20160222_114537_539288_AEBFC650)
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
 <1456116079-7161-4-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456116079-7161-4-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2016 at 01:41:13PM +0900, Leo Kim wrote:
> This patch removes unnecessary wilc_debug print log.
> The print log was written when if condition fail.
> The condition is chip-id check function.
> Also, replaces this condition with normal function.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index f0ac47f..34018a1 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -502,9 +502,7 @@ void chip_wakeup(struct wilc *wilc)
>  
>  			do {
>  				usleep_range(2 * 1000, 2 * 1000);
> -				if ((wilc_get_chipid(wilc, true) == 0))
> -					wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
> -
> +				wilc_get_chipid(wilc, true);

Remove this as well.  Don't leave random no-op function calls lying
around.

>  			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
                                                                         ^^^^^^^^^^^^

This doesn't work as intended either.

regards,
dan carpenter

