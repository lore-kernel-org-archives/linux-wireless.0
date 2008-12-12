Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbYLLQVL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 11:21:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlagn: fix agn rate scaling
Date: Fri, 12 Dec 2008 08:22:15 -0800
Message-Id: <1229098935-30198-1-git-send-email-reinette.chatre@intel.com> (sfid-20081212_172115_790112_5E6E3CFA)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

    Rate scaling in agn can be broken because of these two problems
    1- the LQ command could not sent, we try to call LQ command before
       post association will be rejected, this will cause the driver to
       break in rs_tx_status reporting initial rate does not match.
    2- In rs_rate_init we can get a value of 12, rate 60, for
       last_txrate_idx, this rate only valid in SISO/MIMO mode only

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 025fb78..50e4dd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -838,6 +838,10 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    (hw->wiphy->bands[priv->band]->bitrates[rs_index].bitrate !=
 	     hw->wiphy->bands[info->band]->bitrates[info->status.rates[0].idx].bitrate)) {
 		IWL_DEBUG_RATE("initial rate does not match 0x%x\n", tx_rate);
+		/* the last LQ command could failed so the LQ in ucode not
+		 * the same in driver sync up
+		 */
+		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		goto out;
 	}
 
@@ -2170,6 +2174,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct iwl_lq_sta *lq_sta = priv_sta;
+	u16 mask_bit = 0;
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
@@ -2206,16 +2211,6 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		priv->assoc_station_added = 1;
 	}
 
-	/* Find highest tx rate supported by hardware and destination station */
-	lq_sta->last_txrate_idx = 3;
-	for (i = 0; i < sband->n_bitrates; i++)
-		if (sta->supp_rates[sband->band] & BIT(i))
-			lq_sta->last_txrate_idx = i;
-
-	/* For MODE_IEEE80211A, skip over cck rates in global rate table */
-	if (sband->band == IEEE80211_BAND_5GHZ)
-		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
-
 	lq_sta->is_dup = 0;
 	lq_sta->is_green = rs_use_green(priv, conf);
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
@@ -2254,6 +2249,17 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
 	lq_sta->drv = priv;
 
+	/* Find highest tx rate supported by hardware and destination station */
+	mask_bit = sta->supp_rates[sband->band] & lq_sta->active_legacy_rate;
+	lq_sta->last_txrate_idx = 3;
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (mask_bit & BIT(i))
+			lq_sta->last_txrate_idx = i;
+
+	/* For MODE_IEEE80211A, skip over cck rates in global rate table */
+	if (sband->band == IEEE80211_BAND_5GHZ)
+		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
+
 	rs_initialize_lq(priv, conf, sta, lq_sta);
 }
 
-- 
1.5.4.3

