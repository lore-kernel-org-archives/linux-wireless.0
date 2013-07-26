Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3GZI3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 25/30] iwlwifi: mvm: report per-chain signal to mac80211
Date: Fri, 26 Jul 2013 10:28:42 +0200
Message-Id: <1374827327-3464-26-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103017_213475_496F115E)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of reporting the maximum signal strength and the
antenna bitmap in the antenna field (which is really just
for radiotap and defined differently), report the signal
strength values per chain and set the chain bitmap.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 47 ++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index c02487e..670aa02 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -124,8 +124,9 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	ieee80211_rx_ni(mvm->hw, skb);
 }
 
-static int iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
-			     struct iwl_rx_phy_info *phy_info)
+static void iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
+			      struct iwl_rx_phy_info *phy_info,
+			      struct ieee80211_rx_status *rx_status)
 {
 	int rssi_a, rssi_b, rssi_a_dbm, rssi_b_dbm, max_rssi_dbm;
 	int rssi_all_band_a, rssi_all_band_b;
@@ -156,14 +157,20 @@ static int iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
 	IWL_DEBUG_STATS(mvm, "Rssi In A %d B %d Max %d AGCA %d AGCB %d\n",
 			rssi_a_dbm, rssi_b_dbm, max_rssi_dbm, agc_a, agc_b);
 
-	return max_rssi_dbm;
+	rx_status->signal = max_rssi_dbm;
+	rx_status->chains = (le16_to_cpu(phy_info->phy_flags) &
+				RX_RES_PHY_FLAGS_ANTENNA)
+					>> RX_RES_PHY_FLAGS_ANTENNA_POS;
+	rx_status->chain_signal[0] = rssi_a_dbm;
+	rx_status->chain_signal[1] = rssi_b_dbm;
 }
 
 /*
  * iwl_mvm_get_signal_strength - use new rx PHY INFO API
  */
-static int iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
-				       struct iwl_rx_phy_info *phy_info)
+static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
+					struct iwl_rx_phy_info *phy_info,
+					struct ieee80211_rx_status *rx_status)
 {
 	int energy_a, energy_b, energy_c, max_energy;
 	u32 val;
@@ -182,7 +189,13 @@ static int iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 	IWL_DEBUG_STATS(mvm, "energy In A %d B %d C %d , and max %d\n",
 			energy_a, energy_b, energy_c, max_energy);
 
-	return max_energy;
+	rx_status->signal = max_energy;
+	rx_status->chains = (le16_to_cpu(phy_info->phy_flags) &
+				RX_RES_PHY_FLAGS_ANTENNA)
+					>> RX_RES_PHY_FLAGS_ANTENNA_POS;
+	rx_status->chain_signal[0] = energy_a;
+	rx_status->chain_signal[1] = energy_b;
+	rx_status->chain_signal[2] = energy_c;
 }
 
 /*
@@ -305,32 +318,14 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	 */
 	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
 
-	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_RX_ENERGY_API)
-		rx_status.signal = iwl_mvm_get_signal_strength(mvm, phy_info);
+		iwl_mvm_get_signal_strength(mvm, phy_info, &rx_status);
 	else
-		rx_status.signal = iwl_mvm_calc_rssi(mvm, phy_info);
+		iwl_mvm_calc_rssi(mvm, phy_info, &rx_status);
 
 	IWL_DEBUG_STATS_LIMIT(mvm, "Rssi %d, TSF %llu\n", rx_status.signal,
 			      (unsigned long long)rx_status.mactime);
 
-	/*
-	 * "antenna number"
-	 *
-	 * It seems that the antenna field in the phy flags value
-	 * is actually a bit field. This is undefined by radiotap,
-	 * it wants an actual antenna number but I always get "7"
-	 * for most legacy frames I receive indicating that the
-	 * same frame was received on all three RX chains.
-	 *
-	 * I think this field should be removed in favor of a
-	 * new 802.11n radiotap field "RX chains" that is defined
-	 * as a bitmask.
-	 */
-	rx_status.antenna = (le16_to_cpu(phy_info->phy_flags) &
-				RX_RES_PHY_FLAGS_ANTENNA)
-				>> RX_RES_PHY_FLAGS_ANTENNA_POS;
-
 	/* set the preamble flag if appropriate */
 	if (phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_SHORT_PREAMBLE))
 		rx_status.flag |= RX_FLAG_SHORTPRE;
-- 
1.8.0

