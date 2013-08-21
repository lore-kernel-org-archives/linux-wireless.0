Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab3HUGEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 4/8] iwlwifi: mvm: don't set the MCAST queue in STA's queue list
Date: Wed, 21 Aug 2013 09:04:22 +0300
Message-Id: <1377065066-13030-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080442_752616_632567AB)
In-Reply-To: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 837fb69f10588caafc883c4473a864660e1403ce upstream.

The MCAST queue should be enabled after DTIM only.
According to fw API, the MCAST must not be attached to any
station, but should appear in the mcast_qid of the AP's
mac context only.

This bug induces packet loss on MCAST frames since the
firmware was sending them while the peer is asleep.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    5 +----
 drivers/net/wireless/iwlwifi/mvm/sta.c      |    3 ---
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 3b69045..d8e858c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -193,14 +193,11 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif)
 {
-	u32 qmask, ac;
+	u32 qmask = 0, ac;
 
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
 
-	qmask = (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE) ?
-		BIT(vif->cab_queue) : 0;
-
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
 			qmask |= BIT(vif->hw_queue[ac]);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 35c8ed5..68f0bbe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -226,9 +226,6 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
 			mvm_sta->tfd_queue_msk |= BIT(vif->hw_queue[i]);
 
-	if (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE)
-		mvm_sta->tfd_queue_msk |= BIT(vif->cab_queue);
-
 	/* for HW restart - need to reset the seq_number etc... */
 	memset(mvm_sta->tid_data, 0, sizeof(mvm_sta->tid_data));
 
-- 
1.7.10.4

