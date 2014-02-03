Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40341 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaBCU64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:56 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3874362eek.41
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/62] iwlwifi: mvm: add bcast_filtering debugfs entries
Date: Mon,  3 Feb 2014 22:57:32 +0200
Message-Id: <1391461088-8082-26-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_597545_DFC15B7F)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Allow reading and setting bcast filtering configuration
through debugfs.

By default, mvm->bcast_filters is used for setting
the bcast filtering configuration (these filters
will be configured for each associated station).

For testing purposes, allow overriding this configuration,
and setting the bcast filtering configuration manually.
The following debugfs keys can be used:
* bcast_filtering/override - use debugfs values instead
	of default configuration
* bcast_filtering/filters - set filters (+ attributes)
* bcast_filtering/macs - per-mac bcast filtering
	configuration (policy + attached filters)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |  213 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   43 ++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    8 +
 3 files changed, 250 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 8d3bf25..6ddc188 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -599,6 +599,187 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 	return count;
 }
 
+#define ADD_TEXT(...) pos += scnprintf(buf + pos, bufsz - pos, __VA_ARGS__)
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+static ssize_t iwl_dbgfs_bcast_filters_read(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	struct iwl_bcast_filter_cmd cmd;
+	const struct iwl_fw_bcast_filter *filter;
+	char *buf;
+	int bufsz = 1024;
+	int i, j, pos = 0;
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&mvm->mutex);
+	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd)) {
+		ADD_TEXT("None\n");
+		mutex_unlock(&mvm->mutex);
+		goto out;
+	}
+	mutex_unlock(&mvm->mutex);
+
+	for (i = 0; cmd.filters[i].attrs[0].mask; i++) {
+		filter = &cmd.filters[i];
+
+		ADD_TEXT("Filter [%d]:\n", i);
+		ADD_TEXT("\tDiscard=%d\n", filter->discard);
+		ADD_TEXT("\tFrame Type: %s\n",
+			 filter->frame_type ? "IPv4" : "Generic");
+
+		for (j = 0; j < ARRAY_SIZE(filter->attrs); j++) {
+			const struct iwl_fw_bcast_filter_attr *attr;
+
+			attr = &filter->attrs[j];
+			if (!attr->mask)
+				break;
+
+			ADD_TEXT("\tAttr [%d]: offset=%d (from %s), mask=0x%x, value=0x%x reserved=0x%x\n",
+				 j, attr->offset,
+				 attr->offset_type ? "IP End" :
+						     "Payload Start",
+				 be32_to_cpu(attr->mask),
+				 be32_to_cpu(attr->val),
+				 le16_to_cpu(attr->reserved1));
+		}
+	}
+out:
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_bcast_filters_write(struct iwl_mvm *mvm, char *buf,
+					     size_t count, loff_t *ppos)
+{
+	int pos, next_pos;
+	struct iwl_fw_bcast_filter filter = {};
+	struct iwl_bcast_filter_cmd cmd;
+	u32 filter_id, attr_id, mask, value;
+	int err = 0;
+
+	if (sscanf(buf, "%d %hhi %hhi %n", &filter_id, &filter.discard,
+		   &filter.frame_type, &pos) != 3)
+		return -EINVAL;
+
+	if (filter_id >= ARRAY_SIZE(mvm->dbgfs_bcast_filtering.cmd.filters) ||
+	    filter.frame_type > BCAST_FILTER_FRAME_TYPE_IPV4)
+		return -EINVAL;
+
+	for (attr_id = 0; attr_id < ARRAY_SIZE(filter.attrs);
+	     attr_id++) {
+		struct iwl_fw_bcast_filter_attr *attr =
+				&filter.attrs[attr_id];
+
+		if (pos >= count)
+			break;
+
+		if (sscanf(&buf[pos], "%hhi %hhi %i %i %n",
+			   &attr->offset, &attr->offset_type,
+			   &mask, &value, &next_pos) != 4)
+			return -EINVAL;
+
+		attr->mask = cpu_to_be32(mask);
+		attr->val = cpu_to_be32(value);
+		if (mask)
+			filter.num_attrs++;
+
+		pos += next_pos;
+	}
+
+	mutex_lock(&mvm->mutex);
+	memcpy(&mvm->dbgfs_bcast_filtering.cmd.filters[filter_id],
+	       &filter, sizeof(filter));
+
+	/* send updated bcast filtering configuration */
+	if (mvm->dbgfs_bcast_filtering.override &&
+	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
+		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
+					   sizeof(cmd), &cmd);
+	mutex_unlock(&mvm->mutex);
+
+	return err ?: count;
+}
+
+static ssize_t iwl_dbgfs_bcast_filters_macs_read(struct file *file,
+						 char __user *user_buf,
+						 size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	struct iwl_bcast_filter_cmd cmd;
+	char *buf;
+	int bufsz = 1024;
+	int i, pos = 0;
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&mvm->mutex);
+	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd)) {
+		ADD_TEXT("None\n");
+		mutex_unlock(&mvm->mutex);
+		goto out;
+	}
+	mutex_unlock(&mvm->mutex);
+
+	for (i = 0; i < ARRAY_SIZE(cmd.macs); i++) {
+		const struct iwl_fw_bcast_mac *mac = &cmd.macs[i];
+
+		ADD_TEXT("Mac [%d]: discard=%d attached_filters=0x%x\n",
+			 i, mac->default_discard, mac->attached_filters);
+	}
+out:
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_bcast_filters_macs_write(struct iwl_mvm *mvm,
+						  char *buf, size_t count,
+						  loff_t *ppos)
+{
+	struct iwl_bcast_filter_cmd cmd;
+	struct iwl_fw_bcast_mac mac = {};
+	u32 mac_id, attached_filters;
+	int err = 0;
+
+	if (!mvm->bcast_filters)
+		return -ENOENT;
+
+	if (sscanf(buf, "%d %hhi %i", &mac_id, &mac.default_discard,
+		   &attached_filters) != 3)
+		return -EINVAL;
+
+	if (mac_id >= ARRAY_SIZE(cmd.macs) ||
+	    mac.default_discard > 1 ||
+	    attached_filters >= BIT(ARRAY_SIZE(cmd.filters)))
+		return -EINVAL;
+
+	mac.attached_filters = cpu_to_le16(attached_filters);
+
+	mutex_lock(&mvm->mutex);
+	memcpy(&mvm->dbgfs_bcast_filtering.cmd.macs[mac_id],
+	       &mac, sizeof(mac));
+
+	/* send updated bcast filtering configuration */
+	if (mvm->dbgfs_bcast_filtering.override &&
+	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
+		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
+					   sizeof(cmd), &cmd);
+	mutex_unlock(&mvm->mutex);
+
+	return err ?: count;
+}
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 static ssize_t iwl_dbgfs_d3_sram_write(struct iwl_mvm *mvm, char *buf,
 				       size_t count, loff_t *ppos)
@@ -661,11 +842,13 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 	_MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
-#define MVM_DEBUGFS_ADD_FILE(name, parent, mode) do {			\
-		if (!debugfs_create_file(#name, mode, parent, mvm,	\
+#define MVM_DEBUGFS_ADD_FILE_ALIAS(alias, name, parent, mode) do {	\
+		if (!debugfs_create_file(alias, mode, parent, mvm,	\
 					 &iwl_dbgfs_##name##_ops))	\
 			goto err;					\
 	} while (0)
+#define MVM_DEBUGFS_ADD_FILE(name, parent, mode) \
+	MVM_DEBUGFS_ADD_FILE_ALIAS(#name, name, parent, mode)
 
 /* Device wide debugfs entries */
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
@@ -680,12 +863,18 @@ MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
 #endif
 
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 {
+	struct dentry *bcast_dir __maybe_unused;
 	char buf[100];
 
 	mvm->debugfs_dir = dbgfs_dir;
@@ -704,6 +893,26 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
+
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
+		bcast_dir = debugfs_create_dir("bcast_filtering",
+					       mvm->debugfs_dir);
+		if (!bcast_dir)
+			goto err;
+
+		if (!debugfs_create_bool("override", S_IRUSR | S_IWUSR,
+				bcast_dir,
+				&mvm->dbgfs_bcast_filtering.override))
+			goto err;
+
+		MVM_DEBUGFS_ADD_FILE_ALIAS("filters", bcast_filters,
+					   bcast_dir, S_IWUSR | S_IRUSR);
+		MVM_DEBUGFS_ADD_FILE_ALIAS("macs", bcast_filters_macs,
+					   bcast_dir, S_IWUSR | S_IRUSR);
+	}
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 	MVM_DEBUGFS_ADD_FILE(d3_sram, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(d3_test, mvm->debugfs_dir, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b3f6c2b..67c0dfc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1045,32 +1045,51 @@ static void iwl_mvm_bcast_filter_iterator(void *_data, u8 *mac,
 	}
 }
 
-static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif)
+bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
+				    struct iwl_bcast_filter_cmd *cmd)
 {
-	/* initialize cmd to pass broadcasts on all vifs */
-	struct iwl_bcast_filter_cmd cmd = {
-		.disable = 0,
-		.max_bcast_filters = ARRAY_SIZE(cmd.filters),
-		.max_macs = ARRAY_SIZE(cmd.macs),
-	};
 	struct iwl_bcast_iter_data iter_data = {
 		.mvm = mvm,
-		.cmd = &cmd,
+		.cmd = cmd,
 	};
 
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING))
-		return 0;
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->max_bcast_filters = ARRAY_SIZE(cmd->filters);
+	cmd->max_macs = ARRAY_SIZE(cmd->macs);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	/* use debugfs filters/macs if override is configured */
+	if (mvm->dbgfs_bcast_filtering.override) {
+		memcpy(cmd->filters, &mvm->dbgfs_bcast_filtering.cmd.filters,
+		       sizeof(cmd->filters));
+		memcpy(cmd->macs, &mvm->dbgfs_bcast_filtering.cmd.macs,
+		       sizeof(cmd->macs));
+		return true;
+	}
+#endif
 
 	/* if no filters are configured, do nothing */
 	if (!mvm->bcast_filters)
-		return 0;
+		return false;
 
 	/* configure and attach these filters for each associated sta vif */
 	ieee80211_iterate_active_interfaces(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_bcast_filter_iterator, &iter_data);
 
+	return true;
+}
+static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif)
+{
+	struct iwl_bcast_filter_cmd cmd;
+
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING))
+		return 0;
+
+	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
+		return 0;
+
 	return iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
 				    sizeof(cmd), &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2da17d1..43f13ab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -500,6 +500,12 @@ struct iwl_mvm {
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	/* broadcast filters to configure for each associated station */
 	const struct iwl_fw_bcast_filter *bcast_filters;
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	struct {
+		u32 override; /* u32 for debugfs_create_bool */
+		struct iwl_bcast_filter_cmd cmd;
+	} dbgfs_bcast_filtering;
+#endif
 #endif
 
 	/* Internal station */
@@ -687,6 +693,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm);
 int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm);
 
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm);
+bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
+				    struct iwl_bcast_filter_cmd *cmd);
 
 /*
  * FW notifications / CMD responses handlers
-- 
1.7.9.5

