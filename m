Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZASX2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/15] iwl3945: Use iwl_txq_update_write_ptr
Date: Mon, 19 Jan 2009 15:30:25 -0800
Message-Id: <1232407835-19451-6-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002825_865724_2D4737D2)
In-Reply-To: <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

The iwl3945 and the iwl versions are identical.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   67 ++++-----------------------
 1 files changed, 9 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4e581f5..2ab9162 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -56,9 +56,6 @@
 #include "iwl-core.h"
 #include "iwl-dev.h"
 
-static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq);
-
 /*
  * module name, copyright, version, etc.
  */
@@ -527,7 +524,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
+	ret = iwl_txq_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 	return ret ? ret : idx;
@@ -2359,7 +2356,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);
+	rc = iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (rc)
@@ -2370,7 +2367,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
 			txq->need_update = 1;
-			iwl3945_tx_queue_update_write_ptr(priv, txq);
+			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
@@ -3485,52 +3482,6 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	iwl3945_rx_queue_restock(priv);
 }
 
-/**
- * iwl3945_tx_queue_update_write_ptr - Send new write index to hardware
- */
-static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq)
-{
-	u32 reg = 0;
-	int rc = 0;
-	int txq_id = txq->q.id;
-
-	if (txq->need_update == 0)
-		return rc;
-
-	/* if we're trying to save power */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		/* wake up nic if it's powered down ...
-		 * uCode will wake up, and interrupt us again, so next
-		 * time we'll skip this part. */
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
-			iwl_set_bit(priv, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			return rc;
-		}
-
-		/* restore this queue's parameters in nic hardware. */
-		rc = iwl_grab_nic_access(priv);
-		if (rc)
-			return rc;
-		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
-				     txq->q.write_ptr | (txq_id << 8));
-		iwl_release_nic_access(priv);
-
-	/* else not in power-save mode, uCode will never sleep when we're
-	 * trying to tx (during RFKILL, we're not trying to tx). */
-	} else
-		iwl_write32(priv, HBUS_TARG_WRPTR,
-			    txq->q.write_ptr | (txq_id << 8));
-
-	txq->need_update = 0;
-
-	return rc;
-}
-
 #ifdef CONFIG_IWL3945_DEBUG
 static void iwl3945_print_rx_config_cmd(struct iwl_priv *priv,
 					struct iwl3945_rxon_cmd *rxon)
@@ -3899,12 +3850,12 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[0]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[1]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[2]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[3]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[4]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[5]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[2]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[3]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
-- 
1.5.4.3

