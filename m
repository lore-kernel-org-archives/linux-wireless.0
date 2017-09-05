Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33547 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752753AbdIEVVc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:21:32 -0400
Received: by mail-wm0-f47.google.com with SMTP id f145so13369612wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:21:31 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 26/30] brcmfmac: More efficient and slightly easier to
 read fixup for 4339 chips
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-27-ian@mnementh.co.uk>
Message-ID: <debb0614-e8a1-4e1e-b0c2-8bb5ce04a43f@broadcom.com> (sfid-20170905_232135_271427_7B670A29)
Date: Tue, 5 Sep 2017 23:21:29 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-27-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Its more efficient to test the register we're interested in first,
> potentially avoiding two more comparisons, and therefore always avoiding
> one comparison per call on all other chips.

Efficiency is really not a big issue. The buscore callbacks are really 
only used during chip recognition so this feels like change for sake of 
change. Not my favorite.

> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 7ebe6460cb5c..8a730133db77 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -3766,15 +3766,18 @@ static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
>   	/* Force 4339 chips over rev2 to use the same ID */
>   	/* This is borderline tolerable whilst there is only two exceptions */
>   	/* But could be handled better */

This is not correct way to do multi-line comment and the story is not 
quite correct or maybe I do not understand what is written here.

> -	if ((sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 ||
> -	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339) &&
> -	     addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
> +	if (addr == CORE_CC_REG(SI_ENUM_BASE, chipid) &&
> +	    (sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4339 ||
> +	     sdiodev->func[1]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339)) {
> +
>   		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
> +
>   		if (rev >= 2) {
>   			val &= ~CID_ID_MASK;
>   			val |= BRCM_CC_4339_CHIP_ID;
>   		}
>   	}
> +
>   	return val;
>   }
>   
> 
