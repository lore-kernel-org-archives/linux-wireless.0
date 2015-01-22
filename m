Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbbAVUel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:41 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/38] iwlwifi: mvm: Do not consider invalid HW queues in queue mask
Date: Thu, 22 Jan 2015 22:33:23 +0200
Message-Id: <1421958809-3371-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_588645_DE17EEAC)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The iwl_mvm_mac_get_queues_mask() added vif->hw_queue[ac] to the
queue mask although it might be set to IEEE80211_INVAL_HW_QUEUE.
Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index a3e9cd9..8bf78fa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -208,8 +208,10 @@ u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
 
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		qmask |= BIT(vif->hw_queue[ac]);
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
+			qmask |= BIT(vif->hw_queue[ac]);
+	}
 
 	if (vif->type == NL80211_IFTYPE_AP)
 		qmask |= BIT(vif->cab_queue);
-- 
1.9.1

