Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0045.outbound.protection.outlook.com ([104.47.38.45]:12352
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751379AbdGRLCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 07:02:10 -0400
Date: Tue, 18 Jul 2017 14:01:52 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: imitsyanko@quantenna.com, kvalo@codeaurora.org,
        avinashp@quantenna.com, smatyukevich@quantenna.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/11] net: qtnfmac: constify pci_device_id.
Message-ID: <20170718110150.cmjg2ke6rfvz53jm@bars> (sfid-20170718_130349_206797_51A2F9C3)
References: <1500315263-3373-1-git-send-email-arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500315263-3373-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> index 7fc4f0d..02337d8 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> @@ -1336,7 +1336,7 @@ static SIMPLE_DEV_PM_OPS(qtnf_pcie_pm_ops, qtnf_pcie_suspend,
>                          qtnf_pcie_resume);
>  #endif
> 
> -static struct pci_device_id qtnf_pcie_devid_table[] = {
> +static const struct pci_device_id qtnf_pcie_devid_table[] = {
>         {
>                 PCIE_VENDOR_ID_QUANTENNA, PCIE_DEVICE_ID_QTN_PEARL,
>                 PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> --
> 2.7.4

Thanks !

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
