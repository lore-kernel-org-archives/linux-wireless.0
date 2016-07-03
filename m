Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60880 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932068AbcGCT7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:59:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:52 +0300
Message-Id: <1467575332-32112-13-git-send-email-luca@coelho.fi> (sfid-20160703_215921_528300_EBC78724)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 13/13] iwlwifi: mvm: handle FRAME_RELEASE in MQ code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For some reason, the FRAME_RELEASE message handling for the
default queue ended up being in the only/default queue for
non-RSS devices; fix that and handle FRAME_RELEASE properly
on the default queue for RSS devices.

Fixes: 585a6fccf5b8 ("iwlwifi: mvm: infrastructure for frame-release message")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ddc4004..632b1dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -967,8 +967,6 @@ static void iwl_mvm_rx(struct iwl_op_mode *op_mode,
 
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
 		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
-	else if (pkt->hdr.cmd == FRAME_RELEASE)
-		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
 	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
 		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
 	else
@@ -987,6 +985,8 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 	else if (unlikely(pkt->hdr.group_id == DATA_PATH_GROUP &&
 			  pkt->hdr.cmd == RX_QUEUES_NOTIFICATION))
 		iwl_mvm_rx_queue_notif(mvm, rxb, 0);
+	else if (pkt->hdr.cmd == FRAME_RELEASE)
+		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
-- 
2.8.1

