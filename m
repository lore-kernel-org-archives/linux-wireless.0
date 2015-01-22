Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbbAVUd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/38] iwlwifi: mvm: scan dwell time corrections
Date: Thu, 22 Jan 2015 22:33:03 +0200
Message-Id: <1421958809-3371-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213405_867263_22ABCA0A)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Use only basic dwell time (10 ms for active scan and 110 for passive),
regardless of the number of the probes and the band, if it is
supported by the FW. The FW will add 3 ms for each probe sent and 10
ms for low band channels.
Add a TLV flag to indicate such support in FW.

This fix is needed to fix few bugs regarding scans that take too much time.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/scan.c    | 17 ++++++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 731f1db..c4266b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -241,6 +241,9 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF: ucode supports disabling dummy notif.
  * @IWL_UCODE_TLV_API_FRAGMENTED_SCAN: This ucode supports active dwell time
  *	longer than the passive one, which is essential for fragmented scan.
+ * @IWL_UCODE_TLV_API_BASIC_DWELL: use only basic dwell time in scan command,
+ *	regardless of the band or the number of the probes. FW will calculate
+ *	the actual dwell time.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -248,6 +251,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_LMAC_SCAN		= BIT(6),
 	IWL_UCODE_TLV_API_SF_NO_DUMMY_NOTIF	= BIT(7),
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= BIT(8),
+	IWL_UCODE_TLV_API_BASIC_DWELL		= BIT(13),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 0ee0f81..33e4284 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -173,15 +173,21 @@ static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
  * already included in the probe template, so we need to set only
  * req->n_ssids - 1 bits in addition to the first bit.
  */
-static u16 iwl_mvm_get_active_dwell(enum ieee80211_band band, int n_ssids)
+static u16 iwl_mvm_get_active_dwell(struct iwl_mvm *mvm,
+				    enum ieee80211_band band, int n_ssids)
 {
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BASIC_DWELL)
+		return 10;
 	if (band == IEEE80211_BAND_2GHZ)
 		return 20  + 3 * (n_ssids + 1);
 	return 10  + 2 * (n_ssids + 1);
 }
 
-static u16 iwl_mvm_get_passive_dwell(enum ieee80211_band band)
+static u16 iwl_mvm_get_passive_dwell(struct iwl_mvm *mvm,
+				     enum ieee80211_band band)
 {
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BASIC_DWELL)
+			return 110;
 	return band == IEEE80211_BAND_2GHZ ? 100 + 20 : 100 + 10;
 }
 
@@ -337,7 +343,8 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		 */
 		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			u32 passive_dwell =
-				iwl_mvm_get_passive_dwell(IEEE80211_BAND_2GHZ);
+				iwl_mvm_get_passive_dwell(mvm,
+							  IEEE80211_BAND_2GHZ);
 			params->max_out_time = passive_dwell;
 		} else {
 			params->passive_fragmented = true;
@@ -354,8 +361,8 @@ not_bound:
 			params->dwell[band].passive = frag_passive_dwell;
 		else
 			params->dwell[band].passive =
-				iwl_mvm_get_passive_dwell(band);
-		params->dwell[band].active = iwl_mvm_get_active_dwell(band,
+				iwl_mvm_get_passive_dwell(mvm, band);
+		params->dwell[band].active = iwl_mvm_get_active_dwell(mvm, band,
 								      n_ssids);
 	}
 }
-- 
1.9.1

