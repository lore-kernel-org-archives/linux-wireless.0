Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab3KLLNU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 06:13:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org,
	Michal Nazarewicz <mina86@mina86.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v3] iwlwifi: pcie: remove minor dead code
Date: Tue, 12 Nov 2013 13:12:41 +0200
Message-Id: <1384254761-22992-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131112_121323_702783_6F5E06DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

inta is checked to be zero in a IRQ_NONE branch so afterwards it
cannot be zero as it is never modified.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
[reword the patch title and fix comment]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Fixed a few things so sending again before applying to our internal tree
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 784d66b..795162b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1122,7 +1122,6 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta, inta_mask;
-	irqreturn_t ret = IRQ_NONE;
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
@@ -1151,7 +1150,16 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 * or due to sporadic interrupts thrown from our NIC. */
 	if (!inta) {
 		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		goto none;
+		/*
+		 * Re-enable interrupts here since we don't have anything to
+		 * service, but only in case the handler won't run. Note that
+		 * the handler can be scheduled because of a previous
+		 * interrupt.
+		 */
+		if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
+		    !trans_pcie->inta)
+			iwl_enable_interrupts(trans);
+		return IRQ_NONE;
 	}
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
@@ -1169,19 +1177,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 
 	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
-	if (likely(inta))
-		return IRQ_WAKE_THREAD;
-
-	ret = IRQ_HANDLED;
-
-none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-	    !trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-
-	return ret;
+	return IRQ_WAKE_THREAD;
 }
 
 /* interrupt handler using ict table, with this interrupt driver will
-- 
1.8.3.2

