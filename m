Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:41511 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbYGAOJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 10:09:28 -0400
Received: by ug-out-1314.google.com with SMTP id h2so402809ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 07:09:26 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: remove input device from iwl3945
Date: Tue, 1 Jul 2008 16:13:43 +0200
Cc: linux-wireless@vger.kernel.org,
	Adel Gadllah <adel.gadllah@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Fabien Crespel <fcrespel@gmail.com>, Zhu Yi <yi.zhu@intel.com>
References: <8AD95083DC3E36478732061D97524415035E38AB@pdsmsx411.ccr.corp.intel.com> <1214918580-5855-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1214918580-5855-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200807011613.43501.IvDoorn@gmail.com> (sfid-20080701_160952_949815_08DDD040)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 July 2008, John W. Linville wrote:
> I merged an early version of a patch and missed some bits included in a
> later version.
> 
> 	http://marc.info/?l=linux-wireless&m=121481826531792&w=2
> 
> I have replicated the missing bits here.

Not a problem in this or above mentioned patch, but more a comment
on rfkill handling in the iwlwifi driver.

How is the changed rfkill state of the driver reported to rfkill?
I see that the patch to remove the input device doesn't remove the
call input_report_key() by which I assume such call was never made.
This would mean rfkill support in iwlwifi has always been broken and
the entire input device wasn't used at all.

>From what I gather from the code itself is the function responsible
for changing the state iwl_rfkill_set_hw_state() but that only updates
the state, and doesn't report anything to the rfkill layer.

Ivo

> Cc: Adel Gadllah <adel.gadllah@gmail.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Ivo van Doorn <ivdoorn@gmail.com>
> Cc: Fabien Crespel <fcrespel@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/Kconfig        |    5 +++
>  drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   38 +-------------------------
>  3 files changed, 9 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
> index b628a44..82b66a3 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -104,6 +104,7 @@ config IWL3945
>  	select IWLWIFI
>  	select MAC80211_LEDS if IWL3945_LEDS
>  	select LEDS_CLASS if IWL3945_LEDS
> +	select RFKILL if IWL3945_RFKILL
>  	---help---
>  	  Select to build the driver supporting the:
>  
> @@ -126,6 +127,10 @@ config IWL3945
>  	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
>  	  module will be called iwl3945.ko.
>  
> +config IWL3945_RFKILL
> +	bool "Enable RF kill support in iwl3945 drivers"
> +	depends on IWL3945
> +
>  config IWL3945_SPECTRUM_MEASUREMENT
>  	bool "Enable Spectrum Measurement in iwl3945 drivers"
>  	depends on IWL3945
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
> index a774978..4df42ad 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
> @@ -690,7 +690,7 @@ enum {
>  
>  #endif
>  
> -#ifdef CONFIG_IWLWIFI_RFKILL
> +#ifdef CONFIG_IWL3945_RFKILL
>  struct iwl3945_priv;
>  
>  struct iwl3945_rfkill_mngr {
> @@ -800,7 +800,7 @@ struct iwl3945_priv {
>  	struct iwl3945_init_alive_resp card_alive_init;
>  	struct iwl3945_alive_resp card_alive;
>  
> -#ifdef CONFIG_IWLWIFI_RFKILL
> +#ifdef CONFIG_IWL3945_RFKILL
>  	struct iwl3945_rfkill_mngr rfkill_mngr;
>  #endif
>  
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 3bc2644..a604a29 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -8270,7 +8270,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
>  #endif /* CONFIG_PM */
>  
>  /*************** RFKILL FUNCTIONS **********/
> -#ifdef CONFIG_IWLWIFI_RFKILL
> +#ifdef CONFIG_IWL3945_RFKILL
>  /* software rf-kill from user */
>  static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  {
> @@ -8331,44 +8331,15 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
>  	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
>  	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
>  
> -	priv->rfkill_mngr.input_dev = input_allocate_device();
> -	if (!priv->rfkill_mngr.input_dev) {
> -		IWL_ERROR("Unable to allocate rfkill input device.\n");
> -		ret = -ENOMEM;
> -		goto freed_rfkill;
> -	}
> -
> -	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
> -	priv->rfkill_mngr.input_dev->phys = wiphy_name(priv->hw->wiphy);
> -	priv->rfkill_mngr.input_dev->id.bustype = BUS_HOST;
> -	priv->rfkill_mngr.input_dev->id.vendor = priv->pci_dev->vendor;
> -	priv->rfkill_mngr.input_dev->dev.parent = device;
> -	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
> -	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
> -
>  	ret = rfkill_register(priv->rfkill_mngr.rfkill);
>  	if (ret) {
>  		IWL_ERROR("Unable to register rfkill: %d\n", ret);
> -		goto free_input_dev;
> -	}
> -
> -	ret = input_register_device(priv->rfkill_mngr.input_dev);
> -	if (ret) {
> -		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
> -		goto unregister_rfkill;
> +		goto freed_rfkill;
>  	}
>  
>  	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
>  	return ret;
>  
> -unregister_rfkill:
> -	rfkill_unregister(priv->rfkill_mngr.rfkill);
> -	priv->rfkill_mngr.rfkill = NULL;
> -
> -free_input_dev:
> -	input_free_device(priv->rfkill_mngr.input_dev);
> -	priv->rfkill_mngr.input_dev = NULL;
> -
>  freed_rfkill:
>  	if (priv->rfkill_mngr.rfkill != NULL)
>  		rfkill_free(priv->rfkill_mngr.rfkill);
> @@ -8381,14 +8352,9 @@ error:
>  
>  void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
>  {
> -
> -	if (priv->rfkill_mngr.input_dev)
> -		input_unregister_device(priv->rfkill_mngr.input_dev);
> -
>  	if (priv->rfkill_mngr.rfkill)
>  		rfkill_unregister(priv->rfkill_mngr.rfkill);
>  
> -	priv->rfkill_mngr.input_dev = NULL;
>  	priv->rfkill_mngr.rfkill = NULL;
>  }
>  


