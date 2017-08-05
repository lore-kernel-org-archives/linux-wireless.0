Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42588 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHEToi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:26 +0300
Message-Id: <20170805194331.17426-15-luca@coelho.fi> (sfid-20170805_214441_297021_078710BE)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 14/19] iwlwifi: mvm: add station before allocating a queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

One of the queue config params is the associated station id.
Hence the FW must know about the station prior to the queue allocation.
In a000 devices, allocating a queue without a valid station
results with assert 0x2B00.
In FW restart flow the queues are allocated before
adding the station so first add the station.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 108 ++++++++++++++++-----------
 1 file changed, 63 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5506d6ac66d6..f895a8ac31e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1265,6 +1265,50 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 	}
 }
 
+static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
+				      struct iwl_mvm_int_sta *sta,
+				      const u8 *addr,
+				      u16 mac_id, u16 color)
+{
+	struct iwl_mvm_add_sta_cmd cmd;
+	int ret;
+	u32 status;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.sta_id = sta->sta_id;
+	cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
+							     color));
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		cmd.station_type = sta->type;
+
+	if (!iwl_mvm_has_new_tx_api(mvm))
+		cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
+	cmd.tid_disable_tx = cpu_to_le16(0xffff);
+
+	if (addr)
+		memcpy(cmd.addr, addr, ETH_ALEN);
+
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA,
+					  iwl_mvm_add_sta_cmd_size(mvm),
+					  &cmd, &status);
+	if (ret)
+		return ret;
+
+	switch (status & IWL_ADD_STA_STATUS_MASK) {
+	case ADD_STA_SUCCESS:
+		IWL_DEBUG_INFO(mvm, "Internal station added.\n");
+		return 0;
+	default:
+		ret = -EIO;
+		IWL_ERR(mvm, "Add internal station failed, status=0x%x\n",
+			status);
+		break;
+	}
+	return ret;
+}
+
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta)
@@ -1273,6 +1317,8 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_rxq_dup_data *dup_data;
 	int i, ret, sta_id;
+	bool sta_update = false;
+	unsigned int sta_flags = 0;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1289,7 +1335,23 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	/* if this is a HW restart re-alloc existing queues */
 	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		struct iwl_mvm_int_sta tmp_sta = {
+			.sta_id = sta_id,
+			.type = mvm_sta->sta_type,
+		};
+
+		/*
+		 * First add an empty station since allocating
+		 * a queue requires a valid station
+		 */
+		ret = iwl_mvm_add_int_sta_common(mvm, &tmp_sta, sta->addr,
+						 mvmvif->id, mvmvif->color);
+		if (ret)
+			goto err;
+
 		iwl_mvm_realloc_queues_after_restart(mvm, mvm_sta);
+		sta_update = true;
+		sta_flags = iwl_mvm_has_new_tx_api(mvm) ? 0 : STA_MODIFY_QUEUES;
 		goto update_fw;
 	}
 
@@ -1356,7 +1418,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	}
 
 update_fw:
-	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false, 0);
+	ret = iwl_mvm_sta_send_to_fw(mvm, sta, sta_update, sta_flags);
 	if (ret)
 		goto err;
 
@@ -1625,50 +1687,6 @@ void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta)
 	sta->sta_id = IWL_MVM_INVALID_STA;
 }
 
-static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
-				      struct iwl_mvm_int_sta *sta,
-				      const u8 *addr,
-				      u16 mac_id, u16 color)
-{
-	struct iwl_mvm_add_sta_cmd cmd;
-	int ret;
-	u32 status;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.sta_id = sta->sta_id;
-	cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
-							     color));
-	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
-		cmd.station_type = sta->type;
-
-	if (!iwl_mvm_has_new_tx_api(mvm))
-		cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
-	cmd.tid_disable_tx = cpu_to_le16(0xffff);
-
-	if (addr)
-		memcpy(cmd.addr, addr, ETH_ALEN);
-
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA,
-					  iwl_mvm_add_sta_cmd_size(mvm),
-					  &cmd, &status);
-	if (ret)
-		return ret;
-
-	switch (status & IWL_ADD_STA_STATUS_MASK) {
-	case ADD_STA_SUCCESS:
-		IWL_DEBUG_INFO(mvm, "Internal station added.\n");
-		return 0;
-	default:
-		ret = -EIO;
-		IWL_ERR(mvm, "Add internal station failed, status=0x%x\n",
-			status);
-		break;
-	}
-	return ret;
-}
-
 static void iwl_mvm_enable_aux_queue(struct iwl_mvm *mvm)
 {
 	unsigned int wdg_timeout = iwlmvm_mod_params.tfd_q_hang_detect ?
-- 
2.13.2
