Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48084 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726862AbeIIO07 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:51 +0300
Message-Id: <20180909093656.10194-12-luca@coelho.fi> (sfid-20180909_113756_538322_1CF9CC5D)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 11/16] iwlwifi: mvm: remove support for adjacent channel compensation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We no longer want to consider the RSSI if the beacon / probe
has been heard on an adjacent channel.
This was based on a firmware capability that is now
unavailable.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c445e93951bf..4a54756bd1d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -554,8 +554,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->max_remain_on_channel_duration = 10000;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
-	/* we can compensate an offset of up to 3 channels = 15 MHz */
-	hw->wiphy->max_adj_channel_rssi_comp = 3 * 5;
 
 	/* Extract MAC address */
 	memcpy(mvm->addresses[0].addr, mvm->nvm_data->hw_addr, ETH_ALEN);
-- 
2.18.0
