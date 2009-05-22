Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401AbZEVRzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/10] iwlwifi: report the rate index as an MCS rate number
Date: Fri, 22 May 2009 11:01:48 -0700
Message-Id: <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If transmit in HT rate, report the rate index as an MCS rate number
instead of an index. so "iw" can display correct BitRate

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   31 +++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 4c88e87..bcdfea7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -270,6 +270,8 @@ const static struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
   {"60", "64QAM 5/6"}
 };
 
+#define MCS_INDEX_PER_STREAM	(8)
+
 static inline u8 rs_extract_rate(u32 rate_n_flags)
 {
 	return (u8)(rate_n_flags & 0xFF);
@@ -2514,12 +2516,33 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 		}
 	}
 
-	if (rate_idx < 0 || rate_idx > IWL_RATE_COUNT)
-		rate_idx = rate_lowest_index(sband, sta);
-	else if (sband->band == IEEE80211_BAND_5GHZ)
+	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
 		rate_idx -= IWL_FIRST_OFDM_RATE;
-
+		/* 6M and 9M shared same MCS index */
+		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
+		if (rs_extract_rate(lq_sta->last_rate_n_flags) >=
+		    IWL_RATE_MIMO3_6M_PLCP)
+			rate_idx = rate_idx + (2 * MCS_INDEX_PER_STREAM);
+		else if (rs_extract_rate(lq_sta->last_rate_n_flags) >=
+			 IWL_RATE_MIMO2_6M_PLCP)
+			rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
+		info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
+		if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
+			info->control.rates[0].flags |= IEEE80211_TX_RC_SHORT_GI;
+		if (lq_sta->last_rate_n_flags & RATE_MCS_DUP_MSK)
+			info->control.rates[0].flags |= IEEE80211_TX_RC_DUP_DATA;
+		if (lq_sta->last_rate_n_flags & RATE_MCS_FAT_MSK)
+			info->control.rates[0].flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+		if (lq_sta->last_rate_n_flags & RATE_MCS_GF_MSK)
+			info->control.rates[0].flags |= IEEE80211_TX_RC_GREEN_FIELD;
+	} else {
+		if (rate_idx < 0 || rate_idx > IWL_RATE_COUNT)
+			rate_idx = rate_lowest_index(sband, sta);
+		else if (sband->band == IEEE80211_BAND_5GHZ)
+			rate_idx -= IWL_FIRST_OFDM_RATE;
+	}
 	info->control.rates[0].idx = rate_idx;
+
 }
 
 static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
-- 
1.5.6.3

