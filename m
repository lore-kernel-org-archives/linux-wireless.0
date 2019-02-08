Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF276C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9973621919
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 10:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfBHKra (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:47:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:57012 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727660AbfBHKra (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 05:47:30 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gs3gs-0002jg-8c; Fri, 08 Feb 2019 12:47:27 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 12:47:01 +0200
Message-Id: <20190208104712.16210-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208104712.16210-1-luca@coelho.fi>
References: <20190208104712.16210-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/20] iwlwifi: mvm: add support for new FTM fw API
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

The FTM new API uses API TLV bit 15. The driver mistakenly uses
this bit for beacon filter API, although no TLV was assigned for
the beacon filter API. For now, make beacon filter use bit 16
instead (not set by the fw anyway). Once a TLV is assigned to the
beacon filter API it should be updated.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/location.h  | 181 +++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   5 +
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 338 +++++++++++++-----
 3 files changed, 429 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
index 10cac5f987e7..5dddb21c1c4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
@@ -324,7 +324,7 @@ enum iwl_tof_location_query {
 };
 
  /**
- * struct iwl_tof_range_req_ap_entry - AP configuration parameters
+ * struct iwl_tof_range_req_ap_entry_v2 - AP configuration parameters
  * @channel_num: Current AP Channel
  * @bandwidth: Current AP Bandwidth. One of iwl_tof_bandwidth.
  * @tsf_delta_direction: TSF relatively to the subject AP
@@ -357,7 +357,7 @@ enum iwl_tof_location_query {
  * @notify_mcsi: &enum iwl_tof_mcsi_ntfy.
  * @reserved: For alignment and future use
  */
-struct iwl_tof_range_req_ap_entry {
+struct iwl_tof_range_req_ap_entry_v2 {
 	u8 channel_num;
 	u8 bandwidth;
 	u8 tsf_delta_direction;
@@ -376,6 +376,62 @@ struct iwl_tof_range_req_ap_entry {
 	u8 algo_type;
 	u8 notify_mcsi;
 	__le16 reserved;
+} __packed; /* LOCATION_RANGE_REQ_AP_ENTRY_CMD_API_S_VER_2 */
+
+/**
+ * enum iwl_initiator_ap_flags - per responder FTM configuration flags
+ * @IWL_INITIATOR_AP_FLAGS_ASAP: Request for ASAP measurement.
+ * @IWL_INITIATOR_AP_FLAGS_LCI_REQUEST: Request for LCI information
+ * @IWL_INITIATOR_AP_FLAGS_CIVIC_REQUEST: Request for CIVIC information
+ * @IWL_INITIATOR_AP_FLAGS_DYN_ACK: Send HT/VHT ack for FTM frames. If not set,
+ *	20Mhz dup acks will be sent.
+ * @IWL_INITIATOR_AP_FLAGS_ALGO_LR: Use LR algo type for rtt calculation.
+ *	Default algo type is ML.
+ * @IWL_INITIATOR_AP_FLAGS_ALGO_FFT: Use FFT algo type for rtt calculation.
+ *	Default algo type is ML.
+ * @IWL_INITIATOR_AP_FLAGS_MCSI_REPORT: Send the MCSI for each FTM frame to the
+ *	driver.
+ */
+enum iwl_initiator_ap_flags {
+	IWL_INITIATOR_AP_FLAGS_ASAP = BIT(1),
+	IWL_INITIATOR_AP_FLAGS_LCI_REQUEST = BIT(2),
+	IWL_INITIATOR_AP_FLAGS_CIVIC_REQUEST = BIT(3),
+	IWL_INITIATOR_AP_FLAGS_DYN_ACK = BIT(4),
+	IWL_INITIATOR_AP_FLAGS_ALGO_LR = BIT(5),
+	IWL_INITIATOR_AP_FLAGS_ALGO_FFT = BIT(6),
+	IWL_INITIATOR_AP_FLAGS_MCSI_REPORT = BIT(8),
+};
+
+/**
+ * struct iwl_tof_range_req_ap_entry - AP configuration parameters
+ * @initiator_ap_flags: see &enum iwl_initiator_ap_flags.
+ * @channel_num: AP Channel number
+ * @bandwidth: AP bandwidth. One of iwl_tof_bandwidth.
+ * @ctrl_ch_position: Coding of the control channel position relative to the
+ *	center frequency, see iwl_mvm_get_ctrl_pos().
+ * @ftmr_max_retries: Max number of retries to send the FTMR in case of no
+ *	reply from the AP.
+ * @bssid: AP's BSSID
+ * @burst_period: Recommended value to be sent to the AP. Measurement
+ *	periodicity In units of 100ms. ignored if num_of_bursts_exp = 0
+ * @samples_per_burst: the number of FTMs pairs in single Burst (1-31);
+ * @num_of_bursts: Recommended value to be sent to the AP. 2s Exponent of
+ *	the number of measurement iterations (min 2^0 = 1, max 2^14)
+ * @reserved: For alignment and future use
+ * @tsf_delta: not in use
+ */
+struct iwl_tof_range_req_ap_entry {
+	__le32 initiator_ap_flags;
+	u8 channel_num;
+	u8 bandwidth;
+	u8 ctrl_ch_position;
+	u8 ftmr_max_retries;
+	u8 bssid[ETH_ALEN];
+	__le16 burst_period;
+	u8 samples_per_burst;
+	u8 num_of_bursts;
+	__le16 reserved;
+	__le32 tsf_delta;
 } __packed; /* LOCATION_RANGE_REQ_AP_ENTRY_CMD_API_S_VER_3 */
 
 /**
@@ -405,10 +461,12 @@ enum iwl_tof_response_mode {
  * @IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_A: use antenna A fo TX ACKs during FTM
  * @IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_B: use antenna B fo TX ACKs during FTM
  * @IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_C: use antenna C fo TX ACKs during FTM
+ * @IWL_TOF_INITIATOR_FLAGS_MACADDR_RANDOM: use random mac address for FTM
  * @IWL_TOF_INITIATOR_FLAGS_SPECIFIC_CALIB: use the specific calib value from
  *	the range request command
  * @IWL_TOF_INITIATOR_FLAGS_COMMON_CALIB: use the common calib value from the
  *	ragne request command
+ * @IWL_TOF_INITIATOR_FLAGS_NON_ASAP_SUPPORT: support non-asap measurements
  */
 enum iwl_tof_initiator_flags {
 	IWL_TOF_INITIATOR_FLAGS_FAST_ALGO_DISABLED = BIT(0),
@@ -418,15 +476,17 @@ enum iwl_tof_initiator_flags {
 	IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_A = BIT(4),
 	IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_B = BIT(5),
 	IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_C = BIT(6),
+	IWL_TOF_INITIATOR_FLAGS_MACADDR_RANDOM = BIT(7),
 	IWL_TOF_INITIATOR_FLAGS_SPECIFIC_CALIB = BIT(15),
 	IWL_TOF_INITIATOR_FLAGS_COMMON_CALIB   = BIT(16),
+	IWL_TOF_INITIATOR_FLAGS_NON_ASAP_SUPPORT = BIT(20),
 }; /* LOCATION_RANGE_REQ_CMD_API_S_VER_5 */
 
 #define IWL_MVM_TOF_MAX_APS 5
 #define IWL_MVM_TOF_MAX_TWO_SIDED_APS 5
 
 /**
- * struct iwl_tof_range_req_cmd - start measurement cmd
+ * struct iwl_tof_range_req_cmd_v5 - start measurement cmd
  * @initiator_flags: see flags @ iwl_tof_initiator_flags
  * @request_id: A Token incremented per request. The same Token will be
  *		sent back in the range response
@@ -454,7 +514,7 @@ enum iwl_tof_initiator_flags {
  * @specific_calib: The specific calib value to inject to this measurement calc
  * @ap: per-AP request data
  */
-struct iwl_tof_range_req_cmd {
+struct iwl_tof_range_req_cmd_v5 {
 	__le32 initiator_flags;
 	u8 request_id;
 	u8 initiator;
@@ -471,10 +531,42 @@ struct iwl_tof_range_req_cmd {
 	u8 ftm_tx_chains;
 	__le16 common_calib;
 	__le16 specific_calib;
-	struct iwl_tof_range_req_ap_entry ap[IWL_MVM_TOF_MAX_APS];
+	struct iwl_tof_range_req_ap_entry_v2 ap[IWL_MVM_TOF_MAX_APS];
 } __packed;
 /* LOCATION_RANGE_REQ_CMD_API_S_VER_5 */
 
+/**
+ * struct iwl_tof_range_req_cmd - start measurement cmd
+ * @initiator_flags: see flags @ iwl_tof_initiator_flags
+ * @request_id: A Token incremented per request. The same Token will be
+ *		sent back in the range response
+ * @num_of_ap: Number of APs to measure (error if > IWL_MVM_TOF_MAX_APS)
+ * @range_req_bssid: ranging request BSSID
+ * @macaddr_mask: Bits set to 0 shall be copied from the MAC address template.
+ *		  Bits set to 1 shall be randomized by the UMAC
+ * @macaddr_template: MAC address template to use for non-randomized bits
+ * @req_timeout_ms: Requested timeout of the response in units of milliseconds.
+ *	This is the session time for completing the measurement.
+ * @tsf_mac_id: report the measurement start time for each ap in terms of the
+ *	TSF of this mac id. 0xff to disable TSF reporting.
+ * @common_calib: The common calib value to inject to this measurement calc
+ * @specific_calib: The specific calib value to inject to this measurement calc
+ * @ap: per-AP request data, see &struct iwl_tof_range_req_ap_entry_v2.
+ */
+struct iwl_tof_range_req_cmd {
+	__le32 initiator_flags;
+	u8 request_id;
+	u8 num_of_ap;
+	u8 range_req_bssid[ETH_ALEN];
+	u8 macaddr_mask[ETH_ALEN];
+	u8 macaddr_template[ETH_ALEN];
+	__le32 req_timeout_ms;
+	__le32 tsf_mac_id;
+	__le16 common_calib;
+	__le16 specific_calib;
+	struct iwl_tof_range_req_ap_entry ap[IWL_MVM_TOF_MAX_APS];
+} __packed; /* LOCATION_RANGE_REQ_CMD_API_S_VER_7 */
+
 /*
  * enum iwl_tof_range_request_status - status of the sent request
  * @IWL_TOF_RANGE_REQUEST_STATUS_SUCCESSFUL - FW successfully received the
@@ -534,7 +626,7 @@ enum iwl_tof_entry_status {
 }; /* LOCATION_RANGE_RSP_AP_ENTRY_NTFY_API_S_VER_2 */
 
 /**
- * struct iwl_tof_range_rsp_ap_entry_ntfy - AP parameters (response)
+ * struct iwl_tof_range_rsp_ap_entry_ntfy_v3 - AP parameters (response)
  * @bssid: BSSID of the AP
  * @measure_status: current APs measurement status, one of
  *	&enum iwl_tof_entry_status.
@@ -561,7 +653,7 @@ enum iwl_tof_entry_status {
  * @papd_calib_output: The result of the tof papd calibration that was injected
  *	into the algorithm.
  */
-struct iwl_tof_range_rsp_ap_entry_ntfy {
+struct iwl_tof_range_rsp_ap_entry_ntfy_v3 {
 	u8 bssid[ETH_ALEN];
 	u8 measure_status;
 	u8 measure_bw;
@@ -582,6 +674,59 @@ struct iwl_tof_range_rsp_ap_entry_ntfy {
 	__le32 papd_calib_output;
 } __packed; /* LOCATION_RANGE_RSP_AP_ETRY_NTFY_API_S_VER_3 */
 
+/**
+ * struct iwl_tof_range_rsp_ap_entry_ntfy - AP parameters (response)
+ * @bssid: BSSID of the AP
+ * @measure_status: current APs measurement status, one of
+ *	&enum iwl_tof_entry_status.
+ * @measure_bw: Current AP Bandwidth: 0  20MHz, 1  40MHz, 2  80MHz
+ * @rtt: The Round Trip Time that took for the last measurement for
+ *	current AP [pSec]
+ * @rtt_variance: The Variance of the RTT values measured for current AP
+ * @rtt_spread: The Difference between the maximum and the minimum RTT
+ *	values measured for current AP in the current session [pSec]
+ * @rssi: RSSI as uploaded in the Channel Estimation notification
+ * @rssi_spread: The Difference between the maximum and the minimum RSSI values
+ *	measured for current AP in the current session
+ * @last_burst: 1 if no more FTM sessions are scheduled for this responder
+ * @refusal_period: refusal period in case of
+ *	@IWL_TOF_ENTRY_RESPONDER_CANNOT_COLABORATE [sec]
+ * @timestamp: The GP2 Clock [usec] where Channel Estimation notification was
+ *	uploaded by the LMAC
+ * @start_tsf: measurement start time in TSF of the mac specified in the range
+ *	request
+ * @rx_rate_n_flags: rate and flags of the last FTM frame received from this
+ *	responder
+ * @tx_rate_n_flags: rate and flags of the last ack sent to this responder
+ * @t2t3_initiator: as calculated from the algo in the initiator
+ * @t1t4_responder: as calculated from the algo in the responder
+ * @common_calib: Calib val that was used in for this AP measurement
+ * @specific_calib: val that was used in for this AP measurement
+ * @papd_calib_output: The result of the tof papd calibration that was injected
+ *	into the algorithm.
+ */
+struct iwl_tof_range_rsp_ap_entry_ntfy {
+	u8 bssid[ETH_ALEN];
+	u8 measure_status;
+	u8 measure_bw;
+	__le32 rtt;
+	__le32 rtt_variance;
+	__le32 rtt_spread;
+	s8 rssi;
+	u8 rssi_spread;
+	u8 last_burst;
+	u8 refusal_period;
+	__le32 timestamp;
+	__le32 start_tsf;
+	__le32 rx_rate_n_flags;
+	__le32 tx_rate_n_flags;
+	__le32 t2t3_initiator;
+	__le32 t1t4_responder;
+	__le16 common_calib;
+	__le16 specific_calib;
+	__le32 papd_calib_output;
+} __packed; /* LOCATION_RANGE_RSP_AP_ETRY_NTFY_API_S_VER_4 */
+
 /**
  * enum iwl_tof_response_status - tof response status
  *
@@ -599,7 +744,7 @@ enum iwl_tof_response_status {
 }; /* LOCATION_RNG_RSP_STATUS */
 
 /**
- * struct iwl_tof_range_rsp_ntfy - ranging response notification
+ * struct iwl_tof_range_rsp_ntfy_v5 - ranging response notification
  * @request_id: A Token ID of the corresponding Range request
  * @request_status: status of current measurement session, one of
  *	&enum iwl_tof_response_status.
@@ -607,13 +752,29 @@ enum iwl_tof_response_status {
  * @num_of_aps: Number of APs to measure (error if > IWL_MVM_TOF_MAX_APS)
  * @ap: per-AP data
  */
-struct iwl_tof_range_rsp_ntfy {
+struct iwl_tof_range_rsp_ntfy_v5 {
 	u8 request_id;
 	u8 request_status;
 	u8 last_in_batch;
 	u8 num_of_aps;
+	struct iwl_tof_range_rsp_ap_entry_ntfy_v3 ap[IWL_MVM_TOF_MAX_APS];
+} __packed; /* LOCATION_RANGE_RSP_NTFY_API_S_VER_5 */
+
+/**
+ * struct iwl_tof_range_rsp_ntfy - ranging response notification
+ * @request_id: A Token ID of the corresponding Range request
+ * @num_of_aps: Number of APs results
+ * @last_report: 1 if no more FTM sessions are scheduled, 0 otherwise.
+ * @reserved: reserved
+ * @ap: per-AP data
+ */
+struct iwl_tof_range_rsp_ntfy {
+	u8 request_id;
+	u8 num_of_aps;
+	u8 last_report;
+	u8 reserved;
 	struct iwl_tof_range_rsp_ap_entry_ntfy ap[IWL_MVM_TOF_MAX_APS];
-} __packed;
+} __packed; /* LOCATION_RANGE_RSP_NTFY_API_S_VER_6 */
 
 #define IWL_MVM_TOF_MCSI_BUF_SIZE  (245)
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 3f61dc50c2d5..641c95d03b15 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -9,6 +9,7 @@
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,6 +33,7 @@
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -270,6 +272,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	version of the beacon notification.
  * @IWL_UCODE_TLV_API_BEACON_FILTER_V4: This ucode supports v4 of
  *	BEACON_FILTER_CONFIG_API_S_VER_4.
+ * @IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ: This ucode supports v7 of
+ *	LOCATION_RANGE_REQ_CMD_API_S and v6 of LOCATION_RANGE_RESP_NTFY_API_S.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -296,6 +300,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_REDUCE_TX_POWER	= (__force iwl_ucode_tlv_api_t)45,
 	IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF	= (__force iwl_ucode_tlv_api_t)46,
 	IWL_UCODE_TLV_API_BEACON_FILTER_V4      = (__force iwl_ucode_tlv_api_t)47,
+	IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ     = (__force iwl_ucode_tlv_api_t)49,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index eb6f084a0f8a..c1d9703ab40c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -132,91 +132,224 @@ iwl_ftm_range_request_status_to_err(enum iwl_tof_range_request_status s)
 	}
 }
 
+static void iwl_mvm_ftm_cmd_v5(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			       struct iwl_tof_range_req_cmd_v5 *cmd,
+			       struct cfg80211_pmsr_request *req)
+{
+	int i;
+
+	cmd->request_id = req->cookie;
+	cmd->num_of_ap = req->n_peers;
+
+	/* use maximum for "no timeout" or bigger than what we can do */
+	if (!req->timeout || req->timeout > 255 * 100)
+		cmd->req_timeout = 255;
+	else
+		cmd->req_timeout = DIV_ROUND_UP(req->timeout, 100);
+
+	/*
+	 * We treat it always as random, since if not we'll
+	 * have filled our local address there instead.
+	 */
+	cmd->macaddr_random = 1;
+	memcpy(cmd->macaddr_template, req->mac_addr, ETH_ALEN);
+	for (i = 0; i < ETH_ALEN; i++)
+		cmd->macaddr_mask[i] = ~req->mac_addr_mask[i];
+
+	if (vif->bss_conf.assoc)
+		memcpy(cmd->range_req_bssid, vif->bss_conf.bssid, ETH_ALEN);
+	else
+		eth_broadcast_addr(cmd->range_req_bssid);
+}
+
+static void iwl_mvm_ftm_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			    struct iwl_tof_range_req_cmd *cmd,
+			    struct cfg80211_pmsr_request *req)
+{
+	int i;
+
+	cmd->initiator_flags =
+		cpu_to_le32(IWL_TOF_INITIATOR_FLAGS_MACADDR_RANDOM |
+			    IWL_TOF_INITIATOR_FLAGS_NON_ASAP_SUPPORT);
+	cmd->request_id = req->cookie;
+	cmd->num_of_ap = req->n_peers;
+
+	/*
+	 * Use a large value for "no timeout". Don't use the maximum value
+	 * because of fw limitations.
+	 */
+	if (req->timeout)
+		cmd->req_timeout_ms = cpu_to_le32(req->timeout);
+	else
+		cmd->req_timeout_ms = cpu_to_le32(0xfffff);
+
+	memcpy(cmd->macaddr_template, req->mac_addr, ETH_ALEN);
+	for (i = 0; i < ETH_ALEN; i++)
+		cmd->macaddr_mask[i] = ~req->mac_addr_mask[i];
+
+	if (vif->bss_conf.assoc)
+		memcpy(cmd->range_req_bssid, vif->bss_conf.bssid, ETH_ALEN);
+	else
+		eth_broadcast_addr(cmd->range_req_bssid);
+
+	/* TODO: fill in tsf_mac_id if needed */
+	cmd->tsf_mac_id = cpu_to_le32(0xff);
+}
+
+static int iwl_mvm_ftm_target_chandef(struct iwl_mvm *mvm,
+				      struct cfg80211_pmsr_request_peer *peer,
+				      u8 *channel, u8 *bandwidth,
+				      u8 *ctrl_ch_position)
+{
+	u32 freq = peer->chandef.chan->center_freq;
+
+	*channel = ieee80211_frequency_to_channel(freq);
+
+	switch (peer->chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		*bandwidth = IWL_TOF_BW_20_LEGACY;
+		break;
+	case NL80211_CHAN_WIDTH_20:
+		*bandwidth = IWL_TOF_BW_20_HT;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		*bandwidth = IWL_TOF_BW_40;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		*bandwidth = IWL_TOF_BW_80;
+		break;
+	default:
+		IWL_ERR(mvm, "Unsupported BW in FTM request (%d)\n",
+			peer->chandef.width);
+		return -EINVAL;
+	}
+
+	*ctrl_ch_position = (peer->chandef.width > NL80211_CHAN_WIDTH_20) ?
+		iwl_mvm_get_ctrl_pos(&peer->chandef) : 0;
+
+	return 0;
+}
+
+static int
+iwl_mvm_ftm_put_target_v2(struct iwl_mvm *mvm,
+			  struct cfg80211_pmsr_request_peer *peer,
+			  struct iwl_tof_range_req_ap_entry_v2 *target)
+{
+	int ret;
+
+	ret = iwl_mvm_ftm_target_chandef(mvm, peer, &target->channel_num,
+					 &target->bandwidth,
+					 &target->ctrl_ch_position);
+	if (ret)
+		return ret;
+
+	memcpy(target->bssid, peer->addr, ETH_ALEN);
+	target->burst_period =
+		cpu_to_le16(peer->ftm.burst_period);
+	target->samples_per_burst = peer->ftm.ftms_per_burst;
+	target->num_of_bursts = peer->ftm.num_bursts_exp;
+	target->measure_type = 0; /* regular two-sided FTM */
+	target->retries_per_sample = peer->ftm.ftmr_retries;
+	target->asap_mode = peer->ftm.asap;
+	target->enable_dyn_ack = IWL_MVM_FTM_INITIATOR_DYNACK;
+
+	if (peer->ftm.request_lci)
+		target->location_req |= IWL_TOF_LOC_LCI;
+	if (peer->ftm.request_civicloc)
+		target->location_req |= IWL_TOF_LOC_CIVIC;
+
+	target->algo_type = IWL_MVM_FTM_INITIATOR_ALGO;
+
+	return 0;
+}
+
+#define FTM_PUT_FLAG(flag)	(target->initiator_ap_flags |= \
+				 cpu_to_le32(IWL_INITIATOR_AP_FLAGS_##flag))
+
+static int iwl_mvm_ftm_put_target(struct iwl_mvm *mvm,
+				  struct cfg80211_pmsr_request_peer *peer,
+				  struct iwl_tof_range_req_ap_entry *target)
+{
+	int ret;
+
+	ret = iwl_mvm_ftm_target_chandef(mvm, peer, &target->channel_num,
+					 &target->bandwidth,
+					 &target->ctrl_ch_position);
+	if (ret)
+		return ret;
+
+	memcpy(target->bssid, peer->addr, ETH_ALEN);
+	target->burst_period =
+		cpu_to_le16(peer->ftm.burst_period);
+	target->samples_per_burst = peer->ftm.ftms_per_burst;
+	target->num_of_bursts = peer->ftm.num_bursts_exp;
+	target->ftmr_max_retries = peer->ftm.ftmr_retries;
+	target->initiator_ap_flags = cpu_to_le32(0);
+
+	if (peer->ftm.asap)
+		FTM_PUT_FLAG(ASAP);
+
+	if (peer->ftm.request_lci)
+		FTM_PUT_FLAG(LCI_REQUEST);
+
+	if (peer->ftm.request_civicloc)
+		FTM_PUT_FLAG(CIVIC_REQUEST);
+
+	if (IWL_MVM_FTM_INITIATOR_DYNACK)
+		FTM_PUT_FLAG(DYN_ACK);
+
+	if (IWL_MVM_FTM_INITIATOR_ALGO == IWL_TOF_ALGO_TYPE_LINEAR_REG)
+		FTM_PUT_FLAG(ALGO_LR);
+	else if (IWL_MVM_FTM_INITIATOR_ALGO == IWL_TOF_ALGO_TYPE_FFT)
+		FTM_PUT_FLAG(ALGO_FFT);
+
+	return 0;
+}
+
 int iwl_mvm_ftm_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		      struct cfg80211_pmsr_request *req)
 {
-	struct iwl_tof_range_req_cmd cmd = {
-		.request_id = req->cookie,
-		.req_timeout = DIV_ROUND_UP(req->timeout, 100),
-		.num_of_ap = req->n_peers,
-		/*
-		 * We treat it always as random, since if not we'll
-		 * have filled our local address there instead.
-		 */
-		.macaddr_random = 1,
-	};
+	struct iwl_tof_range_req_cmd_v5 cmd_v5;
+	struct iwl_tof_range_req_cmd cmd;
+	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
+				  IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ);
+	u8 num_of_ap;
 	struct iwl_host_cmd hcmd = {
 		.id = iwl_cmd_id(TOF_RANGE_REQ_CMD, LOCATION_GROUP, 0),
-		.data[0] = &cmd,
-		.len[0] = sizeof(cmd),
 		.dataflags[0] = IWL_HCMD_DFL_DUP,
 	};
 	u32 status = 0;
 	int err, i;
 
-	/* use maximum for "no timeout" or bigger than what we can do */
-	if (!req->timeout || req->timeout > 255 * 100)
-		cmd.req_timeout = 255;
-
 	lockdep_assert_held(&mvm->mutex);
 
 	if (mvm->ftm_initiator.req)
 		return -EBUSY;
 
-	memcpy(cmd.macaddr_template, req->mac_addr, ETH_ALEN);
-	for (i = 0; i < ETH_ALEN; i++)
-		cmd.macaddr_mask[i] = ~req->mac_addr_mask[i];
+	if (new_api) {
+		iwl_mvm_ftm_cmd(mvm, vif, &cmd, req);
+		hcmd.data[0] = &cmd;
+		hcmd.len[0] = sizeof(cmd);
+		num_of_ap = cmd.num_of_ap;
+	} else {
+		iwl_mvm_ftm_cmd_v5(mvm, vif, &cmd_v5, req);
+		hcmd.data[0] = &cmd_v5;
+		hcmd.len[0] = sizeof(cmd_v5);
+		num_of_ap = cmd_v5.num_of_ap;
+	}
 
-	for (i = 0; i < cmd.num_of_ap; i++) {
+	for (i = 0; i < num_of_ap; i++) {
 		struct cfg80211_pmsr_request_peer *peer = &req->peers[i];
-		struct iwl_tof_range_req_ap_entry *cmd_target = &cmd.ap[i];
-		u32 freq = peer->chandef.chan->center_freq;
 
-		cmd_target->channel_num = ieee80211_frequency_to_channel(freq);
-		switch (peer->chandef.width) {
-		case NL80211_CHAN_WIDTH_20_NOHT:
-			cmd_target->bandwidth = IWL_TOF_BW_20_LEGACY;
-			break;
-		case NL80211_CHAN_WIDTH_20:
-			cmd_target->bandwidth = IWL_TOF_BW_20_HT;
-			break;
-		case NL80211_CHAN_WIDTH_40:
-			cmd_target->bandwidth = IWL_TOF_BW_40;
-			break;
-		case NL80211_CHAN_WIDTH_80:
-			cmd_target->bandwidth = IWL_TOF_BW_80;
-			break;
-		default:
-			IWL_ERR(mvm, "Unsupported BW in FTM request (%d)\n",
-				peer->chandef.width);
-			return -EINVAL;
-		}
-		cmd_target->ctrl_ch_position =
-			(peer->chandef.width > NL80211_CHAN_WIDTH_20) ?
-			iwl_mvm_get_ctrl_pos(&peer->chandef) : 0;
-
-		memcpy(cmd_target->bssid, peer->addr, ETH_ALEN);
-		cmd_target->measure_type = 0; /* regular two-sided FTM */
-		cmd_target->num_of_bursts = peer->ftm.num_bursts_exp;
-		cmd_target->burst_period =
-			cpu_to_le16(peer->ftm.burst_period);
-		cmd_target->samples_per_burst = peer->ftm.ftms_per_burst;
-		cmd_target->retries_per_sample = peer->ftm.ftmr_retries;
-		cmd_target->asap_mode = peer->ftm.asap;
-		cmd_target->enable_dyn_ack = IWL_MVM_FTM_INITIATOR_DYNACK;
-
-		if (peer->ftm.request_lci)
-			cmd_target->location_req |= IWL_TOF_LOC_LCI;
-		if (peer->ftm.request_civicloc)
-			cmd_target->location_req |= IWL_TOF_LOC_CIVIC;
-
-		cmd_target->algo_type = IWL_MVM_FTM_INITIATOR_ALGO;
-	}
+		if (new_api)
+			err = iwl_mvm_ftm_put_target(mvm, peer, &cmd.ap[i]);
+		else
+			err = iwl_mvm_ftm_put_target_v2(mvm, peer,
+							&cmd_v5.ap[i]);
 
-	if (vif->bss_conf.assoc)
-		memcpy(cmd.range_req_bssid, vif->bss_conf.bssid, ETH_ALEN);
-	else
-		eth_broadcast_addr(cmd.range_req_bssid);
+		if (err)
+			return err;
+	}
 
 	err = iwl_mvm_send_cmd_status(mvm, &hcmd, &status);
 	if (!err && status) {
@@ -305,11 +438,34 @@ static void iwl_mvm_ftm_get_lci_civic(struct iwl_mvm *mvm,
 	}
 }
 
+static int iwl_mvm_ftm_range_resp_valid(struct iwl_mvm *mvm, u8 request_id,
+					u8 num_of_aps)
+{
+	lockdep_assert_held(&mvm->mutex);
+
+	if (request_id != (u8)mvm->ftm_initiator.req->cookie) {
+		IWL_ERR(mvm, "Request ID mismatch, got %u, active %u\n",
+			request_id, (u8)mvm->ftm_initiator.req->cookie);
+		return -EINVAL;
+	}
+
+	if (num_of_aps > mvm->ftm_initiator.req->n_peers) {
+		IWL_ERR(mvm, "FTM range response invalid\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_tof_range_rsp_ntfy_v5 *fw_resp_v5 = (void *)pkt->data;
 	struct iwl_tof_range_rsp_ntfy *fw_resp = (void *)pkt->data;
 	int i;
+	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
+				  IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ);
+	u8 num_of_aps, last_in_batch;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -318,28 +474,46 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		return;
 	}
 
-	if (fw_resp->request_id != (u8)mvm->ftm_initiator.req->cookie) {
-		IWL_ERR(mvm, "Request ID mismatch, got %u, active %u\n",
-			fw_resp->request_id,
-			(u8)mvm->ftm_initiator.req->cookie);
-		return;
-	}
+	if (new_api) {
+		if (iwl_mvm_ftm_range_resp_valid(mvm, fw_resp->request_id,
+						 fw_resp->num_of_aps))
+			return;
 
-	if (fw_resp->num_of_aps > mvm->ftm_initiator.req->n_peers) {
-		IWL_ERR(mvm, "FTM range response invalid\n");
-		return;
+		num_of_aps = fw_resp->num_of_aps;
+		last_in_batch = fw_resp->last_report;
+	} else {
+		if (iwl_mvm_ftm_range_resp_valid(mvm, fw_resp_v5->request_id,
+						 fw_resp_v5->num_of_aps))
+			return;
+
+		num_of_aps = fw_resp_v5->num_of_aps;
+		last_in_batch = fw_resp_v5->last_in_batch;
 	}
 
-	for (i = 0; i < fw_resp->num_of_aps && i < IWL_MVM_TOF_MAX_APS; i++) {
-		struct iwl_tof_range_rsp_ap_entry_ntfy *fw_ap = &fw_resp->ap[i];
+	for (i = 0; i < num_of_aps && i < IWL_MVM_TOF_MAX_APS; i++) {
 		struct cfg80211_pmsr_result result = {};
+		struct iwl_tof_range_rsp_ap_entry_ntfy *fw_ap;
 		int peer_idx;
 
+		if (new_api) {
+			fw_ap = &fw_resp->ap[i];
+			result.final = fw_resp->ap[i].last_burst;
+		} else {
+			/* the first part is the same for old and new APIs */
+			fw_ap = (void *)&fw_resp_v5->ap[i];
+			/*
+			 * FIXME: the firmware needs to report this, we don't
+			 * even know the number of bursts the responder picked
+			 * (if we asked it to)
+			 */
+			result.final = 0;
+		}
+
 		peer_idx = iwl_mvm_ftm_find_peer(mvm->ftm_initiator.req,
 						 fw_ap->bssid);
 		if (peer_idx < 0) {
 			IWL_WARN(mvm,
-				 "Unknown address (%pM, target #%d) in FTM response.\n",
+				 "Unknown address (%pM, target #%d) in FTM response\n",
 				 fw_ap->bssid, i);
 			continue;
 		}
@@ -374,12 +548,6 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		result.type = NL80211_PMSR_TYPE_FTM;
 		result.ftm.burst_index = mvm->ftm_initiator.responses[peer_idx];
 		mvm->ftm_initiator.responses[peer_idx]++;
-		/*
-		 * FIXME: the firmware needs to report this, we don't even know
-		 *        the number of bursts the responder picked (if we asked
-		 *        it to)
-		 */
-		result.final = 0;
 		result.ftm.rssi_avg = fw_ap->rssi;
 		result.ftm.rssi_avg_valid = 1;
 		result.ftm.rssi_spread = fw_ap->rssi_spread;
@@ -398,7 +566,7 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 				     &result, GFP_KERNEL);
 	}
 
-	if (fw_resp->last_in_batch) {
+	if (last_in_batch) {
 		cfg80211_pmsr_complete(mvm->ftm_initiator.req_wdev,
 				       mvm->ftm_initiator.req,
 				       GFP_KERNEL);
-- 
2.20.1

