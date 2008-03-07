Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43419 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbYCGBkV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 20:40:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/4] iwlwifi: Fix 3945 rate scaling
Date: Thu,  6 Mar 2008 17:36:54 -0800
Message-Id: <1204853816-8964-3-git-send-email-reinette.chatre@intel.com> (sfid-20080307_014028_204478_E16F7365)
In-Reply-To: <1204853816-8964-2-git-send-email-reinette.chatre@intel.com>
References: <1204853816-8964-1-git-send-email-reinette.chatre@intel.com>
 <1204853816-8964-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fix 3945 rate scaling after cfg80211 rate/band changes

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   45 +++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h |    2 +-
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index c4bfba6..08604eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -158,9 +158,9 @@ static void iwl3945_clear_window(struct iwl3945_rate_scale_data *window)
 {
 	window->data = 0;
 	window->success_counter = 0;
-	window->success_ratio = IWL_INVALID_VALUE;
+	window->success_ratio = -1;
 	window->counter = 0;
-	window->average_tpt = IWL_INVALID_VALUE;
+	window->average_tpt = IWL_INV_TPT;
 	window->stamp = 0;
 }
 
@@ -459,13 +459,13 @@ static void rs_tx_status(void *priv_rate,
 	struct iwl3945_rs_sta *rs_sta;
 	struct ieee80211_supported_band *sband;
 
+	IWL_DEBUG_RATE("enter\n");
+
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	IWL_DEBUG_RATE("enter\n");
 
 	retries = tx_resp->retry_count;
-	/* FIXME : this is wrong */
-	first_index = &sband->bitrates[0] - tx_resp->control.tx_rate;
+	first_index = tx_resp->control.tx_rate->hw_value;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
 		IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
@@ -634,7 +634,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
  *
  */
 static void rs_get_rate(void *priv_rate, struct net_device *dev,
-			struct ieee80211_supported_band *band,
+			struct ieee80211_supported_band *sband,
 			struct sk_buff *skb,
 			struct rate_selection *sel)
 {
@@ -644,9 +644,9 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	int index;
 	struct iwl3945_rs_sta *rs_sta;
 	struct iwl3945_rate_scale_data *window = NULL;
-	int current_tpt = IWL_INVALID_VALUE;
-	int low_tpt = IWL_INVALID_VALUE;
-	int high_tpt = IWL_INVALID_VALUE;
+	int current_tpt = IWL_INV_TPT;
+	int low_tpt = IWL_INV_TPT;
+	int high_tpt = IWL_INV_TPT;
 	u32 fail_count;
 	s8 scale_action = 0;
 	unsigned long flags;
@@ -670,15 +670,15 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
-		sel->rate = rate_lowest(local, band, sta);
+		sel->rate = rate_lowest(local, sband, sta);
 		rcu_read_unlock();
 		return;
 	}
 
-	rate_mask = sta->supp_rates[band->band];
+	rate_mask = sta->supp_rates[sband->band];
 	index = min(sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
-	if (priv->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
 
 	rs_sta = (void *)sta->rate_ctrl_priv;
@@ -710,7 +710,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 	if (((fail_count <= IWL_RATE_MIN_FAILURE_TH) &&
 	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))) {
-		window->average_tpt = IWL_INVALID_VALUE;
+		window->average_tpt = IWL_INV_TPT;
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 		IWL_DEBUG_RATE("Invalid average_tpt on rate %d: "
@@ -729,7 +729,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	current_tpt = window->average_tpt;
 
 	high_low = iwl3945_get_adjacent_rate(rs_sta, index, rate_mask,
-					     band->band);
+					     sband->band);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
@@ -746,19 +746,16 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt) {
 		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
-	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE))
+	} else if ((low_tpt == IWL_INV_TPT) && (high_tpt == IWL_INV_TPT))
 		scale_action = 1;
-	else if ((low_tpt != IWL_INVALID_VALUE) &&
-		   (high_tpt != IWL_INVALID_VALUE)
-		   && (low_tpt < current_tpt)
-		   && (high_tpt < current_tpt)) {
+	else if ((low_tpt != IWL_INV_TPT) && (high_tpt != IWL_INV_TPT) &&
+		 (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
 		IWL_DEBUG_RATE("No action -- low [%d] & high [%d] < "
 			       "current_tpt [%d]\n",
 			       low_tpt, high_tpt, current_tpt);
 		scale_action = 0;
 	} else {
-		if (high_tpt != IWL_INVALID_VALUE) {
+		if (high_tpt != IWL_INV_TPT) {
 			if (high_tpt > current_tpt)
 				scale_action = 1;
 			else {
@@ -766,7 +763,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 				    ("decrease rate because of high tpt\n");
 				scale_action = -1;
 			}
-		} else if (low_tpt != IWL_INVALID_VALUE) {
+		} else if (low_tpt != IWL_INV_TPT) {
 			if (low_tpt > current_tpt) {
 				IWL_DEBUG_RATE
 				    ("decrease rate because of low tpt\n");
@@ -808,7 +805,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
  out:
 
 	sta->last_txrate_idx = index;
-	if (priv->band == IEEE80211_BAND_5GHZ)
+	if (sband->band == IEEE80211_BAND_5GHZ)
 		sta->txrate_idx = sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
 	else
 		sta->txrate_idx = sta->last_txrate_idx;
@@ -817,7 +814,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 
 	IWL_DEBUG_RATE("leave: %d\n", index);
 
-	sel->rate = &priv->ieee_rates[index];
+	sel->rate = &sband->bitrates[sta->txrate_idx];
 }
 
 static struct rate_control_ops rs_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index 3c61f08..b082a09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -159,7 +159,7 @@ enum {
 
 #define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
 
-#define IWL_INVALID_VALUE    -1
+#define IWL_INV_TPT    -1
 
 #define IWL_MIN_RSSI_VAL                 -100
 #define IWL_MAX_RSSI_VAL                    0
-- 
1.5.3.4

