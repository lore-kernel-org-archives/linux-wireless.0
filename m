Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYCNRsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:48:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/5] iwlwifi: Re-ordering probe flow (4965)
Date: Fri, 14 Mar 2008 10:38:46 -0700
Message-Id: <1205516329-22172-3-git-send-email-reinette.chatre@intel.com> (sfid-20080314_175000_231088_DCDD6ED6)
In-Reply-To: <1205516329-22172-2-git-send-email-reinette.chatre@intel.com>
References: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch re-orders the iwl4965_pci_probe function.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   19 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  252 ++++++++++++++-------------
 2 files changed, 151 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1030f17..b6b495e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1843,14 +1843,26 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
  */
 int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 {
+	int ret = 0;
+
+	if ((iwl4965_param_queues_num > IWL_MAX_NUM_QUEUES) ||
+	    (iwl4965_param_queues_num < IWL_MIN_NUM_QUEUES)) {
+		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
+			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* Allocate area for Tx byte count tables and Rx queue status */
 	priv->hw_setting.shared_virt =
 	    pci_alloc_consistent(priv->pci_dev,
 				 sizeof(struct iwl4965_shared),
 				 &priv->hw_setting.shared_phys);
 
-	if (!priv->hw_setting.shared_virt)
-		return -1;
+	if (!priv->hw_setting.shared_virt) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	memset(priv->hw_setting.shared_virt, 0, sizeof(struct iwl4965_shared));
 
@@ -1868,7 +1880,8 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 
 	priv->hw_setting.tx_ant_num = 2;
 
-	return 0;
+out:
+	return ret;
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5bd98f5..9fb14a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8626,6 +8626,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	int i;
 	DECLARE_MAC_BUF(mac);
 
+	/************************
+	 * 1. Allocating HW data
+	 ************************/
+
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
 	if (iwl4965_param_disable_hw_scan) {
@@ -8633,14 +8637,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		iwl4965_hw_ops.hw_scan = NULL;
 	}
 
-	if ((iwl4965_param_queues_num > IWL_MAX_NUM_QUEUES) ||
-	    (iwl4965_param_queues_num < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
-		err = -EINVAL;
-		goto out;
-	}
-
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
 	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwl4965_hw_ops);
@@ -8651,22 +8647,101 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	}
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	hw->rate_control_algorithm = "iwl-4965-rs";
-
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->cfg = cfg;
 
 	priv->pci_dev = pdev;
-	priv->antenna = (enum iwl4965_antenna)iwl4965_param_antenna;
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 	iwl_debug_level = iwl4965_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
-	priv->retry_rate = 1;
 
-	priv->ibss_beacon = NULL;
+	/**************************
+	 * 2. Initializing PCI bus
+	 **************************/
+	if (pci_enable_device(pdev)) {
+		err = -ENODEV;
+		goto out_ieee80211_free_hw;
+	}
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (!err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (err) {
+			printk(KERN_WARNING DRV_NAME
+				": No suitable DMA available.\n");
+			goto out_pci_disable_device;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err)
+		goto out_pci_disable_device;
+
+	pci_set_drvdata(pdev, priv);
+
+	/* We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_write_config_byte(pdev, 0x41, 0x00);
+
+	/***********************
+	 * 3. Read REV register
+	 ***********************/
+	priv->hw_base = pci_iomap(pdev, 0, 0);
+	if (!priv->hw_base) {
+		err = -ENODEV;
+		goto out_pci_release_regions;
+	}
+
+	IWL_DEBUG_INFO("pci_resource_len = 0x%08llx\n",
+		(unsigned long long) pci_resource_len(pdev, 0));
+	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
+
+	printk(KERN_INFO DRV_NAME
+		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
+
+	/*****************
+	 * 4. Read EEPROM
+	 *****************/
+	/* nic init */
+	iwl4965_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+		CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+	iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	err = iwl4965_poll_bit(priv, CSR_GP_CNTRL,
+		CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+		CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (err < 0) {
+		IWL_DEBUG_INFO("Failed to init the card\n");
+		goto out_iounmap;
+	}
+	/* Read the EEPROM */
+	err = iwl_eeprom_init(priv);
+	if (err) {
+		IWL_ERROR("Unable to init EEPROM\n");
+		goto out_iounmap;
+	}
+	/* MAC Address location in EEPROM same for 3945/4965 */
+	iwl_eeprom_get_mac(priv, priv->mac_addr);
+	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
+
+	/************************
+	 * 5. Setup HW constants
+	 ************************/
+	/* Device-specific setup */
+	if (iwl4965_hw_set_hw_setting(priv)) {
+		IWL_ERROR("failed to set hw settings\n");
+		goto out_iounmap;
+	}
+
+	/*******************
+	 * 6. Setup hw/priv
+	 *******************/
 
 	/* Tell mac80211 and its clients (e.g. Wireless Extensions)
 	 *   the range of signal quality values that we'll provide.
@@ -8687,6 +8762,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	hw->queues = 16;
 #endif /* CONFIG_IWL4965_HT */
 
+	hw->rate_control_algorithm = "iwl-4965-rs";
+	priv->antenna = (enum iwl4965_antenna)iwl4965_param_antenna;
+	priv->retry_rate = 1;
+	priv->ibss_beacon = NULL;
+
 	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->power_data.lock);
 	spin_lock_init(&priv->sta_lock);
@@ -8699,12 +8779,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);
-	if (pci_enable_device(pdev)) {
-		err = -ENODEV;
-		goto out_ieee80211_free_hw;
-	}
-
-	pci_set_master(pdev);
 
 	/* Clear the driver's (not device's) station table */
 	iwl4965_clear_stations_table(priv);
@@ -8714,44 +8788,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
-	if (err) {
-		printk(KERN_WARNING DRV_NAME ": No suitable DMA available.\n");
-		goto out_pci_disable_device;
-	}
-
-	pci_set_drvdata(pdev, priv);
-	err = pci_request_regions(pdev, DRV_NAME);
-	if (err)
-		goto out_pci_disable_device;
-
-	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state */
-	pci_write_config_byte(pdev, 0x41, 0x00);
-
-	priv->hw_base = pci_iomap(pdev, 0, 0);
-	if (!priv->hw_base) {
-		err = -ENODEV;
-		goto out_pci_release_regions;
-	}
-
-	IWL_DEBUG_INFO("pci_resource_len = 0x%08llx\n",
-			(unsigned long long) pci_resource_len(pdev, 0));
-	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
-
-	/* Initialize module parameter values here */
-
-	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (iwl4965_param_disable) {
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-		IWL_DEBUG_INFO("Radio disabled.\n");
-	}
-
 	priv->iw_mode = IEEE80211_IF_TYPE_STA;
 
-	priv->ps_mode = 0;
 	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
 	priv->valid_antenna = 0x7;	/* assume all 3 connected */
 	priv->ps_mode = IWL_MIMO_PS_NONE;
@@ -8759,73 +8797,22 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Choose which receivers/antennas to use */
 	iwl4965_set_rxon_chain(priv);
 
-
-	printk(KERN_INFO DRV_NAME
-		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
-
-	/* Device-specific setup */
-	if (iwl4965_hw_set_hw_setting(priv)) {
-		IWL_ERROR("failed to set hw settings\n");
-		goto out_iounmap;
-	}
-
-	if (iwl4965_param_qos_enable)
-		priv->qos_data.qos_enable = 1;
-
 	iwl4965_reset_qos(priv);
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
 
 	iwl4965_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
-	iwl4965_setup_deferred_work(priv);
-	iwl4965_setup_rx_handlers(priv);
 
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
 
-	iwl4965_disable_interrupts(priv);
-
-	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
-	if (err) {
-		IWL_ERROR("failed to create sysfs device attributes\n");
-		goto out_release_irq;
-	}
-
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err) {
-		IWL_ERROR("failed to create debugfs files\n");
-		goto out_remove_sysfs;
-	}
-	/* nic init */
-	iwl4965_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-                    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-        iwl4965_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-        err = iwl4965_poll_bit(priv, CSR_GP_CNTRL,
-                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-                          CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-        if (err < 0) {
-                IWL_DEBUG_INFO("Failed to init the card\n");
-		goto out_remove_dbgfs;
-        }
-	/* Read the EEPROM */
-	err = iwl_eeprom_init(priv);
-	if (err) {
-		IWL_ERROR("Unable to init EEPROM\n");
-		goto out_remove_dbgfs;
-	}
-	/* MAC Address location in EEPROM same for 3945/4965 */
-	iwl_eeprom_get_mac(priv, priv->mac_addr);
-	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
-	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
-
 	err = iwl4965_init_channel_map(priv);
 	if (err) {
 		IWL_ERROR("initializing regulatory failed: %d\n", err);
-		goto out_remove_dbgfs;
+		goto out_unset_hw_settings;
 	}
 
 	err = iwl4965_init_geos(priv);
@@ -8843,32 +8830,63 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->hw->conf.beacon_int = 100;
 	priv->mac80211_registered = 1;
+
+	/**********************************
+	 * 7. Initialize module parameters
+	 **********************************/
+
+	/* Disable radio (SW RF KILL) via parameter when loading driver */
+	if (iwl4965_param_disable) {
+		set_bit(STATUS_RF_KILL_SW, &priv->status);
+		IWL_DEBUG_INFO("Radio disabled.\n");
+	}
+
+	if (iwl4965_param_qos_enable)
+		priv->qos_data.qos_enable = 1;
+
+	/********************
+	 * 8. Setup services
+	 ********************/
+	iwl4965_disable_interrupts(priv);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
+	if (err) {
+		IWL_ERROR("failed to create sysfs device attributes\n");
+		goto out_free_geos;
+	}
+
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err) {
+		IWL_ERROR("failed to create debugfs files\n");
+		goto out_remove_sysfs;
+	}
+
+	iwl4965_setup_deferred_work(priv);
+	iwl4965_setup_rx_handlers(priv);
+
+	/********************
+	 * 9. Conclude
+	 ********************/
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 
 	return 0;
 
+ out_remove_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
  out_free_geos:
 	iwl4965_free_geos(priv);
  out_free_channel_map:
 	iwl4965_free_channel_map(priv);
- out_remove_dbgfs:
-	iwl_dbgfs_unregister(priv);
- out_remove_sysfs:
-	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
-
- out_release_irq:
-	destroy_workqueue(priv->workqueue);
-	priv->workqueue = NULL;
+ out_unset_hw_settings:
 	iwl4965_unset_hw_setting(priv);
-
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
 	pci_release_regions(pdev);
+	pci_set_drvdata(pdev, NULL);
  out_pci_disable_device:
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
  out_ieee80211_free_hw:
 	ieee80211_free_hw(priv->hw);
  out:
-- 
1.5.3.4

