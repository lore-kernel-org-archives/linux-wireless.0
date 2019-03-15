Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46656C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15C9B2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbfCOQgr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:47 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44246 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729141AbfCOQgq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:46 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp5-0004qp-Kn; Fri, 15 Mar 2019 18:36:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:22 +0200
Message-Id: <20190315163634.17315-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/16] iwlwifi: support new NVM response API
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Support REGULATORY_NVM_GET_INFO_RSP_API_S_VER_4.
This API adds the new 6-7GHz channels.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 39 +++++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 ++
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 46 +++++++++++++------
 3 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 93b392f0c6a4..97b49843e318 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright(C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright(C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -233,7 +233,8 @@ struct iwl_nvm_get_info_phy {
 	__le32 rx_chains;
 } __packed; /* REGULATORY_NVM_GET_INFO_PHY_SKU_SECTION_S_VER_1 */
 
-#define IWL_NUM_CHANNELS (51)
+#define IWL_NUM_CHANNELS_V1	51
+#define IWL_NUM_CHANNELS	110
 
 /**
  * struct iwl_nvm_get_info_regulatory - regulatory information
@@ -241,12 +242,38 @@ struct iwl_nvm_get_info_phy {
  * @channel_profile: regulatory data of this channel
  * @reserved: reserved
  */
-struct iwl_nvm_get_info_regulatory {
+struct iwl_nvm_get_info_regulatory_v1 {
 	__le32 lar_enabled;
-	__le16 channel_profile[IWL_NUM_CHANNELS];
+	__le16 channel_profile[IWL_NUM_CHANNELS_V1];
 	__le16 reserved;
 } __packed; /* REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_1 */
 
+/**
+ * struct iwl_nvm_get_info_regulatory - regulatory information
+ * @lar_enabled: is LAR enabled
+ * @n_channels: number of valid channels in the array
+ * @channel_profile: regulatory data of this channel
+ */
+struct iwl_nvm_get_info_regulatory {
+	__le32 lar_enabled;
+	__le32 n_channels;
+	__le32 channel_profile[IWL_NUM_CHANNELS];
+} __packed; /* REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_2 */
+
+/**
+ * struct iwl_nvm_get_info_rsp_v3 - response to get NVM data
+ * @general: general NVM data
+ * @mac_sku: data relating to MAC sku
+ * @phy_sku: data relating to PHY sku
+ * @regulatory: regulatory data
+ */
+struct iwl_nvm_get_info_rsp_v3 {
+	struct iwl_nvm_get_info_general general;
+	struct iwl_nvm_get_info_sku mac_sku;
+	struct iwl_nvm_get_info_phy phy_sku;
+	struct iwl_nvm_get_info_regulatory_v1 regulatory;
+} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_3 */
+
 /**
  * struct iwl_nvm_get_info_rsp - response to get NVM data
  * @general: general NVM data
@@ -259,7 +286,7 @@ struct iwl_nvm_get_info_rsp {
 	struct iwl_nvm_get_info_sku mac_sku;
 	struct iwl_nvm_get_info_phy phy_sku;
 	struct iwl_nvm_get_info_regulatory regulatory;
-} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_3 */
+} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_4 */
 
 /**
  * struct iwl_nvm_access_complete_cmd - NVM_ACCESS commands are completed
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 04ad6b96a28b..3f26dee1b29c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -272,6 +272,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	version of the beacon notification.
  * @IWL_UCODE_TLV_API_BEACON_FILTER_V4: This ucode supports v4 of
  *	BEACON_FILTER_CONFIG_API_S_VER_4.
+ * @IWL_UCODE_TLV_API_REGULATORY_NVM_INFO: This ucode supports v4 of
+ *	REGULATORY_NVM_GET_INFO_RSP_API_S.
  * @IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ: This ucode supports v7 of
  *	LOCATION_RANGE_REQ_CMD_API_S and v6 of LOCATION_RANGE_RESP_NTFY_API_S.
  *
@@ -300,6 +302,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_REDUCE_TX_POWER	= (__force iwl_ucode_tlv_api_t)45,
 	IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF	= (__force iwl_ucode_tlv_api_t)46,
 	IWL_UCODE_TLV_API_BEACON_FILTER_V4      = (__force iwl_ucode_tlv_api_t)47,
+	IWL_UCODE_TLV_API_REGULATORY_NVM_INFO   = (__force iwl_ucode_tlv_api_t)48,
 	IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ     = (__force iwl_ucode_tlv_api_t)49,
 
 	NUM_IWL_UCODE_TLV_API
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index a20ac68f4ba3..1408c89242a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -226,7 +226,7 @@ enum iwl_nvm_channel_flags {
 };
 
 static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
-					       int chan, u16 flags)
+					       int chan, u32 flags)
 {
 #define CHECK_AND_PRINT_I(x)	\
 	((flags & NVM_CHANNEL_##x) ? " " #x : "")
@@ -257,7 +257,7 @@ static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
 }
 
 static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
-				 u16 nvm_flags, const struct iwl_cfg *cfg)
+				 u32 nvm_flags, const struct iwl_cfg *cfg)
 {
 	u32 flags = IEEE80211_CHAN_NO_HT40;
 
@@ -301,13 +301,13 @@ static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
 
 static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 				struct iwl_nvm_data *data,
-				const __le16 * const nvm_ch_flags,
-				u32 sbands_flags)
+				const void * const nvm_ch_flags,
+				u32 sbands_flags, bool v4)
 {
 	int ch_idx;
 	int n_channels = 0;
 	struct ieee80211_channel *channel;
-	u16 ch_flags;
+	u32 ch_flags;
 	int num_of_ch, num_2ghz_channels = NUM_2GHZ_CHANNELS;
 	const u16 *nvm_chan;
 
@@ -325,7 +325,12 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
 		bool is_5ghz = (ch_idx >= num_2ghz_channels);
 
-		ch_flags = __le16_to_cpup(nvm_ch_flags + ch_idx);
+		if (v4)
+			ch_flags =
+				__le32_to_cpup((__le32 *)nvm_ch_flags + ch_idx);
+		else
+			ch_flags =
+				__le16_to_cpup((__le16 *)nvm_ch_flags + ch_idx);
 
 		if (is_5ghz && !data->sku_cap_band_52ghz_enable)
 			continue;
@@ -671,15 +676,15 @@ static void iwl_init_he_hw_capab(struct ieee80211_supported_band *sband,
 
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 			    struct iwl_nvm_data *data,
-			    const __le16 *nvm_ch_flags, u8 tx_chains,
-			    u8 rx_chains, u32 sbands_flags)
+			    const void *nvm_ch_flags, u8 tx_chains,
+			    u8 rx_chains, u32 sbands_flags, bool v4)
 {
 	int n_channels;
 	int n_used = 0;
 	struct ieee80211_supported_band *sband;
 
 	n_channels = iwl_init_channel_map(dev, cfg, data, nvm_ch_flags,
-					  sbands_flags);
+					  sbands_flags, v4);
 	sband = &data->bands[NL80211_BAND_2GHZ];
 	sband->band = NL80211_BAND_2GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_24_OFFS];
@@ -1016,7 +1021,7 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		sbands_flags |= IWL_NVM_SBANDS_FLAGS_NO_WIDE_IN_5GHZ;
 
 	iwl_init_sbands(dev, cfg, data, ch_section, tx_chains, rx_chains,
-			sbands_flags);
+			sbands_flags, false);
 	data->calib_version = 255;
 
 	return data;
@@ -1407,7 +1412,6 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 				 const struct iwl_fw *fw)
 {
 	struct iwl_nvm_get_info cmd = {};
-	struct iwl_nvm_get_info_rsp *rsp;
 	struct iwl_nvm_data *nvm;
 	struct iwl_host_cmd hcmd = {
 		.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
@@ -1422,12 +1426,24 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	bool empty_otp;
 	u32 mac_flags;
 	u32 sbands_flags = 0;
+	/*
+	 * All the values in iwl_nvm_get_info_rsp v4 are the same as
+	 * in v3, except for the channel profile part of the
+	 * regulatory.  So we can just access the new struct, with the
+	 * exception of the latter.
+	 */
+	struct iwl_nvm_get_info_rsp *rsp;
+	struct iwl_nvm_get_info_rsp_v3 *rsp_v3;
+	bool v4 = fw_has_api(&fw->ucode_capa,
+			     IWL_UCODE_TLV_API_REGULATORY_NVM_INFO);
+	size_t rsp_size = v4 ? sizeof(*rsp) : sizeof(*rsp_v3);
+	void *channel_profile;
 
 	ret = iwl_trans_send_cmd(trans, &hcmd);
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (WARN(iwl_rx_packet_payload_len(hcmd.resp_pkt) != sizeof(*rsp),
+	if (WARN(iwl_rx_packet_payload_len(hcmd.resp_pkt) != rsp_size,
 		 "Invalid payload len in NVM response from FW %d",
 		 iwl_rx_packet_payload_len(hcmd.resp_pkt))) {
 		ret = -EINVAL;
@@ -1489,11 +1505,15 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 		sbands_flags |= IWL_NVM_SBANDS_FLAGS_LAR;
 	}
 
+	rsp_v3 = (void *)rsp;
+	channel_profile = v4 ? (void *)rsp->regulatory.channel_profile :
+			  (void *)rsp_v3->regulatory.channel_profile;
+
 	iwl_init_sbands(trans->dev, trans->cfg, nvm,
 			rsp->regulatory.channel_profile,
 			nvm->valid_tx_ant & fw->valid_tx_ant,
 			nvm->valid_rx_ant & fw->valid_rx_ant,
-			sbands_flags);
+			sbands_flags, v4);
 
 	iwl_free_resp(&hcmd);
 	return nvm;
-- 
2.20.1

