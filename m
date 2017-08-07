Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34287 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdHGTab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 15:30:31 -0400
Received: by mail-wm0-f53.google.com with SMTP id t138so1327682wmt.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 12:30:30 -0700 (PDT)
Subject: Re: [PATCH 13/34] brcmfmac: Tidy register definitions a little
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-14-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bbbcb6d0-8556-d201-0036-6192b72d6fe7@broadcom.com> (sfid-20170807_213034_997085_FA05329A)
Date: Mon, 7 Aug 2017 21:30:28 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-14-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> Trivial tidy of register definitions.

Initially skipped this one, but it is indeed trivial.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>

comment below...

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> index 4c81ea24d19c..fb4f24dfc99d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
> @@ -51,17 +51,18 @@
>  
>  /* function 0 vendor specific CCCR registers */
>  
> -#define SDIO_CCCR_BRCM_CARDCAP			0xf0
> +#define SDIO_CCCR_BRCM_CARDCAP		0xf0
>  #define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
>  #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
>  #define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
> +
>  #define SDIO_CCCR_BRCM_CARDCTRL		0xf1
>  #define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	0x02
> -#define SDIO_CCCR_BRCM_SEPINT			0xf2
>  
> -#define  SDIO_SEPINT_MASK		0x01
> -#define  SDIO_SEPINT_OE			0x02
> -#define  SDIO_SEPINT_ACT_HI		0x04
> +#define SDIO_CCCR_BRCM_SEPINT		0xf2
> +#define SDIO_SEPINT_MASK			0x01
> +#define SDIO_SEPINT_OE				0x02
> +#define SDIO_SEPINT_ACT_HI			0x04

So the SEPINT definitions are not consistent with the other ones. Maybe
drop the SDIO_CCCR from the other value definitions and for the SEPINT
replace 'SDIO_' with 'SEPINT_'.
