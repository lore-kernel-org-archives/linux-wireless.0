Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbbLUUvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:17 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/45] iwlwifi: uninline iwl_trans_send_cmd
Date: Mon, 21 Dec 2015 22:50:15 +0200
Message-Id: <1450731046-2796-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215128_983921_9150CC38)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function got too big to be inlined. Uninline it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 33 +++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 34 ++------------------------
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index ccd317b..c3fafbc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -61,6 +61,7 @@
  *
  *****************************************************************************/
 #include <linux/kernel.h>
+#include "iwl-drv.h"
 #include "iwl-trans.h"
 
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
@@ -112,3 +113,35 @@ void iwl_trans_free(struct iwl_trans *trans)
 	kmem_cache_destroy(trans->dev_cmd_pool);
 	kfree(trans);
 }
+
+int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
+{
+	int ret;
+
+	if (unlikely(!(cmd->flags & CMD_SEND_IN_RFKILL) &&
+		     test_bit(STATUS_RFKILL, &trans->status)))
+		return -ERFKILL;
+
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return -EIO;
+
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE)) {
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return -EIO;
+	}
+
+	if (WARN_ON((cmd->flags & CMD_WANT_ASYNC_CALLBACK) &&
+		    !(cmd->flags & CMD_ASYNC)))
+		return -EINVAL;
+
+	if (!(cmd->flags & CMD_ASYNC))
+		lock_map_acquire_read(&trans->sync_cmd_lockdep_map);
+
+	ret = trans->ops->send_cmd(trans, cmd);
+
+	if (!(cmd->flags & CMD_ASYNC))
+		lock_map_release(&trans->sync_cmd_lockdep_map);
+
+	return ret;
+}
+IWL_EXPORT_SYMBOL(iwl_trans_send_cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 77ae7fa..b825d94 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -889,38 +889,6 @@ iwl_trans_dump_data(struct iwl_trans *trans,
 	return trans->ops->dump_data(trans, trigger);
 }
 
-static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
-				     struct iwl_host_cmd *cmd)
-{
-	int ret;
-
-	if (unlikely(!(cmd->flags & CMD_SEND_IN_RFKILL) &&
-		     test_bit(STATUS_RFKILL, &trans->status)))
-		return -ERFKILL;
-
-	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
-		return -EIO;
-
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE)) {
-		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
-		return -EIO;
-	}
-
-	if (WARN_ON((cmd->flags & CMD_WANT_ASYNC_CALLBACK) &&
-		    !(cmd->flags & CMD_ASYNC)))
-		return -EINVAL;
-
-	if (!(cmd->flags & CMD_ASYNC))
-		lock_map_acquire_read(&trans->sync_cmd_lockdep_map);
-
-	ret = trans->ops->send_cmd(trans, cmd);
-
-	if (!(cmd->flags & CMD_ASYNC))
-		lock_map_release(&trans->sync_cmd_lockdep_map);
-
-	return ret;
-}
-
 static inline struct iwl_device_cmd *
 iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 {
@@ -933,6 +901,8 @@ iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 			(dev_cmd_ptr + trans->dev_cmd_headroom);
 }
 
+int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
+
 static inline void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
 					 struct iwl_device_cmd *dev_cmd)
 {
-- 
2.5.0

