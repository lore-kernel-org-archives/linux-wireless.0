Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:52346 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753148AbZAOKDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 05:03:17 -0500
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCHv2] iwl3945: report killswitch changes even if the interface is
 down
MIME-Version: 1.0
Date: Thu, 15 Jan 2009 11:01:25 +0100
From: <samuel@sortiz.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ipw3945-devel@lists.sourceforge.net, mabbaswireless@gmail.com,
	tomas.winkler@intel.com, yi.zhu@intel.com,
	reinette.chatre@intel.com, dcbw@redhat.com
In-Reply-To: <200901150938.45058.helmut.schaa@gmail.com>
References: <200901150938.45058.helmut.schaa@gmail.com>
Message-ID: <06316e16bbe98bae31cd022f156f6f49@localhost> (sfid-20090115_110324_320195_0076740E)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 15 Jan 2009 09:38:44 +0100, Helmut Schaa

<helmut.schaa@googlemail.com> wrote:

> Currently iwl3945 is not able to report hw-killswitch events while the

> interface is down. This has implications on user space tools (like

> NetworkManager) relying on rfkill notifications to bring the interface

> up once the wireless gets enabled through a hw killswitch.

> 

> Thus, enable the device already in iwl3945_pci_probe instead of

iwl3945_up

> and poll the CSR_GP_CNTRL register to update the killswitch state every

> two seconds. The polling is only needed on 3945 hardware as this adapter

> does not use interrupts to signal rfkill changes to the driver (in case

no

> firmware is loaded). The firmware loading is still done in iwl3945_up.

> 

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Thanks Helmut.



Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>



> ---

> 

> I did not do any power measurements but I think it is more efficient to

> leave the pci device enabled (without firmware being loaded) then to

change

> NetworkManagers behaviour to keep the interface up all the time just to

get

> rfkill notifications (which means the firmware has to be loaded).

> 

> Changes since the first version:

> Stop polling when the firmware is loaded and start it again when the

> interface

> goes down.

> 

> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h

> b/drivers/net/wireless/iwlwifi/iwl-dev.h

> index fd34ba8..4d437cf 100644

> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h

> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h

> @@ -1041,6 +1041,7 @@ struct iwl_priv {

>  

>  	/*For 3945 only*/

>  	struct delayed_work thermal_periodic;

> +	struct delayed_work rfkill_poll;

>  

>  	/* TX Power */

>  	s8 tx_power_user_lmt;

> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c

> b/drivers/net/wireless/iwlwifi/iwl3945-base.c

> index 15425a0..1ca417d 100644

> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c

> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c

> @@ -5479,7 +5479,8 @@ static void iwl3945_bg_rf_kill(struct work_struct

> *work)

>  		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL,

>  			  "HW and/or SW RF Kill no longer active, restarting "

>  			  "device\n");

> -		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))

> +		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) && 

> +		     test_bit(STATUS_ALIVE, &priv->status))

>  			queue_work(priv->workqueue, &priv->restart);

>  	} else {

>  

> @@ -5496,6 +5497,25 @@ static void iwl3945_bg_rf_kill(struct work_struct

> *work)

>  	iwl3945_rfkill_set_hw_state(priv);

>  }

>  

> +static void iwl3945_rfkill_poll(struct work_struct *data)

> +{

> +	struct iwl_priv *priv =

> +	    container_of(data, struct iwl_priv, rfkill_poll.work);

> +	unsigned long status = priv->status;

> +

> +	if (iwl_read32(priv, CSR_GP_CNTRL) &

CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)

> +		clear_bit(STATUS_RF_KILL_HW, &priv->status);

> +	else

> +		set_bit(STATUS_RF_KILL_HW, &priv->status);

> +

> +	if (test_bit(STATUS_RF_KILL_HW, &status) != test_bit(STATUS_RF_KILL_HW,

> &priv->status))

> +		queue_work(priv->workqueue, &priv->rf_kill);

> +

> +	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,

> +			   round_jiffies_relative(2 * HZ));

> +

> +}

> +

>  #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)

>  

>  static void iwl3945_bg_scan_check(struct work_struct *data)

> @@ -5898,20 +5918,6 @@ static int iwl3945_mac_start(struct ieee80211_hw

> *hw)

>  

>  	IWL_DEBUG_MAC80211("enter\n");

>  

> -	if (pci_enable_device(priv->pci_dev)) {

> -		IWL_ERR(priv, "Fail to pci_enable_device\n");

> -		return -ENODEV;

> -	}

> -	pci_restore_state(priv->pci_dev);

> -	pci_enable_msi(priv->pci_dev);

> -

> -	ret = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,

> -			  DRV_NAME, priv);

> -	if (ret) {

> -		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);

> -		goto out_disable_msi;

> -	}

> -

>  	/* we should be verifying the device is ready to be opened */

>  	mutex_lock(&priv->mutex);

>  

> @@ -5957,15 +5963,15 @@ static int iwl3945_mac_start(struct ieee80211_hw

> *hw)

>  		}

>  	}

>  

> +	/* ucode is running and will send rfkill notifications,

> +	 * no need to poll the killswitch state anymore */

> +	cancel_delayed_work(&priv->rfkill_poll);

> +

>  	priv->is_open = 1;

>  	IWL_DEBUG_MAC80211("leave\n");

>  	return 0;

>  

>  out_release_irq:

> -	free_irq(priv->pci_dev->irq, priv);

> -out_disable_msi:

> -	pci_disable_msi(priv->pci_dev);

> -	pci_disable_device(priv->pci_dev);

>  	priv->is_open = 0;

>  	IWL_DEBUG_MAC80211("leave - failed\n");

>  	return ret;

> @@ -5996,10 +6002,10 @@ static void iwl3945_mac_stop(struct ieee80211_hw

> *hw)

>  	iwl3945_down(priv);

>  

>  	flush_workqueue(priv->workqueue);

> -	free_irq(priv->pci_dev->irq, priv);

> -	pci_disable_msi(priv->pci_dev);

> -	pci_save_state(priv->pci_dev);

> -	pci_disable_device(priv->pci_dev);

> +

> +	/* start polling the killswitch state again */

> +	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,

> +			   round_jiffies_relative(2 * HZ));

>  

>  	IWL_DEBUG_MAC80211("leave\n");

>  }

> @@ -7207,6 +7213,7 @@ static void iwl3945_setup_deferred_work(struct

> iwl_priv *priv)

>  	INIT_DELAYED_WORK(&priv->init_alive_start,

iwl3945_bg_init_alive_start);

>  	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);

>  	INIT_DELAYED_WORK(&priv->scan_check, iwl3945_bg_scan_check);

> +	INIT_DELAYED_WORK(&priv->rfkill_poll, iwl3945_rfkill_poll);

>  

>  	iwl3945_hw_setup_deferred_work(priv);

>  

> @@ -7497,6 +7504,15 @@ static int iwl3945_pci_probe(struct pci_dev *pdev,

> const struct pci_device_id *e

>  	iwl3945_disable_interrupts(priv);

>  	spin_unlock_irqrestore(&priv->lock, flags);

>  

> +	pci_enable_msi(priv->pci_dev);

> +

> +	err = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,

> +			  DRV_NAME, priv);

> +	if (err) {

> +		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);

> +		goto out_disable_msi;

> +	}

> +

>  	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);

>  	if (err) {

>  		IWL_ERR(priv, "failed to create sysfs device attributes\n");

> @@ -7507,14 +7523,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev,

> const struct pci_device_id *e

>  	iwl3945_setup_deferred_work(priv);

>  	iwl3945_setup_rx_handlers(priv);

>  

> -	/***********************

> -	 * 9. Conclude

> -	 * ********************/

> -	pci_save_state(pdev);

> -	pci_disable_device(pdev);

> -

>  	/*********************************

> -	 * 10. Setup and Register mac80211

> +	 * 9. Setup and Register mac80211

>  	 * *******************************/

>  

>  	err = ieee80211_register_hw(priv->hw);

> @@ -7531,6 +7541,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev,

> const struct pci_device_id *e

>  		IWL_ERR(priv, "Unable to initialize RFKILL system. "

>  				  "Ignoring error: %d\n", err);

>  

> +	/* Start monitoring the killswitch */

> +	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,

> +			   2 * HZ);

> +

>  	return 0;

>  

>   out_remove_sysfs:

> @@ -7539,10 +7553,12 @@ static int iwl3945_pci_probe(struct pci_dev

*pdev,

> const struct pci_device_id *e

>  	iwl3945_free_geos(priv);

>  

>   out_release_irq:

> +	free_irq(priv->pci_dev->irq, priv);

>  	destroy_workqueue(priv->workqueue);

>  	priv->workqueue = NULL;

>  	iwl3945_unset_hw_params(priv);

> -

> + out_disable_msi:

> +	pci_disable_msi(priv->pci_dev);

>   out_iounmap:

>  	pci_iounmap(pdev, priv->hw_base);

>   out_pci_release_regions:

> @@ -7587,6 +7603,8 @@ static void __devexit iwl3945_pci_remove(struct

> pci_dev *pdev)

>  	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);

>  

>  	iwl3945_rfkill_unregister(priv);

> +	cancel_delayed_work(&priv->rfkill_poll);

> +

>  	iwl3945_dealloc_ucode_pci(priv);

>  

>  	if (priv->rxq.bd)

> @@ -7605,6 +7623,9 @@ static void __devexit iwl3945_pci_remove(struct

> pci_dev *pdev)

>  	destroy_workqueue(priv->workqueue);

>  	priv->workqueue = NULL;

>  

> +	free_irq(pdev->irq, priv);

> +	pci_disable_msi(pdev);

> +

>  	pci_iounmap(pdev, priv->hw_base);

>  	pci_release_regions(pdev);

>  	pci_disable_device(pdev);

> @@ -7630,7 +7651,8 @@ static int iwl3945_pci_suspend(struct pci_dev

*pdev,

> pm_message_t state)

>  		iwl3945_mac_stop(priv->hw);

>  		priv->is_open = 1;

>  	}

> -

> +	pci_save_state(pdev);

> +	pci_disable_device(pdev);

>  	pci_set_power_state(pdev, PCI_D3hot);

>  

>  	return 0;

> @@ -7641,6 +7663,8 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)

>  	struct iwl_priv *priv = pci_get_drvdata(pdev);

>  

>  	pci_set_power_state(pdev, PCI_D0);

> +	pci_enable_device(pdev);

> +	pci_restore_state(pdev);

>  

>  	if (priv->is_open)

>  		iwl3945_mac_start(priv->hw);
