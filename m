Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbbCLNGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:23 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/49] iwlwifi: mvm: BT Coex - update the new API
Date: Thu, 12 Mar 2015 15:04:28 +0200
Message-Id: <1426165474-25586-43-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_671038_BE273D73)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware was not using the new API, so we don't need to
differentiate between the different stages of this new API.
The main difference here is that most of the hard coded
values are not sent through the command anymore.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 220 -------------------------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c |  59 +++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  26 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h |  47 ------
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  11 --
 5 files changed, 65 insertions(+), 298 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index ce99572..c7358a9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -72,158 +72,6 @@
 #include "mvm.h"
 #include "iwl-debug.h"
 
-const u32 iwl_bt_ctl_kill_msk[BT_KILL_MSK_MAX] = {
-	[BT_KILL_MSK_DEFAULT] = 0xfffffc00,
-	[BT_KILL_MSK_NEVER] = 0xffffffff,
-	[BT_KILL_MSK_ALWAYS] = 0,
-};
-
-const u8 iwl_bt_cts_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT] = {
-	{
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-	},
-	{
-		BT_KILL_MSK_NEVER,
-		BT_KILL_MSK_NEVER,
-		BT_KILL_MSK_NEVER,
-	},
-	{
-		BT_KILL_MSK_NEVER,
-		BT_KILL_MSK_NEVER,
-		BT_KILL_MSK_NEVER,
-	},
-	{
-		BT_KILL_MSK_DEFAULT,
-		BT_KILL_MSK_NEVER,
-		BT_KILL_MSK_DEFAULT,
-	},
-};
-
-const u8 iwl_bt_ack_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT] = {
-	{
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-	},
-	{
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-	},
-	{
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_ALWAYS,
-	},
-	{
-		BT_KILL_MSK_DEFAULT,
-		BT_KILL_MSK_ALWAYS,
-		BT_KILL_MSK_DEFAULT,
-	},
-};
-
-static const __le32 iwl_bt_prio_boost[BT_COEX_BOOST_SIZE] = {
-	cpu_to_le32(0xf0f0f0f0), /* 50% */
-	cpu_to_le32(0xc0c0c0c0), /* 25% */
-	cpu_to_le32(0xfcfcfcfc), /* 75% */
-	cpu_to_le32(0xfefefefe), /* 87.5% */
-};
-
-static const __le32 iwl_single_shared_ant[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
-	{
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x40000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x44000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-	},
-};
-
-static const __le32 iwl_combined_lookup[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
-	{
-		/* Tight */
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaeaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xcc00ff28),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xcc00aaaa),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0x00004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		/* Loose */
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xcc00ff28),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xcc00aaaa),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0x00000000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xf0005000),
-	},
-	{
-		/* Tx Tx disabled */
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xeeaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xcc00ff28),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xcc00aaaa),
-		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0xf0005000),
-		cpu_to_le32(0xf0005000),
-	},
-};
-
 /* 20MHz / 40MHz below / 40Mhz above*/
 static const __le64 iwl_ci_mask[][3] = {
 	/* dummy entry for channel 0 */
@@ -596,14 +444,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		goto send_cmd;
 	}
 
-	bt_cmd->max_kill = cpu_to_le32(5);
-	bt_cmd->bt4_antenna_isolation_thr =
-		cpu_to_le32(IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS);
-	bt_cmd->bt4_tx_tx_delta_freq_thr = cpu_to_le32(15);
-	bt_cmd->bt4_tx_rx_max_freq0 = cpu_to_le32(15);
-	bt_cmd->override_primary_lut = cpu_to_le32(BT_COEX_INVALID_LUT);
-	bt_cmd->override_secondary_lut = cpu_to_le32(BT_COEX_INVALID_LUT);
-
 	mode = iwlwifi_mod_params.bt_coex_active ? BT_COEX_NW : BT_COEX_DISABLE;
 	bt_cmd->mode = cpu_to_le32(mode);
 
@@ -622,18 +462,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 
 	bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_HIGH_BAND_RET);
 
-	if (mvm->cfg->bt_shared_single_ant)
-		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
-		       sizeof(iwl_single_shared_ant));
-	else
-		memcpy(&bt_cmd->decision_lut, iwl_combined_lookup,
-		       sizeof(iwl_combined_lookup));
-
-	memcpy(&bt_cmd->mplut_prio_boost, iwl_bt_prio_boost,
-	       sizeof(iwl_bt_prio_boost));
-	bt_cmd->multiprio_lut[0] = cpu_to_le32(IWL_MVM_BT_COEX_MPLUT_REG0);
-	bt_cmd->multiprio_lut[1] = cpu_to_le32(IWL_MVM_BT_COEX_MPLUT_REG1);
-
 send_cmd:
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
@@ -644,48 +472,6 @@ send_cmd:
 	return ret;
 }
 
-static int iwl_mvm_bt_udpate_sw_boost(struct iwl_mvm *mvm)
-{
-	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
-	u32 primary_lut = le32_to_cpu(notif->primary_ch_lut);
-	u32 secondary_lut = le32_to_cpu(notif->secondary_ch_lut);
-	u32 ag = le32_to_cpu(notif->bt_activity_grading);
-	struct iwl_bt_coex_sw_boost_update_cmd cmd = {};
-	u8 ack_kill_msk[NUM_PHY_CTX] = {};
-	u8 cts_kill_msk[NUM_PHY_CTX] = {};
-	int i;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	ack_kill_msk[0] = iwl_bt_ack_kill_msk[ag][primary_lut];
-	cts_kill_msk[0] = iwl_bt_cts_kill_msk[ag][primary_lut];
-
-	ack_kill_msk[1] = iwl_bt_ack_kill_msk[ag][secondary_lut];
-	cts_kill_msk[1] = iwl_bt_cts_kill_msk[ag][secondary_lut];
-
-	/* Don't send HCMD if there is no update */
-	if (!memcmp(ack_kill_msk, mvm->bt_ack_kill_msk, sizeof(ack_kill_msk)) ||
-	    !memcmp(cts_kill_msk, mvm->bt_cts_kill_msk, sizeof(cts_kill_msk)))
-		return 0;
-
-	memcpy(mvm->bt_ack_kill_msk, ack_kill_msk,
-	       sizeof(mvm->bt_ack_kill_msk));
-	memcpy(mvm->bt_cts_kill_msk, cts_kill_msk,
-	       sizeof(mvm->bt_cts_kill_msk));
-
-	BUILD_BUG_ON(ARRAY_SIZE(ack_kill_msk) < ARRAY_SIZE(cmd.boost_values));
-
-	for (i = 0; i < ARRAY_SIZE(cmd.boost_values); i++) {
-		cmd.boost_values[i].kill_ack_msk =
-			cpu_to_le32(iwl_bt_ctl_kill_msk[ack_kill_msk[i]]);
-		cmd.boost_values[i].kill_cts_msk =
-			cpu_to_le32(iwl_bt_ctl_kill_msk[cts_kill_msk[i]]);
-	}
-
-	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_SW_BOOST, 0,
-				    sizeof(cmd), &cmd);
-}
-
 static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 				       bool enable)
 {
@@ -950,9 +736,6 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 			IWL_ERR(mvm, "Failed to send BT_CI cmd\n");
 		memcpy(&mvm->last_bt_ci_cmd, &cmd, sizeof(cmd));
 	}
-
-	if (iwl_mvm_bt_udpate_sw_boost(mvm))
-		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
 int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
@@ -1073,9 +856,6 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_bt_rssi_iterator, &data);
-
-	if (iwl_mvm_bt_udpate_sw_boost(mvm))
-		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000)
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 593bed7..897dd53 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -288,6 +288,65 @@ static const __le64 iwl_ci_mask[][3] = {
 	},
 };
 
+enum iwl_bt_kill_msk {
+	BT_KILL_MSK_DEFAULT,
+	BT_KILL_MSK_NEVER,
+	BT_KILL_MSK_ALWAYS,
+	BT_KILL_MSK_MAX,
+};
+
+static const u32 iwl_bt_ctl_kill_msk[BT_KILL_MSK_MAX] = {
+	[BT_KILL_MSK_DEFAULT] = 0xfffffc00,
+	[BT_KILL_MSK_NEVER] = 0xffffffff,
+	[BT_KILL_MSK_ALWAYS] = 0,
+};
+
+static const u8 iwl_bt_cts_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT] = {
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+	},
+	{
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_NEVER,
+	},
+	{
+		BT_KILL_MSK_DEFAULT,
+		BT_KILL_MSK_NEVER,
+		BT_KILL_MSK_DEFAULT,
+	},
+};
+
+static const u8 iwl_bt_ack_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT] = {
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_ALWAYS,
+	},
+	{
+		BT_KILL_MSK_DEFAULT,
+		BT_KILL_MSK_ALWAYS,
+		BT_KILL_MSK_DEFAULT,
+	},
+};
+
 struct corunning_block_luts {
 	u8 range;
 	__le32 lut20[BT_COEX_CORUN_LUT_SIZE];
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 8cbe77d..8c52298 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -562,11 +562,12 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 			       "\tSecondary Channel Bitmap 0x%016llx\n",
 			       le64_to_cpu(cmd->bt_secondary_ci));
 
-		pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
-		pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill Mask 0x%08x\n",
-				 iwl_bt_ctl_kill_msk[mvm->bt_ack_kill_msk[0]]);
-		pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill Mask 0x%08x\n",
-				 iwl_bt_ctl_kill_msk[mvm->bt_cts_kill_msk[0]]);
+		pos += scnprintf(buf+pos, bufsz-pos,
+				 "BT Configuration CMD - 0=default, 1=never, 2=always\n");
+		pos += scnprintf(buf+pos, bufsz-pos, "\tACK Kill msk idx %d\n",
+				 mvm->bt_ack_kill_msk[0]);
+		pos += scnprintf(buf+pos, bufsz-pos, "\tCTS Kill msk idx %d\n",
+				 mvm->bt_cts_kill_msk[0]);
 
 	} else {
 		struct iwl_bt_coex_ci_cmd *cmd = &mvm->last_bt_ci_cmd;
@@ -579,21 +580,6 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 		pos += scnprintf(buf+pos, bufsz-pos,
 			       "\tSecondary Channel Bitmap 0x%016llx\n",
 			       le64_to_cpu(cmd->bt_secondary_ci));
-
-		pos += scnprintf(buf+pos, bufsz-pos, "BT Configuration CMD\n");
-		pos += scnprintf(buf+pos, bufsz-pos,
-				 "\tPrimary: ACK Kill Mask 0x%08x\n",
-				 iwl_bt_ctl_kill_msk[mvm->bt_ack_kill_msk[0]]);
-		pos += scnprintf(buf+pos, bufsz-pos,
-				 "\tPrimary: CTS Kill Mask 0x%08x\n",
-				 iwl_bt_ctl_kill_msk[mvm->bt_cts_kill_msk[0]]);
-		pos += scnprintf(buf+pos, bufsz-pos,
-				 "\tSecondary: ACK Kill Mask 0x%08x\n",
-				 iwl_bt_ctl_kill_msk[mvm->bt_ack_kill_msk[1]]);
-		pos += scnprintf(buf+pos, bufsz-pos,
-				 "\tSecondary: CTS Kill Mask 0x%08x\n",
-				 iwl_bt_ctl_kill_msk[mvm->bt_cts_kill_msk[1]]);
-
 	}
 
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index f3b1189..d398a61 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -235,36 +235,12 @@ enum iwl_bt_coex_enabled_modules {
  * struct iwl_bt_coex_cmd - bt coex configuration command
  * @mode: enum %iwl_bt_coex_mode
  * @enabled_modules: enum %iwl_bt_coex_enabled_modules
- * @max_kill: max count of Tx retries due to kill from PTA
- * @override_primary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
- *	should be set by default
- * @override_secondary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
- *	should be set by default
- * @bt4_antenna_isolation_thr: antenna threshold value
- * @bt4_tx_tx_delta_freq_thr: TxTx delta frequency
- * @bt4_tx_rx_max_freq0: TxRx max frequency
- * @multiprio_lut: multi priority LUT configuration
- * @mplut_prio_boost: BT priority boost registers
- * @decision_lut: PTA decision LUT, per Prio-Ch
  *
  * The structure is used for the BT_COEX command.
  */
 struct iwl_bt_coex_cmd {
 	__le32 mode;
 	__le32 enabled_modules;
-
-	__le32 max_kill;
-	__le32 override_primary_lut;
-	__le32 override_secondary_lut;
-	__le32 bt4_antenna_isolation_thr;
-
-	__le32 bt4_tx_tx_delta_freq_thr;
-	__le32 bt4_tx_rx_max_freq0;
-
-	__le32 multiprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE];
-	__le32 mplut_prio_boost[BT_COEX_BOOST_SIZE];
-
-	__le32 decision_lut[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE];
 } __packed; /* BT_COEX_CMD_API_S_VER_6 */
 
 /**
@@ -280,29 +256,6 @@ struct iwl_bt_coex_corun_lut_update_cmd {
 } __packed; /* BT_COEX_UPDATE_CORUN_LUT_API_S_VER_1 */
 
 /**
- * struct iwl_bt_coex_sw_boost - SW boost values
- * @wifi_tx_prio_boost: SW boost of wifi tx priority
- * @wifi_rx_prio_boost: SW boost of wifi rx priority
- * @kill_ack_msk: kill ACK mask. 1 - Tx ACK, 0 - kill Tx of ACK.
- * @kill_cts_msk: kill CTS mask. 1 - Tx CTS, 0 - kill Tx of CTS.
- */
-struct iwl_bt_coex_sw_boost {
-	__le32 wifi_tx_prio_boost;
-	__le32 wifi_rx_prio_boost;
-	__le32 kill_ack_msk;
-	__le32 kill_cts_msk;
-};
-
-/**
- * struct iwl_bt_coex_sw_boost_update_cmd - command to update the SW boost
- * @boost_values: check struct  %iwl_bt_coex_sw_boost - one for each channel
- *	primary / secondary / low priority
- */
-struct iwl_bt_coex_sw_boost_update_cmd {
-	struct iwl_bt_coex_sw_boost boost_values[3];
-} __packed; /* BT_COEX_UPDATE_SW_BOOST_S_VER_1 */
-
-/**
  * struct iwl_bt_coex_reduced_txp_update_cmd
  * @reduced_txp: bit BT_REDUCED_TX_POWER_BIT to enable / disable, rest of the
  *	bits are the sta_id (value)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 52135a4..432265e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1315,17 +1315,6 @@ int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
 				      struct iwl_rx_cmd_buffer *rxb,
 				      struct iwl_device_cmd *cmd);
 
-enum iwl_bt_kill_msk {
-	BT_KILL_MSK_DEFAULT,
-	BT_KILL_MSK_NEVER,
-	BT_KILL_MSK_ALWAYS,
-	BT_KILL_MSK_MAX,
-};
-
-extern const u8 iwl_bt_ack_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT];
-extern const u8 iwl_bt_cts_kill_msk[BT_MAX_AG][BT_COEX_MAX_LUT];
-extern const u32 iwl_bt_ctl_kill_msk[BT_KILL_MSK_MAX];
-
 /* beacon filtering */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void
-- 
1.9.1

