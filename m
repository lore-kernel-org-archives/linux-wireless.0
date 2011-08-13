Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1HMSSy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 35/60] iwlagn: move hcmd_lock to transport layer
Date: Sat, 13 Aug 2011 10:38:11 -0700
Message-Id: <1313257116-2697-36-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_204257_549256_E5B224BC)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is needed for host commands only, it is needed in transport layer only

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-trans.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h         |    2 ++
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7fa782d..65117e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3123,7 +3123,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	int ret;
 
 	spin_lock_init(&priv->shrd->sta_lock);
-	spin_lock_init(&priv->hcmd_lock);
 
 	mutex_init(&priv->shrd->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b1277cf..ad564b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1180,7 +1180,6 @@ struct iwl_priv {
 	u8 mgmt_tx_ant;
 
 	/* spinlock */
-	spinlock_t hcmd_lock;	/* protect hcmd */
 	spinlock_t reg_lock;	/* protect hw register access */
 
 	/*TODO: remove these pointers - use bus(priv) instead */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 49845c7..a706993 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -601,10 +601,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	spin_lock_irqsave(&priv->hcmd_lock, flags);
+	spin_lock_irqsave(&trans->hcmd_lock, flags);
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
+		spin_unlock_irqrestore(&trans->hcmd_lock, flags);
 
 		IWL_ERR(trans, "No space in command queue\n");
 		is_ct_kill = iwl_check_for_ct_kill(priv);
@@ -713,7 +713,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	iwl_txq_update_write_ptr(priv, txq);
 
  out:
-	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
+	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
 	return idx;
 }
 
@@ -796,7 +796,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	} else if (meta->callback)
 		meta->callback(priv, cmd, pkt);
 
-	spin_lock_irqsave(&priv->hcmd_lock, flags);
+	spin_lock_irqsave(&trans->hcmd_lock, flags);
 
 	iwl_hcmd_queue_reclaim(priv, txq_id, index);
 
@@ -809,7 +809,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	meta->flags = 0;
 
-	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
+	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
 }
 
 const char *get_cmd_string(u8 cmd)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index b448e79..73883fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1284,6 +1284,7 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 		iwl_trans->ops = &trans_ops_pcie;
 		iwl_trans->shrd = shrd;
 		trans_pcie->trans = iwl_trans;
+		spin_lock_init(&iwl_trans->hcmd_lock);
 	}
 
 	return iwl_trans;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index da6cc59..78bd2f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -146,10 +146,12 @@ struct iwl_trans_ops {
  * struct iwl_trans - transport common data
  * @ops - pointer to iwl_trans_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
+ * @hcmd_lock: protects HCMD
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_shared *shrd;
+	spinlock_t hcmd_lock;
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
-- 
1.7.0.4

