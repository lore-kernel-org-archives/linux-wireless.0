Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51370 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751803AbdDMP0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:26:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:56 +0300
Message-Id: <20170413152507.9648-16-luca@coelho.fi> (sfid-20170413_172624_883962_636CD2B2)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 15/26] iwlwifi: mvm: remove unnecessary debugging from UMAC scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There are several occasions where a scan of the same type is requested
concurrently, so logging every time this happens is just noisy and
unnecessary.  Remove the logging for these cases.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index ce6a2b3b021e..9668f945b4e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1037,11 +1037,8 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
 		return -ENOBUFS;
 
-	if (type == mvm->scan_type) {
-		IWL_DEBUG_SCAN(mvm,
-			       "Ignoring UMAC scan config of the same type\n");
+	if (type == mvm->scan_type)
 		return 0;
-	}
 
 	if (iwl_mvm_has_new_tx_api(mvm))
 		cmd_size = sizeof(struct iwl_scan_config);
-- 
2.11.0
