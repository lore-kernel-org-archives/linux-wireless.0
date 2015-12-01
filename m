Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbbLAJ7v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Nicholas Krause <xerofoify@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/41] iwlwifi: mvm: fix incorrect fallthrough in iwl_mvm_check_running_scans()
Date: Tue,  1 Dec 2015 11:58:54 +0200
Message-Id: <1448963947-24302-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105956_840716_58F99927)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nicholas Krause <xerofoify@gmail.com>

In the iwl_mvm_check_running_scans() we were mistakenly ignoring the
value returned by iwl_mvm_scan_stop() for scheduled scans and falling
thorugh to the next case, which caused us to always return zero.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e8a79bf..7cbfb08 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1162,7 +1162,7 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	case IWL_MVM_SCAN_SCHED:
 		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
 			return -EBUSY;
-		iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
+		return iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
 	case IWL_MVM_SCAN_NETDETECT:
 		/* No need to stop anything for net-detect since the
 		 * firmware is restarted anyway.  This way, any sched
-- 
2.5.0

