Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22835 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965572AbbD1MnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/8] iwlwifi: pcie: prevent using unmapped memory in fw monitor
Date: Tue, 28 Apr 2015 15:43:09 +0300
Message-Id: <1430224992-20327-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144331_003759_BCF03CCC)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In the case of a DMA mapping error on the last iteration of
the loop of the allocation of memory of the FW monitor we
indeed free the pages, but don't NULL out the page variable
thus allowing for the possibility of setting the FW monitor
variables with invalid data to use.

Fixes: c2d202017da1 ("iwlwifi: pcie: add firmware monitor capabilities")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 2de8fbf..6debb0c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -5,8 +5,8 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2007 - 2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,8 +31,8 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2005 - 2015 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -104,7 +104,7 @@ static void iwl_pcie_free_fw_monitor(struct iwl_trans *trans)
 static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct page *page;
+	struct page *page = NULL;
 	dma_addr_t phys;
 	u32 size;
 	u8 power;
@@ -131,6 +131,7 @@ static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans)
 				    DMA_FROM_DEVICE);
 		if (dma_mapping_error(trans->dev, phys)) {
 			__free_pages(page, order);
+			page = NULL;
 			continue;
 		}
 		IWL_INFO(trans,
-- 
2.1.0

