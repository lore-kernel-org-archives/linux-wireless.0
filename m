Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39548 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754755AbeDMMoR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:44:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:45 +0300
Message-Id: <20180413124256.21769-15-luca@coelho.fi> (sfid-20180413_144419_825068_2221DA37)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: pcie: use the queue size as sent by opmode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Op mode will begin tp use varying size of TX queue.
All the infra is in place, allow it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b3d151ec8fe4..a235dda1f70b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1067,12 +1067,12 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 		return -ENOMEM;
 	}
 
-	ret = iwl_pcie_txq_alloc(trans, txq, TFD_TX_CMD_SLOTS, false);
+	ret = iwl_pcie_txq_alloc(trans, txq, size, false);
 	if (ret) {
 		IWL_ERR(trans, "Tx queue alloc failed\n");
 		goto error;
 	}
-	ret = iwl_pcie_txq_init(trans, txq, TFD_TX_CMD_SLOTS, false);
+	ret = iwl_pcie_txq_init(trans, txq, size, false);
 	if (ret) {
 		IWL_ERR(trans, "Tx queue init failed\n");
 		goto error;
@@ -1082,7 +1082,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 
 	cmd->tfdq_addr = cpu_to_le64(txq->dma_addr);
 	cmd->byte_cnt_addr = cpu_to_le64(txq->bc_tbl.dma);
-	cmd->cb_size = cpu_to_le32(TFD_QUEUE_CB_SIZE(TFD_TX_CMD_SLOTS));
+	cmd->cb_size = cpu_to_le32(TFD_QUEUE_CB_SIZE(size));
 
 	ret = iwl_trans_send_cmd(trans, &hcmd);
 	if (ret)
-- 
2.16.3
