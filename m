Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55828 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932338AbcISHal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:07 +0300
Message-Id: <20160919073028.22065-4-luca@coelho.fi> (sfid-20160919_093049_788882_4C44318A)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: compare full command ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When comparing command IDs, the group should be taken
into account so the same command/notification from a
different group doesn't trigger anything unexpected.
Fix this by comparing to the wide ID.

Fixes: commit 1738d60b31d7 ("iwlwifi: mvm: handle RX MPDUs separately")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 43ea1e5..de34c9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -966,10 +966,11 @@ static void iwl_mvm_rx(struct iwl_op_mode *op_mode,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	u16 cmd = WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd);
 
-	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
+	if (likely(cmd == WIDE_ID(LEGACY_GROUP, REPLY_RX_MPDU_CMD)))
 		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
-	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
+	else if (cmd == WIDE_ID(LEGACY_GROUP, REPLY_RX_PHY_CMD))
 		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
@@ -981,13 +982,14 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	u16 cmd = WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd);
 
-	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
+	if (likely(cmd == WIDE_ID(LEGACY_GROUP, REPLY_RX_MPDU_CMD)))
 		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, 0);
-	else if (unlikely(pkt->hdr.group_id == DATA_PATH_GROUP &&
-			  pkt->hdr.cmd == RX_QUEUES_NOTIFICATION))
+	else if (unlikely(cmd == WIDE_ID(DATA_PATH_GROUP,
+					 RX_QUEUES_NOTIFICATION)))
 		iwl_mvm_rx_queue_notif(mvm, rxb, 0);
-	else if (pkt->hdr.cmd == FRAME_RELEASE)
+	else if (cmd == WIDE_ID(LEGACY_GROUP, FRAME_RELEASE))
 		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
@@ -1666,13 +1668,14 @@ static void iwl_mvm_rx_mq_rss(struct iwl_op_mode *op_mode,
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u16 cmd = WIDE_ID(pkt->hdr.group_id, pkt->hdr.cmd);
 
-	if (unlikely(pkt->hdr.cmd == FRAME_RELEASE))
+	if (unlikely(cmd == WIDE_ID(LEGACY_GROUP, FRAME_RELEASE)))
 		iwl_mvm_rx_frame_release(mvm, napi, rxb, queue);
-	else if (unlikely(pkt->hdr.cmd == RX_QUEUES_NOTIFICATION &&
-			  pkt->hdr.group_id == DATA_PATH_GROUP))
+	else if (unlikely(cmd == WIDE_ID(DATA_PATH_GROUP,
+					 RX_QUEUES_NOTIFICATION)))
 		iwl_mvm_rx_queue_notif(mvm, rxb, queue);
-	else if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
+	else if (likely(cmd == WIDE_ID(LEGACY_GROUP, REPLY_RX_MPDU_CMD)))
 		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, queue);
 }
 
-- 
2.9.3
