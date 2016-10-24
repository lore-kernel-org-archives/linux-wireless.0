Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33880 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753745AbcJXUXi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 16:23:38 -0400
Received: by mail-pf0-f180.google.com with SMTP id r16so104528279pfg.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 13:23:38 -0700 (PDT)
Date: Mon, 24 Oct 2016 13:23:33 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        dmitry.torokhov@gmail.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Message-ID: <20161024202332.GD968@localhost> (sfid-20161024_222344_116988_10FF2B62)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-5-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477318892-22877-5-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2016 at 07:51:32PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch ensures to wait for firmware dump completion in
> mwifiex_remove_card().
> 
> For sdio interface, reset_trigger variable is used to identify
> if mwifiex_sdio_remove() is called by sdio_work during reset or
> the call is from sdio subsystem.
> 
> This patch fixes a kernel crash observed during reboot when firmware
> dump operation is in process.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c |  2 ++
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 986bf07..4512e86 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -528,6 +528,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>  	if (!adapter || !adapter->priv_num)
>  		return;
>  
> +	cancel_work_sync(&pcie_work);

Is there a good reason you have to cancel the work? What if you were
just to finish it (i.e., flush_work())?

In any case, I think this is fine, so for the PCIe bits:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> +
>  	if (user_rmmod && !adapter->mfg_mode) {
>  #ifdef CONFIG_PM_SLEEP
>  		if (adapter->is_suspended)
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 4cad1c2..f974260 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -46,6 +46,15 @@
>   */
>  static u8 user_rmmod;
>  
> +/* reset_trigger variable is used to identify if mwifiex_sdio_remove()
> + * is called by sdio_work during reset or the call is from sdio subsystem.
> + * We will cancel sdio_work only if the call is from sdio subsystem.
> + */
> +static u8 reset_triggered;
> +
> +static void mwifiex_sdio_work(struct work_struct *work);
> +static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
> +
>  static struct mwifiex_if_ops sdio_ops;
>  static unsigned long iface_work_flags;
>  
> @@ -289,6 +298,9 @@ mwifiex_sdio_remove(struct sdio_func *func)
>  	if (!adapter || !adapter->priv_num)
>  		return;
>  
> +	if (!reset_triggered)
> +		cancel_work_sync(&sdio_work);
> +
>  	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
>  
>  	if (user_rmmod && !adapter->mfg_mode) {
> @@ -2290,7 +2302,9 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
>  	 * discovered and initializes them from scratch.
>  	 */
>  
> +	reset_triggered = 1;
>  	mwifiex_sdio_remove(func);
> +	reset_triggered = 0;

Boy that's ugly! Couldn't you just create something like
__mwifiex_sdio_remove(), which does everything except the
cancel_work_sync()? Then you'd do this for the .remove() callback:

	cancel_work_sync(&sdio_work);
	__mwifiex_sdio_remove(func);

and for mwifiex_recreate_adapter() you'd just call
__mwifiex_sdio_remove()? The static variable that simply serves as a
(non-reentrant) function call parameter seems like a really poor
alternative to this simple refactoring.

Or you could just address the TODO in this function, and you wouldn't
have to do this dance at all...

Brian

>  
>  	/* power cycle the adapter */
>  	sdio_claim_host(func);
> @@ -2621,7 +2635,6 @@ static void mwifiex_sdio_work(struct work_struct *work)
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
