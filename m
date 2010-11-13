Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46273 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab0KMB0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:26:19 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so492216wwb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:26:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289611433-5119-4-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <1289611433-5119-4-git-send-email-brian@cozybit.com>
From: Brian Cavagnolo <brian@cozybit.com>
Date: Fri, 12 Nov 2010 17:25:58 -0800
Message-ID: <AANLkTi=UQY63jD+-zu9K3vFsOduR_VZHZ_9Rz9sHcSN_@mail.gmail.com>
Subject: Re: [PATCH V2 3/7] mwl8k: factor out firmware loading and hw init code
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My apologies.  This is also a V2 patch despite the subject.

On Fri, Nov 12, 2010 at 5:23 PM, Brian Cavagnolo <brian@cozybit.com> wrote:
> This is in preparation for supporting different fw images for
> different interface types, and for supporting asynchronous
> firmware loading.
>
> Based on a patch from Pradeep Nemavat <pnemavat@marvell.com>
> and Yogesh Powar <yogeshp@marvell.com>
>
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> ---
>  drivers/net/wireless/mwl8k.c |  345 ++++++++++++++++++++++++++----------------
>  1 files changed, 214 insertions(+), 131 deletions(-)
>
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index cfda87a..7bd8615 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -3942,73 +3942,10 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
>  };
>  MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
>
> -static int __devinit mwl8k_probe(struct pci_dev *pdev,
> -                                const struct pci_device_id *id)
> +static int mwl8k_init_firmware(struct ieee80211_hw *hw)
>  {
> -       static int printed_version = 0;
> -       struct ieee80211_hw *hw;
> -       struct mwl8k_priv *priv;
> +       struct mwl8k_priv *priv = hw->priv;
>        int rc;
> -       int i;
> -
> -       if (!printed_version) {
> -               printk(KERN_INFO "%s version %s\n", MWL8K_DESC, MWL8K_VERSION);
> -               printed_version = 1;
> -       }
> -
> -
> -       rc = pci_enable_device(pdev);
> -       if (rc) {
> -               printk(KERN_ERR "%s: Cannot enable new PCI device\n",
> -                      MWL8K_NAME);
> -               return rc;
> -       }
> -
> -       rc = pci_request_regions(pdev, MWL8K_NAME);
> -       if (rc) {
> -               printk(KERN_ERR "%s: Cannot obtain PCI resources\n",
> -                      MWL8K_NAME);
> -               goto err_disable_device;
> -       }
> -
> -       pci_set_master(pdev);
> -
> -
> -       hw = ieee80211_alloc_hw(sizeof(*priv), &mwl8k_ops);
> -       if (hw == NULL) {
> -               printk(KERN_ERR "%s: ieee80211 alloc failed\n", MWL8K_NAME);
> -               rc = -ENOMEM;
> -               goto err_free_reg;
> -       }
> -
> -       SET_IEEE80211_DEV(hw, &pdev->dev);
> -       pci_set_drvdata(pdev, hw);
> -
> -       priv = hw->priv;
> -       priv->hw = hw;
> -       priv->pdev = pdev;
> -       priv->device_info = &mwl8k_info_tbl[id->driver_data];
> -
> -
> -       priv->sram = pci_iomap(pdev, 0, 0x10000);
> -       if (priv->sram == NULL) {
> -               wiphy_err(hw->wiphy, "Cannot map device SRAM\n");
> -               goto err_iounmap;
> -       }
> -
> -       /*
> -        * If BAR0 is a 32 bit BAR, the register BAR will be BAR1.
> -        * If BAR0 is a 64 bit BAR, the register BAR will be BAR2.
> -        */
> -       priv->regs = pci_iomap(pdev, 1, 0x10000);
> -       if (priv->regs == NULL) {
> -               priv->regs = pci_iomap(pdev, 2, 0x10000);
> -               if (priv->regs == NULL) {
> -                       wiphy_err(hw->wiphy, "Cannot map device registers\n");
> -                       goto err_iounmap;
> -               }
> -       }
> -
>
>        /* Reset firmware and hardware */
>        mwl8k_hw_reset(priv);
> @@ -4017,19 +3954,26 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
>        rc = mwl8k_request_firmware(priv);
>        if (rc) {
>                wiphy_err(hw->wiphy, "Firmware files not found\n");
> -               goto err_stop_firmware;
> +               return rc;
>        }
>
>        /* Load firmware into hardware */
>        rc = mwl8k_load_firmware(hw);
> -       if (rc) {
> +       if (rc)
>                wiphy_err(hw->wiphy, "Cannot start firmware\n");
> -               goto err_stop_firmware;
> -       }
>
>        /* Reclaim memory once firmware is successfully loaded */
>        mwl8k_release_firmware(priv);
>
> +       return rc;
> +}
> +
> +/* initialize hw after successfully loading a firmware image */
> +static int mwl8k_probe_hw(struct ieee80211_hw *hw)
> +{
> +       struct mwl8k_priv *priv = hw->priv;
> +       int rc = 0;
> +       int i;
>
>        if (priv->ap_fw) {
>                priv->rxd_ops = priv->device_info->ap_rxd_ops;
> @@ -4046,58 +3990,11 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
>        priv->wmm_enabled = false;
>        priv->pending_tx_pkts = 0;
>
> -
> -       /*
> -        * Extra headroom is the size of the required DMA header
> -        * minus the size of the smallest 802.11 frame (CTS frame).
> -        */
> -       hw->extra_tx_headroom =
> -               sizeof(struct mwl8k_dma_data) - sizeof(struct ieee80211_cts);
> -
> -       hw->channel_change_time = 10;
> -
> -       hw->queues = MWL8K_TX_QUEUES;
> -
> -       /* Set rssi values to dBm */
> -       hw->flags |= IEEE80211_HW_SIGNAL_DBM;
> -       hw->vif_data_size = sizeof(struct mwl8k_vif);
> -       hw->sta_data_size = sizeof(struct mwl8k_sta);
> -
> -       priv->macids_used = 0;
> -       INIT_LIST_HEAD(&priv->vif_list);
> -
> -       /* Set default radio state and preamble */
> -       priv->radio_on = 0;
> -       priv->radio_short_preamble = 0;
> -
> -       /* Finalize join worker */
> -       INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
> -
> -       /* TX reclaim and RX tasklets.  */
> -       tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
> -       tasklet_disable(&priv->poll_tx_task);
> -       tasklet_init(&priv->poll_rx_task, mwl8k_rx_poll, (unsigned long)hw);
> -       tasklet_disable(&priv->poll_rx_task);
> -
> -       /* Power management cookie */
> -       priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
> -       if (priv->cookie == NULL)
> -               goto err_stop_firmware;
> -
>        rc = mwl8k_rxq_init(hw, 0);
>        if (rc)
> -               goto err_free_cookie;
> +               goto err_stop_firmware;
>        rxq_refill(hw, 0, INT_MAX);
>
> -       mutex_init(&priv->fw_mutex);
> -       priv->fw_mutex_owner = NULL;
> -       priv->fw_mutex_depth = 0;
> -       priv->hostcmd_wait = NULL;
> -
> -       spin_lock_init(&priv->tx_lock);
> -
> -       priv->tx_wait = NULL;
> -
>        for (i = 0; i < MWL8K_TX_QUEUES; i++) {
>                rc = mwl8k_txq_init(hw, i);
>                if (rc)
> @@ -4137,13 +4034,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
>                goto err_free_irq;
>        }
>
> -       hw->wiphy->interface_modes = 0;
> -       if (priv->ap_macids_supported)
> -               hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
> -       if (priv->sta_macids_supported)
> -               hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
> -
> -
>        /* Turn radio off */
>        rc = mwl8k_cmd_radio_disable(hw);
>        if (rc) {
> @@ -4162,12 +4052,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
>        iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
>        free_irq(priv->pdev->irq, hw);
>
> -       rc = ieee80211_register_hw(hw);
> -       if (rc) {
> -               wiphy_err(hw->wiphy, "Cannot register device\n");
> -               goto err_free_queues;
> -       }
> -
>        wiphy_info(hw->wiphy, "%s v%d, %pm, %s firmware %u.%u.%u.%u\n",
>                   priv->device_info->part_name,
>                   priv->hw_rev, hw->wiphy->perm_addr,
> @@ -4186,14 +4070,213 @@ err_free_queues:
>                mwl8k_txq_deinit(hw, i);
>        mwl8k_rxq_deinit(hw, 0);
>
> +err_stop_firmware:
> +       mwl8k_hw_reset(priv);
> +
> +       return rc;
> +}
> +
> +/*
> + * invoke mwl8k_reload_firmware to change the firmware image after the device
> + * has already been registered
> + */
> +static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
> +{
> +       int i, rc = 0;
> +       struct mwl8k_priv *priv = hw->priv;
> +
> +       mwl8k_stop(hw);
> +       mwl8k_rxq_deinit(hw, 0);
> +
> +       for (i = 0; i < MWL8K_TX_QUEUES; i++)
> +               mwl8k_txq_deinit(hw, i);
> +
> +       rc = mwl8k_init_firmware(hw, fw_image);
> +       if (rc)
> +               goto fail;
> +
> +       rc = mwl8k_probe_hw(hw);
> +       if (rc)
> +               goto fail;
> +
> +       rc = mwl8k_start(hw);
> +       if (rc)
> +               goto fail;
> +
> +       rc = mwl8k_config(hw, ~0);
> +       if (rc)
> +               goto fail;
> +
> +       for (i = 0; i < MWL8K_TX_QUEUES; i++) {
> +               rc = mwl8k_conf_tx(hw, i, &priv->wmm_params[i]);
> +               if (rc)
> +                       goto fail;
> +       }
> +
> +       return rc;
> +
> +fail:
> +       printk(KERN_WARNING "mwl8k: Failed to reload firmware image.\n");
> +       return rc;
> +}
> +
> +static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
> +{
> +       struct ieee80211_hw *hw = priv->hw;
> +       int i, rc;
> +
> +       /*
> +        * Extra headroom is the size of the required DMA header
> +        * minus the size of the smallest 802.11 frame (CTS frame).
> +        */
> +       hw->extra_tx_headroom =
> +               sizeof(struct mwl8k_dma_data) - sizeof(struct ieee80211_cts);
> +
> +       hw->channel_change_time = 10;
> +
> +       hw->queues = MWL8K_TX_QUEUES;
> +
> +       /* Set rssi values to dBm */
> +       hw->flags |= IEEE80211_HW_SIGNAL_DBM;
> +       hw->vif_data_size = sizeof(struct mwl8k_vif);
> +       hw->sta_data_size = sizeof(struct mwl8k_sta);
> +
> +       priv->macids_used = 0;
> +       INIT_LIST_HEAD(&priv->vif_list);
> +
> +       /* Set default radio state and preamble */
> +       priv->radio_on = 0;
> +       priv->radio_short_preamble = 0;
> +
> +       /* Finalize join worker */
> +       INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
> +
> +       /* TX reclaim and RX tasklets.  */
> +       tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
> +       tasklet_disable(&priv->poll_tx_task);
> +       tasklet_init(&priv->poll_rx_task, mwl8k_rx_poll, (unsigned long)hw);
> +       tasklet_disable(&priv->poll_rx_task);
> +
> +       /* Power management cookie */
> +       priv->cookie = pci_alloc_consistent(priv->pdev, 4, &priv->cookie_dma);
> +       if (priv->cookie == NULL)
> +               return -ENOMEM;
> +
> +       mutex_init(&priv->fw_mutex);
> +       priv->fw_mutex_owner = NULL;
> +       priv->fw_mutex_depth = 0;
> +       priv->hostcmd_wait = NULL;
> +
> +       spin_lock_init(&priv->tx_lock);
> +
> +       priv->tx_wait = NULL;
> +
> +       rc = mwl8k_probe_hw(hw);
> +       if (rc)
> +               goto err_free_cookie;
> +
> +       hw->wiphy->interface_modes = 0;
> +       if (priv->ap_macids_supported || priv->device_info->fw_image_ap)
> +               hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
> +       if (priv->sta_macids_supported || priv->device_info->fw_image_sta)
> +               hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
> +
> +       rc = ieee80211_register_hw(hw);
> +       if (rc) {
> +               wiphy_err(hw->wiphy, "Cannot register device\n");
> +               goto err_unprobe_hw;
> +       }
> +
> +       return 0;
> +
> +err_unprobe_hw:
> +       for (i = 0; i < MWL8K_TX_QUEUES; i++)
> +               mwl8k_txq_deinit(hw, i);
> +       mwl8k_rxq_deinit(hw, 0);
> +
>  err_free_cookie:
>        if (priv->cookie != NULL)
>                pci_free_consistent(priv->pdev, 4,
>                                priv->cookie, priv->cookie_dma);
>
> +       return rc;
> +}
> +static int __devinit mwl8k_probe(struct pci_dev *pdev,
> +                                const struct pci_device_id *id)
> +{
> +       static int printed_version;
> +       struct ieee80211_hw *hw;
> +       struct mwl8k_priv *priv;
> +       int rc;
> +
> +       if (!printed_version) {
> +               printk(KERN_INFO "%s version %s\n", MWL8K_DESC, MWL8K_VERSION);
> +               printed_version = 1;
> +       }
> +
> +
> +       rc = pci_enable_device(pdev);
> +       if (rc) {
> +               printk(KERN_ERR "%s: Cannot enable new PCI device\n",
> +                      MWL8K_NAME);
> +               return rc;
> +       }
> +
> +       rc = pci_request_regions(pdev, MWL8K_NAME);
> +       if (rc) {
> +               printk(KERN_ERR "%s: Cannot obtain PCI resources\n",
> +                      MWL8K_NAME);
> +               goto err_disable_device;
> +       }
> +
> +       pci_set_master(pdev);
> +
> +
> +       hw = ieee80211_alloc_hw(sizeof(*priv), &mwl8k_ops);
> +       if (hw == NULL) {
> +               printk(KERN_ERR "%s: ieee80211 alloc failed\n", MWL8K_NAME);
> +               rc = -ENOMEM;
> +               goto err_free_reg;
> +       }
> +
> +       SET_IEEE80211_DEV(hw, &pdev->dev);
> +       pci_set_drvdata(pdev, hw);
> +
> +       priv = hw->priv;
> +       priv->hw = hw;
> +       priv->pdev = pdev;
> +       priv->device_info = &mwl8k_info_tbl[id->driver_data];
> +
> +
> +       priv->sram = pci_iomap(pdev, 0, 0x10000);
> +       if (priv->sram == NULL) {
> +               wiphy_err(hw->wiphy, "Cannot map device SRAM\n");
> +               goto err_iounmap;
> +       }
> +
> +       /*
> +        * If BAR0 is a 32 bit BAR, the register BAR will be BAR1.
> +        * If BAR0 is a 64 bit BAR, the register BAR will be BAR2.
> +        */
> +       priv->regs = pci_iomap(pdev, 1, 0x10000);
> +       if (priv->regs == NULL) {
> +               priv->regs = pci_iomap(pdev, 2, 0x10000);
> +               if (priv->regs == NULL) {
> +                       wiphy_err(hw->wiphy, "Cannot map device registers\n");
> +                       goto err_iounmap;
> +               }
> +       }
> +
> +       rc = mwl8k_init_firmware(hw);
> +       if (rc)
> +               goto err_stop_firmware;
> +
> +       rc = mwl8k_firmware_load_success(priv);
> +       if (!rc)
> +               return rc;
> +
>  err_stop_firmware:
>        mwl8k_hw_reset(priv);
> -       mwl8k_release_firmware(priv);
>
>  err_iounmap:
>        if (priv->regs != NULL)
> --
> 1.7.1.1
>
>
