Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39802 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3KXUHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:15 -0500
Received: by mail-wi0-f173.google.com with SMTP id hm4so2718336wib.12
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:14 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/29] iwlwifi: pcie: remove minor dead code
Date: Sun, 24 Nov 2013 22:06:36 +0200
Message-Id: <1385323606-3603-19-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_959647_F25DB8D5)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

inta is checked to be zero in a IRQ_NONE branch so afterwards it
cannot be zero as it is never modified.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
[reword the patch title and fix comment]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 3f237b4..79d46a9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1121,7 +1121,6 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta, inta_mask;
-	irqreturn_t ret = IRQ_NONE;
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
@@ -1150,7 +1149,16 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
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
@@ -1168,19 +1176,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 
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
1.7.9.5

