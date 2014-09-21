Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60527 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaIUTWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:31 -0400
Received: by mail-wi0-f178.google.com with SMTP id z2so1832300wiv.17
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:30 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/17] iwlwifi: mvm: Set RRM_ENABLED bit in scan commands
Date: Sun, 21 Sep 2014 22:22:05 +0300
Message-Id: <1411327338-23099-4-git-send-email-egrumbach@gmail.com> (sfid-20140921_212236_935901_ECEFBC6D)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Set RRM_ENABLED (bit 6) flag in scan commands. When this flag is set
the fw will add WFA vendor-specific TPC report and DS parameter set
IEs into probe requests.
This bit is set for SCAN_OFFLOAD_REQUEST_CMD(0x51).

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Assaf Krauss <assaf.krauss@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |  6 ++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  3 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  9 +++++++++
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 15 +++++++++++++--
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 081a93d..e337546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -148,11 +148,17 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
  *	action frame
+ * @IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT: supports adding DS params
+ *	element in probe requests.
+ * @IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT: supports adding TPC Report IE in
+ *	probe requests.
  * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
  */
 enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
 	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
+	IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT	= BIT(9),
+	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	= BIT(10),
 	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 8f22166..1354c68 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -670,6 +670,8 @@ struct iwl_scan_channel_opt {
  * @IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE: send iteration complete notification
  * @IWL_MVM_LMAC_SCAN_FLAG_MULTIPLE_SSIDS multiple SSID matching
  * @IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED: all passive scans will be fragmented
+ * @IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED: insert WFA vendor-specific TPC report
+ *	and DS parameter set IEs into probe requests.
  */
 enum iwl_mvm_lmac_scan_flags {
 	IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL		= BIT(0),
@@ -678,6 +680,7 @@ enum iwl_mvm_lmac_scan_flags {
 	IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE	= BIT(3),
 	IWL_MVM_LMAC_SCAN_FLAG_MULTIPLE_SSIDS	= BIT(4),
 	IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED	= BIT(5),
+	IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED	= BIT(6),
 };
 
 enum iwl_scan_priority {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5a169ab..bd12f8e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -419,6 +419,15 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT)
 		hw->wiphy->features |= NL80211_FEATURE_QUIET;
 
+	if (mvm->fw->ucode_capa.capa[0] &
+	    IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT)
+		hw->wiphy->features |=
+			NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES;
+
+	if (mvm->fw->ucode_capa.capa[0] &
+	    IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT)
+		hw->wiphy->features |= NL80211_FEATURE_WFA_TPC_IE_IN_PROBES;
+
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 	/* currently FW API supports only one optional cipher scheme */
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 09545f2..076fe1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -339,6 +339,13 @@ not_bound:
 	}
 }
 
+static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
+{
+	/* require rrm scan whenever the fw supports it */
+	return mvm->fw->ucode_capa.capa[0] &
+	       IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT;
+}
+
 int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 			 struct ieee80211_vif *vif,
 			 struct cfg80211_scan_request *req)
@@ -1153,6 +1160,10 @@ iwl_mvm_build_generic_unified_scan_cmd(struct iwl_mvm *mvm,
 				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
 	}
+
+	if (iwl_mvm_rrm_scan_needed(mvm))
+		cmd->scan_flags |=
+			cpu_to_le32(IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED);
 }
 
 int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
@@ -1208,7 +1219,7 @@ int iwl_mvm_unified_scan_lmac(struct iwl_mvm *mvm,
 	if (req->req.n_ssids == 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
 
-	cmd->scan_flags = cpu_to_le32(flags);
+	cmd->scan_flags |= cpu_to_le32(flags);
 
 	cmd->flags = iwl_mvm_scan_rxon_flags(req->req.channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
@@ -1305,7 +1316,7 @@ int iwl_mvm_unified_sched_scan_lmac(struct iwl_mvm *mvm,
 	if (req->n_ssids == 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
 
-	cmd->scan_flags = cpu_to_le32(flags);
+	cmd->scan_flags |= cpu_to_le32(flags);
 
 	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
-- 
1.9.1

