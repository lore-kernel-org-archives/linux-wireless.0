Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52126 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752173AbeF3NXn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:23:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:22 +0300
Message-Id: <20180630132330.14928-8-luca@coelho.fi> (sfid-20180630_152359_100218_48A47110)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 07/15] iwlwifi: pcie: update bytes in the byte count table
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

For devices which use the image loader image, the length of the frame
must be updated in the byte count in bytes, and not dwords as today.
Avoid dividing the input length by 4.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index aa11b35d6f51..5d9b9306ea1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -708,7 +708,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 
 	trans->wide_cmd_header = true;
-	trans_cfg.bc_table_dword = true;
+	trans_cfg.bc_table_dword =
+		mvm->trans->cfg->device_family < IWL_DEVICE_FAMILY_22560;
 
 	trans_cfg.command_groups = iwl_mvm_groups;
 	trans_cfg.command_groups_size = ARRAY_SIZE(iwl_mvm_groups);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 48890a1c825f..5f05bcb26776 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -19,6 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -84,7 +86,8 @@ void iwl_pcie_gen2_tx_stop(struct iwl_trans *trans)
 /*
  * iwl_pcie_txq_update_byte_tbl - Set up entry in Tx byte-count array
  */
-static void iwl_pcie_gen2_update_byte_tbl(struct iwl_txq *txq, u16 byte_cnt,
+static void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
+					  struct iwl_txq *txq, u16 byte_cnt,
 					  int num_tbs)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl = txq->bc_tbl.addr;
@@ -93,7 +96,8 @@ static void iwl_pcie_gen2_update_byte_tbl(struct iwl_txq *txq, u16 byte_cnt,
 	u16 len = byte_cnt;
 	__le16 bc_ent;
 
-	len = DIV_ROUND_UP(len, 4);
+	if (trans_pcie->bc_table_dword)
+		len = DIV_ROUND_UP(len, 4);
 
 	if (WARN_ON(len > 0xFFF || idx >= txq->n_window))
 		return;
@@ -526,7 +530,7 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	iwl_pcie_gen2_update_byte_tbl(txq, le16_to_cpu(tx_cmd->len),
+	iwl_pcie_gen2_update_byte_tbl(trans_pcie, txq, le16_to_cpu(tx_cmd->len),
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
 
 	/* start timer if queue currently empty */
-- 
2.18.0
