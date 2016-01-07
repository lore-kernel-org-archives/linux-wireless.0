Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbcAGMsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 21/21] iwlwifi: pcie: properly configure the debug buffer size for 8000
Date: Thu,  7 Jan 2016 14:47:41 +0200
Message-Id: <1452170861-10060-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134822_482962_9A1CDA80)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

8000 device family has a new debug engine that needs to be
configured differently than 7000's.
The debug engine's DMA works in chunks of memory and the
size of the buffer really means the start of the last
chunk. Since one chunk is 256-byte long, we should
configure the device to write to buffer_size - 256.
This fixes a situation were the device would write to
memory it is not allowed to access.

CC: <stable@vger.kernel.org> [4.1+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3a43109..d60a467 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2007 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -924,9 +926,16 @@ monitor:
 	if (dest->monitor_mode == EXTERNAL_MODE && trans_pcie->fw_mon_size) {
 		iwl_write_prph(trans, le32_to_cpu(dest->base_reg),
 			       trans_pcie->fw_mon_phys >> dest->base_shift);
-		iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
-			       (trans_pcie->fw_mon_phys +
-				trans_pcie->fw_mon_size) >> dest->end_shift);
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
+				       (trans_pcie->fw_mon_phys +
+					trans_pcie->fw_mon_size - 256) >>
+						dest->end_shift);
+		else
+			iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
+				       (trans_pcie->fw_mon_phys +
+					trans_pcie->fw_mon_size) >>
+						dest->end_shift);
 	}
 }
 
-- 
2.5.0

