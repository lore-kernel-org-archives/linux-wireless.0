Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40886 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752851AbcEJUbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:31:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:21 +0300
Message-Id: <1462910797-20303-25-git-send-email-luca@coelho.fi> (sfid-20160510_223114_880449_C308088E)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 25/41] iwlwifi: pcie: don't wake up the NIC when writing CSRs in MSIX mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

CSR registers are always available even when the NIC is not awake, no
need to wake up the NIC before accessing them. This has a huge impact
when we re-enable an interrupt at the end of the ISR since waking up the
NIC can take some time.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 7f8a232..89f87f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1298,7 +1298,7 @@ static inline void iwl_pcie_clear_irq(struct iwl_trans *trans,
 	 * write 1 clear (W1C) register, meaning that it's being clear
 	 * by writing 1 to the bit.
 	 */
-	iwl_write_direct32(trans, CSR_MSIX_AUTOMASK_ST_AD, BIT(entry->entry));
+	iwl_write32(trans, CSR_MSIX_AUTOMASK_ST_AD, BIT(entry->entry));
 }
 
 /*
@@ -1817,13 +1817,13 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
 	spin_lock(&trans_pcie->irq_lock);
-	inta_fh = iwl_read_direct32(trans, CSR_MSIX_FH_INT_CAUSES_AD);
-	inta_hw = iwl_read_direct32(trans, CSR_MSIX_HW_INT_CAUSES_AD);
+	inta_fh = iwl_read32(trans, CSR_MSIX_FH_INT_CAUSES_AD);
+	inta_hw = iwl_read32(trans, CSR_MSIX_HW_INT_CAUSES_AD);
 	/*
 	 * Clear causes registers to avoid being handling the same cause.
 	 */
-	iwl_write_direct32(trans, CSR_MSIX_FH_INT_CAUSES_AD, inta_fh);
-	iwl_write_direct32(trans, CSR_MSIX_HW_INT_CAUSES_AD, inta_hw);
+	iwl_write32(trans, CSR_MSIX_FH_INT_CAUSES_AD, inta_fh);
+	iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD, inta_hw);
 	spin_unlock(&trans_pcie->irq_lock);
 
 	if (unlikely(!(inta_fh | inta_hw))) {
-- 
2.8.1

