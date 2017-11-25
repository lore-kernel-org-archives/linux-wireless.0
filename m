Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47438 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751824AbdKYQew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:52 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:35 +0200
Message-Id: <20171125163444.24258-3-luca@coelho.fi> (sfid-20171125_173457_142840_0D4BB412)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 02/11] iwlwifi: mvm: support MGMT frames in compressed BA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In A000 family, compressed BA notifs can include MGMT
frames, so don't fail RXs in such a case.

While at it, since in A000 the TID for MGMT frames is
15, treat it in the RX flow as if received TID 8. This
way we won't require special handling of this TID.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d88c3685a6dd..0407ea30bb82 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1623,7 +1623,7 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 	int freed;
 
 	if (WARN_ONCE(sta_id >= IWL_MVM_STATION_COUNT ||
-		      tid >= IWL_MAX_TID_COUNT,
+		      tid > IWL_MAX_TID_COUNT,
 		      "sta_id %d tid %d", sta_id, tid))
 		return;
 
@@ -1678,7 +1678,7 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			freed++;
 		else
-			WARN_ON_ONCE(1);
+			WARN_ON_ONCE(tid != IWL_MAX_TID_COUNT);
 
 		iwl_trans_free_tx_cmd(mvm->trans, info->driver_data[1]);
 
@@ -1770,8 +1770,12 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 			struct iwl_mvm_compressed_ba_tfd *ba_tfd =
 				&ba_res->tfd[i];
 
+			tid = ba_tfd->tid;
+			if (tid == IWL_MGMT_TID)
+				tid = IWL_MAX_TID_COUNT;
+
 			mvmsta->tid_data[i].lq_color = lq_color;
-			iwl_mvm_tx_reclaim(mvm, sta_id, ba_tfd->tid,
+			iwl_mvm_tx_reclaim(mvm, sta_id, tid,
 					   (int)(le16_to_cpu(ba_tfd->q_num)),
 					   le16_to_cpu(ba_tfd->tfd_index),
 					   &ba_info,
-- 
2.15.0
