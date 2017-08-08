Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36234 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHM3M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 08:29:12 -0400
Received: by mail-wr0-f171.google.com with SMTP id y43so12271639wrd.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 05:29:11 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 32/34] brcmfmac: Replace function index with function
 pointer
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-33-ian@mnementh.co.uk>
Message-ID: <59afe81f-56a7-64ea-62b6-29974a4f5e0f@broadcom.com> (sfid-20170808_142916_123881_9867C0C2)
Date: Tue, 8 Aug 2017 14:29:09 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-33-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> In preparation for removing the function array, remove all code that
> refers to function by index and replace with pointers to the function
> itself.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

comments below...

> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 86 ++++++++++++----------
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 14 ++--
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    | 14 ++--
>  3 files changed, 61 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index da0654c50db9..5787348003d9 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -148,7 +148,8 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
>  
>  		/* must configure SDIO_CCCR_IENx to enable irq */
>  		data = brcmf_sdiod_func0_rb(sdiodev, SDIO_CCCR_IENx, &ret);
> -		data |= 1 << SDIO_FUNC_1 | 1 << SDIO_FUNC_2 | 1;
> +		data |= SDIO_CCCR_IEN_FUNC1 | SDIO_CCCR_IEN_FUNC2 |
> +			SDIO_CCCR_IEN_BIT0;

This is not really related except that you are doing away with the
SDIO_FUNC_{1,2} defintions. Please use separate patch for this. The BIT0
should basically be FUNC0.

>  		brcmf_sdiod_func0_wb(sdiodev, SDIO_CCCR_IENx, data, &ret);
>  
>  		/* redirect, configure and enable io for interrupt signal */

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> index 227c90198a8e..3d41bd94f97c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> @@ -24,9 +24,6 @@
>  /* Maximum number of I/O funcs */
>  #define NUM_SDIO_FUNCS	3
>  
> -#define SDIO_FUNC_1		1
> -#define SDIO_FUNC_2		2
> -
>  #define SDIOD_FBR_SIZE		0x100
>  
>  /* io_en */
> @@ -45,11 +42,13 @@
>  #define REG_F0_REG_MASK		0x7FF
>  #define REG_F1_MISC_MASK	0x1FFFF
>  
> -/* as of sdiod rev 0, supports 3 functions */
> -#define SBSDIO_NUM_FUNCTION		3
> -
>  /* function 0 vendor specific CCCR registers */
>  
> +/* Interrupt enable bits for func 1 and 2 */
> +#define SDIO_CCCR_IEN_BIT0		BIT(0)

Better change BIT0 to FUNC0 in separate patch as mentioned above.

> +#define SDIO_CCCR_IEN_FUNC1		BIT(1)
> +#define SDIO_CCCR_IEN_FUNC2		BIT(2)
> +
