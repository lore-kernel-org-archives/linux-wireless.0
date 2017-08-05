Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42580 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHEToe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:27 +0300
Message-Id: <20170805194331.17426-16-luca@coelho.fi> (sfid-20170805_214437_172389_2DD3B0E3)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 15/19] iwlwifi: pcie: don't init a Tx queue with an SSN > size of the queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The TVQM tells us the initial write pointer for a queue,
but that write pointer is in WiFi sequence number unit
and not in TFD index unit. Which means that the write
pointer in the TVQM's response can be bigger than the
Tx queue ring size.

Fix that by modulo'ing the write pointer from the TVQM
with the Tx queue size.

Fixes: 66128fa08806 ("iwlwifi: move to TVQM mode")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 5dc785d4c167..83a28892dc4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1033,6 +1033,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 		.flags = CMD_WANT_SKB,
 	};
 	int ret, qid;
+	u32 wr_ptr;
 
 	txq = kzalloc(sizeof(*txq), GFP_KERNEL);
 	if (!txq)
@@ -1073,6 +1074,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 
 	rsp = (void *)hcmd.resp_pkt->data;
 	qid = le16_to_cpu(rsp->queue_number);
+	wr_ptr = le16_to_cpu(rsp->write_pointer);
 
 	if (qid >= ARRAY_SIZE(trans_pcie->txq)) {
 		WARN_ONCE(1, "queue index %d unsupported", qid);
@@ -1088,10 +1090,11 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 
 	txq->id = qid;
 	trans_pcie->txq[qid] = txq;
+	wr_ptr &= (TFD_QUEUE_SIZE_MAX - 1);
 
 	/* Place first TFD at index corresponding to start sequence number */
-	txq->read_ptr = le16_to_cpu(rsp->write_pointer);
-	txq->write_ptr = le16_to_cpu(rsp->write_pointer);
+	txq->read_ptr = wr_ptr;
+	txq->write_ptr = wr_ptr;
 	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 			   (txq->write_ptr) | (qid << 16));
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d\n", qid);
-- 
2.13.2
