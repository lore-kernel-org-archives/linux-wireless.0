Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35513 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932174AbcKNSSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 13:18:03 -0500
Received: by mail-pf0-f178.google.com with SMTP id i88so30726052pfk.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 10:18:03 -0800 (PST)
Date: Mon, 14 Nov 2016 10:18:00 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v3 3/3] mwifiex: Enable WoWLAN for both sdio and pcie
Message-ID: <20161114181759.GA121274@google.com> (sfid-20161114_191811_095680_01D9AFD4)
References: <1479127752-23745-1-git-send-email-akarwar@marvell.com>
 <1479127752-23745-3-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479127752-23745-3-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 14, 2016 at 06:19:12PM +0530, Amitkumar Karwar wrote:
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
> v3: Same as v2 

For the whole series:

Reviewed-by: Brian Norris <briannorris@chromium.org>

I think there are some trivial conflicts with one of your/our other
series, but that can be worked out once one of them is accepted. I also
expect you'll send patches to fix the existing bugs I noted already.

Also, this implicitly extends device tree support to PCIe devices. While
that's probably OK, it would be good to promptly update a patch like
this:

[PATCH v6] mwifiex: parse device tree node for PCIe
https://patchwork.kernel.org/patch/9390225/

to check for the appropriate compatible properties before accepting the
device and registering the card. That patch should be just a little bit
simpler on top of this patch set.

Brian

> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 41 ++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/main.h | 25 ++++++++++
>  drivers/net/wireless/marvell/mwifiex/pcie.c |  2 +
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 72 ++---------------------------
>  drivers/net/wireless/marvell/mwifiex/sdio.h |  8 ----
>  5 files changed, 73 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 835d330..948f5c2 100644
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
> +		disable_irq_nosync(irq);
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
> index 549e1ba..ae5afe5 100644
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
>  int mwifiex_add_card(void *card, struct semaphore *sem,
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index de6939c..7942b28 100644
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
> @@ -186,6 +187,7 @@ static int mwifiex_pcie_resume(struct device *dev)
>  
>  	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
>  			  MWIFIEX_ASYNC_CMD);
> +	mwifiex_disable_wake(adapter);
>  
>  	return 0;
>  }
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index c95f41f..7055282 100644
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
> @@ -198,11 +149,9 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
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
>  	}
>  
>  	ret = mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops,
> @@ -267,12 +216,7 @@ static int mwifiex_sdio_resume(struct device *dev)
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
> @@ -352,13 +296,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
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
