Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42580 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbXFOAfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 20:35:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HyzmJ-0006Uk-4C
	for linux-wireless@vger.kernel.org; Fri, 15 Jun 2007 02:35:03 +0200
Received: from 207.47.10.130.static.nextweb.net ([207.47.10.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2007 02:35:03 +0200
Received: from shemminger by 207.47.10.130.static.nextweb.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2007 02:35:03 +0200
To: linux-wireless@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] iwlwifi MSI support (rev3)
Date: Thu, 14 Jun 2007 17:11:55 -0700
Message-ID: <20070614171155.705371a2@localhost>
References: <20070614114809.39106c17@localhost>
	<46718E7A.6090001@garzik.org>
	<20070614154743.140dd6b5@localhost>
	<4671C91E.4020800@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <4671C91E.4020800@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 14 Jun 2007 19:02:54 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Stephen Hemminger wrote:
> > On Thu, 14 Jun 2007 14:52:42 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> Stephen Hemminger wrote:
> >>> The previous patch would crash on remove. pci_disable_msi has to be
> >>> called after free_irq.  FYI - pci_disable_msi is safe if MSI hasn't been
> >>> enabled.
> >>>
> >>> --- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
> >>> +++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-14 11:47:01.000000000 -0700
> >>> @@ -8117,10 +8117,13 @@ static int iwl_pci_probe(struct pci_dev 
> >>>  	/* If power management is turned on, default to AC mode */
> >>>  	priv->power_mode = IWL_POWER_AC;
> >>>  	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
> >>> +
> >>> +	pci_enable_msi(pdev);
> >> The API wants fixing, if code that fails to check return value of 
> >> pci_enable_msi() is being written.
> >>
> >> We should definitely be checking the return value there...
> >>
> >> 	Jeff
> >>
> > 
> > I don't understand. pci_enable_msi() returns error if device doesn't
> > do MSI, that's fine.
> 
> It also returns errors for conditions other than "doesn't do MSI", and 
> therein lies the problem with not checking return values.

Errors:
	Not MSI device  - don't care
	MSI disabled globally	- don-t care
	Already doing MSI-X  - message already, don't care
	Out of memory can't setup - don't care

The error codes are a mess so it is better to just not print anything
and just continue on with normal INT mode.

	


