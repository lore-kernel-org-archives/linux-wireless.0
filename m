Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYCSTiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] iwlwifi: Completing the parameter packaging
Date: Tue, 18 Mar 2008 14:57:50 -0700
Message-Id: <1205877470-11525-2-git-send-email-reinette.chatre@intel.com> (sfid-20080319_193943_056961_B371D966)
In-Reply-To: <1205877470-11525-1-git-send-email-reinette.chatre@intel.com>
References: <1205877470-11525-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch completes the changes regarding the packaging of user
parameters.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   54 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    9 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   48 ++++-------------------
 3 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 03c032e..376968f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -43,6 +43,14 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
+/* module parameters */
+static struct iwl_mod_params iwl4965_mod_params = {
+	.num_of_queues = IWL_MAX_NUM_QUEUES,
+	.enable_qos = 1,
+	.amsdu_size_8K = 1,
+	/* the rest are 0 by default */
+};
+
 static void iwl4965_hw_card_show_info(struct iwl_priv *priv);
 
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
@@ -110,7 +118,7 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	int ret;
 	int i;
 
-	priv->antenna = (enum iwl4965_antenna)iwl4965_mod_params.antenna;
+	priv->antenna = (enum iwl4965_antenna)priv->cfg->mod_params->antenna;
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
 
@@ -404,7 +412,7 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 		return rc;
 	}
 
-	if (iwl4965_mod_params.amsdu_size_8K)
+	if (priv->cfg->mod_params->amsdu_size_8K)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
 	else
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
@@ -1880,8 +1888,8 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	if ((iwl4965_mod_params.num_of_queues > IWL_MAX_NUM_QUEUES) ||
-	    (iwl4965_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
+	if ((priv->cfg->mod_params->num_of_queues > IWL_MAX_NUM_QUEUES) ||
+	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
 			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
 		ret = -EINVAL;
@@ -1901,11 +1909,11 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 
 	memset(priv->hw_setting.shared_virt, 0, sizeof(struct iwl4965_shared));
 
-	priv->hw_setting.max_txq_num = iwl4965_mod_params.num_of_queues;
+	priv->hw_setting.max_txq_num = priv->cfg->mod_params->num_of_queues;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	if (iwl4965_mod_params.amsdu_size_8K)
+	if (priv->cfg->mod_params->amsdu_size_8K)
 		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_8K;
 	else
 		priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE_4K;
@@ -3522,7 +3530,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	stats->flag = 0;
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
-	if (iwl4965_mod_params.hw_crypto)
+	if (priv->cfg->mod_params->hw_crypto)
 		iwl4965_set_decrypted_flag(priv, rxb->skb, ampdu_status, stats);
 
 	if (priv->add_radiotap)
@@ -3645,7 +3653,8 @@ static int parse_elems(u8 *start, size_t len, struct ieee802_11_elems *elems)
 	return 0;
 }
 
-void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
+			      struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band)
 {
 	ht_info->cap = 0;
@@ -3662,10 +3671,9 @@ void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
 	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
 	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
 			     (IWL_MIMO_PS_NONE << 2));
-	if (iwl4965_mod_params.amsdu_size_8K) {
-		printk(KERN_DEBUG "iwl4965 in A-MSDU 8K support mode\n");
+
+	if (priv->cfg->mod_params->amsdu_size_8K)
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_MAX_AMSDU;
-	}
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
@@ -4966,6 +4974,7 @@ static struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl4965_ops,
+	.mod_params = &iwl4965_mod_params,
 };
 
 struct pci_device_id iwl4965_hw_card_ids[] = {
@@ -4975,3 +4984,26 @@ struct pci_device_id iwl4965_hw_card_ids[] = {
 };
 
 MODULE_DEVICE_TABLE(pci, iwl4965_hw_card_ids);
+
+module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
+MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
+module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
+MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
+module_param_named(hwcrypto, iwl4965_mod_params.hw_crypto, int, 0444);
+MODULE_PARM_DESC(hwcrypto,
+		 "using hardware crypto engine (default 0 [software])\n");
+module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
+MODULE_PARM_DESC(debug, "debug output mask");
+module_param_named(
+	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, 0444);
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
+
+module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, 0444);
+MODULE_PARM_DESC(queues_num, "number of hw queues.");
+
+/* QoS */
+module_param_named(qos_enable, iwl4965_mod_params.enable_qos, int, 0444);
+MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
+module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K, int, 0444);
+MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 7baed4d..bf17289 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -66,9 +66,6 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
  *   averages within an s8's (used in some apps) range of negative values. */
 #define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
 
-/* Module parameters accessible from iwl-*.c */
-extern struct iwl_mod_params iwl4965_mod_params;
-
 enum iwl4965_antenna {
 	IWL_ANTENNA_DIVERSITY,
 	IWL_ANTENNA_MAIN,
@@ -763,7 +760,8 @@ extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 					 struct ieee80211_tx_control *control);
 
 #ifdef CONFIG_IWL4965_HT
-void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
+			      struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band);
 void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 			 struct iwl_ht_info *ht_info);
@@ -775,7 +773,8 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					u8 tid, int txq_id);
 #else
-static inline void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+static inline void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
+					    struct ieee80211_ht_info *ht_info,
 					    enum ieee80211_band band) {}
 
 #endif /*CONFIG_IWL4965_HT */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 97db4eb..7ba4f1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -59,14 +59,6 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
  *
  ******************************************************************************/
 
-/* module parameters */
-struct iwl_mod_params iwl4965_mod_params = {
-	.num_of_queues = IWL_MAX_NUM_QUEUES,
-	.enable_qos = 1,
-	.amsdu_size_8K = 1,
-	/* the rest are 0 by default */
-};
-
 /*
  * module name, copyright, version, etc.
  * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
@@ -1135,7 +1127,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
-	iwl4965_set_rxon_hwcrypto(priv, iwl4965_mod_params.hw_crypto);
+	iwl4965_set_rxon_hwcrypto(priv, priv->cfg->mod_params->hw_crypto);
 	/* Apply the new configuration */
 	rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
@@ -5162,7 +5154,7 @@ int iwl4965_init_geos(struct iwl_priv *priv)
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
 
-	iwl4965_init_ht_hw_capab(&sband->ht_info, IEEE80211_BAND_5GHZ);
+	iwl4965_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_5GHZ);
 
 	sband = &priv->bands[IEEE80211_BAND_2GHZ];
 	sband->channels = channels;
@@ -5170,7 +5162,7 @@ int iwl4965_init_geos(struct iwl_priv *priv)
 	sband->bitrates = rates;
 	sband->n_bitrates = IWL_RATE_COUNT;
 
-	iwl4965_init_ht_hw_capab(&sband->ht_info, IEEE80211_BAND_2GHZ);
+	iwl4965_init_ht_hw_capab(priv, &sband->ht_info, IEEE80211_BAND_2GHZ);
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
@@ -6843,7 +6835,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
-	if (unlikely(!iwl4965_mod_params.disable_hw_scan &&
+	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
 		set_bit(STATUS_CONF_PENDING, &priv->status);
@@ -7229,7 +7221,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl4965_mod_params.hw_crypto) {
+	if (!priv->cfg->mod_params->hw_crypto) {
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -8186,7 +8178,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
-	if (iwl4965_mod_params.disable_hw_scan) {
+	if (cfg->mod_params->disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
 		iwl4965_hw_ops.hw_scan = NULL;
 	}
@@ -8206,7 +8198,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	iwl_debug_level = iwl4965_mod_params.debug;
+	iwl_debug_level = priv->cfg->mod_params->debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
@@ -8304,12 +8296,12 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 **********************************/
 
 	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (iwl4965_mod_params.disable) {
+	if (priv->cfg->mod_params->disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
 		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
 
-	if (iwl4965_mod_params.enable_qos)
+	if (priv->cfg->mod_params->enable_qos)
 		priv->qos_data.qos_enable = 1;
 
 	/********************
@@ -8500,27 +8492,5 @@ static void __exit iwl4965_exit(void)
 	pci_unregister_driver(&iwl4965_driver);
 }
 
-module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
-MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
-MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
-module_param_named(hwcrypto, iwl4965_mod_params.hw_crypto, int, 0444);
-MODULE_PARM_DESC(hwcrypto,
-		 "using hardware crypto engine (default 0 [software])\n");
-module_param_named(debug, iwl4965_mod_params.debug, int, 0444);
-MODULE_PARM_DESC(debug, "debug output mask");
-module_param_named(
-	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, 0444);
-MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
-
-module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, 0444);
-MODULE_PARM_DESC(queues_num, "number of hw queues.");
-
-/* QoS */
-module_param_named(qos_enable, iwl4965_mod_params.enable_qos, int, 0444);
-MODULE_PARM_DESC(qos_enable, "enable all QoS functionality");
-module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K, int, 0444);
-MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
-
 module_exit(iwl4965_exit);
 module_init(iwl4965_init);
-- 
1.5.3.4

