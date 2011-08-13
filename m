Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1HMSSv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 57/60] iwlagn: move wait_for_tx_queue_empty to transport layer
Date: Sat, 13 Aug 2011 10:38:33 -0700
Message-Id: <1313257116-2697-58-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201939_168690_9F038288)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This one is really transport related.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   33 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.c   |   32 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h   |    8 ++++++
 5 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 359bd90..7c036b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -634,37 +634,6 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 				  vif->bss_conf.bssid);
 }
 
-#define IWL_FLUSH_WAIT_MS	2000
-
-int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
-{
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	int cnt;
-	unsigned long now = jiffies;
-	int ret = 0;
-
-	/* waiting for all the tx frames complete might take a while */
-	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
-		if (cnt == priv->shrd->cmd_queue)
-			continue;
-		txq = &priv->txq[cnt];
-		q = &txq->q;
-		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
-		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
-				msleep(1);
-
-		if (q->read_ptr != q->write_ptr) {
-			IWL_ERR(priv, "fail to flush all tx fifo queues\n");
-			ret = -ETIMEDOUT;
-			break;
-		}
-	}
-	return ret;
-}
-
-#define IWL_TX_QUEUE_MSK	0xfffff
-
 /**
  * iwlagn_txfifo_flush: send REPLY_TXFIFO_FLUSH command to uCode
  *
@@ -715,7 +684,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		goto done;
 	}
 	IWL_DEBUG_INFO(priv, "wait transmit/flush all frames\n");
-	iwlagn_wait_tx_queue_empty(priv);
+	iwl_trans_wait_tx_queue_empty(trans(priv));
 done:
 	ieee80211_wake_queues(priv->hw);
 	mutex_unlock(&priv->shrd->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ed1ac78..3f39c5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2830,7 +2830,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 		}
 	}
 	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
-	iwlagn_wait_tx_queue_empty(priv);
+	iwl_trans_wait_tx_queue_empty(trans(priv));
 done:
 	mutex_unlock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2b94a10..a7b4948 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -102,7 +102,6 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
-int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 9b0ecd4..7b868c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1446,6 +1446,35 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 	return iwl_trans;
 }
 
+#define IWL_FLUSH_WAIT_MS	2000
+
+static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
+{
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	int cnt;
+	unsigned long now = jiffies;
+	int ret = 0;
+
+	/* waiting for all the tx frames complete might take a while */
+	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
+		if (cnt == trans->shrd->cmd_queue)
+			continue;
+		txq = &priv(trans)->txq[cnt];
+		q = &txq->q;
+		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
+		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
+			msleep(1);
+
+		if (q->read_ptr != q->write_ptr) {
+			IWL_ERR(trans, "fail to flush all tx fifo queues\n");
+			ret = -ETIMEDOUT;
+			break;
+		}
+	}
+	return ret;
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
@@ -2024,6 +2053,9 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.free = iwl_trans_pcie_free,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
+
+	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
+
 	.suspend = iwl_trans_pcie_suspend,
 	.resume = iwl_trans_pcie_resume,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c92c9fe..45d6dff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -101,6 +101,7 @@ struct iwl_device_cmd;
  * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
+ * @wait_tx_queue_empty: wait until all tx queues are empty
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
  *	automatically deleted.
  * @suspend: stop the device unless WoWLAN is configured
@@ -142,6 +143,8 @@ struct iwl_trans_ops {
 	void (*free)(struct iwl_trans *trans);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
+	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
+
 	int (*suspend)(struct iwl_trans *trans);
 	int (*resume)(struct iwl_trans *trans);
 };
@@ -251,6 +254,11 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 	trans->ops->free(trans);
 }
 
+static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
+{
+	return trans->ops->wait_tx_queue_empty(trans);
+}
+
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
 					    struct dentry *dir)
 {
-- 
1.7.0.4

