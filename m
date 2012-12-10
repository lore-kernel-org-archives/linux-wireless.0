Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2LJVtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:49:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/10] iwlwifi: don't handle masked interrupt
Date: Mon, 10 Dec 2012 22:49:18 +0100
Message-Id: <1355176158-24675-10-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224915_539994_3B232599)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can lead to a panic if the driver isn't ready to
handle them. Since our interrupt line is shared, we can get
an interrupt at any time (and CONFIG_DEBUG_SHIRQ checks
that even when the interrupt is being freed).

If the op_mode has gone away, we musn't call it. To avoid
this the transport disables the interrupts when the hw is
stopped and the op_mode is leaving.
If there is an event that would cause an interrupt the INTA
register is updated regardless of the enablement of the
interrupts: even if the interrupts are disabled, the INTA
will be changed, but the device won't issue an interrupt.
But the ISR can be called at any time, so we ought ignore
the value in the INTA otherwise we can call the op_mode
after it was freed.

I found this bug when the op_mode_start failed, and called
iwl_trans_stop_hw(trans, true). Then I played with the
RFKILL button, and removed the module.
While removing the module, the IRQ is freed, and the ISR is
called (CONFIG_DEBUG_SHIRQ enabled). Panic.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 787b9ca..6f72e1a 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1103,12 +1103,20 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
 	inta = iwl_read32(trans, CSR_INT);
 
+	if (inta & (~inta_mask)) {
+		IWL_DEBUG_ISR(trans,
+			      "We got a masked interrupt (0x%08x)...Ack and ignore\n",
+			      inta & (~inta_mask));
+		iwl_write32(trans, CSR_INT, inta & (~inta_mask));
+		inta &= inta_mask;
+	}
+
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
@@ -1190,7 +1198,7 @@ irqreturn_t iwl_pcie_isr_ict(int irq, void *data)
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);
 	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
-- 
1.8.0

