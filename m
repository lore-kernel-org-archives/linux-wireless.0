Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42612 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHETou (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:24 +0300
Message-Id: <20170805194331.17426-13-luca@coelho.fi> (sfid-20170805_214453_560623_D6CBC1BA)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 12/19] iwlwifi: mvm: support new beacon template command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Support new version of beacon template command. This rplaces v8 command
which was missing the rate code.
Also, export rate decision logic to separate function.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    | 17 +++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 47 ++++++++++++++++-------
 3 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 2909d1ed89cf..4928310ddd31 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -786,13 +786,20 @@ struct iwl_mac_beacon_cmd_v7 {
 	struct ieee80211_hdr frame[0];
 } __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_7 */
 
+enum iwl_mac_beacon_flags {
+	IWL_MAC_BEACON_CCK	= BIT(8),
+	IWL_MAC_BEACON_ANT_A	= BIT(9),
+	IWL_MAC_BEACON_ANT_B	= BIT(10),
+	IWL_MAC_BEACON_ANT_C	= BIT(11),
+};
+
 /**
  * struct iwl_mac_beacon_cmd - beacon template command with offloaded CSA
- * @byte_cnt: byte count of the beacon frame
- * @flags: for future use
+ * @byte_cnt: byte count of the beacon frame.
+ * @flags: least significant byte for rate code. The most significant byte
+ *	is &enum iwl_mac_beacon_flags.
  * @reserved: reserved
- * @template_id: currently equal to the mac context id of the coresponding
- *  mac.
+ * @template_id: currently equal to the mac context id of the coresponding mac.
  * @tim_idx: the offset of the tim IE in the beacon
  * @tim_size: the length of the tim IE
  * @ecsa_offset: offset to the ECSA IE if present
@@ -809,7 +816,7 @@ struct iwl_mac_beacon_cmd {
 	__le32 ecsa_offset;
 	__le32 csa_offset;
 	struct ieee80211_hdr frame[0];
-} __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_8 */
+} __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_9 */
 
 struct iwl_beacon_notif {
 	struct iwl_mvm_tx_resp beacon_notify_hdr;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 0fa8c473f1e2..d933aa324ffe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -260,6 +260,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_STA_TYPE		= (__force iwl_ucode_tlv_api_t)30,
 	IWL_UCODE_TLV_API_NAN2_VER2		= (__force iwl_ucode_tlv_api_t)31,
 	/* API Set 1 */
+	IWL_UCODE_TLV_API_NEW_BEACON_TEMPLATE	= (__force iwl_ucode_tlv_api_t)34,
 	IWL_UCODE_TLV_API_NEW_RX_STATS		= (__force iwl_ucode_tlv_api_t)35,
 
 	NUM_IWL_UCODE_TLV_API
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 8fe955d58c6e..cb4e311b059f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -923,6 +923,19 @@ static u32 iwl_mvm_find_ie_offset(u8 *beacon, u8 eid, u32 frame_size)
 	return ie - beacon;
 }
 
+static u8 iwl_mvm_mac_ctxt_get_lowest_rate(struct ieee80211_tx_info *info,
+					   struct ieee80211_vif *vif)
+{
+	u8 rate;
+
+	if (info->band == NL80211_BAND_5GHZ || vif->p2p)
+		rate = IWL_FIRST_OFDM_RATE;
+	else
+		rate = IWL_FIRST_CCK_RATE;
+
+	return rate;
+}
+
 static void iwl_mvm_mac_ctxt_set_tx(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct sk_buff *beacon,
@@ -930,7 +943,8 @@ static void iwl_mvm_mac_ctxt_set_tx(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct ieee80211_tx_info *info;
-	u32 rate, tx_flags;
+	u8 rate;
+	u32 tx_flags;
 
 	info = IEEE80211_SKB_CB(beacon);
 
@@ -955,14 +969,12 @@ static void iwl_mvm_mac_ctxt_set_tx(struct iwl_mvm *mvm,
 		cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
 			    RATE_MCS_ANT_POS);
 
-	if (info->band == NL80211_BAND_5GHZ || vif->p2p) {
-		rate = IWL_FIRST_OFDM_RATE;
-	} else {
-		rate = IWL_FIRST_CCK_RATE;
-		tx->rate_n_flags |= cpu_to_le32(RATE_MCS_CCK_MSK);
-	}
+	rate = iwl_mvm_mac_ctxt_get_lowest_rate(info, vif);
 
 	tx->rate_n_flags |= cpu_to_le32(iwl_mvm_mac80211_idx_to_hwrate(rate));
+	if (rate == IWL_FIRST_CCK_RATE)
+		tx->rate_n_flags |= cpu_to_le32(RATE_MCS_CCK_MSK);
+
 }
 
 static int iwl_mvm_mac_ctxt_send_beacon_cmd(struct iwl_mvm *mvm,
@@ -1033,19 +1045,27 @@ static int iwl_mvm_mac_ctxt_send_beacon_v7(struct iwl_mvm *mvm,
 						sizeof(beacon_cmd));
 }
 
-static int iwl_mvm_mac_ctxt_send_beacon_v8(struct iwl_mvm *mvm,
+static int iwl_mvm_mac_ctxt_send_beacon_v9(struct iwl_mvm *mvm,
 					   struct ieee80211_vif *vif,
 					   struct sk_buff *beacon)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(beacon);
 	struct iwl_mac_beacon_cmd beacon_cmd = {};
+	u8 rate = iwl_mvm_mac_ctxt_get_lowest_rate(info, vif);
+	u16 flags;
+
+	flags = iwl_mvm_mac80211_idx_to_hwrate(rate);
 
+	if (flags == IWL_FIRST_CCK_RATE)
+		flags |= IWL_MAC_BEACON_CCK;
+
+	beacon_cmd.flags = cpu_to_le16(flags);
 	beacon_cmd.byte_cnt = cpu_to_le16((u16)beacon->len);
 	beacon_cmd.template_id = cpu_to_le32((u32)mvmvif->id);
 
 	if (vif->type == NL80211_IFTYPE_AP)
-		iwl_mvm_mac_ctxt_set_tim(mvm,
-					 &beacon_cmd.tim_idx,
+		iwl_mvm_mac_ctxt_set_tim(mvm, &beacon_cmd.tim_idx,
 					 &beacon_cmd.tim_size,
 					 beacon->data, beacon->len);
 
@@ -1073,10 +1093,11 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 			 IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD))
 		return iwl_mvm_mac_ctxt_send_beacon_v6(mvm, vif, beacon);
 
-	if (!iwl_mvm_has_new_tx_api(mvm))
-		return iwl_mvm_mac_ctxt_send_beacon_v7(mvm, vif, beacon);
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_NEW_BEACON_TEMPLATE))
+		return iwl_mvm_mac_ctxt_send_beacon_v9(mvm, vif, beacon);
 
-	return iwl_mvm_mac_ctxt_send_beacon_v8(mvm, vif, beacon);
+	return iwl_mvm_mac_ctxt_send_beacon_v7(mvm, vif, beacon);
 }
 
 /* The beacon template for the AP/GO/IBSS has changed and needs update */
-- 
2.13.2
