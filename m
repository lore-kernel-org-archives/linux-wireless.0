Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbcCBH5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/43] iwlwifi: mvm: update firmware of VHT MU-MIMO groups status on restart
Date: Wed,  2 Mar 2016 09:56:14 +0200
Message-Id: <1456905404-14435-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085712_599525_ABE63BF1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The firmware handles the VHT MU-MIMO group data on its own.
However, on HW restart (and future sniffer mode) the driver
shall update the firmware on the VHT MU-MIMO group membership
status.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   | 18 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 28 +++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index d5f9037..ca7fec71 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -285,6 +285,10 @@ enum iwl_phy_ops_subcmd_ids {
 	DTS_MEASUREMENT_NOTIF_WIDE = 0xFF,
 };
 
+enum iwl_data_path_subcmd_ids {
+	UPDATE_MU_GROUPS_CMD = 0x1,
+};
+
 enum iwl_prot_offload_subcmd_ids {
 	STORED_BEACON_NTF = 0xFF,
 };
@@ -294,6 +298,7 @@ enum {
 	LEGACY_GROUP = 0x0,
 	LONG_GROUP = 0x1,
 	PHY_OPS_GROUP = 0x4,
+	DATA_PATH_GROUP = 0x5,
 	PROT_OFFLOAD_GROUP = 0xb,
 };
 
@@ -1923,6 +1928,19 @@ struct iwl_shared_mem_cfg {
 	__le32 page_buff_size;
 } __packed; /* SHARED_MEM_ALLOC_API_S_VER_1 */
 
+/**
+ * VHT MU-MIMO group configuration
+ *
+ * @membership_status: a bitmap of MU groups
+ * @user_position:the position of station in a group. If the station is in the
+ *	group then bits (group * 2) is the position -1
+ */
+struct iwl_mu_group_mgmt_cmd {
+	__le32 reserved;
+	__le32 membership_status[2];
+	__le32 user_position[4];
+} __packed; /* MU_GROUP_ID_MNG_TABLE_API_S_VER_1 */
+
 #define MAX_STORED_BEACON_SIZE 600
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5315681..f1ed90b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1762,6 +1762,22 @@ static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm)
 }
 #endif
 
+static int iwl_mvm_update_mu_groups(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif)
+{
+	struct iwl_mu_group_mgmt_cmd cmd = {};
+
+	memcpy(cmd.membership_status, vif->bss_conf.mu_group.membership,
+	       WLAN_MEMBERSHIP_LEN);
+	memcpy(cmd.user_position, vif->bss_conf.mu_group.position,
+	       WLAN_USER_POSITION_LEN);
+
+	return iwl_mvm_send_cmd_pdu(mvm,
+				    WIDE_ID(DATA_PATH_GROUP,
+					    UPDATE_MU_GROUPS_CMD),
+				    0, sizeof(cmd), &cmd);
+}
+
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_bss_conf *bss_conf,
@@ -1870,6 +1886,18 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					vif->addr);
 		}
 
+		/*
+		 * The firmware tracks the MU-MIMO group on its own.
+		 * However, on HW restart we should restore this data
+		 */
+		if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
+		    changes & BSS_CHANGED_MU_GROUPS) {
+			ret = iwl_mvm_update_mu_groups(mvm, vif);
+			if (ret)
+				IWL_ERR(mvm,
+					"failed to update VHT MU_MIMO groups\n");
+		}
+
 		iwl_mvm_recalc_multicast(mvm);
 		iwl_mvm_configure_bcast_filter(mvm);
 
-- 
2.5.0

