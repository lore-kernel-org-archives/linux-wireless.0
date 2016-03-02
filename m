Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34250 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbcCBH4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:56:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/43] iwlwifi: mvm: fix RSS key sizing
Date: Wed,  2 Mar 2016 09:56:06 +0200
Message-Id: <1456905404-14435-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085657_538719_EC2C8B63)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The initialization and copying of the RSS secret key
should not use ARRAY_SIZE as we need to initialize a
dword array, and not a byte array.
Fix also the hook maximum write size to allow writing
a longer table - up to full indirection table size.

Fixes: 43413a975d06("iwlwifi: mvm: support rss queues configuration command")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index c529e53..54d0d7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -976,7 +976,7 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
 	memcpy(&cmd.indirection_table[i * nbytes], cmd.indirection_table,
 	       ARRAY_SIZE(cmd.indirection_table) % nbytes);
 
-	memcpy(cmd.secret_key, mvm->secret_key, ARRAY_SIZE(cmd.secret_key));
+	memcpy(cmd.secret_key, mvm->secret_key, sizeof(cmd.secret_key));
 
 	mutex_lock(&mvm->mutex);
 	ret = iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
@@ -1497,7 +1497,8 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 64);
 MVM_DEBUGFS_WRITE_FILE_OPS(cont_recording, 8);
-MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl, 16);
+MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl,
+			   (IWL_RSS_INDIRECTION_TABLE_SIZE * 2));
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 3e596e4..05475a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -121,7 +121,7 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 
 	for (i = 0; i < ARRAY_SIZE(cmd.indirection_table); i++)
 		cmd.indirection_table[i] = i % mvm->trans->num_rx_queues;
-	memcpy(cmd.secret_key, mvm->secret_key, ARRAY_SIZE(cmd.secret_key));
+	memcpy(cmd.secret_key, mvm->secret_key, sizeof(cmd.secret_key));
 
 	return iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3661a9d..c5b6e86 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -661,7 +661,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_mvm_tof_init(mvm);
 
 	/* init RSS hash key */
-	get_random_bytes(mvm->secret_key, ARRAY_SIZE(mvm->secret_key));
+	get_random_bytes(mvm->secret_key, sizeof(mvm->secret_key));
 
 	return op_mode;
 
-- 
2.5.0

