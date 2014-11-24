Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35506 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaKXOfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:37 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5862321wiv.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/75] iwlwifi: mvm: BT Coex - add support for TTC / RRC
Date: Mon, 24 Nov 2014 16:34:00 +0200
Message-Id: <1416839691-28533-24-git-send-email-egrumbach@gmail.com> (sfid-20141124_154350_791724_622C68E2)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The TTC and RRC features are supported by the newer
firmwares. It allows to reach better overall WiFi and BT
performance. When the RRC is enabled, we don't need to force
the AP to send SISO frames, but it can keeps sending MIMO
frames.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 13 ++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/constants.h   |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h |  9 ++++++++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index cda5111..b3210cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -612,7 +612,9 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 					    BT_VALID_ANT_ISOLATION_THRS |
 					    BT_VALID_TXTX_DELTA_FREQ_THRS |
 					    BT_VALID_TXRX_MAX_FREQ_0 |
-					    BT_VALID_SYNC_TO_SCO);
+					    BT_VALID_SYNC_TO_SCO |
+					    BT_VALID_TTC |
+					    BT_VALID_RRC);
 
 	if (IWL_MVM_BT_COEX_SYNC2SCO)
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
@@ -628,6 +630,12 @@ int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm)
 		bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_MULTI_PRIO_LUT);
 	}
 
+	if (IWL_MVM_BT_COEX_TTC)
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_TTC);
+
+	if (IWL_MVM_BT_COEX_RRC)
+		bt_cmd->flags |= cpu_to_le32(BT_COEX_RRC);
+
 	if (mvm->cfg->bt_shared_single_ant)
 		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
 		       sizeof(iwl_single_shared_ant));
@@ -824,6 +832,9 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	if (!vif->bss_conf.assoc)
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
+	if (data->notif->rrc_enabled & BIT(mvmvif->phy_ctxt->id))
+		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+
 	IWL_DEBUG_COEX(data->mvm,
 		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
 		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 5c1ea80..1716031 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -92,6 +92,8 @@
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		0
 #define IWL_MVM_BT_COEX_MPLUT			1
+#define IWL_MVM_BT_COEX_RRC			1
+#define IWL_MVM_BT_COEX_TTC			1
 #define IWL_MVM_BT_COEX_MPLUT_REG0		0x2e402280
 #define IWL_MVM_BT_COEX_MPLUT_REG1		0x7711a751
 #define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 816883f..f3b1189 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -84,6 +84,8 @@
  * @BT_COEX_SYNC2SCO:
  * @BT_COEX_CORUNNING:
  * @BT_COEX_MPLUT:
+ * @BT_COEX_TTC:
+ * @BT_COEX_RRC:
  *
  * The COEX_MODE must be set for each command. Even if it is not changed.
  */
@@ -100,6 +102,8 @@ enum iwl_bt_coex_flags {
 	BT_COEX_SYNC2SCO		= BIT(7),
 	BT_COEX_CORUNNING		= BIT(8),
 	BT_COEX_MPLUT			= BIT(9),
+	BT_COEX_TTC			= BIT(20),
+	BT_COEX_RRC			= BIT(21),
 };
 
 /*
@@ -127,6 +131,8 @@ enum iwl_bt_coex_valid_bit_msk {
 	BT_VALID_TXTX_DELTA_FREQ_THRS	= BIT(16),
 	BT_VALID_TXRX_MAX_FREQ_0	= BIT(17),
 	BT_VALID_SYNC_TO_SCO		= BIT(18),
+	BT_VALID_TTC			= BIT(20),
+	BT_VALID_RRC			= BIT(21),
 };
 
 /**
@@ -506,7 +512,8 @@ struct iwl_bt_coex_profile_notif_old {
 	u8 bt_agg_traffic_load;
 	u8 bt_ci_compliance;
 	u8 ttc_enabled;
-	__le16 reserved;
+	u8 rrc_enabled;
+	u8 reserved;
 
 	__le32 primary_ch_lut;
 	__le32 secondary_ch_lut;
-- 
1.9.1

