Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbbCATcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/31] iwlwifi: mvm: use only 40 ms for fragmented scan
Date: Sun,  1 Mar 2015 21:31:35 +0200
Message-Id: <1425238304-498-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_847087_AD554C87)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

20 ms fragments are no longer required by system.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index ca3a187..c8377e1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -230,7 +230,7 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 			 * If there is more than one active interface make
 			 * passive scan more fragmented.
 			 */
-			frag_passive_dwell = (global_cnt < 2) ? 40 : 20;
+			frag_passive_dwell = 40;
 			params->max_out_time = frag_passive_dwell;
 		} else {
 			params->suspend_time = 120;
-- 
1.9.1

