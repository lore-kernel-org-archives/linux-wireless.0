Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCCCC282CA
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 740852146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfA0KTd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:33 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51350 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726766AbfA0KTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:32 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXE-0001vC-Vf; Sun, 27 Jan 2019 12:19:29 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:56 +0200
Message-Id: <20190127101908.6428-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/21] iwlwifi: mvm: Change FW channel info API
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: David Spinadel <david.spinadel@intel.com>

Change iwl_fw_channel_info structure so it can have channel number
greater than 255. This is needed for 6 GHz channel numbers.
Change all relevant structs and member accesses accordingly.
The new API is indicated by a TLV capability bit.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/phy-ctxt.h  | 51 +++++++++++++----
 .../net/wireless/intel/iwlwifi/fw/api/tdls.h  | 19 +++++--
 .../intel/iwlwifi/fw/api/time-event.h         | 34 ++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 30 ++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 55 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 24 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c | 33 +++++------
 .../wireless/intel/iwlwifi/mvm/time-event.c   |  4 +-
 9 files changed, 182 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h b/drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h
index 45f61c6af14e..b833b80ea3d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -95,17 +97,36 @@
 #define PHY_VHT_CTRL_POS_4_ABOVE  (0x7)
 
 /*
+ * struct iwl_fw_channel_info_v1 - channel information
+ *
  * @band: PHY_BAND_*
  * @channel: channel number
  * @width: PHY_[VHT|LEGACY]_CHANNEL_*
  * @ctrl channel: PHY_[VHT|LEGACY]_CTRL_*
  */
-struct iwl_fw_channel_info {
+struct iwl_fw_channel_info_v1 {
 	u8 band;
 	u8 channel;
 	u8 width;
 	u8 ctrl_pos;
-} __packed;
+} __packed; /* CHANNEL_CONFIG_API_S_VER_1 */
+
+/*
+ * struct iwl_fw_channel_info - channel information
+ *
+ * @channel: channel number
+ * @band: PHY_BAND_*
+ * @width: PHY_[VHT|LEGACY]_CHANNEL_*
+ * @ctrl channel: PHY_[VHT|LEGACY]_CTRL_*
+ * @reserved: for future use and alignment
+ */
+struct iwl_fw_channel_info {
+	__le32 channel;
+	u8 band;
+	u8 width;
+	u8 ctrl_pos;
+	u8 reserved;
+} __packed; /*CHANNEL_CONFIG_API_S_VER_2 */
 
 #define PHY_RX_CHAIN_DRIVER_FORCE_POS	(0)
 #define PHY_RX_CHAIN_DRIVER_FORCE_MSK \
@@ -133,6 +154,22 @@ struct iwl_fw_channel_info {
 #define NUM_PHY_CTX	3
 
 /* TODO: complete missing documentation */
+/**
+ * struct iwl_phy_context_cmd_tail - tail of iwl_phy_ctx_cmd for alignment with
+ *	various channel structures.
+ *
+ * @txchain_info: ???
+ * @rxchain_info: ???
+ * @acquisition_data: ???
+ * @dsp_cfg_flags: set to 0
+ */
+struct iwl_phy_context_cmd_tail {
+	__le32 txchain_info;
+	__le32 rxchain_info;
+	__le32 acquisition_data;
+	__le32 dsp_cfg_flags;
+} __packed;
+
 /**
  * struct iwl_phy_context_cmd - config of the PHY context
  * ( PHY_CONTEXT_CMD = 0x8 )
@@ -142,10 +179,7 @@ struct iwl_fw_channel_info {
  *	other value means apply new params after X usecs
  * @tx_param_color: ???
  * @ci: channel info
- * @txchain_info: ???
- * @rxchain_info: ???
- * @acquisition_data: ???
- * @dsp_cfg_flags: set to 0
+ * @tail: command tail
  */
 struct iwl_phy_context_cmd {
 	/* COMMON_INDEX_HDR_API_S_VER_1 */
@@ -155,10 +189,7 @@ struct iwl_phy_context_cmd {
 	__le32 apply_time;
 	__le32 tx_param_color;
 	struct iwl_fw_channel_info ci;
-	__le32 txchain_info;
-	__le32 rxchain_info;
-	__le32 acquisition_data;
-	__le32 dsp_cfg_flags;
+	struct iwl_phy_context_cmd_tail tail;
 } __packed; /* PHY_CONTEXT_CMD_API_VER_1 */
 
 #endif /* __iwl_fw_api_phy_ctxt_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
index 7c6c2462d0e8..b089285ac466 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -110,6 +112,17 @@ struct iwl_tdls_channel_switch_frame {
 	u8 data[IWL_TDLS_CH_SW_FRAME_MAX_SIZE];
 } __packed; /* TDLS_STA_CHANNEL_SWITCH_FRAME_API_S_VER_1 */
 
+/**
+ * struct iwl_tdls_channel_switch_cmd_tail - tail of iwl_tdls_channel_switch_cmd
+ *
+ * @timing: timing related data for command
+ * @frame: channel-switch request/response template, depending to switch_type
+ */
+struct iwl_tdls_channel_switch_cmd_tail {
+	struct iwl_tdls_channel_switch_timing timing;
+	struct iwl_tdls_channel_switch_frame frame;
+} __packed;
+
 /**
  * struct iwl_tdls_channel_switch_cmd - TDLS channel switch command
  *
@@ -119,15 +132,13 @@ struct iwl_tdls_channel_switch_frame {
  * @switch_type: see &enum iwl_tdls_channel_switch_type
  * @peer_sta_id: station id of TDLS peer
  * @ci: channel we switch to
- * @timing: timing related data for command
- * @frame: channel-switch request/response template, depending to switch_type
+ * @tail: command tail
  */
 struct iwl_tdls_channel_switch_cmd {
 	u8 switch_type;
 	__le32 peer_sta_id;
 	struct iwl_fw_channel_info ci;
-	struct iwl_tdls_channel_switch_timing timing;
-	struct iwl_tdls_channel_switch_frame frame;
+	struct iwl_tdls_channel_switch_cmd_tail tail;
 } __packed; /* TDLS_STA_CHANNEL_SWITCH_CMD_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h b/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
index f824bebceb06..4621ef93a2cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -317,6 +319,25 @@ struct iwl_time_event_notif {
 	__le32 status;
 } __packed; /* MAC_TIME_EVENT_NTFY_API_S_VER_1 */
 
+/*
+ * struct iwl_hs20_roc_req_tail - tail of iwl_hs20_roc_req
+ *
+ * @node_addr: Our MAC Address
+ * @reserved: reserved for alignment
+ * @apply_time: GP2 value to start (should always be the current GP2 value)
+ * @apply_time_max_delay: Maximum apply time delay value in TU. Defines max
+ *	time by which start of the event is allowed to be postponed.
+ * @duration: event duration in TU To calculate event duration:
+ *	timeEventDuration = min(duration, remainingQuota)
+ */
+struct iwl_hs20_roc_req_tail {
+	u8 node_addr[ETH_ALEN];
+	__le16 reserved;
+	__le32 apply_time;
+	__le32 apply_time_max_delay;
+	__le32 duration;
+} __packed;
+
 /*
  * Aux ROC command
  *
@@ -336,13 +357,6 @@ struct iwl_time_event_notif {
  * @sta_id_and_color: station id and color, resumed during "Remain On Channel"
  *	activity.
  * @channel_info: channel info
- * @node_addr: Our MAC Address
- * @reserved: reserved for alignment
- * @apply_time: GP2 value to start (should always be the current GP2 value)
- * @apply_time_max_delay: Maximum apply time delay value in TU. Defines max
- *	time by which start of the event is allowed to be postponed.
- * @duration: event duration in TU To calculate event duration:
- *	timeEventDuration = min(duration, remainingQuota)
  */
 struct iwl_hs20_roc_req {
 	/* COMMON_INDEX_HDR_API_S_VER_1 hdr */
@@ -351,11 +365,7 @@ struct iwl_hs20_roc_req {
 	__le32 event_unique_id;
 	__le32 sta_id_and_color;
 	struct iwl_fw_channel_info channel_info;
-	u8 node_addr[ETH_ALEN];
-	__le16 reserved;
-	__le32 apply_time;
-	__le32 apply_time_max_delay;
-	__le32 duration;
+	struct iwl_hs20_roc_req_tail tail;
 } __packed; /* HOT_SPOT_CMD_API_S_VER_1 */
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index f73c5c697690..e8b00b795cbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -333,6 +333,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_TLC_OFFLOAD: firmware implements rate scaling algorithm
  * @IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA: firmware implements quota related
  * @IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2: firmware implements Coex Schema 2
+ * @IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS: firmware supports ultra high band
+ *	(6 GHz).
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
@@ -395,6 +397,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_TLC_OFFLOAD                  = (__force iwl_ucode_tlv_capa_t)43,
 	IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA                = (__force iwl_ucode_tlv_capa_t)44,
 	IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2		= (__force iwl_ucode_tlv_capa_t)45,
+	IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS		= (__force iwl_ucode_tlv_capa_t)48,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index dd0761e5cf6a..1762b1fcb3db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3520,14 +3520,20 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 		.id_and_color =
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(MAC_INDEX_AUX, 0)),
 		.sta_id_and_color = cpu_to_le32(mvm->aux_sta.sta_id),
-		/* Set the channel info data */
-		.channel_info.band = (channel->band == NL80211_BAND_2GHZ) ?
-			PHY_BAND_24 : PHY_BAND_5,
-		.channel_info.channel = channel->hw_value,
-		.channel_info.width = PHY_VHT_CHANNEL_MODE20,
-		/* Set the time and duration */
-		.apply_time = cpu_to_le32(iwl_read_prph(mvm->trans, time_reg)),
-	 };
+	};
+	struct iwl_hs20_roc_req_tail *tail = iwl_mvm_chan_info_cmd_tail(mvm,
+		&aux_roc_req.channel_info);
+	u16 len = sizeof(aux_roc_req) - iwl_mvm_chan_info_padding(mvm);
+
+	/* Set the channel info data */
+	iwl_mvm_set_chan_info(mvm, &aux_roc_req.channel_info, channel->hw_value,
+			      (channel->band == NL80211_BAND_2GHZ) ?
+			       PHY_BAND_24 : PHY_BAND_5,
+			      PHY_VHT_CHANNEL_MODE20,
+			      0);
+
+	/* Set the time and duration */
+	tail->apply_time = cpu_to_le32(iwl_read_prph(mvm->trans, time_reg));
 
 	delay = AUX_ROC_MIN_DELAY;
 	req_dur = MSEC_TO_TU(duration);
@@ -3552,15 +3558,15 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 		}
 	}
 
-	aux_roc_req.duration = cpu_to_le32(req_dur);
-	aux_roc_req.apply_time_max_delay = cpu_to_le32(delay);
+	tail->duration = cpu_to_le32(req_dur);
+	tail->apply_time_max_delay = cpu_to_le32(delay);
 
 	IWL_DEBUG_TE(mvm,
 		     "ROC: Requesting to remain on channel %u for %ums (requested = %ums, max_delay = %ums, dtim_interval = %ums)\n",
 		     channel->hw_value, req_dur, duration, delay,
 		     dtim_interval);
 	/* Set the node address */
-	memcpy(aux_roc_req.node_addr, vif->addr, ETH_ALEN);
+	memcpy(tail->node_addr, vif->addr, ETH_ALEN);
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -3591,7 +3597,7 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 				   ARRAY_SIZE(time_event_response),
 				   iwl_mvm_rx_aux_roc, te_data);
 
-	res = iwl_mvm_send_cmd_pdu(mvm, HOT_SPOT_CMD, 0, sizeof(aux_roc_req),
+	res = iwl_mvm_send_cmd_pdu(mvm, HOT_SPOT_CMD, 0, len,
 				   &aux_roc_req);
 
 	if (res) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 55f08e433331..59d655436a8f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2059,4 +2059,59 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 			     struct dentry *dir);
 #endif
 
+/* Channel info utils */
+static inline bool iwl_mvm_has_ultra_hb_channel(struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS);
+}
+
+static inline void *iwl_mvm_chan_info_cmd_tail(struct iwl_mvm *mvm,
+					       struct iwl_fw_channel_info *ci)
+{
+	return (u8 *)ci + (iwl_mvm_has_ultra_hb_channel(mvm) ?
+			   sizeof(struct iwl_fw_channel_info) :
+			   sizeof(struct iwl_fw_channel_info_v1));
+}
+
+static inline size_t iwl_mvm_chan_info_padding(struct iwl_mvm *mvm)
+{
+	return iwl_mvm_has_ultra_hb_channel(mvm) ? 0 :
+		sizeof(struct iwl_fw_channel_info) -
+		sizeof(struct iwl_fw_channel_info_v1);
+}
+
+static inline void iwl_mvm_set_chan_info(struct iwl_mvm *mvm,
+					 struct iwl_fw_channel_info *ci,
+					 u32 chan, u8 band, u8 width,
+					 u8 ctrl_pos)
+{
+	if (iwl_mvm_has_ultra_hb_channel(mvm)) {
+		ci->channel = cpu_to_le32(chan);
+		ci->band = band;
+		ci->width = width;
+		ci->ctrl_pos = ctrl_pos;
+	} else {
+		struct iwl_fw_channel_info_v1 *ci_v1 =
+					(struct iwl_fw_channel_info_v1 *)ci;
+
+		ci_v1->channel = chan;
+		ci_v1->band = band;
+		ci_v1->width = width;
+		ci_v1->ctrl_pos = ctrl_pos;
+	}
+}
+
+static inline void
+iwl_mvm_set_chan_info_chandef(struct iwl_mvm *mvm,
+			      struct iwl_fw_channel_info *ci,
+			      struct cfg80211_chan_def *chandef)
+{
+	iwl_mvm_set_chan_info(mvm, ci, chandef->chan->hw_value,
+			      (chandef->chan->band == NL80211_BAND_2GHZ ?
+			       PHY_BAND_24 : PHY_BAND_5),
+			       iwl_mvm_get_channel_width(chandef),
+			       iwl_mvm_get_ctrl_pos(chandef));
+}
+
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 7f5434b34d0d..f369173db11c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -143,14 +143,11 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 				      u8 chains_static, u8 chains_dynamic)
 {
 	u8 active_cnt, idle_cnt;
+	struct iwl_phy_context_cmd_tail *tail =
+		iwl_mvm_chan_info_cmd_tail(mvm, &cmd->ci);
 
 	/* Set the channel info data */
-	cmd->ci.band = (chandef->chan->band == NL80211_BAND_2GHZ ?
-	      PHY_BAND_24 : PHY_BAND_5);
-
-	cmd->ci.channel = chandef->chan->hw_value;
-	cmd->ci.width = iwl_mvm_get_channel_width(chandef);
-	cmd->ci.ctrl_pos = iwl_mvm_get_ctrl_pos(chandef);
+	iwl_mvm_set_chan_info_chandef(mvm, &cmd->ci, chandef);
 
 	/* Set rx the chains */
 	idle_cnt = chains_static;
@@ -168,17 +165,17 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 		active_cnt = 2;
 	}
 
-	cmd->rxchain_info = cpu_to_le32(iwl_mvm_get_valid_rx_ant(mvm) <<
+	tail->rxchain_info = cpu_to_le32(iwl_mvm_get_valid_rx_ant(mvm) <<
 					PHY_RX_CHAIN_VALID_POS);
-	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
-	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
+	tail->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
+	tail->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (unlikely(mvm->dbgfs_rx_phyinfo))
-		cmd->rxchain_info = cpu_to_le32(mvm->dbgfs_rx_phyinfo);
+		tail->rxchain_info = cpu_to_le32(mvm->dbgfs_rx_phyinfo);
 #endif
 
-	cmd->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
+	tail->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 }
 
 /*
@@ -195,6 +192,7 @@ static int iwl_mvm_phy_ctxt_apply(struct iwl_mvm *mvm,
 {
 	struct iwl_phy_context_cmd cmd;
 	int ret;
+	u16 len = sizeof(cmd) - iwl_mvm_chan_info_padding(mvm);
 
 	/* Set the command header fields */
 	iwl_mvm_phy_ctxt_cmd_hdr(ctxt, &cmd, action, apply_time);
@@ -203,9 +201,7 @@ static int iwl_mvm_phy_ctxt_apply(struct iwl_mvm *mvm,
 	iwl_mvm_phy_ctxt_cmd_data(mvm, &cmd, chandef,
 				  chains_static, chains_dynamic);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, PHY_CONTEXT_CMD, 0,
-				   sizeof(struct iwl_phy_context_cmd),
-				   &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, PHY_CONTEXT_CMD, 0, len, &cmd);
 	if (ret)
 		IWL_ERR(mvm, "PHY ctxt cmd error. ret=%d\n", ret);
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index e02f4eb20359..859aa5a4e6b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -399,6 +399,9 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_hdr *hdr;
 	struct iwl_tdls_channel_switch_cmd cmd = {0};
+	struct iwl_tdls_channel_switch_cmd_tail *tail =
+		iwl_mvm_chan_info_cmd_tail(mvm, &cmd.ci);
+	u16 len = sizeof(cmd) - iwl_mvm_chan_info_padding(mvm);
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -414,9 +417,9 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 	}
 
 	cmd.switch_type = type;
-	cmd.timing.frame_timestamp = cpu_to_le32(timestamp);
-	cmd.timing.switch_time = cpu_to_le32(switch_time);
-	cmd.timing.switch_timeout = cpu_to_le32(switch_timeout);
+	tail->timing.frame_timestamp = cpu_to_le32(timestamp);
+	tail->timing.switch_time = cpu_to_le32(switch_time);
+	tail->timing.switch_timeout = cpu_to_le32(switch_timeout);
 
 	rcu_read_lock();
 	sta = ieee80211_find_sta(vif, peer);
@@ -448,21 +451,16 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 		}
 	}
 
-	if (chandef) {
-		cmd.ci.band = (chandef->chan->band == NL80211_BAND_2GHZ ?
-			       PHY_BAND_24 : PHY_BAND_5);
-		cmd.ci.channel = chandef->chan->hw_value;
-		cmd.ci.width = iwl_mvm_get_channel_width(chandef);
-		cmd.ci.ctrl_pos = iwl_mvm_get_ctrl_pos(chandef);
-	}
+	if (chandef)
+		iwl_mvm_set_chan_info_chandef(mvm, &cmd.ci, chandef);
 
 	/* keep quota calculation simple for now - 50% of DTIM for TDLS */
-	cmd.timing.max_offchan_duration =
+	tail->timing.max_offchan_duration =
 			cpu_to_le32(TU_TO_US(vif->bss_conf.dtim_period *
 					     vif->bss_conf.beacon_int) / 2);
 
 	/* Switch time is the first element in the switch-timing IE. */
-	cmd.frame.switch_time_offset = cpu_to_le32(ch_sw_tm_ie + 2);
+	tail->frame.switch_time_offset = cpu_to_le32(ch_sw_tm_ie + 2);
 
 	info = IEEE80211_SKB_CB(skb);
 	hdr = (void *)skb->data;
@@ -472,20 +470,19 @@ iwl_mvm_tdls_config_channel_switch(struct iwl_mvm *mvm,
 			ret = -EINVAL;
 			goto out;
 		}
-		iwl_mvm_set_tx_cmd_ccmp(info, &cmd.frame.tx_cmd);
+		iwl_mvm_set_tx_cmd_ccmp(info, &tail->frame.tx_cmd);
 	}
 
-	iwl_mvm_set_tx_cmd(mvm, skb, &cmd.frame.tx_cmd, info,
+	iwl_mvm_set_tx_cmd(mvm, skb, &tail->frame.tx_cmd, info,
 			   mvmsta->sta_id);
 
-	iwl_mvm_set_tx_cmd_rate(mvm, &cmd.frame.tx_cmd, info, sta,
+	iwl_mvm_set_tx_cmd_rate(mvm, &tail->frame.tx_cmd, info, sta,
 				hdr->frame_control);
 	rcu_read_unlock();
 
-	memcpy(cmd.frame.data, skb->data, skb->len);
+	memcpy(tail->frame.data, skb->data, skb->len);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, TDLS_CHANNEL_SWITCH_CMD, 0,
-				   sizeof(cmd), &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, TDLS_CHANNEL_SWITCH_CMD, 0, len, &cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to send TDLS_CHANNEL_SWITCH cmd: %d\n",
 			ret);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 9fa1a36dcda3..5b34100e9099 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -687,6 +687,8 @@ static void iwl_mvm_remove_aux_roc_te(struct iwl_mvm *mvm,
 				      struct iwl_mvm_time_event_data *te_data)
 {
 	struct iwl_hs20_roc_req aux_cmd = {};
+	u16 len = sizeof(aux_cmd) - iwl_mvm_chan_info_padding(mvm);
+
 	u32 uid;
 	int ret;
 
@@ -700,7 +702,7 @@ static void iwl_mvm_remove_aux_roc_te(struct iwl_mvm *mvm,
 	IWL_DEBUG_TE(mvm, "Removing BSS AUX ROC TE 0x%x\n",
 		     le32_to_cpu(aux_cmd.event_unique_id));
 	ret = iwl_mvm_send_cmd_pdu(mvm, HOT_SPOT_CMD, 0,
-				   sizeof(aux_cmd), &aux_cmd);
+				   len, &aux_cmd);
 
 	if (WARN_ON(ret))
 		return;
-- 
2.20.1

