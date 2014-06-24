Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:58127 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaFXTwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:55 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so878850wes.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/27] iwlwifi: mvm: BT Coex - allow to force the antenna allocation
Date: Tue, 24 Jun 2014 22:52:12 +0300
Message-Id: <1403639541-4621-18-git-send-email-egrumbach@gmail.com> (sfid-20140624_215300_125481_4F1CA63D)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can be used for testing.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 39 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     | 39 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h |  6 ++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 10 +++++++
 4 files changed, 94 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index c8c3b38..b2003d8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -106,6 +106,9 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 
 static int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
 {
+	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
+		return 0;
+
 	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, 0,
 				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
 				    &iwl_bt_prio_tbl);
@@ -578,6 +581,29 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		return -ENOMEM;
 	cmd.data[0] = bt_cmd;
 
+	lockdep_assert_held(&mvm->mutex);
+
+	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS)) {
+		switch (mvm->bt_force_ant_mode) {
+		case BT_FORCE_ANT_AUTO:
+			flags = BT_COEX_AUTO;
+			break;
+		case BT_FORCE_ANT_BT:
+			flags = BT_COEX_BT;
+			break;
+		case BT_FORCE_ANT_WIFI:
+			flags = BT_COEX_WIFI;
+			break;
+		default:
+			WARN_ON(1);
+			flags = 0;
+		}
+
+		bt_cmd->flags = cpu_to_le32(flags);
+		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_ENABLE);
+		goto send_cmd;
+	}
+
 	bt_cmd->max_kill = 5;
 	bt_cmd->bt4_antenna_isolation_thr = BT_ANTENNA_COUPLING_THRESHOLD;
 	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling;
@@ -642,6 +668,7 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	bt_cmd->kill_cts_msk =
 		cpu_to_le32(iwl_bt_cts_kill_msk[BT_KILL_MSK_DEFAULT]);
 
+send_cmd:
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
 
@@ -955,6 +982,10 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 	struct iwl_bt_coex_ci_cmd cmd = {};
 	u8 ci_bw_idx;
 
+	/* Ignore updates if we are in force mode */
+	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
+		return;
+
 	rcu_read_lock();
 	ieee80211_iterate_active_interfaces_atomic(
 					mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
@@ -1121,6 +1152,10 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	/* Ignore updates if we are in force mode */
+	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
+		return;
+
 	/*
 	 * Rssi update while not associated - can happen since the statistics
 	 * are handled asynchronously
@@ -1274,6 +1309,10 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	/* Ignore updates if we are in force mode */
+	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
+		return 0;
+
 	if (ant_isolation ==  mvm->last_ant_isol)
 		return 0;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 29ca726..602bbd2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -455,6 +455,43 @@ iwl_dbgfs_bt_tx_prio_write(struct iwl_mvm *mvm, char *buf,
 	return count;
 }
 
+static ssize_t
+iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
+			     size_t count, loff_t *ppos)
+{
+	static const char * const modes_str[BT_FORCE_ANT_MAX] = {
+		[BT_FORCE_ANT_DIS] = "dis",
+		[BT_FORCE_ANT_AUTO] = "auto",
+		[BT_FORCE_ANT_BT] = "bt",
+		[BT_FORCE_ANT_WIFI] = "wifi",
+	};
+	int ret, bt_force_ant_mode;
+
+	for (bt_force_ant_mode = 0;
+	     bt_force_ant_mode < ARRAY_SIZE(modes_str);
+	     bt_force_ant_mode++) {
+		if (!strcmp(buf, modes_str[bt_force_ant_mode]))
+			break;
+	}
+
+	if (bt_force_ant_mode >= ARRAY_SIZE(modes_str))
+		return -EINVAL;
+
+	ret = 0;
+	mutex_lock(&mvm->mutex);
+	if (mvm->bt_force_ant_mode == bt_force_ant_mode)
+		goto out;
+
+	mvm->bt_force_ant_mode = bt_force_ant_mode;
+	IWL_DEBUG_COEX(mvm, "Force mode: %s\n",
+		       modes_str[mvm->bt_force_ant_mode]);
+	ret = iwl_send_bt_init_conf(mvm);
+
+out:
+	mutex_unlock(&mvm->mutex);
+	return ret ?: count;
+}
+
 #define PRINT_STATS_LE32(_str, _val)					\
 			 pos += scnprintf(buf + pos, bufsz - pos,	\
 					  fmt_table, _str,		\
@@ -1101,6 +1138,7 @@ MVM_DEBUGFS_READ_FILE_OPS(drv_rx_stats);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(bt_tx_prio, 10);
+MVM_DEBUGFS_WRITE_FILE_OPS(bt_force_ant, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
@@ -1142,6 +1180,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(bt_tx_prio, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(bt_force_ant, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(prph_reg, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 5fe82c29..98175ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -76,6 +76,9 @@
  * @BT_COEX_2W:
  * @BT_COEX_3W:
  * @BT_COEX_NW:
+ * @BT_COEX_AUTO:
+ * @BT_COEX_BT: Antenna is for BT (manufacuring tests)
+ * @BT_COEX_WIFI: Antenna is for BT (manufacuring tests)
  * @BT_COEX_SYNC2SCO:
  * @BT_COEX_CORUNNING:
  * @BT_COEX_MPLUT:
@@ -89,6 +92,9 @@ enum iwl_bt_coex_flags {
 	BT_COEX_2W			= 0x1 << BT_COEX_MODE_POS,
 	BT_COEX_3W			= 0x2 << BT_COEX_MODE_POS,
 	BT_COEX_NW			= 0x3 << BT_COEX_MODE_POS,
+	BT_COEX_AUTO			= 0x5 << BT_COEX_MODE_POS,
+	BT_COEX_BT			= 0x6 << BT_COEX_MODE_POS,
+	BT_COEX_WIFI			= 0x7 << BT_COEX_MODE_POS,
 	BT_COEX_SYNC2SCO		= BIT(7),
 	BT_COEX_CORUNNING		= BIT(8),
 	BT_COEX_MPLUT			= BIT(9),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fcc6c29..472ef09 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -235,6 +235,15 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_COUNT,
 };
 
+enum iwl_bt_force_ant_mode {
+	BT_FORCE_ANT_DIS = 0,
+	BT_FORCE_ANT_AUTO,
+	BT_FORCE_ANT_BT,
+	BT_FORCE_ANT_WIFI,
+
+	BT_FORCE_ANT_MAX,
+};
+
 /**
 * struct iwl_mvm_vif_bf_data - beacon filtering related data
 * @bf_enabled: indicates if beacon filtering is enabled
@@ -629,6 +638,7 @@ struct iwl_mvm {
 	u32 last_ant_isol;
 	u8 last_corun_lut;
 	u8 bt_tx_prio;
+	enum iwl_bt_force_ant_mode bt_force_ant_mode;
 
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
-- 
1.8.3.2

