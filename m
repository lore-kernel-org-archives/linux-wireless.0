Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:59736 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbbECTb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:31:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/42] iwlwifi: mvm: ROC: Reduce the aux roc max delay
Date: Sun,  3 May 2015 22:31:12 +0300
Message-Id: <1430681513-7838-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213201_635167_73D93EFC)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

When user space requests mac80211 to transmit a frame off
channel, mac80211 notifies the driver, and the driver requests
a time event from the ucode, and then transmits the frame.
When the driver requests a time event, it can specify what is the allowed
max delay for starting the time event.

When the max delay is too big, this can cause a timeout in the user space,
that is waiting for the frame to be transmitted.

Currently the max delay is extremely long.

Reduce the max delay for the AUX ROC time event that is sent to the ucode.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 40265b9..f44bb17 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3001,7 +3001,7 @@ static bool iwl_mvm_rx_aux_roc(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
-#define AUX_ROC_MAX_DELAY_ON_CHANNEL 5000
+#define AUX_ROC_MAX_DELAY_ON_CHANNEL 200
 static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_channel *channel,
 				    struct ieee80211_vif *vif,
-- 
2.1.0

