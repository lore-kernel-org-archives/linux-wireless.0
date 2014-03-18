Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56757 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbaCROqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:38 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so5467854eek.13
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/35] iwlwifi: mvm: BT Coex - add debugfs hook to set BT Tx priority
Date: Tue, 18 Mar 2014 16:45:32 +0200
Message-Id: <1395153939-23897-28-git-send-email-egrumbach@gmail.com> (sfid-20140318_155649_854066_14FB1F5D)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In order to debug the firmware, we need to be able to set
the BT priority of WiFi packets. This priority is set based
on the type of the packet (control frames, EAPOL etc...).
For debugging purposes, allow to override this priority by
a debugfs controlled value.
Enable this feature that needs this priority to be able to
test it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  8 ++++++++
 drivers/net/wireless/iwlwifi/mvm/constants.h   |  1 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     | 18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  1 +
 5 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 018d75c..c9b320a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -616,6 +616,11 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
 	}
 
+	if (IWL_MVM_BT_COEX_MPLUT) {
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_MPLUT);
+		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_MULTI_PRIO_LUT);
+	}
+
 	if (mvm->cfg->bt_shared_single_ant)
 		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
 		       sizeof(iwl_single_shared_ant));
@@ -1215,6 +1220,9 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 	if (info->band != IEEE80211_BAND_2GHZ)
 		return 0;
 
+	if (unlikely(mvm->bt_tx_prio))
+		return mvm->bt_tx_prio - 1;
+
 	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
 	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
 	     is_multicast_ether_addr(hdr->addr1) ||
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 37d5f35..921b177 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -83,5 +83,6 @@
 #define IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR	24 /* TU */
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		1
+#define IWL_MVM_BT_COEX_MPLUT			1
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e33ffd1..326b452 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -440,6 +440,22 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t
+iwl_dbgfs_bt_tx_prio_write(struct iwl_mvm *mvm, char *buf,
+			   size_t count, loff_t *ppos)
+{
+	u32 bt_tx_prio;
+
+	if (sscanf(buf, "%u", &bt_tx_prio) != 1)
+		return -EINVAL;
+	if (bt_tx_prio > 4)
+		return -EINVAL;
+
+	mvm->bt_tx_prio = bt_tx_prio;
+
+	return count;
+}
+
 #define PRINT_STATS_LE32(_str, _val)					\
 			 pos += scnprintf(buf + pos, bufsz - pos,	\
 					  fmt_table, _str,		\
@@ -1084,6 +1100,7 @@ MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
 MVM_DEBUGFS_READ_FILE_OPS(drv_rx_stats);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
+MVM_DEBUGFS_WRITE_FILE_OPS(bt_tx_prio, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
@@ -1125,6 +1142,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(drv_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(bt_tx_prio, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(prph_reg, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 32156d7..21877e5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -78,6 +78,7 @@
  * @BT_COEX_NW:
  * @BT_COEX_SYNC2SCO:
  * @BT_COEX_CORUNNING:
+ * @BT_COEX_MPLUT:
  *
  * The COEX_MODE must be set for each command. Even if it is not changed.
  */
@@ -90,6 +91,7 @@ enum iwl_bt_coex_flags {
 	BT_COEX_NW			= 0x3 << BT_COEX_MODE_POS,
 	BT_COEX_SYNC2SCO		= BIT(7),
 	BT_COEX_CORUNNING		= BIT(8),
+	BT_COEX_MPLUT			= BIT(9),
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index cb6dbb1..d581182 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -611,6 +611,7 @@ struct iwl_mvm {
 	struct iwl_bt_coex_ci_cmd last_bt_ci_cmd;
 	u32 last_ant_isol;
 	u8 last_corun_lut;
+	u8 bt_tx_prio;
 
 	/* Thermal Throttling and CTkill */
 	struct iwl_mvm_tt_mgmt thermal_throttle;
-- 
1.8.3.2

