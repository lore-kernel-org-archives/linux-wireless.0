Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59525 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaBWT5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:17 -0500
Received: by mail-wi0-f172.google.com with SMTP id e4so2366148wiv.17
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:14 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/17] iwlwifi: pcie: clean iwl_pcie_[rt]xq_inc_wr_ptr a bit
Date: Sun, 23 Feb 2014 21:56:52 +0200
Message-Id: <1393185428-8524-1-git-send-email-egrumbach@gmail.com> (sfid-20140223_205730_046790_65360444)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The various code blocks in iwl_pcie_[rt]xq_inc_wr_ptr
finally do the same things, so just merge them
all and make the functions cleaner.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   47 +++++++++---------------
 drivers/net/wireless/iwlwifi/pcie/tx.c |   63 +++++++++++++++-----------------
 2 files changed, 47 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 41f684d..cf49f6c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -155,37 +155,26 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	if (rxq->need_update == 0)
 		goto exit_unlock;
 
-	if (trans->cfg->base_params->shadow_reg_enable) {
-		/* shadow register enabled */
-		/* Device expects a multiple of 8 */
-		rxq->write_actual = (rxq->write & ~0x7);
-		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
-	} else {
-		/* If power-saving is in use, make sure device is awake */
-		if (test_bit(STATUS_TPOWER_PMI, &trans->status)) {
-			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
-
-			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(trans,
-					"Rx queue requesting wakeup,"
-					" GP1 = 0x%x\n", reg);
-				iwl_set_bit(trans, CSR_GP_CNTRL,
-					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-				goto exit_unlock;
-			}
-
-			rxq->write_actual = (rxq->write & ~0x7);
-			iwl_write_direct32(trans, FH_RSCSR_CHNL0_WPTR,
-					   rxq->write_actual);
-
-		/* Else device is assumed to be awake */
-		} else {
-			/* Device expects a multiple of 8 */
-			rxq->write_actual = (rxq->write & ~0x7);
-			iwl_write_direct32(trans, FH_RSCSR_CHNL0_WPTR,
-					   rxq->write_actual);
+	/*
+	 * explicitly wake up the NIC if:
+	 * 1. shadow registers aren't enabled
+	 * 2. there is a chance that the NIC is asleep
+	 */
+	if (!trans->cfg->base_params->shadow_reg_enable &&
+	    test_bit(STATUS_TPOWER_PMI, &trans->status)) {
+		reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
+
+		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+			IWL_DEBUG_INFO(trans, "Rx queue requesting wakeup, GP1 = 0x%x\n",
+				       reg);
+			iwl_set_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			goto exit_unlock;
 		}
 	}
+
+	rxq->write_actual = round_down(rxq->write, 8);
+	iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
 	rxq->need_update = 0;
 
  exit_unlock:
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 2541264..e476d9e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -296,43 +296,38 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 	if (txq->need_update == 0)
 		return;
 
-	if (trans->cfg->base_params->shadow_reg_enable ||
-	    txq_id == trans_pcie->cmd_queue) {
-		/* shadow register enabled */
-		iwl_write32(trans, HBUS_TARG_WRPTR,
-			    txq->q.write_ptr | (txq_id << 8));
-	} else {
-		/* if we're trying to save power */
-		if (test_bit(STATUS_TPOWER_PMI, &trans->status)) {
-			/* wake up nic if it's powered down ...
-			 * uCode will wake up, and interrupt us again, so next
-			 * time we'll skip this part. */
-			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
-
-			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-				IWL_DEBUG_INFO(trans,
-					"Tx queue %d requesting wakeup,"
-					" GP1 = 0x%x\n", txq_id, reg);
-				iwl_set_bit(trans, CSR_GP_CNTRL,
-					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-				return;
-			}
-
-			IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id,
-				     txq->q.write_ptr);
-
-			iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-				     txq->q.write_ptr | (txq_id << 8));
-
+	/*
+	 * explicitly wake up the NIC if:
+	 * 1. shadow registers aren't enabled
+	 * 2. NIC is woken up for CMD regardless of shadow outside this function
+	 * 3. there is a chance that the NIC is asleep
+	 */
+	if (!trans->cfg->base_params->shadow_reg_enable &&
+	    txq_id != trans_pcie->cmd_queue &&
+	    test_bit(STATUS_TPOWER_PMI, &trans->status)) {
 		/*
-		 * else not in power-save mode,
-		 * uCode will never sleep when we're
-		 * trying to tx (during RFKILL, we're not trying to tx).
+		 * wake up nic if it's powered down ...
+		 * uCode will wake up, and interrupt us again, so next
+		 * time we'll skip this part.
 		 */
-		} else
-			iwl_write32(trans, HBUS_TARG_WRPTR,
-				    txq->q.write_ptr | (txq_id << 8));
+		reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
+
+		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+			IWL_DEBUG_INFO(trans, "Tx queue %d requesting wakeup, GP1 = 0x%x\n",
+				       txq_id, reg);
+			iwl_set_bit(trans, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			return;
+		}
 	}
+
+	/*
+	 * if not in power-save mode, uCode will never sleep when we're
+	 * trying to tx (during RFKILL, we're not trying to tx).
+	 */
+	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->q.write_ptr);
+	iwl_write32(trans, HBUS_TARG_WRPTR, txq->q.write_ptr | (txq_id << 8));
+
 	txq->need_update = 0;
 }
 
-- 
1.7.9.5

