Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab0DPVwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/21] iwlwifi: remove scan_bands logic
Date: Fri, 16 Apr 2010 14:52:19 -0700
Message-Id: <1271454758-14351-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since mac80211 will now never request scanning
multiple bands, we can remove all the associated
logic and scan a single band only in each scan.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   59 ++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 +++----
 3 files changed, 25 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b2d94c7..ee4cb02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1054,7 +1054,7 @@ struct iwl_priv {
 	unsigned long scan_pass_start;
 	unsigned long scan_start_tsf;
 	void *scan;
-	int scan_bands;
+	enum ieee80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
 	bool is_internal_short_scan;
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c3b06c4..3904bb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -223,29 +223,16 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 
 	IWL_DEBUG_INFO(priv, "Scan pass on %sGHz took %dms\n",
-		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
-						"2.4" : "5.2",
+		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_pass_start, jiffies)));
 
-	/* Remove this scanned band from the list of pending
-	 * bands to scan, band G precedes A in order of scanning
-	 * as seen in iwl_bg_request_scan */
-	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ))
-		priv->scan_bands &= ~BIT(IEEE80211_BAND_2GHZ);
-	else if (priv->scan_bands &  BIT(IEEE80211_BAND_5GHZ))
-		priv->scan_bands &= ~BIT(IEEE80211_BAND_5GHZ);
-
 	/* If a request to abort was given, or the scan did not succeed
 	 * then we reset the scan state machine and terminate,
 	 * re-queuing another scan if one has been requested */
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-	} else {
-		/* If there are more bands on this scan pass reschedule */
-		if (priv->scan_bands)
-			goto reschedule;
 	}
 
 	if (!priv->is_internal_short_scan)
@@ -259,12 +246,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
 
 	queue_work(priv->workqueue, &priv->scan_completed);
-
-	return;
-
-reschedule:
-	priv->scan_pass_start = jiffies;
-	queue_work(priv->workqueue, &priv->request_scan);
 }
 
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
@@ -489,10 +470,13 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 {
 	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
-	int ret, i;
+	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
+	if (req->n_channels == 0)
+		return -EINVAL;
+
 	mutex_lock(&priv->mutex);
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -526,10 +510,8 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	priv->scan_bands = 0;
-	for (i = 0; i < req->n_channels; i++)
-		priv->scan_bands |= BIT(req->channels[i]->band);
-
+	/* mac80211 will only ask for one band at a time */
+	priv->scan_band = req->channels[0]->band;
 	priv->scan_request = req;
 
 	ret = iwl_scan_initiate(priv);
@@ -575,11 +557,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 		goto unlock;
 	}
 
-	priv->scan_bands = 0;
-	if (priv->band == IEEE80211_BAND_5GHZ)
-		priv->scan_bands |= BIT(IEEE80211_BAND_5GHZ);
-	else
-		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
+	priv->scan_band = priv->band;
 
 	IWL_DEBUG_SCAN(priv, "Start internal short scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
@@ -727,11 +705,6 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (!priv->scan_bands) {
-		IWL_DEBUG_HC(priv, "Aborting scan due to no requested bands\n");
-		goto done;
-	}
-
 	if (!priv->scan) {
 		priv->scan = kmalloc(sizeof(struct iwl_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
@@ -798,9 +771,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
-
-	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) {
-		band = IEEE80211_BAND_2GHZ;
+	switch (priv->scan_band) {
+	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		chan_mod = le32_to_cpu(priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_MSK)
 				       >> RXON_FLG_CHANNEL_MODE_POS;
@@ -811,8 +783,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 			rate_flags = RATE_MCS_CCK_MSK;
 		}
 		scan->good_CRC_th = 0;
-	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
-		band = IEEE80211_BAND_5GHZ;
+		break;
+	case IEEE80211_BAND_5GHZ:
 		rate = IWL_RATE_6M_PLCP;
 		/*
 		 * If active scaning is requested but a certain channel
@@ -827,13 +799,16 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		 */
 		if (priv->cfg->off_channel_workaround)
 			rx_ant = ANT_BC;
-	} else {
+		break;
+	default:
 		IWL_WARN(priv, "Invalid scan band count\n");
 		goto done;
 	}
 
+	band = priv->scan_band;
+
 	priv->scan_tx_ant[band] =
-			 iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
+			iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
 	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
 	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 24e9694..e266695 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2852,11 +2852,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (!priv->scan_bands) {
-		IWL_DEBUG_HC(priv, "Aborting scan due to no requested bands\n");
-		goto done;
-	}
-
 	if (!priv->scan) {
 		priv->scan = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
@@ -2934,12 +2929,14 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	/* flags + rate selection */
 
-	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) {
+	switch (priv->scan_band) {
+	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate = IWL_RATE_1M_PLCP;
 		scan->good_CRC_th = 0;
 		band = IEEE80211_BAND_2GHZ;
-	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
+		break;
+	case IEEE80211_BAND_5GHZ:
 		scan->tx_cmd.rate = IWL_RATE_6M_PLCP;
 		/*
 		 * If active scaning is requested but a certain channel
@@ -2948,8 +2945,9 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		 */
 		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
 		band = IEEE80211_BAND_5GHZ;
-	} else {
-		IWL_WARN(priv, "Invalid scan band count\n");
+		break;
+	default:
+		IWL_WARN(priv, "Invalid scan band\n");
 		goto done;
 	}
 
-- 
1.6.3.3

