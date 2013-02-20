Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43497 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933343Ab3BTAJl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 19:09:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 19 Feb 2013 16:09:35 -0800
Subject: RE: [PATCH] mwifiex: don't drop carrier flag over suspend
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D6CE5CF@SC-VEXCH1.marvell.com> (sfid-20130220_010945_756553_6382CD0A)
References: <20130219200947.70319FA975@dev.laptop.org>
In-Reply-To: <20130219200947.70319FA975@dev.laptop.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> If the system suspends with mwifiex wifi powered on, and is then woken
> by an ICMP ping packet, the ping response is discarded by the kernel
> because the kernel incorrectly thinks there is no carrier.
> 
> I can't see any valid reason to want to report loss of carrier here,
> so remove the offending code.
> 
> Fixes http://dev.laptop.org/ticket/12554

Thanks for the patch.

> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/pcie.c | 10 +---------
>  drivers/net/wireless/mwifiex/sdio.c |  9 ---------
>  2 files changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index b879e13..db29dea 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -157,7 +157,7 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	struct mwifiex_adapter *adapter;
>  	struct pcie_service_card *card;
> -	int hs_actived, i;
> +	int hs_actived;
> 
>  	if (pdev) {
>  		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
> @@ -177,9 +177,6 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
>  	/* Indicate device suspended */
>  	adapter->is_suspended = true;
> 
> -	for (i = 0; i < adapter->priv_num; i++)
> -		netif_carrier_off(adapter->priv[i]->netdev);
> -
>  	return 0;
>  }
> 
> @@ -195,7 +192,6 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
>  {
>  	struct mwifiex_adapter *adapter;
>  	struct pcie_service_card *card;
> -	int i;
> 
>  	if (pdev) {
>  		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
> @@ -217,10 +213,6 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
> 
>  	adapter->is_suspended = false;
> 
> -	for (i = 0; i < adapter->priv_num; i++)
> -		if (adapter->priv[i]->media_connected)
> -			netif_carrier_on(adapter->priv[i]->netdev);
> -
>  	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
>  			  MWIFIEX_ASYNC_CMD);
> 
> diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
> index 5a1c1d0..133ecb5 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -161,7 +161,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
>  	struct sdio_mmc_card *card;
>  	struct mwifiex_adapter *adapter;
>  	mmc_pm_flag_t pm_flag = 0;
> -	int i;
>  	int ret = 0;
> 
>  	if (func) {
> @@ -198,9 +197,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
>  	/* Indicate device suspended */
>  	adapter->is_suspended = true;
> 
> -	for (i = 0; i < adapter->priv_num; i++)
> -		netif_carrier_off(adapter->priv[i]->netdev);
> -
>  	return ret;
>  }
> 
> @@ -220,7 +216,6 @@ static int mwifiex_sdio_resume(struct device *dev)
>  	struct sdio_mmc_card *card;
>  	struct mwifiex_adapter *adapter;
>  	mmc_pm_flag_t pm_flag = 0;
> -	int i;
> 
>  	if (func) {
>  		pm_flag = sdio_get_host_pm_caps(func);
> @@ -243,10 +238,6 @@ static int mwifiex_sdio_resume(struct device *dev)
> 
>  	adapter->is_suspended = false;
> 
> -	for (i = 0; i < adapter->priv_num; i++)
> -		if (adapter->priv[i]->media_connected)
> -			netif_carrier_on(adapter->priv[i]->netdev);
> -
>  	/* Disable Host Sleep */
>  	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
>  			  MWIFIEX_ASYNC_CMD);
> --
> 1.8.1.2

