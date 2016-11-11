Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35632 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934727AbcKKUtP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 15:49:15 -0500
Received: by mail-pf0-f182.google.com with SMTP id i88so13158085pfk.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2016 12:49:15 -0800 (PST)
Date: Fri, 11 Nov 2016 12:42:36 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v2 3/3] mwifiex: Enable WoWLAN for both sdio and pcie
Message-ID: <20161111204235.GB111624@google.com> (sfid-20161111_214919_815306_A3C29587)
References: <1478862911-15498-1-git-send-email-akarwar@marvell.com>
 <1478862911-15498-3-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478862911-15498-3-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 11, 2016 at 04:45:11PM +0530, Amitkumar Karwar wrote:
> From: Rajat Jain <rajatja@google.com>
> 
> Commit ce4f6f0c353b ("mwifiex: add platform specific wakeup interrupt
> support") added WoWLAN feature only for sdio. This patch moves that
> code to the common module so that all the interface drivers can use
> it for free. It enables pcie and sdio for its use currently.
> 
> Signed-off-by: Rajat Jain <rajatja@google.com>
> ---
> v2: v1 doesn't apply smoothly on latest code due to recently merged
> patch "mwifiex: report error to PCIe for suspend failure". Minor
> conflict is resolved in v2
> ---

In case you haven't noticed my comments elsewhere, I'll repeat them
here: you're copy-and-pasting buggy code. That can be OK I suppose, but
please fix these issues, possibly in a follow-up patch.

>  drivers/net/wireless/marvell/mwifiex/main.c | 41 ++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/main.h | 25 ++++++++++
>  drivers/net/wireless/marvell/mwifiex/pcie.c |  2 +
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 72 ++---------------------------
>  drivers/net/wireless/marvell/mwifiex/sdio.h |  8 ----
>  5 files changed, 73 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index b2f3d96..20c9b77 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -1552,14 +1552,55 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
>  }
>  EXPORT_SYMBOL_GPL(mwifiex_do_flr);
>  
> +static irqreturn_t mwifiex_irq_wakeup_handler(int irq, void *priv)
> +{
> +	struct mwifiex_adapter *adapter = priv;
> +
> +	if (adapter->irq_wakeup >= 0) {
> +		dev_dbg(adapter->dev, "%s: wake by wifi", __func__);
> +		adapter->wake_by_wifi = true;

This flag is unecessary and buggy. IIUC, you're trying to avoid calling
disable_irq() in resume(), if you've called it here?

> +		disable_irq_nosync(irq);

...but this is unnecessary, I think, unless you're trying to make up for
buggy wakeup interrupts that keep firing? See my suggestion below.

> +	}
> +
> +	/* Notify PM core we are wakeup source */
> +	pm_wakeup_event(adapter->dev, 0);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
>  {
> +	int ret;
>  	struct device *dev = adapter->dev;
>  
>  	if (!dev->of_node)
>  		return;
>  
>  	adapter->dt_node = dev->of_node;
> +	adapter->irq_wakeup = irq_of_parse_and_map(adapter->dt_node, 0);
> +	if (!adapter->irq_wakeup) {
> +		dev_info(dev, "fail to parse irq_wakeup from device tree\n");
> +		return;
> +	}
> +
> +	ret = devm_request_irq(dev, adapter->irq_wakeup,
> +			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
> +			       "wifi_wake", adapter);
> +	if (ret) {
> +		dev_err(dev, "Failed to request irq_wakeup %d (%d)\n",
> +			adapter->irq_wakeup, ret);
> +		goto err_exit;
> +	}
> +
> +	disable_irq(adapter->irq_wakeup);
> +	if (device_init_wakeup(dev, true)) {
> +		dev_err(dev, "fail to init wakeup for mwifiex\n");
> +		goto err_exit;
> +	}
> +	return;
> +
> +err_exit:
> +	adapter->irq_wakeup = 0;
>  }
>  
>  /*
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 0c07434..11abc49 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -1011,6 +1011,10 @@ struct mwifiex_adapter {
>  	bool usb_mc_setup;
>  	struct cfg80211_wowlan_nd_info *nd_info;
>  	struct ieee80211_regdomain *regd;
> +
> +	/* Wake-on-WLAN (WoWLAN) */
> +	int irq_wakeup;
> +	bool wake_by_wifi;
>  };
>  
>  void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
> @@ -1410,6 +1414,27 @@ static inline u8 mwifiex_is_tdls_link_setup(u8 status)
>  	return false;
>  }
>  
> +/* Disable platform specific wakeup interrupt */
> +static inline void mwifiex_disable_wake(struct mwifiex_adapter *adapter)
> +{
> +	if (adapter->irq_wakeup >= 0) {
> +		disable_irq_wake(adapter->irq_wakeup);
> +		if (!adapter->wake_by_wifi)

You're depending on the wake IRQ handler to set this flag, so you don't
disable the IRQ twice (the calls nest). But what if the IRQ is being
serviced concurrently with this? Then you'll double-disable the IRQ.

I believe you can just remove the disable_irq_nosync() from the handler,
kill the above flag, and just unconditionally disable the IRQ.

> +			disable_irq(adapter->irq_wakeup);
> +	}
> +}
> +
> +/* Enable platform specific wakeup interrupt */
> +static inline void mwifiex_enable_wake(struct mwifiex_adapter *adapter)
> +{
> +	/* Enable platform specific wakeup interrupt */
> +	if (adapter->irq_wakeup >= 0) {
> +		adapter->wake_by_wifi = false;
> +		enable_irq(adapter->irq_wakeup);
> +		enable_irq_wake(adapter->irq_wakeup);
> +	}
> +}
> +
>  int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
>  			     u32 func_init_shutdown);
>  int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8,
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index fe7f3b0..a38994e 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -131,6 +131,7 @@ static int mwifiex_pcie_suspend(struct device *dev)
>  	}
>  
>  	adapter = card->adapter;
> +	mwifiex_enable_wake(adapter);
>  
>  	/* Enable the Host Sleep */
>  	if (!mwifiex_enable_hs(adapter)) {

^^^ What if this fails? Then you'll leave the wake IRQ enabled.

(You've propagated this error from the SDIO driver.)

> @@ -186,6 +187,7 @@ static int mwifiex_pcie_resume(struct device *dev)
>  
>  	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
>  			  MWIFIEX_ASYNC_CMD);
> +	mwifiex_disable_wake(adapter);
>  
>  	return 0;
>  }
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 558743a..ff5bb45 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -79,67 +79,18 @@
>  	{ }
>  };
>  
> -static irqreturn_t mwifiex_wake_irq_wifi(int irq, void *priv)
> -{
> -	struct mwifiex_plt_wake_cfg *cfg = priv;
> -
> -	if (cfg->irq_wifi >= 0) {
> -		pr_info("%s: wake by wifi", __func__);
> -		cfg->wake_by_wifi = true;
> -		disable_irq_nosync(irq);
> -	}
> -
> -	/* Notify PM core we are wakeup source */
> -	pm_wakeup_event(cfg->dev, 0);
> -
> -	return IRQ_HANDLED;
> -}
> -
>  /* This function parse device tree node using mmc subnode devicetree API.
>   * The device node is saved in card->plt_of_node.
>   * if the device tree node exist and include interrupts attributes, this
>   * function will also request platform specific wakeup interrupt.
>   */
> -static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
> +static int mwifiex_sdio_probe_of(struct device *dev)
>  {
> -	struct mwifiex_plt_wake_cfg *cfg;
> -	int ret;
> -
>  	if (!of_match_node(mwifiex_sdio_of_match_table, dev->of_node)) {
>  		dev_err(dev, "required compatible string missing\n");
>  		return -EINVAL;
>  	}
>  
> -	card->plt_of_node = dev->of_node;
> -	card->plt_wake_cfg = devm_kzalloc(dev, sizeof(*card->plt_wake_cfg),
> -					  GFP_KERNEL);
> -	cfg = card->plt_wake_cfg;
> -	if (cfg && card->plt_of_node) {
> -		cfg->dev = dev;
> -		cfg->irq_wifi = irq_of_parse_and_map(card->plt_of_node, 0);
> -		if (!cfg->irq_wifi) {
> -			dev_dbg(dev,
> -				"fail to parse irq_wifi from device tree\n");
> -		} else {
> -			ret = devm_request_irq(dev, cfg->irq_wifi,
> -					       mwifiex_wake_irq_wifi,
> -					       IRQF_TRIGGER_LOW,
> -					       "wifi_wake", cfg);
> -			if (ret) {
> -				dev_dbg(dev,
> -					"Failed to request irq_wifi %d (%d)\n",
> -					cfg->irq_wifi, ret);
> -				card->plt_wake_cfg = NULL;
> -				return 0;
> -			}
> -			disable_irq(cfg->irq_wifi);
> -		}
> -	}
> -
> -	ret = device_init_wakeup(dev, true);
> -	if (ret)
> -		dev_err(dev, "fail to init wakeup for mwifiex");
> -
>  	return 0;
>  }
>  
> @@ -199,11 +150,9 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
>  
>  	/* device tree node parsing and platform specific configuration*/
>  	if (func->dev.of_node) {
> -		ret = mwifiex_sdio_probe_of(&func->dev, card);
> -		if (ret) {
> -			dev_err(&func->dev, "SDIO dt node parse failed\n");
> +		ret = mwifiex_sdio_probe_of(&func->dev);
> +		if (ret)
>  			goto err_disable;
> -		}
>  		valid_of_node = true;
>  	}
>  
> @@ -269,12 +218,7 @@ static int mwifiex_sdio_resume(struct device *dev)
>  	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
>  			  MWIFIEX_SYNC_CMD);
>  
> -	/* Disable platform specific wakeup interrupt */
> -	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_wifi >= 0) {
> -		disable_irq_wake(card->plt_wake_cfg->irq_wifi);
> -		if (!card->plt_wake_cfg->wake_by_wifi)
> -			disable_irq(card->plt_wake_cfg->irq_wifi);
> -	}
> +	mwifiex_disable_wake(adapter);
>  
>  	return 0;
>  }
> @@ -354,13 +298,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
>  	}
>  
>  	adapter = card->adapter;
> -
> -	/* Enable platform specific wakeup interrupt */
> -	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_wifi >= 0) {
> -		card->plt_wake_cfg->wake_by_wifi = false;
> -		enable_irq(card->plt_wake_cfg->irq_wifi);
> -		enable_irq_wake(card->plt_wake_cfg->irq_wifi);
> -	}
> +	mwifiex_enable_wake(adapter);
>  
>  	/* Enable the Host Sleep */
>  	if (!mwifiex_enable_hs(adapter)) {

Same problem here. Existing issue.

Brian

> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
> index 07cdd23..b9fbc5c 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.h
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
> @@ -154,12 +154,6 @@
>  	a->mpa_rx.start_port = 0;					\
>  } while (0)
>  
> -struct mwifiex_plt_wake_cfg {
> -	struct device *dev;
> -	int irq_wifi;
> -	bool wake_by_wifi;
> -};
> -
>  /* data structure for SDIO MPA TX */
>  struct mwifiex_sdio_mpa_tx {
>  	/* multiport tx aggregation buffer pointer */
> @@ -243,8 +237,6 @@ struct mwifiex_sdio_card_reg {
>  struct sdio_mmc_card {
>  	struct sdio_func *func;
>  	struct mwifiex_adapter *adapter;
> -	struct device_node *plt_of_node;
> -	struct mwifiex_plt_wake_cfg *plt_wake_cfg;
>  
>  	const char *firmware;
>  	const struct mwifiex_sdio_card_reg *reg;
> -- 
> 1.9.1
> 
