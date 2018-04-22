Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40926 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751990AbeDVI2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:28:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:45 +0300
Message-Id: <20180422082745.9743-13-luca@coelho.fi> (sfid-20180422_102845_392433_6214FADA)
In-Reply-To: <20180422082745.9743-1-luca@coelho.fi>
References: <20180422082745.9743-1-luca@coelho.fi>
Subject: [PATCH 12/12] iwlwifi: mvm: set wakeup filters for wowlan "any" configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

In can of "any" wowlan trigger is configured, no valid wakeup filter
was configured.

Moreover, the fw assumes there's no connection when there are no configured
wakeup filters.
This leads to the station info not being updated on D3 command, causing
rate_n_flags to be 0 when the offloading code sends tx frame (triggering
SYSASSERT_102C due to invalid antenna param)

Note: "any" trigger is currently assumed to only be used when entering
d0i3 (which has a different flow). However, we still reach this code
when using d3_test.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 80a9a7cb83be..3fcf489f3120 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,11 +19,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
  *
@@ -35,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -693,6 +690,14 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 				    IWL_WOWLAN_WAKEUP_LINK_CHANGE);
 	}
 
+	if (wowlan->any) {
+		wowlan_config_cmd->wakeup_filter |=
+			cpu_to_le32(IWL_WOWLAN_WAKEUP_BEACON_MISS |
+				    IWL_WOWLAN_WAKEUP_LINK_CHANGE |
+				    IWL_WOWLAN_WAKEUP_RX_FRAME |
+				    IWL_WOWLAN_WAKEUP_BCN_FILTERING);
+	}
+
 	return 0;
 }
 
-- 
2.17.0
