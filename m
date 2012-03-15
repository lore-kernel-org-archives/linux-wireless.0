Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161383Ab2COU17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:27:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/26] iwlwifi: remove un-needed parameter
Date: Thu, 15 Mar 2012 13:26:42 -0700
Message-Id: <1331843226-29860-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212805_193831_A5A9A3E7)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get rid of un-needed parameter

Change-Id: I992741e7382a3dbced7f8413bf1d5f301029d576
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   33 ++++++++++++-------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f1226db..e7da3a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1178,7 +1178,6 @@ static void iwl_debug_config(struct iwl_priv *priv)
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 						 const struct iwl_fw *fw)
 {
-	int err = 0;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_op_mode *op_mode;
@@ -1201,7 +1200,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	if (!hw) {
 		pr_err("%s: Cannot allocate network device\n",
 				cfg(trans)->name);
-		err = -ENOMEM;
 		goto out;
 	}
 
@@ -1273,26 +1271,24 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		cfg(priv)->name, trans(priv)->hw_rev);
 
-	err = iwl_trans_start_hw(trans(priv));
-	if (err)
+	if (iwl_trans_start_hw(trans(priv)))
 		goto out_free_traffic_mem;
 
 	/*****************
 	 * 3. Read EEPROM
 	 *****************/
-	err = iwl_eeprom_init(trans(priv), trans(priv)->hw_rev);
-	/* Reset chip to save power until we load uCode during "up". */
-	iwl_trans_stop_hw(trans(priv));
-	if (err) {
+	/* Read the EEPROM */
+	if (iwl_eeprom_init(trans(priv), trans(priv)->hw_rev)) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_traffic_mem;
 	}
-	err = iwl_eeprom_check_version(priv);
-	if (err)
+	/* Reset chip to save power until we load uCode during "up". */
+	iwl_trans_stop_hw(trans(priv));
+
+	if (iwl_eeprom_check_version(priv))
 		goto out_free_eeprom;
 
-	err = iwl_eeprom_init_hw_params(priv);
-	if (err)
+	if (iwl_eeprom_init_hw_params(priv))
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
@@ -1332,9 +1328,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 * 5. Setup priv
 	 *******************/
 
-	err = iwl_init_drv(priv);
-	if (err)
+	if (iwl_init_drv(priv))
 		goto out_free_eeprom;
+
 	/* At this point both hw and priv are initialized. */
 
 	/********************
@@ -1367,15 +1363,12 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 *
 	 * 7. Setup and register with mac80211 and debugfs
 	 **************************************************/
-	err = iwlagn_mac_setup_register(priv, &fw->ucode_capa);
-	if (err)
+	if (iwlagn_mac_setup_register(priv, &fw->ucode_capa))
 		goto out_destroy_workqueue;
 
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err)
+	if (iwl_dbgfs_register(priv, DRV_NAME))
 		IWL_ERR(priv,
-			"failed to create debugfs files. Ignoring error: %d\n",
-			err);
+			"failed to create debugfs files. Ignoring error\n");
 
 	return op_mode;
 
-- 
1.7.0.4

