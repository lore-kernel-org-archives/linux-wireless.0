Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45719 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaCROq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:28 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so4744148eek.21
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:27 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/35] iwlwifi: mvm: Change beacon filter enablement condition
Date: Tue, 18 Mar 2014 16:45:27 +0200
Message-Id: <1395153939-23897-23-git-send-email-egrumbach@gmail.com> (sfid-20140318_154639_095288_E939EC49)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Enable beacon filter only if at least one beacon from candidate
AP is received before or after association. Check this condition before
enabling BF upon secured association completion. Add BF enablement to
mac80211 event that indicates beacon is received after association.
Too early beacon filtering enablement can lead to disconnection due to
missing AP's beacon after association.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index de0e0df..66760e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1237,6 +1237,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
+		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC));
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
 		ret = iwl_mvm_power_update_mac(mvm, vif);
@@ -1611,7 +1612,9 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		/* enable beacon filtering */
-		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC));
+		if (vif->bss_conf.dtim_period)
+			WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif,
+							     CMD_SYNC));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
-- 
1.8.3.2

