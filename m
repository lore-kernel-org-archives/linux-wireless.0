Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55212 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaDMNCK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:10 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/13] iwlwifi: mvm: delay enabling smart FIFO until after beacon RX
Date: Sun, 13 Apr 2014 16:01:51 +0300
Message-Id: <1397394123-25102-1-git-send-email-egrumbach@gmail.com> (sfid-20140413_150215_437499_7383700E)
In-Reply-To: <534A8A49.2030100@gmail.com>
References: <534A8A49.2030100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we have no beacon data before association, delay smart FIFO
enablement until after we have this data.

Not doing so can cause association failures in extremely silent
environments (usually only a shielded box/room) as beacon RX is
not sent to the host immediately, and then the association time
event ends without the host receiving any beacon even though it
was on the air - it's just stuck on the FIFO.

Cc: <stable@vger.kernel.org> [3.14]
Fixes: 1f3b0ff8ecce ("iwlwifi: mvm: Add Smart FIFO support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 drivers/net/wireless/iwlwifi/mvm/sf.c       | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4dd9ff4..f0cebf1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1332,6 +1332,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
+		iwl_mvm_sf_update(mvm, vif, false);
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC));
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 8401627..88809b2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -274,7 +274,8 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *changed_vif,
 				return -EINVAL;
 			if (changed_vif->type != NL80211_IFTYPE_STATION) {
 				new_state = SF_UNINIT;
-			} else if (changed_vif->bss_conf.assoc) {
+			} else if (changed_vif->bss_conf.assoc &&
+				   changed_vif->bss_conf.dtim_period) {
 				mvmvif = iwl_mvm_vif_from_mac80211(changed_vif);
 				sta_id = mvmvif->ap_sta_id;
 				new_state = SF_FULL_ON;
-- 
1.8.3.2

