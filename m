Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13470 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbbFCHbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/15] iwlwifi: wrt: add mipi type to debug types
Date: Wed,  3 Jun 2015 10:31:23 +0300
Message-Id: <1433316696-4612-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093150_306604_8BFCB4BD)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

This adds the MIPI mode type to the types declared supported
by the driver. Without this patch, when using MIPI mode and
looking at the logs the user would see the debug destination
"UNKNOWN".

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 2 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h      | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index a8d0b64..5b7c0ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -427,11 +427,13 @@ struct iwl_fw_dbg_reg_op {
  * @SMEM_MODE: monitor stores the data in SMEM
  * @EXTERNAL_MODE: monitor stores the data in allocated DRAM
  * @MARBH_MODE: monitor stores the data in MARBH buffer
+ * @MIPI_MODE: monitor outputs the data through the MIPI interface
  */
 enum iwl_fw_dbg_monitor_mode {
 	SMEM_MODE = 0,
 	EXTERNAL_MODE = 1,
 	MARBH_MODE = 2,
+	MIPI_MODE = 3,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index cf75baf..cdc7f1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -205,6 +205,8 @@ static inline const char *get_fw_dbg_mode_string(int mode)
 		return "EXTERNAL_DRAM";
 	case MARBH_MODE:
 		return "MARBH";
+	case MIPI_MODE:
+		return "MIPI";
 	default:
 		return "UNKNOWN";
 	}
-- 
2.1.4

