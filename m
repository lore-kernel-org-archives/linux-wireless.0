Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39881 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387801AbeGWNCN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 09:02:13 -0400
Received: by mail-wm0-f68.google.com with SMTP id h20-v6so912664wmb.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2018 05:01:20 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix regression in parsing NVRAM for multiple
 devices
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180722214625.12101-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Aditya Xavier <adityaxavier@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B55C38E.3070003@broadcom.com> (sfid-20180723_140124_141853_E4567A0D)
Date: Mon, 23 Jul 2018 14:01:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180722214625.12101-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/22/2018 11:46 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> NVRAM is designed to work with Broadcom's SDK Linux kernel which fakes
> PCI domain 0 for all internal MMIO devices. Since official Linux kernel
> uses platform devices for that purpose there is a mismatch in numbering
> PCI domains.
>
> There used to be a fix for that problem but it was accidentally dropped
> during the last firmware loading rework. That resulted in brcmfmac not
> being able to extract device specific NVRAM content and all kind of
> calibration problems.
>
> Reported-by: Aditya Xavier <adityaxavier@gmail.com>
> Fixes: 2baa3aaee27f ("brcmfmac: introduce brcmf_fw_alloc_request() function")
> Cc: stable@vger.kernel.org # v4.17+

oops. my bad.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 45928b5b8d97..4fffa6988087 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -1785,7 +1785,8 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
>   	fwreq->items[BRCMF_PCIE_FW_CODE].type = BRCMF_FW_TYPE_BINARY;
>   	fwreq->items[BRCMF_PCIE_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
>   	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
> -	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus);
> +	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
> +	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
>   	fwreq->bus_nr = devinfo->pdev->bus->number;
>
>   	return fwreq;
>
