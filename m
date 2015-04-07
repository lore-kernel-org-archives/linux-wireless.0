Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbbDGQFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 12:05:32 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the 5.2 GHz band
Date: Tue,  7 Apr 2015 19:05:21 +0300
Message-Id: <1428422722-655-1-git-send-email-ilan.peer@intel.com> (sfid-20150407_180542_808381_B43BAFDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, VHT capabilities and supported MCSs where set for all
bands, although VHT is only allowed on 5.2 GHz band. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d5c0a1a..2f0ebda 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2438,6 +2438,31 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			sband->n_channels = ARRAY_SIZE(hwsim_channels_5ghz);
 			sband->bitrates = data->rates + 4;
 			sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
+
+			sband->vht_cap.vht_supported = true;
+			sband->vht_cap.cap =
+				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+				IEEE80211_VHT_CAP_RXLDPC |
+				IEEE80211_VHT_CAP_SHORT_GI_80 |
+				IEEE80211_VHT_CAP_SHORT_GI_160 |
+				IEEE80211_VHT_CAP_TXSTBC |
+				IEEE80211_VHT_CAP_RXSTBC_1 |
+				IEEE80211_VHT_CAP_RXSTBC_2 |
+				IEEE80211_VHT_CAP_RXSTBC_3 |
+				IEEE80211_VHT_CAP_RXSTBC_4 |
+				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
+			sband->vht_cap.vht_mcs.rx_mcs_map =
+				cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
+					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
+			sband->vht_cap.vht_mcs.tx_mcs_map =
+				sband->vht_cap.vht_mcs.rx_mcs_map;
 			break;
 		default:
 			continue;
@@ -2458,31 +2483,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
 		hw->wiphy->bands[band] = sband;
-
-		sband->vht_cap.vht_supported = true;
-		sband->vht_cap.cap =
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
-			IEEE80211_VHT_CAP_RXLDPC |
-			IEEE80211_VHT_CAP_SHORT_GI_80 |
-			IEEE80211_VHT_CAP_SHORT_GI_160 |
-			IEEE80211_VHT_CAP_TXSTBC |
-			IEEE80211_VHT_CAP_RXSTBC_1 |
-			IEEE80211_VHT_CAP_RXSTBC_2 |
-			IEEE80211_VHT_CAP_RXSTBC_3 |
-			IEEE80211_VHT_CAP_RXSTBC_4 |
-			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
-		sband->vht_cap.vht_mcs.rx_mcs_map =
-			cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
-		sband->vht_cap.vht_mcs.tx_mcs_map =
-			sband->vht_cap.vht_mcs.rx_mcs_map;
 	}
 
 	/* By default all radios belong to the first group */
-- 
1.9.1

