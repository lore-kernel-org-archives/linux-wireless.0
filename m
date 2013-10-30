Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3J3UcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/9] iwlwifi: mvm: update UAPSD support TLV bits
Date: Wed, 30 Oct 2013 22:31:29 +0200
Message-Id: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213213_547571_C82DB327)
In-Reply-To: <527143AA.5070900@gmail.com>
References: <527143AA.5070900@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Change old UAPSD bit to PM_CMD_SUPPORT, and add a new bit to indicate
real UAPSD support.
Don't use UAPSD when the firmware doesn't support it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 87b66a8..75db0871 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -100,7 +100,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_NEWBT_COEX		= BIT(5),
-	IWL_UCODE_TLV_FLAGS_UAPSD		= BIT(6),
+	IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT	= BIT(6),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
 	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
 	IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2	= BIT(9),
@@ -113,6 +113,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_SCHED_SCAN		= BIT(17),
 	IWL_UCODE_TLV_FLAGS_STA_KEY_CMD		= BIT(19),
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
+	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f40685c..74bc2c8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -164,8 +164,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_UAPSD;
+		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
@@ -180,6 +179,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT) {
+		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
+		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
+		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
+	}
+
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
@@ -204,8 +209,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->max_remain_on_channel_duration = 10000;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
-	hw->uapsd_queues = IWL_UAPSD_AC_INFO;
-	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
 	/* Extract MAC address */
 	memcpy(mvm->addresses[0].addr, mvm->nvm_data->hw_addr, ETH_ALEN);
@@ -861,7 +864,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		/* reset rssi values */
 		mvmvif->bf_data.ave_beacon_signal = 0;
 
-		if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD)) {
+		if (!(mvm->fw->ucode_capa.flags &
+					IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)) {
 			/* Workaround for FW bug, otherwise FW disables device
 			 * power save upon disassociation
 			 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 59b7cb3..d86083c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -459,7 +459,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (err)
 		goto out_unregister;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD)
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT)
 		mvm->pm_ops = &pm_mac_ops;
 	else
 		mvm->pm_ops = &pm_legacy_ops;
-- 
1.8.3.2

