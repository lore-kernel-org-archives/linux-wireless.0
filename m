Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55984 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936248AbcISHby (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:18 +0300
Message-Id: <20160919073028.22065-15-luca@coelho.fi> (sfid-20160919_093156_991367_C50BBF61)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm: document passing unexpected Block Ack Request frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we get an unexpected Block Ack Request frame, the BAID from
the hardware will be invalid, and we'll pass it to mac80211 for
further handling (sending a delBA action frame.)

Add a comment explaining that, in case anyone looks in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 0274f14..a57c6ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -591,6 +591,11 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	baid = (reorder & IWL_RX_MPDU_REORDER_BAID_MASK) >>
 		IWL_RX_MPDU_REORDER_BAID_SHIFT;
 
+	/*
+	 * This also covers the case of receiving a Block Ack Request
+	 * outside a BA session; we'll pass it to mac80211 and that
+	 * then sends a delBA action frame.
+	 */
 	if (baid == IWL_RX_REORDER_DATA_INVALID_BAID)
 		return false;
 
-- 
2.9.3
