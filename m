Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36574 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934164AbcJ0Ssz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 14:48:55 -0400
Received: by mail-pf0-f170.google.com with SMTP id e6so22343921pfk.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2016 11:48:55 -0700 (PDT)
Date: Thu, 27 Oct 2016 11:48:52 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, dmitry.torokhov@gmail.com,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 5/5] mwifiex: wait firmware dump complete during card
 remove process
Message-ID: <20161027184851.GB28717@localhost> (sfid-20161027_204859_684130_40FA8EC3)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <1477559563-18328-5-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477559563-18328-5-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Oct 27, 2016 at 02:42:43PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Wait for firmware dump complete in card remove function.
> For sdio interface, there are two diffenrent cases,
> card reset trigger sdio_work and firmware dump trigger sdio_work.
> Do code rearrangement for distinguish between these two cases.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: 1. Get rid of reset_triggered flag. Instead split the code and use
>     __mwifiex_sdio_remove() (Brian Norris/Dmitry Torokhov)
>     2. "v1 4/5 mwifiex: firmware dump code rearrangement.." is dropped. So
>     rebased accordingly.
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c |  6 +++++-
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++---
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 9025af7..6c421ad 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -37,6 +37,9 @@ static struct mwifiex_if_ops pcie_ops;
>  
>  static struct semaphore add_remove_card_sem;
>  
> +static void mwifiex_pcie_work(struct work_struct *work);
> +static DECLARE_WORK(pcie_work, mwifiex_pcie_work);

This work_struct didn't need to be static in the first place; it should
be embedded in the 'card' and initialized during device init. Then once
you cancel the work in remove() (like this patch is doing) you can also
kill the cancel_work_sync() from the module_exit() path -- you really
shouldn't be doing work like this in the module_init()/module_exit(). It
all belongs in device init/teardown.

> +
>  static int
>  mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
>  		       size_t size, int flags)
> @@ -249,6 +252,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>  	if (!adapter || !adapter->priv_num)
>  		return;
>  
> +	cancel_work_sync(&pcie_work);

Hmm, actually what happens if we have !adapter? Then that means we've
already torn down the device (e.g., unregister_dev() -- except we
haven't quite fixed that bug, see the other patch series you sent out),
and so we'll never reach this. But that also means we haven't
synchronized any outstanding work.

So this really belongs in one of the earlier mwifiex callbacks
(unregister_dev()?), and not in the device remove() callback.

Same applies to sdio.c I think.

Brian

> +
>  	if (user_rmmod && !adapter->mfg_mode) {
>  #ifdef CONFIG_PM_SLEEP
>  		if (adapter->is_suspended)
> @@ -2716,7 +2721,6 @@ static void mwifiex_pcie_work(struct work_struct *work)
>  		mwifiex_pcie_device_dump_work(save_adapter);
>  }
>  
> -static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
>  /* This function dumps FW information */
>  static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
>  {
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 241d2b3..5d84c563 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -46,6 +46,9 @@
>   */
>  static u8 user_rmmod;
>  
> +static void mwifiex_sdio_work(struct work_struct *work);
> +static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
> +
>  static struct mwifiex_if_ops sdio_ops;
>  static unsigned long iface_work_flags;
>  
> @@ -275,7 +278,7 @@ static int mwifiex_sdio_resume(struct device *dev)
>   * This function removes the interface and frees up the card structure.
>   */
>  static void
> -mwifiex_sdio_remove(struct sdio_func *func)
> +__mwifiex_sdio_remove(struct sdio_func *func)
>  {
>  	struct sdio_mmc_card *card;
>  	struct mwifiex_adapter *adapter;
> @@ -305,6 +308,13 @@ mwifiex_sdio_remove(struct sdio_func *func)
>  	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
>  }
>  
> +static void
> +mwifiex_sdio_remove(struct sdio_func *func)
> +{
> +	cancel_work_sync(&sdio_work);
> +	__mwifiex_sdio_remove(func);
> +}
> +
>  /*
>   * SDIO suspend.
>   *
> @@ -2290,7 +2300,7 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
>  	 * discovered and initializes them from scratch.
>  	 */
>  
> -	mwifiex_sdio_remove(func);
> +	__mwifiex_sdio_remove(func);
>  
>  	/* power cycle the adapter */
>  	sdio_claim_host(func);
> @@ -2623,7 +2633,6 @@ static void mwifiex_sdio_work(struct work_struct *work)
>  		mwifiex_sdio_card_reset_work(save_adapter);
>  }
>  
> -static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
>  /* This function resets the card */
>  static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
>  {
> -- 
> 1.9.1
> 
