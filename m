Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758472AbXHHHhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/28] iwlwifi: make local functions static
Date: Wed,  8 Aug 2007 15:33:24 +0800
Message-Id: <1186558443548-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584413292-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    9 +++++----
 drivers/net/wireless/iwl-base.c |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index c93c607..8175b48 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -4257,8 +4257,9 @@ static int iwl4965_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 /**
  * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
  */
-int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id, int tx_fifo,
-				int sta_id, int tid, u16 ssn_idx)
+static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
+				       int tx_fifo, int sta_id, int tid,
+				       u16 ssn_idx)
 {
 	unsigned long flags;
 	int rc;
@@ -4315,8 +4316,8 @@ int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id, int tx_fifo,
 /**
  * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
  */
-int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
-				 u16 ssn_idx, u8 tx_fifo)
+static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
+					u16 ssn_idx, u8 tx_fifo)
 {
 	unsigned long flags;
 	int rc;
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 18c4a23..e58dcfa 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -310,7 +310,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd))
 		iwl_hw_tx_queue_free_tfd(priv, txq);
 
-	len = sizeof(txq->cmd[0]) * q->n_window;
+	len = sizeof(struct iwl_cmd) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM);
 		len += IWL_MAX_SCAN_SIZE;
 
@@ -3549,7 +3549,7 @@ static inline u32 iwl_get_scd_ssn(struct iwl_tx_resp *tx_resp)
 	return le32_to_cpu(*scd_ssn & MAX_SN);
 
 }
-int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
+static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
 				      struct iwl_tx_resp *tx_resp,
 				      u16 start_idx)
-- 
1.5.2
