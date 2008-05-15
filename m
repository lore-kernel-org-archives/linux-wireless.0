Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYEOF4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:18 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/26] iwlwifi: filling Tx MCS set
Date: Thu, 15 May 2008 13:53:56 +0800
Message-Id: <1210830858-3410-5-git-send-email-yi.zhu@intel.com> (sfid-20080515_075623_169970_88F5393A)
In-Reply-To: <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fills the needed data about HW capabilities in matters of
possible HT Tx MCS.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   33 +++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d3cbad2..a2f4f28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -317,24 +317,33 @@ void iwl_reset_qos(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_reset_qos);
 
 #ifdef CONFIG_IWL4965_HT
+#define MAX_BIT_RATE_40_MHZ 0x96; /* 150 Mbps */
+#define MAX_BIT_RATE_20_MHZ 0x48; /* 72 Mbps */
 static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 			      struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band)
 {
+	u16 max_bit_rate = 0;
+	u8 rx_chains_num = priv->hw_params.rx_chains_num;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
+
 	ht_info->cap = 0;
 	memset(ht_info->supp_mcs_set, 0, 16);
 
 	ht_info->ht_supported = 1;
 
+	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
+	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
+	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
+			     (IWL_MIMO_PS_NONE << 2));
+
+	max_bit_rate = MAX_BIT_RATE_20_MHZ;
 	if (priv->hw_params.fat_channel & BIT(band)) {
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_SUP_WIDTH;
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_40;
 		ht_info->supp_mcs_set[4] = 0x01;
+		max_bit_rate = MAX_BIT_RATE_40_MHZ;
 	}
-	ht_info->cap |= (u16)IEEE80211_HT_CAP_GRN_FLD;
-	ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_20;
-	ht_info->cap |= (u16)(IEEE80211_HT_CAP_MIMO_PS &
-			     (IWL_MIMO_PS_NONE << 2));
 
 	if (priv->cfg->mod_params->amsdu_size_8K)
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_MAX_AMSDU;
@@ -343,10 +352,22 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
 
 	ht_info->supp_mcs_set[0] = 0xFF;
-	if (priv->hw_params.tx_chains_num >= 2)
+	if (rx_chains_num >= 2)
 		ht_info->supp_mcs_set[1] = 0xFF;
-	if (priv->hw_params.tx_chains_num >= 3)
+	if (rx_chains_num >= 3)
 		ht_info->supp_mcs_set[2] = 0xFF;
+
+	/* Highest supported Rx data rate */
+	max_bit_rate *= rx_chains_num;
+	ht_info->supp_mcs_set[10] = (u8)(max_bit_rate & 0x00FF);
+	ht_info->supp_mcs_set[11] = (u8)((max_bit_rate & 0xFF00) >> 8);
+
+	/* Tx MCS capabilities */
+	ht_info->supp_mcs_set[12] = IEEE80211_HT_CAP_MCS_TX_DEFINED;
+	if (tx_chains_num != rx_chains_num) {
+		ht_info->supp_mcs_set[12] |= IEEE80211_HT_CAP_MCS_TX_RX_DIFF;
+		ht_info->supp_mcs_set[12] |= ((tx_chains_num - 1) << 2);
+	}
 }
 #else
 static inline void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
-- 
1.5.3.6

