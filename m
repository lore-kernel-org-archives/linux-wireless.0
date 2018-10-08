Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C5CC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 007D82087D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 007D82087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbeJHP2P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56302 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726113AbeJHP2P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:15 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9QjX-0003w6-KO; Mon, 08 Oct 2018 11:17:44 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:21 +0300
Message-Id: <20181008081735.3401-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/18] iwlwifi: mvm: introduce a new fragmented scan type: fast balance
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ayala Beker <ayala.beker@intel.com>

Fast balance scan is similar to SCAN_TYPE_MILD, but this scan is
fragmented and has shorter out of operating channel time,
and therefore better match low latency scenarios.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 24 +++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 8f71eeed50d9..6f927052aeaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -512,6 +512,7 @@ enum iwl_mvm_scan_type {
 	IWL_SCAN_TYPE_WILD,
 	IWL_SCAN_TYPE_MILD,
 	IWL_SCAN_TYPE_FRAGMENTED,
+	IWL_SCAN_TYPE_FAST_BALANCE,
 };
 
 enum iwl_mvm_sched_scan_pass_all_states {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index ffcd0ca86041..b43bf116c7e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -110,6 +110,10 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.suspend_time = 95,
 		.max_out_time = 44,
 	},
+	[IWL_SCAN_TYPE_FAST_BALANCE] = {
+		.suspend_time = 30,
+		.max_out_time = 37,
+	},
 };
 
 struct iwl_mvm_scan_params {
@@ -860,6 +864,12 @@ static inline bool iwl_mvm_is_regular_scan(struct iwl_mvm_scan_params *params)
 		params->scan_plans[0].iterations == 1;
 }
 
+static bool iwl_mvm_is_scan_fragmented(enum iwl_mvm_scan_type type)
+{
+	return (type == IWL_SCAN_TYPE_FRAGMENTED ||
+		type == IWL_SCAN_TYPE_FAST_BALANCE);
+}
+
 static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 				   struct iwl_mvm_scan_params *params,
 				   struct ieee80211_vif *vif)
@@ -872,7 +882,7 @@ static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
-	if (params->type == IWL_SCAN_TYPE_FRAGMENTED)
+	if (iwl_mvm_is_scan_fragmented(params->type))
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
 	if (iwl_mvm_rrm_scan_needed(mvm) &&
@@ -895,7 +905,7 @@ static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 
 	if (iwl_mvm_is_regular_scan(params) &&
 	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
-	    params->type != IWL_SCAN_TYPE_FRAGMENTED)
+	    !iwl_mvm_is_scan_fragmented(params->type))
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_EXTENDED_DWELL;
 
 	return flags;
@@ -1162,7 +1172,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 		 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
 		 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS |
 		 SCAN_CONFIG_N_CHANNELS(num_channels) |
-		 (type == IWL_SCAN_TYPE_FRAGMENTED ?
+		 (iwl_mvm_is_scan_fragmented(type) ?
 		  SCAN_CONFIG_FLAG_SET_FRAGMENTED :
 		  SCAN_CONFIG_FLAG_CLEAR_FRAGMENTED);
 
@@ -1177,7 +1187,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	 */
 	if (iwl_mvm_cdb_scan_api(mvm)) {
 		if (iwl_mvm_is_cdb_supported(mvm))
-			flags |= (hb_type == IWL_SCAN_TYPE_FRAGMENTED) ?
+			flags |= (iwl_mvm_is_scan_fragmented(hb_type)) ?
 				 SCAN_CONFIG_FLAG_SET_LMAC2_FRAGMENTED :
 				 SCAN_CONFIG_FLAG_CLEAR_LMAC2_FRAGMENTED;
 		iwl_mvm_fill_scan_config(mvm, cfg, flags, channel_flags);
@@ -1338,11 +1348,11 @@ static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT;
 
-	if (params->type == IWL_SCAN_TYPE_FRAGMENTED)
+	if (iwl_mvm_is_scan_fragmented(params->type))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED;
 
 	if (iwl_mvm_is_cdb_supported(mvm) &&
-	    params->hb_type == IWL_SCAN_TYPE_FRAGMENTED)
+	    iwl_mvm_is_scan_fragmented(params->hb_type))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_LMAC2_FRAGMENTED;
 
 	if (iwl_mvm_rrm_scan_needed(mvm) &&
@@ -1380,7 +1390,7 @@ static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	 */
 	if (iwl_mvm_is_regular_scan(params) &&
 	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
-	    params->type != IWL_SCAN_TYPE_FRAGMENTED &&
+	    !iwl_mvm_is_scan_fragmented(params->type) &&
 	    !iwl_mvm_is_adaptive_dwell_supported(mvm) &&
 	    !iwl_mvm_is_oce_supported(mvm))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_EXTENDED_DWELL;
-- 
2.19.0

