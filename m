Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11719 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbbCLNF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/49] iwlwifi: pcie: speed up the Tx DMA stop flow
Date: Thu, 12 Mar 2015 15:04:11 +0200
Message-Id: <1426165474-25586-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_582365_885C0A2D)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need to acquire MAC access for each access, it
makes much more sense to keep the MAC access. This speeds
up the Tx DMA stop flow significantly.
Moreover, if one channel can't be stopped, stop the others
but don't poll for them to avoid being stuck there for a
long time.

This solves a situation in which we were stuck in that flow
for way too long with a spinlock held which led to a kernel
panic.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 51 ++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index af0bce7..26e6dd0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -725,33 +725,50 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 	iwl_pcie_tx_start(trans, 0);
 }
 
+static void iwl_pcie_tx_stop_fh(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+	int ch, ret;
+	u32 mask = 0;
+
+	spin_lock(&trans_pcie->irq_lock);
+
+	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+		goto out;
+
+	/* Stop each Tx DMA channel */
+	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
+		iwl_write32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		mask |= FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch);
+	}
+
+	/* Wait for DMA channels to be idle */
+	ret = iwl_poll_bit(trans, FH_TSSR_TX_STATUS_REG, mask, mask, 5000);
+	if (ret < 0)
+		IWL_ERR(trans,
+			"Failing on timeout while stopping DMA channel %d [0x%08x]\n",
+			ch, iwl_read32(trans, FH_TSSR_TX_STATUS_REG));
+
+	iwl_trans_release_nic_access(trans, &flags);
+
+out:
+	spin_unlock(&trans_pcie->irq_lock);
+}
+
 /*
  * iwl_pcie_tx_stop - Stop all Tx DMA channels
  */
 int iwl_pcie_tx_stop(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int ch, txq_id, ret;
+	int txq_id;
 
 	/* Turn off all Tx DMA fifos */
-	spin_lock(&trans_pcie->irq_lock);
-
 	iwl_scd_deactivate_fifos(trans);
 
-	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
-		iwl_write_direct32(trans,
-				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		ret = iwl_poll_direct_bit(trans, FH_TSSR_TX_STATUS_REG,
-			FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch), 1000);
-		if (ret < 0)
-			IWL_ERR(trans,
-				"Failing on timeout while stopping DMA channel %d [0x%08x]\n",
-				ch,
-				iwl_read_direct32(trans,
-						  FH_TSSR_TX_STATUS_REG));
-	}
-	spin_unlock(&trans_pcie->irq_lock);
+	/* Turn off all Tx DMA channels */
+	iwl_pcie_tx_stop_fh(trans);
 
 	/*
 	 * This function can be called before the op_mode disabled the
-- 
1.9.1

