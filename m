Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35994 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751752AbdF1UPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:25 +0300
Message-Id: <20170628201330.9432-27-luca@coelho.fi> (sfid-20170628_221556_692959_32746746)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 26/31] iwlwifi: mvm: fix deduplication start logic
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the first frame on a given TID is received with seqno 0 and needed
to be retransmitted, we erroneously drop it because the deduplication
data is initialized to zero, and then comparing

        if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
                     dup_data->last_seq[tid] == hdr->seq_ctrl &&
                     dup_data->last_sub_frame[tid] >= sub_frame_idx))
                return true;

will return in iwl_mvm_is_dup() since last_sub_frame is also set to
zero, and sub_frame_idx is usually zero since this only covers the
relatively rare case of A-MSDU.

Fix this by initializing the last_seq array to 0xffff, which is an
impossible value for hdr->seq_ctrl to have here because the lower
four bits are the fragment number, and fragments aren't handled in
this code but go to mac80211 instead.

Fixes: a571f5f635ef ("iwlwifi: mvm: add duplicate packet detection per rx queue")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ee7c978fe5ab..4df5f13fcdae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1402,11 +1402,24 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	if (iwl_mvm_has_new_rx_api(mvm) &&
 	    !test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		int q;
+
 		dup_data = kcalloc(mvm->trans->num_rx_queues,
-				   sizeof(*dup_data),
-				   GFP_KERNEL);
+				   sizeof(*dup_data), GFP_KERNEL);
 		if (!dup_data)
 			return -ENOMEM;
+		/*
+		 * Initialize all the last_seq values to 0xffff which can never
+		 * compare equal to the frame's seq_ctrl in the check in
+		 * iwl_mvm_is_dup() since the lower 4 bits are the fragment
+		 * number and fragmented packets don't reach that function.
+		 *
+		 * This thus allows receiving a packet with seqno 0 and the
+		 * retry bit set as the very first packet on a new TID.
+		 */
+		for (q = 0; q < mvm->trans->num_rx_queues; q++)
+			memset(dup_data[q].last_seq, 0xff,
+			       sizeof(dup_data[q].last_seq));
 		mvm_sta->dup_data = dup_data;
 	}
 
-- 
2.11.0
