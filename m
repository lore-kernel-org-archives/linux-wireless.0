Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36297 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGQTVR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 15:21:17 -0400
Received: by mail-wm0-f45.google.com with SMTP id t70so24845645wmt.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 12:21:16 -0700 (PDT)
Subject: Re: [PATCH 11/11] net: brcmfmac: constify pci_device_id.
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, kvalo@codeaurora.org,
        hante.meuleman@broadcom.com, franky.lin@broadcom.com,
        wright.feng@cypress.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <1500315402-3439-1-git-send-email-arvind.yadav.cs@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <aa683182-5d94-1b63-2c22-fec3775ae7d3@broadcom.com> (sfid-20170717_212132_396549_82030EB5)
Date: Mon, 17 Jul 2017 21:21:12 +0200
MIME-Version: 1.0
In-Reply-To: <1500315402-3439-1-git-send-email-arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-07-17 20:16, Arvind Yadav wrote:
> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index f878706..e6e9b00 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -1951,7 +1951,7 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm = {
>  	BRCM_PCIE_VENDOR_ID_BROADCOM, dev_id,\
>  	subvend, subdev, PCI_CLASS_NETWORK_OTHER << 8, 0xffff00, 0 }
>  
> -static struct pci_device_id brcmf_pcie_devid_table[] = {
> +static const struct pci_device_id brcmf_pcie_devid_table[] = {
>  	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID),
>  	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
>  	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
> 
