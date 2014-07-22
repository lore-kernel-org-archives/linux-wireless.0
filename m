Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:59366 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaGVT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:48 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so115771wes.20
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:47 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/20] iwlwifi: mvm: update smart fifo / beacon filtering upon association
Date: Tue, 22 Jul 2014 22:26:49 +0300
Message-Id: <1406057211-31752-18-git-send-email-egrumbach@gmail.com> (sfid-20140722_212754_516572_4D6428FD)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

When we associate, we may have heard the beacon before the
association. In that case, BSS_CHANGED_BEACON_INFO will be
set along with BSS_CHANGED_ASSOC in changes in
bss_info_change.

In this case, we didn't update the smart fifo nor beacon
filtering leaving those two feature disabled.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index bd924a1..01af86a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1501,14 +1501,18 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
-		iwl_mvm_sf_update(mvm, vif, false);
-		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
 		ret = iwl_mvm_power_update_mac(mvm);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
 	}
+
+	if (changes & BSS_CHANGED_BEACON_INFO) {
+		iwl_mvm_sf_update(mvm, vif, false);
+		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
+	}
+
 	if (changes & BSS_CHANGED_TXPOWER) {
 		IWL_DEBUG_CALIB(mvm, "Changing TX Power to %d\n",
 				bss_conf->txpower);
-- 
1.8.3.2

