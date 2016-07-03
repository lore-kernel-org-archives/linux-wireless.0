Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60784 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbcGCTtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:41 +0300
Message-Id: <1467575332-32112-2-git-send-email-luca@coelho.fi> (sfid-20160703_214921_095211_F1438F9E)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 02/13] iwlwifi: mvm: do not trust NSSN for amsdu sub-frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We cannot trust NSSN for AMSDU sub-frames that are not the
last.
The reason is that NSSN advances on the first sub-frame,
and may cause the reorder buffer to advance before all the
sub-frames arrive.
Example:
Reorder buffer contains SN 0 & 2.
We receive AMSDU with SN 1 and NSSN for first sub frame 3.
The result us that driver releases SN 0,1, 2.
When sub-frame 1 arrives - reorder buffer is already ahead and
it will be dropped.
If the last sub-frame is not on this queue - we will get frame
release notification with up to date NSSN.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index ac2c571..0f26c70 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -587,6 +587,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	struct sk_buff *tail;
 	u32 reorder = le32_to_cpu(desc->reorder_data);
 	bool amsdu = desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU;
+	bool last_subframe =
+		desc->amsdu_info & IWL_RX_MPDU_AMSDU_LAST_SUBFRAME;
 	u8 tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 	u8 sub_frame_idx = desc->amsdu_info &
 			   IWL_RX_MPDU_AMSDU_SUBFRAME_IDX_MASK;
@@ -651,7 +653,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	/* release immediately if allowed by nssn and no stored frames */
 	if (!buffer->num_stored && ieee80211_sn_less(sn, nssn)) {
 		if (iwl_mvm_is_sn_less(buffer->head_sn, nssn,
-				       buffer->buf_size))
+				       buffer->buf_size) &&
+		   (!amsdu || last_subframe))
 			buffer->head_sn = nssn;
 		/* No need to update AMSDU last SN - we are moving the head */
 		spin_unlock_bh(&buffer->lock);
@@ -685,7 +688,20 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 		buffer->last_sub_index = sub_frame_idx;
 	}
 
-	iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+	/*
+	 * We cannot trust NSSN for AMSDU sub-frames that are not the last.
+	 * The reason is that NSSN advances on the first sub-frame, and may
+	 * cause the reorder buffer to advance before all the sub-frames arrive.
+	 * Example: reorder buffer contains SN 0 & 2, and we receive AMSDU with
+	 * SN 1. NSSN for first sub frame will be 3 with the result of driver
+	 * releasing SN 0,1, 2. When sub-frame 1 arrives - reorder buffer is
+	 * already ahead and it will be dropped.
+	 * If the last sub-frame is not on this queue - we will get frame
+	 * release notification with up to date NSSN.
+	 */
+	if (!amsdu || last_subframe)
+		iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+
 	spin_unlock_bh(&buffer->lock);
 	return true;
 
-- 
2.8.1

