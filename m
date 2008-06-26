Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:42154 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYFZW4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 18:56:25 -0400
Message-ID: <4666621.1214520962096.JavaMail.oracle@acsmt301.oracle.com> (sfid-20080627_005652_370202_A2DFEBE1)
Date: Thu, 26 Jun 2008 17:56:02 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: drago01 <drago01@gmail.com>, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] iwl3945: fix up rfkill kconfig and input
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806270045.50169.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
References: <f6ca9fed0806261455j17848d17pa011ae47246a32@mail.gmail.com> <200806270015.00301.IvDoorn@gmail.com> <f6ca9fed0806261527q75df34d4scbe36e2f63cec275@mail.gmail.com> <200806270045.50169.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- Original Message ---
> On Friday 27 June 2008, drago01 wrote:
> > On Fri, Jun 27, 2008 at 12:15 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > >> diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> > >> b/drivers/net/wireless/iwlwifi/Kconfig
> > >> index a382c00..3148a28 100644
> > >> --- a/drivers/net/wireless/iwlwifi/Kconfig
> > >> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> > >> @@ -105,6 +105,7 @@ config IWL3945
> > >>       select IWLWIFI
> > >>       select MAC80211_LEDS if IWL3945_LEDS
> > >>       select LEDS_CLASS if IWL3945_LEDS
> > >> +     select RFKILL_INPUT if (IWL3945_RFKILL && INPUT)
> > >
> > > That is a big no. Drivers should only use CONFIG_RFKILL and in no way
> > > depend or select RFKILL_INPUT. RFKILL_INPUT is a decision for the user
> > > and doesn't change anything for drivers.
> > 
> > v2 is attached it removed the CONFIG_RFKILL_INPUT stuff and made it
> > depend on CONFIG_RFKILL.
> > That means that the 4965 patch needs to be updated/fixed too.
> 
> Not sure if it should depend or select CONFIG_INPUT,
> but the RFKILL dependencies are now correct.

I'd say depend on, but it's up to you guys + maintainer.

Here's what Documentation/kbuild/kconfig-language.txt says:

  Note:
	select should be used with care. select will force
	a symbol to a value without visiting the dependencies.
	By abusing select you are able to select a symbol FOO even
	if FOO depends on BAR that is not set.
	In general use select only for non-visible symbols
	(no prompts anywhere) and for symbols with no dependencies.
	That will limit the usefulness but on the other hand avoid
	the illegal configurations all over.
	kconfig should one day warn about such things.


and in general select is OK on smallish library-like functions and should
not be used on entire subsystems.  To me that means that it should not
be used in CONFIG_INPUT....


> Thanks,
> 
> Ivo
> 
> > ------
> > This patch fixes the iwl3945 driver to depend on CONFIG_RFKILL and
> > CONFIG_INPUT when RFKILL is used.
> > It removes the dependency on CONFIG_IWLCORE and frees the input
> > device on exit.
> > 
> > Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/Kconfig
> > b/drivers/net/wireless/iwlwifi/Kconfig
> > index a382c00..c7fd8aa 100644
> > --- a/drivers/net/wireless/iwlwifi/Kconfig
> > +++ b/drivers/net/wireless/iwlwifi/Kconfig
> > @@ -105,6 +105,8 @@ config IWL3945
> >  	select IWLWIFI
> >  	select MAC80211_LEDS if IWL3945_LEDS
> >  	select LEDS_CLASS if IWL3945_LEDS
> > +	select RFKILL if IWL3945_RFKILL
> > +	select INPUT if IWL3945_RFKILL
> >  	---help---
> >  	  Select to build the driver supporting the:
> > 
> > @@ -127,6 +129,10 @@ config IWL3945
> >  	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
> >  	  module will be called iwl3945.ko.
> > 
> > +config IWL3945_RFKILL
> > +	boolean "Enable RF kill support in iwl3945 drivers"
> > +	depends on IWL3945
> > +
> >  config IWL3945_SPECTRUM_MEASUREMENT
> >  	bool "Enable Spectrum Measurement in iwl3945 drivers"
> >  	depends on IWL3945
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h
> > b/drivers/net/wireless/iwlwifi/iwl-3945.h
> > index a774978..4df42ad 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
> > +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
> > @@ -690,7 +690,7 @@ enum {
> > 
> >  #endif
> > 
> > -#ifdef CONFIG_IWLWIFI_RFKILL
> > +#ifdef CONFIG_IWL3945_RFKILL
> >  struct iwl3945_priv;
> > 
> >  struct iwl3945_rfkill_mngr {
> > @@ -800,7 +800,7 @@ struct iwl3945_priv {
> >  	struct iwl3945_init_alive_resp card_alive_init;
> >  	struct iwl3945_alive_resp card_alive;
> > 
> > -#ifdef CONFIG_IWLWIFI_RFKILL
> > +#ifdef CONFIG_IWL3945_RFKILL
> >  	struct iwl3945_rfkill_mngr rfkill_mngr;
> >  #endif
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > index 43cb8ff..e12baaa 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -8282,7 +8282,7 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
> >  #endif /* CONFIG_PM */
> > 
> >  /*************** RFKILL FUNCTIONS **********/
> > -#ifdef CONFIG_IWLWIFI_RFKILL
> > +#ifdef CONFIG_IWL3945_RFKILL
> >  /* software rf-kill from user */
> >  static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
> >  {
> > @@ -8391,8 +8391,11 @@ error:
> >  void iwl3945_rfkill_unregister(struct iwl3945_priv *priv)
> >  {
> > 
> > -	if (priv->rfkill_mngr.input_dev)
> > +	if (priv->rfkill_mngr.input_dev) {
> >  		input_unregister_device(priv->rfkill_mngr.input_dev);
> > +		input_free_device(priv->rfkill_mngr.input_dev);
> > +	}
> > +
> > 
> >  	if (priv->rfkill_mngr.rfkill)
> >  		rfkill_unregister(priv->rfkill_mngr.rfkill);
> > 
> 
> 

