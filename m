Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbbDTTxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 15:53:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] iwlwifi: dvm: don't sleep in event_callback callback
Date: Mon, 20 Apr 2015 22:53:36 +0300
Message-Id: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150420_215348_318005_E0B2FADD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow mac80211 to forbid sleeping from the
event_callback callback.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
Please apply this on mac80211-next.git since other mac80211 patches
depend on it.
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 5707ba5..1e2c352 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1139,7 +1139,6 @@ static void iwlagn_mac_event_callback(struct ieee80211_hw *hw,
 		return;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->mutex);
 
 	if (priv->lib->bt_params &&
 	    priv->lib->bt_params->advanced_bt_coexist) {
@@ -1148,13 +1147,12 @@ static void iwlagn_mac_event_callback(struct ieee80211_hw *hw,
 		else if (event->u.rssi.data == RSSI_EVENT_HIGH)
 			priv->bt_enable_pspoll = false;
 
-		iwlagn_send_advance_bt_config(priv);
+		queue_work(priv->workqueue, &priv->bt_runtime_config);
 	} else {
 		IWL_DEBUG_MAC80211(priv, "Advanced BT coex disabled,"
 				"ignoring RSSI callback\n");
 	}
 
-	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-- 
2.1.0

