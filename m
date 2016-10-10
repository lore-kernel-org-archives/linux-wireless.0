Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36613 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbcJJUxg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 16:53:36 -0400
Received: by mail-pf0-f172.google.com with SMTP id e6so1259834pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2016 13:53:36 -0700 (PDT)
Date: Mon, 10 Oct 2016 13:53:33 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        Xinming Hu <huxm@marvell.com>, abhishekbh@google.com
Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161010205332.GB11254@localhost> (sfid-20161010_225339_529800_C0B58F4E)
References: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Thu, Oct 06, 2016 at 11:36:24PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> card->adapter gets initialized during device registration.
> As it's not cleared, we may end up accessing invalid memory
> in some corner cases. This patch fixes the problem.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v4: Same as v1, v2, v3
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

As discussed on v1, I had qualms about the raciness between reads/writes
of card->adapter, but I believe we:
(a) can't have any command activity while writing the ->adapter field
(either we're just init'ing the device, or we've disabled interrupts and
are tearing it down) and
(b) can't have a race between suspend()/resume() and unregister_dev(),
since unregister_dev() is called from device remove() (which should not
be concurrent with suspend()).

Also, I thought you had the same problem in usb.c, but in fact, you
fixed that ages ago here:

353d2a69ea26 mwifiex: fix issues in driver unload path for USB chipsets

Would be nice if fixes were bettery synchronized across the three
interface drivers you support. We seem to be discovering unnecessary
divergence on a few points recently.

At any rate:

Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>

Thanks.
