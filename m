Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4314 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbbFCHcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:32:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/15] iwlwifi: prepare for higher API/CAPA bits
Date: Wed,  3 Jun 2015 10:31:32 +0300
Message-Id: <1433316696-4612-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093351_068422_4D11C0C4)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, loading the firmware fails when it has higher API or CAPA
bits than the driver supports. That's an issue with integration.

At the same time, actually using api[0] and capa[0] will become
confusing when we also have api[1] and capa[1], and it's almost
certain that we'll mix up the bits and use the bits for api[1] with
api[0] by accident.

Avoid all this by translating the API/CAPA bits to the regular kernel
test_bit() format, and also providing wrapper functions. Also use the
__bitwise__ facility of sparse to check that we're testing the right
one.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c      | 26 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h  | 67 ++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-fw.h       | 20 +++++++--
 drivers/net/wireless/iwlwifi/mvm/coex.c     | 22 +++++-----
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |  9 ++--
 drivers/net/wireless/iwlwifi/mvm/fw.c       |  4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 47 ++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 21 +++++----
 drivers/net/wireless/iwlwifi/mvm/nvm.c      |  8 ++--
 drivers/net/wireless/iwlwifi/mvm/rs.c       | 10 ++---
 drivers/net/wireless/iwlwifi/mvm/rx.c       |  4 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 33 +++++++-------
 drivers/net/wireless/iwlwifi/mvm/tx.c       |  4 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c    |  2 +-
 14 files changed, 161 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 12566c8..6685259 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -423,13 +423,19 @@ static int iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
 {
 	const struct iwl_ucode_api *ucode_api = (void *)data;
 	u32 api_index = le32_to_cpu(ucode_api->api_index);
+	u32 api_flags = le32_to_cpu(ucode_api->api_flags);
+	int i;
 
-	if (api_index >= IWL_API_ARRAY_SIZE) {
+	if (api_index >= IWL_API_MAX_BITS / 32) {
 		IWL_ERR(drv, "api_index larger than supported by driver\n");
-		return -EINVAL;
+		/* don't return an error so we can load FW that has more bits */
+		return 0;
 	}
 
-	capa->api[api_index] = le32_to_cpu(ucode_api->api_flags);
+	for (i = 0; i < 32; i++) {
+		if (api_flags & BIT(i))
+			__set_bit(i + 32 * api_index, capa->_api);
+	}
 
 	return 0;
 }
@@ -439,13 +445,19 @@ static int iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
 {
 	const struct iwl_ucode_capa *ucode_capa = (void *)data;
 	u32 api_index = le32_to_cpu(ucode_capa->api_index);
+	u32 api_flags = le32_to_cpu(ucode_capa->api_capa);
+	int i;
 
-	if (api_index >= IWL_CAPABILITIES_ARRAY_SIZE) {
+	if (api_index >= IWL_CAPABILITIES_MAX_BITS / 32) {
 		IWL_ERR(drv, "api_index larger than supported by driver\n");
-		return -EINVAL;
+		/* don't return an error so we can load FW that has more bits */
+		return 0;
 	}
 
-	capa->capa[api_index] = le32_to_cpu(ucode_capa->api_capa);
+	for (i = 0; i < 32; i++) {
+		if (api_flags & BIT(i))
+			__set_bit(i + 32 * api_index, capa->_capa);
+	}
 
 	return 0;
 }
@@ -1148,7 +1160,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		goto try_again;
 
-	if (drv->fw.ucode_capa.api[0] & IWL_UCODE_TLV_API_NEW_VERSION)
+	if (fw_has_api(&drv->fw.ucode_capa, IWL_UCODE_TLV_API_NEW_VERSION))
 		api_ver = drv->fw.ucode_ver;
 	else
 		api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 5b7c0ae..7efd629 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -237,6 +237,8 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
 };
 
+typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
+
 /**
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_BT_COEX_SPLIT: new API for BT Coex
@@ -259,21 +261,23 @@ enum iwl_ucode_tlv_flag {
  *	instead of 3.
  */
 enum iwl_ucode_tlv_api {
-	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
-	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
-	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= BIT(9),
-	IWL_UCODE_TLV_API_HDC_PHASE_0		= BIT(10),
-	IWL_UCODE_TLV_API_TX_POWER_DEV		= BIT(11),
-	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
-	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
-	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= BIT(16),
-	IWL_UCODE_TLV_API_ASYNC_DTM		= BIT(17),
-	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= BIT(18),
-	IWL_UCODE_TLV_API_STATS_V10		= BIT(19),
-	IWL_UCODE_TLV_API_NEW_VERSION		= BIT(20),
-	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= BIT(24),
+	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = (__force iwl_ucode_tlv_api_t)3,
+	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= (__force iwl_ucode_tlv_api_t)8,
+	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
+	IWL_UCODE_TLV_API_HDC_PHASE_0		= (__force iwl_ucode_tlv_api_t)10,
+	IWL_UCODE_TLV_API_TX_POWER_DEV		= (__force iwl_ucode_tlv_api_t)11,
+	IWL_UCODE_TLV_API_BASIC_DWELL		= (__force iwl_ucode_tlv_api_t)13,
+	IWL_UCODE_TLV_API_SCD_CFG		= (__force iwl_ucode_tlv_api_t)15,
+	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
+	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
+	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
+	IWL_UCODE_TLV_API_STATS_V10		= (__force iwl_ucode_tlv_api_t)19,
+	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
+	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
 };
 
+typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
+
 /**
  * enum iwl_ucode_tlv_capa - ucode capabilities
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
@@ -302,22 +306,22 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  */
 enum iwl_ucode_tlv_capa {
-	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
-	IWL_UCODE_TLV_CAPA_LAR_SUPPORT			= BIT(1),
-	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= BIT(2),
-	IWL_UCODE_TLV_CAPA_BEAMFORMER			= BIT(3),
-	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= BIT(6),
-	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
-	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
-	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
-	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
-	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= BIT(12),
-	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= BIT(13),
-	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= BIT(18),
-	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= BIT(22),
-	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= BIT(28),
-	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= BIT(29),
-	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= BIT(30),
+	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= (__force iwl_ucode_tlv_capa_t)0,
+	IWL_UCODE_TLV_CAPA_LAR_SUPPORT			= (__force iwl_ucode_tlv_capa_t)1,
+	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= (__force iwl_ucode_tlv_capa_t)2,
+	IWL_UCODE_TLV_CAPA_BEAMFORMER			= (__force iwl_ucode_tlv_capa_t)3,
+	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= (__force iwl_ucode_tlv_capa_t)6,
+	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= (__force iwl_ucode_tlv_capa_t)8,
+	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= (__force iwl_ucode_tlv_capa_t)9,
+	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= (__force iwl_ucode_tlv_capa_t)10,
+	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= (__force iwl_ucode_tlv_capa_t)11,
+	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			= (__force iwl_ucode_tlv_capa_t)12,
+	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= (__force iwl_ucode_tlv_capa_t)13,
+	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)18,
+	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= (__force iwl_ucode_tlv_capa_t)22,
+	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= (__force iwl_ucode_tlv_capa_t)28,
+	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
+	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 };
 
 /* The default calibrate table size if not specified by firmware file */
@@ -328,13 +332,14 @@ enum iwl_ucode_tlv_capa {
 /* The default max probe length if not specified by the firmware file */
 #define IWL_DEFAULT_MAX_PROBE_LENGTH	200
 
+#define IWL_API_MAX_BITS		64
+#define IWL_CAPABILITIES_MAX_BITS	64
+
 /*
  * For 16.0 uCode and above, there is no differentiation between sections,
  * just an offset to the HW address.
  */
 #define IWL_UCODE_SECTION_MAX 12
-#define IWL_API_ARRAY_SIZE	1
-#define IWL_CAPABILITIES_ARRAY_SIZE	1
 #define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
 
 /* uCode version contains 4 values: Major/Minor/API/Serial */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index cdc7f1e..3e3c9d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -105,10 +105,24 @@ struct iwl_ucode_capabilities {
 	u32 n_scan_channels;
 	u32 standard_phy_calibration_size;
 	u32 flags;
-	u32 api[IWL_API_ARRAY_SIZE];
-	u32 capa[IWL_CAPABILITIES_ARRAY_SIZE];
+	unsigned long _api[BITS_TO_LONGS(IWL_API_MAX_BITS)];
+	unsigned long _capa[BITS_TO_LONGS(IWL_CAPABILITIES_MAX_BITS)];
 };
 
+static inline bool
+fw_has_api(const struct iwl_ucode_capabilities *capabilities,
+	   iwl_ucode_tlv_api_t api)
+{
+	return test_bit((__force long)api, capabilities->_api);
+}
+
+static inline bool
+fw_has_capa(const struct iwl_ucode_capabilities *capabilities,
+	    iwl_ucode_tlv_capa_t capa)
+{
+	return test_bit((__force long)capa, capabilities->_capa);
+}
+
 /* one for each uCode image (inst/data, init/runtime/wowlan) */
 struct fw_desc {
 	const void *data;	/* vmalloc'ed data */
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 662fa9c..b4737e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -411,7 +411,7 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	struct iwl_bt_coex_cmd bt_cmd = {};
 	u32 mode;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_send_bt_init_conf_old(mvm);
 
 	lockdep_assert_held(&mvm->mutex);
@@ -732,7 +732,7 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *notif = (void *)pkt->data;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_rx_bt_coex_notif_old(mvm, rxb, dev_cmd);
 
 	IWL_DEBUG_COEX(mvm, "BT Coex Notification received\n");
@@ -762,7 +762,8 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
 		iwl_mvm_bt_rssi_event_old(mvm, vif, rssi_event);
 		return;
 	}
@@ -813,7 +814,7 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 	struct iwl_mvm_phy_ctxt *phy_ctxt = mvmvif->phy_ctxt;
 	enum iwl_bt_coex_lut_type lut_type;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_coex_agg_time_limit_old(mvm, sta);
 
 	if (IWL_COEX_IS_TTC_ON(mvm->last_bt_notif.ttc_rrc_status, phy_ctxt->id))
@@ -840,7 +841,7 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	struct iwl_mvm_phy_ctxt *phy_ctxt = mvmvif->phy_ctxt;
 	enum iwl_bt_coex_lut_type lut_type;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_mimo_allowed_old(mvm, sta);
 
 	if (IWL_COEX_IS_TTC_ON(mvm->last_bt_notif.ttc_rrc_status, phy_ctxt->id))
@@ -870,7 +871,7 @@ bool iwl_mvm_bt_coex_is_ant_avail(struct iwl_mvm *mvm, u8 ant)
 	if (ant & mvm->cfg->non_shared_ant)
 		return true;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_shared_ant_avail_old(mvm);
 
 	return le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
@@ -883,7 +884,7 @@ bool iwl_mvm_bt_coex_is_shared_ant_avail(struct iwl_mvm *mvm)
 	if (mvm->cfg->bt_shared_single_ant)
 		return true;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_shared_ant_avail_old(mvm);
 
 	return le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) < BT_HIGH_TRAFFIC;
@@ -894,7 +895,7 @@ bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 {
 	u32 bt_activity = le32_to_cpu(mvm->last_bt_notif.bt_activity_grading);
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_tpc_allowed_old(mvm, band);
 
 	if (band != IEEE80211_BAND_2GHZ)
@@ -937,7 +938,8 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 
 void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
 {
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
 		iwl_mvm_bt_coex_vif_change_old(mvm);
 		return;
 	}
@@ -955,7 +957,7 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	u8 __maybe_unused lower_bound, upper_bound;
 	u8 lut;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_rx_ant_coupling_notif_old(mvm, rxb, dev_cmd);
 
 	if (!iwl_mvm_bt_is_plcr_supported(mvm))
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 8c17b94..ffb4b5c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -493,7 +493,8 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
 		struct iwl_bt_coex_profile_notif_old *notif =
 			&mvm->last_bt_notif_old;
 
@@ -550,7 +551,8 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 
 	mutex_lock(&mvm->mutex);
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
 		struct iwl_bt_coex_ci_cmd_old *cmd = &mvm->last_bt_ci_cmd_old;
 
 		pos += scnprintf(buf+pos, bufsz-pos,
@@ -916,7 +918,8 @@ iwl_dbgfs_scan_ant_rxchain_write(struct iwl_mvm *mvm, char *buf,
 
 	if (mvm->scan_rx_ant != scan_rx_ant) {
 		mvm->scan_rx_ant = scan_rx_ant;
-		if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_UMAC_SCAN))
 			iwl_mvm_config_scan(mvm);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 2f76fb2..eb10c5e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -623,7 +623,7 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 	if (!mvm->trans->ltr_enabled)
 		return 0;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_HDC_PHASE_0))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_HDC_PHASE_0))
 		return iwl_mvm_config_ltr_v1(mvm);
 
 	return iwl_mvm_send_cmd_pdu(mvm, LTR_CONFIG, 0,
@@ -754,7 +754,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			goto error;
 	}
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		ret = iwl_mvm_config_scan(mvm);
 		if (ret)
 			goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 57d75d1..c46c69f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -515,7 +515,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	BUILD_BUG_ON(IWL_MVM_MAX_UMAC_SCANS > HWEIGHT32(IWL_MVM_SCAN_MASK) ||
 		     IWL_MVM_MAX_LMAC_SCANS > HWEIGHT32(IWL_MVM_SCAN_MASK));
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
 		mvm->max_scans = IWL_MVM_MAX_UMAC_SCANS;
 	else
 		mvm->max_scans = IWL_MVM_MAX_LMAC_SCANS;
@@ -527,10 +527,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
 
-		if ((mvm->fw->ucode_capa.capa[0] &
-		     IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
-		    (mvm->fw->ucode_capa.api[0] &
-		     IWL_UCODE_TLV_API_LQ_SS_PARAMS))
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
+		    fw_has_api(&mvm->fw->ucode_capa,
+			       IWL_UCODE_TLV_API_LQ_SS_PARAMS))
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap.cap |=
 				IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
 	}
@@ -556,20 +556,20 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			       NL80211_FEATURE_STATIC_SMPS |
 			       NL80211_FEATURE_SUPPORTS_WMM_ADMISSION;
 
-	if (mvm->fw->ucode_capa.capa[0] &
-	    IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT)
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT))
 		hw->wiphy->features |= NL80211_FEATURE_TX_POWER_INSERTION;
-	if (mvm->fw->ucode_capa.capa[0] &
-	    IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT)
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT))
 		hw->wiphy->features |= NL80211_FEATURE_QUIET;
 
-	if (mvm->fw->ucode_capa.capa[0] &
-	    IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT)
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT))
 		hw->wiphy->features |=
 			NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES;
 
-	if (mvm->fw->ucode_capa.capa[0] &
-	    IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT)
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT))
 		hw->wiphy->features |= NL80211_FEATURE_WFA_TPC_IE_IN_PROBES;
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
@@ -619,13 +619,14 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (ret)
 		return ret;
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_TDLS_SUPPORT) {
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_TDLS_SUPPORT)) {
 		IWL_DEBUG_TDLS(mvm, "TDLS supported\n");
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	}
 
-	if (mvm->fw->ucode_capa.capa[0] &
-	    IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH) {
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH)) {
 		IWL_DEBUG_TDLS(mvm, "TDLS channel switch supported\n");
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
@@ -1500,7 +1501,7 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	/* We shouldn't have any UIDs still set.  Loop over all the UIDs to
 	 * make sure there's nothing left there and warn if any is found.
 	 */
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		int i;
 
 		for (i = 0; i < mvm->max_scans; i++) {
@@ -1572,7 +1573,7 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		.pwr_restriction = cpu_to_le16(8 * tx_power),
 	};
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_TX_POWER_DEV))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_TX_POWER_DEV))
 		return iwl_mvm_set_tx_power_old(mvm, vif, tx_power);
 
 	if (tx_power == IWL_DEFAULT_MAX_TX_POWER)
@@ -3102,8 +3103,8 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		if (mvm->fw->ucode_capa.capa[0] &
-		    IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT) {
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT)) {
 			/* Use aux roc framework (HS20) */
 			ret = iwl_mvm_send_aux_roc_cmd(mvm, channel,
 						       vif, duration);
@@ -3895,7 +3896,7 @@ static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	if (!(mvm->fw->ucode_capa.capa[0] &
+	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
 		return -ENOENT;
 
@@ -3942,8 +3943,8 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-	if (!(mvm->fw->ucode_capa.capa[0] &
-				IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
 		return;
 
 	/* if beacon filtering isn't on mac80211 does it anyway */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 0173ad1..255cde4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -889,14 +889,15 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 	return mvm->trans->cfg->d0i3 &&
 	       mvm->trans->d0i3_mode != IWL_D0I3_MODE_OFF &&
 	       !iwlwifi_mod_params.d0i3_disable &&
-	       (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
+	       fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
 static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 {
 	bool nvm_lar = mvm->nvm_data->lar_enabled;
-	bool tlv_lar = mvm->fw->ucode_capa.capa[0] &
-		IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+	bool tlv_lar = fw_has_capa(&mvm->fw->ucode_capa,
+				   IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
 
 	if (iwlwifi_mod_params.lar_disable)
 		return false;
@@ -913,24 +914,28 @@ static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_wifi_mcc_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WIFI_MCC_UPDATE ||
-	       mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC;
+	return fw_has_api(&mvm->fw->ucode_capa,
+			  IWL_UCODE_TLV_API_WIFI_MCC_UPDATE) ||
+	       fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC);
 }
 
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SCD_CFG;
+	return fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_SCD_CFG);
 }
 
 static inline bool iwl_mvm_bt_is_plcr_supported(struct iwl_mvm *mvm)
 {
-	return (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BT_COEX_PLCR) &&
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_BT_COEX_PLCR) &&
 		IWL_MVM_BT_COEX_CORUNNING;
 }
 
 static inline bool iwl_mvm_bt_is_rrc_supported(struct iwl_mvm *mvm)
 {
-	return (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BT_COEX_RRC) &&
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_BT_COEX_RRC) &&
 		IWL_MVM_BT_COEX_RRC;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 4701424..2a6be35 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -316,8 +316,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	phy_sku = (const __le16 *)sections[NVM_SECTION_TYPE_PHY_SKU].data;
 
 	lar_enabled = !iwlwifi_mod_params.lar_disable &&
-		      (mvm->fw->ucode_capa.capa[0] &
-		       IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
+		      fw_has_capa(&mvm->fw->ucode_capa,
+				  IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
 
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override, phy_sku,
@@ -792,8 +792,8 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	char mcc[3];
 
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
-		tlv_lar = mvm->fw->ucode_capa.capa[0] &
-			IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+		tlv_lar = fw_has_capa(&mvm->fw->ucode_capa,
+				      IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
 		nvm_lar = mvm->nvm_data->lar_enabled;
 		if (tlv_lar != nvm_lar)
 			IWL_INFO(mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index ae99656..daff1d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1127,8 +1127,8 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	u32 tx_resp_hwrate = (uintptr_t)info->status.status_driver_data[1];
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
-	bool allow_ant_mismatch = mvm->fw->ucode_capa.api[0] &
-		IWL_UCODE_TLV_API_LQ_SS_PARAMS;
+	bool allow_ant_mismatch = fw_has_api(&mvm->fw->ucode_capa,
+					     IWL_UCODE_TLV_API_LQ_SS_PARAMS);
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
@@ -2714,7 +2714,7 @@ static void rs_vht_init(struct iwl_mvm *mvm,
 	    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))
 		lq_sta->stbc_capable = true;
 
-	if ((mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_BEAMFORMER) &&
 	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
 	    (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE))
 		lq_sta->bfer_capable = true;
@@ -2998,7 +2998,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
 
 	/* TODO: remove old API when min FW API hits 14 */
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS) &&
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_LQ_SS_PARAMS) &&
 	    rs_stbc_allow(mvm, sta, lq_sta))
 		rate.stbc = true;
 
@@ -3212,7 +3212,7 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 
 	rs_build_rates_table(mvm, sta, lq_sta, initial_rate);
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS)
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_LQ_SS_PARAMS))
 		rs_set_lq_ss_params(mvm, sta, lq_sta, initial_rate);
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index d6314dd..8f1d93b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -570,7 +570,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 	};
 	u32 temperature;
 
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_STATS_V10) {
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STATS_V10)) {
 		struct iwl_notif_statistics_v10 *stats = (void *)&pkt->data;
 
 		if (iwl_rx_packet_payload_len(pkt) != v10_len)
@@ -610,7 +610,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 	/* Only handle rx statistics temperature changes if async temp
 	 * notifications are not supported
 	 */
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_ASYNC_DTM))
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_ASYNC_DTM))
 		iwl_mvm_tt_temp_changed(mvm, temperature);
 
 	ieee80211_iterate_active_interfaces(mvm->hw,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 794109e..5de1449 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -160,7 +160,7 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
 static u16 iwl_mvm_get_active_dwell(struct iwl_mvm *mvm,
 				    enum ieee80211_band band, int n_ssids)
 {
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BASIC_DWELL)
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BASIC_DWELL))
 		return 10;
 	if (band == IEEE80211_BAND_2GHZ)
 		return 20  + 3 * (n_ssids + 1);
@@ -170,7 +170,7 @@ static u16 iwl_mvm_get_active_dwell(struct iwl_mvm *mvm,
 static u16 iwl_mvm_get_passive_dwell(struct iwl_mvm *mvm,
 				     enum ieee80211_band band)
 {
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BASIC_DWELL)
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BASIC_DWELL))
 			return 110;
 	return band == IEEE80211_BAND_2GHZ ? 100 + 20 : 100 + 10;
 }
@@ -205,8 +205,9 @@ static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
 	params->max_out_time = 120;
 
 	if (iwl_mvm_low_latency(mvm)) {
-		if (mvm->fw->ucode_capa.api[0] &
-		    IWL_UCODE_TLV_API_FRAGMENTED_SCAN) {
+		if (fw_has_api(&mvm->fw->ucode_capa,
+			       IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
+
 			params->suspend_time = 105;
 			/*
 			 * If there is more than one active interface make
@@ -220,8 +221,9 @@ static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
 		}
 	}
 
-	if (frag_passive_dwell && (mvm->fw->ucode_capa.api[0] &
-				   IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
+	if (frag_passive_dwell &&
+	    fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
 		/*
 		 * P2P device scan should not be fragmented to avoid negative
 		 * impact on P2P device discovery. Configure max_out_time to be
@@ -273,8 +275,8 @@ not_bound:
 static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
 {
 	/* require rrm scan whenever the fw supports it */
-	return mvm->fw->ucode_capa.capa[0] &
-	       IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT;
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT);
 }
 
 static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm)
@@ -732,7 +734,8 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 static __le32 iwl_mvm_scan_priority(struct iwl_mvm *mvm,
 				    enum iwl_scan_priority_ext prio)
 {
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY)
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY))
 		return cpu_to_le32(prio);
 
 	if (prio <= IWL_SCAN_PRIORITY_EXT_2)
@@ -785,7 +788,7 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 	return ((capa->flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT) &&
 		mvm->last_ebs_successful &&
 		(n_iterations > 1 ||
-		 (capa->api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)) &&
+		 fw_has_api(capa, IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)) &&
 		vif->type != NL80211_IFTYPE_P2P_DEVICE);
 }
 
@@ -1233,7 +1236,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		hcmd.id = SCAN_REQ_UMAC;
 		ret = iwl_mvm_scan_umac(mvm, vif, &params,
 					IWL_MVM_SCAN_REGULAR);
@@ -1341,7 +1344,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		hcmd.id = SCAN_REQ_UMAC;
 		ret = iwl_mvm_scan_umac(mvm, vif, &params, IWL_MVM_SCAN_SCHED);
 	} else {
@@ -1468,7 +1471,7 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 
 	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
 		ret = iwl_mvm_umac_scan_abort(mvm, type);
 	else
 		ret = iwl_mvm_lmac_scan_abort(mvm);
@@ -1486,7 +1489,7 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 
 int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 {
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
 		return sizeof(struct iwl_scan_req_umac) +
 			sizeof(struct iwl_scan_channel_cfg_umac) *
 				mvm->fw->ucode_capa.n_scan_channels +
@@ -1504,7 +1507,7 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
  */
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 {
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
 		int uid, i;
 
 		uid = iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_REGULAR);
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 57e0cbb..7ba7a118 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -171,8 +171,8 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !is_multicast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_flags |= TX_CMD_FLG_PROT_REQUIRE;
 
-	if ((mvm->fw->ucode_capa.capa[0] &
-	     IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT) &&
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT) &&
 	    ieee80211_action_contains_tpc(skb))
 		tx_flags |= TX_CMD_FLG_WRITE_TX_POWER;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index bc55a8b..03f8e06 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -584,7 +584,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 	struct iwl_error_event_table table;
 	u32 base;
 
-	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_NEW_VERSION)) {
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_NEW_VERSION)) {
 		iwl_mvm_dump_nic_error_log_old(mvm);
 		return;
 	}
-- 
2.1.4

