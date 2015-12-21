Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbbLUUwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:22 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/45] iwlwifi: mvm: enable L3 filtering
Date: Mon, 21 Dec 2015 22:50:32 +0200
Message-Id: <1450731046-2796-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215229_280529_1FE2EBB8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Firmware will support filtering multicast L3 packets.
The L3 filtering is configured by the WOWLAN_CONFIG command.
All flags should be enabled by default.
Older firmware is not affected as it does not look into
this field.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h | 13 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  3 ++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 69fd10a..3e6b6d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -804,6 +804,8 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 
 	wowlan_config_cmd->is_11n_connection =
 					ap_sta->ht_cap.ht_supported;
+	wowlan_config_cmd->flags = ENABLE_L3_FILTERING |
+		ENABLE_NBNS_FILTERING | ENABLE_DHCP_FILTERING;
 
 	/* Query the last used seqno and set it */
 	ret = iwl_mvm_get_last_nonqos_seq(mvm, vif);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
index c36c956..62b9a0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -245,6 +246,13 @@ enum iwl_wowlan_wakeup_filters {
 	IWL_WOWLAN_WAKEUP_BCN_FILTERING			= BIT(16),
 }; /* WOWLAN_WAKEUP_FILTER_API_E_VER_4 */
 
+enum iwl_wowlan_flags {
+	IS_11W_ASSOC		= BIT(0),
+	ENABLE_L3_FILTERING	= BIT(1),
+	ENABLE_NBNS_FILTERING	= BIT(2),
+	ENABLE_DHCP_FILTERING	= BIT(3),
+};
+
 struct iwl_wowlan_config_cmd {
 	__le32 wakeup_filter;
 	__le16 non_qos_seq;
@@ -252,8 +260,9 @@ struct iwl_wowlan_config_cmd {
 	u8 wowlan_ba_teardown_tids;
 	u8 is_11n_connection;
 	u8 offloading_tid;
-	u8 reserved[3];
-} __packed; /* WOWLAN_CONFIG_API_S_VER_3 */
+	u8 flags;
+	u8 reserved[2];
+} __packed; /* WOWLAN_CONFIG_API_S_VER_4 */
 
 /*
  * WOWLAN_TSC_RSC_PARAMS
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 50b8c01..a5e1c8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1186,7 +1186,8 @@ static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
 	mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
 	cmd->is_11n_connection = ap_sta->ht_cap.ht_supported;
 	cmd->offloading_tid = iter_data->offloading_tid;
-
+	cmd->flags = ENABLE_L3_FILTERING | ENABLE_NBNS_FILTERING |
+		ENABLE_DHCP_FILTERING;
 	/*
 	 * The d0i3 uCode takes care of the nonqos counters,
 	 * so configure only the qos seq ones.
-- 
2.5.0

