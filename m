Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbGTTnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 09/10] iwlwifi: mvm: allow to configure the maximal size of an A-MSDU
Date: Mon, 20 Jul 2015 22:43:03 +0300
Message-Id: <1437421384-19884-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214337_906548_D79AE86C)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since an A-MSDU has one single CRC for the whole
aggregation, it is tricky to know what size to allow.
For now, add a debugfs hook to be able to tune the
algorightm.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c      |  7 ++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index ffb4b5c..621792c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -981,6 +981,23 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_max_amsdu_sz_write(struct iwl_mvm *mvm,
+					    char *buf, size_t count,
+					    loff_t *ppos)
+{
+	unsigned int max_amsdu_sz;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &max_amsdu_sz);
+
+	if (max_amsdu_sz > 11454 || max_amsdu_sz < IEEE80211_MAX_DATA_LEN)
+		return -EINVAL;
+
+	mvm->max_amsdu_sz = max_amsdu_sz;
+
+	return count;
+}
+
 #define ADD_TEXT(...) pos += scnprintf(buf + pos, bufsz - pos, __VA_ARGS__)
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 static ssize_t iwl_dbgfs_bcast_filters_read(struct file *file,
@@ -1499,6 +1516,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(max_amsdu_sz, 10);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1542,6 +1560,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(max_amsdu_sz, mvm->debugfs_dir, S_IWUSR);
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c8b9d88..82a0c50 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -663,6 +663,7 @@ struct iwl_mvm {
 	u32 dbgfs_prph_reg_addr;
 	bool disable_power_off;
 	bool disable_power_off_d3;
+	unsigned int max_amsdu_sz;
 
 	u32 scan_iter_notif_enabled; /* must be u32 for debugfs_create_bool */
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 3f89d71..cddc296 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -903,7 +903,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff* skb_gso,
 		if (s.gso_payload_len - s.gso_payload_pos <= s.mss)
 			s.amsdu = false;
 
-		max_amsdu_sz = sta->max_amsdu_sz;
+		max_amsdu_sz = ACCESS_ONCE(mvm->max_amsdu_sz);
+		if (max_amsdu_sz)
+			max_amsdu_sz = min_t(unsigned int, sta->max_amsdu_sz,
+					     max_amsdu_sz);
+		else
+			max_amsdu_sz = sta->max_amsdu_sz;
 
 		if (!max_amsdu_sz || !s.amsdu) {
 			int l;
-- 
2.1.4

