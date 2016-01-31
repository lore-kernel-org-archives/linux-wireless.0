Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbcAaLHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:07:00 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/31] iwlwifi: mvm: support rss queues configuration command
Date: Sun, 31 Jan 2016 13:06:23 +0200
Message-Id: <1454238386-27032-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123655_272376_79E898E6)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

9000 series supports multi-queue rx. The hardware needs
to be configured with the hash functions to perform and
indirection table that maps hash results to the relevant
CPUs\queues.
Support this configuration.
Add debugfs hook to configure the indirection table in
order to enable performance analysis. The configuration
is stateless, receives a partial or full pattern and sends
the command to the firmware.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 44 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 33 +++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 29 ++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  4 ++
 6 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 5c0f939..005cc09 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -943,6 +944,47 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
+					       char *buf, size_t count,
+					       loff_t *ppos)
+{
+	struct iwl_rss_config_cmd cmd = {
+		.flags = cpu_to_le32(IWL_RSS_ENABLE),
+		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
+			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
+			     IWL_RSS_HASH_TYPE_IPV6_TCP |
+			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
+	};
+	int ret, i, num_repeats, nbytes = count / 2;
+
+	ret = hex2bin(cmd.indirection_table, buf, nbytes);
+	if (ret)
+		return ret;
+
+	/*
+	 * The input is the redirection table, partial or full.
+	 * Repeat the pattern if needed.
+	 * For example, input of 01020F will be repeated 42 times,
+	 * indirecting RSS hash results to queues 1, 2, 15 (skipping
+	 * queues 3 - 14).
+	 */
+	num_repeats = ARRAY_SIZE(cmd.indirection_table) / nbytes;
+	for (i = 1; i < num_repeats; i++)
+		memcpy(&cmd.indirection_table[i * nbytes],
+		       cmd.indirection_table, nbytes);
+	/* handle cut in the middle pattern for the last places */
+	memcpy(&cmd.indirection_table[i * nbytes], cmd.indirection_table,
+	       ARRAY_SIZE(cmd.indirection_table) % nbytes);
+
+	memcpy(cmd.secret_key, mvm->secret_key, ARRAY_SIZE(cmd.secret_key));
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
+	mutex_unlock(&mvm->mutex);
+
+	return ret ?: count;
+}
+
 static ssize_t iwl_dbgfs_fw_dbg_conf_read(struct file *file,
 					  char __user *user_buf,
 					  size_t count, loff_t *ppos)
@@ -1455,6 +1497,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 64);
 MVM_DEBUGFS_WRITE_FILE_OPS(cont_recording, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl, 16);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1499,6 +1542,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, S_IWUSR);
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
 				 S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index ab467cb..b45c61e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -362,4 +362,33 @@ struct iwl_frame_release {
 	__le16 nssn;
 };
 
+enum iwl_rss_hash_func_en {
+	IWL_RSS_HASH_TYPE_IPV4_TCP,
+	IWL_RSS_HASH_TYPE_IPV4_UDP,
+	IWL_RSS_HASH_TYPE_IPV4_PAYLOAD,
+	IWL_RSS_HASH_TYPE_IPV6_TCP,
+	IWL_RSS_HASH_TYPE_IPV6_UDP,
+	IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
+};
+
+#define IWL_RSS_HASH_KEY_CNT 10
+#define IWL_RSS_INDIRECTION_TABLE_SIZE 128
+#define IWL_RSS_ENABLE 1
+
+/**
+ * struct iwl_rss_config_cmd - RSS (Receive Side Scaling) configuration
+ *
+ * @flags: 1 - enable, 0 - disable
+ * @hash_mask: Type of RSS to use. Values are from %iwl_rss_hash_func_en
+ * @secret_key: 320 bit input of random key configuration from driver
+ * @indirection_table: indirection table
+ */
+struct iwl_rss_config_cmd {
+	__le32 flags;
+	u8 hash_mask;
+	u8 reserved[3];
+	__le32 secret_key[IWL_RSS_HASH_KEY_CNT];
+	u8 indirection_table[IWL_RSS_INDIRECTION_TABLE_SIZE];
+} __packed; /* RSS_CONFIG_CMD_API_S_VER_1 */
+
 #endif /* __fw_api_rx_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index b6b5727..f332497 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -213,6 +213,8 @@ enum {
 
 	MFUART_LOAD_NOTIFICATION = 0xb1,
 
+	RSS_CONFIG_CMD = 0xb3,
+
 	REPLY_RX_PHY_CMD = 0xc0,
 	REPLY_RX_MPDU_CMD = 0xc1,
 	FRAME_RELEASE = 0xc3,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4ed5180..070e2af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -107,6 +108,24 @@ static int iwl_send_tx_ant_cfg(struct iwl_mvm *mvm, u8 valid_tx_ant)
 				    sizeof(tx_ant_cmd), &tx_ant_cmd);
 }
 
+static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
+{
+	int i;
+	struct iwl_rss_config_cmd cmd = {
+		.flags = cpu_to_le32(IWL_RSS_ENABLE),
+		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
+			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
+			     IWL_RSS_HASH_TYPE_IPV6_TCP |
+			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(cmd.indirection_table); i++)
+		cmd.indirection_table[i] = i % mvm->trans->num_rx_queues;
+	memcpy(cmd.secret_key, mvm->secret_key, ARRAY_SIZE(cmd.secret_key));
+
+	return iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
+}
+
 static void iwl_free_fw_paging(struct iwl_mvm *mvm)
 {
 	int i;
@@ -894,6 +913,16 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
+	/* Init RSS configuration */
+	if (iwl_mvm_has_new_rx_api(mvm)) {
+		ret = iwl_send_rss_cfg_cmd(mvm);
+		if (ret) {
+			IWL_ERR(mvm, "Failed to configure RSS queues: %d\n",
+				ret);
+			goto error;
+		}
+	}
+
 	/* init the fw <-> mac80211 STA mapping */
 	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
 		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f87aa97..747f7eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -647,6 +647,7 @@ struct iwl_mvm {
 	atomic_t pending_frames[IWL_MVM_STATION_COUNT];
 	u32 tfd_drained[IWL_MVM_STATION_COUNT];
 	u8 rx_ba_sessions;
+	u32 secret_key[IWL_RSS_HASH_KEY_CNT];
 
 	/* configured by mac80211 */
 	u32 rts_threshold;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3c869ad..325ff8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -347,6 +347,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 	HCMD_NAME(MAC_PM_POWER_TABLE),
 	HCMD_NAME(TDLS_CHANNEL_SWITCH_NOTIFICATION),
 	HCMD_NAME(MFUART_LOAD_NOTIFICATION),
+	HCMD_NAME(RSS_CONFIG_CMD),
 	HCMD_NAME(SCAN_ITERATION_COMPLETE_UMAC),
 	HCMD_NAME(REPLY_RX_PHY_CMD),
 	HCMD_NAME(REPLY_RX_MPDU_CMD),
@@ -651,6 +652,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_tof_init(mvm);
 
+	/* init RSS hash key */
+	get_random_bytes(mvm->secret_key, ARRAY_SIZE(mvm->secret_key));
+
 	return op_mode;
 
  out_unregister:
-- 
2.5.0

