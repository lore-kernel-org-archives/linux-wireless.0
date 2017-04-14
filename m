Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51830 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752941AbdDNJEc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:55 +0300
Message-Id: <20170414090210.31397-12-luca@coelho.fi> (sfid-20170414_110437_044428_6D155FAB)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 11/26] iwlwifi: pcie: introduce a000 TX queues management
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 devices the TX handling is different in a few ways:
* Queues are allocated dynamically
* DQA is enabled by default
* Driver shouldn't access TFH registers - ucode configures it
  all in SCD_QUEUE_CFG command

Support all this in a new API with op mode, where op mode sends
the command, transport will allocate the queue dynamically, fill
in DMA properties, send the command to FW and get the ID back.
Current implementation only sets the new transport API and fills
the DMA properties.
Future patches will complete the other parts.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  70 ++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   6 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 162 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   8 +-
 6 files changed, 240 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index b27bcac8f5db..411cb91c102f 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -7,7 +7,7 @@ iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
-iwlwifi-objs		+= pcie/ctxt-info.o pcie/trans-gen2.o
+iwlwifi-objs		+= pcie/ctxt-info.o pcie/trans-gen2.o pcie/tx-gen2.o
 iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
 iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o iwl-9000.o iwl-a000.o
 iwlwifi-objs		+= iwl-trans.o
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 1b4b62ede2c4..723402ee7be2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -531,6 +531,38 @@ struct iwl_trans_txq_scd_cfg {
 };
 
 /**
+ * struct iwl_tx_queue_cfg_cmd - txq hw scheduler config command
+ * @token: token of the command
+ * @sta_id: station id
+ * @tid: tid of the queue
+ * @scd_queue: scheduler queue to config
+ * @action: 1 queue enable, 0 queue disable
+ * @aggregate: 1 aggregated queue, 0 otherwise
+ * @tx_fifo: TX fifo
+ * @window: BA window size
+ * @ssn: SSN for the BA agreement
+ * @cb_size: size of TFD cyclic buffer. Value is exponent - 3.
+ *	Minimum value 0 (8 TFDs), maximum value 5 (256 TFDs)
+ * @byte_cnt_addr: address of byte count table
+ * @tfdq_addr: address of TFD circular buffer
+ */
+struct iwl_tx_queue_cfg_cmd {
+	u8 token;
+	u8 sta_id;
+	u8 tid;
+	u8 scd_queue;
+	u8 action;
+	u8 aggregate;
+	u8 tx_fifo;
+	u8 window;
+	__le16 ssn;
+	__le16 reserved;
+	__le32 cb_size;
+	__le64 byte_cnt_addr;
+	__le64 tfdq_addr;
+} __packed; /* TX_QUEUE_CFG_CMD_API_S_VER_1 */
+
+/**
  * struct iwl_trans_ops - transport specific operations
  *
  * All the handlers MUST be implemented
@@ -640,6 +672,12 @@ struct iwl_trans_ops {
 			   unsigned int queue_wdg_timeout);
 	void (*txq_disable)(struct iwl_trans *trans, int queue,
 			    bool configure_scd);
+	/* a000 functions */
+	int (*txq_alloc)(struct iwl_trans *trans,
+			 struct iwl_tx_queue_cfg_cmd *cmd,
+			 int cmd_id,
+			 unsigned int queue_wdg_timeout);
+	void (*txq_free)(struct iwl_trans *trans, int queue);
 
 	void (*txq_set_shared_mode)(struct iwl_trans *trans, u32 txq_id,
 				    bool shared);
@@ -1057,6 +1095,34 @@ iwl_trans_txq_enable_cfg(struct iwl_trans *trans, int queue, u16 ssn,
 	trans->ops->txq_enable(trans, queue, ssn, cfg, queue_wdg_timeout);
 }
 
+static inline void
+iwl_trans_txq_free(struct iwl_trans *trans, int queue)
+{
+	if (WARN_ON_ONCE(!trans->ops->txq_free))
+		return;
+
+	trans->ops->txq_free(trans, queue);
+}
+
+static inline int
+iwl_trans_txq_alloc(struct iwl_trans *trans,
+		    struct iwl_tx_queue_cfg_cmd *cmd,
+		    int cmd_id,
+		    unsigned int queue_wdg_timeout)
+{
+	might_sleep();
+
+	if (WARN_ON_ONCE(!trans->ops->txq_alloc))
+		return -ENOTSUPP;
+
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return -EIO;
+	}
+
+	return trans->ops->txq_alloc(trans, cmd, cmd_id, queue_wdg_timeout);
+}
+
 static inline void iwl_trans_txq_set_shared_mode(struct iwl_trans *trans,
 						 int queue, bool shared_mode)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 98c1308eab0d..5e191579b9a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -758,10 +758,16 @@ void iwl_pcie_apm_config(struct iwl_trans *trans);
 int iwl_pcie_prepare_card_hw(struct iwl_trans *trans);
 void iwl_pcie_synchronize_irqs(struct iwl_trans *trans);
 bool iwl_trans_check_hw_rf_kill(struct iwl_trans *trans);
+void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 				 const struct fw_img *fw, bool run_in_rfkill);
 void iwl_trans_pcie_gen2_fw_alive(struct iwl_trans *trans, u32 scd_addr);
+int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
+				 struct iwl_tx_queue_cfg_cmd *cmd,
+				 int cmd_id,
+				 unsigned int timeout);
+void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue);
 
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 361f0b0a6f42..9cd9c1f5a3dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2923,10 +2923,8 @@ static const struct iwl_trans_ops trans_ops_pcie_gen2 = {
 	.tx = iwl_trans_pcie_tx,
 	.reclaim = iwl_trans_pcie_reclaim,
 
-	.txq_disable = iwl_trans_pcie_txq_disable,
-	.txq_enable = iwl_trans_pcie_txq_enable,
-
-	.txq_set_shared_mode = iwl_trans_pcie_txq_set_shared_mode,
+	.txq_alloc = iwl_trans_pcie_dyn_txq_alloc,
+	.txq_free = iwl_trans_pcie_dyn_txq_free,
 
 	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 	.block_txq_ptrs = iwl_trans_pcie_block_txq_ptrs,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
new file mode 100644
index 000000000000..7c93f266871e
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -0,0 +1,162 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2017 Intel Deutschland GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2017 Intel Deutschland GmbH
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include "iwl-debug.h"
+#include "iwl-csr.h"
+#include "iwl-io.h"
+#include "internal.h"
+
+/*
+ * iwl_pcie_gen2_txq_unmap -  Unmap any remaining DMA mappings and free skb's
+ */
+void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+
+	spin_lock_bh(&txq->lock);
+	while (txq->write_ptr != txq->read_ptr) {
+		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
+				   txq_id, txq->read_ptr);
+
+		iwl_pcie_txq_free_tfd(trans, txq);
+		txq->read_ptr = iwl_queue_inc_wrap(txq->read_ptr);
+
+		if (txq->read_ptr == txq->write_ptr) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&trans_pcie->reg_lock, flags);
+			if (txq_id != trans_pcie->cmd_queue) {
+				IWL_DEBUG_RPM(trans, "Q %d - last tx freed\n",
+					      txq->id);
+				iwl_trans_unref(trans);
+			} else if (trans_pcie->ref_cmd_in_flight) {
+				trans_pcie->ref_cmd_in_flight = false;
+				IWL_DEBUG_RPM(trans,
+					      "clear ref_cmd_in_flight\n");
+				iwl_trans_unref(trans);
+			}
+			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
+		}
+	}
+	spin_unlock_bh(&txq->lock);
+
+	/* just in case - this queue may have been stopped */
+	iwl_wake_queue(trans, txq);
+}
+
+int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
+				 struct iwl_tx_queue_cfg_cmd *cmd,
+				 int cmd_id,
+				 unsigned int timeout)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = &trans_pcie->txq[cmd->scd_queue];
+	struct iwl_host_cmd hcmd = {
+		.id = cmd_id,
+		.len = { sizeof(*cmd) },
+		.data = { cmd, },
+		.flags = 0,
+	};
+	u16 ssn = le16_to_cpu(cmd->ssn);
+
+	if (test_and_set_bit(cmd->scd_queue, trans_pcie->queue_used)) {
+		WARN_ONCE(1, "queue %d already used", cmd->scd_queue);
+		return -EINVAL;
+	}
+
+	txq->wd_timeout = msecs_to_jiffies(timeout);
+
+	/*
+	 * Place first TFD at index corresponding to start sequence number.
+	 * Assumes that ssn_idx is valid (!= 0xFFF)
+	 */
+	txq->read_ptr = (ssn & 0xff);
+	txq->write_ptr = (ssn & 0xff);
+	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
+			   (ssn & 0xff) | (cmd->scd_queue << 8));
+
+	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d WrPtr: %d\n",
+			    cmd->scd_queue, ssn & 0xff);
+
+	cmd->tfdq_addr = cpu_to_le64(txq->dma_addr);
+	cmd->byte_cnt_addr = cpu_to_le64(trans_pcie->scd_bc_tbls.dma +
+					 cmd->scd_queue *
+					 sizeof(struct iwlagn_scd_bc_tbl));
+	cmd->cb_size = cpu_to_le64(TFD_QUEUE_CB_SIZE(TFD_QUEUE_SIZE_MAX));
+
+	return iwl_trans_send_cmd(trans, &hcmd);
+}
+
+void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	trans_pcie->txq[queue].frozen_expiry_remainder = 0;
+	trans_pcie->txq[queue].frozen = false;
+
+	/*
+	 * Upon HW Rfkill - we stop the device, and then stop the queues
+	 * in the op_mode. Just for the sake of the simplicity of the op_mode,
+	 * allow the op_mode to call txq_disable after it already called
+	 * stop_device.
+	 */
+	if (!test_and_clear_bit(queue, trans_pcie->queue_used)) {
+		WARN_ONCE(test_bit(STATUS_DEVICE_ENABLED, &trans->status),
+			  "queue %d not used", queue);
+		return;
+	}
+
+	iwl_pcie_gen2_txq_unmap(trans, queue);
+
+	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", queue);
+}
+
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index b3ac1fb51009..9c903270645c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -456,7 +456,7 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
+void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 {
 	/* rd_ptr is bounded by TFD_QUEUE_SIZE_MAX and
 	 * idx is bounded by n_window
@@ -1359,9 +1359,6 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
-	if (cfg && trans->cfg->use_tfh)
-		WARN_ONCE(1, "Expected no calls to SCD configuration");
-
 	txq->wd_timeout = msecs_to_jiffies(wdg_timeout);
 
 	if (cfg) {
@@ -1477,9 +1474,6 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 		return;
 	}
 
-	if (configure_scd && trans->cfg->use_tfh)
-		WARN_ONCE(1, "Expected no calls to SCD configuration");
-
 	if (configure_scd) {
 		iwl_scd_txq_set_inactive(trans, txq_id);
 
-- 
2.11.0
