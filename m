Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbcC3OFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/43] iwlwifi: pcie: clear trans reference on queue stop
Date: Wed, 30 Mar 2016 17:04:33 +0300
Message-Id: <1459346715-7954-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160542_887866_B4B66A2D)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently when stop flow is performed, there might be transport TX RTPM
references that are not freed in case we unmap a queue that still has
packets not reclaimed. Fix that.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 59 +++++++++++++++++-----------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 16ad820..cc6fa00 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -596,6 +596,28 @@ static void iwl_pcie_free_tso_page(struct sk_buff *skb)
 	}
 }
 
+static void iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	lockdep_assert_held(&trans_pcie->reg_lock);
+
+	if (trans_pcie->ref_cmd_in_flight) {
+		trans_pcie->ref_cmd_in_flight = false;
+		IWL_DEBUG_RPM(trans, "clear ref_cmd_in_flight - unref\n");
+		iwl_trans_pcie_unref(trans);
+	}
+
+	if (!trans->cfg->base_params->apmg_wake_up_wa)
+		return;
+	if (WARN_ON(!trans_pcie->cmd_hold_nic_awake))
+		return;
+
+	trans_pcie->cmd_hold_nic_awake = false;
+	__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+
 /*
  * iwl_pcie_txq_unmap -  Unmap any remaining DMA mappings and free skb's
  */
@@ -620,6 +642,20 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 		}
 		iwl_pcie_txq_free_tfd(trans, txq);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr);
+
+		if (q->read_ptr == q->write_ptr) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+			if (txq_id != trans_pcie->cmd_queue) {
+				IWL_DEBUG_RPM(trans, "Q %d - last tx freed\n",
+					      q->id);
+				iwl_trans_pcie_unref(trans);
+			} else {
+				iwl_pcie_clear_cmd_in_flight(trans);
+			}
+			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+		}
 	}
 	txq->active = false;
 
@@ -1148,29 +1184,6 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 	return 0;
 }
 
-static int iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	lockdep_assert_held(&trans_pcie->reg_lock);
-
-	if (trans_pcie->ref_cmd_in_flight) {
-		trans_pcie->ref_cmd_in_flight = false;
-		IWL_DEBUG_RPM(trans, "clear ref_cmd_in_flight - unref\n");
-		iwl_trans_pcie_unref(trans);
-	}
-
-	if (trans->cfg->base_params->apmg_wake_up_wa) {
-		if (WARN_ON(!trans_pcie->cmd_hold_nic_awake))
-			return 0;
-
-		trans_pcie->cmd_hold_nic_awake = false;
-		__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
-					   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	}
-	return 0;
-}
-
 /*
  * iwl_pcie_cmdq_reclaim - Reclaim TX command queue entries already Tx'd
  *
-- 
2.5.0

