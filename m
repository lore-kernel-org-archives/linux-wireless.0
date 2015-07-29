Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbG2VBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 17:01:24 -0400
Date: Wed, 29 Jul 2015 14:01:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 21/21] staging: wilc1000: update TODO list of WILC1000
Message-ID: <20150729210123.GA25941@kroah.com> (sfid-20150729_230127_808959_272201F0)
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
 <1438073261-28315-22-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438073261-28315-22-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2015 at 05:47:40PM +0900, Tony Cho wrote:
> The TODO list is updated for the WILC1000 kernel driver. The TODO list
> contains many items listed in time sequence.

I don't understand what you mean by "in time sequence"

> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/staging/wilc1000/TODO | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
> index 95199d8..6b745cd 100644
> --- a/drivers/staging/wilc1000/TODO
> +++ b/drivers/staging/wilc1000/TODO
> @@ -1,14 +1,15 @@
>  TODO:
> -- remove the defined feature as kernel versions
> -- remove OS wrapper functions
> -- remove custom debug and tracing functions
> +- remove most of warnings reported by checkpatch.pl

"most"?  Why not all?

> +- remove OS wrapper functions to use kernel API as is

Why reword this, the original line is just fine.

>  - rework comments and function headers(also coding style)
>  - replace all semaphores with mutexes or completions
> -- make spi and sdio components coexist in one build

Why remove this item?  It's not done and needs to be done.

> +- remove compile warnings related to 64 bit machine

That's a given, I'm not enabling the build of the driver until that
happens.  Please work on that next, coding style fixes can happen after
that.  As of right now, this driver is marked BROKEN.

thanks,

greg k-h
