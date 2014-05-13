Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35952 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066AbaEMNo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:44:58 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so403886wgg.22
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 06:44:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] iwlwifi: mvm: prevent sched scan while not idle
Date: Tue, 13 May 2014 16:44:45 +0300
Message-Id: <1399988685-14715-3-git-send-email-egrumbach@gmail.com> (sfid-20140513_154501_857822_CE3F5969)
In-Reply-To: <53722142.6070105@gmail.com>
References: <53722142.6070105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Prevent sched scan while not idle (including during association or in AP
mode) instead of while associated only.

This fixes my previous commit which was incomplete:

commit bd5e4744a6ca64299b57a2682c720d00a475a734
Author: David Spinadel <david.spinadel@intel.com>
Date:   Thu Apr 24 13:15:29 2014 +0300

    iwlwifi: mvm: do no sched scan while associated

    Currently the FW doesn't support sched scan while associated,
    Prevent it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 16 ++++++++--------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4b0b8b6..b41dc84 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1807,7 +1807,7 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (iwl_mvm_is_associated(mvm)) {
+	if (!iwl_mvm_is_idle(mvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 84c75a1..f1ec098 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1004,7 +1004,7 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 }
 
 /* Assoc status */
-bool iwl_mvm_is_associated(struct iwl_mvm *mvm);
+bool iwl_mvm_is_idle(struct iwl_mvm *mvm);
 
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 6fdbef9..2180902 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -645,21 +645,21 @@ bool iwl_mvm_low_latency(struct iwl_mvm *mvm)
 	return result;
 }
 
-static void iwl_mvm_assoc_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
+static void iwl_mvm_idle_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
 {
-	bool *assoc = _data;
+	bool *idle = _data;
 
-	if (vif->bss_conf.assoc)
-		*assoc = true;
+	if (!vif->bss_conf.idle)
+		*idle = false;
 }
 
-bool iwl_mvm_is_associated(struct iwl_mvm *mvm)
+bool iwl_mvm_is_idle(struct iwl_mvm *mvm)
 {
-	bool assoc = false;
+	bool idle = true;
 
 	ieee80211_iterate_active_interfaces_atomic(
 			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-			iwl_mvm_assoc_iter, &assoc);
+			iwl_mvm_idle_iter, &idle);
 
-	return assoc;
+	return idle;
 }
-- 
1.8.3.2

