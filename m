Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43419 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308AbYCGBkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 20:40:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Max Stepanov <max.stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/4] iwlwifi: grab NIC access when disabling aggregations
Date: Thu,  6 Mar 2008 17:36:56 -0800
Message-Id: <1204853816-8964-5-git-send-email-reinette.chatre@intel.com> (sfid-20080307_014029_154325_DE8C3853)
In-Reply-To: <1204853816-8964-4-git-send-email-reinette.chatre@intel.com>
References: <1204853816-8964-1-git-send-email-reinette.chatre@intel.com>
 <1204853816-8964-2-git-send-email-reinette.chatre@intel.com>
 <1204853816-8964-3-git-send-email-reinette.chatre@intel.com>
 <1204853816-8964-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch grabs NIC access inside iwl4965_tx_queue_agg_disable, instead of the
caller doing it.
The caller must still hold priv->lock when calling the function.

Signed-off-by: Max Stepanov <max.stepanov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   37 ++++++++++++++++--------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3e122a9..4a7167d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4138,16 +4138,23 @@ static void iwl4965_tx_queue_stop_scheduler(struct iwl4965_priv *priv,
 
 /**
  * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
+ * priv->lock must be held by the caller
  */
 static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
 					u16 ssn_idx, u8 tx_fifo)
 {
+	int ret = 0;
+
 	if (IWL_BACK_QUEUE_FIRST_ID > txq_id) {
 		IWL_WARNING("queue number too small: %d, must be > %d\n",
 				txq_id, IWL_BACK_QUEUE_FIRST_ID);
 		return -EINVAL;
 	}
 
+	ret = iwl4965_grab_nic_access(priv);
+	if (ret)
+		return ret;
+
 	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
 
 	iwl4965_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
@@ -4161,6 +4168,8 @@ static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
 	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
+	iwl4965_release_nic_access(priv);
+
 	return 0;
 }
 
@@ -4630,7 +4639,7 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 	int tx_fifo;
 	int txq_id;
 	int ssn = -1;
-	int rc = 0;
+	int ret = 0;
 	unsigned long flags;
 	struct iwl4965_tid_data *tid_data;
 	DECLARE_MAC_BUF(mac);
@@ -4663,12 +4672,12 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	*start_seq_num = ssn;
-	rc = iwl4965_tx_queue_agg_enable(priv, txq_id, tx_fifo,
-					   sta_id, tid, ssn);
-	if (rc)
-		return rc;
+	ret = iwl4965_tx_queue_agg_enable(priv, txq_id, tx_fifo,
+					  sta_id, tid, ssn);
+	if (ret)
+		return ret;
 
-	rc = 0;
+	ret = 0;
 	if (tid_data->tfds_in_queue == 0) {
 		printk(KERN_ERR "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
@@ -4678,7 +4687,7 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 				tid_data->tfds_in_queue);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
-	return rc;
+	return ret;
 }
 
 static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
@@ -4688,7 +4697,7 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 	struct iwl4965_priv *priv = hw->priv;
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl4965_tid_data *tid_data;
-	int rc, write_ptr, read_ptr;
+	int ret, write_ptr, read_ptr;
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
@@ -4728,17 +4737,11 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-	rc = iwl4965_tx_queue_agg_disable(priv, txq_id, ssn, tx_fifo_id);
-	iwl4965_release_nic_access(priv);
+	ret = iwl4965_tx_queue_agg_disable(priv, txq_id, ssn, tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (rc)
-		return rc;
+	if (ret)
+		return ret;
 
 	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, da, tid);
 
-- 
1.5.3.4

