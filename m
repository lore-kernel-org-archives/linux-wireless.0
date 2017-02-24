Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34399 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdBXNVs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 08:21:48 -0500
Received: by mail-qk0-f177.google.com with SMTP id s186so18011259qkb.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 05:21:34 -0800 (PST)
Subject: Re: [PATCH 4.12 1/2] brcmfmac: don't use 43602a1 firmware for 43602a0
 chipset
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170224122739.1778-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c7c82c1f-df42-c4a2-4f1f-1ff4928590d1@broadcom.com> (sfid-20170224_142313_876917_82779900)
Date: Fri, 24 Feb 2017 14:21:28 +0100
MIME-Version: 1.0
In-Reply-To: <20170224122739.1778-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-2-2017 13:27, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 43602a0 uses chip revision 0 compared to 43602a1 with revision 1. In
> brcmfmac there is support for 43602a1 and from what I know supporting
> 43602a0 would require loading a different firmware.

This is not necessarily true. It depends on whether the rom image is
different or not and there is no way to tell up front. So if a0 has same
rom image as a1 the firmware is compatible and no distinction is needed.
This tends to be the case for chips that only change the digit and not
the letter in the chip revision. Anyway, I do not know if a0 has
different rom image, but the a0 was never sold so there is no harm in
keeping it as is.

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 6fae4cf3f6ab..2a171479b42b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -60,7 +60,7 @@ BRCMF_FW_NVRAM_DEF(4366C, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
>  
>  static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFE, 43602),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFF00, 4350),
> 
