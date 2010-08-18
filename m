Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0HRQSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/16] iwlagn: continue perform rate scale when error detected
Date: Wed, 18 Aug 2010 09:22:45 -0700
Message-Id: <1282148571-9258-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If for some reason, the actual link command not matching neither
active nor search table; instead of return and not performing rate
scale, by-pass the data collection and continue the rate scale process.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 4d5738d..a456338 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -82,6 +82,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct iwl_lq_sta *lq_sta);
 static void rs_fill_link_cmd(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
+static void rs_stay_in_table(struct iwl_lq_sta *lq_sta);
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -502,6 +503,7 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	u8 num_of_ant = get_num_of_ant_from_rate(rate_n_flags);
 	u8 mcs;
 
+	memset(tbl, 0, sizeof(struct iwl_scale_tbl_info));
 	*rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
 
 	if (*rate_idx  == IWL_RATE_INVALID) {
@@ -848,7 +850,20 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	} else {
 		IWL_DEBUG_RATE(priv, "Neither active nor search matches tx rate\n");
-		return;
+		tmp_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+		IWL_DEBUG_RATE(priv, "active- lq:%x, ant:%x, SGI:%d\n",
+			tmp_tbl->lq_type, tmp_tbl->ant_type, tmp_tbl->is_SGI);
+		tmp_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
+		IWL_DEBUG_RATE(priv, "search- lq:%x, ant:%x, SGI:%d\n",
+			tmp_tbl->lq_type, tmp_tbl->ant_type, tmp_tbl->is_SGI);
+		IWL_DEBUG_RATE(priv, "actual- lq:%x, ant:%x, SGI:%d\n",
+			tbl_type.lq_type, tbl_type.ant_type, tbl_type.is_SGI);
+		/*
+		 * no matching table found, let's by-pass the data collection
+		 * and continue to perform rate scale to find the rate table
+		 */
+		rs_stay_in_table(lq_sta);
+		goto done;
 	}
 
 	/*
@@ -909,7 +924,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	}
 	/* The last TX rate is cached in lq_sta; it's set in if/else above */
 	lq_sta->last_rate_n_flags = tx_rate;
-
+done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
@@ -2598,7 +2613,6 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
 
 	/* Interpret new_rate (rate_n_flags) */
-	memset(&tbl_type, 0, sizeof(tbl_type));
 	rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
 				  &tbl_type, &rate_idx);
 
-- 
1.7.0.4

