Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131AbXFNWsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 18:48:12 -0400
Date: Thu, 14 Jun 2007 15:47:43 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi MSI support (rev3)
Message-ID: <20070614154743.140dd6b5@localhost>
In-Reply-To: <46718E7A.6090001@garzik.org>
References: <20070614114809.39106c17@localhost>
	<46718E7A.6090001@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 14 Jun 2007 14:52:42 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Stephen Hemminger wrote:
> > The previous patch would crash on remove. pci_disable_msi has to be
> > called after free_irq.  FYI - pci_disable_msi is safe if MSI hasn't been
> > enabled.
> > 
> > --- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
> > +++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-14 11:47:01.000000000 -0700
> > @@ -8117,10 +8117,13 @@ static int iwl_pci_probe(struct pci_dev 
> >  	/* If power management is turned on, default to AC mode */
> >  	priv->power_mode = IWL_POWER_AC;
> >  	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
> > +
> > +	pci_enable_msi(pdev);
> 
> The API wants fixing, if code that fails to check return value of 
> pci_enable_msi() is being written.
> 
> We should definitely be checking the return value there...
> 
> 	Jeff
> 

I don't understand. pci_enable_msi() returns error if device doesn't
do MSI, that's fine. The device driver doesn't have to care or do anything
different.  The API is well written, it just works.
