Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51442 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754653AbdDMP1J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:27:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:25:03 +0300
Message-Id: <20170413152507.9648-23-luca@coelho.fi> (sfid-20170413_172714_207355_49E9342F)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 22/26] iwlwifi: pcie: support new write pointer width
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 devices we have 16 bytes for the TFD index and 16 for the
queue, in order to support 512 queues.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index af5b97c82c5e..e8eb11282795 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -109,7 +109,7 @@ static void iwl_pcie_gen2_txq_inc_wr_ptr(struct iwl_trans *trans,
 	 */
 	if (!txq->block)
 		iwl_write32(trans, HBUS_TARG_WRPTR,
-			    txq->write_ptr | (txq->id << 8));
+			    txq->write_ptr | (txq->id << 16));
 }
 
 static u8 iwl_pcie_gen2_get_num_tbs(struct iwl_trans *trans,
@@ -825,7 +825,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 	txq->read_ptr = (ssn & 0xff);
 	txq->write_ptr = (ssn & 0xff);
 	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-			   (ssn & 0xff) | (cmd->scd_queue << 8));
+			   (ssn & 0xff) | (cmd->scd_queue << 16));
 
 	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d WrPtr: %d\n",
 			    cmd->scd_queue, ssn & 0xff);
-- 
2.11.0
