Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYKLVNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwl3945 : Simplify iwl3945_pci_probe
Date: Wed, 12 Nov 2008 13:14:04 -0800
Message-Id: <1226524451-3417-2-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221352_286896_C110C22E)
In-Reply-To: <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

Patch aligns iwl3945_pci_probe with iwlwifi's iwl_pci_probe.
Added few comments and code simplified to make readable.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  195 ++++++++++++++++-----------
 1 files changed, 117 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index dec9e04..bf55f34 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7807,6 +7807,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
+	/***********************
+	 * 1. Allocating HW data
+	 * ********************/
+
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
 	if (iwl3945_param_disable_hw_scan) {
@@ -7830,27 +7834,24 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		err = -ENOMEM;
 		goto out;
 	}
-	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	hw->rate_control_algorithm = "iwl-3945-rs";
-	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
+	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
 	priv = hw->priv;
 	priv->hw = hw;
-
 	priv->pci_dev = pdev;
 	priv->cfg = cfg;
 
+	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
+	hw->rate_control_algorithm = "iwl-3945-rs";
+	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
+
 	/* Select antenna (may be helpful if only one antenna is connected) */
 	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
 #ifdef CONFIG_IWL3945_DEBUG
 	iwl3945_debug_level = iwl3945_param_debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
-	priv->retry_rate = 1;
-
-	priv->ibss_beacon = NULL;
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
@@ -7864,14 +7865,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
 
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
-	spin_lock_init(&priv->sta_lock);
-	spin_lock_init(&priv->hcmd_lock);
-
-	INIT_LIST_HEAD(&priv->free_frames);
-
-	mutex_init(&priv->mutex);
+	/***************************
+	 * 2. Initializing PCI bus
+	 * *************************/
 	if (pci_enable_device(pdev)) {
 		err = -ENODEV;
 		goto out_ieee80211_free_hw;
@@ -7879,14 +7875,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_set_master(pdev);
 
-	/* Clear the driver's (not device's) station table */
-	iwl3945_clear_stations_table(priv);
-
-	priv->data_retry_limit = -1;
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
-	priv->band = IEEE80211_BAND_2GHZ;
-
 	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (!err)
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
@@ -7900,10 +7888,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (err)
 		goto out_pci_disable_device;
 
-	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state */
-	pci_write_config_byte(pdev, 0x41, 0x00);
-
+	/***********************
+	 * 3. Read REV Register
+	 * ********************/
 	priv->hw_base = pci_iomap(pdev, 0, 0);
 	if (!priv->hw_base) {
 		err = -ENODEV;
@@ -7914,25 +7901,70 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 			(unsigned long long) pci_resource_len(pdev, 0));
 	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
 
-	/* Initialize module parameter values here */
+	/* We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_write_config_byte(pdev, 0x41, 0x00);
 
-	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (iwl3945_param_disable) {
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-		IWL_DEBUG_INFO("Radio disabled.\n");
-	}
+	/* nic init */
+	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+			CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
-	priv->iw_mode = NL80211_IFTYPE_STATION;
+	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	err = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (err < 0) {
+		IWL_DEBUG_INFO("Failed to init the card\n");
+		goto out_remove_sysfs;
+	}
 
-	printk(KERN_INFO DRV_NAME
-		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
+	/***********************
+	 * 4. Read EEPROM
+	 * ********************/
+	/* Read the EEPROM */
+	err = iwl3945_eeprom_init(priv);
+	if (err) {
+		IWL_ERROR("Unable to init EEPROM\n");
+		goto out_remove_sysfs;
+	}
+	/* MAC Address location in EEPROM same for 3945/4965 */
+	get_eeprom_mac(priv, priv->mac_addr);
+	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
+	/***********************
+	 * 5. Setup HW Constants
+	 * ********************/
 	/* Device-specific setup */
 	if (iwl3945_hw_set_hw_setting(priv)) {
 		IWL_ERROR("failed to set hw settings\n");
 		goto out_iounmap;
 	}
 
+	/***********************
+	 * 6. Setup priv
+	 * ********************/
+	priv->retry_rate = 1;
+	priv->ibss_beacon = NULL;
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->power_data.lock);
+	spin_lock_init(&priv->sta_lock);
+	spin_lock_init(&priv->hcmd_lock);
+
+	INIT_LIST_HEAD(&priv->free_frames);
+	mutex_init(&priv->mutex);
+
+	/* Clear the driver's (not device's) station table */
+	iwl3945_clear_stations_table(priv);
+
+	priv->data_retry_limit = -1;
+	priv->ieee_channels = NULL;
+	priv->ieee_rates = NULL;
+	priv->band = IEEE80211_BAND_2GHZ;
+
+	priv->iw_mode = NL80211_IFTYPE_STATION;
+
 	if (iwl3945_param_qos_enable)
 		priv->qos_data.qos_enable = 1;
 
@@ -7941,70 +7973,76 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
 
-	iwl3945_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
-	iwl3945_setup_deferred_work(priv);
-	iwl3945_setup_rx_handlers(priv);
 
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IWL_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
+	err = iwl3945_init_channel_map(priv);
 	if (err) {
-		IWL_ERROR("failed to create sysfs device attributes\n");
+		IWL_ERROR("initializing regulatory failed: %d\n", err);
 		goto out_release_irq;
 	}
 
-	/* nic init */
-	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-			CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	err = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (err < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
-		goto out_remove_sysfs;
-	}
-	/* Read the EEPROM */
-	err = iwl3945_eeprom_init(priv);
+	err = iwl3945_init_geos(priv);
 	if (err) {
-		IWL_ERROR("Unable to init EEPROM\n");
-		goto out_remove_sysfs;
+		IWL_ERROR("initializing geos failed: %d\n", err);
+		goto out_free_channel_map;
 	}
-	/* MAC Address location in EEPROM same for 3945/4965 */
-	get_eeprom_mac(priv, priv->mac_addr);
-	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
-	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
-	err = iwl3945_init_channel_map(priv);
-	if (err) {
-		IWL_ERROR("initializing regulatory failed: %d\n", err);
-		goto out_remove_sysfs;
+	printk(KERN_INFO DRV_NAME
+		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
+
+	/***********************************
+	 * 7. Initialize Module Parameters
+	 * **********************************/
+
+	/* Initialize module parameter values here */
+	/* Disable radio (SW RF KILL) via parameter when loading driver */
+	if (iwl3945_param_disable) {
+		set_bit(STATUS_RF_KILL_SW, &priv->status);
+		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
 
-	err = iwl3945_init_geos(priv);
+
+	/***********************
+	 * 8. Setup Services
+	 * ********************/
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl3945_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
-		IWL_ERROR("initializing geos failed: %d\n", err);
-		goto out_free_channel_map;
+		IWL_ERROR("failed to create sysfs device attributes\n");
+		goto out_free_geos;
 	}
 
+	iwl3945_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
+	iwl3945_setup_deferred_work(priv);
+	iwl3945_setup_rx_handlers(priv);
+
+	/***********************
+	 * 9. Conclude
+	 * ********************/
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+
+	/*********************************
+	 * 10. Setup and Register mac80211
+	 * *******************************/
+
 	err = ieee80211_register_hw(priv->hw);
 	if (err) {
 		IWL_ERROR("Failed to register network device (error %d)\n", err);
-		goto out_free_geos;
+		goto  out_remove_sysfs;
 	}
 
 	priv->hw->conf.beacon_int = 100;
 	priv->mac80211_registered = 1;
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
+
 
 	err = iwl3945_rfkill_init(priv);
 	if (err)
@@ -8013,12 +8051,13 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	return 0;
 
+ out_remove_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
  out_free_geos:
 	iwl3945_free_geos(priv);
  out_free_channel_map:
 	iwl3945_free_channel_map(priv);
- out_remove_sysfs:
-	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
+
 
  out_release_irq:
 	destroy_workqueue(priv->workqueue);
-- 
1.5.4.3

