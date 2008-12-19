Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYLSCpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:43 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 40/43] iwl3945: simplify iwl3945_pci_probe
Date: Fri, 19 Dec 2008 10:37:40 +0800
Message-Id: <1229654263-21454-41-git-send-email-yi.zhu@intel.com> (sfid-20081219_034635_306148_6F234369)
In-Reply-To: <1229654263-21454-40-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-37-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-38-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-39-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-40-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch simplifies iwl3945_pci_probe. It also uses apm_ops for apm init.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  146 ++++++++++++++------------
 1 files changed, 79 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1446fa6..1d4a474 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7439,6 +7439,62 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.hw_scan = iwl3945_mac_hw_scan
 };
 
+int iwl3945_init_drv(struct iwl_priv *priv)
+{
+	int ret;
+
+	priv->retry_rate = 1;
+	priv->ibss_beacon = NULL;
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->power_data.lock);
+	spin_lock_init(&priv->sta_lock);
+	spin_lock_init(&priv->hcmd_lock);
+
+	INIT_LIST_HEAD(&priv->free_frames);
+
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
+	iwl_reset_qos(priv);
+
+	priv->qos_data.qos_active = 0;
+	priv->qos_data.qos_cap.val = 0;
+
+	priv->rates_mask = IWL_RATES_MASK;
+	/* If power management is turned on, default to AC mode */
+	priv->power_mode = IWL_POWER_AC;
+	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+
+	ret = iwl3945_init_channel_map(priv);
+	if (ret) {
+		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = iwl3945_init_geos(priv);
+	if (ret) {
+		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
+		goto err_free_channel_map;
+	}
+
+	return 0;
+
+err_free_channel_map:
+	iwl3945_free_channel_map(priv);
+err:
+	return ret;
+}
+
 static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int err = 0;
@@ -7454,19 +7510,14 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
-	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwl3945_hw_ops);
+	hw = iwl_alloc_all(cfg, &iwl3945_hw_ops);
 	if (hw == NULL) {
 		printk(KERN_ERR DRV_NAME "Can not allocate network device\n");
 		err = -ENOMEM;
 		goto out;
 	}
-
-	SET_IEEE80211_DEV(hw, &pdev->dev);
-
 	priv = hw->priv;
-	priv->hw = hw;
-	priv->pci_dev = pdev;
-	priv->cfg = cfg;
+	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	if ((iwl3945_mod_params.num_of_queues > IWL39_MAX_NUM_QUEUES) ||
 	     (iwl3945_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
@@ -7477,23 +7528,29 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out;
 	}
 
-	/* Disabling hardware scan means that mac80211 will perform scans
-	 * "the hard way", rather than using device's scan. */
+	/*
+	 * Disabling hardware scan means that mac80211 will perform scans
+	 * "the hard way", rather than using device's scan.
+	 */
 	if (iwl3945_mod_params.disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
+
 	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
-	hw->rate_control_algorithm = "iwl-3945-rs";
-	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
+	priv->cfg = cfg;
+	priv->pci_dev = pdev;
 
-	/* Select antenna (may be helpful if only one antenna is connected) */
-	priv->antenna = (enum iwl3945_antenna)iwl3945_mod_params.antenna;
 #ifdef CONFIG_IWL3945_DEBUG
 	priv->debug_level = iwl3945_mod_params.debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
+	hw->rate_control_algorithm = "iwl-3945-rs";
+	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
+
+	/* Select antenna (may be helpful if only one antenna is connected) */
+	priv->antenna = (enum iwl3945_antenna)iwl3945_mod_params.antenna;
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
@@ -7548,21 +7605,17 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
-	/* nic init */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-			CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	err = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
-				CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	/* amp init */
+	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
-		IWL_DEBUG_INFO("Failed to init the APMG\n");
-		goto out_remove_sysfs;
+		IWL_DEBUG_INFO("Failed to init APMG\n");
+		goto out_iounmap;
 	}
 
 	/***********************
 	 * 4. Read EEPROM
 	 * ********************/
+
 	/* Read the EEPROM */
 	err = iwl3945_eeprom_init(priv);
 	if (err) {
@@ -7586,48 +7639,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/***********************
 	 * 6. Setup priv
 	 * ********************/
-	priv->retry_rate = 1;
-	priv->ibss_beacon = NULL;
-
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data_39.lock);
-	spin_lock_init(&priv->sta_lock);
-	spin_lock_init(&priv->hcmd_lock);
-
-	INIT_LIST_HEAD(&priv->free_frames);
-	mutex_init(&priv->mutex);
-
-	/* Clear the driver's (not device's) station table */
-	iwl3945_clear_stations_table(priv);
 
-	priv->data_retry_limit = -1;
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
-	priv->band = IEEE80211_BAND_2GHZ;
-
-	priv->iw_mode = NL80211_IFTYPE_STATION;
-
-	iwl_reset_qos(priv);
-
-	priv->qos_data.qos_active = 0;
-	priv->qos_data.qos_cap.val = 0;
-
-
-	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL39_POWER_AC;
-	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
-
-	err = iwl3945_init_channel_map(priv);
-	if (err) {
-		IWL_ERR(priv, "initializing regulatory failed: %d\n", err);
-		goto out_release_irq;
-	}
-
-	err = iwl3945_init_geos(priv);
+	err = iwl3945_init_drv(priv);
 	if (err) {
-		IWL_ERR(priv, "initializing geos failed: %d\n", err);
-		goto out_free_channel_map;
+		IWL_ERR(priv, "initializing driver failed\n");
+		goto out_free_geos;
 	}
 
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s\n",
@@ -7656,7 +7672,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
 		IWL_ERR(priv, "failed to create sysfs device attributes\n");
-		goto out_free_geos;
+		goto out_release_irq;
 	}
 
 	iwl3945_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
@@ -7682,7 +7698,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->hw->conf.beacon_int = 100;
 	priv->mac80211_registered = 1;
 
-
 	err = iwl3945_rfkill_init(priv);
 	if (err)
 		IWL_ERR(priv, "Unable to initialize RFKILL system. "
@@ -7694,9 +7709,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
  out_free_geos:
 	iwl3945_free_geos(priv);
- out_free_channel_map:
-	iwl3945_free_channel_map(priv);
-
 
  out_release_irq:
 	destroy_workqueue(priv->workqueue);
-- 
1.5.3.6

