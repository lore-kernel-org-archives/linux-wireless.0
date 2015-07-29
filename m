Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbbG2Uy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 16:54:56 -0400
Date: Wed, 29 Jul 2015 13:54:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	austin.shin@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	jude.lee@atmel.com, robin.hwang@atmel.com, Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 09/21] staging: wilc1000: #ifdef conditionals cover
 entire functions
Message-ID: <20150729205454.GA7965@kroah.com> (sfid-20150729_225459_563259_E16C5EE9)
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
 <1438073261-28315-10-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438073261-28315-10-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2015 at 05:47:28PM +0900, Tony Cho wrote:
> This patch lets preprocessor conditionals (#ifdef) related to
> WILC_SDIO_IRQ_GPIO to compile out the entire functions. Compiling out
> the entire functions is preferred rather than portions of functions or
> expressions becausue doing so makes code harder to read.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 482 +++++++++++++++++++++--------------
>  1 file changed, 293 insertions(+), 189 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index 8f674ad..83b8da9 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -155,22 +155,9 @@ _fail_:
>  	return 0;
>  }
>  
> +#ifdef WILC_SDIO_IRQ_GPIO
>  static int sdio_clear_int(void)
>  {
> -#ifndef WILC_SDIO_IRQ_GPIO
> -	/* uint32_t sts; */
> -	sdio_cmd52_t cmd;
> -
> -	cmd.read_write = 0;
> -	cmd.function = 1;
> -	cmd.raw = 0;
> -	cmd.address = 0x4;
> -	cmd.data = 0;
> -	g_sdio.sdio_cmd52(&cmd);
> -	int_clrd++;
> -
> -	return cmd.data;
> -#else
>  	uint32_t reg;
>  
>  	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
> @@ -181,9 +168,23 @@ static int sdio_clear_int(void)
>  	sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
>  	int_clrd++;
>  	return 1;
> -#endif
> +}
> +#else
> +static int sdio_clear_int(void)
> +{
> +	sdio_cmd52_t cmd;
>  
> +	cmd.read_write = 0;
> +	cmd.function = 1;
> +	cmd.raw = 0;
> +	cmd.address = 0x4;
> +	cmd.data = 0;
> +	g_sdio.sdio_cmd52(&cmd);
> +	int_clrd++;
> +
> +	return cmd.data;
>  }
> +#endif /* WILC_SDIO_IRQ_GPIO */

Why does this have to be a config option anyway?  Shouldn't this be
dynamically determined?  How should someone know which to choose?

>  uint32_t sdio_xfer_cnt(void)
>  {
> @@ -521,14 +522,16 @@ static int sdio_deinit(void *pv)
>  	return 1;
>  }
>  
> +#ifdef WILC_SDIO_IRQ_GPIO
>  static int sdio_sync(void)
>  {
>  	uint32_t reg;
> +	int ret;
>  
>  	/**
>  	 *      Disable power sequencer
>  	 **/
> -	if (!sdio_read_reg(WILC_MISC, &reg)) {
> +	if(!sdio_read_reg(WILC_MISC, &reg)) {

You just reverted this coding style change, why?

I can't take this patch, sorry.  Please sync up and make sure you do not
revert changes that other people have already made to the code, and
resend the remaining patches in this series.

thanks,

greg k-h
