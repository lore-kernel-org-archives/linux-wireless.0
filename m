Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757794AbcISHap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:11 +0300
Message-Id: <20160919073028.22065-8-luca@coelho.fi> (sfid-20160919_093058_850419_48A5B3DA)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: mvm: support BAR in reorder buffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

On default queue we will not receive frame release notification,
but the BAR itself.
Upon receiving the BAR driver should look at the NSSN and adjust
window accordingly.

Fixes: b915c10174fb ("iwlwifi: mvm: add reorder buffer per queue")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b386628..0274f14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -600,9 +600,10 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
-	/* not a data packet */
-	if (!ieee80211_is_data_qos(hdr->frame_control) ||
-	    is_multicast_ether_addr(hdr->addr1))
+	/* not a data packet or a bar */
+	if (!ieee80211_is_back_req(hdr->frame_control) &&
+	    (!ieee80211_is_data_qos(hdr->frame_control) ||
+	     is_multicast_ether_addr(hdr->addr1)))
 		return false;
 
 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
@@ -626,6 +627,11 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	spin_lock_bh(&buffer->lock);
 
+	if (ieee80211_is_back_req(hdr->frame_control)) {
+		iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+		goto drop;
+	}
+
 	/*
 	 * If there was a significant jump in the nssn - adjust.
 	 * If the SN is smaller than the NSSN it might need to first go into
-- 
2.9.3
