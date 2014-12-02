Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59637 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:36 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so17760620wgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:35 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/26] iwlwifi: pcie: refactor cmd_in_flight set/clear code
Date: Tue,  2 Dec 2014 20:11:00 +0200
Message-Id: <1417543877-24193-9-git-send-email-egrumbach@gmail.com> (sfid-20141202_191141_414228_F38AAEB0)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

A following patche will use trans_pcie->cmd_in_flight
for reference accounting as well. get ready for it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 102 +++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 4a4104e..8a6c7a0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -989,6 +989,65 @@ out:
 	spin_unlock_bh(&txq->lock);
 }
 
+static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int ret;
+
+	lockdep_assert_held(&trans_pcie->reg_lock);
+
+	if (trans_pcie->cmd_in_flight)
+		return 0;
+
+	trans_pcie->cmd_in_flight = true;
+
+	/*
+	 * wake up the NIC to make sure that the firmware will see the host
+	 * command - we will let the NIC sleep once all the host commands
+	 * returned. This needs to be done only on NICs that have
+	 * apmg_wake_up_wa set.
+	 */
+	if (trans->cfg->base_params->apmg_wake_up_wa) {
+		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
+					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			udelay(2);
+
+		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+				   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+				   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+				    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP),
+				   15000);
+		if (ret < 0) {
+			__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			trans_pcie->cmd_in_flight = false;
+			IWL_ERR(trans, "Failed to wake NIC for hcmd\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static int iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	lockdep_assert_held(&trans_pcie->reg_lock);
+
+	if (WARN_ON(!trans_pcie->cmd_in_flight))
+		return 0;
+
+	trans_pcie->cmd_in_flight = false;
+
+	if (trans->cfg->base_params->apmg_wake_up_wa)
+		__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
+					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	return 0;
+}
+
 /*
  * iwl_pcie_cmdq_reclaim - Reclaim TX command queue entries already Tx'd
  *
@@ -1024,14 +1083,9 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		}
 	}
 
-	if (trans->cfg->base_params->apmg_wake_up_wa &&
-	    q->read_ptr == q->write_ptr) {
+	if (q->read_ptr == q->write_ptr) {
 		spin_lock_irqsave(&trans_pcie->reg_lock, flags);
-		WARN_ON(!trans_pcie->cmd_in_flight);
-		trans_pcie->cmd_in_flight = false;
-		__iwl_trans_pcie_clear_bit(trans,
-					   CSR_GP_CNTRL,
-					   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		iwl_pcie_clear_cmd_in_flight(trans);
 		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 	}
 
@@ -1419,35 +1473,11 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
 
 	spin_lock_irqsave(&trans_pcie->reg_lock, flags);
-
-	/*
-	 * wake up the NIC to make sure that the firmware will see the host
-	 * command - we will let the NIC sleep once all the host commands
-	 * returned. This needs to be done only on NICs that have
-	 * apmg_wake_up_wa set.
-	 */
-	if (trans->cfg->base_params->apmg_wake_up_wa &&
-	    !trans_pcie->cmd_in_flight) {
-		trans_pcie->cmd_in_flight = true;
-		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
-					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
-			udelay(2);
-
-		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-				   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-				   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-				    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP),
-				   15000);
-		if (ret < 0) {
-			__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
-				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
-			trans_pcie->cmd_in_flight = false;
-			IWL_ERR(trans, "Failed to wake NIC for hcmd\n");
-			idx = -EIO;
-			goto out;
-		}
+	ret = iwl_pcie_set_cmd_in_flight(trans);
+	if (ret < 0) {
+		idx = ret;
+		spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+		goto out;
 	}
 
 	/* Increment and update queue's write index */
-- 
1.9.1

