Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbbBCHPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:05 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/19] iwlwifi: mvm: enable watchdog on Tx queues for mvm
Date: Tue,  3 Feb 2015 09:14:31 +0200
Message-Id: <1422947678-16917-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081512_920950_3ACDCBAE)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This watchdog allows to monitor the transmit queues. When a
queue doesn't progress for a too long time, a timer fires
and then, debug data can be collected.
This watchdog has never been enabled on dvm controlled
devices, so don't enable it there.
In order to have it running on mvm controlled devices, we
need to fix a small issue in the transport layer: mvm
controlled devices use the shadow registers optimization.
In this case, the watchdog wasn't running at all, even if
enabled by the module parameter. Fix that on the way.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c      | 6 +-----
 drivers/net/wireless/iwlwifi/iwl-drv.c       | 5 -----
 drivers/net/wireless/iwlwifi/iwl-modparams.h | 2 --
 drivers/net/wireless/iwlwifi/mvm/mvm.h       | 2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c       | 9 ++++++---
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 2 +-
 6 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index de43dd7..a21400c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1228,11 +1228,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 	trans_cfg.rx_buf_size_8k = iwlwifi_mod_params.amsdu_size_8K;
-	if (!iwlwifi_mod_params.wd_disable)
-		trans_cfg.queue_watchdog_timeout =
-			priv->cfg->base_params->wd_timeout;
-	else
-		trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
+	trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
 	trans_cfg.cmd_fifo = IWLAGN_CMD_FIFO_NUM;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index e7c0df6..996e7f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1367,7 +1367,6 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.restart_fw = true,
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
-	.wd_disable = true,
 	.d0i3_disable = true,
 #ifndef CONFIG_IWLWIFI_UAPSD
 	.uapsd_disable = true,
@@ -1478,10 +1477,6 @@ module_param_named(antenna_coupling, iwlwifi_mod_params.ant_coupling,
 MODULE_PARM_DESC(antenna_coupling,
 		 "specify antenna coupling in dB (default: 0 dB)");
 
-module_param_named(wd_disable, iwlwifi_mod_params.wd_disable, int, S_IRUGO);
-MODULE_PARM_DESC(wd_disable,
-		"Disable stuck queue watchdog timer 0=system default, 1=disable (default: 1)");
-
 module_param_named(nvm_file, iwlwifi_mod_params.nvm_file, charp, S_IRUGO);
 MODULE_PARM_DESC(nvm_file, "NVM file name");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 2a8cf4b..e8eabd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -96,7 +96,6 @@ enum iwl_disable_11n {
  *	use IWL_[DIS,EN]ABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 0
  * @restart_fw: restart firmware, default = 1
- * @wd_disable: disable stuck queue check, default = 1
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
  * @power_save: enable power save, default = false
@@ -111,7 +110,6 @@ struct iwl_mod_params {
 	unsigned int disable_11n;
 	int amsdu_size_8K;
 	bool restart_fw;
-	int  wd_disable;
 	bool bt_coex_active;
 	int led_mode;
 	bool power_save;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ed09726..4a7620c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -119,11 +119,13 @@ extern const struct ieee80211_ops iwl_mvm_hw_ops;
  *	We will register to mac80211 to have testmode working. The NIC must not
  *	be up'ed after the INIT fw asserted. This is useful to be able to use
  *	proprietary tools over testmode to debug the INIT fw.
+ * @tfd_q_hang_detect: enabled the detection of hung transmit queues
  * @power_scheme: CAM(Continuous Active Mode)-1, BPS(Balanced Power
  *	Save)-2(default), LP(Low Power)-3
  */
 struct iwl_mvm_mod_params {
 	bool init_dbg;
+	bool tfd_q_hang_detect;
 	int power_scheme;
 };
 extern struct iwl_mvm_mod_params iwlmvm_mod_params;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b1dea68..f801824 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -93,6 +93,7 @@ static const struct iwl_op_mode_ops iwl_mvm_ops;
 
 struct iwl_mvm_mod_params iwlmvm_mod_params = {
 	.power_scheme = IWL_POWER_SCHEME_BPS,
+	.tfd_q_hang_detect = true
 	/* rest of fields are 0 by default */
 };
 
@@ -102,6 +103,10 @@ MODULE_PARM_DESC(init_dbg,
 module_param_named(power_scheme, iwlmvm_mod_params.power_scheme, int, S_IRUGO);
 MODULE_PARM_DESC(power_scheme,
 		 "power management scheme: 1-active, 2-balanced, 3-low power, default: 2");
+module_param_named(tfd_q_hang_detect, iwlmvm_mod_params.tfd_q_hang_detect,
+		   bool, S_IRUGO);
+MODULE_PARM_DESC(tfd_q_hang_detect,
+		 "TFD queues hang detection (default: true");
 
 /*
  * module init and exit functions
@@ -473,10 +478,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DW_BC_TABLE)
 		trans_cfg.bc_table_dword = true;
 
-	if (!iwlwifi_mod_params.wd_disable)
+	if (iwlmvm_mod_params.tfd_q_hang_detect)
 		trans_cfg.queue_watchdog_timeout = cfg->base_params->wd_timeout;
-	else
-		trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
 
 	trans_cfg.command_names = iwl_mvm_cmd_strings;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 59aefa4..bb9dd3e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1849,7 +1849,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* start timer if queue currently empty */
 	if (q->read_ptr == q->write_ptr) {
-		if (txq->need_update && trans_pcie->wd_timeout)
+		if (trans_pcie->wd_timeout)
 			mod_timer(&txq->stuck_timer,
 				  jiffies + trans_pcie->wd_timeout);
 		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", q->id);
-- 
1.9.1

