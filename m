Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C08DC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE51821929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394471AbfBOLtc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60368 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727457AbfBOLtc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:32 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzm-0008TN-2m; Fri, 15 Feb 2019 13:49:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:05 +0200
Message-Id: <20190215114924.2545-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/20] iwlwifi: pcie: allocate rb_stts's for all queues in one place
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Triebitz <shaul.triebitz@intel.com>

AX210 devices assume that the (DRAM) addresses of the rb_stts's for
the different queues are continuous.
So allocate the rb_stts's for all the Rx queues in one place.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  9 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 66 ++++++++++++++-----
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 0ecd90d050e6..bf8b61a476c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -526,6 +526,8 @@ struct cont_rec {
  * @fh_mask: current unmasked fh causes
  * @hw_mask: current unmasked hw causes
  * @in_rescan: true if we have triggered a device rescan
+ * @base_rb_stts: base virtual address of receive buffer status for all queues
+ * @base_rb_stts_dma: base physical address of receive buffer status
  */
 struct iwl_trans_pcie {
 	struct iwl_rxq *rxq;
@@ -617,6 +619,9 @@ struct iwl_trans_pcie {
 	cpumask_t affinity_mask[IWL_MAX_RX_HW_QUEUES];
 	u16 tx_cmd_queue_size;
 	bool in_rescan;
+
+	void *base_rb_stts;
+	dma_addr_t base_rb_stts_dma;
 };
 
 static inline struct iwl_trans_pcie *
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 38844215a58e..8d4f0628622b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -702,11 +702,6 @@ static void iwl_pcie_free_rxq_dma(struct iwl_trans *trans,
 	rxq->bd_dma = 0;
 	rxq->bd = NULL;
 
-	if (rxq->rb_stts)
-		dma_free_coherent(trans->dev,
-				  use_rx_td ? sizeof(__le16) :
-				  sizeof(struct iwl_rb_status),
-				  rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->rb_stts_dma = 0;
 	rxq->rb_stts = NULL;
 
@@ -743,6 +738,8 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 	int free_size;
 	bool use_rx_td = (trans->cfg->device_family >=
 			  IWL_DEVICE_FAMILY_22560);
+	size_t rb_stts_size = use_rx_td ? sizeof(__le16) :
+			      sizeof(struct iwl_rb_status);
 
 	spin_lock_init(&rxq->lock);
 	if (trans->cfg->mq_rx_supported)
@@ -770,12 +767,9 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 			goto err;
 	}
 
-	/* Allocate the driver's pointer to receive buffer status */
-	rxq->rb_stts = dma_alloc_coherent(dev,
-					  use_rx_td ? sizeof(__le16) : sizeof(struct iwl_rb_status),
-					  &rxq->rb_stts_dma, GFP_KERNEL);
-	if (!rxq->rb_stts)
-		goto err;
+	rxq->rb_stts = trans_pcie->base_rb_stts + rxq->id * rb_stts_size;
+	rxq->rb_stts_dma =
+		trans_pcie->base_rb_stts_dma + rxq->id * rb_stts_size;
 
 	if (!use_rx_td)
 		return 0;
@@ -805,7 +799,6 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 
 		iwl_pcie_free_rxq_dma(trans, rxq);
 	}
-	kfree(trans_pcie->rxq);
 
 	return -ENOMEM;
 }
@@ -815,6 +808,9 @@ int iwl_pcie_rx_alloc(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	int i, ret;
+	size_t rb_stts_size = trans->cfg->device_family >=
+			      IWL_DEVICE_FAMILY_22560 ?
+			      sizeof(__le16) : sizeof(struct iwl_rb_status);
 
 	if (WARN_ON(trans_pcie->rxq))
 		return -EINVAL;
@@ -822,18 +818,46 @@ int iwl_pcie_rx_alloc(struct iwl_trans *trans)
 	trans_pcie->rxq = kcalloc(trans->num_rx_queues, sizeof(struct iwl_rxq),
 				  GFP_KERNEL);
 	if (!trans_pcie->rxq)
-		return -EINVAL;
+		return -ENOMEM;
 
 	spin_lock_init(&rba->lock);
 
+	/*
+	 * Allocate the driver's pointer to receive buffer status.
+	 * Allocate for all queues continuously (HW requirement).
+	 */
+	trans_pcie->base_rb_stts =
+			dma_alloc_coherent(trans->dev,
+					   rb_stts_size * trans->num_rx_queues,
+					   &trans_pcie->base_rb_stts_dma,
+					   GFP_KERNEL);
+	if (!trans_pcie->base_rb_stts) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	for (i = 0; i < trans->num_rx_queues; i++) {
 		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
 
+		rxq->id = i;
 		ret = iwl_pcie_alloc_rxq_dma(trans, rxq);
 		if (ret)
-			return ret;
+			goto err;
 	}
 	return 0;
+
+err:
+	if (trans_pcie->base_rb_stts) {
+		dma_free_coherent(trans->dev,
+				  rb_stts_size * trans->num_rx_queues,
+				  trans_pcie->base_rb_stts,
+				  trans_pcie->base_rb_stts_dma);
+		trans_pcie->base_rb_stts = NULL;
+		trans_pcie->base_rb_stts_dma = 0;
+	}
+	kfree(trans_pcie->rxq);
+
+	return ret;
 }
 
 static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
@@ -1042,8 +1066,6 @@ int _iwl_pcie_rx_init(struct iwl_trans *trans)
 	for (i = 0; i < trans->num_rx_queues; i++) {
 		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
 
-		rxq->id = i;
-
 		spin_lock(&rxq->lock);
 		/*
 		 * Set read write pointer to reflect that we have processed
@@ -1130,6 +1152,9 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
 	int i;
+	size_t rb_stts_size = trans->cfg->device_family >=
+			      IWL_DEVICE_FAMILY_22560 ?
+			      sizeof(__le16) : sizeof(struct iwl_rb_status);
 
 	/*
 	 * if rxq is NULL, it means that nothing has been allocated,
@@ -1144,6 +1169,15 @@ void iwl_pcie_rx_free(struct iwl_trans *trans)
 
 	iwl_pcie_free_rbs_pool(trans);
 
+	if (trans_pcie->base_rb_stts) {
+		dma_free_coherent(trans->dev,
+				  rb_stts_size * trans->num_rx_queues,
+				  trans_pcie->base_rb_stts,
+				  trans_pcie->base_rb_stts_dma);
+		trans_pcie->base_rb_stts = NULL;
+		trans_pcie->base_rb_stts_dma = 0;
+	}
+
 	for (i = 0; i < trans->num_rx_queues; i++) {
 		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
 
-- 
2.20.1

