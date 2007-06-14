Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48331 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXFNSwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 14:52:46 -0400
Message-ID: <46718E7A.6090001@garzik.org>
Date: Thu, 14 Jun 2007 14:52:42 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi MSI support (rev3)
References: <20070614114809.39106c17@localhost>
In-Reply-To: <20070614114809.39106c17@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Hemminger wrote:
> The previous patch would crash on remove. pci_disable_msi has to be
> called after free_irq.  FYI - pci_disable_msi is safe if MSI hasn't been
> enabled.
> 
> --- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
> +++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-14 11:47:01.000000000 -0700
> @@ -8117,10 +8117,13 @@ static int iwl_pci_probe(struct pci_dev 
>  	/* If power management is turned on, default to AC mode */
>  	priv->power_mode = IWL_POWER_AC;
>  	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
> +
> +	pci_enable_msi(pdev);

The API wants fixing, if code that fails to check return value of 
pci_enable_msi() is being written.

We should definitely be checking the return value there...

	Jeff



