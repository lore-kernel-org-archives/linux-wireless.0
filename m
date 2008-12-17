Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:64601 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYLQUKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 15:10:13 -0500
Received: by rv-out-0506.google.com with SMTP id k40so60732rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 12:10:12 -0800 (PST)
Message-ID: <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com> (sfid-20081217_211020_955992_707ED4DE)
Date: Wed, 17 Dec 2008 12:10:11 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
Cc: linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
In-Reply-To: <200812161307.07193.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200812161307.07193.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the interrupt moved from pci_probe to mac_start for power saving. once
the interface is up the driver will read some register to know rfkill
status, if the interface in down the driver don't care to keep track
of rfkill switch. I wonder what the purpose of changing this behavior?


On Tue, Dec 16, 2008 at 4:07 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Currently iwlagn is not able to report hw-killswitch events while the
> interface is down. However iwl4965 and iwl5000 are able to report killswitch
> changes via interrupts even if no firmware is loaded.
>
> Thus enable the device and interrupts already in iwl_pci_probe instead of
> iwl_up to get notified when the hw-killswitch state changes. Furthermore
> move the pci deactivation code from iwl_mac_stop to iwl_pci_remove and
> update the killswitch state in the interrupt handler. iwl_bg_rf_kill will
> care about restarting the card if the killswitch was activated while the
> interface was left up.
>
> The patch at least does what it is supposed to do and I used it the last
> few days without noticing any issues. Nevertheless sending as RFC/RFT as I'm
> not completely sure if everything is done correctly.
>
> Thanks for reviewing/commenting.
>
> Btw the patch is against current wireless-testing.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 9d50fad..d57b103 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1413,12 +1413,15 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
>
>                /* driver only loads ucode once setting the interface up.
>                 * the driver as well won't allow loading if RFKILL is set
> -                * therefore no need to restart the driver from this handler
> +                * therefore no need to restart the driver from this handler.
> +                * However the killswitch state should be updated.
>                 */
> -               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
> -                       clear_bit(STATUS_RF_KILL_HW, &priv->status);
> -                       if (priv->is_open && !iwl_is_rfkill(priv))
> -                               queue_work(priv->workqueue, &priv->up);
> +               if (!test_bit(STATUS_ALIVE, &priv->status)) {
> +                       if (hw_rf_kill)
> +                               set_bit(STATUS_RF_KILL_HW, &priv->status);
> +                       else
> +                               clear_bit(STATUS_RF_KILL_HW, &priv->status);
> +                       queue_work(priv->workqueue, &priv->rf_kill);
>                }
>
>                handled |= CSR_INT_BIT_RF_KILL;
> @@ -2044,12 +2047,6 @@ static int __iwl_up(struct iwl_priv *priv)
>                return -EIO;
>        }
>
> -       /* If platform's RF_KILL switch is NOT set to KILL */
> -       if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
> -               clear_bit(STATUS_RF_KILL_HW, &priv->status);
> -       else
> -               set_bit(STATUS_RF_KILL_HW, &priv->status);
> -
>        if (iwl_is_rfkill(priv)) {
>                iwl_enable_interrupts(priv);
>                IWL_WARNING("Radio disabled by %s RF Kill switch\n",
> @@ -2167,7 +2164,7 @@ static void iwl_bg_rf_kill(struct work_struct *work)
>                IWL_DEBUG(IWL_DL_RF_KILL,
>                          "HW and/or SW RF Kill no longer active, restarting "
>                          "device\n");
> -               if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> +               if (!test_bit(STATUS_EXIT_PENDING, &priv->status) && test_bit(STATUS_ALIVE, &priv->status))
>                        queue_work(priv->workqueue, &priv->restart);
>        } else {
>                /* make sure mac80211 stop sending Tx frame */
> @@ -2366,31 +2363,9 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
>  {
>        struct iwl_priv *priv = hw->priv;
>        int ret;
> -       u16 pci_cmd;
>
>        IWL_DEBUG_MAC80211("enter\n");
>
> -       if (pci_enable_device(priv->pci_dev)) {
> -               IWL_ERROR("Fail to pci_enable_device\n");
> -               return -ENODEV;
> -       }
> -       pci_restore_state(priv->pci_dev);
> -       pci_enable_msi(priv->pci_dev);
> -
> -       /* enable interrupts if needed: hw bug w/a */
> -       pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
> -       if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
> -               pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
> -               pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
> -       }
> -
> -       ret = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
> -                         DRV_NAME, priv);
> -       if (ret) {
> -               IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
> -               goto out_disable_msi;
> -       }
> -
>        /* we should be verifying the device is ready to be opened */
>        mutex_lock(&priv->mutex);
>
> @@ -2403,7 +2378,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
>                if (ret) {
>                        IWL_ERROR("Could not read microcode: %d\n", ret);
>                        mutex_unlock(&priv->mutex);
> -                       goto out_release_irq;
> +                       return ret;
>                }
>        }
>
> @@ -2414,7 +2389,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
>        iwl_rfkill_set_hw_state(priv);
>
>        if (ret)
> -               goto out_release_irq;
> +               return ret;
>
>        if (iwl_is_rfkill(priv))
>                goto out;
> @@ -2433,8 +2408,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
>                if (!test_bit(STATUS_READY, &priv->status)) {
>                        IWL_ERROR("START_ALIVE timeout after %dms.\n",
>                                jiffies_to_msecs(UCODE_READY_TIMEOUT));
> -                       ret = -ETIMEDOUT;
> -                       goto out_release_irq;
> +                       return -ETIMEDOUT;
>                }
>        }
>
> @@ -2442,15 +2416,6 @@ out:
>        priv->is_open = 1;
>        IWL_DEBUG_MAC80211("leave\n");
>        return 0;
> -
> -out_release_irq:
> -       free_irq(priv->pci_dev->irq, priv);
> -out_disable_msi:
> -       pci_disable_msi(priv->pci_dev);
> -       pci_disable_device(priv->pci_dev);
> -       priv->is_open = 0;
> -       IWL_DEBUG_MAC80211("leave - failed\n");
> -       return ret;
>  }
>
>  static void iwl_mac_stop(struct ieee80211_hw *hw)
> @@ -2478,10 +2443,10 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
>        iwl_down(priv);
>
>        flush_workqueue(priv->workqueue);
> -       free_irq(priv->pci_dev->irq, priv);
> -       pci_disable_msi(priv->pci_dev);
> -       pci_save_state(priv->pci_dev);
> -       pci_disable_device(priv->pci_dev);
> +
> +       /* enable interrupts again in order to receive rfkill changes*/
> +       iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
> +       iwl_enable_interrupts(priv);
>
>        IWL_DEBUG_MAC80211("leave\n");
>  }
> @@ -3778,6 +3743,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>        struct ieee80211_hw *hw;
>        struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
>        unsigned long flags;
> +       u16 pci_cmd;
>        DECLARE_MAC_BUF(mac);
>
>        /************************
> @@ -3923,6 +3889,15 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>        spin_lock_irqsave(&priv->lock, flags);
>        iwl_disable_interrupts(priv);
>        spin_unlock_irqrestore(&priv->lock, flags);
> +
> +       pci_enable_msi(priv->pci_dev);
> +
> +       err = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
> +                         DRV_NAME, priv);
> +       if (err) {
> +               IWL_ERROR("Error allocating IRQ %d\n", priv->pci_dev->irq);
> +               goto out_disable_msi;
> +       }
>
>        err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
>        if (err) {
> @@ -3930,20 +3905,22 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                goto out_uninit_drv;
>        }
>
> -
>        iwl_setup_deferred_work(priv);
>        iwl_setup_rx_handlers(priv);
>
> -       /********************
> -        * 9. Conclude
> -        ********************/
> -       pci_save_state(pdev);
> -       pci_disable_device(pdev);
> -
>        /**********************************
>         * 10. Setup and register mac80211
>         **********************************/
>
> +       /* enable interrupts if needed: hw bug w/a */
> +       pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
> +       if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
> +               pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
> +               pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
> +       }
> +
> +       iwl_enable_interrupts(priv);
> +
>        err = iwl_setup_mac(priv);
>        if (err)
>                goto out_remove_sysfs;
> @@ -3952,15 +3929,30 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>        if (err)
>                IWL_ERROR("failed to create debugfs files\n");
>
> +       /* If platform's RF_KILL switch is NOT set to KILL */
> +       if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
> +               clear_bit(STATUS_RF_KILL_HW, &priv->status);
> +       else
> +               set_bit(STATUS_RF_KILL_HW, &priv->status);
> +
> +       IWL_DEBUG(IWL_DL_RF_KILL, "RF_KILL bit is %s.\n",
> +                       test_bit(STATUS_RF_KILL_HW, &priv->status) ? "disable radio" : "enable radio");
> +
>        err = iwl_rfkill_init(priv);
>        if (err)
>                IWL_ERROR("Unable to initialize RFKILL system. "
>                                  "Ignoring error: %d\n", err);
> +       else
> +               iwl_rfkill_set_hw_state(priv);
> +
>        iwl_power_initialize(priv);
>        return 0;
>
>  out_remove_sysfs:
>        sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
> + out_disable_msi:
> +       pci_disable_msi(priv->pci_dev);
> +       pci_disable_device(priv->pci_dev);
>  out_uninit_drv:
>        iwl_uninit_drv(priv);
>  out_free_eeprom:
> @@ -4032,6 +4024,9 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
>        destroy_workqueue(priv->workqueue);
>        priv->workqueue = NULL;
>
> +       free_irq(priv->pci_dev->irq, priv);
> +       pci_disable_msi(priv->pci_dev);
> +
>        pci_iounmap(pdev, priv->hw_base);
>        pci_release_regions(pdev);
>        pci_disable_device(pdev);
> @@ -4057,6 +4052,8 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>                priv->is_open = 1;
>        }
>
> +       pci_save_state(pdev);
> +       pci_disable_device(pdev);
>        pci_set_power_state(pdev, PCI_D3hot);
>
>        return 0;
> @@ -4067,6 +4064,9 @@ static int iwl_pci_resume(struct pci_dev *pdev)
>        struct iwl_priv *priv = pci_get_drvdata(pdev);
>
>        pci_set_power_state(pdev, PCI_D0);
> +       pci_enable_device(pdev);
> +       pci_restore_state(pdev);
> +       iwl_enable_interrupts(priv);
>
>        if (priv->is_open)
>                iwl_mac_start(priv->hw);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
