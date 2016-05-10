Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40788 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752482AbcEJUaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:13 +0300
Message-Id: <1462910797-20303-17-git-send-email-luca@coelho.fi> (sfid-20160510_223101_630856_4517E204)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 17/41] iwlwifi: wake from runtime suspend before sending sync commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If a host command was queued while in runtime suspend, it would go out
before the D0I3_END_CMD was sent.  Sometimes it works, but sometimes
it fails, and it is obviously the wrong thing to do.

To fix this, have the opmode take a reference before sending a SYNC
command and make the pcie trans wait for the runtime state to become
active before actually queueing the command.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c   |  8 +++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c     | 11 +++++++++++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 362a546..513a8540 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1309,6 +1309,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_PROTECT_CSA);
 	PRINT_MVM_REF(IWL_MVM_REF_FW_DBG_COLLECT);
 	PRINT_MVM_REF(IWL_MVM_REF_INIT_UCODE);
+	PRINT_MVM_REF(IWL_MVM_REF_SENDING_CMD);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 72c0467..23d7539 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -301,6 +301,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_PROTECT_CSA,
 	IWL_MVM_REF_FW_DBG_COLLECT,
 	IWL_MVM_REF_INIT_UCODE,
+	IWL_MVM_REF_SENDING_CMD,
 
 	/* update debugfs.c when changing this */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index f0ffd62..eb41d3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -90,11 +90,17 @@ int iwl_mvm_send_cmd(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd)
 	 * the mutex, this ensures we don't try to send two
 	 * (or more) synchronous commands at a time.
 	 */
-	if (!(cmd->flags & CMD_ASYNC))
+	if (!(cmd->flags & CMD_ASYNC)) {
 		lockdep_assert_held(&mvm->mutex);
+		if (!(cmd->flags & CMD_SEND_IN_IDLE))
+			iwl_mvm_ref(mvm, IWL_MVM_REF_SENDING_CMD);
+	}
 
 	ret = iwl_trans_send_cmd(mvm->trans, cmd);
 
+	if (!(cmd->flags & (CMD_ASYNC | CMD_SEND_IN_IDLE)))
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SENDING_CMD);
+
 	/*
 	 * If the caller wants the SKB, then don't hide any problems, the
 	 * caller might access the response buffer which will be NULL if
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index e2eb130d..d6beac9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -32,6 +32,7 @@
 #include <linux/ieee80211.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/pm_runtime.h>
 #include <net/ip6_checksum.h>
 #include <net/tso.h>
 
@@ -1799,6 +1800,16 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	IWL_DEBUG_INFO(trans, "Setting HCMD_ACTIVE for command %s\n",
 		       iwl_get_cmd_string(trans, cmd->id));
 
+	if (pm_runtime_suspended(&trans_pcie->pci_dev->dev)) {
+		ret = wait_event_timeout(trans_pcie->d0i3_waitq,
+				 pm_runtime_active(&trans_pcie->pci_dev->dev),
+				 msecs_to_jiffies(IWL_TRANS_IDLE_TIMEOUT));
+		if (!ret) {
+			IWL_ERR(trans, "Timeout exiting D0i3 before hcmd\n");
+			return -ETIMEDOUT;
+		}
+	}
+
 	cmd_idx = iwl_pcie_enqueue_hcmd(trans, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
-- 
2.8.1

