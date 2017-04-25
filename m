Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54348 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954317AbdDYUaQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:30:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:28 +0300
Message-Id: <20170425202243.7844-11-luca@coelho.fi> (sfid-20170425_223022_216950_6B8D7C77)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: mvm: Ignore wifi mcc update in the driver while associated
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Wifi mcc (mobile country code) update is forbidden while associated.
Currently, FW prevents these updates and the driver is unaware to
this logic. From now on, the FW sends every wifi mcc update to the
driver. The driver in his turn needs to decide whether to
ignore it or not, depends on the association state.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c   |  9 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 29 ++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ab87c0203b6f..1bb4249fc6f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1827,6 +1827,7 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 				     u32 size);
 void iwl_mvm_reorder_timer_expired(unsigned long data);
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
+bool iwl_mvm_is_vif_assoc(struct iwl_mvm *mvm);
 
 void iwl_mvm_inactivity_check(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index eade099b6dbf..283c41df622c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -817,6 +817,11 @@ void iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwl_mvm_is_vif_assoc(mvm) && notif->source_id == MCC_SOURCE_WIFI) {
+		IWL_DEBUG_LAR(mvm, "Ignore mcc update while associated\n");
+		return;
+	}
+
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 987edc98a203..175e927493d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1063,6 +1063,35 @@ struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm)
 	return bss_iter_data.vif;
 }
 
+struct iwl_sta_iter_data {
+	bool assoc;
+};
+
+static void iwl_mvm_sta_iface_iterator(void *_data, u8 *mac,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_sta_iter_data *data = _data;
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (vif->bss_conf.assoc)
+		data->assoc = true;
+}
+
+bool iwl_mvm_is_vif_assoc(struct iwl_mvm *mvm)
+{
+	struct iwl_sta_iter_data data = {
+		.assoc = false,
+	};
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_sta_iface_iterator,
+						   &data);
+	return data.assoc;
+}
+
 unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    bool tdls, bool cmd_q)
-- 
2.11.0
