Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40770 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752268AbcEJUaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:09 +0300
Message-Id: <1462910797-20303-13-git-send-email-luca@coelho.fi> (sfid-20160510_223041_226010_32ABDBDB)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 13/41] iwlwifi: mvm: advertise RSS queue usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order for mac80211 to use per-CPU statistics for RSS RX, the
driver needs to advertise that it uses RSS. Do this when using
more than a single queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6286063..5648e37 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -442,6 +442,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (iwl_mvm_has_new_rx_api(mvm))
 		ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
 
+	if (mvm->trans->num_rx_queues > 1)
+		ieee80211_hw_set(hw, USES_RSS);
+
 	if (mvm->trans->max_skb_frags)
 		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
 
-- 
2.8.1

