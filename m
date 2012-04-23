Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab2DWVxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:53:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 28/29] iwlwifi: clean up module parameters
Date: Mon, 23 Apr 2012 14:47:39 -0700
Message-Id: <1335217660-21950-29-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235323_764199_F9FE6C15)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For now at least, all module parameters should be
with the core functionality, so move them there,
while at it rename to iwlwifi_mod_params. Also
rename iwl-shared.h to iwl-modparams.h to reflect
the real contents.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |   16 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   91 ++----------------
 drivers/net/wireless/iwlwifi/iwl-debug.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h        |    1 -
 drivers/net/wireless/iwlwifi/iwl-drv.c        |   88 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-led.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |   13 ++-
 drivers/net/wireless/iwlwifi/iwl-modparams.h  |  124 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-pci.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c      |    7 +-
 drivers/net/wireless/iwlwifi/iwl-power.h      |    9 --
 drivers/net/wireless/iwlwifi/iwl-shared.h     |  115 -----------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 -
 18 files changed, 248 insertions(+), 238 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-modparams.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-shared.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ed37174..e1c2bb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -37,6 +37,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
+#include "iwl-modparams.h"
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 {
@@ -92,17 +93,6 @@ void iwlagn_temperature(struct iwl_priv *priv)
 	iwl_tt_handler(priv);
 }
 
-struct iwl_mod_params iwlagn_mod_params = {
-	.amsdu_size_8K = 1,
-	.restart_fw = 1,
-	.plcp_check = true,
-	.bt_coex_active = true,
-	.power_level = IWL_POWER_INDEX_1,
-	.bt_ch_announce = true,
-	.auto_agg = true,
-	/* the rest are 0 by default */
-};
-
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 {
 	int idx = 0;
@@ -343,7 +333,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	 * (might be in monitor mode), or the interface is in
 	 * IBSS mode (no proper uCode support for coex then).
 	 */
-	if (!iwlagn_mod_params.bt_coex_active ||
+	if (!iwlwifi_mod_params.bt_coex_active ||
 	    priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		basic.flags = IWLAGN_BT_FLAG_COEX_MODE_DISABLED;
 	} else {
@@ -1152,7 +1142,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 	if (ret)
 		goto out;
 
-	if (!iwlagn_mod_params.sw_crypto) {
+	if (!iwlwifi_mod_params.sw_crypto) {
 		/* mark all keys clear */
 		priv->ucode_key_table = 0;
 		ctx->key_mapping_keys = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 14afd01..51e1a69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -38,6 +38,7 @@
 #include "iwl-dev.h"
 #include "iwl-agn.h"
 #include "iwl-op-mode.h"
+#include "iwl-modparams.h"
 
 #define RS_NAME "iwl-agn-rs"
 
@@ -419,7 +420,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 
 	load = rs_tl_get_load(lq_data, tid);
 
-	if ((iwlagn_mod_params.auto_agg) || (load > IWL_AGG_LOAD_THRESHOLD)) {
+	if ((iwlwifi_mod_params.auto_agg) || (load > IWL_AGG_LOAD_THRESHOLD)) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
 		ret = ieee80211_start_tx_ba_session(sta, tid, 5000);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 6b2007a..f941223 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -37,6 +37,7 @@
 #include "iwl-io.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
+#include "iwl-modparams.h"
 
 #define IWL_CMD_ENTRY(x) [x] = #x
 
@@ -337,7 +338,7 @@ static void iwlagn_recover_from_statistics(struct iwl_priv *priv,
 	if (msecs < 99)
 		return;
 
-	if (iwlagn_mod_params.plcp_check &&
+	if (iwlwifi_mod_params.plcp_check &&
 	    !iwlagn_good_plcp_health(priv, cur_ofdm, cur_ofdm_ht, msecs))
 		iwl_force_rf_reset(priv, false);
 }
@@ -747,7 +748,7 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 	}
 
 	/* In case of HW accelerated crypto and bad decryption, drop */
-	if (!iwlagn_mod_params.sw_crypto &&
+	if (!iwlwifi_mod_params.sw_crypto &&
 	    iwlagn_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 6e9dce7..0f7c444 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -29,6 +29,7 @@
 #include "iwl-agn.h"
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
+#include "iwl-modparams.h"
 
 /*
  * initialize rxon structure with default values from eeprom
@@ -1129,7 +1130,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		return 0;
 	}
 
-	iwl_set_rxon_hwcrypto(priv, ctx, !iwlagn_mod_params.sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, ctx, !iwlwifi_mod_params.sw_crypto);
 
 	IWL_DEBUG_INFO(priv,
 		       "Going to commit RXON\n"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index cd331da..a5cfe0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -41,6 +41,7 @@
 #include "iwl-commands.h"
 #include "iwl-debug.h"
 #include "iwl-agn-tt.h"
+#include "iwl-modparams.h"
 
 /* default Thermal Throttling transaction table
  * Current state   |         Throttling Down               |  Throttling Up
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0aba378..e219868 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -52,6 +52,7 @@
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
+#include "iwl-modparams.h"
 
 /******************************************************************************
  *
@@ -752,7 +753,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 		.kill_cts_mask = 0,
 	};
 
-	if (!iwlagn_mod_params.bt_coex_active)
+	if (!iwlwifi_mod_params.bt_coex_active)
 		bt_cmd.flags = BT_COEX_DISABLE;
 	else
 		bt_cmd.flags = BT_COEX_ENABLE;
@@ -1190,7 +1191,7 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 		max_bit_rate = MAX_BIT_RATE_40_MHZ;
 	}
 
-	if (iwlagn_mod_params.amsdu_size_8K)
+	if (iwlwifi_mod_params.amsdu_size_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
@@ -1428,7 +1429,7 @@ void iwl_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.use_rts_for_aggregation =
 			priv->cfg->ht_params->use_rts_for_aggregation;
 
-	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		priv->hw_params.sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	/* Device-specific setup */
@@ -1554,8 +1555,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.op_mode = op_mode;
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
-	trans_cfg.rx_buf_size_8k = iwlagn_mod_params.amsdu_size_8K;
-	if (!iwlagn_mod_params.wd_disable)
+	trans_cfg.rx_buf_size_8k = iwlwifi_mod_params.amsdu_size_8K;
+	if (!iwlwifi_mod_params.wd_disable)
 		trans_cfg.queue_watchdog_timeout =
 			priv->cfg->base_params->wd_timeout;
 	else
@@ -1600,12 +1601,12 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
-		(iwlagn_mod_params.ant_coupling >
+		(iwlwifi_mod_params.ant_coupling >
 			IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
 			true : false;
 
 	/* enable/disable bt channel inhibition */
-	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
+	priv->bt_ch_announce = iwlwifi_mod_params.bt_ch_announce;
 	IWL_DEBUG_INFO(priv, "BT channel inhibition is %s\n",
 		       (priv->bt_ch_announce) ? "On" : "Off");
 
@@ -2204,7 +2205,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	}
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		if (iwlagn_mod_params.restart_fw) {
+		if (iwlwifi_mod_params.restart_fw) {
 			IWL_DEBUG_FW_ERRORS(priv,
 				  "Restarting adapter due to uCode error.\n");
 			queue_work(priv->workqueue, &priv->restart);
@@ -2394,77 +2395,3 @@ static void __exit iwl_exit(void)
 
 module_exit(iwl_exit);
 module_init(iwl_init);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-module_param_named(debug, iwlagn_mod_params.debug_level, uint,
-		   S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "debug output mask");
-#endif
-
-module_param_named(swcrypto, iwlagn_mod_params.sw_crypto, int, S_IRUGO);
-MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(11n_disable, iwlagn_mod_params.disable_11n, uint, S_IRUGO);
-MODULE_PARM_DESC(11n_disable,
-	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
-module_param_named(amsdu_size_8K, iwlagn_mod_params.amsdu_size_8K,
-		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
-module_param_named(fw_restart, iwlagn_mod_params.restart_fw, int, S_IRUGO);
-MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
-
-module_param_named(antenna_coupling, iwlagn_mod_params.ant_coupling,
-		   int, S_IRUGO);
-MODULE_PARM_DESC(antenna_coupling,
-		 "specify antenna coupling in dB (defualt: 0 dB)");
-
-module_param_named(bt_ch_inhibition, iwlagn_mod_params.bt_ch_announce,
-		   bool, S_IRUGO);
-MODULE_PARM_DESC(bt_ch_inhibition,
-		 "Enable BT channel inhibition (default: enable)");
-
-module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
-MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
-
-module_param_named(wd_disable, iwlagn_mod_params.wd_disable, int, S_IRUGO);
-MODULE_PARM_DESC(wd_disable,
-		"Disable stuck queue watchdog timer 0=system default, "
-		"1=disable, 2=enable (default: 0)");
-
-/*
- * set bt_coex_active to true, uCode will do kill/defer
- * every time the priority line is asserted (BT is sending signals on the
- * priority line in the PCIx).
- * set bt_coex_active to false, uCode will ignore the BT activity and
- * perform the normal operation
- *
- * User might experience transmit issue on some platform due to WiFi/BT
- * co-exist problem. The possible behaviors are:
- *   Able to scan and finding all the available AP
- *   Not able to associate with any AP
- * On those platforms, WiFi communication can be restored by set
- * "bt_coex_active" module parameter to "false"
- *
- * default: bt_coex_active = true (BT_COEX_ENABLE)
- */
-module_param_named(bt_coex_active, iwlagn_mod_params.bt_coex_active,
-		bool, S_IRUGO);
-MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
-
-module_param_named(led_mode, iwlagn_mod_params.led_mode, int, S_IRUGO);
-MODULE_PARM_DESC(led_mode, "0=system default, "
-		"1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0)");
-
-module_param_named(power_save, iwlagn_mod_params.power_save,
-		bool, S_IRUGO);
-MODULE_PARM_DESC(power_save,
-		 "enable WiFi power management (default: disable)");
-
-module_param_named(power_level, iwlagn_mod_params.power_level,
-		int, S_IRUGO);
-MODULE_PARM_DESC(power_level,
-		 "default power save level (range from 1 - 5, default: 1)");
-
-module_param_named(auto_agg, iwlagn_mod_params.auto_agg,
-		bool, S_IRUGO);
-MODULE_PARM_DESC(auto_agg,
-		 "enable agg w/o check traffic load (default: enable)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 2dcbeba..8376b84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -29,12 +29,12 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
-#include "iwl-shared.h"
+#include "iwl-modparams.h"
 
 
 static inline bool iwl_have_debug_level(u32 level)
 {
-	return iwlagn_mod_params.debug_level & level;
+	return iwlwifi_mod_params.debug_level & level;
 }
 
 void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f612ce8..e7c157e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -39,6 +39,7 @@
 #include "iwl-debug.h"
 #include "iwl-io.h"
 #include "iwl-agn.h"
+#include "iwl-modparams.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7994be3..b064676 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -48,7 +48,6 @@
 #include "iwl-agn-rs.h"
 #include "iwl-agn-tt.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 #include "iwl-op-mode.h"
 #include "iwl-notif-wait.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 28d81a7..05302d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -71,6 +71,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-fw.h"
 #include "iwl-config.h"
+#include "iwl-modparams.h"
 
 /* private includes */
 #include "iwl-fw-file.h"
@@ -924,3 +925,90 @@ void iwl_drv_stop(struct iwl_drv *drv)
 
 	kfree(drv);
 }
+
+
+/* shared module parameters */
+struct iwl_mod_params iwlwifi_mod_params = {
+	.amsdu_size_8K = 1,
+	.restart_fw = 1,
+	.plcp_check = true,
+	.bt_coex_active = true,
+	.power_level = IWL_POWER_INDEX_1,
+	.bt_ch_announce = true,
+	.auto_agg = true,
+	/* the rest are 0 by default */
+};
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+module_param_named(debug, iwlwifi_mod_params.debug_level, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "debug output mask");
+#endif
+
+module_param_named(swcrypto, iwlwifi_mod_params.sw_crypto, int, S_IRUGO);
+MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
+module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
+MODULE_PARM_DESC(11n_disable,
+	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
+module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
+		   int, S_IRUGO);
+MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
+module_param_named(fw_restart, iwlwifi_mod_params.restart_fw, int, S_IRUGO);
+MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
+
+module_param_named(antenna_coupling, iwlwifi_mod_params.ant_coupling,
+		   int, S_IRUGO);
+MODULE_PARM_DESC(antenna_coupling,
+		 "specify antenna coupling in dB (defualt: 0 dB)");
+
+module_param_named(bt_ch_inhibition, iwlwifi_mod_params.bt_ch_announce,
+		   bool, S_IRUGO);
+MODULE_PARM_DESC(bt_ch_inhibition,
+		 "Enable BT channel inhibition (default: enable)");
+
+module_param_named(plcp_check, iwlwifi_mod_params.plcp_check, bool, S_IRUGO);
+MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
+
+module_param_named(wd_disable, iwlwifi_mod_params.wd_disable, int, S_IRUGO);
+MODULE_PARM_DESC(wd_disable,
+		"Disable stuck queue watchdog timer 0=system default, "
+		"1=disable, 2=enable (default: 0)");
+
+/*
+ * set bt_coex_active to true, uCode will do kill/defer
+ * every time the priority line is asserted (BT is sending signals on the
+ * priority line in the PCIx).
+ * set bt_coex_active to false, uCode will ignore the BT activity and
+ * perform the normal operation
+ *
+ * User might experience transmit issue on some platform due to WiFi/BT
+ * co-exist problem. The possible behaviors are:
+ *   Able to scan and finding all the available AP
+ *   Not able to associate with any AP
+ * On those platforms, WiFi communication can be restored by set
+ * "bt_coex_active" module parameter to "false"
+ *
+ * default: bt_coex_active = true (BT_COEX_ENABLE)
+ */
+module_param_named(bt_coex_active, iwlwifi_mod_params.bt_coex_active,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
+
+module_param_named(led_mode, iwlwifi_mod_params.led_mode, int, S_IRUGO);
+MODULE_PARM_DESC(led_mode, "0=system default, "
+		"1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0)");
+
+module_param_named(power_save, iwlwifi_mod_params.power_save,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(power_save,
+		 "enable WiFi power management (default: disable)");
+
+module_param_named(power_level, iwlwifi_mod_params.power_level,
+		int, S_IRUGO);
+MODULE_PARM_DESC(power_level,
+		 "default power save level (range from 1 - 5, default: 1)");
+
+module_param_named(auto_agg, iwlwifi_mod_params.auto_agg,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(auto_agg,
+		 "enable agg w/o check traffic load (default: enable)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 1d62d06..4700041 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -39,6 +39,7 @@
 #include "iwl-agn.h"
 #include "iwl-io.h"
 #include "iwl-trans.h"
+#include "iwl-modparams.h"
 
 /* Throughput		OFF time(ms)	ON time (ms)
  *	>300			25		25
@@ -173,7 +174,7 @@ static int iwl_led_blink_set(struct led_classdev *led_cdev,
 
 void iwl_leds_init(struct iwl_priv *priv)
 {
-	int mode = iwlagn_mod_params.led_mode;
+	int mode = iwlwifi_mod_params.led_mode;
 	int ret;
 
 	if (mode == IWL_LED_DISABLE) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 4f45156..9670554 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -49,6 +49,7 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
+#include "iwl-modparams.h"
 
 /*****************************************************************************
  *
@@ -202,7 +203,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 					  WIPHY_WOWLAN_DISCONNECT |
 					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
 					  WIPHY_WOWLAN_RFKILL_RELEASE;
-		if (!iwlagn_mod_params.sw_crypto)
+		if (!iwlwifi_mod_params.sw_crypto)
 			hw->wiphy->wowlan.flags |=
 				WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
 				WIPHY_WOWLAN_GTK_REKEY_FAILURE;
@@ -214,7 +215,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
 
-	if (iwlagn_mod_params.power_save)
+	if (iwlwifi_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -365,7 +366,7 @@ void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
-	if (iwlagn_mod_params.sw_crypto)
+	if (iwlwifi_mod_params.sw_crypto)
 		return;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -531,7 +532,7 @@ int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (iwlagn_mod_params.sw_crypto) {
+	if (iwlwifi_mod_params.sw_crypto) {
 		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -642,7 +643,7 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
 			break;
 		IWL_DEBUG_HT(priv, "start Rx\n");
 		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
@@ -654,7 +655,7 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		if (!priv->trans->ops->tx_agg_setup)
 			break;
-		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
 			break;
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
new file mode 100644
index 0000000..558b2e6
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -0,0 +1,124 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_shared_h__
+#define __iwl_shared_h__
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/gfp.h>
+#include <net/mac80211.h>
+
+extern struct iwl_mod_params iwlwifi_mod_params;
+
+enum iwl_power_level {
+	IWL_POWER_INDEX_1,
+	IWL_POWER_INDEX_2,
+	IWL_POWER_INDEX_3,
+	IWL_POWER_INDEX_4,
+	IWL_POWER_INDEX_5,
+	IWL_POWER_NUM
+};
+
+#define IWL_DISABLE_HT_ALL	BIT(0)
+#define IWL_DISABLE_HT_TXAGG	BIT(1)
+#define IWL_DISABLE_HT_RXAGG	BIT(2)
+
+/**
+ * struct iwl_mod_params
+ *
+ * Holds the module parameters
+ *
+ * @sw_crypto: using hardware encryption, default = 0
+ * @disable_11n: disable 11n capabilities, default = 0,
+ *	use IWL_DISABLE_HT_* constants
+ * @amsdu_size_8K: enable 8K amsdu size, default = 1
+ * @restart_fw: restart firmware, default = 1
+ * @plcp_check: enable plcp health check, default = true
+ * @wd_disable: enable stuck queue check, default = 0
+ * @bt_coex_active: enable bt coex, default = true
+ * @led_mode: system default, default = 0
+ * @power_save: disable power save, default = false
+ * @power_level: power level, default = 1
+ * @debug_level: levels are IWL_DL_*
+ * @ant_coupling: antenna coupling in dB, default = 0
+ * @bt_ch_announce: BT channel inhibition, default = enable
+ * @auto_agg: enable agg. without check, default = true
+ */
+struct iwl_mod_params {
+	int sw_crypto;
+	unsigned int disable_11n;
+	int amsdu_size_8K;
+	int restart_fw;
+	bool plcp_check;
+	int  wd_disable;
+	bool bt_coex_active;
+	int led_mode;
+	bool power_save;
+	int power_level;
+	u32 debug_level;
+	int ant_coupling;
+	bool bt_ch_announce;
+	bool auto_agg;
+};
+
+#endif /* #__iwl_shared_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index e80e9aa..0c8a1c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -72,7 +72,6 @@
 #include "iwl-drv.h"
 #include "iwl-trans.h"
 #include "iwl-trans-pcie-int.h"
-#include "iwl-shared.h"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 5fba34b..8352265 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -42,6 +42,7 @@
 #include "iwl-debug.h"
 #include "iwl-power.h"
 #include "iwl-trans.h"
+#include "iwl-modparams.h"
 
 /*
  * Setting power level allows the card to go to sleep when not busy.
@@ -307,10 +308,10 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 				     priv->power_data.debug_sleep_level_override,
 				     dtimper);
 	else {
-		if (iwlagn_mod_params.power_level > IWL_POWER_INDEX_1 &&
-		    iwlagn_mod_params.power_level <= IWL_POWER_INDEX_5)
+		if (iwlwifi_mod_params.power_level > IWL_POWER_INDEX_1 &&
+		    iwlwifi_mod_params.power_level <= IWL_POWER_INDEX_5)
 			iwl_static_sleep_cmd(priv, cmd,
-				iwlagn_mod_params.power_level, dtimper);
+				iwlwifi_mod_params.power_level, dtimper);
 		else
 			iwl_static_sleep_cmd(priv, cmd,
 				IWL_POWER_INDEX_1, dtimper);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 07a19fc..21afc92 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -30,15 +30,6 @@
 
 #include "iwl-commands.h"
 
-enum iwl_power_level {
-	IWL_POWER_INDEX_1,
-	IWL_POWER_INDEX_2,
-	IWL_POWER_INDEX_3,
-	IWL_POWER_INDEX_4,
-	IWL_POWER_INDEX_5,
-	IWL_POWER_NUM
-};
-
 struct iwl_power_mgr {
 	struct iwl_powertable_cmd sleep_cmd;
 	struct iwl_powertable_cmd sleep_cmd_next;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
deleted file mode 100644
index 3f21dd2..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ /dev/null
@@ -1,115 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#ifndef __iwl_shared_h__
-#define __iwl_shared_h__
-
-#include <linux/types.h>
-#include <linux/spinlock.h>
-#include <linux/gfp.h>
-#include <net/mac80211.h>
-
-extern struct iwl_mod_params iwlagn_mod_params;
-
-#define IWL_DISABLE_HT_ALL	BIT(0)
-#define IWL_DISABLE_HT_TXAGG	BIT(1)
-#define IWL_DISABLE_HT_RXAGG	BIT(2)
-
-/**
- * struct iwl_mod_params
- *
- * Holds the module parameters
- *
- * @sw_crypto: using hardware encryption, default = 0
- * @disable_11n: disable 11n capabilities, default = 0,
- *	use IWL_DISABLE_HT_* constants
- * @amsdu_size_8K: enable 8K amsdu size, default = 1
- * @restart_fw: restart firmware, default = 1
- * @plcp_check: enable plcp health check, default = true
- * @wd_disable: enable stuck queue check, default = 0
- * @bt_coex_active: enable bt coex, default = true
- * @led_mode: system default, default = 0
- * @power_save: disable power save, default = false
- * @power_level: power level, default = 1
- * @debug_level: levels are IWL_DL_*
- * @ant_coupling: antenna coupling in dB, default = 0
- * @bt_ch_announce: BT channel inhibition, default = enable
- * @auto_agg: enable agg. without check, default = true
- */
-struct iwl_mod_params {
-	int sw_crypto;
-	unsigned int disable_11n;
-	int amsdu_size_8K;
-	int restart_fw;
-	bool plcp_check;
-	int  wd_disable;
-	bool bt_coex_active;
-	int led_mode;
-	bool power_save;
-	int power_level;
-	u32 debug_level;
-	int ant_coupling;
-	bool bt_ch_announce;
-	bool auto_agg;
-};
-
-#endif /* #__iwl_shared_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 3eab7d5..63557bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -70,7 +70,6 @@
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
-#include "iwl-shared.h"
 #include "iwl-trans-pcie-int.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
-- 
1.7.0.4

