Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F89C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB5C220830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfDCJXS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:23:18 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49810 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725935AbfDCJXS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:23:18 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6R-0007aR-8b; Wed, 03 Apr 2019 12:22:40 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:21 +0300
Message-Id: <20190403092224.815-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/13] iwlwifi: mvm: support rtt confidence indication
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

The range response notification API has changed to add a value that
indicates the confidence of the rtt result.
Support the new API and print the rtt confidence for debug.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/location.h  | 77 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  1 +
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 13 +++-
 3 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
index 5dddb21c1c4d..8d78b0e671c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
@@ -674,6 +674,59 @@ struct iwl_tof_range_rsp_ap_entry_ntfy_v3 {
 	__le32 papd_calib_output;
 } __packed; /* LOCATION_RANGE_RSP_AP_ETRY_NTFY_API_S_VER_3 */
 
+/**
+ * struct iwl_tof_range_rsp_ap_entry_ntfy_v4 - AP parameters (response)
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
+struct iwl_tof_range_rsp_ap_entry_ntfy_v4 {
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
  * struct iwl_tof_range_rsp_ap_entry_ntfy - AP parameters (response)
  * @bssid: BSSID of the AP
@@ -704,6 +757,8 @@ struct iwl_tof_range_rsp_ap_entry_ntfy_v3 {
  * @specific_calib: val that was used in for this AP measurement
  * @papd_calib_output: The result of the tof papd calibration that was injected
  *	into the algorithm.
+ * @rttConfidence: a value between 0 - 31 that represents the rtt accuracy.
+ * @reserved: for alignment
  */
 struct iwl_tof_range_rsp_ap_entry_ntfy {
 	u8 bssid[ETH_ALEN];
@@ -725,7 +780,9 @@ struct iwl_tof_range_rsp_ap_entry_ntfy {
 	__le16 common_calib;
 	__le16 specific_calib;
 	__le32 papd_calib_output;
-} __packed; /* LOCATION_RANGE_RSP_AP_ETRY_NTFY_API_S_VER_4 */
+	u8 rttConfidence;
+	u8 reserved[3];
+} __packed; /* LOCATION_RANGE_RSP_AP_ETRY_NTFY_API_S_VER_5 */
 
 /**
  * enum iwl_tof_response_status - tof response status
@@ -760,6 +817,22 @@ struct iwl_tof_range_rsp_ntfy_v5 {
 	struct iwl_tof_range_rsp_ap_entry_ntfy_v3 ap[IWL_MVM_TOF_MAX_APS];
 } __packed; /* LOCATION_RANGE_RSP_NTFY_API_S_VER_5 */
 
+/**
+ * struct iwl_tof_range_rsp_ntfy_v6 - ranging response notification
+ * @request_id: A Token ID of the corresponding Range request
+ * @num_of_aps: Number of APs results
+ * @last_report: 1 if no more FTM sessions are scheduled, 0 otherwise.
+ * @reserved: reserved
+ * @ap: per-AP data
+ */
+struct iwl_tof_range_rsp_ntfy_v6 {
+	u8 request_id;
+	u8 num_of_aps;
+	u8 last_report;
+	u8 reserved;
+	struct iwl_tof_range_rsp_ap_entry_ntfy_v4 ap[IWL_MVM_TOF_MAX_APS];
+} __packed; /* LOCATION_RANGE_RSP_NTFY_API_S_VER_6 */
+
 /**
  * struct iwl_tof_range_rsp_ntfy - ranging response notification
  * @request_id: A Token ID of the corresponding Range request
@@ -774,7 +847,7 @@ struct iwl_tof_range_rsp_ntfy {
 	u8 last_report;
 	u8 reserved;
 	struct iwl_tof_range_rsp_ap_entry_ntfy ap[IWL_MVM_TOF_MAX_APS];
-} __packed; /* LOCATION_RANGE_RSP_NTFY_API_S_VER_6 */
+} __packed; /* LOCATION_RANGE_RSP_NTFY_API_S_VER_7 */
 
 #define IWL_MVM_TOF_MCSI_BUF_SIZE  (245)
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index abfdcabdcbf7..1cc56003b349 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -311,6 +311,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ     = (__force iwl_ucode_tlv_api_t)49,
 	IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS    = (__force iwl_ucode_tlv_api_t)50,
 	IWL_UCODE_TLV_API_MBSSID_HE		= (__force iwl_ucode_tlv_api_t)52,
+	IWL_UCODE_TLV_API_FTM_RTT_ACCURACY      = (__force iwl_ucode_tlv_api_t)54,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 94132cfd1f56..b15a4db7198e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -480,6 +480,7 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_tof_range_rsp_ntfy_v5 *fw_resp_v5 = (void *)pkt->data;
+	struct iwl_tof_range_rsp_ntfy_v6 *fw_resp_v6 = (void *)pkt->data;
 	struct iwl_tof_range_rsp_ntfy *fw_resp = (void *)pkt->data;
 	int i;
 	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
@@ -519,7 +520,12 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		int peer_idx;
 
 		if (new_api) {
-			fw_ap = &fw_resp->ap[i];
+			if (fw_has_api(&mvm->fw->ucode_capa,
+				       IWL_UCODE_TLV_API_FTM_RTT_ACCURACY))
+				fw_ap = &fw_resp->ap[i];
+			else
+				fw_ap = (void *)&fw_resp_v6->ap[i];
+
 			result.final = fw_resp->ap[i].last_burst;
 		} else {
 			/* the first part is the same for old and new APIs */
@@ -588,6 +594,11 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 				     mvm->ftm_initiator.req,
 				     &result, GFP_KERNEL);
 
+		if (fw_has_api(&mvm->fw->ucode_capa,
+			       IWL_UCODE_TLV_API_FTM_RTT_ACCURACY))
+			IWL_DEBUG_INFO(mvm, "RTT confidence: %hhu\n",
+				       fw_ap->rttConfidence);
+
 		iwl_mvm_debug_range_resp(mvm, i, &result);
 	}
 
-- 
2.20.1

