Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43330 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaFXTxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:53:03 -0400
Received: by mail-wg0-f41.google.com with SMTP id a1so898032wgh.12
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:53:02 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/27] iwlwifi: mvm: Introduce an API to set STA_FLG_DISABLE_TX flag
Date: Tue, 24 Jun 2014 22:52:18 +0300
Message-Id: <1403639541-4621-24-git-send-email-egrumbach@gmail.com> (sfid-20140624_220200_383874_D2DB36F3)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Introduce new station flag STA_FLG_DISABLE_TX, which is modified with ADD_STA
command. This flag, when set, disables tx to the STA.
Provide an API (iwl_mvm_sta_modify_disable_tx) to modify this flag, which
should be used in channel switch and immediate quiet flows.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h         |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |  7 ++-----
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.h        |  2 ++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 287b949..c713310 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -120,10 +120,12 @@ enum iwl_ucode_tlv_flag {
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
  * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
+ * @IWL_UCODE_TLV_API_DISABLE_STA_TX: ucode supports tx_disable bit.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
 	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
+	IWL_UCODE_TLV_API_DISABLE_STA_TX	= BIT(5),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 39cebee..47bd040 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -67,7 +67,7 @@
  * enum iwl_sta_flags - flags for the ADD_STA host command
  * @STA_FLG_REDUCED_TX_PWR_CTRL:
  * @STA_FLG_REDUCED_TX_PWR_DATA:
- * @STA_FLG_FLG_ANT_MSK: Antenna selection
+ * @STA_FLG_DISABLE_TX: set if TX should be disabled
  * @STA_FLG_PS: set if STA is in Power Save
  * @STA_FLG_INVALID: set if STA is invalid
  * @STA_FLG_DLP_EN: Direct Link Protocol is enabled
@@ -91,10 +91,7 @@ enum iwl_sta_flags {
 	STA_FLG_REDUCED_TX_PWR_CTRL	= BIT(3),
 	STA_FLG_REDUCED_TX_PWR_DATA	= BIT(6),
 
-	STA_FLG_FLG_ANT_A		= (1 << 4),
-	STA_FLG_FLG_ANT_B		= (2 << 4),
-	STA_FLG_FLG_ANT_MSK		= (STA_FLG_FLG_ANT_A |
-					   STA_FLG_FLG_ANT_B),
+	STA_FLG_DISABLE_TX		= BIT(4),
 
 	STA_FLG_PS			= BIT(8),
 	STA_FLG_DRAIN_FLOW		= BIT(12),
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 1fb01ea..d3a6cf7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1448,3 +1448,23 @@ int iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
 
 	return 0;
 }
+
+void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
+				   struct iwl_mvm_sta *mvmsta, bool disable)
+{
+	struct iwl_mvm_add_sta_cmd cmd = {
+		.add_modify = STA_MODE_MODIFY,
+		.sta_id = mvmsta->sta_id,
+		.station_flags = disable ? cpu_to_le32(STA_FLG_DISABLE_TX) : 0,
+		.station_flags_msk = cpu_to_le32(STA_FLG_DISABLE_TX),
+		.mac_id_n_color = cpu_to_le32(mvmsta->mac_id_n_color),
+	};
+	int ret;
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_DISABLE_STA_TX))
+		return;
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index d98e8a2..10c1a53 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -404,5 +404,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				       bool agg);
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain);
+void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
+				   struct iwl_mvm_sta *mvmsta, bool disable);
 
 #endif /* __sta_h__ */
-- 
1.8.3.2

