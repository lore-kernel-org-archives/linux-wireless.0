Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50188 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944575AbcJSPSP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:53 +0300
Message-Id: <20161019100755.23874-9-luca@coelho.fi> (sfid-20161019_171820_944098_0FF52ECC)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 08/10] iwlwifi: mvm: assign cab queue to the correct station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently when configuring the cab queue the scheduler is configured
without station id - which results in station id 0.
In DQA mode this causes firmware to assert later on when the actual
station 0 is added with an empty tfd_queue_mask.
Fix that by configuring the queue to the broadcast station.
This is a bit trickier since the queue should not be included in the
tfd_queue_mask of the ADD_STA since it is a multicast queue, and the
tfd_queue_mask is only unicast queue. As a result the queue should be
enabled only after the broadcast station is added.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 16 +++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 9a91203..4a0874e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -499,23 +499,21 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (ret)
 		return ret;
 
+	/* If DQA is supported - queues will be enabled when needed */
+	if (iwl_mvm_is_dqa_supported(mvm))
+		return 0;
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		if (!iwl_mvm_is_dqa_supported(mvm))
-			iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
-					      IWL_MVM_OFFCHANNEL_QUEUE,
-					      IWL_MVM_TX_FIFO_VO, 0,
-					      wdg_timeout);
+		iwl_mvm_enable_ac_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
+				      IWL_MVM_OFFCHANNEL_QUEUE,
+				      IWL_MVM_TX_FIFO_VO, 0, wdg_timeout);
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_mvm_enable_ac_txq(mvm, vif->cab_queue, vif->cab_queue,
 				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
 		/* fall through */
 	default:
-		/* If DQA is supported - queues will be enabled when needed */
-		if (iwl_mvm_is_dqa_supported(mvm))
-			break;
-
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			iwl_mvm_enable_ac_txq(mvm, vif->hw_queue[ac],
 					      vif->hw_queue[ac],
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9eeb2c3..4f8c134 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2099,6 +2099,22 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unbind;
 
+	/* enable the multicast queue, now that we have a station for it */
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		unsigned int wdg_timeout =
+			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
+		struct iwl_trans_txq_scd_cfg cfg = {
+			.fifo = IWL_MVM_TX_FIFO_MCAST,
+			.sta_id = mvmvif->bcast_sta.sta_id,
+			.tid = IWL_MAX_TID_COUNT,
+			.aggregate = false,
+			.frame_limit = IWL_FRAME_LIMIT,
+		};
+
+		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
+				   &cfg, wdg_timeout);
+	}
+
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
 
-- 
2.9.3
