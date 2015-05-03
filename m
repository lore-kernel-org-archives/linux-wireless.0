Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbbECTc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/42] iwlwifi: mvm: combine LMAC and UMAC preq generation
Date: Sun,  3 May 2015 22:31:39 +0300
Message-Id: <1430681513-7838-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213313_995667_557AB352)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The probe request to be added to both LMAC and UMAC scan commands are
identical, so move the generation out of the LMAC/UMAC-specific code.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 81 ++++++++++++++-------------------
 1 file changed, 35 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index e8ec6e2..acff2e7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -91,6 +91,7 @@ struct iwl_mvm_scan_params {
 	bool no_cck;
 	bool pass_all;
 	int n_match_sets;
+	struct iwl_scan_probe_req preq;
 	struct cfg80211_match_set *match_sets;
 	struct _dwell {
 		u16 passive;
@@ -725,11 +726,12 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 static void
 iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			 struct ieee80211_scan_ies *ies,
-			 struct iwl_scan_probe_req *preq,
-			 const u8 *mac_addr, const u8 *mac_addr_mask)
+			 struct iwl_mvm_scan_params *params)
 {
-	struct ieee80211_mgmt *frame = (struct ieee80211_mgmt *)preq->buf;
+	struct ieee80211_mgmt *frame = (void *)params->preq.buf;
 	u8 *pos, *newpos;
+	const u8 *mac_addr = params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+		params->mac_addr : NULL;
 
 	/*
 	 * Unfortunately, right now the offload scan doesn't support randomising
@@ -738,7 +740,8 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 * random, only when it's restarted, but at least that helps a bit.
 	 */
 	if (mac_addr)
-		get_random_mask_addr(frame->sa, mac_addr, mac_addr_mask);
+		get_random_mask_addr(frame->sa, mac_addr,
+				     params->mac_addr_mask);
 	else
 		memcpy(frame->sa, vif->addr, ETH_ALEN);
 
@@ -751,27 +754,28 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = 0;
 
-	preq->mac_header.offset = 0;
-	preq->mac_header.len = cpu_to_le16(24 + 2);
+	params->preq.mac_header.offset = 0;
+	params->preq.mac_header.len = cpu_to_le16(24 + 2);
 
 	/* Insert ds parameter set element on 2.4 GHz band */
 	newpos = iwl_mvm_copy_and_insert_ds_elem(mvm,
 						 ies->ies[IEEE80211_BAND_2GHZ],
 						 ies->len[IEEE80211_BAND_2GHZ],
 						 pos);
-	preq->band_data[0].offset = cpu_to_le16(pos - preq->buf);
-	preq->band_data[0].len = cpu_to_le16(newpos - pos);
+	params->preq.band_data[0].offset = cpu_to_le16(pos - params->preq.buf);
+	params->preq.band_data[0].len = cpu_to_le16(newpos - pos);
 	pos = newpos;
 
 	memcpy(pos, ies->ies[IEEE80211_BAND_5GHZ],
 	       ies->len[IEEE80211_BAND_5GHZ]);
-	preq->band_data[1].offset = cpu_to_le16(pos - preq->buf);
-	preq->band_data[1].len = cpu_to_le16(ies->len[IEEE80211_BAND_5GHZ]);
+	params->preq.band_data[1].offset = cpu_to_le16(pos - params->preq.buf);
+	params->preq.band_data[1].len =
+		cpu_to_le16(ies->len[IEEE80211_BAND_5GHZ]);
 	pos += ies->len[IEEE80211_BAND_5GHZ];
 
 	memcpy(pos, ies->common_ies, ies->common_ie_len);
-	preq->common_data.offset = cpu_to_le16(pos - preq->buf);
-	preq->common_data.len = cpu_to_le16(ies->common_ie_len);
+	params->preq.common_data.offset = cpu_to_le16(pos - params->preq.buf);
+	params->preq.common_data.len = cpu_to_le16(ies->common_ie_len);
 }
 
 static void
@@ -809,11 +813,12 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 }
 
 static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct ieee80211_scan_ies *ies,
 			     struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
-	struct iwl_scan_probe_req *preq;
+	struct iwl_scan_probe_req *preq =
+		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
+			 mvm->fw->ucode_capa.n_scan_channels);
 	u32 flags = 0, ssid_bitmap = 0;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -881,24 +886,19 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_lmac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
-	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
-			mvm->fw->ucode_capa.n_scan_channels);
-
-	iwl_mvm_build_scan_probe(mvm, vif, ies, preq,
-		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			params->mac_addr : NULL,
-		params->mac_addr_mask);
+	*preq = params->preq;
 
 	return 0;
 }
 
 static int
 iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			struct ieee80211_scan_ies *ies,
-			struct iwl_mvm_scan_params *params)
+				   struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
-	struct iwl_scan_probe_req *preq;
+	struct iwl_scan_probe_req *preq =
+		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
+			 mvm->fw->ucode_capa.n_scan_channels);
 	u32 flags = 0, ssid_bitmap = 0;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -967,13 +967,7 @@ iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_lmac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
-	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
-			mvm->fw->ucode_capa.n_scan_channels);
-
-	iwl_mvm_build_scan_probe(mvm, vif, ies, preq,
-		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			params->mac_addr : NULL,
-		params->mac_addr_mask);
+	*preq = params->preq;
 
 	return 0;
 }
@@ -1234,7 +1228,6 @@ static u32 iwl_mvm_scan_umac_common_flags(struct iwl_mvm *mvm, int n_ssids,
 }
 
 static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct ieee80211_scan_ies *ies,
 			     struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
@@ -1285,18 +1278,13 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	sec_part->schedule[0].iter_count = 1;
 	sec_part->delay = 0;
-
-	iwl_mvm_build_scan_probe(mvm, vif, ies, &sec_part->preq,
-		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			params->mac_addr : NULL,
-		params->mac_addr_mask);
+	sec_part->preq = params->preq;
 
 	return 0;
 }
 
 static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
-				   struct ieee80211_scan_ies *ies,
 				   struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
@@ -1361,10 +1349,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 		sec_part->delay = cpu_to_le16(params->delay);
 	}
 
-	iwl_mvm_build_scan_probe(mvm, vif, ies, &sec_part->preq,
-		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			params->mac_addr : NULL,
-		params->mac_addr_mask);
+	sec_part->preq = params->preq;
 
 	return 0;
 }
@@ -1464,12 +1449,14 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
 
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
+
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_scan_umac(mvm, vif, ies, &params);
+		ret = iwl_mvm_scan_umac(mvm, vif, &params);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
-		ret = iwl_mvm_scan_lmac(mvm, vif, ies, &params);
+		ret = iwl_mvm_scan_lmac(mvm, vif, &params);
 	}
 
 	if (ret)
@@ -1552,12 +1539,14 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
+
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_sched_scan_umac(mvm, vif, ies, &params);
+		ret = iwl_mvm_sched_scan_umac(mvm, vif, &params);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
-		ret = iwl_mvm_sched_scan_lmac(mvm, vif, ies, &params);
+		ret = iwl_mvm_sched_scan_lmac(mvm, vif, &params);
 	}
 
 	if (ret)
-- 
2.1.0

