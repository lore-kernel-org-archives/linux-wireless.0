Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34910 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbG3L5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 07:57:01 -0400
Received: by pabkd10 with SMTP id kd10so22543841pab.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 04:57:01 -0700 (PDT)
Date: Thu, 30 Jul 2015 17:26:48 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH V2 1/5] staging: wilc1000: #ifdef conditionals cover
 entire functions
Message-ID: <20150730115647.GA12823@sudip-pc> (sfid-20150730_135706_638032_84DFE8D6)
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
 <1438247414-19708-2-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438247414-19708-2-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 06:10:10PM +0900, Tony Cho wrote:
> This patch lets preprocessor conditionals (#ifdef) related to
> WILC_SDIO_IRQ_GPIO to compile out the entire functions. Compiling out
> the entire functions is preferred rather than portions of functions or
> expressions becausue doing so makes code harder to read.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
<snip>
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
> +
> +	cmd.read_write = 0;
> +	cmd.function = 1;
> +	cmd.raw = 0;
> +	cmd.address = 0x4;
> +	cmd.data = 0;
> +	g_sdio.sdio_cmd52(&cmd);
> +	int_clrd++;
>  
> +	return cmd.data;
>  }
> +#endif /* WILC_SDIO_IRQ_GPIO */
instead of changing #ifndef to #ifdef i think the following would have
been easier:

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 5a18148..5cd4d45 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -155,9 +155,9 @@ _fail_:
 	return 0;
 }
 
+#ifndef WILC_SDIO_IRQ_GPIO
 static int sdio_clear_int(void)
 {
-#ifndef WILC_SDIO_IRQ_GPIO
 	/* uint32_t sts; */
 	sdio_cmd52_t cmd;
 
@@ -170,7 +170,10 @@ static int sdio_clear_int(void)
 	int_clrd++;
 
 	return cmd.data;
+}
 #else
+static int sdio_clear_int(void)
+{
 	uint32_t reg;
 
 	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
@@ -181,9 +184,8 @@ static int sdio_clear_int(void)
 	sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
 	int_clrd++;
 	return 1;
-#endif
-
 }
+#endif
 
 uint32_t sdio_xfer_cnt(void)
 {

>  
>  uint32_t sdio_xfer_cnt(void)
<snip>
> +#ifdef WILC_SDIO_IRQ_GPIO
>  static int sdio_clear_int_ext(uint32_t val)
>  {
>  	int ret;
>  
> -	if (g_sdio.has_thrpt_enh3) {
> +	if(g_sdio.has_thrpt_enh3) {
why changing this? The original style is according to the kernel coding
style.

regards
sudip
