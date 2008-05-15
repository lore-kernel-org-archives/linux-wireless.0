Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYEOF4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/26] iwlwifi: remove 4965 from iwl4965_tx_queue_update_write_ptr
Date: Thu, 15 May 2008 13:54:00 +0800
Message-Id: <1210830858-3410-9-git-send-email-yi.zhu@intel.com> (sfid-20080515_075627_006853_96F78EF3)
In-Reply-To: <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl4965_tx_queue_update_write_ptr to
iwl_txq_update_write_ptr. This is a preparation for moving to iwl-tx.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   38 +++++++++++++-------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 45b6b52..0ad9558 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -53,7 +53,7 @@
 #include "iwl-sta.h"
 #include "iwl-calib.h"
 
-static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
+static int iwl_txq_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_tx_queue *txq);
 
 /******************************************************************************
@@ -417,7 +417,7 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	ret = iwl4965_tx_queue_update_write_ptr(priv, txq);
+	ret = iwl_txq_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 	return ret ? ret : idx;
@@ -1978,7 +1978,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	rc = iwl4965_tx_queue_update_write_ptr(priv, txq);
+	rc = iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (rc)
@@ -1989,7 +1989,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
 			txq->need_update = 1;
-			iwl4965_tx_queue_update_write_ptr(priv, txq);
+			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
@@ -3272,17 +3272,17 @@ int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
 }
 
 /**
- * iwl4965_tx_queue_update_write_ptr - Send new write index to hardware
+ * iwl_txq_update_write_ptr - Send new write index to hardware
  */
-static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
+static int iwl_txq_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
-	int rc = 0;
+	int ret = 0;
 	int txq_id = txq->q.id;
 
 	if (txq->need_update == 0)
-		return rc;
+		return ret;
 
 	/* if we're trying to save power */
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
@@ -3295,13 +3295,13 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
 			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			return rc;
+			return ret;
 		}
 
 		/* restore this queue's parameters in nic hardware. */
-		rc = iwl_grab_nic_access(priv);
-		if (rc)
-			return rc;
+		ret = iwl_grab_nic_access(priv);
+		if (ret)
+			return ret;
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
 		iwl_release_nic_access(priv);
@@ -3314,7 +3314,7 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
 
 	txq->need_update = 0;
 
-	return rc;
+	return ret;
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -3706,12 +3706,12 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[0]);
-		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[1]);
-		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[2]);
-		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[3]);
-		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[4]);
-		iwl4965_tx_queue_update_write_ptr(priv, &priv->txq[5]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[2]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[3]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
+		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
-- 
1.5.3.6

