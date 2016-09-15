Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54886 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753609AbcIOSMv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:29 +0300
Message-Id: <20160915181131.32213-23-luca@coelho.fi> (sfid-20160915_201320_158276_63E8F4E8)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: mvm: make RSS RX more robust
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the firmware ever decides to send any new/more notifications
to the RSS queues, the driver would currently try to interpret
those as REPLY_RX_MPDU_CMD and, if the notification was small,
access invalid memory.

Prevent that by checking for REPLY_RX_MPDU_CMD explicitly which
allows ignoring unexpected notifications.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 55d9096..43ea1e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1672,7 +1672,7 @@ static void iwl_mvm_rx_mq_rss(struct iwl_op_mode *op_mode,
 	else if (unlikely(pkt->hdr.cmd == RX_QUEUES_NOTIFICATION &&
 			  pkt->hdr.group_id == DATA_PATH_GROUP))
 		iwl_mvm_rx_queue_notif(mvm, rxb, queue);
-	else
+	else if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
 		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, queue);
 }
 
-- 
2.9.3
