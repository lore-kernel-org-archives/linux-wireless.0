Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35001 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdBXN2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 08:28:41 -0500
Received: by mail-qk0-f173.google.com with SMTP id u188so18101117qkc.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 05:28:40 -0800 (PST)
Subject: Re: [PATCH 4.12 2/2] brcmfmac: use more accurate PCIe chip names in
 fw table
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170224122739.1778-1-zajec5@gmail.com>
 <20170224122739.1778-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3cc84a21-9ef9-e28c-454e-ddd60ab4921e@broadcom.com> (sfid-20170224_142853_575104_C2BD4CB1)
Date: Fri, 24 Feb 2017 14:28:33 +0100
MIME-Version: 1.0
In-Reply-To: <20170224122739.1778-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-2-2017 13:27, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Many chips have few variants/versions, e.g. BCM4366 can be 4366b1 or
> 4366c0. Cutting name at the letter isn't a good idea as sometimes we may
> have e.g. a0 and a1.

As explained in 1/2, the revision may change but if rom image is
unchanged the firmware stays compatible. As predicting chip development
is impossible initially we choose a common name as entry ID. So if there
would come a 4366c1 with incompatible rom image it would be time to
change the entry ID.

Regards,
Arend

> This is just a cosmetic change, a trivial cleanup. It obviously doesn't
> change fw filenames as we don't want to break user space.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 2a171479b42b..7039f7f09653 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -46,7 +46,7 @@ enum brcmf_pcie_state {
>  	BRCMFMAC_PCIE_STATE_UP
>  };
>  
> -BRCMF_FW_NVRAM_DEF(43602, "brcmfmac43602-pcie.bin", "brcmfmac43602-pcie.txt");
> +BRCMF_FW_NVRAM_DEF(43602a1, "brcmfmac43602-pcie.bin", "brcmfmac43602-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4350, "brcmfmac4350-pcie.bin", "brcmfmac4350-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4350C, "brcmfmac4350c2-pcie.bin", "brcmfmac4350c2-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-pcie.bin", "brcmfmac4356-pcie.txt");
> @@ -55,13 +55,13 @@ BRCMF_FW_NVRAM_DEF(4358, "brcmfmac4358-pcie.bin", "brcmfmac4358-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4359, "brcmfmac4359-pcie.bin", "brcmfmac4359-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4365B, "brcmfmac4365b-pcie.bin", "brcmfmac4365b-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4365C, "brcmfmac4365c-pcie.bin", "brcmfmac4365c-pcie.txt");
> -BRCMF_FW_NVRAM_DEF(4366B, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
> -BRCMF_FW_NVRAM_DEF(4366C, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
> +BRCMF_FW_NVRAM_DEF(4366b1, "brcmfmac4366b-pcie.bin", "brcmfmac4366b-pcie.txt");
> +BRCMF_FW_NVRAM_DEF(4366c0, "brcmfmac4366c-pcie.bin", "brcmfmac4366c-pcie.txt");
>  BRCMF_FW_NVRAM_DEF(4371, "brcmfmac4371-pcie.bin", "brcmfmac4371-pcie.txt");
>  
>  static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFE, 43602),
> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFE, 43602a1),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366c0),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFF00, 4350),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43525_CHIP_ID, 0xFFFFFFF0, 4365C),
> @@ -73,8 +73,8 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366B),
> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366C),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0x0000000F, 4366b1),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4366_CHIP_ID, 0xFFFFFFF0, 4366c0),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
>  };
>  
> 
