Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965714AbbKDUko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 15:40:44 -0500
Date: Wed, 4 Nov 2015 12:40:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH RESEND 11/12] staging: wilc1000: rename os_context to wilc
Message-ID: <20151104204043.GA15421@kroah.com> (sfid-20151104_214048_426106_1E66909A)
References: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
 <1446088732-12301-11-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446088732-12301-11-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 29, 2015 at 12:18:51PM +0900, Glen Lee wrote:
> This patch rename os_context to wilc because it is used as struct wilc and
> move os_private from struct wilc_wlan_os_context_t to struct wilc_wlan_inp_t.
> Finally, delete wilc_wlan_os_context_t.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c   | 2 +-
>  drivers/staging/wilc1000/wilc_sdio.c    | 6 +++---
>  drivers/staging/wilc1000/wilc_spi.c     | 6 +++---
>  drivers/staging/wilc1000/wilc_wlan_if.h | 6 +-----
>  4 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 017799f..d0161cd 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1012,7 +1012,7 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
>  
>  	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
>  
> -	nwi->os_context.os_private = (void *)nic;
> +	nwi->wilc = (void *)nic;

Why do you need the cast to a void * here?


>  
>  #ifdef WILC_SDIO
>  	nwi->io_func.io_type = HIF_SDIO;
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index 300c571..82f68eb 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -14,7 +14,7 @@
>  #define WILC_SDIO_BLOCK_SIZE 512
>  
>  typedef struct {
> -	void *os_context;
> +	void *wilc;

This should be a struct wilc *, right?  Don't add a void pointer for
something that you know what it is.

thanks,

greg k-h
