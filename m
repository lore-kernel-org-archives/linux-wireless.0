Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41048 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754786AbeDWNBl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:01:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, mika.westerberg@intel.com,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 23 Apr 2018 16:01:31 +0300
Message-Id: <20180423130131.29645-1-luca@coelho.fi> (sfid-20180423_150145_686852_00F7F078)
Subject: [PATCH] iwlwifi: mvm: fix old scan version sizes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When version 8 of the scan command API was introduced, only the size
of version 7 was updated, causing older versions of the firmware to
throw BAD_COMMAND errors.

Calculating the old version based on the size of the latest version
got too complicated and the size of the older versions will never
change anyway, so it's better to just hardcoded the sizes.

Fixes: 66fa2424df16 ("iwlwifi: fw api: support the new scan request FW API version")
Reported-by: Scott Register <sreg@sreg.io>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 7af3a0f51b77..a17c4a79b8d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -749,13 +750,9 @@ struct iwl_scan_req_umac {
 } __packed;
 
 #define IWL_SCAN_REQ_UMAC_SIZE_V8 sizeof(struct iwl_scan_req_umac)
-#define IWL_SCAN_REQ_UMAC_SIZE_V7 (sizeof(struct iwl_scan_req_umac) - \
-					 4 * sizeof(u8))
-#define IWL_SCAN_REQ_UMAC_SIZE_V6 (sizeof(struct iwl_scan_req_umac) - \
-				   2 * sizeof(u8) - sizeof(__le16))
-#define IWL_SCAN_REQ_UMAC_SIZE_V1 (sizeof(struct iwl_scan_req_umac) - \
-				   2 * sizeof(__le32) - 2 * sizeof(u8) - \
-				   sizeof(__le16))
+#define IWL_SCAN_REQ_UMAC_SIZE_V7 48
+#define IWL_SCAN_REQ_UMAC_SIZE_V6 44
+#define IWL_SCAN_REQ_UMAC_SIZE_V1 36
 
 /**
  * struct iwl_umac_scan_abort
-- 
2.17.0
