Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbbECTcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/42] iwlwifi: mvm: move scan code from mac80211.c to scan.c
Date: Sun,  3 May 2015 22:31:22 +0300
Message-Id: <1430681513-7838-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_929518_3B8CBFCD)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Move all the scan code that was in mac80211.c to scan.c where it
belongs, leaving only the parts that are specific to mac80211 ops.

Change some function definitions slightly to improve consistency.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  80 +------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  13 +--
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 173 ++++++++++++++++++++--------
 3 files changed, 136 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6350ca2..ff3273a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -80,7 +80,6 @@
 #include "sta.h"
 #include "time-event.h"
 #include "iwl-eeprom-parse.h"
-#include "fw-api-scan.h"
 #include "iwl-phy-db.h"
 #include "testmode.h"
 #include "iwl-fw-error-dump.h"
@@ -2381,81 +2380,21 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	iwl_mvm_unref(mvm, IWL_MVM_REF_BSS_CHANGED);
 }
 
-static int iwl_mvm_num_scans(struct iwl_mvm *mvm)
-{
-	return hweight32(mvm->scan_status & IWL_MVM_SCAN_MASK);
-}
-
-static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
-{
-	/* This looks a bit arbitrary, but the idea is that if we run
-	 * out of possible simultaneous scans and the userspace is
-	 * trying to run a scan type that is already running, we
-	 * return -EBUSY.  But if the userspace wants to start a
-	 * different type of scan, we stop the opposite type to make
-	 * space for the new request.  The reason is backwards
-	 * compatibility with old wpa_supplicant that wouldn't stop a
-	 * scheduled scan before starting a normal scan.
-	 */
-
-	if (iwl_mvm_num_scans(mvm) < mvm->max_scans)
-		return 0;
-
-	/* Use a switch, even though this is a bitmask, so that more
-	 * than one bits set will fall in default and we will warn.
-	 */
-	switch (type) {
-	case IWL_MVM_SCAN_REGULAR:
-		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR_MASK)
-			return -EBUSY;
-		return iwl_mvm_scan_offload_stop(mvm, true);
-	case IWL_MVM_SCAN_SCHED:
-		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
-			return -EBUSY;
-		return iwl_mvm_cancel_scan(mvm);
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	return -EIO;
-}
-
 static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_scan_request *hw_req)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct cfg80211_scan_request *req = &hw_req->req;
 	int ret;
 
-	if (req->n_channels == 0 ||
-	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
+	if (hw_req->req.n_channels == 0 ||
+	    hw_req->req.n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -EINVAL;
 
 	mutex_lock(&mvm->mutex);
-
-	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
-		IWL_ERR(mvm, "scan while LAR regdomain is not set\n");
-		ret = -EBUSY;
-		goto out;
-	}
-
-	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_REGULAR);
-	if (ret)
-		goto out;
-
-	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
-
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		ret = iwl_mvm_scan_umac(mvm, vif, hw_req);
-	else
-		ret = iwl_mvm_scan_lmac(mvm, vif, hw_req);
-
-	if (ret)
-		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-out:
+	ret = iwl_mvm_reg_scan_start(mvm, vif, &hw_req->req, &hw_req->ies);
 	mutex_unlock(&mvm->mutex);
+
 	return ret;
 }
 
@@ -2794,25 +2733,16 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 					struct ieee80211_scan_ies *ies)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
 	int ret;
 
 	mutex_lock(&mvm->mutex);
 
-	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
-		IWL_ERR(mvm, "sched-scan while LAR regdomain is not set\n");
-		ret = -EBUSY;
-		goto out;
-	}
-
 	if (!vif->bss_conf.idle) {
 		ret = -EBUSY;
 		goto out;
 	}
 
-	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_SCHED);
-	if (ret)
-		goto out;
-
 	ret = iwl_mvm_sched_scan_start(mvm, vif, req, ies);
 
 out:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index be1d277..bbe4d98 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1159,6 +1159,9 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, bool force_upload,
 			  struct ieee80211_vif *disabled_vif);
 
 /* Scanning */
+int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			   struct cfg80211_scan_request *req,
+			   struct ieee80211_scan_ies *ies);
 int iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan);
@@ -1182,18 +1185,8 @@ int iwl_mvm_rx_scan_offload_results(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd);
 
-/* LMAC scan */
-int iwl_mvm_scan_lmac(struct iwl_mvm *mvm,
-		      struct ieee80211_vif *vif,
-		      struct ieee80211_scan_request *req);
-
 /* UMAC scan */
 int iwl_mvm_config_scan(struct iwl_mvm *mvm);
-int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-		      struct ieee80211_scan_request *req);
-int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			    struct cfg80211_sched_scan_request *req,
-			    struct ieee80211_scan_ies *ies);
 int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 					struct iwl_rx_cmd_buffer *rxb,
 					struct iwl_device_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 62efc75..3fe398e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -802,9 +802,9 @@ iwl_mvm_build_generic_scan_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED);
 }
 
-int iwl_mvm_scan_lmac(struct iwl_mvm *mvm,
-		      struct ieee80211_vif *vif,
-		      struct ieee80211_scan_request *req)
+static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     struct cfg80211_scan_request *req,
+			     struct ieee80211_scan_ies *ies)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = SCAN_OFFLOAD_REQUEST_CMD,
@@ -828,41 +828,41 @@ int iwl_mvm_scan_lmac(struct iwl_mvm *mvm,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (req->req.n_ssids > PROBE_OPTION_MAX ||
-	    req->ies.common_ie_len + req->ies.len[NL80211_BAND_2GHZ] +
-	    req->ies.len[NL80211_BAND_5GHZ] >
+	if (req->n_ssids > PROBE_OPTION_MAX ||
+	    ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
+	    ies->len[NL80211_BAND_5GHZ] >
 		iwl_mvm_max_scan_ie_fw_cmd_room(mvm, false) ||
-	    req->req.n_channels > mvm->fw->ucode_capa.n_scan_channels)
+	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -ENOBUFS;
 
 	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->req.n_ssids, req->req.flags,
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
 				 &params);
 
 	iwl_mvm_build_generic_scan_cmd(mvm, cmd, &params);
 
-	cmd->n_channels = (u8)req->req.n_channels;
+	cmd->n_channels = (u8)req->n_channels;
 
 	flags = IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
 
-	if (req->req.n_ssids == 1 && req->req.ssids[0].ssid_len != 0)
+	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
 	if (params.passive_fragmented)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
-	if (req->req.n_ssids == 0)
+	if (req->n_ssids == 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
 
 	cmd->scan_flags |= cpu_to_le32(flags);
 
-	cmd->flags = iwl_mvm_scan_rxon_flags(req->req.channels[0]->band);
+	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
-	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, req->req.no_cck);
-	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->req.ssids,
-				req->req.n_ssids, 0);
+	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, req->no_cck);
+	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->ssids,
+				req->n_ssids, 0);
 
 	cmd->schedule[0].delay = 0;
 	cmd->schedule[0].iterations = 1;
@@ -887,20 +887,20 @@ int iwl_mvm_scan_lmac(struct iwl_mvm *mvm,
 			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
 	}
 
-	for (i = 1; i <= req->req.n_ssids; i++)
+	for (i = 1; i <= req->n_ssids; i++)
 		ssid_bitmap |= BIT(i);
 
-	iwl_mvm_lmac_scan_cfg_channels(mvm, req->req.channels,
-				       req->req.n_channels, ssid_bitmap,
+	iwl_mvm_lmac_scan_cfg_channels(mvm, req->channels,
+				       req->n_channels, ssid_bitmap,
 				       cmd);
 
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
-	iwl_mvm_build_scan_probe(mvm, vif, &req->ies, preq,
-		req->req.flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			req->req.mac_addr : NULL,
-		req->req.mac_addr_mask);
+	iwl_mvm_build_scan_probe(mvm, vif, ies, preq,
+		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			req->mac_addr : NULL,
+		req->mac_addr_mask);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -1293,8 +1293,9 @@ static u32 iwl_mvm_scan_umac_common_flags(struct iwl_mvm *mvm, int n_ssids,
 	return flags;
 }
 
-int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-		      struct ieee80211_scan_request *req)
+static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     struct cfg80211_scan_request *req,
+			     struct ieee80211_scan_ies *ies)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = SCAN_REQ_UMAC,
@@ -1321,15 +1322,15 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (WARN_ON(req->req.n_ssids > PROBE_OPTION_MAX ||
-		    req->ies.common_ie_len +
-		    req->ies.len[NL80211_BAND_2GHZ] +
-		    req->ies.len[NL80211_BAND_5GHZ] + 24 + 2 >
-		    SCAN_OFFLOAD_PROBE_REQ_SIZE || req->req.n_channels >
+	if (WARN_ON(req->n_ssids > PROBE_OPTION_MAX ||
+		    ies->common_ie_len +
+		    ies->len[NL80211_BAND_2GHZ] +
+		    ies->len[NL80211_BAND_5GHZ] + 24 + 2 >
+		    SCAN_OFFLOAD_PROBE_REQ_SIZE || req->n_channels >
 		    mvm->fw->ucode_capa.n_scan_channels))
 		return -ENOBUFS;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->req.n_ssids, req->req.flags,
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
 				 &params);
 
 	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, &params);
@@ -1340,8 +1341,8 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
 
-	flags = iwl_mvm_scan_umac_common_flags(mvm, req->req.n_ssids,
-					       req->req.ssids,
+	flags = iwl_mvm_scan_umac_common_flags(mvm, req->n_ssids,
+					       req->ssids,
 					       params.passive_fragmented);
 
 	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
@@ -1354,24 +1355,24 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
-	cmd->n_channels = req->req.n_channels;
+	cmd->n_channels = req->n_channels;
 
-	for (i = 0; i < req->req.n_ssids; i++)
+	for (i = 0; i < req->n_ssids; i++)
 		ssid_bitmap |= BIT(i);
 
-	iwl_mvm_umac_scan_cfg_channels(mvm, req->req.channels,
-				       req->req.n_channels, ssid_bitmap, cmd);
+	iwl_mvm_umac_scan_cfg_channels(mvm, req->channels,
+				       req->n_channels, ssid_bitmap, cmd);
 
 	sec_part->schedule[0].iter_count = 1;
 	sec_part->delay = 0;
 
-	iwl_mvm_build_scan_probe(mvm, vif, &req->ies, &sec_part->preq,
-		req->req.flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			req->req.mac_addr : NULL,
-		req->req.mac_addr_mask);
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &sec_part->preq,
+		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			req->mac_addr : NULL,
+		req->mac_addr_mask);
 
-	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, req->req.ssids,
-				req->req.n_ssids, 0);
+	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, req->ssids,
+				req->n_ssids, 0);
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -1388,9 +1389,10 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return ret;
 }
 
-int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			    struct cfg80211_sched_scan_request *req,
-			    struct ieee80211_scan_ies *ies)
+static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif,
+				   struct cfg80211_sched_scan_request *req,
+				   struct ieee80211_scan_ies *ies)
 {
 
 	struct iwl_host_cmd hcmd = {
@@ -1499,6 +1501,76 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return ret;
 }
 
+static int iwl_mvm_num_scans(struct iwl_mvm *mvm)
+{
+	return hweight32(mvm->scan_status & IWL_MVM_SCAN_MASK);
+}
+
+static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
+{
+	/* This looks a bit arbitrary, but the idea is that if we run
+	 * out of possible simultaneous scans and the userspace is
+	 * trying to run a scan type that is already running, we
+	 * return -EBUSY.  But if the userspace wants to start a
+	 * different type of scan, we stop the opposite type to make
+	 * space for the new request.  The reason is backwards
+	 * compatibility with old wpa_supplicant that wouldn't stop a
+	 * scheduled scan before starting a normal scan.
+	 */
+
+	if (iwl_mvm_num_scans(mvm) < mvm->max_scans)
+		return 0;
+
+	/* Use a switch, even though this is a bitmask, so that more
+	 * than one bits set will fall in default and we will warn.
+	 */
+	switch (type) {
+	case IWL_MVM_SCAN_REGULAR:
+		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR_MASK)
+			return -EBUSY;
+		return iwl_mvm_scan_offload_stop(mvm, true);
+	case IWL_MVM_SCAN_SCHED:
+		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
+			return -EBUSY;
+		return iwl_mvm_cancel_scan(mvm);
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return -EIO;
+}
+
+int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			   struct cfg80211_scan_request *req,
+			   struct ieee80211_scan_ies *ies)
+{
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
+		IWL_ERR(mvm, "scan while LAR regdomain is not set\n");
+		return -EBUSY;
+	}
+
+	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_REGULAR);
+	if (ret)
+		return ret;
+
+	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
+
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_mvm_scan_umac(mvm, vif, req, ies);
+	else
+		ret = iwl_mvm_scan_lmac(mvm, vif, req, ies);
+
+	if (ret)
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+
+	return ret;
+}
+
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_sched_scan_request *req,
@@ -1506,6 +1578,17 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 {
 	int ret;
 
+	lockdep_assert_held(&mvm->mutex);
+
+	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
+		IWL_ERR(mvm, "sched-scan while LAR regdomain is not set\n");
+		return -EBUSY;
+	}
+
+	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_SCHED);
+	if (ret)
+		return ret;
+
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 	if (ret)
 		return ret;
-- 
2.1.0

