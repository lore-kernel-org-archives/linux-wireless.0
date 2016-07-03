Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60804 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbcGCTtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:44 +0300
Message-Id: <1467575332-32112-5-git-send-email-luca@coelho.fi> (sfid-20160703_214918_015056_24180CDA)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 05/13] iwlwifi: mvm: remove RX_PHY support for 9000 device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In multiple RX queues architecture, the RX_PHY notification
is no longer useful as it is received in the default queue
even for packets that are received on RSS queue, and cannot
be accessed without locking.
All the needed data is in the new RX packet metadata and
firmware will no longer send this notification for 9000
devices. Remove support of it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 13 -------------
 3 files changed, 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4843e02..dd0b8f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1321,7 +1321,6 @@ bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
 void iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb);
-void iwl_mvm_rx_phy_cmd_mq(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue);
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 64d2b4f..55f114d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -958,8 +958,6 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
 		iwl_mvm_rx_mpdu_mq(mvm, napi, rxb, 0);
-	else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD)
-		iwl_mvm_rx_phy_cmd_mq(mvm, rxb);
 	else if (unlikely(pkt->hdr.group_id == DATA_PATH_GROUP &&
 			  pkt->hdr.cmd == RX_QUEUES_NOTIFICATION))
 		iwl_mvm_rx_queue_notif(mvm, rxb, 0);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 0f26c70..67924fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -65,19 +65,6 @@
 #include "fw-api.h"
 #include "fw-dbg.h"
 
-void iwl_mvm_rx_phy_cmd_mq(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
-{
-	mvm->ampdu_ref++;
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->last_phy_info.phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_AGG)) {
-		spin_lock(&mvm->drv_stats_lock);
-		mvm->drv_rx_stats.ampdu_count++;
-		spin_unlock(&mvm->drv_stats_lock);
-	}
-#endif
-}
-
 static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
 				   int queue, struct ieee80211_sta *sta)
 {
-- 
2.8.1

