Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1KRBA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 20:00:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlwifi: check the HW when a queue is stuck
Date: Thu, 17 Nov 2011 16:05:09 -0800
Message-Id: <1321574713-12076-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111118_020036_412648_4FFFBA5C)
In-Reply-To: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add more information when a queue is stuck and actually get
information from the scheduler instead of looking at internal
variables.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index a1a5833..3f2ceb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1515,8 +1515,12 @@ static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
 	if (time_after(jiffies, timeout)) {
 		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
 			hw_params(trans).wd_timeout);
-		IWL_ERR(trans, "Current read_ptr %d write_ptr %d\n",
+		IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 			q->read_ptr, q->write_ptr);
+		IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
+			iwl_read_prph(bus(trans), SCD_QUEUE_RDPTR(cnt))
+				& (TFD_QUEUE_SIZE_MAX - 1),
+			iwl_read_prph(bus(trans), SCD_QUEUE_WRPTR(cnt)));
 		return 1;
 	}
 
-- 
1.7.0.4

