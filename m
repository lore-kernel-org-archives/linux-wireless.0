Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:35335 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759411AbXFMSlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 14:41:06 -0400
Date: Wed, 13 Jun 2007 11:41:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: MSI support
Message-Id: <20070613114124.65039d8b.randy.dunlap@oracle.com>
In-Reply-To: <20070613112939.3b73f928@localhost>
References: <20070613112939.3b73f928@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 13 Jun 2007 11:29:39 -0700 Stephen Hemminger wrote:

> Add Message Signal Interrupt support to iwlwifi. Tested on 3945.
> Enable by default, but have parameter to disable for buggy platforms.

We prefer to use the system-wide capability to disable/enable MSI
interrupts when it is a platform problem vs. an individual device
problem.  I.e., in general individual drivers should not be adding
such options.


> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> 
> --- a/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:10:10.000000000 -0700
> +++ b/drivers/net/wireless/mac80211/iwlwifi/base.c	2007-06-13 11:26:30.000000000 -0700
> @@ -80,6 +80,8 @@ int param_antenna = 0;      /* def: 0 = 
>  int param_hwcrypto = 0;     /* def: using software encryption */
>  int param_qos_enable = 0;
>  
> +static int disable_msi;
> +
>  /*
>   * module name, copyright, version, etc.
>   * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
> @@ -8117,6 +8119,10 @@ static int iwl_pci_probe(struct pci_dev 
>  	/* If power management is turned on, default to AC mode */
>  	priv->power_mode = IWL_POWER_AC;
>  	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
> +
> +	if (!disable_msi)
> +		pci_enable_msi(pdev);
> +
>  	err = request_irq(pdev->irq, iwl_isr, IRQF_SHARED, DRV_NAME, priv);
>  	if (err) {
>  		IWL_ERROR("Error allocating IRQ %d\n", pdev->irq);
> @@ -8155,6 +8161,7 @@ static int iwl_pci_probe(struct pci_dev 
>  	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
>  
>   out_release_irq:
> +	pci_disable_msi(pdev);
>  	free_irq(pdev->irq, priv);
>  
>   out_destroy_workqueue:
> @@ -8224,6 +8231,8 @@ static void iwl_pci_remove(struct pci_de
>  	destroy_workqueue(priv->workqueue);
>  	priv->workqueue = NULL;
>  
> +	pci_disable_msi(pdev);
> +
>  	free_irq(pdev->irq, priv);
>  	iounmap(priv->hw_base);
>  	pci_release_regions(pdev);
> @@ -8352,6 +8361,9 @@ static void __exit iwl_exit(void)
>  	pci_unregister_driver(&iwl_driver);
>  }
>  
> +module_param(disable_msi, int, 0);
> +MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
> +
>  module_param_named(antenna, param_antenna, int, 0444);
>  MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
>  module_param_named(disable, param_disable, int, 0444);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
