Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51954 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaEGUBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:01:39 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so5584056wib.11
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 13:01:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/5] iwlwifi: mvm: do no sched scan while associated
Date: Wed,  7 May 2014 23:01:23 +0300
Message-Id: <1399492884-13508-4-git-send-email-egrumbach@gmail.com> (sfid-20140507_220146_102939_4E3024FA)
In-Reply-To: <536A90BD.8010204@gmail.com>
References: <536A90BD.8010204@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Currently the FW doesn't support sched scan while associated,
Prevent it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  5 +++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  3 +++
 drivers/net/wireless/iwlwifi/mvm/utils.c    | 19 +++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f0cebf1..593f723 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1807,6 +1807,11 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	if (iwl_mvm_is_associated(mvm)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	switch (mvm->scan_status) {
 	case IWL_MVM_SCAN_OS:
 		IWL_DEBUG_SCAN(mvm, "Stopping previous scan for sched_scan\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d564233..84c75a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1003,6 +1003,9 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 	return mvmvif->low_latency;
 }
 
+/* Assoc status */
+bool iwl_mvm_is_associated(struct iwl_mvm *mvm);
+
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index d619851..6fdbef9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -644,3 +644,22 @@ bool iwl_mvm_low_latency(struct iwl_mvm *mvm)
 
 	return result;
 }
+
+static void iwl_mvm_assoc_iter(void *_data, u8 *mac, struct ieee80211_vif *vif)
+{
+	bool *assoc = _data;
+
+	if (vif->bss_conf.assoc)
+		*assoc = true;
+}
+
+bool iwl_mvm_is_associated(struct iwl_mvm *mvm)
+{
+	bool assoc = false;
+
+	ieee80211_iterate_active_interfaces_atomic(
+			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+			iwl_mvm_assoc_iter, &assoc);
+
+	return assoc;
+}
-- 
1.8.3.2

