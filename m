Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbbECTcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/42] iwlwifi: mvm: rename unified_scan symbols to just scan
Date: Sun,  3 May 2015 22:31:21 +0300
Message-Id: <1430681513-7838-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213425_218786_6D0D1835)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

All scans are using the unified APIs now, so using "unified" in the
symbols is useless and just make them much longer and the main
difference between scans now is LMAC vs. UMAC.  Remove "unified" from
all relevant symbols.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c          |   6 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |   6 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  20 ++---
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 107 ++++++++++++-------------
 5 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 1b1b2bf..e82a47b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -981,7 +981,7 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_scan_offload_start(mvm, vif, nd_config, &mvm->nd_ies);
+	ret = iwl_mvm_sched_scan_start(mvm, vif, nd_config, &mvm->nd_ies);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 69daa4e..d74615f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -464,7 +464,7 @@ enum iwl_scan_priority {
 };
 
 /**
- * iwl_scan_req_unified_lmac - SCAN_REQUEST_CMD_API_S_VER_1
+ * iwl_scan_req_lmac - SCAN_REQUEST_CMD_API_S_VER_1
  * @reserved1: for alignment and future use
  * @channel_num: num of channels to scan
  * @active-dwell: dwell time for active channels
@@ -487,7 +487,7 @@ enum iwl_scan_priority {
  * @channel_opt: channel optimization options, for full and partial scan
  * @data: channel configuration and probe request packet.
  */
-struct iwl_scan_req_unified_lmac {
+struct iwl_scan_req_lmac {
 	/* SCAN_REQUEST_FIXED_PART_API_S_VER_7 */
 	__le32 reserved1;
 	u8 n_channels;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a5fe070..6350ca2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2450,7 +2450,7 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
 		ret = iwl_mvm_scan_umac(mvm, vif, hw_req);
 	else
-		ret = iwl_mvm_unified_scan_lmac(mvm, vif, hw_req);
+		ret = iwl_mvm_scan_lmac(mvm, vif, hw_req);
 
 	if (ret)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
@@ -2813,9 +2813,7 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_scan_offload_start(mvm, vif, req, ies);
-	if (ret)
-		mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
+	ret = iwl_mvm_sched_scan_start(mvm, vif, req, ies);
 
 out:
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index cb99eb7..be1d277 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1173,23 +1173,19 @@ int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 						struct iwl_device_cmd *cmd);
 int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req);
-int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
-			       struct ieee80211_vif *vif,
-			       struct cfg80211_sched_scan_request *req,
-			       struct ieee80211_scan_ies *ies);
+int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
+			     struct ieee80211_vif *vif,
+			     struct cfg80211_sched_scan_request *req,
+			     struct ieee80211_scan_ies *ies);
 int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify);
 int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd);
 
-/* Unified scan */
-int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_scan_request *req);
-int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif,
-				    struct cfg80211_sched_scan_request *req,
-				    struct ieee80211_scan_ies *ies);
+/* LMAC scan */
+int iwl_mvm_scan_lmac(struct iwl_mvm *mvm,
+		      struct ieee80211_vif *vif,
+		      struct ieee80211_scan_request *req);
 
 /* UMAC scan */
 int iwl_mvm_config_scan(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 3721b16..62efc75 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -553,29 +553,6 @@ static bool iwl_mvm_scan_pass_all(struct iwl_mvm *mvm,
 	return true;
 }
 
-int iwl_mvm_scan_offload_start(struct iwl_mvm *mvm,
-			       struct ieee80211_vif *vif,
-			       struct cfg80211_sched_scan_request *req,
-			       struct ieee80211_scan_ies *ies)
-{
-	int ret;
-
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
-		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
-		if (ret)
-			return ret;
-		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
-	} else {
-		mvm->scan_status |= IWL_MVM_SCAN_SCHED;
-		ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
-		if (ret)
-			return ret;
-		ret = iwl_mvm_unified_sched_scan_lmac(mvm, vif, req, ies);
-	}
-
-	return ret;
-}
-
 static int iwl_mvm_send_scan_offload_abort(struct iwl_mvm *mvm)
 {
 	int ret;
@@ -676,9 +653,9 @@ out:
 	return ret;
 }
 
-static void iwl_mvm_unified_scan_fill_tx_cmd(struct iwl_mvm *mvm,
-					     struct iwl_scan_req_tx_cmd *tx_cmd,
-					     bool no_cck)
+static void iwl_mvm_scan_fill_tx_cmd(struct iwl_mvm *mvm,
+				     struct iwl_scan_req_tx_cmd *tx_cmd,
+				     bool no_cck)
 {
 	tx_cmd[0].tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
 					 TX_CMD_FLG_BT_DIS);
@@ -699,7 +676,7 @@ static void
 iwl_mvm_lmac_scan_cfg_channels(struct iwl_mvm *mvm,
 			       struct ieee80211_channel **channels,
 			       int n_channels, u32 ssid_bitmap,
-			       struct iwl_scan_req_unified_lmac *cmd)
+			       struct iwl_scan_req_lmac *cmd)
 {
 	struct iwl_scan_channel_cfg_lmac *channel_cfg = (void *)&cmd->data;
 	int i;
@@ -752,10 +729,10 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 }
 
 static void
-iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				 struct ieee80211_scan_ies *ies,
-				 struct iwl_scan_probe_req *preq,
-				 const u8 *mac_addr, const u8 *mac_addr_mask)
+iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			 struct ieee80211_scan_ies *ies,
+			 struct iwl_scan_probe_req *preq,
+			 const u8 *mac_addr, const u8 *mac_addr_mask)
 {
 	struct ieee80211_mgmt *frame = (struct ieee80211_mgmt *)preq->buf;
 	u8 *pos, *newpos;
@@ -804,9 +781,9 @@ iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 }
 
 static void
-iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
-				       struct iwl_scan_req_unified_lmac *cmd,
-				       struct iwl_mvm_scan_params *params)
+iwl_mvm_build_generic_scan_cmd(struct iwl_mvm *mvm,
+			       struct iwl_scan_req_lmac *cmd,
+			       struct iwl_mvm_scan_params *params)
 {
 	memset(cmd, 0, ksize(cmd));
 	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
@@ -825,20 +802,20 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED);
 }
 
-int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_scan_request *req)
+int iwl_mvm_scan_lmac(struct iwl_mvm *mvm,
+		      struct ieee80211_vif *vif,
+		      struct ieee80211_scan_request *req)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = SCAN_OFFLOAD_REQUEST_CMD,
-		.len = { sizeof(struct iwl_scan_req_unified_lmac) +
+		.len = { sizeof(struct iwl_scan_req_lmac) +
 			 sizeof(struct iwl_scan_channel_cfg_lmac) *
 				mvm->fw->ucode_capa.n_scan_channels +
 			 sizeof(struct iwl_scan_probe_req), },
 		.data = { mvm->scan_cmd, },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
-	struct iwl_scan_req_unified_lmac *cmd = mvm->scan_cmd;
+	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq;
 	struct iwl_mvm_scan_params params = {};
 	u32 flags;
@@ -863,7 +840,7 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	iwl_mvm_scan_calc_params(mvm, vif, req->req.n_ssids, req->req.flags,
 				 &params);
 
-	iwl_mvm_build_generic_unified_scan_cmd(mvm, cmd, &params);
+	iwl_mvm_build_generic_scan_cmd(mvm, cmd, &params);
 
 	cmd->n_channels = (u8)req->req.n_channels;
 
@@ -883,7 +860,7 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	cmd->flags = iwl_mvm_scan_rxon_flags(req->req.channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
-	iwl_mvm_unified_scan_fill_tx_cmd(mvm, cmd->tx_cmd, req->req.no_cck);
+	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, req->req.no_cck);
 	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->req.ssids,
 				req->req.n_ssids, 0);
 
@@ -920,7 +897,7 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, preq,
+	iwl_mvm_build_scan_probe(mvm, vif, &req->ies, preq,
 		req->req.flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
 			req->req.mac_addr : NULL,
 		req->req.mac_addr_mask);
@@ -941,21 +918,21 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif,
-				    struct cfg80211_sched_scan_request *req,
-				    struct ieee80211_scan_ies *ies)
+static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif,
+				   struct cfg80211_sched_scan_request *req,
+				   struct ieee80211_scan_ies *ies)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = SCAN_OFFLOAD_REQUEST_CMD,
-		.len = { sizeof(struct iwl_scan_req_unified_lmac) +
+		.len = { sizeof(struct iwl_scan_req_lmac) +
 			 sizeof(struct iwl_scan_channel_cfg_lmac) *
 				mvm->fw->ucode_capa.n_scan_channels +
 			 sizeof(struct iwl_scan_probe_req), },
 		.data = { mvm->scan_cmd, },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
-	struct iwl_scan_req_unified_lmac *cmd = mvm->scan_cmd;
+	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq;
 	struct iwl_mvm_scan_params params = {};
 	int ret;
@@ -976,7 +953,7 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 
 	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
 
-	iwl_mvm_build_generic_unified_scan_cmd(mvm, cmd, &params);
+	iwl_mvm_build_generic_scan_cmd(mvm, cmd, &params);
 
 	cmd->n_channels = (u8)req->n_channels;
 
@@ -1006,7 +983,7 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
-	iwl_mvm_unified_scan_fill_tx_cmd(mvm, cmd->tx_cmd, false);
+	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, false);
 	iwl_scan_offload_build_ssid(req, cmd->direct_scan, &ssid_bitmap, false);
 
 	cmd->schedule[0].delay = cpu_to_le16(req->interval / MSEC_PER_SEC);
@@ -1039,7 +1016,7 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, preq,
+	iwl_mvm_build_scan_probe(mvm, vif, ies, preq,
 		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
 			req->mac_addr : NULL,
 		req->mac_addr_mask);
@@ -1388,7 +1365,7 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	sec_part->schedule[0].iter_count = 1;
 	sec_part->delay = 0;
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, &req->ies, &sec_part->preq,
+	iwl_mvm_build_scan_probe(mvm, vif, &req->ies, &sec_part->preq,
 		req->req.flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
 			req->req.mac_addr : NULL,
 		req->req.mac_addr_mask);
@@ -1502,7 +1479,7 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		sec_part->delay = cpu_to_le16(req->delay);
 	}
 
-	iwl_mvm_build_unified_scan_probe(mvm, vif, ies, &sec_part->preq,
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &sec_part->preq,
 		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
 			req->mac_addr : NULL,
 		req->mac_addr_mask);
@@ -1522,6 +1499,28 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return ret;
 }
 
+int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
+			     struct ieee80211_vif *vif,
+			     struct cfg80211_sched_scan_request *req,
+			     struct ieee80211_scan_ies *ies)
+{
+	int ret;
+
+	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
+	if (ret)
+		return ret;
+
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
+	} else {
+		ret = iwl_mvm_sched_scan_lmac(mvm, vif, req, ies);
+		if (!ret)
+			mvm->scan_status |= IWL_MVM_SCAN_SCHED;
+	}
+
+	return ret;
+}
+
 int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 					struct iwl_rx_cmd_buffer *rxb,
 					struct iwl_device_cmd *cmd)
@@ -1672,7 +1671,7 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 				mvm->fw->ucode_capa.n_scan_channels +
 			sizeof(struct iwl_scan_req_umac_tail);
 
-	return sizeof(struct iwl_scan_req_unified_lmac) +
+	return sizeof(struct iwl_scan_req_lmac) +
 		sizeof(struct iwl_scan_channel_cfg_lmac) *
 		mvm->fw->ucode_capa.n_scan_channels +
 		sizeof(struct iwl_scan_probe_req);
-- 
2.1.0

