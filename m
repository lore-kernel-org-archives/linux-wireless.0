Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36310 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756439AbcJYBAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 21:00:52 -0400
Received: by mail-pf0-f178.google.com with SMTP id e6so108000097pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 18:00:51 -0700 (PDT)
Date: Mon, 24 Oct 2016 18:00:48 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        briannorris@google.com, dmitry.torokhov@gmail.com,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v5 1/4] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161025010048.GA11666@localhost> (sfid-20161025_030056_150681_C8928331)
References: <1476969979-28554-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476969979-28554-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2016 at 06:56:16PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> card->adapter gets initialized in mwifiex_register_dev(). As it's not
> cleared in mwifiex_unregister_dev(), we may end up accessing the memory
> which is already free in below scenario.
> 
> Scenario: Driver initialization is failed due to incorrect firmware or
> some other reason. Meanwhile device reboot/unload occurs.
> 
> Please note that we have 'add_remove_card_sem' semaphore. So if there
> is a race betweem init and remove threads, they will execute one after
> another.

I argued in v4 [1] that this is false, and therefore this patch isn't
really correct. Carrying the NACK here.

Brian

[1] https://patchwork.kernel.org/patch/9365209/

> This patch ensures that "card->adapter" is set to NULL when
> all cleanup is performed in init failure thread. Later remove thread
> can return immediately if "card->adapter" is NULL
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v4: Same as v1, v2, v3
> v5: Patch description is updated to get clear picture. There is no race
> for init and remove threads as per design. This patch just adds missing
> "card->adapter= NULL" change to avoid accessing already freed memory which
> leads to a crash.
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 063c707..302ffd1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -3021,6 +3021,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
>  			if (card->msi_enable)
>  				pci_disable_msi(pdev);
>  	       }
> +		card->adapter = NULL;
>  	}
>  }
>  
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
