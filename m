Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZAUSzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 13:55:35 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2 v2.6.29] iwlagn: fix agn rate scaling
Date: Wed, 21 Jan 2009 10:58:03 -0800
Message-Id: <1232564283-18008-3-git-send-email-reinette.chatre@intel.com> (sfid-20090121_195542_490527_B15F2D8C)
In-Reply-To: <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232564283-18008-1-git-send-email-reinette.chatre@intel.com>
 <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

Sometime Tx reply rate different than what rate scale expecting
causing rate scale to bail out. This could cause failing to
commit LQ cmd. This patch will try to solve this instead of just
bail out. It also make sure we start with a valid rate.

Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   31 +++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 27f5047..720a9d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -49,6 +49,8 @@
 #define IWL_RATE_MIN_FAILURE_TH		6	/* min failures to calc tpt */
 #define IWL_RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
 
+/* max allowed rate miss before sync LQ cmd */
+#define IWL_MISSED_RATE_MAX		15
 /* max time to accum history 2 seconds */
 #define IWL_RATE_SCALE_FLUSH_INTVL   (2*HZ)
 
@@ -148,6 +150,7 @@ struct iwl_lq_sta {
 	u16 active_mimo2_rate;
 	u16 active_mimo3_rate;
 	u16 active_rate_basic;
+	u8 missed_rate_counter;
 
 	struct iwl_link_quality_cmd lq;
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
@@ -839,10 +842,15 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		/* the last LQ command could failed so the LQ in ucode not
 		 * the same in driver sync up
 		 */
-		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+		lq_sta->missed_rate_counter++;
+		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
+			lq_sta->missed_rate_counter = 0;
+			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+		}
 		goto out;
 	}
 
+	lq_sta->missed_rate_counter = 0;
 	/* Update frame history window with "failure" for each Tx retry. */
 	while (retries) {
 		/* Look up the rate and other info used for each tx attempt.
@@ -2182,6 +2190,8 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	struct ieee80211_conf *conf = &priv->hw->conf;
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	u16 mask_bit = 0;
+	int count;
+	int start_rate = 0;
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
@@ -2216,6 +2226,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	}
 
 	lq_sta->is_dup = 0;
+	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
 	lq_sta->is_green = rs_use_green(priv, conf);
 	lq_sta->active_legacy_rate = priv->active_rate & ~(0x1000);
 	lq_sta->active_rate_basic = priv->active_rate_basic;
@@ -2254,16 +2265,20 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->drv = priv;
 
 	/* Find highest tx rate supported by hardware and destination station */
-	mask_bit = sta->supp_rates[sband->band] & lq_sta->active_legacy_rate;
-	lq_sta->last_txrate_idx = 3;
-	for (i = 0; i < sband->n_bitrates; i++)
+	mask_bit = sta->supp_rates[sband->band];
+	count = sband->n_bitrates;
+	if (sband->band == IEEE80211_BAND_5GHZ) {
+		count += IWL_FIRST_OFDM_RATE;
+		start_rate = IWL_FIRST_OFDM_RATE;
+		mask_bit <<= IWL_FIRST_OFDM_RATE;
+	}
+
+	mask_bit = mask_bit & lq_sta->active_legacy_rate;
+	lq_sta->last_txrate_idx = 4;
+	for (i = start_rate; i < count; i++)
 		if (mask_bit & BIT(i))
 			lq_sta->last_txrate_idx = i;
 
-	/* For MODE_IEEE80211A, skip over cck rates in global rate table */
-	if (sband->band == IEEE80211_BAND_5GHZ)
-		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
-
 	rs_initialize_lq(priv, conf, sta, lq_sta);
 }
 
-- 
1.5.4.3

