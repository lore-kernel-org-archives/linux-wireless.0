Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35877 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756010AbcJYAON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 20:14:13 -0400
Received: by mail-pf0-f196.google.com with SMTP id r16so17767567pfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 17:14:13 -0700 (PDT)
Date: Mon, 24 Oct 2016 17:14:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        briannorris@google.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 5/5] mwifiex: wait for firmware dump completion in
 remove_card
Message-ID: <20161025001405.GE15034@dtor-ws> (sfid-20161025_022352_657798_5920F62D)
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

It would be really great if the driver supported multiple devices. IOW
please avoid module-globals.

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

What exactly happens if I trigger mwifiex_sdio_remove() from sysfs at
the same time this code is running?

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

-- 
Dmitry
