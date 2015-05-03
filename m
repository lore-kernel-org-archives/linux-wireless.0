Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbECTd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/42] iwlwifi: mvm: include wildcard SSID in scans
Date: Sun,  3 May 2015 22:31:53 +0300
Message-Id: <1430681513-7838-42-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213356_607957_01F19DEB)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Fix a copy paste bug that didn't copy wildcard SSIDs to
scan requests. This bug causes scan with only wildcard
SSID to be passive, and scans with more than one SSID to
send only the direct probes.

Fixes: 2a28ac14c518 ("iwlwifi: mvm: add common scan params to thw iwl_mvm_scan_params struct")
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 3c33d61..e50fd3f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -452,8 +452,6 @@ static void iwl_scan_build_ssids(struct iwl_mvm_scan_params *params,
 				       params->ssids[j].ssid_len,
 				       ssids);
 		if (index < 0) {
-			if (!params->ssids[j].ssid_len)
-				continue;
 			ssids[i].id = WLAN_EID_SSID;
 			ssids[i].len = params->ssids[j].ssid_len;
 			memcpy(ssids[i].ssid, params->ssids[j].ssid,
-- 
2.1.0

