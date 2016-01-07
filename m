Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbcAGMsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:00 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/21] iwlwifi: mvm: support A-MSDU in A-MPDU
Date: Thu,  7 Jan 2016 14:47:32 +0200
Message-Id: <1452170861-10060-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134814_548894_7732B461)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since A-MPDU deaggregation is done in hardware, and A-MSDU deaggregation
is done in software, there's no reason not to support A-MSDU in A-MPDU;
set the flag to support it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 2d65040..8539dfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -438,6 +438,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 
 	if (mvm->trans->max_skb_frags)
 		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
-- 
2.5.0

