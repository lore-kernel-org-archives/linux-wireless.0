Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A01C4151A
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E57812146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfA0KT3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:29 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51292 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726516AbfA0KT2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:28 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhX8-0001vC-Em; Sun, 27 Jan 2019 12:19:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:50 +0200
Message-Id: <20190127101908.6428-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/21] iwlwifi: remove TOF implementation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is an ancient (~2015) implementation that no longer matches
the firmware in any way, and most likely never worked. Remove all
of it so it can be reintroduced properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  12 -
 .../net/wireless/intel/iwlwifi/fw/api/tof.h   | 393 ---------
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   2 -
 .../net/wireless/intel/iwlwifi/mvm/Makefile   |   1 -
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  | 770 ------------------
 .../net/wireless/intel/iwlwifi/mvm/fw-api.h   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   3 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   8 -
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c  | 305 -------
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h  |  89 --
 10 files changed, 2 insertions(+), 1584 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/tof.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.h

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 89c0cfddcc3f..baba7bcee5fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -77,7 +77,6 @@
  * @DATA_PATH_GROUP: data path group, uses command IDs from
  *	&enum iwl_data_path_subcmd_ids
  * @NAN_GROUP: NAN group, uses command IDs from &enum iwl_nan_subcmd_ids
- * @TOF_GROUP: TOF group, uses command IDs from &enum iwl_tof_subcmd_ids
  * @PROT_OFFLOAD_GROUP: protocol offload group, uses command IDs from
  *	&enum iwl_prot_offload_subcmd_ids
  * @REGULATORY_AND_NVM_GROUP: regulatory/NVM group, uses command IDs from
@@ -92,7 +91,6 @@ enum iwl_mvm_command_groups {
 	PHY_OPS_GROUP = 0x4,
 	DATA_PATH_GROUP = 0x5,
 	NAN_GROUP = 0x7,
-	TOF_GROUP = 0x8,
 	PROT_OFFLOAD_GROUP = 0xb,
 	REGULATORY_AND_NVM_GROUP = 0xc,
 	DEBUG_GROUP = 0xf,
@@ -352,16 +350,6 @@ enum iwl_legacy_cmds {
 	 */
 	PHY_DB_CMD = 0x6c,
 
-	/**
-	 * @TOF_CMD: &struct iwl_tof_config_cmd
-	 */
-	TOF_CMD = 0x10,
-
-	/**
-	 * @TOF_NOTIFICATION: &struct iwl_tof_gen_resp_cmd
-	 */
-	TOF_NOTIFICATION = 0x11,
-
 	/**
 	 * @POWER_TABLE_CMD: &struct iwl_device_power_cmd
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tof.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tof.h
deleted file mode 100644
index 7328a1606146..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tof.h
+++ /dev/null
@@ -1,393 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * The full GNU General Public License is included in this distribution
- * in the file called COPYING.
- *
- * Contact Information:
- * Intel Linux Wireless <linuxwifi@intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#ifndef __iwl_fw_api_tof_h__
-#define __iwl_fw_api_tof_h__
-
-/* ToF sub-group command IDs */
-enum iwl_mvm_tof_sub_grp_ids {
-	TOF_RANGE_REQ_CMD = 0x1,
-	TOF_CONFIG_CMD = 0x2,
-	TOF_RANGE_ABORT_CMD = 0x3,
-	TOF_RANGE_REQ_EXT_CMD = 0x4,
-	TOF_RESPONDER_CONFIG_CMD = 0x5,
-	TOF_NW_INITIATED_RES_SEND_CMD = 0x6,
-	TOF_NEIGHBOR_REPORT_REQ_CMD = 0x7,
-	TOF_NEIGHBOR_REPORT_RSP_NOTIF = 0xFC,
-	TOF_NW_INITIATED_REQ_RCVD_NOTIF = 0xFD,
-	TOF_RANGE_RESPONSE_NOTIF = 0xFE,
-	TOF_MCSI_DEBUG_NOTIF = 0xFB,
-};
-
-/**
- * struct iwl_tof_config_cmd - ToF configuration
- * @tof_disabled: 0 enabled, 1 - disabled
- * @one_sided_disabled: 0 enabled, 1 - disabled
- * @is_debug_mode: 1 debug mode, 0 - otherwise
- * @is_buf_required: 1 channel estimation buffer required, 0 - otherwise
- */
-struct iwl_tof_config_cmd {
-	__le32 sub_grp_cmd_id;
-	u8 tof_disabled;
-	u8 one_sided_disabled;
-	u8 is_debug_mode;
-	u8 is_buf_required;
-} __packed;
-
-/**
- * struct iwl_tof_responder_config_cmd - ToF AP mode (for debug)
- * @burst_period: future use: (currently hard coded in the LMAC)
- *		  The interval between two sequential bursts.
- * @min_delta_ftm: future use: (currently hard coded in the LMAC)
- *		   The minimum delay between two sequential FTM Responses
- *		   in the same burst.
- * @burst_duration: future use: (currently hard coded in the LMAC)
- *		   The total time for all FTMs handshake in the same burst.
- *		   Affect the time events duration in the LMAC.
- * @num_of_burst_exp: future use: (currently hard coded in the LMAC)
- *		   The number of bursts for the current ToF request. Affect
- *		   the number of events allocations in the current iteration.
- * @get_ch_est: for xVT only, NA for driver
- * @abort_responder: when set to '1' - Responder will terminate its activity
- *		     (all other fields in the command are ignored)
- * @recv_sta_req_params: 1 - Responder will ignore the other Responder's
- *			 params and use the recomended Initiator params.
- *			 0 - otherwise
- * @channel_num: current AP Channel
- * @bandwidth: current AP Bandwidth: 0  20MHz, 1  40MHz, 2  80MHz
- * @rate: current AP rate
- * @ctrl_ch_position: coding of the control channel position relative to
- *	the center frequency:
- *
- *	40 MHz
- *		0 below center, 1 above center
- *
- *	80 MHz
- *		bits [0..1]
- *		 * 0  the near 20MHz to the center,
- *		 * 1  the far  20MHz to the center
- *		bit[2]
- *		 as above 40MHz
- * @ftm_per_burst: FTMs per Burst
- * @ftm_resp_ts_avail: '0' - we don't measure over the Initial FTM Response,
- *		  '1' - we measure over the Initial FTM Response
- * @asap_mode: ASAP / Non ASAP mode for the current WLS station
- * @sta_id: index of the AP STA when in AP mode
- * @tsf_timer_offset_msecs: The dictated time offset (mSec) from the AP's TSF
- * @toa_offset: Artificial addition [0.1nsec] for the ToA - to be used for debug
- *		purposes, simulating station movement by adding various values
- *		to this field
- * @bssid: Current AP BSSID
- */
-struct iwl_tof_responder_config_cmd {
-	__le32 sub_grp_cmd_id;
-	__le16 burst_period;
-	u8 min_delta_ftm;
-	u8 burst_duration;
-	u8 num_of_burst_exp;
-	u8 get_ch_est;
-	u8 abort_responder;
-	u8 recv_sta_req_params;
-	u8 channel_num;
-	u8 bandwidth;
-	u8 rate;
-	u8 ctrl_ch_position;
-	u8 ftm_per_burst;
-	u8 ftm_resp_ts_avail;
-	u8 asap_mode;
-	u8 sta_id;
-	__le16 tsf_timer_offset_msecs;
-	__le16 toa_offset;
-	u8 bssid[ETH_ALEN];
-} __packed;
-
-/**
- * struct iwl_tof_range_request_ext_cmd - extended range req for WLS
- * @tsf_timer_offset_msec: the recommended time offset (mSec) from the AP's TSF
- * @reserved: reserved
- * @min_delta_ftm: Minimal time between two consecutive measurements,
- *		   in units of 100us. 0 means no preference by station
- * @ftm_format_and_bw20M: FTM Channel Spacing/Format for 20MHz: recommended
- *			value be sent to the AP
- * @ftm_format_and_bw40M: FTM Channel Spacing/Format for 40MHz: recommended
- *			value to be sent to the AP
- * @ftm_format_and_bw80M: FTM Channel Spacing/Format for 80MHz: recommended
- *			value to be sent to the AP
- */
-struct iwl_tof_range_req_ext_cmd {
-	__le32 sub_grp_cmd_id;
-	__le16 tsf_timer_offset_msec;
-	__le16 reserved;
-	u8 min_delta_ftm;
-	u8 ftm_format_and_bw20M;
-	u8 ftm_format_and_bw40M;
-	u8 ftm_format_and_bw80M;
-} __packed;
-
-#define IWL_MVM_TOF_MAX_APS 21
-
-/**
- * struct iwl_tof_range_req_ap_entry - AP configuration parameters
- * @channel_num: Current AP Channel
- * @bandwidth: Current AP Bandwidth: 0  20MHz, 1  40MHz, 2  80MHz
- * @tsf_delta_direction: TSF relatively to the subject AP
- * @ctrl_ch_position: Coding of the control channel position relative to the
- *	     center frequency.
- *	     40MHz  0 below center, 1 above center
- *	     80MHz  bits [0..1]: 0  the near 20MHz to the center,
- *				 1  the far  20MHz to the center
- *		    bit[2]  as above 40MHz
- * @bssid: AP's bss id
- * @measure_type: Measurement type: 0 - two sided, 1 - One sided
- * @num_of_bursts: Recommended value to be sent to the AP.  2s Exponent of the
- *		   number of measurement iterations (min 2^0 = 1, max 2^14)
- * @burst_period: Recommended value to be sent to the AP. Measurement
- *		  periodicity In units of 100ms. ignored if num_of_bursts = 0
- * @samples_per_burst: 2-sided: the number of FTMs pairs in single Burst (1-31)
- *		       1-sided: how many rts/cts pairs should be used per burst.
- * @retries_per_sample: Max number of retries that the LMAC should send
- *			in case of no replies by the AP.
- * @tsf_delta: TSF Delta in units of microseconds.
- *	       The difference between the AP TSF and the device local clock.
- * @location_req: Location Request Bit[0] LCI should be sent in the FTMR
- *			      Bit[1] Civic should be sent in the FTMR
- * @asap_mode: 0 - non asap mode, 1 - asap mode (not relevant for one sided)
- * @enable_dyn_ack: Enable Dynamic ACK BW.
- *	    0  Initiator interact with regular AP
- *	    1  Initiator interact with Responder machine: need to send the
- *	    Initiator Acks with HT 40MHz / 80MHz, since the Responder should
- *	    use it for its ch est measurement (this flag will be set when we
- *	    configure the opposite machine to be Responder).
- * @rssi: Last received value
- *	  leagal values: -128-0 (0x7f). above 0x0 indicating an invalid value.
- */
-struct iwl_tof_range_req_ap_entry {
-	u8 channel_num;
-	u8 bandwidth;
-	u8 tsf_delta_direction;
-	u8 ctrl_ch_position;
-	u8 bssid[ETH_ALEN];
-	u8 measure_type;
-	u8 num_of_bursts;
-	__le16 burst_period;
-	u8 samples_per_burst;
-	u8 retries_per_sample;
-	__le32 tsf_delta;
-	u8 location_req;
-	u8 asap_mode;
-	u8 enable_dyn_ack;
-	s8 rssi;
-} __packed;
-
-/**
- * enum iwl_tof_response_mode
- * @IWL_MVM_TOF_RESPOSE_ASAP: report each AP measurement separately as soon as
- *			      possible (not supported for this release)
- * @IWL_MVM_TOF_RESPOSE_TIMEOUT: report all AP measurements as a batch upon
- *				 timeout expiration
- * @IWL_MVM_TOF_RESPOSE_COMPLETE: report all AP measurements as a batch at the
- *				  earlier of: measurements completion / timeout
- *				  expiration.
- */
-enum iwl_tof_response_mode {
-	IWL_MVM_TOF_RESPOSE_ASAP = 1,
-	IWL_MVM_TOF_RESPOSE_TIMEOUT,
-	IWL_MVM_TOF_RESPOSE_COMPLETE,
-};
-
-/**
- * struct iwl_tof_range_req_cmd - start measurement cmd
- * @request_id: A Token incremented per request. The same Token will be
- *		sent back in the range response
- * @initiator: 0- NW initiated,  1 - Client Initiated
- * @one_sided_los_disable: '0'- run ML-Algo for both ToF/OneSided,
- *			   '1' - run ML-Algo for ToF only
- * @req_timeout: Requested timeout of the response in units of 100ms.
- *	     This is equivalent to the session time configured to the
- *	     LMAC in Initiator Request
- * @report_policy: Supported partially for this release: For current release -
- *		   the range report will be uploaded as a batch when ready or
- *		   when the session is done (successfully / partially).
- *		   one of iwl_tof_response_mode.
- * @num_of_ap: Number of APs to measure (error if > IWL_MVM_TOF_MAX_APS)
- * @macaddr_random: '0' Use default source MAC address (i.e. p2_p),
- *	            '1' Use MAC Address randomization according to the below
- * @macaddr_mask: Bits set to 0 shall be copied from the MAC address template.
- *		  Bits set to 1 shall be randomized by the UMAC
- * @ap: per-AP request data
- */
-struct iwl_tof_range_req_cmd {
-	__le32 sub_grp_cmd_id;
-	u8 request_id;
-	u8 initiator;
-	u8 one_sided_los_disable;
-	u8 req_timeout;
-	u8 report_policy;
-	u8 los_det_disable;
-	u8 num_of_ap;
-	u8 macaddr_random;
-	u8 macaddr_template[ETH_ALEN];
-	u8 macaddr_mask[ETH_ALEN];
-	struct iwl_tof_range_req_ap_entry ap[IWL_MVM_TOF_MAX_APS];
-} __packed;
-
-/**
- * struct iwl_tof_gen_resp_cmd - generic ToF response
- */
-struct iwl_tof_gen_resp_cmd {
-	__le32 sub_grp_cmd_id;
-	u8 data[];
-} __packed;
-
-/**
- * struct iwl_tof_range_rsp_ap_entry_ntfy - AP parameters (response)
- * @bssid: BSSID of the AP
- * @measure_status: current APs measurement status, one of
- *	&enum iwl_tof_entry_status.
- * @measure_bw: Current AP Bandwidth: 0  20MHz, 1  40MHz, 2  80MHz
- * @rtt: The Round Trip Time that took for the last measurement for
- *	 current AP [nSec]
- * @rtt_variance: The Variance of the RTT values measured for current AP
- * @rtt_spread: The Difference between the maximum and the minimum RTT
- *	       values measured for current AP in the current session [nsec]
- * @rssi: RSSI as uploaded in the Channel Estimation notification
- * @rssi_spread: The Difference between the maximum and the minimum RSSI values
- *	        measured for current AP in the current session
- * @reserved: reserved
- * @range: Measured range [cm]
- * @range_variance: Measured range variance [cm]
- * @timestamp: The GP2 Clock [usec] where Channel Estimation notification was
- *	       uploaded by the LMAC
- */
-struct iwl_tof_range_rsp_ap_entry_ntfy {
-	u8 bssid[ETH_ALEN];
-	u8 measure_status;
-	u8 measure_bw;
-	__le32 rtt;
-	__le32 rtt_variance;
-	__le32 rtt_spread;
-	s8 rssi;
-	u8 rssi_spread;
-	__le16 reserved;
-	__le32 range;
-	__le32 range_variance;
-	__le32 timestamp;
-} __packed;
-
-/**
- * struct iwl_tof_range_rsp_ntfy -
- * @request_id: A Token ID of the corresponding Range request
- * @request_status: status of current measurement session
- * @last_in_batch: reprot policy (when not all responses are uploaded at once)
- * @num_of_aps: Number of APs to measure (error if > IWL_MVM_TOF_MAX_APS)
- * @ap: per-AP data
- */
-struct iwl_tof_range_rsp_ntfy {
-	u8 request_id;
-	u8 request_status;
-	u8 last_in_batch;
-	u8 num_of_aps;
-	struct iwl_tof_range_rsp_ap_entry_ntfy ap[IWL_MVM_TOF_MAX_APS];
-} __packed;
-
-#define IWL_MVM_TOF_MCSI_BUF_SIZE  (245)
-/**
- * struct iwl_tof_mcsi_notif - used for debug
- * @token: token ID for the current session
- * @role: '0' - initiator, '1' - responder
- * @reserved: reserved
- * @initiator_bssid: initiator machine
- * @responder_bssid: responder machine
- * @mcsi_buffer: debug data
- */
-struct iwl_tof_mcsi_notif {
-	u8 token;
-	u8 role;
-	__le16 reserved;
-	u8 initiator_bssid[ETH_ALEN];
-	u8 responder_bssid[ETH_ALEN];
-	u8 mcsi_buffer[IWL_MVM_TOF_MCSI_BUF_SIZE * 4];
-} __packed;
-
-/**
- * struct iwl_tof_neighbor_report_notif
- * @bssid: BSSID of the AP which sent the report
- * @request_token: same token as the corresponding request
- * @status:
- * @report_ie_len: the length of the response frame starting from the Element ID
- * @data: the IEs
- */
-struct iwl_tof_neighbor_report {
-	u8 bssid[ETH_ALEN];
-	u8 request_token;
-	u8 status;
-	__le16 report_ie_len;
-	u8 data[];
-} __packed;
-
-/**
- * struct iwl_tof_range_abort_cmd
- * @request_id: corresponds to a range request
- * @reserved: reserved
- */
-struct iwl_tof_range_abort_cmd {
-	__le32 sub_grp_cmd_id;
-	u8 request_id;
-	u8 reserved[3];
-} __packed;
-
-#endif
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 81f557c0b58d..dfe02bdb7481 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -303,7 +303,6 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_LAR_SUPPORT: supports Location Aware Regulatory
  * @IWL_UCODE_TLV_CAPA_UMAC_SCAN: supports UMAC scan.
  * @IWL_UCODE_TLV_CAPA_BEAMFORMER: supports Beamformer
- * @IWL_UCODE_TLV_CAPA_TOF_SUPPORT: supports Time of Flight (802.11mc FTM)
  * @IWL_UCODE_TLV_CAPA_TDLS_SUPPORT: support basic TDLS functionality
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
@@ -369,7 +368,6 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_SUPPORT			= (__force iwl_ucode_tlv_capa_t)1,
 	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= (__force iwl_ucode_tlv_capa_t)2,
 	IWL_UCODE_TLV_CAPA_BEAMFORMER			= (__force iwl_ucode_tlv_capa_t)3,
-	IWL_UCODE_TLV_CAPA_TOF_SUPPORT                  = (__force iwl_ucode_tlv_capa_t)5,
 	IWL_UCODE_TLV_CAPA_TDLS_SUPPORT			= (__force iwl_ucode_tlv_capa_t)6,
 	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= (__force iwl_ucode_tlv_capa_t)8,
 	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= (__force iwl_ucode_tlv_capa_t)9,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index 9ffd21918b5a..87373b099fd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -7,7 +7,6 @@ iwlmvm-y += power.o coex.o
 iwlmvm-y += tt.o offloading.o tdls.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
-iwlmvm-y += tof.o
 iwlmvm-$(CONFIG_PM) += d3.o
 
 ccflags-y += -I$(src)/../
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 33b0af24a537..1c0f84049573 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -60,7 +60,6 @@
  *
  *****************************************************************************/
 #include "mvm.h"
-#include "fw/api/tof.h"
 #include "debugfs.h"
 
 static void iwl_dbgfs_update_pm(struct iwl_mvm *mvm,
@@ -523,751 +522,6 @@ static ssize_t iwl_dbgfs_os_device_timediff_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_tof_enable_write(struct ieee80211_vif *vif,
-					  char *buf,
-					  size_t count, loff_t *ppos)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	u32 value;
-	int ret = -EINVAL;
-	char *data;
-
-	mutex_lock(&mvm->mutex);
-
-	data = iwl_dbgfs_is_match("tof_disabled=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.tof_cfg.tof_disabled = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("one_sided_disabled=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.tof_cfg.one_sided_disabled = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("is_debug_mode=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.tof_cfg.is_debug_mode = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("is_buf=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.tof_cfg.is_buf_required = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("send_tof_cfg=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value) {
-			ret = iwl_mvm_tof_config_cmd(mvm);
-			goto out;
-		}
-	}
-
-out:
-	mutex_unlock(&mvm->mutex);
-
-	return ret ?: count;
-}
-
-static ssize_t iwl_dbgfs_tof_enable_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct ieee80211_vif *vif = file->private_data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	char buf[256];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-	struct iwl_tof_config_cmd *cmd;
-
-	cmd = &mvm->tof_data.tof_cfg;
-
-	mutex_lock(&mvm->mutex);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "tof_disabled = %d\n",
-			 cmd->tof_disabled);
-	pos += scnprintf(buf + pos, bufsz - pos, "one_sided_disabled = %d\n",
-			 cmd->one_sided_disabled);
-	pos += scnprintf(buf + pos, bufsz - pos, "is_debug_mode = %d\n",
-			 cmd->is_debug_mode);
-	pos += scnprintf(buf + pos, bufsz - pos, "is_buf_required = %d\n",
-			 cmd->is_buf_required);
-
-	mutex_unlock(&mvm->mutex);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_dbgfs_tof_responder_params_write(struct ieee80211_vif *vif,
-						    char *buf,
-						    size_t count, loff_t *ppos)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	u32 value;
-	int ret = 0;
-	char *data;
-
-	mutex_lock(&mvm->mutex);
-
-	data = iwl_dbgfs_is_match("burst_period=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (!ret)
-			mvm->tof_data.responder_cfg.burst_period =
-							cpu_to_le16(value);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("min_delta_ftm=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.min_delta_ftm = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("burst_duration=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.burst_duration = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("num_of_burst_exp=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.num_of_burst_exp = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("abort_responder=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.abort_responder = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("get_ch_est=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.get_ch_est = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("recv_sta_req_params=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.recv_sta_req_params = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("channel_num=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.channel_num = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("bandwidth=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.bandwidth = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("rate=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.rate = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("bssid=", buf);
-	if (data) {
-		u8 *mac = mvm->tof_data.responder_cfg.bssid;
-
-		if (!mac_pton(data, mac)) {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	data = iwl_dbgfs_is_match("tsf_timer_offset_msecs=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.tsf_timer_offset_msecs =
-							cpu_to_le16(value);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("toa_offset=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.toa_offset =
-							cpu_to_le16(value);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("center_freq=", buf);
-	if (data) {
-		struct iwl_tof_responder_config_cmd *cmd =
-			&mvm->tof_data.responder_cfg;
-
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value) {
-			enum nl80211_band band = (cmd->channel_num <= 14) ?
-						   NL80211_BAND_2GHZ :
-						   NL80211_BAND_5GHZ;
-			struct ieee80211_channel chn = {
-				.band = band,
-				.center_freq = ieee80211_channel_to_frequency(
-					cmd->channel_num, band),
-				};
-			struct cfg80211_chan_def chandef = {
-				.chan =  &chn,
-				.center_freq1 =
-					ieee80211_channel_to_frequency(value,
-								       band),
-			};
-
-			cmd->ctrl_ch_position = iwl_mvm_get_ctrl_pos(&chandef);
-		}
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("ftm_per_burst=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.ftm_per_burst = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("ftm_resp_ts_avail=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.ftm_resp_ts_avail = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("asap_mode=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.asap_mode = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("send_responder_cfg=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value) {
-			ret = iwl_mvm_tof_responder_cmd(mvm, vif);
-			goto out;
-		}
-	}
-
-out:
-	mutex_unlock(&mvm->mutex);
-
-	return ret ?: count;
-}
-
-static ssize_t iwl_dbgfs_tof_responder_params_read(struct file *file,
-						   char __user *user_buf,
-						   size_t count, loff_t *ppos)
-{
-	struct ieee80211_vif *vif = file->private_data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	char buf[256];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-	struct iwl_tof_responder_config_cmd *cmd;
-
-	cmd = &mvm->tof_data.responder_cfg;
-
-	mutex_lock(&mvm->mutex);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "burst_period = %d\n",
-			 le16_to_cpu(cmd->burst_period));
-	pos += scnprintf(buf + pos, bufsz - pos, "burst_duration = %d\n",
-			 cmd->burst_duration);
-	pos += scnprintf(buf + pos, bufsz - pos, "bandwidth = %d\n",
-			 cmd->bandwidth);
-	pos += scnprintf(buf + pos, bufsz - pos, "channel_num = %d\n",
-			 cmd->channel_num);
-	pos += scnprintf(buf + pos, bufsz - pos, "ctrl_ch_position = 0x%x\n",
-			 cmd->ctrl_ch_position);
-	pos += scnprintf(buf + pos, bufsz - pos, "bssid = %pM\n",
-			 cmd->bssid);
-	pos += scnprintf(buf + pos, bufsz - pos, "min_delta_ftm = %d\n",
-			 cmd->min_delta_ftm);
-	pos += scnprintf(buf + pos, bufsz - pos, "num_of_burst_exp = %d\n",
-			 cmd->num_of_burst_exp);
-	pos += scnprintf(buf + pos, bufsz - pos, "rate = %d\n", cmd->rate);
-	pos += scnprintf(buf + pos, bufsz - pos, "abort_responder = %d\n",
-			 cmd->abort_responder);
-	pos += scnprintf(buf + pos, bufsz - pos, "get_ch_est = %d\n",
-			 cmd->get_ch_est);
-	pos += scnprintf(buf + pos, bufsz - pos, "recv_sta_req_params = %d\n",
-			 cmd->recv_sta_req_params);
-	pos += scnprintf(buf + pos, bufsz - pos, "ftm_per_burst = %d\n",
-			 cmd->ftm_per_burst);
-	pos += scnprintf(buf + pos, bufsz - pos, "ftm_resp_ts_avail = %d\n",
-			 cmd->ftm_resp_ts_avail);
-	pos += scnprintf(buf + pos, bufsz - pos, "asap_mode = %d\n",
-			 cmd->asap_mode);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "tsf_timer_offset_msecs = %d\n",
-			 le16_to_cpu(cmd->tsf_timer_offset_msecs));
-	pos += scnprintf(buf + pos, bufsz - pos, "toa_offset = %d\n",
-			 le16_to_cpu(cmd->toa_offset));
-
-	mutex_unlock(&mvm->mutex);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
-						 char *buf, size_t count,
-						 loff_t *ppos)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	u32 value;
-	int ret = 0;
-	char *data;
-
-	mutex_lock(&mvm->mutex);
-
-	data = iwl_dbgfs_is_match("request_id=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.request_id = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("initiator=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.initiator = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("one_sided_los_disable=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.one_sided_los_disable = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("req_timeout=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.req_timeout = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("report_policy=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.report_policy = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("macaddr_random=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.macaddr_random = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("num_of_ap=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req.num_of_ap = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("macaddr_template=", buf);
-	if (data) {
-		u8 mac[ETH_ALEN];
-
-		if (!mac_pton(data, mac)) {
-			ret = -EINVAL;
-			goto out;
-		}
-		memcpy(mvm->tof_data.range_req.macaddr_template, mac, ETH_ALEN);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("macaddr_mask=", buf);
-	if (data) {
-		u8 mac[ETH_ALEN];
-
-		if (!mac_pton(data, mac)) {
-			ret = -EINVAL;
-			goto out;
-		}
-		memcpy(mvm->tof_data.range_req.macaddr_mask, mac, ETH_ALEN);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("ap=", buf);
-	if (data) {
-		struct iwl_tof_range_req_ap_entry ap = {};
-		int size = sizeof(struct iwl_tof_range_req_ap_entry);
-		u16 burst_period;
-		u8 *mac = ap.bssid;
-		unsigned int i;
-
-		if (sscanf(data, "%u %hhd %hhd %hhd"
-			   "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx"
-			   "%hhd %hhd %hd"
-			   "%hhd %hhd %d"
-			   "%hhx %hhd %hhd %hhd",
-			   &i, &ap.channel_num, &ap.bandwidth,
-			   &ap.ctrl_ch_position,
-			   mac, mac + 1, mac + 2, mac + 3, mac + 4, mac + 5,
-			   &ap.measure_type, &ap.num_of_bursts,
-			   &burst_period,
-			   &ap.samples_per_burst, &ap.retries_per_sample,
-			   &ap.tsf_delta, &ap.location_req, &ap.asap_mode,
-			   &ap.enable_dyn_ack, &ap.rssi) != 20) {
-			ret = -EINVAL;
-			goto out;
-		}
-		if (i >= IWL_MVM_TOF_MAX_APS) {
-			IWL_ERR(mvm, "Invalid AP index %d\n", i);
-			ret = -EINVAL;
-			goto out;
-		}
-
-		ap.burst_period = cpu_to_le16(burst_period);
-
-		memcpy(&mvm->tof_data.range_req.ap[i], &ap, size);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("send_range_request=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value)
-			ret = iwl_mvm_tof_range_request_cmd(mvm, vif);
-		goto out;
-	}
-
-	ret = -EINVAL;
-out:
-	mutex_unlock(&mvm->mutex);
-	return ret ?: count;
-}
-
-static ssize_t iwl_dbgfs_tof_range_request_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos)
-{
-	struct ieee80211_vif *vif = file->private_data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	char buf[512];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-	struct iwl_tof_range_req_cmd *cmd;
-	int i;
-
-	cmd = &mvm->tof_data.range_req;
-
-	mutex_lock(&mvm->mutex);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "request_id= %d\n",
-			 cmd->request_id);
-	pos += scnprintf(buf + pos, bufsz - pos, "initiator= %d\n",
-			 cmd->initiator);
-	pos += scnprintf(buf + pos, bufsz - pos, "one_sided_los_disable = %d\n",
-			 cmd->one_sided_los_disable);
-	pos += scnprintf(buf + pos, bufsz - pos, "req_timeout= %d\n",
-			 cmd->req_timeout);
-	pos += scnprintf(buf + pos, bufsz - pos, "report_policy= %d\n",
-			 cmd->report_policy);
-	pos += scnprintf(buf + pos, bufsz - pos, "macaddr_random= %d\n",
-			 cmd->macaddr_random);
-	pos += scnprintf(buf + pos, bufsz - pos, "macaddr_template= %pM\n",
-			 cmd->macaddr_template);
-	pos += scnprintf(buf + pos, bufsz - pos, "macaddr_mask= %pM\n",
-			 cmd->macaddr_mask);
-	pos += scnprintf(buf + pos, bufsz - pos, "num_of_ap= %d\n",
-			 cmd->num_of_ap);
-	for (i = 0; i < cmd->num_of_ap; i++) {
-		struct iwl_tof_range_req_ap_entry *ap = &cmd->ap[i];
-
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"ap %.2d: channel_num=%hhd bw=%hhd"
-				" control=%hhd bssid=%pM type=%hhd"
-				" num_of_bursts=%hhd burst_period=%hd ftm=%hhd"
-				" retries=%hhd tsf_delta=%d"
-				" tsf_delta_direction=%hhd location_req=0x%hhx "
-				" asap=%hhd enable=%hhd rssi=%hhd\n",
-				i, ap->channel_num, ap->bandwidth,
-				ap->ctrl_ch_position, ap->bssid,
-				ap->measure_type, ap->num_of_bursts,
-				ap->burst_period, ap->samples_per_burst,
-				ap->retries_per_sample, ap->tsf_delta,
-				ap->tsf_delta_direction,
-				ap->location_req, ap->asap_mode,
-				ap->enable_dyn_ack, ap->rssi);
-	}
-
-	mutex_unlock(&mvm->mutex);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_dbgfs_tof_range_req_ext_write(struct ieee80211_vif *vif,
-						 char *buf,
-						 size_t count, loff_t *ppos)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	u32 value;
-	int ret = 0;
-	char *data;
-
-	mutex_lock(&mvm->mutex);
-
-	data = iwl_dbgfs_is_match("tsf_timer_offset_msec=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req_ext.tsf_timer_offset_msec =
-							cpu_to_le16(value);
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("min_delta_ftm=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req_ext.min_delta_ftm = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("ftm_format_and_bw20M=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req_ext.ftm_format_and_bw20M =
-									value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("ftm_format_and_bw40M=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req_ext.ftm_format_and_bw40M =
-									value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("ftm_format_and_bw80M=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.range_req_ext.ftm_format_and_bw80M =
-									value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("send_range_req_ext=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value)
-			ret = iwl_mvm_tof_range_request_ext_cmd(mvm, vif);
-		goto out;
-	}
-
-	ret = -EINVAL;
-out:
-	mutex_unlock(&mvm->mutex);
-	return ret ?: count;
-}
-
-static ssize_t iwl_dbgfs_tof_range_req_ext_read(struct file *file,
-						char __user *user_buf,
-						size_t count, loff_t *ppos)
-{
-	struct ieee80211_vif *vif = file->private_data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	char buf[256];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-	struct iwl_tof_range_req_ext_cmd *cmd;
-
-	cmd = &mvm->tof_data.range_req_ext;
-
-	mutex_lock(&mvm->mutex);
-
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "tsf_timer_offset_msec = %hd\n",
-			 cmd->tsf_timer_offset_msec);
-	pos += scnprintf(buf + pos, bufsz - pos, "min_delta_ftm = %hhd\n",
-			 cmd->min_delta_ftm);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ftm_format_and_bw20M = %hhd\n",
-			 cmd->ftm_format_and_bw20M);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ftm_format_and_bw40M = %hhd\n",
-			 cmd->ftm_format_and_bw40M);
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "ftm_format_and_bw80M = %hhd\n",
-			 cmd->ftm_format_and_bw80M);
-
-	mutex_unlock(&mvm->mutex);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_dbgfs_tof_range_abort_write(struct ieee80211_vif *vif,
-					       char *buf,
-					       size_t count, loff_t *ppos)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	u32 value;
-	int abort_id, ret = 0;
-	char *data;
-
-	mutex_lock(&mvm->mutex);
-
-	data = iwl_dbgfs_is_match("abort_id=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.last_abort_id = value;
-		goto out;
-	}
-
-	data = iwl_dbgfs_is_match("send_range_abort=", buf);
-	if (data) {
-		ret = kstrtou32(data, 10, &value);
-		if (ret == 0 && value) {
-			abort_id = mvm->tof_data.last_abort_id;
-			ret = iwl_mvm_tof_range_abort_cmd(mvm, abort_id);
-			goto out;
-		}
-	}
-
-out:
-	mutex_unlock(&mvm->mutex);
-	return ret ?: count;
-}
-
-static ssize_t iwl_dbgfs_tof_range_abort_read(struct file *file,
-					      char __user *user_buf,
-					      size_t count, loff_t *ppos)
-{
-	struct ieee80211_vif *vif = file->private_data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	char buf[32];
-	int pos = 0;
-	const size_t bufsz = sizeof(buf);
-	int last_abort_id;
-
-	mutex_lock(&mvm->mutex);
-	last_abort_id = mvm->tof_data.last_abort_id;
-	mutex_unlock(&mvm->mutex);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "last_abort_id = %d\n",
-			 last_abort_id);
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_dbgfs_tof_range_response_read(struct file *file,
-						 char __user *user_buf,
-						 size_t count, loff_t *ppos)
-{
-	struct ieee80211_vif *vif = file->private_data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	char *buf;
-	int pos = 0;
-	const size_t bufsz = sizeof(struct iwl_tof_range_rsp_ntfy) + 256;
-	struct iwl_tof_range_rsp_ntfy *cmd;
-	int i, ret;
-
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	mutex_lock(&mvm->mutex);
-	cmd = &mvm->tof_data.range_resp;
-
-	pos += scnprintf(buf + pos, bufsz - pos, "request_id = %d\n",
-			 cmd->request_id);
-	pos += scnprintf(buf + pos, bufsz - pos, "status = %d\n",
-			 cmd->request_status);
-	pos += scnprintf(buf + pos, bufsz - pos, "last_in_batch = %d\n",
-			 cmd->last_in_batch);
-	pos += scnprintf(buf + pos, bufsz - pos, "num_of_aps = %d\n",
-			 cmd->num_of_aps);
-	for (i = 0; i < cmd->num_of_aps; i++) {
-		struct iwl_tof_range_rsp_ap_entry_ntfy *ap = &cmd->ap[i];
-
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"ap %.2d: bssid=%pM status=%hhd bw=%hhd"
-				" rtt=%d rtt_var=%d rtt_spread=%d"
-				" rssi=%hhd  rssi_spread=%hhd"
-				" range=%d range_var=%d"
-				" time_stamp=%d\n",
-				i, ap->bssid, ap->measure_status,
-				ap->measure_bw,
-				ap->rtt, ap->rtt_variance, ap->rtt_spread,
-				ap->rssi, ap->rssi_spread, ap->range,
-				ap->range_variance, ap->timestamp);
-	}
-	mutex_unlock(&mvm->mutex);
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
 static ssize_t iwl_dbgfs_low_latency_write(struct ieee80211_vif *vif, char *buf,
 					   size_t count, loff_t *ppos)
 {
@@ -1458,12 +712,6 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(uapsd_misbehaving, 20);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(rx_phyinfo, 10);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_enable, 32);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_range_request, 512);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_range_req_ext, 32);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_range_abort, 32);
-MVM_DEBUGFS_READ_FILE_OPS(tof_range_response);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(tof_responder_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(quota_min, 32);
 MVM_DEBUGFS_READ_FILE_OPS(os_device_timediff);
 
@@ -1506,24 +754,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	    mvmvif == mvm->bf_allowed_vif)
 		MVM_DEBUGFS_ADD_FILE_VIF(bf_params, mvmvif->dbgfs_dir, 0600);
 
-	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT) &&
-	    !vif->p2p && (vif->type != NL80211_IFTYPE_P2P_DEVICE)) {
-		if (IWL_MVM_TOF_IS_RESPONDER && vif->type == NL80211_IFTYPE_AP)
-			MVM_DEBUGFS_ADD_FILE_VIF(tof_responder_params,
-						 mvmvif->dbgfs_dir, 0600);
-
-		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_request, mvmvif->dbgfs_dir,
-					 0600);
-		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_req_ext, mvmvif->dbgfs_dir,
-					 0600);
-		MVM_DEBUGFS_ADD_FILE_VIF(tof_enable, mvmvif->dbgfs_dir,
-					 0600);
-		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_abort, mvmvif->dbgfs_dir,
-					 0600);
-		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_response, mvmvif->dbgfs_dir,
-					 0400);
-	}
-
 	/*
 	 * Create symlink for convenience pointing to interface specific
 	 * debugfs entries for the driver. For example, under
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 143c7fcaea41..851bfb259f10 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -89,7 +91,6 @@
 #include "fw/api/sf.h"
 #include "fw/api/sta.h"
 #include "fw/api/stats.h"
-#include "fw/api/tof.h"
 #include "fw/api/tx.h"
 
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index a289b9488c03..5d28080e257e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -83,7 +83,6 @@
 #include "sta.h"
 #include "fw-api.h"
 #include "constants.h"
-#include "tof.h"
 #include "fw/runtime.h"
 #include "fw/dbg.h"
 #include "fw/acpi.h"
@@ -1124,7 +1123,6 @@ struct iwl_mvm {
 
 	u32 ciphers[IWL_MVM_NUM_CIPHERS];
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
-	struct iwl_mvm_tof_data tof_data;
 
 	struct ieee80211_vif *nan_vif;
 #define IWL_MAX_BAID	32
@@ -1184,7 +1182,6 @@ enum iwl_mvm_init_status {
 	IWL_MVM_INIT_STATUS_THERMAL_INIT_COMPLETE = BIT(0),
 	IWL_MVM_INIT_STATUS_LEDS_INIT_COMPLETE = BIT(1),
 	IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE = BIT(2),
-	IWL_MVM_INIT_STATUS_TOF_INIT_COMPLETE = BIT(3),
 };
 
 static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ee2ef3f0042c..93b7cc5910fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -301,8 +301,6 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER(MFUART_LOAD_NOTIFICATION, iwl_mvm_rx_mfuart_notif,
 		   RX_HANDLER_SYNC),
-	RX_HANDLER(TOF_NOTIFICATION, iwl_mvm_tof_resp_handler,
-		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER_GRP(DEBUG_GROUP, MFU_ASSERT_DUMP_NTF,
 		       iwl_mvm_mfu_assert_dump_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(PROT_OFFLOAD_GROUP, STORED_BEACON_NTF,
@@ -329,8 +327,6 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 	HCMD_NAME(SCAN_REQ_UMAC),
 	HCMD_NAME(SCAN_ABORT_UMAC),
 	HCMD_NAME(SCAN_COMPLETE_UMAC),
-	HCMD_NAME(TOF_CMD),
-	HCMD_NAME(TOF_NOTIFICATION),
 	HCMD_NAME(BA_WINDOW_STATUS_NOTIFICATION_ID),
 	HCMD_NAME(ADD_STA_KEY),
 	HCMD_NAME(ADD_STA),
@@ -846,8 +842,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (iwl_mvm_is_d0i3_supported(mvm))
 		iwl_trans_unref(mvm->trans);
 
-	iwl_mvm_tof_init(mvm);
-
 	iwl_mvm_toggle_tx_ant(mvm, &mvm->mgmt_last_antenna_idx);
 
 	return op_mode;
@@ -913,8 +907,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	cancel_delayed_work_sync(&mvm->tcm.work);
 
-	iwl_mvm_tof_clean(mvm);
-
 	iwl_fw_runtime_free(&mvm->fwrt);
 	mutex_destroy(&mvm->mutex);
 	mutex_destroy(&mvm->d0i3_suspend_mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c b/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
deleted file mode 100644
index 01e0a999063b..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.c
+++ /dev/null
@@ -1,305 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2015 Intel Deutschland GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * The full GNU General Public License is included in this distribution
- * in the file called COPYING.
- *
- * Contact Information:
- * Intel Linux Wireless <linuxwifi@intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Deutschland GmbH
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#include "mvm.h"
-#include "fw/api/tof.h"
-
-#define IWL_MVM_TOF_RANGE_REQ_MAX_ID 256
-
-void iwl_mvm_tof_init(struct iwl_mvm *mvm)
-{
-	struct iwl_mvm_tof_data *tof_data = &mvm->tof_data;
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
-		return;
-
-	memset(tof_data, 0, sizeof(*tof_data));
-
-	tof_data->tof_cfg.sub_grp_cmd_id = cpu_to_le32(TOF_CONFIG_CMD);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (IWL_MVM_TOF_IS_RESPONDER) {
-		tof_data->responder_cfg.sub_grp_cmd_id =
-			cpu_to_le32(TOF_RESPONDER_CONFIG_CMD);
-		tof_data->responder_cfg.sta_id = IWL_MVM_INVALID_STA;
-	}
-#endif
-
-	tof_data->range_req.sub_grp_cmd_id = cpu_to_le32(TOF_RANGE_REQ_CMD);
-	tof_data->range_req.req_timeout = 1;
-	tof_data->range_req.initiator = 1;
-	tof_data->range_req.report_policy = 3;
-
-	tof_data->range_req_ext.sub_grp_cmd_id =
-		cpu_to_le32(TOF_RANGE_REQ_EXT_CMD);
-
-	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
-	mvm->init_status |= IWL_MVM_INIT_STATUS_TOF_INIT_COMPLETE;
-}
-
-void iwl_mvm_tof_clean(struct iwl_mvm *mvm)
-{
-	struct iwl_mvm_tof_data *tof_data = &mvm->tof_data;
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa,
-			 IWL_UCODE_TLV_CAPA_TOF_SUPPORT) ||
-	    !(mvm->init_status & IWL_MVM_INIT_STATUS_TOF_INIT_COMPLETE))
-		return;
-
-	memset(tof_data, 0, sizeof(*tof_data));
-	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
-	mvm->init_status &= ~IWL_MVM_INIT_STATUS_TOF_INIT_COMPLETE;
-}
-
-static void iwl_tof_iterator(void *_data, u8 *mac,
-			     struct ieee80211_vif *vif)
-{
-	bool *enabled = _data;
-
-	/* non bss vif exists */
-	if (ieee80211_vif_type_p2p(vif) !=  NL80211_IFTYPE_STATION)
-		*enabled = false;
-}
-
-int iwl_mvm_tof_config_cmd(struct iwl_mvm *mvm)
-{
-	struct iwl_tof_config_cmd *cmd = &mvm->tof_data.tof_cfg;
-	bool enabled;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
-		return -EINVAL;
-
-	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-						   IEEE80211_IFACE_ITER_NORMAL,
-						   iwl_tof_iterator, &enabled);
-	if (!enabled) {
-		IWL_DEBUG_INFO(mvm, "ToF is not supported (non bss vif)\n");
-		return -EINVAL;
-	}
-
-	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
-	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
-						    IWL_ALWAYS_LONG_GROUP, 0),
-				    0, sizeof(*cmd), cmd);
-}
-
-int iwl_mvm_tof_range_abort_cmd(struct iwl_mvm *mvm, u8 id)
-{
-	struct iwl_tof_range_abort_cmd cmd = {
-		.sub_grp_cmd_id = cpu_to_le32(TOF_RANGE_ABORT_CMD),
-		.request_id = id,
-	};
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
-		return -EINVAL;
-
-	if (id != mvm->tof_data.active_range_request) {
-		IWL_ERR(mvm, "Invalid range request id %d (active %d)\n",
-			id, mvm->tof_data.active_range_request);
-		return -EINVAL;
-	}
-
-	/* after abort is sent there's no active request anymore */
-	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
-
-	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
-						    IWL_ALWAYS_LONG_GROUP, 0),
-				    0, sizeof(cmd), &cmd);
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_mvm_tof_responder_cmd(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif)
-{
-	struct iwl_tof_responder_config_cmd *cmd = &mvm->tof_data.responder_cfg;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
-		return -EINVAL;
-
-	if (vif->p2p || vif->type != NL80211_IFTYPE_AP ||
-	    !mvmvif->ap_ibss_active) {
-		IWL_ERR(mvm, "Cannot start responder, not in AP mode\n");
-		return -EIO;
-	}
-
-	cmd->sta_id = mvmvif->bcast_sta.sta_id;
-	memcpy(cmd->bssid, vif->addr, ETH_ALEN);
-	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
-						    IWL_ALWAYS_LONG_GROUP, 0),
-				    0, sizeof(*cmd), cmd);
-}
-#endif
-
-int iwl_mvm_tof_range_request_cmd(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif)
-{
-	struct iwl_host_cmd cmd = {
-		.id = iwl_cmd_id(TOF_CMD, IWL_ALWAYS_LONG_GROUP, 0),
-		.len = { sizeof(mvm->tof_data.range_req), },
-		/* no copy because of the command size */
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
-
-	lockdep_assert_held(&mvm->mutex);
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
-		return -EINVAL;
-
-	if (ieee80211_vif_type_p2p(vif) !=  NL80211_IFTYPE_STATION) {
-		IWL_ERR(mvm, "Cannot send range request, not STA mode\n");
-		return -EIO;
-	}
-
-	/* nesting of range requests is not supported in FW */
-	if (mvm->tof_data.active_range_request !=
-		IWL_MVM_TOF_RANGE_REQ_MAX_ID) {
-		IWL_ERR(mvm, "Cannot send range req, already active req %d\n",
-			mvm->tof_data.active_range_request);
-		return -EIO;
-	}
-
-	mvm->tof_data.active_range_request = mvm->tof_data.range_req.request_id;
-
-	cmd.data[0] = &mvm->tof_data.range_req;
-	return iwl_mvm_send_cmd(mvm, &cmd);
-}
-
-int iwl_mvm_tof_range_request_ext_cmd(struct iwl_mvm *mvm,
-				      struct ieee80211_vif *vif)
-{
-	lockdep_assert_held(&mvm->mutex);
-
-	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT))
-		return -EINVAL;
-
-	if (ieee80211_vif_type_p2p(vif) !=  NL80211_IFTYPE_STATION) {
-		IWL_ERR(mvm, "Cannot send ext range req, not in STA mode\n");
-		return -EIO;
-	}
-
-	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
-						    IWL_ALWAYS_LONG_GROUP, 0),
-				    0, sizeof(mvm->tof_data.range_req_ext),
-				    &mvm->tof_data.range_req_ext);
-}
-
-static int iwl_mvm_tof_range_resp(struct iwl_mvm *mvm, void *data)
-{
-	struct iwl_tof_range_rsp_ntfy *resp = (void *)data;
-
-	if (resp->request_id != mvm->tof_data.active_range_request) {
-		IWL_ERR(mvm, "Request id mismatch, got %d, active %d\n",
-			resp->request_id, mvm->tof_data.active_range_request);
-		return -EIO;
-	}
-
-	memcpy(&mvm->tof_data.range_resp, resp,
-	       sizeof(struct iwl_tof_range_rsp_ntfy));
-	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
-
-	return 0;
-}
-
-static int iwl_mvm_tof_mcsi_notif(struct iwl_mvm *mvm, void *data)
-{
-	struct iwl_tof_mcsi_notif *resp = (struct iwl_tof_mcsi_notif *)data;
-
-	IWL_DEBUG_INFO(mvm, "MCSI notification, token %d\n", resp->token);
-	return 0;
-}
-
-static int iwl_mvm_tof_nb_report_notif(struct iwl_mvm *mvm, void *data)
-{
-	struct iwl_tof_neighbor_report *report =
-		(struct iwl_tof_neighbor_report *)data;
-
-	IWL_DEBUG_INFO(mvm, "NB report, bssid %pM, token %d, status 0x%x\n",
-		       report->bssid, report->request_token, report->status);
-	return 0;
-}
-
-void iwl_mvm_tof_resp_handler(struct iwl_mvm *mvm,
-			      struct iwl_rx_cmd_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_tof_gen_resp_cmd *resp = (void *)pkt->data;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	switch (le32_to_cpu(resp->sub_grp_cmd_id)) {
-	case TOF_RANGE_RESPONSE_NOTIF:
-		iwl_mvm_tof_range_resp(mvm, resp->data);
-		break;
-	case TOF_MCSI_DEBUG_NOTIF:
-		iwl_mvm_tof_mcsi_notif(mvm, resp->data);
-		break;
-	case TOF_NEIGHBOR_REPORT_RSP_NOTIF:
-		iwl_mvm_tof_nb_report_notif(mvm, resp->data);
-		break;
-	default:
-	       IWL_ERR(mvm, "Unknown sub-group command 0x%x\n",
-		       resp->sub_grp_cmd_id);
-	       break;
-	}
-}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tof.h b/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
deleted file mode 100644
index 8138d0606c52..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tof.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2015 Intel Deutschland GmbH
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * The full GNU General Public License is included in this distribution
- * in the file called COPYING.
- *
- * Contact Information:
- * Intel Linux Wireless <linuxwifi@intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Deutschland GmbH
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-#ifndef __tof_h__
-#define __tof_h__
-
-#include "fw/api/tof.h"
-
-struct iwl_mvm_tof_data {
-	struct iwl_tof_config_cmd tof_cfg;
-	struct iwl_tof_range_req_cmd range_req;
-	struct iwl_tof_range_req_ext_cmd range_req_ext;
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	struct iwl_tof_responder_config_cmd responder_cfg;
-#endif
-	struct iwl_tof_range_rsp_ntfy range_resp;
-	u8 last_abort_id;
-	u16 active_range_request;
-};
-
-void iwl_mvm_tof_init(struct iwl_mvm *mvm);
-void iwl_mvm_tof_clean(struct iwl_mvm *mvm);
-int iwl_mvm_tof_config_cmd(struct iwl_mvm *mvm);
-int iwl_mvm_tof_range_abort_cmd(struct iwl_mvm *mvm, u8 id);
-int iwl_mvm_tof_range_request_cmd(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif);
-void iwl_mvm_tof_resp_handler(struct iwl_mvm *mvm,
-			      struct iwl_rx_cmd_buffer *rxb);
-int iwl_mvm_tof_range_request_ext_cmd(struct iwl_mvm *mvm,
-				      struct ieee80211_vif *vif);
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_mvm_tof_responder_cmd(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif);
-#endif
-#endif /* __tof_h__ */
-- 
2.20.1

