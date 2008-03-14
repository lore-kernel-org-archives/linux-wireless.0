Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYCNRsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:48:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/5] iwlwifi: Packing all 4965 parameters
Date: Fri, 14 Mar 2008 10:38:47 -0700
Message-Id: <1205516329-22172-4-git-send-email-reinette.chatre@intel.com> (sfid-20080314_174958_090512_BC3C0AAE)
In-Reply-To: <1205516329-22172-3-git-send-email-reinette.chatre@intel.com>
References: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-2-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch defines a package struct for iwlwifi parameters, and uses a
single instance of this struct to group all iwl4965 module parameters
together.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   14 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    4 +--
 drivers/net/wireless/iwlwifi/iwl-core.h     |   12 +++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   47 +++++++++++++--------------
 4 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b6b495e..f015780 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -320,7 +320,7 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 		return rc;
 	}
 
-	if (iwl4965_param_amsdu_size_8K)
+	if (iwl4965_mod_params.amsdu_size_8K)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
 	else
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
@@ -1845,8 +1845,8 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	if ((iwl4965_param_queues_num > IWL_MAX_NUM_QUEUES) ||
-	    (iwl4965_param_queues_num < IWL_MIN_NUM_QUEUES)) {
+	if ((iwl4965_mod_params.num_of_queues > IWL_MAX_NUM_QUEUES) ||
+	    (iwl4965_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
 			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
 		ret = -EINVAL;
@@ -1866,11 +1866,11 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 
 	memset(priv->hw_setting.shared_virt, 0, sizeof(struct iwl4965_shared));
 
-	priv->hw_setting.max_txq_num = iwl4965_param_queues_num;
+	priv->hw_setting.max_txq_num = iwl4965_mod_params.num_of_queues;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	if (iwl4965_param_amsdu_size_8K)
+	if (iwl4965_mod_params.amsdu_size_8K)
 		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_8K;
 	else
 		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_4K;
@@ -3487,7 +3487,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	stats->flag = 0;
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
-	if (iwl4965_param_hwcrypto)
+	if (iwl4965_mod_params.hw_crypto)
 		iwl4965_set_decrypted_flag(priv, rxb->skb, ampdu_status, stats);
 
 	if (priv->add_radiotap)
@@ -3627,7 +3627,7 @@ void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
 	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
 			     (IWL_MIMO_PS_NONE << 2));
-	if (iwl4965_param_amsdu_size_8K) {
+	if (iwl4965_mod_params.amsdu_size_8K) {
 		printk(KERN_DEBUG "iwl4965 in A-MSDU 8K support mode\n");
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_MAX_AMSDU;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index cec62ba..1480e1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -67,9 +67,7 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 #define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
 
 /* Module parameters accessible from iwl-*.c */
-extern int iwl4965_param_hwcrypto;
-extern int iwl4965_param_queues_num;
-extern int iwl4965_param_amsdu_size_8K;
+extern struct iwl_mod_params iwl4965_mod_params;
 
 enum iwl4965_antenna {
 	IWL_ANTENNA_DIVERSITY,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 88fd49a..fb4ce08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -84,11 +84,23 @@ struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 };
 
+struct iwl_mod_params {
+	int disable;		/* def: 0 = enable radio */
+	int hw_crypto;		/* def: 0 = using software encryption */
+	int debug;		/* def: 0 = minimal debug log messages */
+	int disable_hw_scan;	/* def: 0 = use h/w scan */
+	int num_of_queues;	/* def: HW dependent */
+	int enable_qos;		/* def: 1 = use quality of service */
+	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
+	int antenna;  		/* def: 0 = both antennas (use diversity) */
+};
+
 struct iwl_cfg {
 	const char *name;
 	const char *fw_name;
 	unsigned int sku;
 	const struct iwl_ops *ops;
+	const struct iwl_mod_params *mod_params;
 };
 
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9fb14a4..ebdf2d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -60,14 +60,12 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
  ******************************************************************************/
 
 /* module parameters */
-static int iwl4965_param_disable_hw_scan; /* def: 0 = use 4965's h/w scan */
-static int iwl4965_param_debug;    /* def: 0 = minimal debug log messages */
-static int iwl4965_param_disable;  /* def: enable radio */
-static int iwl4965_param_antenna;  /* def: 0 = both antennas (use diversity) */
-int iwl4965_param_hwcrypto;        /* def: using software encryption */
-static int iwl4965_param_qos_enable = 1; /* def: 1 = use quality of service */
-int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 16 Tx queues */
-int iwl4965_param_amsdu_size_8K;   /* def: enable 8K amsdu size */
+struct iwl_mod_params iwl4965_mod_params = {
+	.num_of_queues = IWL_MAX_NUM_QUEUES,
+	.enable_qos = 1,
+	.amsdu_size_8K = 1,
+	/* the rest are 0 by default */
+};
 
 /*
  * module name, copyright, version, etc.
@@ -1191,7 +1189,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
-	iwl4965_set_rxon_hwcrypto(priv, iwl4965_param_hwcrypto);
+	iwl4965_set_rxon_hwcrypto(priv, iwl4965_mod_params.hw_crypto);
 	/* Apply the new configuration */
 	rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
@@ -7288,7 +7286,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
-	if (unlikely(!iwl4965_param_disable_hw_scan &&
+	if (unlikely(!iwl4965_mod_params.disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
 		set_bit(STATUS_CONF_PENDING, &priv->status);
@@ -7674,7 +7672,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl4965_param_hwcrypto) {
+	if (!iwl4965_mod_params.hw_crypto) {
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -8632,7 +8630,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
-	if (iwl4965_param_disable_hw_scan) {
+	if (iwl4965_mod_params.disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
 		iwl4965_hw_ops.hw_scan = NULL;
 	}
@@ -8655,7 +8653,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	iwl_debug_level = iwl4965_param_debug;
+	iwl_debug_level = iwl4965_mod_params.debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
@@ -8763,7 +8761,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 #endif /* CONFIG_IWL4965_HT */
 
 	hw->rate_control_algorithm = "iwl-4965-rs";
-	priv->antenna = (enum iwl4965_antenna)iwl4965_param_antenna;
+	priv->antenna = (enum iwl4965_antenna)iwl4965_mod_params.antenna;
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
 
@@ -8836,12 +8834,12 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 **********************************/
 
 	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (iwl4965_param_disable) {
+	if (iwl4965_mod_params.disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
 		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
 
-	if (iwl4965_param_qos_enable)
+	if (iwl4965_mod_params.enable_qos)
 		priv->qos_data.qos_enable = 1;
 
 	/********************
@@ -9036,25 +9034,26 @@ static void __exit iwl4965_exit(void)
 	pci_unregister_driver(&iwl4965_driver);
 }
 
-module_param_named(antenna, iwl4965_param_antenna, int, 0444);
+module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(disable, iwl4965_param_disable, int, 0444);
+module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
-module_param_named(hwcrypto, iwl4965_param_hwcrypto, int, 0444);
+module_param_named(hwcrypto, iwl4965_mod_params.hw_crypto, int, 0444);
 MODULE_PARM_DESC(hwcrypto,
 		 "using hardware crypto engine (default 0 [software])\n");
-module_param_named(debug, iwl4965_param_debug, int, 0444);
+module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
-module_param_named(disable_hw_scan, iwl4965_param_disable_hw_scan, int, 0444);
+module_param_named(
+	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 
-module_param_named(queues_num, iwl4965_param_queues_num, int, 0444);
+module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
 
 /* QoS */
-module_param_named(qos_enable, iwl4965_param_qos_enable, int, 0444);
+module_param_named(qos_enable, iwl4965_mod_params.enable_qos, int, 0444);
 MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
-module_param_named(amsdu_size_8K, iwl4965_param_amsdu_size_8K, int, 0444);
+module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K, int, 0444);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
 
 module_exit(iwl4965_exit);
-- 
1.5.3.4

