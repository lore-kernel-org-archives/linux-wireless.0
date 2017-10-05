Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:43427 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdJEKJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 06:09:39 -0400
Received: by mail-wm0-f46.google.com with SMTP id m72so1152292wmc.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Oct 2017 03:09:38 -0700 (PDT)
Date: Thu, 5 Oct 2017 12:09:32 +0200
From: Gary Bisson <gary.bisson@boundarydevices.com>
To: silexcommon@gmail.com
Cc: ath10k@lists.infradead.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [08/11] ath10k_sdio: common read write
Message-ID: <20171005100932.vamkzfulq3dg4iav@t450s.lan> (sfid-20171005_120942_790295_18F83CCC)
References: <1506793068-27445-9-git-send-email-alagusankar@silex-india.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506793068-27445-9-git-send-email-alagusankar@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,

On Sat, Sep 30, 2017 at 11:07:45PM +0530, silexcommon@gmail.com wrote:
> From: Alagu Sankar <alagusankar@silex-india.com>
> 
> convert different read write functions in sdio hif to bring it under a
> single read-write path. This helps in having a common dma bounce buffer
> implementation. Also helps in address modification that is required
> specific to change in certain mbox addresses of sdio_write.
> 
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> ---
>  drivers/net/wireless/ath/ath10k/sdio.c | 131 ++++++++++++++++-----------------
>  1 file changed, 64 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
> index 77d4fa4..bb6fa67 100644
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -36,6 +36,11 @@
>  
>  #define ATH10K_SDIO_DMA_BUF_SIZE	(32 * 1024)
>  
> +static int ath10k_sdio_read(struct ath10k *ar, u32 addr, void *buf,
> +			    u32 len, bool incr);
> +static int ath10k_sdio_write(struct ath10k *ar, u32 addr, const void *buf,
> +			     u32 len, bool incr);
> +

As mentioned by Kalle, u32 needs to be size_t.

>  /* inlined helper functions */
>  
>  /* Macro to check if DMA buffer is WORD-aligned and DMA-able.
> @@ -152,6 +157,7 @@ static int ath10k_sdio_config(struct ath10k *ar)
>  	struct sdio_func *func = ar_sdio->func;
>  	unsigned char byte, asyncintdelay = 2;
>  	int ret;
> +	u32 addr;
>  
>  	ath10k_dbg(ar, ATH10K_DBG_BOOT, "sdio configuration\n");
>  
> @@ -180,9 +186,8 @@ static int ath10k_sdio_config(struct ath10k *ar)
>  		 CCCR_SDIO_DRIVER_STRENGTH_ENABLE_C |
>  		 CCCR_SDIO_DRIVER_STRENGTH_ENABLE_D);
>  
> -	ret = ath10k_sdio_func0_cmd52_wr_byte(func->card,
> -					      CCCR_SDIO_DRIVER_STRENGTH_ENABLE_ADDR,
> -					      byte);
> +	addr = CCCR_SDIO_DRIVER_STRENGTH_ENABLE_ADDR,
> +	ret = ath10k_sdio_func0_cmd52_wr_byte(func->card, addr, byte);

Not sure this part is needed.

>  	if (ret) {
>  		ath10k_warn(ar, "failed to enable driver strength: %d\n", ret);
>  		goto out;
> @@ -233,13 +238,16 @@ static int ath10k_sdio_config(struct ath10k *ar)
>  
>  static int ath10k_sdio_write32(struct ath10k *ar, u32 addr, u32 val)
>  {
> -	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
> -	struct sdio_func *func = ar_sdio->func;
> +	__le32 *buf;
>  	int ret;
>  
> -	sdio_claim_host(func);
> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
>  
> -	sdio_writel(func, val, addr, &ret);
> +	*buf = cpu_to_le32(val);
> +
> +	ret = ath10k_sdio_write(ar, addr, &val, sizeof(val), true);

Shouldn't we use buf instead of val? buf seems pretty useless otherwise.

Regards,
Gary
