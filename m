Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59472 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751373AbdFEUoP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:44:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Mordechai Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:16 +0300
Message-Id: <20170605204218.30151-24-luca@coelho.fi> (sfid-20170605_224445_411576_B5BDF0F2)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: fw-api: cleanup cycle includes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechai Goodstein <mordechay.goodstein@intel.com>

The include in the deleted file are included in the fw-api.h file.
Which caused a cycle include in the dependencies.

Signed-off-by: Mordechai Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h | 2 --
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index dded91d7eb96..d27c67b67015 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -68,8 +68,6 @@
 #ifndef __fw_api_scan_h__
 #define __fw_api_scan_h__
 
-#include "fw-api.h"
-
 /* Scan Commands, Responses, Notifications */
 
 /* Max number of IEs for direct SSID scans in a command */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h
index eae036af880e..e2acf39f784d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h
@@ -63,8 +63,6 @@
 #ifndef __fw_api_tof_h__
 #define __fw_api_tof_h__
 
-#include "fw-api.h"
-
 /* ToF sub-group command IDs */
 enum iwl_mvm_tof_sub_grp_ids {
 	TOF_RANGE_REQ_CMD = 0x1,
-- 
2.11.0
