Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7819 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaL3OTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/33] iwlwifi: mvm: allow RSSI compensation
Date: Tue, 30 Dec 2014 16:18:42 +0200
Message-Id: <1419949148-24046-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154348_681532_6FDCEEDA)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware is able to compensate the rssi when we hear
the frame on a different channel.
This is true for an offset up to 3 channels.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2d62b56..bec588d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -377,6 +377,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->max_remain_on_channel_duration = 10000;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
+	/* we can compensate an offset of up to 3 channels = 15 MHz */
+	hw->wiphy->max_adj_channel_rssi_comp = 3 * 5;
 
 	/* Extract MAC address */
 	memcpy(mvm->addresses[0].addr, mvm->nvm_data->hw_addr, ETH_ALEN);
-- 
1.9.1

