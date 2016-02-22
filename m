Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:36473 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754510AbcBVLmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 06:42:47 -0500
From: "Kim, Leo" <Leo.Kim@atmel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"Shin, Austin" <Austin.Shin@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	"Cho, Tony" <Tony.Cho@atmel.com>,
	"Abozaeid, Adham" <Adham.Abozaeid@atmel.com>
Subject: RE: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary
 wilc_debug print log
Date: Mon, 22 Feb 2016 11:42:42 +0000
Message-ID: <74F3875218FC364C9618AB19CB60E9058004B81C@penmbx02.corp.atmel.com> (sfid-20160222_124251_181518_5FBA7328)
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
 <1456116079-7161-4-git-send-email-leo.kim@atmel.com>
 <20160222104519.GR32153@mwanda>
In-Reply-To: <20160222104519.GR32153@mwanda>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Dan,

This patch is subject "removes unnecessary wilc_debug print log".
Your advice are correct but in this patch is not applied.
I'll be applied to next patch about the your good advice.
Would be okay?
Always appreciate your positive advice & great information.

 Thanks, BR
 Leo

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Monday, February 22, 2016 7:45 PM
To: Kim, Leo <Leo.Kim@atmel.com>
Cc: gregkh@linuxfoundation.org; devel@driverdev.osuosl.org; Park, Chris <Chris.Park@atmel.com>; Shin, Austin <Austin.Shin@atmel.com>; linux-wireless@vger.kernel.org; Ferre, Nicolas <Nicolas.FERRE@atmel.com>; Cho, Tony <Tony.Cho@atmel.com>; Abozaeid, Adham <Adham.Abozaeid@atmel.com>
Subject: Re: [PATCH RESEND 04/10] staging: wilc1000: removes unnecessary wilc_debug print log

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
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c 
> b/drivers/staging/wilc1000/wilc_wlan.c
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

Remove this as well.  Don't leave random no-op function calls lying around.

>  			} while ((wilc_get_chipid(wilc, true) == 0) && ((++trials % 3) == 
> 0));
                                                                         ^^^^^^^^^^^^

This doesn't work as intended either.

regards,
dan carpenter

