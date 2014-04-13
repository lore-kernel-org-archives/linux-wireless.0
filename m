Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43999 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:36 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so3136111wiv.7
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/47] iwlwifi: allow to wait for a subset of the queues
Date: Sun, 13 Apr 2014 22:19:32 +0300
Message-Id: <1397416802-32403-17-git-send-email-egrumbach@gmail.com> (sfid-20140413_212041_466466_BE9DD69A)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will be used later to flush / wait for queues that are
related to a specific vif.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/lib.c      |  2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 10 +++++-----
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  6 +++++-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 576f7ee..d169228 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -180,7 +180,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv)
 		goto done;
 	}
 	IWL_DEBUG_INFO(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(priv->trans);
+	iwl_trans_wait_tx_queue_empty(priv->trans, 0xffffffff);
 done:
 	ieee80211_wake_queues(priv->hw);
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index dd55c9c..d3abc15 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1119,7 +1119,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		}
 	}
 	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(priv->trans);
+	iwl_trans_wait_tx_queue_empty(priv->trans, 0xffffffff);
 done:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8cdb0dd..22fd94e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -437,8 +437,7 @@ struct iwl_trans;
  *	this one. The op_mode must not configure the HCMD queue. May sleep.
  * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
- * @wait_tx_queue_empty: wait until all tx queues are empty
- *	May sleep
+ * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
  *	automatically deleted.
  * @write8: write a u8 to a register at offset ofs from the BAR
@@ -490,7 +489,7 @@ struct iwl_trans_ops {
 	void (*txq_disable)(struct iwl_trans *trans, int queue);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
-	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
+	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
 
 	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
 	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
@@ -759,12 +758,13 @@ static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
 			     IWL_MAX_TID_COUNT, IWL_FRAME_LIMIT, 0);
 }
 
-static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
+static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
+						u32 txq_bm)
 {
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
-	return trans->ops->wait_tx_queue_empty(trans);
+	return trans->ops->wait_tx_queue_empty(trans, txq_bm);
 }
 
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 2548f49..0f20e73 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1257,7 +1257,7 @@ static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
 
 #define IWL_FLUSH_WAIT_MS	2000
 
-static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
+static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq;
@@ -1272,6 +1272,10 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
 	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
 		if (cnt == trans_pcie->cmd_queue)
 			continue;
+		if (!test_bit(cnt, trans_pcie->queue_used))
+			continue;
+		if (!(BIT(cnt) & txq_bm))
+			continue;
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
-- 
1.8.3.2

