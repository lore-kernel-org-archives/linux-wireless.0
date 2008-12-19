Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbYLSCph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:37 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 35/43] iwl3945: use iwl_mod_params for 3945
Date: Fri, 19 Dec 2008 10:37:35 +0800
Message-Id: <1229654263-21454-36-git-send-email-yi.zhu@intel.com> (sfid-20081219_034624_533807_CFA01351)
In-Reply-To: <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

Use iwl_mod_params for 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 +++++++++++---------------
 3 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index aaf21e3..84f8612 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -599,7 +599,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	/* Set the size of the skb to the size of the frame */
 	skb_put(rxb->skb, le16_to_cpu(rx_hdr->len));
 
-	if (iwl3945_param_hwcrypto)
+	if (iwl3945_mod_params.sw_crypto)
 		iwl3945_set_decrypted_flag(priv, rxb->skb,
 				       le32_to_cpu(rx_end->status), stats);
 
@@ -2513,6 +2513,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
+	.mod_params = &iwl3945_mod_params
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2521,6 +2522,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
+	.mod_params = &iwl3945_mod_params
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 18424a3..9c520c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -75,8 +75,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
 
 /* Module parameters accessible from iwl-*.c */
-extern int iwl3945_param_hwcrypto;
-extern int iwl3945_param_queues_num;
+extern struct iwl_mod_params iwl3945_mod_params;
 
 struct iwl3945_sta_priv {
 	struct iwl3945_rs_sta *rs_sta;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fc17787..e8b2af8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -58,20 +58,6 @@
 static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl3945_tx_queue *txq);
 
-/******************************************************************************
- *
- * module boiler plate
- *
- ******************************************************************************/
-
-/* module parameters */
-static int iwl3945_param_disable_hw_scan; /* def: 0 = use 3945's h/w scan */
-static u32 iwl3945_param_debug;    /* def: 0 = minimal debug log messages */
-static int iwl3945_param_disable;  /* def: 0 = enable radio */
-static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
-int iwl3945_param_hwcrypto;        /* def: 0 = use software encryption */
-int iwl3945_param_queues_num = IWL39_MAX_NUM_QUEUES; /* def: 8 Tx queues */
-
 /*
  * module name, copyright, version, etc.
  */
@@ -102,6 +88,12 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
+ /* module parameters */
+struct iwl_mod_params iwl3945_mod_params = {
+	.num_of_queues = IWL39_MAX_NUM_QUEUES,
+	/* the rest are 0 by default */
+};
+
 static const struct ieee80211_supported_band *iwl3945_get_band(
 		struct iwl_priv *priv, enum ieee80211_band band)
 {
@@ -6545,7 +6537,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 	}
 
-	if (unlikely(!iwl3945_param_disable_hw_scan &&
+	if (unlikely(!iwl3945_mod_params.disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
 		set_bit(STATUS_CONF_PENDING, &priv->status);
@@ -6959,7 +6951,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl3945_param_hwcrypto) {
+	if (iwl3945_mod_params.sw_crypto) {
 		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -7765,8 +7757,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 	priv->cfg = cfg;
 
-	if ((iwl3945_param_queues_num > IWL39_MAX_NUM_QUEUES) ||
-	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
+	if ((iwl3945_mod_params.num_of_queues > IWL39_MAX_NUM_QUEUES) ||
+	     (iwl3945_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERR(priv,
 			"invalid queues_num, should be between %d and %d\n",
 			IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
@@ -7776,7 +7768,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
-	if (iwl3945_param_disable_hw_scan) {
+	if (iwl3945_mod_params.disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
@@ -7786,9 +7778,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
 
 	/* Select antenna (may be helpful if only one antenna is connected) */
-	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
+	priv->antenna = (enum iwl3945_antenna)iwl3945_mod_params.antenna;
 #ifdef CONFIG_IWL3945_DEBUG
-	priv->debug_level = iwl3945_param_debug;
+	priv->debug_level = iwl3945_mod_params.debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
 
@@ -7936,7 +7928,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* Initialize module parameter values here */
 	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (iwl3945_param_disable) {
+	if (iwl3945_mod_params.disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
 		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
@@ -8266,19 +8258,19 @@ static void __exit iwl3945_exit(void)
 
 MODULE_FIRMWARE(IWL3945_MODULE_FIRMWARE(IWL3945_UCODE_API_MAX));
 
-module_param_named(antenna, iwl3945_param_antenna, int, 0444);
+module_param_named(antenna, iwl3945_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(disable, iwl3945_param_disable, int, 0444);
+module_param_named(disable, iwl3945_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
-module_param_named(hwcrypto, iwl3945_param_hwcrypto, int, 0444);
+module_param_named(hwcrypto, iwl3945_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(hwcrypto,
 		 "using hardware crypto engine (default 0 [software])\n");
-module_param_named(debug, iwl3945_param_debug, uint, 0444);
+module_param_named(debug, iwl3945_mod_params.debug, uint, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
-module_param_named(disable_hw_scan, iwl3945_param_disable_hw_scan, int, 0444);
+module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 
-module_param_named(queues_num, iwl3945_param_queues_num, int, 0444);
+module_param_named(queues_num, iwl3945_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
 
 module_exit(iwl3945_exit);
-- 
1.5.3.6

