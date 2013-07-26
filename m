Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab3GZI3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>
Subject: [PATCH 13/30] iwlwifi: rx_phy_info: new api to get signal strength
Date: Fri, 26 Jul 2013 10:28:30 +0200
Message-Id: <1374827327-3464-14-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_524121_AB83C139)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

A new API that replaces the rx signal strength calculation via agc & rssi.
The energy is now calculated outside the driver and transferred by the fw.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h     | 14 ++++++-----
 drivers/net/wireless/iwlwifi/mvm/fw-api.h |  8 ++++++
 drivers/net/wireless/iwlwifi/mvm/rx.c     | 41 ++++++++++++++++++++++---------
 3 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f26f126..46dc38a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -75,14 +75,16 @@
  * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
  * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
  * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
+ * @IWL_UCODE_TLV_FLAGS_RX_ENERGY_API: supports rx signal strength api
  */
 enum iwl_ucode_tlv_flag {
-	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
-	IWL_UCODE_TLV_FLAGS_NEWSCAN	= BIT(1),
-	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
-	IWL_UCODE_TLV_FLAGS_P2P		= BIT(3),
-	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE	= BIT(4),
-	IWL_UCODE_TLV_FLAGS_UAPSD	= BIT(6),
+	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
+	IWL_UCODE_TLV_FLAGS_NEWSCAN		= BIT(1),
+	IWL_UCODE_TLV_FLAGS_MFP			= BIT(2),
+	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
+	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
+	IWL_UCODE_TLV_FLAGS_UAPSD		= BIT(6),
+	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 44614f5..28cab82 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -768,6 +768,14 @@ struct iwl_phy_context_cmd {
 } __packed; /* PHY_CONTEXT_CMD_API_VER_1 */
 
 #define IWL_RX_INFO_PHY_CNT 8
+#define IWL_RX_INFO_ENERGY_ANT_ABC_IDX 1
+#define IWL_RX_INFO_ENERGY_ANT_A_MSK 0x000000ff
+#define IWL_RX_INFO_ENERGY_ANT_B_MSK 0x0000ff00
+#define IWL_RX_INFO_ENERGY_ANT_C_MSK 0x00ff0000
+#define IWL_RX_INFO_ENERGY_ANT_A_POS 0
+#define IWL_RX_INFO_ENERGY_ANT_B_POS 8
+#define IWL_RX_INFO_ENERGY_ANT_C_POS 16
+
 #define IWL_RX_INFO_AGC_IDX 1
 #define IWL_RX_INFO_RSSI_AB_IDX 2
 #define IWL_OFDM_AGC_A_MSK 0x0000007f
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index e4930d5..c02487e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -124,10 +124,6 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	ieee80211_rx_ni(mvm->hw, skb);
 }
 
-/*
- * iwl_mvm_calc_rssi - calculate the rssi in dBm
- * @phy_info: the phy information for the coming packet
- */
 static int iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
 			     struct iwl_rx_phy_info *phy_info)
 {
@@ -136,12 +132,6 @@ static int iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
 	u32 agc_a, agc_b, max_agc;
 	u32 val;
 
-	/* Find max rssi among 2 possible receivers.
-	 * These values are measured by the Digital Signal Processor (DSP).
-	 * They should stay fairly constant even as the signal strength varies,
-	 * if the radio's Automatic Gain Control (AGC) is working right.
-	 * AGC value (see below) will provide the "interesting" info.
-	 */
 	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_AGC_IDX]);
 	agc_a = (val & IWL_OFDM_AGC_A_MSK) >> IWL_OFDM_AGC_A_POS;
 	agc_b = (val & IWL_OFDM_AGC_B_MSK) >> IWL_OFDM_AGC_B_POS;
@@ -170,6 +160,32 @@ static int iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
 }
 
 /*
+ * iwl_mvm_get_signal_strength - use new rx PHY INFO API
+ */
+static int iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
+				       struct iwl_rx_phy_info *phy_info)
+{
+	int energy_a, energy_b, energy_c, max_energy;
+	u32 val;
+
+	val =
+	    le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_ENERGY_ANT_ABC_IDX]);
+	energy_a = (val & IWL_RX_INFO_ENERGY_ANT_A_MSK) >>
+						IWL_RX_INFO_ENERGY_ANT_A_POS;
+	energy_b = (val & IWL_RX_INFO_ENERGY_ANT_B_MSK) >>
+						IWL_RX_INFO_ENERGY_ANT_B_POS;
+	energy_c = (val & IWL_RX_INFO_ENERGY_ANT_C_MSK) >>
+						IWL_RX_INFO_ENERGY_ANT_C_POS;
+	max_energy = max(energy_a, energy_b);
+	max_energy = max(max_energy, energy_c);
+
+	IWL_DEBUG_STATS(mvm, "energy In A %d B %d C %d , and max %d\n",
+			energy_a, energy_b, energy_c, max_energy);
+
+	return max_energy;
+}
+
+/*
  * iwl_mvm_set_mac80211_rx_flag - translate fw status to mac80211 format
  * @mvm: the mvm object
  * @hdr: 80211 header
@@ -290,7 +306,10 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.signal = iwl_mvm_calc_rssi(mvm, phy_info);
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_RX_ENERGY_API)
+		rx_status.signal = iwl_mvm_get_signal_strength(mvm, phy_info);
+	else
+		rx_status.signal = iwl_mvm_calc_rssi(mvm, phy_info);
 
 	IWL_DEBUG_STATS_LIMIT(mvm, "Rssi %d, TSF %llu\n", rx_status.signal,
 			      (unsigned long long)rx_status.mactime);
-- 
1.8.0

