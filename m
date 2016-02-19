Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26306 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479AbcBSLFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 06:05:00 -0500
Date: Fri, 19 Feb 2016 14:04:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Leo Kim <leo.kim@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	Chris.Park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	tony.cho@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 4/6] staging: wilc1000: removes unnecessary wilc_debug
 print log
Message-ID: <20160219110433.GQ32153@mwanda> (sfid-20160219_120505_726048_2FF6D2D8)
References: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
 <1455871032-7625-4-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455871032-7625-4-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2016 at 05:37:10PM +0900, Leo Kim wrote:
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
> index a51c66b..4873106 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -508,9 +508,7 @@ void chip_wakeup(struct wilc *wilc)
>  
>  			do {
>  				usleep_range(2 * 1000, 2 * 1000);
> -				if ((wilc_get_chipid(wilc, true) == 0))
> -					wilc_debug(N_ERR, "Couldn't read chip id. Wake up failed\n");
> -
> +				wilc_get_chipid(wilc, true);

Why do we need this function when we call it again on the next line?

>  			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 0));
                                  ^^^^^^^^^^^^^^^

Also what the heck is ((++trials % 3) == 0))???  It looks like we are
supposed to retry 3 times but actually we don't retry at all.  :P

regards,
dan carpenter

