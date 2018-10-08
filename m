Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D97AC65BD4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 536012087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 536012087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbeJHP2Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:16 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56312 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726793AbeJHP2Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:16 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9QjY-0003w6-C6; Mon, 08 Oct 2018 11:17:44 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:22 +0300
Message-Id: <20181008081735.3401-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/18] iwlwifi: mvm: use fast balance scan in case of DCM mode with P2P GO
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ayala Beker <ayala.beker@intel.com>

Currently in case of DCM with P2P GO where BSS DTIM interval < 220 msec
the fw fails to allocate events for the P2P GO dtim due to long passive
scan events.

Fix this by requesting all scans in this scenario to be fragmented with
fast balance scan time settings.  The only exception is in case
fragmented scan was planned to be set due to low latency or high
throughput reason, set the scan timing as planned.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 91 ++++++++++++++-----
 1 file changed, 68 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index b43bf116c7e8..cfb784fea77b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -239,8 +239,32 @@ iwl_mvm_get_traffic_load_band(struct iwl_mvm *mvm, enum nl80211_band band)
 	return mvm->tcm.result.band_load[band];
 }
 
+struct iwl_is_dcm_with_go_iterator_data {
+	struct ieee80211_vif *current_vif;
+	bool is_dcm_with_p2p_go;
+};
+
+static void iwl_mvm_is_dcm_with_go_iterator(void *_data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	struct iwl_is_dcm_with_go_iterator_data *data = _data;
+	struct iwl_mvm_vif *other_mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_vif *curr_mvmvif =
+		iwl_mvm_vif_from_mac80211(data->current_vif);
+
+	/* exclude the given vif */
+	if (vif == data->current_vif)
+		return;
+
+	if (vif->type == NL80211_IFTYPE_AP && vif->p2p &&
+	    other_mvmvif->phy_ctxt && curr_mvmvif->phy_ctxt &&
+	    other_mvmvif->phy_ctxt->id != curr_mvmvif->phy_ctxt->id)
+		data->is_dcm_with_p2p_go = true;
+}
+
 static enum
-iwl_mvm_scan_type _iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device,
+iwl_mvm_scan_type _iwl_mvm_get_scan_type(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif,
 					 enum iwl_mvm_traffic_load load,
 					 bool low_latency)
 {
@@ -253,9 +277,30 @@ iwl_mvm_scan_type _iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device,
 	if (!global_cnt)
 		return IWL_SCAN_TYPE_UNASSOC;
 
-	if ((load == IWL_MVM_TRAFFIC_HIGH || low_latency) && !p2p_device &&
-	    fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_FRAGMENTED_SCAN))
-		return IWL_SCAN_TYPE_FRAGMENTED;
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
+		if ((load == IWL_MVM_TRAFFIC_HIGH || low_latency) &&
+		    (!vif || vif->type != NL80211_IFTYPE_P2P_DEVICE))
+			return IWL_SCAN_TYPE_FRAGMENTED;
+
+		/* in case of DCM with GO where BSS DTIM interval < 220msec
+		 * set all scan requests as fast-balance scan
+		 * */
+		if (vif && vif->type == NL80211_IFTYPE_STATION &&
+		    vif->bss_conf.dtim_period < 220) {
+			struct iwl_is_dcm_with_go_iterator_data data = {
+				.current_vif = vif,
+				.is_dcm_with_p2p_go = false,
+			};
+
+			ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						IEEE80211_IFACE_ITER_NORMAL,
+						iwl_mvm_is_dcm_with_go_iterator,
+						&data);
+			if (data.is_dcm_with_p2p_go)
+				return IWL_SCAN_TYPE_FAST_BALANCE;
+		}
+	}
 
 	if (load >= IWL_MVM_TRAFFIC_MEDIUM || low_latency)
 		return IWL_SCAN_TYPE_MILD;
@@ -264,7 +309,8 @@ iwl_mvm_scan_type _iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device,
 }
 
 static enum
-iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device)
+iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif)
 {
 	enum iwl_mvm_traffic_load load;
 	bool low_latency;
@@ -272,12 +318,12 @@ iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device)
 	load = iwl_mvm_get_traffic_load(mvm);
 	low_latency = iwl_mvm_low_latency(mvm);
 
-	return _iwl_mvm_get_scan_type(mvm, p2p_device, load, low_latency);
+	return _iwl_mvm_get_scan_type(mvm, vif, load, low_latency);
 }
 
 static enum
 iwl_mvm_scan_type iwl_mvm_get_scan_type_band(struct iwl_mvm *mvm,
-					     bool p2p_device,
+					     struct ieee80211_vif *vif,
 					     enum nl80211_band band)
 {
 	enum iwl_mvm_traffic_load load;
@@ -286,7 +332,7 @@ iwl_mvm_scan_type iwl_mvm_get_scan_type_band(struct iwl_mvm *mvm,
 	load = iwl_mvm_get_traffic_load_band(mvm, band);
 	low_latency = iwl_mvm_low_latency_band(mvm, band);
 
-	return _iwl_mvm_get_scan_type(mvm, p2p_device, load, low_latency);
+	return _iwl_mvm_get_scan_type(mvm, vif, load, low_latency);
 }
 
 static int
@@ -1054,7 +1100,7 @@ static void iwl_mvm_fill_channels(struct iwl_mvm *mvm, u8 *channels)
 static void iwl_mvm_fill_scan_config_v1(struct iwl_mvm *mvm, void *config,
 					u32 flags, u8 channel_flags)
 {
-	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
+	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, NULL);
 	struct iwl_scan_config_v1 *cfg = config;
 
 	cfg->flags = cpu_to_le32(flags);
@@ -1087,9 +1133,9 @@ static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
 	if (iwl_mvm_is_cdb_supported(mvm)) {
 		enum iwl_mvm_scan_type lb_type, hb_type;
 
-		lb_type = iwl_mvm_get_scan_type_band(mvm, false,
+		lb_type = iwl_mvm_get_scan_type_band(mvm, NULL,
 						     NL80211_BAND_2GHZ);
-		hb_type = iwl_mvm_get_scan_type_band(mvm, false,
+		hb_type = iwl_mvm_get_scan_type_band(mvm, NULL,
 						     NL80211_BAND_5GHZ);
 
 		cfg->out_of_channel_time[SCAN_LB_LMAC_IDX] =
@@ -1103,7 +1149,7 @@ static void iwl_mvm_fill_scan_config(struct iwl_mvm *mvm, void *config,
 			cpu_to_le32(scan_timing[hb_type].suspend_time);
 	} else {
 		enum iwl_mvm_scan_type type =
-			iwl_mvm_get_scan_type(mvm, false);
+			iwl_mvm_get_scan_type(mvm, NULL);
 
 		cfg->out_of_channel_time[SCAN_LB_LMAC_IDX] =
 			cpu_to_le32(scan_timing[type].max_out_time);
@@ -1140,14 +1186,14 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 		return -ENOBUFS;
 
 	if (iwl_mvm_is_cdb_supported(mvm)) {
-		type = iwl_mvm_get_scan_type_band(mvm, false,
+		type = iwl_mvm_get_scan_type_band(mvm, NULL,
 						  NL80211_BAND_2GHZ);
-		hb_type = iwl_mvm_get_scan_type_band(mvm, false,
+		hb_type = iwl_mvm_get_scan_type_band(mvm, NULL,
 						     NL80211_BAND_5GHZ);
 		if (type == mvm->scan_type && hb_type == mvm->hb_scan_type)
 			return 0;
 	} else {
-		type = iwl_mvm_get_scan_type(mvm, false);
+		type = iwl_mvm_get_scan_type(mvm, NULL);
 		if (type == mvm->scan_type)
 			return 0;
 	}
@@ -1599,19 +1645,20 @@ void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 
 static void iwl_mvm_fill_scan_type(struct iwl_mvm *mvm,
 				   struct iwl_mvm_scan_params *params,
-				   bool p2p)
+				   struct ieee80211_vif *vif)
 {
 	if (iwl_mvm_is_cdb_supported(mvm)) {
 		params->type =
-			iwl_mvm_get_scan_type_band(mvm, p2p,
+			iwl_mvm_get_scan_type_band(mvm, vif,
 						   NL80211_BAND_2GHZ);
 		params->hb_type =
-			iwl_mvm_get_scan_type_band(mvm, p2p,
+			iwl_mvm_get_scan_type_band(mvm, vif,
 						   NL80211_BAND_5GHZ);
 	} else {
-		params->type = iwl_mvm_get_scan_type(mvm, p2p);
+		params->type = iwl_mvm_get_scan_type(mvm, vif);
 	}
 }
+
 int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct cfg80211_scan_request *req,
 			   struct ieee80211_scan_ies *ies)
@@ -1659,8 +1706,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.scan_plans = &scan_plan;
 	params.n_scan_plans = 1;
 
-	iwl_mvm_fill_scan_type(mvm, &params,
-			       vif->type == NL80211_IFTYPE_P2P_DEVICE);
+	iwl_mvm_fill_scan_type(mvm, &params, vif);
 
 	ret = iwl_mvm_get_measurement_dwell(mvm, req, &params);
 	if (ret < 0)
@@ -1755,8 +1801,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.n_scan_plans = req->n_scan_plans;
 	params.scan_plans = req->scan_plans;
 
-	iwl_mvm_fill_scan_type(mvm, &params,
-			       vif->type == NL80211_IFTYPE_P2P_DEVICE);
+	iwl_mvm_fill_scan_type(mvm, &params, vif);
 
 	/* In theory, LMAC scans can handle a 32-bit delay, but since
 	 * waiting for over 18 hours to start the scan is a bit silly
-- 
2.19.0

