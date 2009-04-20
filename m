Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682AbZDTVbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/11] iwl3945: calculate debugfs isr statistics
Date: Mon, 20 Apr 2009 14:36:59 -0700
Message-Id: <1240263424-8495-7-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233115_791982_EB24E5DA)
In-Reply-To: <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This patch calculates interrupt statistics for debugfs.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4e1331d..f4978bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1543,6 +1543,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 				"r = %d, i = %d, %s, 0x%02x\n", r, i,
 				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
+			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
 		} else {
 			/* No handling needed */
 			IWL_DEBUG(priv, IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
@@ -1845,6 +1846,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(priv);
 
+		priv->isr_stats.hw++;
 		iwl_irq_handle_error(priv);
 
 		handled |= CSR_INT_BIT_HW_ERR;
@@ -1857,13 +1859,17 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_SCD)
+		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
 				      "the frame/frames.\n");
+			priv->isr_stats.sch++;
+		}
 
 		/* Alive notification via Rx interrupt will do the real work */
-		if (inta & CSR_INT_BIT_ALIVE)
+		if (inta & CSR_INT_BIT_ALIVE) {
 			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
+			priv->isr_stats.alive++;
+		}
 	}
 #endif
 	/* Safely ignore these bits for debug checks below */
@@ -1873,6 +1879,8 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERR(priv, "Microcode SW error detected. "
 			"Restarting 0x%X.\n", inta);
+		priv->isr_stats.sw++;
+		priv->isr_stats.sw_err = inta;
 		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -1888,6 +1896,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
 		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
 
+		priv->isr_stats.wakeup++;
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
 
@@ -1896,11 +1905,13 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	 * notifications from uCode come through here*/
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 		iwl3945_rx_handle(priv);
+		priv->isr_stats.rx++;
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
 		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
+		priv->isr_stats.tx++;
 
 		iwl_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
 		if (!iwl_grab_nic_access(priv)) {
@@ -1911,8 +1922,10 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		handled |= CSR_INT_BIT_FH_TX;
 	}
 
-	if (inta & ~handled)
+	if (inta & ~handled) {
 		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		priv->isr_stats.unhandled++;
+	}
 
 	if (inta & ~CSR_INI_SET_MASK) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-- 
1.5.6.3

