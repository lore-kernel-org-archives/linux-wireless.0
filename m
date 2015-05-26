Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbEZTSU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/39] iwlwifi: mvm: advertise randomised netdetect MAC address
Date: Tue, 26 May 2015 22:17:25 +0300
Message-Id: <1432667872-18092-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211946_777851_180F447B)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

According to the nl80211 documentation, we can neither advertise
scheduled scan nor netdetect address randomisation. However, all
the products that currently require this don't have a need for
the full randomisation.

Therefore, advertise the feature anyway which results in host-
based randomisation, done whenever the system suspends. This is
sufficient for the platforms currently requiring this feature.

If we ever extend this in the future to do full randomisation in
the firmware, then certainly this will still be sufficient for
the current requirements, so it doesn't make a lot of sense to
split the feature bits.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 677143c..d13138e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -452,7 +452,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
 	hw->wiphy->features |=
 		NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
-		NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+		NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
+		NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
 
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
-- 
2.1.4

