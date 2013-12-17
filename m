Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64069 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3LQUpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:16 -0500
Received: by mail-ee0-f50.google.com with SMTP id c41so3091354eek.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/36] iwlwifi: trans: prevent reprobe on repeated FW errors before restart
Date: Tue, 17 Dec 2013 22:44:25 +0200
Message-Id: <1387313079-28123-22-git-send-email-egrumbach@gmail.com> (sfid-20131217_214523_173205_FDDE275D)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In case a sync command timeouts or Tx is stuck while a FW error
interrupt arrives, we might call iwl_op_mode_nic_error twice before
a restart has been initiated. This will cause a reprobe. Unify calls
to this function at the transport level and only call it on the first
FW error in a given by checking the transport FW error flag.

While at it, remove the privately defined iwl_nic_error from PCIE code
and use the common callback instead.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   11 +++++++++++
 drivers/net/wireless/iwlwifi/pcie/internal.h |    6 ------
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   12 ++++++------
 drivers/net/wireless/iwlwifi/pcie/tx.c       |    6 +++---
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c71519d..fa495ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -70,6 +70,7 @@
 #include "iwl-debug.h"
 #include "iwl-config.h"
 #include "iwl-fw.h"
+#include "iwl-op-mode.h"
 
 /**
  * DOC: Transport layer - what is it ?
@@ -805,6 +806,16 @@ iwl_trans_release_nic_access(struct iwl_trans *trans, unsigned long *flags)
 	__release(nic_access);
 }
 
+static inline void iwl_trans_fw_error(struct iwl_trans *trans)
+{
+	if (WARN_ON_ONCE(!trans->op_mode))
+		return;
+
+	/* prevent double restarts due to the same erroneous FW */
+	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status))
+		iwl_op_mode_nic_error(trans->op_mode);
+}
+
 /*****************************************************
 * driver (transport) register/unregister functions
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 8a2de33..674c75b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -456,10 +456,4 @@ static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
 		CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW);
 }
 
-static inline void iwl_nic_error(struct iwl_trans *trans)
-{
-	set_bit(STATUS_FW_ERROR, &trans->status);
-	iwl_op_mode_nic_error(trans->op_mode);
-}
-
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index bbbb3ca..7aeec5c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -797,14 +797,14 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	iwl_pcie_dump_csr(trans);
 	iwl_dump_fh(trans, NULL);
 
-	/* set the ERROR bit before we wake up the caller */
-	set_bit(STATUS_FW_ERROR, &trans->status);
-	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
-	wake_up(&trans_pcie->wait_command_queue);
-
 	local_bh_disable();
-	iwl_nic_error(trans);
+	/* The STATUS_FW_ERROR bit is set in this function. This must happen
+	 * before we wake up the command caller, to ensure a proper cleanup. */
+	iwl_trans_fw_error(trans);
 	local_bh_enable();
+
+	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
+	wake_up(&trans_pcie->wait_command_queue);
 }
 
 irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 5b63948..8df2478 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -207,7 +207,7 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
 			le32_to_cpu(txq->scratchbufs[i].scratch));
 
-	iwl_nic_error(trans);
+	iwl_trans_fw_error(trans);
 }
 
 /*
@@ -1021,7 +1021,7 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
 				idx, q->write_ptr, q->read_ptr);
-			iwl_nic_error(trans);
+			iwl_trans_fw_error(trans);
 		}
 	}
 
@@ -1555,7 +1555,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 			       get_cmd_string(trans_pcie, cmd->id));
 		ret = -ETIMEDOUT;
 
-		iwl_nic_error(trans);
+		iwl_trans_fw_error(trans);
 
 		goto cancel;
 	}
-- 
1.7.9.5

