Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYDOEQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/12] iwlwifi: Fix byte count table for fragmented packets
Date: Mon, 14 Apr 2008 21:16:10 -0700
Message-Id: <1208232974-3828-9-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051625_223208_08EDDBC4)
In-Reply-To: <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fix byte count table update. Table must be updated for each
fragment

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   13 +++++--------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +++---
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 822169e..04fed5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3141,18 +3141,16 @@ static void iwl4965_hw_card_show_info(struct iwl_priv *priv)
 #define IWL_TX_DELIMITER_SIZE	4
 
 /**
- * iwl4965_tx_queue_update_wr_ptr - Set up entry in Tx byte-count array
+ * iwl4965_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
-int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
-				   struct iwl4965_tx_queue *txq, u16 byte_cnt)
+static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					    struct iwl4965_tx_queue *txq,
+					    u16 byte_cnt)
 {
 	int len;
 	int txq_id = txq->q.id;
 	struct iwl4965_shared *shared_data = priv->hw_setting.shared_virt;
 
-	if (txq->need_update == 0)
-		return 0;
-
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
 	/* Set up byte count within first 256 entries */
@@ -3164,8 +3162,6 @@ int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
 			tfd_offset[IWL4965_QUEUE_SIZE + txq->q.write_ptr],
 			byte_cnt, len);
-
-	return 0;
 }
 
 /**
@@ -4934,6 +4930,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 
 static struct iwl_lib_ops iwl4965_lib = {
 	.init_drv = iwl4965_init_drv,
+	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.hw_nic_init = iwl4965_hw_nic_init,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 889fdba..23c21e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -89,6 +89,10 @@ struct iwl_hcmd_utils_ops {
 struct iwl_lib_ops {
 	/* iwlwifi driver (priv) init */
 	int (*init_drv)(struct iwl_priv *priv);
+
+	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
+					struct iwl4965_tx_queue *txq,
+					u16 byte_cnt);
 	/* nic init */
 	int (*hw_nic_init)(struct iwl_priv *priv);
 	/* alive notification */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bfefb05..60c0b83 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -575,11 +575,11 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	txq->need_update = 1;
 
 	/* Set up entry in queue's byte count circular buffer */
-	ret = iwl4965_tx_queue_update_wr_ptr(priv, txq, 0);
+	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl4965_tx_queue_update_write_ptr(priv, txq);
+	ret = iwl4965_tx_queue_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 	return ret ? ret : idx;
@@ -2392,7 +2392,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 			   ieee80211_get_hdrlen(fc));
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
+	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, len);
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-- 
1.5.3.4

