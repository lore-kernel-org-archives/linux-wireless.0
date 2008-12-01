Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:37922 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYLAPx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:53:56 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1955184rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 07:53:54 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH] iwl3945: remove obsolete irq handling
Date: Mon, 1 Dec 2008 16:53:28 +0100
Cc: linux-wireless@vger.kernel.org, tomasw@gmail.com, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812011653.29150.helmut.schaa@gmail.com> (sfid-20081201_165359_769867_9433A9DE)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3945 hardware does not emit the interrupts CSR_INT_BIT_RF_KILL (rfkill
toggled) and CSR_INT_BIT_CT_KILL (adapter too hot). Hence this part of code
can be removed since iwl3945_irq_tasklet does not handle 4965 hw at all.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 490bc4a..b32b507 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4321,35 +4321,6 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	/* Safely ignore these bits for debug checks below */
 	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
 
-	/* HW RF KILL switch toggled (4965 only) */
-	if (inta & CSR_INT_BIT_RF_KILL) {
-		int hw_rf_kill = 0;
-		if (!(iwl3945_read32(priv, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-			hw_rf_kill = 1;
-
-		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL | IWL_DL_ISR,
-				"RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio" : "enable radio");
-
-		/* Queue restart only if RF_KILL switch was set to "kill"
-		 *   when we loaded driver, and is now set to "enable".
-		 * After we're Alive, RF_KILL gets handled by
-		 *   iwl3945_rx_card_state_notif() */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
-			clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			queue_work(priv->workqueue, &priv->restart);
-		}
-
-		handled |= CSR_INT_BIT_RF_KILL;
-	}
-
-	/* Chip got too hot and stopped itself (4965 only) */
-	if (inta & CSR_INT_BIT_CT_KILL) {
-		IWL_ERROR("Microcode CT kill error detected.\n");
-		handled |= CSR_INT_BIT_CT_KILL;
-	}
-
 	/* Error detected by uCode */
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
