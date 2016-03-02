Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11234 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbcCBH5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/43] iwlwifi: pcie: configure more RFH settings
Date: Wed,  2 Mar 2016 09:56:23 +0200
Message-Id: <1456905404-14435-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085950_315280_B8C11BCB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Fine tune RFH registers further:
* Set default queue explicitly
* Set RFH to drop frames exceeding RB size
* Set the maximum rx transfer size to DRAM to 128 instead of 64

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h  | 24 ++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 12 +++++++++++-
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 4ab6682..8af818b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -368,20 +368,24 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define RFH_RXF_DMA_RBDCB_SIZE_512	(0x9 << RFH_RXF_DMA_RBDCB_SIZE_POS)
 #define RFH_RXF_DMA_RBDCB_SIZE_1024	(0xA << RFH_RXF_DMA_RBDCB_SIZE_POS)
 #define RFH_RXF_DMA_RBDCB_SIZE_2048	(0xB << RFH_RXF_DMA_RBDCB_SIZE_POS)
-#define RFH_RXF_DMA_MIN_RB_SIZE_MASK (0x03000000) /* bit 24-25 */
+#define RFH_RXF_DMA_MIN_RB_SIZE_MASK	(0x03000000) /* bit 24-25 */
 #define RFH_RXF_DMA_MIN_RB_SIZE_POS	24
-#define RFH_RXF_DMA_MIN_RB_4_8	(3 << RFH_RXF_DMA_MIN_RB_SIZE_POS)
-#define RFH_RXF_DMA_SINGLE_FRAME_MASK (0x20000000) /* bit 29 */
-#define RFH_DMA_EN_MASK (0xC0000000) /* bits 30-31*/
-#define RFH_DMA_EN_ENABLE_VAL BIT(31)
+#define RFH_RXF_DMA_MIN_RB_4_8		(3 << RFH_RXF_DMA_MIN_RB_SIZE_POS)
+#define RFH_RXF_DMA_DROP_TOO_LARGE_MASK	(0x04000000) /* bit 26 */
+#define RFH_RXF_DMA_SINGLE_FRAME_MASK	(0x20000000) /* bit 29 */
+#define RFH_DMA_EN_MASK			(0xC0000000) /* bits 30-31*/
+#define RFH_DMA_EN_ENABLE_VAL		BIT(31)
 
 #define RFH_RXF_RXQ_ACTIVE 0xA0980C
 
 #define RFH_GEN_CFG	0xA09800
+#define RFH_GEN_CFG_SERVICE_DMA_SNOOP	BIT(0)
+#define RFH_GEN_CFG_RFH_DMA_SNOOP	BIT(1)
+#define RFH_GEN_CFG_RB_CHUNK_SIZE	BIT(4) /* 0 - 64B, 1- 128B */
 #define RFH_GEN_CFG_DEFAULT_RXQ_NUM_MASK 0xF00
-#define RFH_GEN_CFG_SERVICE_DMA_SNOOP BIT(0)
-#define RFH_GEN_CFG_RFH_DMA_SNOOP BIT(1)
-#define DEFAULT_RXQ_NUM 8
+#define RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS 8
+
+#define DEFAULT_RXQ_NUM			0
 
 /* end of 9000 rx series registers */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index c0db681..398dd93 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -783,16 +783,26 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 	 * Single frame mode
 	 * Rx buffer size 4 or 8k or 12k
 	 * Min RB size 4 or 8
+	 * Drop frames that exceed RB size
 	 * 512 RBDs
 	 */
 	iwl_write_prph(trans, RFH_RXF_DMA_CFG,
 		       RFH_DMA_EN_ENABLE_VAL |
 		       rb_size | RFH_RXF_DMA_SINGLE_FRAME_MASK |
 		       RFH_RXF_DMA_MIN_RB_4_8 |
+		       RFH_RXF_DMA_DROP_TOO_LARGE_MASK |
 		       RFH_RXF_DMA_RBDCB_SIZE_512);
 
+	/*
+	 * Activate DMA snooping.
+	 * Set RX DMA chunk size to 128 bit
+	 * Default queue is 0
+	 */
 	iwl_write_prph(trans, RFH_GEN_CFG, RFH_GEN_CFG_RFH_DMA_SNOOP |
-					  RFH_GEN_CFG_SERVICE_DMA_SNOOP);
+		       RFH_GEN_CFG_RB_CHUNK_SIZE |
+		       (DEFAULT_RXQ_NUM << RFH_GEN_CFG_DEFAULT_RXQ_NUM_POS) |
+		       RFH_GEN_CFG_SERVICE_DMA_SNOOP);
+	/* Enable the relevant rx queues */
 	iwl_write_prph(trans, RFH_RXF_RXQ_ACTIVE, enabled);
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
-- 
2.5.0

