Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44539 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaBCU73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:29 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so4015180eaj.29
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 44/62] iwlwifi: mvm: add d0i3_refs debugfs file
Date: Mon,  3 Feb 2014 22:57:50 +0200
Message-Id: <1391461088-8082-44-git-send-email-egrumbach@gmail.com> (sfid-20140203_223007_863250_34D2ED57)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add d0i3_refs debugfs file that prints the currently taken
mvm D0i3 refs.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 6ddc188..2253d5b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -838,6 +838,34 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 }
 #endif
 
+#define PRINT_MVM_REF(ref) do {					\
+	if (test_bit(ref, mvm->ref_bitmap))			\
+		pos += scnprintf(buf + pos, bufsz - pos,	\
+				 "\t(0x%lx) %s\n",		\
+				 BIT(ref), #ref);		\
+} while (0)
+
+static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	int pos = 0;
+	char buf[256];
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "taken mvm refs: 0x%lx\n",
+			 mvm->ref_bitmap[0]);
+
+	PRINT_MVM_REF(IWL_MVM_REF_UCODE_DOWN);
+	PRINT_MVM_REF(IWL_MVM_REF_SCAN);
+	PRINT_MVM_REF(IWL_MVM_REF_ROC);
+	PRINT_MVM_REF(IWL_MVM_REF_P2P_CLIENT);
+	PRINT_MVM_REF(IWL_MVM_REF_AP_IBSS);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 #define MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
@@ -862,6 +890,7 @@ MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
+MVM_DEBUGFS_READ_FILE_OPS(d0i3_refs);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -893,6 +922,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
-- 
1.7.9.5

