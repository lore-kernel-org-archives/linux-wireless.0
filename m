Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33459 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbcJDV6T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 17:58:19 -0400
Received: by mail-pf0-f169.google.com with SMTP id 190so33071257pfv.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 14:58:18 -0700 (PDT)
Date: Tue, 4 Oct 2016 14:58:15 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161004215814.GB31652@localhost> (sfid-20161004_235822_630834_08D0ADE0)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 04, 2016 at 10:38:24PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> card->adapter gets initialized during device registration.
> As it's not cleared, we may end up accessing invalid memory
> in some corner cases. This patch fixes the problem.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: Same as v1
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index f1eeb73..ba9e068 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
>  				pci_disable_msi(pdev);
>  	       }
>  	}
> +	card->adapter = NULL;

I think you have a similar problem here as in patch 2; there is no
locking to protect fields in struct pcie_service_card or struct
sdio_mmc_card below. That problem kind of already exists, except that
you only write the value of card->adapter once at registration time, so
it's not actually unsafe. But now that you're introducing a second
write, you have a problem.

Brian

>  }
>  
>  /* This function initializes the PCI-E host memory space, WCB rings, etc.
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 8718950..4cad1c2 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -2066,6 +2066,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
>  	struct sdio_mmc_card *card = adapter->card;
>  
>  	if (adapter->card) {
> +		card->adapter = NULL;
>  		sdio_claim_host(card->func);
>  		sdio_disable_func(card->func);
>  		sdio_release_host(card->func);
> -- 
> 1.9.1
> 
