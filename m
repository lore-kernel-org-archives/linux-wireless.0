Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34089 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbcDLLur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 07:50:47 -0400
Received: by mail-wm0-f51.google.com with SMTP id l6so184499455wml.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 04:50:46 -0700 (PDT)
Subject: Re: [PATCH v2] mwifiex: fix possible NULL dereference
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1460461597-7309-1-git-send-email-sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
	Christian Daudt <csd@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <570CE113.20200@broadcom.com> (sfid-20160412_135109_836474_1A21B3DB)
Date: Tue, 12 Apr 2016 13:50:43 +0200
MIME-Version: 1.0
In-Reply-To: <1460461597-7309-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12-04-16 13:46, Sudip Mukherjee wrote:
> From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> 
> We have a check for card just after dereferencing it. So if it is NULL
> we have already dereferenced it before its check. Lets dereference it
> after checking card for NULL.

And you are changing the scope of the pdev variable.

Regards,
Arend

> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index edf8b07..d4db9db 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -2884,10 +2884,11 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
>  {
>  	struct pcie_service_card *card = adapter->card;
>  	const struct mwifiex_pcie_card_reg *reg;
> -	struct pci_dev *pdev = card->dev;
>  	int i;
>  
>  	if (card) {
> +		struct pci_dev *pdev = card->dev;
> +
>  		if (card->msix_enable) {
>  			for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
>  				synchronize_irq(card->msix_entries[i].vector);
> 
