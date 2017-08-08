Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37984 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdHHLTs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:19:48 -0400
Received: by mail-wm0-f49.google.com with SMTP id m85so4393468wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 04:19:47 -0700 (PDT)
Subject: Re: [PATCH 31/34] brcmfmac: Remove func0 from function array
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-32-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <21ea2a49-c797-b427-1ee7-ff8164c8f95c@broadcom.com> (sfid-20170808_131952_654917_FD43AAC6)
Date: Tue, 8 Aug 2017 13:19:45 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-32-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> Linux doesnt pass you func0 as a function when probing - instead
> providing specific access functions to read/write it.
> 
> This prepares for a patch to remove the actual array entry itself.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  5 +----
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |  6 +++---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 13 ++++++-------
>  3 files changed, 10 insertions(+), 14 deletions(-)

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> index 8a976c89cf63..227c90198a8e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> @@ -21,7 +21,9 @@
>  #include <linux/firmware.h>
>  #include "firmware.h"
>  
> -#define SDIO_FUNC_0		0
> +/* Maximum number of I/O funcs */
> +#define NUM_SDIO_FUNCS	3
> +
>  #define SDIO_FUNC_1		1
>  #define SDIO_FUNC_2		2
>  
> @@ -39,9 +41,6 @@
>  #define INTR_STATUS_FUNC1	0x2
>  #define INTR_STATUS_FUNC2	0x4
>  
> -/* Maximum number of I/O funcs */
> -#define SDIOD_MAX_IOFUNCS	7
> -

Good riddance, because ...

>  /* mask of register map */
>  #define REG_F0_REG_MASK		0x7FF
>  #define REG_F1_MISC_MASK	0x1FFFF
> @@ -175,7 +174,7 @@ struct brcmf_sdio;
>  struct brcmf_sdiod_freezer;
>  
>  struct brcmf_sdio_dev {
> -	struct sdio_func *func[SDIO_MAX_FUNCS];

... it was not used anyway as this definition is in <linux/mmc/card.h>.

> +	struct sdio_func *func[NUM_SDIO_FUNCS];
>  	u8 num_funcs;			/* Supported funcs on client */
>  	u32 sbwad;			/* Save backplane window address */
>  	struct brcmf_core *cc_core;	/* chipcommon core info struct */
> @@ -297,10 +296,10 @@ void brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
>  /* SDIO device register access interface */
>  /* Functions for accessing SDIO Function 0 */
>  #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
> -	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
> +	sdio_f0_readb((sdiodev)->func[1], (addr), (r))

There is no reason to keep these any longer as these do not provide any
functionality over the core sdio function unless you consider the
sdiodev dereference.
