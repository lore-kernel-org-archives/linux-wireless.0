Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:40717 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYFZWNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 18:13:32 -0400
Received: by ik-out-1112.google.com with SMTP id c28so71797ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 15:13:30 -0700 (PDT)
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH] iwl3945: fix up rfkill kconfig and input
Date: Fri, 27 Jun 2008 00:15:00 +0200
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>
References: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com>
In-Reply-To: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806270015.00301.IvDoorn@gmail.com> (sfid-20080627_001337_218786_41A08A31)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 June 2008, drago01 wrote:
> The attached patch fixes iwl3945 to build with CONFIG_INPUT=n and
> frees the input device on exit.
> Additionally it removes the unnecessary dependency on CONFIG_IWLCORE.
> It depends on the rfkill subsystem patch, which is in the iwlwifi-2.6 tree.
> 
> -----------------
> This patch fixes the iwl3945 driver to build with CONFIG_INPUT=n
> and remove the dependency on CONFIG_IWLCORE.
> It also frees the input device on exit.
> Input stuff based on patch from Randy Dunlap for iwl4965/5000.
> 
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> b/drivers/net/wireless/iwlwifi/Kconfig
> index a382c00..3148a28 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -105,6 +105,7 @@ config IWL3945
>  	select IWLWIFI
>  	select MAC80211_LEDS if IWL3945_LEDS
>  	select LEDS_CLASS if IWL3945_LEDS
> +	select RFKILL_INPUT if (IWL3945_RFKILL && INPUT)

That is a big no. Drivers should only use CONFIG_RFKILL and in no way
depend or select RFKILL_INPUT. RFKILL_INPUT is a decision for the user
and doesn't change anything for drivers.

See the linux-wireless thread regarding rfkill:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/16653

> +#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
>  	priv->rfkill_mngr.input_dev = input_allocate_device();
>  	if (!priv->rfkill_mngr.input_dev) {
>  		IWL_ERROR("Unable to allocate rfkill input device.\n");
> @@ -8354,6 +8355,7 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
>  	priv->rfkill_mngr.input_dev->dev.parent = device;
>  	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
>  	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
> +#endif

This is wrong as well, the input device for the driver has no relation whatsoever with
CONFIG_RFKILL_INPUT.

>  	ret = rfkill_register(priv->rfkill_mngr.rfkill);
>  	if (ret) {
> @@ -8361,11 +8363,13 @@ int iwl3945_rfkill_init(struct iwl3945_priv *priv)
>  		goto free_input_dev;
>  	}
> 
> +#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
>  	ret = input_register_device(priv->rfkill_mngr.input_dev);
>  	if (ret) {
>  		IWL_ERROR("Unable to register rfkill input device: %d\n", ret);
>  		goto unregister_rfkill;
>  	}
> +#endif

Same here.

>  	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
>  	return ret;
> @@ -8375,8 +8379,10 @@ unregister_rfkill:
>  	priv->rfkill_mngr.rfkill = NULL;
> 
>  free_input_dev:
> +#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
>  	input_free_device(priv->rfkill_mngr.input_dev);
>  	priv->rfkill_mngr.input_dev = NULL;
> +#endif

And here.

>  freed_rfkill:
>  	if (priv->rfkill_mngr.rfkill != NULL)
> @@ -8391,13 +8397,16 @@ error:
>  void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
>  {
> 
> +#if defined(CONFIG_RFKILL_INPUT) || defined(CONFIG_RFKILL_INPUT_MODULE)
>  	if (priv->rfkill_mngr.input_dev)
>  		input_unregister_device(priv->rfkill_mngr.input_dev);
> +	input_free_device(priv->rfkill_mngr.input_dev);
> +	priv->rfkill_mngr.input_dev = NULL;
> +#endif

And here.

Ivo

