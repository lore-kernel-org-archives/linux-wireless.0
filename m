Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3ACOpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/12] iwlwifi: move some PCIe calls to better places
Date: Thu,  3 Jan 2013 15:46:14 +0100
Message-Id: <1357224376-27803-10-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154604_559447_C5F043C5)
In-Reply-To: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
 <1357224376-27803-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Synchronizing the IRQ is pointless when we will
then enable the RF-Kill interrupt again, but is
needed before we free it and the data needed to
handle IRQs; move it to the free function.

Simiarly, cancelling the replenish work struct
can move to the function that frees the RX data
structures.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c    | 2 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 9 +++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index dad4c4a..02c9016 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -545,6 +545,8 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 		return;
 	}
 
+	cancel_work_sync(&trans_pcie->rx_replenish);
+
 	spin_lock_irqsave(&rxq->lock, flags);
 	iwl_pcie_rxq_free_rbs(trans);
 	spin_unlock_irqrestore(&rxq->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 48cd65e..bca6203 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -534,12 +534,6 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 
 	iwl_enable_rfkill_int(trans);
 
-	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(trans_pcie->pci_dev->irq);
-	tasklet_kill(&trans_pcie->irq_tasklet);
-
-	cancel_work_sync(&trans_pcie->rx_replenish);
-
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
@@ -682,6 +676,9 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	synchronize_irq(trans_pcie->pci_dev->irq);
+	tasklet_kill(&trans_pcie->irq_tasklet);
+
 	iwl_pcie_tx_free(trans);
 	iwl_pcie_rx_free(trans);
 
-- 
1.8.0

