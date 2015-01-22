Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbbAVUdw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/38] iwlwifi: mvm: set max_out_time equal to frag_passive_dwell in fragmented scan
Date: Thu, 22 Jan 2015 22:33:00 +0200
Message-Id: <1421958809-3371-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213404_677995_E6280B0B)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Fragmented scan should be applied for all channels, passive and active.
When scanning on passive channels the firmware uses frag_passive_dwell
to define the maximum continuous scan time before returning to the
operating channel. On active channels max_out_time is the parameter
used by the firmware to define the maximum time allowed out of the
operating channel. Since active channels' scan should also be fragmented
set max_out_time equal to frag_passive_dwell.
In addition:
- Set max_out_time and suspend_time if the firmware doesn't support
  fragmented scan to avoid unexpected behavior.
- Adjust max_out_time for second level of scan precedence.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 199f6fc..0ee0f81 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -309,18 +309,18 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		goto not_bound;
 
 	params->suspend_time = 30;
-	params->max_out_time = 170;
+	params->max_out_time = 120;
 
 	if (iwl_mvm_low_latency(mvm)) {
 		if (mvm->fw->ucode_capa.api[0] &
 		    IWL_UCODE_TLV_API_FRAGMENTED_SCAN) {
 			params->suspend_time = 105;
-			params->max_out_time = 70;
 			/*
 			 * If there is more than one active interface make
 			 * passive scan more fragmented.
 			 */
 			frag_passive_dwell = (global_cnt < 2) ? 40 : 20;
+			params->max_out_time = frag_passive_dwell;
 		} else {
 			params->suspend_time = 120;
 			params->max_out_time = 120;
-- 
1.9.1

