Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34267 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3IOHqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 03:46:54 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'John W. Linville'" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 07/12] wireless: wil6210: remove unnecessary pci_set_drvdata()
Date: Sun, 15 Sep 2013 10:46:50 +0300
Message-ID: <1712658.NzU3oG495s@lx-vladimir> (sfid-20130915_094714_118951_17B16B55)
In-Reply-To: <00b801ceae18$8e5498c0$aafdca40$%han@samsung.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com> <00b801ceae18$8e5498c0$aafdca40$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, September 10, 2013 08:26:13 PM Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/net/wireless/ath/wil6210/pcie_bus.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> index eb1dc7a..eeceab3 100644
> --- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
> +++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
> @@ -197,7 +197,6 @@ static void wil_pcie_remove(struct pci_dev *pdev)
>  	pci_iounmap(pdev, wil->csr);
>  	pci_release_region(pdev, 0);
>  	pci_disable_device(pdev);
> -	pci_set_drvdata(pdev, NULL);
>  }
>  
>  static DEFINE_PCI_DEVICE_TABLE(wil6210_pcie_ids) = {
> 

Here is my

Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
