Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23975 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbXHHHih (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Cahill@vger.kernel.org,
	Ben M <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 28/28] iwlwifi: Streamline irq_tasklet() when ISR debug not used
Date: Wed,  8 Aug 2007 15:33:45 +0800
Message-Id: <11865584913031-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584891294-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
 <11865584771950-git-send-email-yi.zhu@intel.com>
 <1186558479530-git-send-email-yi.zhu@intel.com>
 <11865584823402-git-send-email-yi.zhu@intel.com>
 <11865584841976-git-send-email-yi.zhu@intel.com>
 <11865584861970-git-send-email-yi.zhu@intel.com>
 <11865584891294-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cahill, Ben M <ben.m.cahill@intel.com>

This patch streamlines irq_tasklet() when ISR debug is not used.
It also reports MAC_CLK_ACTV interrupt bit and enhance comments.

Signed-off-by: Cahill, Ben M <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 881945d..15965fc 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -5125,10 +5125,13 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
 	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
 
-	inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
-	IWL_DEBUG_ISR
-	    ("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-	     inta, inta_mask, inta_fh);
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_debug_level & IWL_DL_ISR) {
+		inta_mask = iwl_read32(priv, CSR_INT_MASK); /* just for debug */
+		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+			      inta, inta_mask, inta_fh);
+	}
+#endif
 
 	/* Since CSR_INT and CSR_FH_INT_STATUS reads and clears are not
 	 * atomic, make sure that inta covers all the interrupts that
@@ -5155,6 +5158,21 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		return;
 	}
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_debug_level & (IWL_DL_ISR)) {
+		/* NIC fires this, but we don't use it, redundant with WAKEUP */
+		if (inta & BIT_INT_MAC_CLK_ACTV)
+			IWL_DEBUG_ISR("Microcode started or stopped.\n");
+
+		/* Alive notification via Rx interrupt will do the real work */
+		if (inta & BIT_INT_ALIVE)
+			IWL_DEBUG_ISR("Alive interrupt\n");
+	}
+#endif
+	/* Safely ignore these bits for debug checks below */
+	inta &= ~(BIT_INT_MAC_CLK_ACTV | BIT_INT_ALIVE);
+
+	/* HW RF KILL switch toggled (4965 only) */
 	if (inta & BIT_INT_RF_KILL) {
 		int hw_rf_kill = 0;
 		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
@@ -5175,11 +5193,13 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		handled |= BIT_INT_RF_KILL;
 	}
 
+	/* Chip got too hot and stopped itself (4965 only) */
 	if (inta & BIT_INT_CT_KILL) {
 		IWL_ERROR("Microcode CT kill error detected.\n");
 		handled |= BIT_INT_CT_KILL;
 	}
 
+	/* Error detected by uCode */
 	if (inta & BIT_INT_SWERROR) {
 		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
 			  inta);
@@ -5187,6 +5207,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		handled |= BIT_INT_SWERROR;
 	}
 
+	/* uCode wakes up after power-down sleep */
 	if (inta & BIT_INT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
@@ -5200,12 +5221,6 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		handled |= BIT_INT_WAKEUP;
 	}
 
-	/* Alive notification via Rx interrupt will do the real work */
-	if (inta & BIT_INT_ALIVE) {
-		IWL_DEBUG_ISR("Alive interrupt\n");
-		handled |= BIT_INT_ALIVE;
-	}
-
 	/* All uCode command responses, including Tx command responses,
 	 * Rx "responses" (frame-received notification), and other
 	 * notifications from uCode come through here*/
-- 
1.5.2
