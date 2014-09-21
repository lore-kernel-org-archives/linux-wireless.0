Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:58891 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIUTWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:53 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so53408wes.26
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:52 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/17] iwlwifi: mvm: Refactor and fix max probe len computation
Date: Sun, 21 Sep 2014 22:22:18 +0300
Message-Id: <1411327338-23099-17-git-send-email-egrumbach@gmail.com> (sfid-20140921_212259_160811_AC343F7F)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Move iwl_mvm_max_scan_ie_len function to scan.c and fix the
implementation to conform with the LMAC scan API.
Since the correct implementation would leave us with unacceptably
tiny probes, add a workaround which returns a larger value.
In current implementation it's possible that unified_scan_lmac and
unified_sched_scan_lmac would return -ENOBUFS.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 10 +----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 64 ++++++++++++++++++++++++-----
 3 files changed, 55 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 412a8a0..c7a73c6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -279,14 +279,6 @@ static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 	}
 }
 
-static int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm)
-{
-	/* we create the 802.11 header and SSID element */
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID)
-		return mvm->fw->ucode_capa.max_probe_length - 24 - 2;
-	return mvm->fw->ucode_capa.max_probe_length - 24 - 34;
-}
-
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 {
 	struct ieee80211_hw *hw = mvm->hw;
@@ -379,7 +371,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	iwl_mvm_reset_phy_ctxts(mvm);
 
-	hw->wiphy->max_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm);
+	hw->wiphy->max_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm, false);
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7d0194b..b153ced 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -935,6 +935,7 @@ int iwl_mvm_rx_scan_response(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 int iwl_mvm_rx_scan_complete(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			     struct iwl_device_cmd *cmd);
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm);
+int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan);
 
 /* Scheduled scan */
 int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 076fe1b..cb85e63 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -346,6 +346,48 @@ static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
 	       IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT;
 }
 
+static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm,
+					   bool is_sched_scan)
+{
+	int max_probe_len;
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN)
+		max_probe_len = SCAN_OFFLOAD_PROBE_REQ_SIZE;
+	else
+		max_probe_len = mvm->fw->ucode_capa.max_probe_length;
+
+	/* we create the 802.11 header and SSID element */
+	max_probe_len -= 24 + 2;
+
+	/* basic ssid is added only for hw_scan with and old api */
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID) &&
+	    !(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN) &&
+	    !is_sched_scan)
+		max_probe_len -= 32;
+
+	return max_probe_len;
+}
+
+int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm, bool is_sched_scan)
+{
+	int max_ie_len = iwl_mvm_max_scan_ie_fw_cmd_room(mvm, is_sched_scan);
+
+	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN))
+		return max_ie_len;
+
+	/* TODO: [BUG] This function should return the maximum allowed size of
+	 * scan IEs, however the LMAC scan api contains both 2GHZ and 5GHZ IEs
+	 * in the same command. So the correct implementation of this function
+	 * is just iwl_mvm_max_scan_ie_fw_cmd_room() / 2. Currently the scan
+	 * command has only 512 bytes and it would leave us with about 240
+	 * bytes for scan IEs, which is clearly not enough. So meanwhile
+	 * we will report an incorrect value. This may result in a failure to
+	 * issue a scan in unified_scan_lmac and unified_sched_scan_lmac
+	 * functions with -ENOBUFS, if a large enough probe will be provided.
+	 */
+	return max_ie_len;
+}
+
 int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 			 struct ieee80211_vif *vif,
 			 struct cfg80211_scan_request *req)
@@ -1191,13 +1233,12 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (WARN_ON_ONCE(req->req.n_ssids > PROBE_OPTION_MAX ||
-			 req->ies.common_ie_len + req->ies.len[0] +
-				req->ies.len[1] + 24 + 2 >
-					SCAN_OFFLOAD_PROBE_REQ_SIZE ||
-			 req->req.n_channels >
-				mvm->fw->ucode_capa.n_scan_channels))
-		return -1;
+	if (req->req.n_ssids > PROBE_OPTION_MAX ||
+	    req->ies.common_ie_len + req->ies.len[NL80211_BAND_2GHZ] +
+	    req->ies.len[NL80211_BAND_5GHZ] >
+		iwl_mvm_max_scan_ie_fw_cmd_room(mvm, false) ||
+	    req->req.n_channels > mvm->fw->ucode_capa.n_scan_channels)
+		return -ENOBUFS;
 
 	mvm->scan_status = IWL_MVM_SCAN_OS;
 
@@ -1285,10 +1326,11 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	if (WARN_ON(mvm->scan_cmd == NULL))
 		return -ENOMEM;
 
-	if (WARN_ON_ONCE(req->n_ssids > PROBE_OPTION_MAX ||
-			 ies->common_ie_len + ies->len[0] + ies->len[1] + 24 + 2
-				> SCAN_OFFLOAD_PROBE_REQ_SIZE ||
-			 req->n_channels > mvm->fw->ucode_capa.n_scan_channels))
+	if (req->n_ssids > PROBE_OPTION_MAX ||
+	    ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
+	    ies->len[NL80211_BAND_5GHZ] >
+		iwl_mvm_max_scan_ie_fw_cmd_room(mvm, true) ||
+	    req->n_channels > mvm->fw->ucode_capa.n_scan_channels)
 		return -ENOBUFS;
 
 	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
-- 
1.9.1

