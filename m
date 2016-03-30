Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbcC3OGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/43] iwlwifi: mvm: improve RSS configuration
Date: Wed, 30 Mar 2016 17:05:02 +0300
Message-Id: <1459346715-7954-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160741_927330_0BBC01DE)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Improve current RSS configuration:
 * Use netdev_rss_key instead of keeping a local copy.
 * Configure also UDP hashing to have UDP traffic spread across queues.
 * Do not direct RSS traffic to our fallback queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c      | 9 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     | 3 ---
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index abc16f7..362a546 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -65,6 +65,7 @@
  *****************************************************************************/
 #include <linux/vmalloc.h>
 #include <linux/ieee80211.h>
+#include <linux/netdevice.h>
 
 #include "mvm.h"
 #include "fw-dbg.h"
@@ -880,8 +881,10 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
 	struct iwl_rss_config_cmd cmd = {
 		.flags = cpu_to_le32(IWL_RSS_ENABLE),
 		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
+			     IWL_RSS_HASH_TYPE_IPV4_UDP |
 			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
 			     IWL_RSS_HASH_TYPE_IPV6_TCP |
+			     IWL_RSS_HASH_TYPE_IPV6_UDP |
 			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
 	};
 	int ret, i, num_repeats, nbytes = count / 2;
@@ -905,7 +908,7 @@ static ssize_t iwl_dbgfs_indirection_tbl_write(struct iwl_mvm *mvm,
 	memcpy(&cmd.indirection_table[i * nbytes], cmd.indirection_table,
 	       ARRAY_SIZE(cmd.indirection_table) % nbytes);
 
-	memcpy(cmd.secret_key, mvm->secret_key, sizeof(cmd.secret_key));
+	netdev_rss_key_fill(cmd.secret_key, sizeof(cmd.secret_key));
 
 	mutex_lock(&mvm->mutex);
 	ret = iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index f375275..2dc97a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -64,6 +64,7 @@
  *
  *****************************************************************************/
 #include <net/mac80211.h>
+#include <linux/netdevice.h>
 
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
@@ -114,14 +115,18 @@ static int iwl_send_rss_cfg_cmd(struct iwl_mvm *mvm)
 	struct iwl_rss_config_cmd cmd = {
 		.flags = cpu_to_le32(IWL_RSS_ENABLE),
 		.hash_mask = IWL_RSS_HASH_TYPE_IPV4_TCP |
+			     IWL_RSS_HASH_TYPE_IPV4_UDP |
 			     IWL_RSS_HASH_TYPE_IPV4_PAYLOAD |
 			     IWL_RSS_HASH_TYPE_IPV6_TCP |
+			     IWL_RSS_HASH_TYPE_IPV6_UDP |
 			     IWL_RSS_HASH_TYPE_IPV6_PAYLOAD,
 	};
 
+	/* Do not direct RSS traffic to Q 0 which is our fallback queue */
 	for (i = 0; i < ARRAY_SIZE(cmd.indirection_table); i++)
-		cmd.indirection_table[i] = i % mvm->trans->num_rx_queues;
-	memcpy(cmd.secret_key, mvm->secret_key, sizeof(cmd.secret_key));
+		cmd.indirection_table[i] =
+			1 + (i % (mvm->trans->num_rx_queues - 1));
+	netdev_rss_key_fill(cmd.secret_key, sizeof(cmd.secret_key));
 
 	return iwl_mvm_send_cmd_pdu(mvm, RSS_CONFIG_CMD, 0, sizeof(cmd), &cmd);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f0e2597..a9de2ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -699,7 +699,6 @@ struct iwl_mvm {
 	atomic_t pending_frames[IWL_MVM_STATION_COUNT];
 	u32 tfd_drained[IWL_MVM_STATION_COUNT];
 	u8 rx_ba_sessions;
-	u32 secret_key[IWL_RSS_HASH_KEY_CNT];
 
 	/* configured by mac80211 */
 	u32 rts_threshold;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 9fc705c..e36bcad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -725,9 +725,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_tof_init(mvm);
 
-	/* init RSS hash key */
-	get_random_bytes(mvm->secret_key, sizeof(mvm->secret_key));
-
 	return op_mode;
 
  out_unregister:
-- 
2.5.0

