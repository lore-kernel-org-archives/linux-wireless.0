Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaL3OTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/33] iwlwifi: mvm: add debugfs to trigger fw debug logs collection
Date: Tue, 30 Dec 2014 16:18:41 +0200
Message-Id: <1419949148-24046-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154349_474272_B7DC7BEE)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to collect the logs even if the firmware hasn't
crashed. Of course, crashing the firmware is an option, but
this is easier and nicer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h    |  4 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 54 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c      | 23 +++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  3 ++
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index ea3b970..83ab423 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -366,11 +366,15 @@ enum secure_load_status_reg {
 #define RXF_FIFO_RD_FENCE_ADDR		(0xa00c0c)
 
 /* FW monitor */
+#define MON_BUFF_SAMPLE_CTL		(0xa03c00)
 #define MON_BUFF_BASE_ADDR		(0xa03c3c)
 #define MON_BUFF_END_ADDR		(0xa03c40)
 #define MON_BUFF_WRPTR			(0xa03c44)
 #define MON_BUFF_CYCLE_CNT		(0xa03c48)
 
+#define DBGC_IN_SAMPLE			(0xa03c00)
+#define DBGC_OUT_CTRL			(0xa03c0c)
+
 /* FW chicken bits */
 #define LMPM_CHICK			0xA01FF8
 enum {
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 0507647..a1b276c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -945,6 +945,56 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	enum iwl_fw_dbg_conf conf;
+	char buf[8];
+	const size_t bufsz = sizeof(buf);
+	int pos = 0;
+
+	mutex_lock(&mvm->mutex);
+	conf = mvm->fw_dbg_conf;
+	mutex_unlock(&mvm->mutex);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%d\n", conf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
+					   char *buf, size_t count,
+					   loff_t *ppos)
+{
+	int ret, conf_id;
+
+	ret = kstrtoint(buf, 0, &conf_id);
+	if (ret)
+		return ret;
+
+	if (WARN_ON(conf_id >= FW_DBG_MAX))
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_start_fw_dbg_conf(mvm, conf_id);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
+static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
+					      char *buf, size_t count,
+					      loff_t *ppos)
+{
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_fw_dbg_collect(mvm);
+	mutex_unlock(&mvm->mutex);
+
+	return count;
+}
+
 #define ADD_TEXT(...) pos += scnprintf(buf + pos, bufsz - pos, __VA_ARGS__)
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 static ssize_t iwl_dbgfs_bcast_filters_read(struct file *file,
@@ -1459,6 +1509,8 @@ MVM_DEBUGFS_WRITE_FILE_OPS(bt_tx_prio, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(bt_force_ant, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 8);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1500,6 +1552,8 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 			     S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(prph_reg, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 60d0c9f..534ee31 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -70,6 +70,7 @@
 #include "iwl-debug.h"
 #include "iwl-csr.h" /* for iwl_mvm_rx_card_state_notif */
 #include "iwl-io.h" /* for iwl_mvm_rx_card_state_notif */
+#include "iwl-prph.h"
 #include "iwl-eeprom-parse.h"
 
 #include "mvm.h"
@@ -399,8 +400,26 @@ out:
 	return ret;
 }
 
-static int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm,
-				     enum iwl_fw_dbg_conf conf_id)
+void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
+{
+	lockdep_assert_held(&mvm->mutex);
+
+	/* stop recording */
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
+		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
+	} else {
+		iwl_write_prph(mvm->trans, DBGC_IN_SAMPLE, 0);
+		iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, 0);
+	}
+
+	iwl_mvm_fw_error_dump(mvm);
+
+	/* start recording again */
+	WARN_ON_ONCE(mvm->fw->dbg_dest_tlv &&
+		     iwl_mvm_start_fw_dbg_conf(mvm, mvm->fw_dbg_conf));
+}
+
+int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, enum iwl_fw_dbg_conf conf_id)
 {
 	u8 *ptr;
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f3cb089..ff1a409 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1371,4 +1371,7 @@ struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 
+int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, enum iwl_fw_dbg_conf id);
+void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm);
+
 #endif /* __IWL_MVM_H__ */
-- 
1.9.1

