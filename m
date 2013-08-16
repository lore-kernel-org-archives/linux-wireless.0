Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3HPLHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 05/20] iwlwifi: pcie: Remove duplicate code from pcie irq handlers
Date: Fri, 16 Aug 2013 13:06:55 +0200
Message-Id: <1376651230-1060-5-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130725_281386_7D014B3C)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Instead of having the same code sequentially, fall-through.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 8c9641b..3f237b4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1121,6 +1121,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta, inta_mask;
+	irqreturn_t ret = IRQ_NONE;
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
@@ -1169,10 +1170,8 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	/* the thread will service interrupts and re-enable them */
 	if (likely(inta))
 		return IRQ_WAKE_THREAD;
-	else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-		 !trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-	return IRQ_HANDLED;
+
+	ret = IRQ_HANDLED;
 
 none:
 	/* re-enable interrupts here since we don't have anything to service. */
@@ -1181,7 +1180,7 @@ none:
 	    !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
 
-	return IRQ_NONE;
+	return ret;
 }
 
 /* interrupt handler using ict table, with this interrupt driver will
@@ -1200,6 +1199,7 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	u32 val = 0;
 	u32 read;
 	unsigned long flags;
+	irqreturn_t ret = IRQ_NONE;
 
 	if (!trans)
 		return IRQ_NONE;
@@ -1212,7 +1212,7 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	 * use legacy interrupt.
 	 */
 	if (unlikely(!trans_pcie->use_ict)) {
-		irqreturn_t ret = iwl_pcie_isr(irq, data);
+		ret = iwl_pcie_isr(irq, data);
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 		return ret;
 	}
@@ -1281,17 +1281,9 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	if (likely(inta)) {
 		spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 		return IRQ_WAKE_THREAD;
-	} else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-		 !trans_pcie->inta) {
-		/* Allow interrupt if was disabled by this handler and
-		 * no tasklet was schedules, We should not enable interrupt,
-		 * tasklet will enable it.
-		 */
-		iwl_enable_interrupts(trans);
 	}
 
-	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-	return IRQ_HANDLED;
+	ret = IRQ_HANDLED;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service.
@@ -1302,5 +1294,5 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 		iwl_enable_interrupts(trans);
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
-	return IRQ_NONE;
+	return ret;
 }
-- 
1.8.4.rc2

