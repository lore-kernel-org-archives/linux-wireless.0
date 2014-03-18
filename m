Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55640 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaCROqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:06 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so5557449eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/35] iwlwifi: mvm: BT Coex add support for Co-running block
Date: Tue, 18 Mar 2014 16:45:17 +0200
Message-Id: <1395153939-23897-13-git-send-email-egrumbach@gmail.com> (sfid-20140318_155650_086570_F81DA7BC)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

7265 features a new calibration which is called antenna
coupling. The purpose of this calibration (which isn't
really a calibration), is to measure the isolation between
the antennas and that can give us useful information for
the Coex modules.

With this information, we can tune the LookUpTables (LUTs)
that define the BT / WiFi contention policy.

The LUTs currently contain dummy values - but they will be
updated soon.

While at it, change the current code to stop duplicate the
host command while sending. This was needed back then, when
the command was short enough to be allocated on the stack.
Since then, the command grew a lot and is now allocated on
the heap - hence we can use the NOCOPY option instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        | 291 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/constants.h      |   1 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        |   3 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |   1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |   5 +
 drivers/net/wireless/iwlwifi/mvm/ops.c            |   3 +
 7 files changed, 303 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 38a54a3..4ae3c85 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -305,6 +305,215 @@ static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
 	cpu_to_le32(0x33113311),
 };
 
+struct corunning_block_luts {
+	u8 range;
+	__le32 lut20[BT_COEX_CORUN_LUT_SIZE];
+};
+
+/*
+ * Ranges for the antenna coupling calibration / co-running block LUT:
+ *		LUT0: [ 0, 12[
+ *		LUT1: [12, 20[
+ *		LUT2: [20, 21[
+ *		LUT3: [21, 23[
+ *		LUT4: [23, 27[
+ *		LUT5: [27, 30[
+ *		LUT6: [30, 32[
+ *		LUT7: [32, 33[
+ *		LUT8: [33, - [
+ */
+static const struct corunning_block_luts antenna_coupling_ranges[] = {
+	{
+		.range = 0,
+		.lut20 = {
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 12,
+		.lut20 = {
+			cpu_to_le32(0x00000001),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 20,
+		.lut20 = {
+			cpu_to_le32(0x00000002),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 21,
+		.lut20 = {
+			cpu_to_le32(0x00000003),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 23,
+		.lut20 = {
+			cpu_to_le32(0x00000004),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 27,
+		.lut20 = {
+			cpu_to_le32(0x00000005),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 30,
+		.lut20 = {
+			cpu_to_le32(0x00000006),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 32,
+		.lut20 = {
+			cpu_to_le32(0x00000007),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+	{
+		.range = 33,
+		.lut20 = {
+			cpu_to_le32(0x00000008),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+			cpu_to_le32(0x00000000),  cpu_to_le32(0x00000000),
+		},
+	},
+};
+
 static enum iwl_bt_coex_lut_type
 iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 {
@@ -390,8 +599,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 					    BT_VALID_LUT |
 					    BT_VALID_WIFI_RX_SW_PRIO_BOOST |
 					    BT_VALID_WIFI_TX_SW_PRIO_BOOST |
-					    BT_VALID_CORUN_LUT_20 |
-					    BT_VALID_CORUN_LUT_40 |
 					    BT_VALID_ANT_ISOLATION |
 					    BT_VALID_ANT_ISOLATION_THRS |
 					    BT_VALID_TXTX_DELTA_FREQ_THRS |
@@ -401,6 +608,12 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	if (IWL_MVM_BT_COEX_SYNC2SCO)
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
 
+	if (IWL_MVM_BT_COEX_CORUNNING) {
+		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_CORUN_LUT_20 |
+						    BT_VALID_CORUN_LUT_40);
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
+	}
+
 	if (mvm->cfg->bt_shared_single_ant)
 		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
 		       sizeof(iwl_single_shared_ant));
@@ -408,6 +621,12 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		memcpy(&bt_cmd->decision_lut, iwl_combined_lookup,
 		       sizeof(iwl_combined_lookup));
 
+	/* Take first Co-running block LUT to get started */
+	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[0].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut20));
+	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[0].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut40));
+
 	memcpy(&bt_cmd->bt_prio_boost, iwl_bt_prio_boost,
 	       sizeof(iwl_bt_prio_boost));
 	memcpy(&bt_cmd->bt4_multiprio_lut, iwl_bt_mprio_lut,
@@ -498,7 +717,7 @@ int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable)
 	struct iwl_host_cmd cmd = {
 		.id = BT_CONFIG,
 		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_DUP, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 		.flags = CMD_ASYNC,
 	};
 	struct iwl_mvm_sta *mvmsta;
@@ -993,3 +1212,69 @@ void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
 
 	iwl_mvm_bt_coex_notif_handle(mvm);
 }
+
+int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
+				  struct iwl_rx_cmd_buffer *rxb,
+				  struct iwl_device_cmd *dev_cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
+	u8 __maybe_unused lower_bound, upper_bound;
+	u8 lut;
+
+	struct iwl_bt_coex_cmd *bt_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_SYNC,
+	};
+
+	if (!IWL_MVM_BT_COEX_CORUNNING)
+		return 0;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (ant_isolation ==  mvm->last_ant_isol)
+		return 0;
+
+	for (lut = 0; lut < ARRAY_SIZE(antenna_coupling_ranges) - 1; lut++)
+		if (ant_isolation < antenna_coupling_ranges[lut + 1].range)
+			break;
+
+	lower_bound = antenna_coupling_ranges[lut].range;
+
+	if (lut < ARRAY_SIZE(antenna_coupling_ranges) - 1)
+		upper_bound = antenna_coupling_ranges[lut + 1].range;
+	else
+		upper_bound = antenna_coupling_ranges[lut].range;
+
+	IWL_DEBUG_COEX(mvm, "Antenna isolation=%d in range [%d,%d[, lut=%d\n",
+		       ant_isolation, lower_bound, upper_bound, lut);
+
+	mvm->last_ant_isol = ant_isolation;
+
+	if (mvm->last_corun_lut == lut)
+		return 0;
+
+	mvm->last_corun_lut = lut;
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
+	if (!bt_cmd)
+		return 0;
+	cmd.data[0] = bt_cmd;
+
+	bt_cmd->flags = cpu_to_le32(BT_COEX_NW);
+	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
+					     BT_VALID_CORUN_LUT_20 |
+					     BT_VALID_CORUN_LUT_40);
+
+	/* For the moment, use the same LUT for 20GHz and 40GHz */
+	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[lut].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut20));
+
+	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[lut].lut20,
+	       sizeof(bt_cmd->bt4_corun_lut40));
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 2d133b1..37d5f35 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -82,5 +82,6 @@
 #define IWL_MVM_LOWLAT_SINGLE_BINDING_MAXDUR	24 /* TU */
 #define IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR	24 /* TU */
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
+#define IWL_MVM_BT_COEX_CORUNNING		1
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e3b42b4..21ef8da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -350,6 +350,9 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 			 le32_to_cpu(notif->secondary_ch_lut));
 	pos += scnprintf(buf+pos, bufsz-pos, "bt_activity_grading = %d\n",
 			 le32_to_cpu(notif->bt_activity_grading));
+	pos += scnprintf(buf+pos, bufsz-pos,
+			 "antenna isolation = %d CORUN LUT index = %d\n",
+			 mvm->last_ant_isol, mvm->last_corun_lut);
 
 	mutex_unlock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
index 20b723d..32156d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
@@ -77,6 +77,7 @@
  * @BT_COEX_3W:
  * @BT_COEX_NW:
  * @BT_COEX_SYNC2SCO:
+ * @BT_COEX_CORUNNING:
  *
  * The COEX_MODE must be set for each command. Even if it is not changed.
  */
@@ -88,6 +89,7 @@ enum iwl_bt_coex_flags {
 	BT_COEX_3W			= 0x2 << BT_COEX_MODE_POS,
 	BT_COEX_NW			= 0x3 << BT_COEX_MODE_POS,
 	BT_COEX_SYNC2SCO		= BIT(7),
+	BT_COEX_CORUNNING		= BIT(8),
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 807fa52..703168b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -95,6 +95,7 @@ enum {
 	/* PHY context commands */
 	PHY_CONTEXT_CMD = 0x8,
 	DBG_CFG = 0x9,
+	ANTENNA_COUPLING_NOTIFICATION = 0xa,
 
 	/* station table */
 	ADD_STA_KEY = 0x17,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index e5c1db9..18939dc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -597,6 +597,8 @@ struct iwl_mvm {
 	u8 bt_kill_msk;
 	struct iwl_bt_coex_profile_notif last_bt_notif;
 	struct iwl_bt_coex_ci_cmd last_bt_ci_cmd;
+	u32 last_ant_isol;
+	u8 last_corun_lut;
 
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
@@ -750,6 +752,9 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_radio_ver(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			 struct iwl_device_cmd *cmd);
+int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
+				  struct iwl_rx_cmd_buffer *rxb,
+				  struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			  struct iwl_device_cmd *cmd);
 int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 39279e1..75fbc40 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -220,6 +220,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(BT_PROFILE_NOTIFICATION, iwl_mvm_rx_bt_coex_notif, true),
 	RX_HANDLER(BEACON_NOTIFICATION, iwl_mvm_rx_beacon_notif, false),
 	RX_HANDLER(STATISTICS_NOTIFICATION, iwl_mvm_rx_statistics, true),
+	RX_HANDLER(ANTENNA_COUPLING_NOTIFICATION,
+		   iwl_mvm_rx_ant_coupling_notif, true),
 
 	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif, false),
 
@@ -321,6 +323,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(MAC_PM_POWER_TABLE),
 	CMD(BT_COEX_CI),
 	CMD(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
+	CMD(ANTENNA_COUPLING_NOTIFICATION),
 };
 #undef CMD
 
-- 
1.8.3.2

