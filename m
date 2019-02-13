Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F151C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 06:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D27B8222BE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 06:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbfBMGzc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 01:55:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:59192 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387415AbfBMGzc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 01:55:32 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gtoS9-0006Lr-PJ; Wed, 13 Feb 2019 08:55:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 13 Feb 2019 08:55:24 +0200
Message-Id: <20190213065524.2875-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190212075620.12055-1-luca@coelho.fi>
References: <20190212075620.12055-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/20 v3] iwlwifi: mvm: add debug prints for FTM
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

Add debug prints for FTM results info. These prints are used by
tests automation.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
In v3:

   * Johannes was not happy with my do_div() comment, so I removed it.


.../intel/iwlwifi/mvm/ftm-initiator.c         | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index c1d9703ab40c..e9822a3ec373 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -457,6 +457,27 @@ static int iwl_mvm_ftm_range_resp_valid(struct iwl_mvm *mvm, u8 request_id,
 	return 0;
 }
 
+static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
+				     struct cfg80211_pmsr_result *res)
+{
+	s64 rtt_avg = res->ftm.rtt_avg * 100;
+
+	do_div(rtt_avg, 6666);
+
+	IWL_DEBUG_INFO(mvm, "entry %d\n", index);
+	IWL_DEBUG_INFO(mvm, "\tstatus: %d\n", res->status);
+	IWL_DEBUG_INFO(mvm, "\tBSSID: %pM\n", res->addr);
+	IWL_DEBUG_INFO(mvm, "\thost time: %llu\n", res->host_time);
+	IWL_DEBUG_INFO(mvm, "\tburst index: %hhu\n", res->ftm.burst_index);
+	IWL_DEBUG_INFO(mvm, "\tsuccess num: %u\n", res->ftm.num_ftmr_successes);
+	IWL_DEBUG_INFO(mvm, "\trssi: %d\n", res->ftm.rssi_avg);
+	IWL_DEBUG_INFO(mvm, "\trssi spread: %hhu\n", res->ftm.rssi_spread);
+	IWL_DEBUG_INFO(mvm, "\trtt: %lld\n", res->ftm.rtt_avg);
+	IWL_DEBUG_INFO(mvm, "\trtt var: %llu\n", res->ftm.rtt_variance);
+	IWL_DEBUG_INFO(mvm, "\trtt spread: %llu\n", res->ftm.rtt_spread);
+	IWL_DEBUG_INFO(mvm, "\tdistance: %lld\n", rtt_avg);
+}
+
 void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -490,6 +511,10 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		last_in_batch = fw_resp_v5->last_in_batch;
 	}
 
+	IWL_DEBUG_INFO(mvm, "Range response received\n");
+	IWL_DEBUG_INFO(mvm, "request id: %lld, num of entries: %hhu\n",
+		       mvm->ftm_initiator.req->cookie, num_of_aps);
+
 	for (i = 0; i < num_of_aps && i < IWL_MVM_TOF_MAX_APS; i++) {
 		struct cfg80211_pmsr_result result = {};
 		struct iwl_tof_range_rsp_ap_entry_ntfy *fw_ap;
@@ -564,6 +589,8 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		cfg80211_pmsr_report(mvm->ftm_initiator.req_wdev,
 				     mvm->ftm_initiator.req,
 				     &result, GFP_KERNEL);
+
+		iwl_mvm_debug_range_resp(mvm, i, &result);
 	}
 
 	if (last_in_batch) {
-- 
2.20.1

