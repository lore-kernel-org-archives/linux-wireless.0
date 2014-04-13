Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45341 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbaDMTU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:57 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so4539509wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_RX_ENERGY_API flag
Date: Sun, 13 Apr 2014 22:19:46 +0300
Message-Id: <1397416802-32403-31-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_094290_200072EE)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h |  2 --
 drivers/net/wireless/iwlwifi/mvm/rx.c | 40 +----------------------------------
 2 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index c9a3ca6..7d5e7ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -77,7 +77,6 @@
  * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
  * @IWL_UCODE_TLV_FLAGS_SHORT_BL: 16 entries of black list instead of 64 in scan
  *	offload profile config command.
- * @IWL_UCODE_TLV_FLAGS_RX_ENERGY_API: supports rx signal strength api
  * @IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2: using the new time event API.
  * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
  *	(rather than two) IPv6 addresses
@@ -108,7 +107,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
-	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
 	IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2	= BIT(9),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
 	IWL_UCODE_TLV_FLAGS_BF_UPDATED		= BIT(11),
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 40fd5dc..cf72769 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -132,41 +132,6 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	ieee80211_rx(mvm->hw, skb);
 }
 
-static void iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
-			      struct iwl_rx_phy_info *phy_info,
-			      struct ieee80211_rx_status *rx_status)
-{
-	int rssi_a, rssi_b, rssi_a_dbm, rssi_b_dbm, max_rssi_dbm;
-	u32 agc_a, agc_b;
-	u32 val;
-
-	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_AGC_IDX]);
-	agc_a = (val & IWL_OFDM_AGC_A_MSK) >> IWL_OFDM_AGC_A_POS;
-	agc_b = (val & IWL_OFDM_AGC_B_MSK) >> IWL_OFDM_AGC_B_POS;
-
-	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_RSSI_AB_IDX]);
-	rssi_a = (val & IWL_OFDM_RSSI_INBAND_A_MSK) >> IWL_OFDM_RSSI_A_POS;
-	rssi_b = (val & IWL_OFDM_RSSI_INBAND_B_MSK) >> IWL_OFDM_RSSI_B_POS;
-
-	/*
-	 * dBm = rssi dB - agc dB - constant.
-	 * Higher AGC (higher radio gain) means lower signal.
-	 */
-	rssi_a_dbm = rssi_a - IWL_RSSI_OFFSET - agc_a;
-	rssi_b_dbm = rssi_b - IWL_RSSI_OFFSET - agc_b;
-	max_rssi_dbm = max_t(int, rssi_a_dbm, rssi_b_dbm);
-
-	IWL_DEBUG_STATS(mvm, "Rssi In A %d B %d Max %d AGCA %d AGCB %d\n",
-			rssi_a_dbm, rssi_b_dbm, max_rssi_dbm, agc_a, agc_b);
-
-	rx_status->signal = max_rssi_dbm;
-	rx_status->chains = (le16_to_cpu(phy_info->phy_flags) &
-				RX_RES_PHY_FLAGS_ANTENNA)
-					>> RX_RES_PHY_FLAGS_ANTENNA_POS;
-	rx_status->chain_signal[0] = rssi_a_dbm;
-	rx_status->chain_signal[1] = rssi_b_dbm;
-}
-
 /*
  * iwl_mvm_get_signal_strength - use new rx PHY INFO API
  * values are reported by the fw as positive values - need to negate
@@ -336,10 +301,7 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	 */
 	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_RX_ENERGY_API)
-		iwl_mvm_get_signal_strength(mvm, phy_info, &rx_status);
-	else
-		iwl_mvm_calc_rssi(mvm, phy_info, &rx_status);
+	iwl_mvm_get_signal_strength(mvm, phy_info, &rx_status);
 
 	IWL_DEBUG_STATS_LIMIT(mvm, "Rssi %d, TSF %llu\n", rx_status.signal,
 			      (unsigned long long)rx_status.mactime);
-- 
1.8.3.2

