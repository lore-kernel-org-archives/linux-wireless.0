Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab3GZI3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 19/30] iwlwifi: mvm: Return on inconsistency in add interface
Date: Fri, 26 Jul 2013 10:28:36 +0200
Message-Id: <1374827327-3464-20-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103019_532120_AFEDA717)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Return in case that HW restart is in progress but the added
interface is not found during the iteration over all the interfaces.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 94aae9c..5fe23a5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -264,7 +264,8 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		return 0;
 
 	/* Therefore, in recovery, we can't get here */
-	WARN_ON_ONCE(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status));
+	if (WARN_ON_ONCE(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)))
+		return -EBUSY;
 
 	mvmvif->id = find_first_bit(data.available_mac_ids,
 				    NUM_MAC_INDEX_DRIVER);
-- 
1.8.0

