Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35092 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdATKTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:19:22 -0500
Received: by mail-pg0-f54.google.com with SMTP id 194so22701245pgd.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 02:19:22 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: drop duplicated core selection from
 brcmf_pcie_attach
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170119095125.12276-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <meuleman@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cef795a9-3716-5153-ce4b-4430100a9f8c@broadcom.com> (sfid-20170120_112231_873011_4BE9A600)
Date: Fri, 20 Jan 2017 11:19:14 +0100
MIME-Version: 1.0
In-Reply-To: <20170119095125.12276-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-1-2017 10:51, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It was left after reworking PCIe reset in commit 07fe2e38c7fd
> ("brcmfmac: Reset PCIE devices after recognition.").
> 
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 19db8f2..6fae4cf 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -601,7 +601,6 @@ static void brcmf_pcie_attach(struct brcmf_pciedev_info *devinfo)
>  {
>  	u32 config;
>  
> -	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
>  	/* BAR1 window may not be sized properly */
>  	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
>  	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR, 0x4e0);
> 
