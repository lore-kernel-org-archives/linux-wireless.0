Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab3LKIfD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 03:35:03 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 06/10] iwlwifi: pcie: determine the interrupt type in the handler
Date: Wed, 11 Dec 2013 10:33:41 +0200
Message-Id: <1386750826-25219-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131211_093529_416921_C2434828)
In-Reply-To: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1386750826-25219-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having:
iwl_pcie_irq_handler
	iwl_pcie_isr_ict
		iwl_pcie_isr_non_ict

we now have:

iwl_pcie_irq_handler:
	if (use_ict))
		iwl_pcie_int_cause_ict;
	else
		iwl_pcie_int_cause_non_ict;

This is much clearer.

Change-Id: Ieb99e8120c62749c06e3b2636aaf7ccbea8c72c5
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 5044fbd..58d3f64 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -807,8 +807,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	wake_up(&trans_pcie->wait_command_queue);
 }
 
-/* legacy (non-ICT) ISR. Assumes that trans_pcie->irq_lock is held */
-static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
+static irqreturn_t iwl_pcie_int_cause_non_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta;
@@ -876,7 +875,7 @@ static irqreturn_t iwl_pcie_isr_non_ict(struct iwl_trans *trans)
  * the interrupt we need to service, driver will set the entries back to 0 and
  * set index.
  */
-static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
+static irqreturn_t iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	irqreturn_t ret;
@@ -884,14 +883,6 @@ static irqreturn_t iwl_pcie_isr_ict(struct iwl_trans *trans)
 	u32 val = 0;
 	u32 read;
 
-	/* dram interrupt table not set yet,
-	 * use legacy interrupt.
-	 */
-	if (unlikely(!trans_pcie->use_ict)) {
-		ret = iwl_pcie_isr_non_ict(trans);
-		return ret;
-	}
-
 	trace_iwlwifi_dev_irq(trans->dev);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
@@ -977,7 +968,14 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
-	ret = iwl_pcie_isr_ict(trans);
+	/* dram interrupt table not set yet,
+	 * use legacy interrupt.
+	 */
+	if (likely(trans_pcie->use_ict))
+		ret = iwl_pcie_int_cause_ict(trans);
+	else
+		ret = iwl_pcie_int_cause_non_ict(trans);
+
 	if (ret != IRQ_WAKE_THREAD) {
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 		return ret;
-- 
1.8.3.2

