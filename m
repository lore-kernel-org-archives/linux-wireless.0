Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39508 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754735AbeDMMn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:44 +0300
Message-Id: <20180413124256.21769-14-luca@coelho.fi> (sfid-20180413_144401_043730_93BF1B4B)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: add TX queue size parameter to TX queue allocation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

As preparation for dynamic queue sizing, add a parameter
of the TX queue size to the dynamic queue allocation op
mode API.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    | 1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
index dfa111bb411e..1f45b2ce5295 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
@@ -131,6 +131,7 @@ enum iwl_tx_queue_cfg_actions {
 	TX_QUEUE_CFG_TFD_SHORT_FORMAT		= BIT(1),
 };
 
+#define IWL_DEFAULT_QUEUE_SIZE 256
 /**
  * struct iwl_tx_queue_cfg_cmd - txq hw scheduler config command
  * @sta_id: station id
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index c25ed1a0bbb0..a92832711683 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -554,7 +554,7 @@ struct iwl_trans_ops {
 	/* 22000 functions */
 	int (*txq_alloc)(struct iwl_trans *trans,
 			 struct iwl_tx_queue_cfg_cmd *cmd,
-			 int cmd_id,
+			 int cmd_id, int size,
 			 unsigned int queue_wdg_timeout);
 	void (*txq_free)(struct iwl_trans *trans, int queue);
 
@@ -952,8 +952,8 @@ iwl_trans_txq_free(struct iwl_trans *trans, int queue)
 static inline int
 iwl_trans_txq_alloc(struct iwl_trans *trans,
 		    struct iwl_tx_queue_cfg_cmd *cmd,
-		    int cmd_id,
-		    unsigned int queue_wdg_timeout)
+		    int cmd_id, int size,
+		    unsigned int wdg_timeout)
 {
 	might_sleep();
 
@@ -965,7 +965,7 @@ iwl_trans_txq_alloc(struct iwl_trans *trans,
 		return -EIO;
 	}
 
-	return trans->ops->txq_alloc(trans, cmd, cmd_id, queue_wdg_timeout);
+	return trans->ops->txq_alloc(trans, cmd, cmd_id, size, wdg_timeout);
 }
 
 static inline void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 20bd403f5af9..f21257dc298b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -733,7 +733,8 @@ int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
 	if (cmd.tid == IWL_MAX_TID_COUNT)
 		cmd.tid = IWL_MGMT_TID;
 	queue = iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
-				    SCD_QUEUE_CFG, timeout);
+				    SCD_QUEUE_CFG, IWL_DEFAULT_QUEUE_SIZE,
+				    timeout);
 
 	if (queue < 0) {
 		IWL_DEBUG_TX_QUEUES(mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index a8833028e1cf..cda66340d357 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -819,7 +819,7 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr);
 int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 				 struct iwl_tx_queue_cfg_cmd *cmd,
-				 int cmd_id,
+				 int cmd_id, int size,
 				 unsigned int timeout);
 void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue);
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 7bdb9c9e04b1..b3d151ec8fe4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1041,7 +1041,7 @@ static void iwl_pcie_gen2_txq_free(struct iwl_trans *trans, int txq_id)
 
 int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 				 struct iwl_tx_queue_cfg_cmd *cmd,
-				 int cmd_id,
+				 int cmd_id, int size,
 				 unsigned int timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-- 
2.16.3
