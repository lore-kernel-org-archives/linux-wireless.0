Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:33169 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaBCU7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:35 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so4001281eaj.11
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:35 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 47/62] iwlwifi: mvm: add debugfs hook to take an mvm ref
Date: Mon,  3 Feb 2014 22:57:53 +0200
Message-Id: <1391461088-8082-47-git-send-email-egrumbach@gmail.com> (sfid-20140203_223007_137379_92EA2852)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Support taking an mvm ref (and preventing D0i3) by
writing '1' into the d0i3_refs debugfs file.

The reference can be unref by writing 0 to the same
file.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   33 ++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |    1 +
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 2253d5b..c116765 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -862,10 +862,39 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_ROC);
 	PRINT_MVM_REF(IWL_MVM_REF_P2P_CLIENT);
 	PRINT_MVM_REF(IWL_MVM_REF_AP_IBSS);
+	PRINT_MVM_REF(IWL_MVM_REF_USER);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
+					 size_t count, loff_t *ppos)
+{
+	unsigned long value;
+	int ret;
+	bool taken;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mvm->mutex);
+
+	taken = test_bit(IWL_MVM_REF_USER, mvm->ref_bitmap);
+	if (value == 1 && !taken)
+		iwl_mvm_ref(mvm, IWL_MVM_REF_USER);
+	else if (value == 0 && taken)
+		iwl_mvm_unref(mvm, IWL_MVM_REF_USER);
+	else
+		ret = -EINVAL;
+
+	mutex_unlock(&mvm->mutex);
+
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -890,7 +919,7 @@ MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
-MVM_DEBUGFS_READ_FILE_OPS(d0i3_refs);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -922,7 +951,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f396607..1f53ade 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -245,6 +245,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_ROC,
 	IWL_MVM_REF_P2P_CLIENT,
 	IWL_MVM_REF_AP_IBSS,
+	IWL_MVM_REF_USER,
 
 	IWL_MVM_REF_COUNT,
 };
-- 
1.7.9.5

