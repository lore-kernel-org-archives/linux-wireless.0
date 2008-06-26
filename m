Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:26042 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYFZWoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 18:44:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so59818nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 15:44:22 -0700 (PDT)
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH v2] iwl3945: fix up rfkill kconfig and input
Date: Fri, 27 Jun 2008 00:45:49 +0200
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>
References: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com> <200806270015.00301.IvDoorn@gmail.com> <f6ca9fed0806261527q75df34d4scbe36e2f63cec275@mail.gmail.com>
In-Reply-To: <f6ca9fed0806261527q75df34d4scbe36e2f63cec275@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806270045.50169.IvDoorn@gmail.com> (sfid-20080627_004427_352711_0DFC1803)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 June 2008, drago01 wrote:
> On Fri, Jun 27, 2008 at 12:15 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> >> diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> >> b/drivers/net/wireless/iwlwifi/Kconfig
> >> index a382c00..3148a28 100644
> >> --- a/drivers/net/wireless/iwlwifi/Kconfig
> >> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> >> @@ -105,6 +105,7 @@ config IWL3945
> >>       select IWLWIFI
> >>       select MAC80211_LEDS if IWL3945_LEDS
> >>       select LEDS_CLASS if IWL3945_LEDS
> >> +     select RFKILL_INPUT if (IWL3945_RFKILL && INPUT)
> >
> > That is a big no. Drivers should only use CONFIG_RFKILL and in no way
> > depend or select RFKILL_INPUT. RFKILL_INPUT is a decision for the user
> > and doesn't change anything for drivers.
> 
> v2 is attached it removed the CONFIG_RFKILL_INPUT stuff and made it
> depend on CONFIG_RFKILL.
> That means that the 4965 patch needs to be updated/fixed too.

Not sure if it should depend or select CONFIG_INPUT,
but the RFKILL dependencies are now correct.

Thanks,

Ivo

> ------
> This patch fixes the iwl3945 driver to depend on CONFIG_RFKILL and
> CONFIG_INPUT when RFKILL is used.
> It removes the dependency on CONFIG_IWLCORE and frees the input
> device on exit.
> 
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> b/drivers/net/wireless/iwlwifi/Kconfig
> index a382c00..c7fd8aa 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -105,6 +105,8 @@ config IWL3945
>  	select IWLWIFI
>  	select MAC80211_LEDS if IWL3945_LEDS
>  	select LEDS_CLASS if IWL3945_LEDS
> +	select RFKILL if IWL3945_RFKILL
> +	select INPUT if IWL3945_RFKILL
>  	---help---
>  	  Select to build the driver supporting the:
> 
> @@ -127,6 +129,10 @@ config IWL3945
>  	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
>  	  module will be called iwl3945.ko.
> 
> +config IWL3945_RFKILL
> +	boolean "Enable RF kill support in iwl3945 drivers"
> +	depends on IWL3945
> +
>  config IWL3945_SPECTRUM_MEASUREMENT
>  	bool "Enable Spectrum Measurement in iwl3945 drivers"
>  	depends on IWL3945
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
> b/drivers/net/wireless/iwlwifi/iwl-3945.h
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
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 43cb8ff..e12baaa 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -8282,7 +8282,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
>  #endif /* CONFIG_PM */
> 
>  /*************** RFKILL FUNCTIONS **********/
> -#ifdef CONFIG_IWLWIFI_RFKILL
> +#ifdef CONFIG_IWL3945_RFKILL
>  /* software rf-kill from user */
>  static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  {
> @@ -8391,8 +8391,11 @@ error:
>  void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
>  {
> 
> -	if (priv->rfkill_mngr.input_dev)
> +	if (priv->rfkill_mngr.input_dev) {
>  		input_unregister_device(priv->rfkill_mngr.input_dev);
> +		input_free_device(priv->rfkill_mngr.input_dev);
> +	}
> +
> 
>  	if (priv->rfkill_mngr.rfkill)
>  		rfkill_unregister(priv->rfkill_mngr.rfkill);
> 


