Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYDCXFr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: use ieee80211_frequency_to_channel
Date: Thu,  3 Apr 2008 16:05:22 -0700
Message-Id: <1207263924-25385-4-git-send-email-reinette.chatre@intel.com> (sfid-20080404_000604_339600_F8F536D2)
In-Reply-To: <1207263924-25385-3-git-send-email-reinette.chatre@intel.com>
References: <1207263924-25385-1-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-2-git-send-email-reinette.chatre@intel.com>
 <1207263924-25385-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces ieee80211chan2mhz from radiotap with
ieee80211_frequency_to_channel provided by mac80211

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |   13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index eb30819..56c881d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -669,12 +669,12 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	rx_status.antenna = 0;
 	rx_status.flag = 0;
 	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
-	rx_status.freq = ieee80211chan2mhz(le16_to_cpu(rx_hdr->channel));
+	rx_status.freq =
+		ieee80211_frequency_to_channel(le16_to_cpu(rx_hdr->channel));
 	rx_status.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 
 	rx_status.rate_idx = iwl3945_hwrate_to_plcp_idx(rx_hdr->rate);
-
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 558e307..4c5057b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3813,12 +3813,12 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	u8 network_packet;
 
 	rx_status.mactime = le64_to_cpu(rx_start->timestamp);
-	rx_status.freq = ieee80211chan2mhz(le16_to_cpu(rx_start->channel));
+	rx_status.freq =
+		ieee80211_frequency_to_channel(le16_to_cpu(rx_start->channel));
 	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-	rx_status.rate_idx = iwl4965_hwrate_to_plcp_idx(
-					le32_to_cpu(rx_start->rate_n_flags));
-
+	rx_status.rate_idx =
+		iwl4965_hwrate_to_plcp_idx(le32_to_cpu(rx_start->rate_n_flags));
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
@@ -3826,9 +3826,8 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	rx_status.flag = 0;
 
 	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP
-			("dsp size out of range [0,20]: "
-			 "%d/n", rx_start->cfg_phy_cnt);
+		IWL_DEBUG_DROP("dsp size out of range [0,20]: %d/n",
+				rx_start->cfg_phy_cnt);
 		return;
 	}
 
-- 
1.5.3.4

