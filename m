Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:38635 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaIOFLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:11:16 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so3368043wes.2
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:11:15 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/12] iwlwifi: mvm: correctly handle PM/QoS changes from mac80211
Date: Mon, 15 Sep 2014 08:10:42 +0300
Message-Id: <1410757848-1827-6-git-send-email-egrumbach@gmail.com> (sfid-20140915_071123_116572_65717D21)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When mac80211 requests multiple BSS config changes, as for example
while associating, we ignore power management and QoS changes and
only apply them later. Fix that by removing the "else" and making
the conditions independent.

Also move it after (potential) beacon filter enablement to have
that already enabled when going into power management code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c4000a1..cdc272d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1526,11 +1526,6 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
-	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
-			      BSS_CHANGED_QOS)) {
-		ret = iwl_mvm_power_update_mac(mvm);
-		if (ret)
-			IWL_ERR(mvm, "failed to update power mode\n");
 	}
 
 	if (changes & BSS_CHANGED_BEACON_INFO) {
@@ -1538,6 +1533,12 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 	}
 
+	if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS | BSS_CHANGED_QOS)) {
+		ret = iwl_mvm_power_update_mac(mvm);
+		if (ret)
+			IWL_ERR(mvm, "failed to update power mode\n");
+	}
+
 	if (changes & BSS_CHANGED_TXPOWER) {
 		IWL_DEBUG_CALIB(mvm, "Changing TX Power to %d\n",
 				bss_conf->txpower);
-- 
1.9.1

