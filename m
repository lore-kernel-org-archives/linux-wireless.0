Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52423 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:59 -0400
Received: by mail-wg0-f42.google.com with SMTP id b13so8920164wgh.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:58 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/36] iwlwifi: trans: refactor txq_enable arguments
Date: Wed,  3 Sep 2014 22:56:08 +0300
Message-Id: <1409774184-24665-20-git-send-email-egrumbach@gmail.com> (sfid-20140903_215757_220980_042009AA)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of having all arguments passed to the function,
add a struct to hold them and only pass some directly.

This will make future work in this area cleaner.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 21 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/pcie/internal.h |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 13 +++++++------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 656371a..c198dde 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -401,6 +401,13 @@ struct iwl_trans_dump_data {
 
 struct iwl_trans;
 
+struct iwl_trans_txq_scd_cfg {
+	u8 fifo;
+	s8 sta_id;
+	u8 tid;
+	int frame_limit;
+};
+
 /**
  * struct iwl_trans_ops - transport specific operations
  *
@@ -492,8 +499,8 @@ struct iwl_trans_ops {
 	void (*reclaim)(struct iwl_trans *trans, int queue, int ssn,
 			struct sk_buff_head *skbs);
 
-	void (*txq_enable)(struct iwl_trans *trans, int queue, int fifo,
-			   int sta_id, int tid, int frame_limit, u16 ssn);
+	void (*txq_enable)(struct iwl_trans *trans, int queue, u16 ssn,
+			   const struct iwl_trans_txq_scd_cfg *cfg);
 	void (*txq_disable)(struct iwl_trans *trans, int queue);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
@@ -775,13 +782,19 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 					int fifo, int sta_id, int tid,
 					int frame_limit, u16 ssn)
 {
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = fifo,
+		.sta_id = sta_id,
+		.tid = tid,
+		.frame_limit = frame_limit,
+	};
+
 	might_sleep();
 
 	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
-	trans->ops->txq_enable(trans, queue, fifo, sta_id, tid,
-				 frame_limit, ssn);
+	trans->ops->txq_enable(trans, queue, ssn, &cfg);
 }
 
 static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 78f72c3..5760405 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -364,8 +364,8 @@ int iwl_pcie_tx_init(struct iwl_trans *trans);
 void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr);
 int iwl_pcie_tx_stop(struct iwl_trans *trans);
 void iwl_pcie_tx_free(struct iwl_trans *trans);
-void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
-			       int sta_id, int tid, int frame_limit, u16 ssn);
+void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int queue, u16 ssn,
+			       const struct iwl_trans_txq_scd_cfg *cfg);
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id);
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 84c3a01..5c95386 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1066,10 +1066,11 @@ static int iwl_pcie_txq_set_ratid_map(struct iwl_trans *trans, u16 ra_tid,
  * combined with Traffic ID (QOS priority), in format used by Tx Scheduler */
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
-void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
-			       int sta_id, int tid, int frame_limit, u16 ssn)
+void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
+			       const struct iwl_trans_txq_scd_cfg *cfg)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u8 frame_limit = cfg->frame_limit;
 
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
@@ -1082,8 +1083,8 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 		iwl_scd_txq_set_chain(trans, txq_id);
 
 	/* If this queue is mapped to a certain station: it is an AGG queue */
-	if (sta_id >= 0) {
-		u16 ra_tid = BUILD_RAxTID(sta_id, tid);
+	if (cfg->sta_id >= 0) {
+		u16 ra_tid = BUILD_RAxTID(cfg->sta_id, cfg->tid);
 
 		/* Map receiver-address / traffic-ID to this queue */
 		iwl_pcie_txq_set_ratid_map(trans, ra_tid, txq_id);
@@ -1124,12 +1125,12 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
 		       (1 << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-		       (fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
+		       (cfg->fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
 		       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
 		       SCD_QUEUE_STTS_REG_MSK);
 	trans_pcie->txq[txq_id].active = true;
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d WrPtr: %d\n",
-			    txq_id, fifo, ssn & 0xff);
+			    txq_id, cfg->fifo, ssn & 0xff);
 }
 
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
-- 
1.9.1

