Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44640 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752148AbdHRPws (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:09 +0300
Message-Id: <20170818154922.2904-12-luca@coelho.fi> (sfid-20170818_175252_294094_3309CB94)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 11/24] iwlwifi: mvm: remove session protection to allow channel switch
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

If a time event is already scheduled when trying to schedule one for
channel switch, the code assumes the channel switch is already
scheduled and no further action is required.
However, it is possible that the scheduled time event is actually
for session protection (e.g. when the first beacon after association
contains the CSA IE). In this case the channel switch will not be
scheduled which will finally lead to disconnection.

Fix this by removing the old time event and schduling a new one for
the channel switch.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 34 ++++++++++++++++++++--
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 2d1404c9fbf4..01143c491e53 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2023,8 +2023,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 * We received a beacon from the associated AP so
 		 * remove the session protection.
 		 */
-		iwl_mvm_remove_time_event(mvm, mvmvif,
-					  &mvmvif->time_event_data);
+		iwl_mvm_stop_session_protection(mvm, vif);
 
 		iwl_mvm_sf_update(mvm, vif, false);
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 65d8299108d5..4d0314912e94 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -726,8 +728,21 @@ void iwl_mvm_stop_session_protection(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
+	u32 id;
 
 	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->time_event_lock);
+	id = te_data->id;
+	spin_unlock_bh(&mvm->time_event_lock);
+
+	if (id != TE_BSS_STA_AGGRESSIVE_ASSOC) {
+		IWL_DEBUG_TE(mvm,
+			     "don't remove TE with id=%u (not session protection)\n",
+			     id);
+		return;
+	}
+
 	iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
 }
 
@@ -859,8 +874,23 @@ int iwl_mvm_schedule_csa_period(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	if (te_data->running) {
-		IWL_DEBUG_TE(mvm, "CS period is already scheduled\n");
-		return -EBUSY;
+		u32 id;
+
+		spin_lock_bh(&mvm->time_event_lock);
+		id = te_data->id;
+		spin_unlock_bh(&mvm->time_event_lock);
+
+		if (id == TE_CHANNEL_SWITCH_PERIOD) {
+			IWL_DEBUG_TE(mvm, "CS period is already scheduled\n");
+			return -EBUSY;
+		}
+
+		/*
+		 * Remove the session protection time event to allow the
+		 * channel switch. If we got here, we just heard a beacon so
+		 * the session protection is not needed anymore anyway.
+		 */
+		iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
 	}
 
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
-- 
2.14.1
