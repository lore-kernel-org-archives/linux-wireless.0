Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11234 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbcCBH5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/43] iwlwifi: mvm: support VHT MU-MIMO notification
Date: Wed,  2 Mar 2016 09:56:29 +0200
Message-Id: <1456905404-14435-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085950_939145_9762D3B7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When the device is in d0i3/d3 we will not receive the VHT
MU-MIMO group id management frame. Instead, firmware will
notify us upon exit on the current status and we can in turn
update mac80211. Support this notification.
While at it, also check as a precaution that the vif is indeed
the VHT MU-MIMO owner before updating the firmware.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   | 13 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 33 +++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  3 +++
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index f432ddd..4a0fc47 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -290,6 +290,7 @@ enum iwl_phy_ops_subcmd_ids {
 enum iwl_data_path_subcmd_ids {
 	UPDATE_MU_GROUPS_CMD = 0x1,
 	TRIGGER_RX_QUEUES_NOTIF_CMD = 0x2,
+	MU_GROUP_MGMT_NOTIF = 0xFE,
 	RX_QUEUES_NOTIFICATION = 0xFF,
 };
 
@@ -1965,6 +1966,18 @@ struct iwl_mu_group_mgmt_cmd {
 	__le32 user_position[4];
 } __packed; /* MU_GROUP_ID_MNG_TABLE_API_S_VER_1 */
 
+/**
+ * struct iwl_mu_group_mgmt_notif - VHT MU-MIMO group id notification
+ *
+ * @membership_status: a bitmap of MU groups
+ * @user_position: the position of station in a group. If the station is in the
+ *	group then bits (group * 2) is the position -1
+ */
+struct iwl_mu_group_mgmt_notif {
+	__le32 membership_status[2];
+	__le32 user_position[4];
+} __packed; /* MU_GROUP_MNG_NTFY_API_S_VER_1 */
+
 #define MAX_STORED_BEACON_SIZE 600
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1a4946f..b755161 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -1780,6 +1781,34 @@ static int iwl_mvm_update_mu_groups(struct iwl_mvm *mvm,
 				    0, sizeof(cmd), &cmd);
 }
 
+static void iwl_mvm_mu_mimo_iface_iterator(void *_data, u8 *mac,
+					   struct ieee80211_vif *vif)
+{
+	if (vif->mu_mimo_owner) {
+		struct iwl_mu_group_mgmt_notif *notif = _data;
+
+		/*
+		 * MU-MIMO Group Id action frame is little endian. We treat
+		 * the data received from firmware as if it came from the
+		 * action frame, so no conversion is needed.
+		 */
+		ieee80211_update_mu_groups(vif,
+					   (u8 *)&notif->membership_status,
+					   (u8 *)&notif->user_position);
+	}
+}
+
+void iwl_mvm_mu_mimo_grp_notif(struct iwl_mvm *mvm,
+			       struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mu_group_mgmt_notif *notif = (void *)pkt->data;
+
+	ieee80211_iterate_active_interfaces_atomic(
+			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+			iwl_mvm_mu_mimo_iface_iterator, notif);
+}
+
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_bss_conf *bss_conf,
@@ -1890,10 +1919,10 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 
 		/*
 		 * The firmware tracks the MU-MIMO group on its own.
-		 * However, on HW restart we should restore this data
+		 * However, on HW restart we should restore this data.
 		 */
 		if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
-		    changes & BSS_CHANGED_MU_GROUPS) {
+		    (changes & BSS_CHANGED_MU_GROUPS) && vif->mu_mimo_owner) {
 			ret = iwl_mvm_update_mu_groups(mvm, vif);
 			if (ret)
 				IWL_ERR(mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f05d2a1..21986f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1272,6 +1272,8 @@ void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 				     struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_mu_mimo_grp_notif(struct iwl_mvm *mvm,
+			       struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 				 struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ac271ff..8bdaa7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -275,6 +275,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(TOF_NOTIFICATION, iwl_mvm_tof_resp_handler, true),
 	RX_HANDLER_GRP(PROT_OFFLOAD_GROUP, STORED_BEACON_NTF,
 		       iwl_mvm_rx_stored_beacon_notif, false),
+	RX_HANDLER_GRP(DATA_PATH_GROUP, MU_GROUP_MGMT_NOTIF,
+		       iwl_mvm_mu_mimo_grp_notif, false),
 
 };
 #undef RX_HANDLER
@@ -405,6 +407,7 @@ static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 	HCMD_NAME(UPDATE_MU_GROUPS_CMD),
 	HCMD_NAME(TRIGGER_RX_QUEUES_NOTIF_CMD),
+	HCMD_NAME(MU_GROUP_MGMT_NOTIF),
 	HCMD_NAME(RX_QUEUES_NOTIFICATION),
 };
 
-- 
2.5.0

