Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933596AbcCIRqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/21] iwlwifi: mvm: extend time event duration
Date: Wed,  9 Mar 2016 19:45:37 +0200
Message-Id: <1457545550-30677-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_184615_509192_0CE2227E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Before authentication, we start a time event during
which we wait for a beacon in order to sync our timers.
If we didn't hear the beacon during this time - we abandon
the connection. However, in congested environment, it was
observed we might not hear beacons in that time slot.
Extend the time event to give the connection a better chance.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 6 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ec6b072..3590835 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2556,10 +2556,8 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	u32 duration = min(IWL_MVM_TE_SESSION_PROTECTION_MAX_TIME_MS,
-			   200 + vif->bss_conf.beacon_int);
-	u32 min_duration = min(IWL_MVM_TE_SESSION_PROTECTION_MIN_TIME_MS,
-			       100 + vif->bss_conf.beacon_int);
+	u32 duration = IWL_MVM_TE_SESSION_PROTECTION_MAX_TIME_MS;
+	u32 min_duration = IWL_MVM_TE_SESSION_PROTECTION_MIN_TIME_MS;
 
 	if (WARN_ON_ONCE(vif->bss_conf.assoc))
 		return;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
index 99d9a35..3d2e8b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
@@ -115,7 +115,7 @@
  * needed by the driver.
  */
 
-#define IWL_MVM_TE_SESSION_PROTECTION_MAX_TIME_MS 500
+#define IWL_MVM_TE_SESSION_PROTECTION_MAX_TIME_MS 600
 #define IWL_MVM_TE_SESSION_PROTECTION_MIN_TIME_MS 400
 
 /**
-- 
2.5.0

