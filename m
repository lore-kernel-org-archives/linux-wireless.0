Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03423C10F06
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6BF021473
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfDCJWf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:35 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49708 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726427AbfDCJWf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:35 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6L-0007aR-9g; Wed, 03 Apr 2019 12:22:34 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:14 +0300
Message-Id: <20190403092224.815-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/13] iwlwifi: unite macros with same meaning
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

TFD_*_SLOTS and IWL_*_QUEUE_SIZE both define the TX queue
size (number of TFDs).
Get rid of TFD_*_SLOTS and use only IWL_*_QUEUE_SIZE.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h          | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c | 3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c      | 6 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h       | 4 ----
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c     | 7 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c             | 8 ++++----
 6 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
index 6ac240b6eace..73196cbc7fbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -133,6 +135,7 @@ enum iwl_tx_queue_cfg_actions {
 
 #define IWL_DEFAULT_QUEUE_SIZE 256
 #define IWL_MGMT_QUEUE_SIZE 16
+#define IWL_CMD_QUEUE_SIZE 32
 /**
  * struct iwl_tx_queue_cfg_cmd - txq hw scheduler config command
  * @sta_id: station id
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 1e36459948db..f496d1bcb643 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -66,7 +66,8 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	void *iml_img;
 	u32 control_flags = 0;
 	int ret;
-	int cmdq_size = max_t(u32, TFD_CMD_SLOTS, trans->cfg->min_txq_size);
+	int cmdq_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
+			      trans->cfg->min_txq_size);
 
 	/* Allocate prph scratch */
 	prph_scratch = dma_alloc_coherent(trans->dev, sizeof(*prph_scratch),
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 9274e317cc77..8969b47bacf2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -20,7 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -210,7 +210,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 	ctxt_info->hcmd_cfg.cmd_queue_addr =
 		cpu_to_le64(trans_pcie->txq[trans_pcie->cmd_queue]->dma_addr);
 	ctxt_info->hcmd_cfg.cmd_queue_size =
-		TFD_QUEUE_CB_SIZE(TFD_CMD_SLOTS);
+		TFD_QUEUE_CB_SIZE(IWL_CMD_QUEUE_SIZE);
 
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_init_fw_sec(trans, fw, &ctxt_info->dram);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 860259e65553..88265e2f4763 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -290,10 +290,6 @@ struct iwl_cmd_meta {
 	u32 tbs;
 };
 
-
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
 /*
  * The FH will write back to the first TB only, so we need to copy some data
  * into the buffer regardless of whether it should be mapped or not.
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 9c203ca75de9..8507a7bdcfdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -20,7 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -234,7 +234,8 @@ void iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 static int iwl_pcie_gen2_nic_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int queue_size = max_t(u32, TFD_CMD_SLOTS, trans->cfg->min_txq_size);
+	int queue_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
+			       trans->cfg->min_txq_size);
 
 	/* TODO: most of the logic can be removed in A0 - but not in Z0 */
 	spin_lock(&trans_pcie->irq_lock);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index bb0fc1c2b4f2..e68c67e59aab 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -996,10 +996,10 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 		bool cmd_queue = (txq_id == trans_pcie->cmd_queue);
 
 		if (cmd_queue)
-			slots_num = max_t(u32, TFD_CMD_SLOTS,
+			slots_num = max_t(u32, IWL_CMD_QUEUE_SIZE,
 					  trans->cfg->min_txq_size);
 		else
-			slots_num = max_t(u32, TFD_TX_CMD_SLOTS,
+			slots_num = max_t(u32, IWL_DEFAULT_QUEUE_SIZE,
 					  trans->cfg->min_256_ba_txq_size);
 		trans_pcie->txq[txq_id] = &trans_pcie->txq_memory[txq_id];
 		ret = iwl_pcie_txq_alloc(trans, trans_pcie->txq[txq_id],
@@ -1050,10 +1050,10 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		bool cmd_queue = (txq_id == trans_pcie->cmd_queue);
 
 		if (cmd_queue)
-			slots_num = max_t(u32, TFD_CMD_SLOTS,
+			slots_num = max_t(u32, IWL_CMD_QUEUE_SIZE,
 					  trans->cfg->min_txq_size);
 		else
-			slots_num = max_t(u32, TFD_TX_CMD_SLOTS,
+			slots_num = max_t(u32, IWL_DEFAULT_QUEUE_SIZE,
 					  trans->cfg->min_256_ba_txq_size);
 		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
 					slots_num, cmd_queue);
-- 
2.20.1

