Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49805 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYLEP5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:43 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwl3945: Fix rate scale for B-mode connection
Date: Fri,  5 Dec 2008 07:58:37 -0800
Message-Id: <1228492721-27381-3-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165749_697596_2E06E09A)
In-Reply-To: <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

This patch make sure we use only CCK rate for B only network.
For 3945 driver, it sets REPLY_RATE_SCALE command every time
we connect to a new network. In this command we set for every
rate the number of try and next rate. The problem mac80211 reports
same mode for both B and G mode as IEEE80211_BAND_2GHZ which will cause
using invalid rate other than CCK in B only network. THis patch
on association will examine sta valid rate on association, if no
OFDM rate in valid available rates it considers it as B only mode so
we can set REPLY_RATE_SCALE command with valid B only network and only
choose CCK rate in rate scaling.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   12 ++++++--
 drivers/net/wireless/iwlwifi/iwl-3945.c    |   41 +++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-3945.h    |    2 +
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 06d97b1..0ecf9d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -335,10 +335,11 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 
 }
 
-static void rs_rate_init(void *priv, struct ieee80211_supported_band *sband,
+static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 			 struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
+	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_r;
 	int i;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -348,16 +349,21 @@ static void rs_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
 
-	for (i = IWL_RATE_COUNT - 1; i >= 0; i--) {
+	for (i = sband->n_bitrates - 1; i >= 0; i--) {
 		if (sta->supp_rates[sband->band] & (1 << i)) {
 			rs_sta->last_txrate_idx = i;
 			break;
 		}
 	}
 
+	priv->sta_supp_rates = sta->supp_rates[sband->band];
 	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
-	if (sband->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == IEEE80211_BAND_5GHZ) {
 		rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
+		priv->sta_supp_rates = priv->sta_supp_rates <<
+						IWL_FIRST_OFDM_RATE;
+	}
+
 
 	IWL_DEBUG_RATE("leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 6602729..dc62859 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -277,12 +277,14 @@ int iwl3945_rs_next_rate(struct iwl3945_priv *priv, int rate)
 		else if (rate == IWL_RATE_6M_INDEX)
 			next_rate = IWL_RATE_6M_INDEX;
 		break;
-/* XXX cannot be invoked in current mac80211 so not a regression
-	case MODE_IEEE80211B:
-		if (rate == IWL_RATE_11M_INDEX_TABLE)
-			next_rate = IWL_RATE_5M_INDEX_TABLE;
+	case IEEE80211_BAND_2GHZ:
+		if (!(priv->sta_supp_rates & IWL_OFDM_RATES_MASK) &&
+		    iwl3945_is_associated(priv)) {
+			if (rate == IWL_RATE_11M_INDEX)
+				next_rate = IWL_RATE_5M_INDEX;
+		}
 		break;
- */
+
 	default:
 		break;
 	}
@@ -2379,7 +2381,8 @@ int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
 			iwl3945_hw_set_rate_n_flags(iwl3945_rates[i].plcp, 0);
 		table[index].try_cnt = priv->retry_rate;
 		prev_index = iwl3945_get_prev_ieee_rate(i);
-		table[index].next_rate_index = iwl3945_rates[prev_index].table_rs_index;
+		table[index].next_rate_index =
+				iwl3945_rates[prev_index].table_rs_index;
 	}
 
 	switch (priv->band) {
@@ -2387,11 +2390,14 @@ int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
 		IWL_DEBUG_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
-		for (i = IWL_RATE_1M_INDEX_TABLE; i <= IWL_RATE_11M_INDEX_TABLE; i++)
-			table[i].next_rate_index = iwl3945_rates[IWL_FIRST_OFDM_RATE].table_rs_index;
+		for (i = IWL_RATE_1M_INDEX_TABLE;
+			i <= IWL_RATE_11M_INDEX_TABLE; i++)
+			table[i].next_rate_index =
+			  iwl3945_rates[IWL_FIRST_OFDM_RATE].table_rs_index;
 
 		/* Don't fall back to CCK rates */
-		table[IWL_RATE_12M_INDEX_TABLE].next_rate_index = IWL_RATE_9M_INDEX_TABLE;
+		table[IWL_RATE_12M_INDEX_TABLE].next_rate_index =
+						IWL_RATE_9M_INDEX_TABLE;
 
 		/* Don't drop out of OFDM rates */
 		table[IWL_RATE_6M_INDEX_TABLE].next_rate_index =
@@ -2402,11 +2408,20 @@ int iwl3945_init_hw_rate_table(struct iwl3945_priv *priv)
 		IWL_DEBUG_RATE("Select B/G mode rate scale\n");
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
-		for (i = IWL_RATE_6M_INDEX_TABLE; i <= IWL_RATE_54M_INDEX_TABLE; i++)
-			table[i].next_rate_index = iwl3945_rates[IWL_FIRST_CCK_RATE].table_rs_index;
 
-		/* CCK shouldn't fall back to OFDM... */
-		table[IWL_RATE_11M_INDEX_TABLE].next_rate_index = IWL_RATE_5M_INDEX_TABLE;
+		if (!(priv->sta_supp_rates & IWL_OFDM_RATES_MASK) &&
+		    iwl3945_is_associated(priv)) {
+
+			index = IWL_FIRST_CCK_RATE;
+			for (i = IWL_RATE_6M_INDEX_TABLE;
+			     i <= IWL_RATE_54M_INDEX_TABLE; i++)
+				table[i].next_rate_index =
+					iwl3945_rates[index].table_rs_index;
+
+			index = IWL_RATE_11M_INDEX_TABLE;
+			/* CCK shouldn't fall back to OFDM... */
+			table[index].next_rate_index = IWL_RATE_5M_INDEX_TABLE;
+		}
 		break;
 
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 5c2c15e..d7d13a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -810,6 +810,8 @@ struct iwl3945_priv {
 	u16 active_rate;
 	u16 active_rate_basic;
 
+	u32 sta_supp_rates;
+
 	u8 call_post_assoc_from_beacon;
 	/* Rate scaling data */
 	s8 data_retry_limit;
-- 
1.5.4.3

