Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59439 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752086AbaKJJYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:24:18 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 10 Nov 2014 11:10:19 +0200
Message-Id: <1415610621-27438-15-git-send-email-luca@coelho.fi> (sfid-20141110_102422_845966_53F4DC04)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 14/16] iwlwifi: mvm: Insert DS Parameter Set placeholder in probes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Since it's too complicated for the fw to insert a DS Parameter Set
element in the middle of the frame, it was decided that it should be
done by the host. The fw will only parse the frame and update the
current channel field.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h   |  4 +--
 drivers/net/wireless/iwlwifi/mvm/scan.c | 53 +++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 4f6e668..e6e69ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -148,8 +148,8 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
  *	action frame
- * @IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT: supports adding DS params
- *	element in probe requests.
+ * @IWL_UCODE_TLV_CAPA_DS_PARAM_SET_IE_SUPPORT: supports updating current
+ *	channel in DS parameter set element in probe requests.
  * @IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT: supports adding TPC Report IE in
  *	probe requests.
  * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index cb85e63..094d3b0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -365,6 +365,10 @@ static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm,
 	    !is_sched_scan)
 		max_probe_len -= 32;
 
+	/* DS parameter set element is added on 2.4GHZ band if required */
+	if (iwl_mvm_rrm_scan_needed(mvm))
+		max_probe_len -= 3;
+
 	return max_probe_len;
 }
 
@@ -1133,6 +1137,42 @@ iwl_mvm_lmac_scan_cfg_channels(struct iwl_mvm *mvm,
 	}
 }
 
+static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
+					   size_t len, u8 *const pos)
+{
+	static const u8 before_ds_params[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_REQUEST,
+			WLAN_EID_EXT_SUPP_RATES,
+	};
+	size_t offs;
+	u8 *newpos = pos;
+
+	if (!iwl_mvm_rrm_scan_needed(mvm)) {
+		memcpy(newpos, ies, len);
+		return newpos + len;
+	}
+
+	offs = ieee80211_ie_split(ies, len,
+				  before_ds_params,
+				  ARRAY_SIZE(before_ds_params),
+				  0);
+
+	memcpy(newpos, ies, offs);
+	newpos += offs;
+
+	/* Add a placeholder for DS Parameter Set element */
+	*newpos++ = WLAN_EID_DS_PARAMS;
+	*newpos++ = 1;
+	*newpos++ = 0;
+
+	memcpy(newpos, ies + offs, len - offs);
+	newpos += len - offs;
+
+	return newpos;
+}
+
 static void
 iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 struct ieee80211_scan_ies *ies,
@@ -1142,7 +1182,7 @@ iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 	struct ieee80211_mgmt *frame = (struct ieee80211_mgmt *)preq->buf;
-	u8 *pos;
+	u8 *pos, *newpos;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
 	eth_broadcast_addr(frame->da);
@@ -1157,11 +1197,14 @@ iwl_mvm_build_unified_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	preq->mac_header.offset = 0;
 	preq->mac_header.len = cpu_to_le16(24 + 2);
 
-	memcpy(pos, ies->ies[IEEE80211_BAND_2GHZ],
-	       ies->len[IEEE80211_BAND_2GHZ]);
+	/* Insert ds parameter set element on 2.4 GHz band */
+	newpos = iwl_mvm_copy_and_insert_ds_elem(mvm,
+						 ies->ies[IEEE80211_BAND_2GHZ],
+						 ies->len[IEEE80211_BAND_2GHZ],
+						 pos);
 	preq->band_data[0].offset = cpu_to_le16(pos - preq->buf);
-	preq->band_data[0].len = cpu_to_le16(ies->len[IEEE80211_BAND_2GHZ]);
-	pos += ies->len[IEEE80211_BAND_2GHZ];
+	preq->band_data[0].len = cpu_to_le16(newpos - pos);
+	pos = newpos;
 
 	memcpy(pos, ies->ies[IEEE80211_BAND_5GHZ],
 	       ies->len[IEEE80211_BAND_5GHZ]);
-- 
2.1.1

