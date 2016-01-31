Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbcAaLGu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/31] iwlwifi: mvm: add debug print if scan config is ignored
Date: Sun, 31 Jan 2016 13:06:15 +0200
Message-Id: <1454238386-27032-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123654_700948_00E39462)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

Print a debug message in iwl_mvm_config_scan() if a scan configuration
data is decided not to be sent to FW.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 0476e76..1e1ab9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -930,8 +930,11 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
 		return -ENOBUFS;
 
-	if (type == mvm->scan_type)
+	if (type == mvm->scan_type) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Ignoring UMAC scan config of the same type\n");
 		return 0;
+	}
 
 	cmd_size = sizeof(*scan_config) + mvm->fw->ucode_capa.n_scan_channels;
 
-- 
2.5.0

