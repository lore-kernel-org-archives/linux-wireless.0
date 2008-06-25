Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbYFYIr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 04:47:27 -0400
Date: Wed, 25 Jun 2008 16:46:31 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: iwlwifi: improve scanning band selection management
Message-ID: <20080625084631.GA23728@mail.intel.com> (sfid-20080625_104732_938111_1182A5E4)
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch modifies the band selection management when scanning, so
bands are now scanned according to HW band support.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
John, this patch is for 2.6.26. I'll submit a separate patch for
wireless-testing later.

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 13925b6..b1b3c52 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2227,7 +2227,10 @@ static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
 	}
 
 	IWL_DEBUG_INFO("Starting scan...\n");
-	priv->scan_bands = 2;
+	if (priv->cfg->sku & IWL_SKU_G)
+		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
+	if (priv->cfg->sku & IWL_SKU_A)
+		priv->scan_bands |= BIT(IEEE80211_BAND_5GHZ);
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->scan_start = jiffies;
 	priv->scan_pass_start = priv->scan_start;
@@ -3352,13 +3355,18 @@ static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
 	cancel_delayed_work(&priv->scan_check);
 
 	IWL_DEBUG_INFO("Scan pass on %sGHz took %dms\n",
-		       (priv->scan_bands == 2) ? "2.4" : "5.2",
+		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
+							"2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_pass_start, jiffies)));
 
-	/* Remove this scanned band from the list
-	 * of pending bands to scan */
-	priv->scan_bands--;
+	/* Remove this scanned band from the list of pending
+	 * bands to scan, band G precedes A in order of scanning
+	 * as seen in iwl3945_bg_request_scan */
+	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ))
+		priv->scan_bands &= ~BIT(IEEE80211_BAND_2GHZ);
+	else if (priv->scan_bands &  BIT(IEEE80211_BAND_5GHZ))
+		priv->scan_bands &= ~BIT(IEEE80211_BAND_5GHZ);
 
 	/* If a request to abort was given, or the scan did not succeed
 	 * then we reset the scan state machine and terminate,
@@ -4972,7 +4980,7 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 
 		ch_info = iwl3945_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
+			IWL_DEBUG_SCAN("Channel %d is INVALID for this band.\n",
 				       scan_ch->channel);
 			continue;
 		}
@@ -6315,21 +6323,16 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	/* flags + rate selection */
 
-	switch (priv->scan_bands) {
-	case 2:
+	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) {
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate = IWL_RATE_1M_PLCP;
 		scan->good_CRC_th = 0;
 		band = IEEE80211_BAND_2GHZ;
-		break;
-
-	case 1:
+	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
 		scan->tx_cmd.rate = IWL_RATE_6M_PLCP;
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
 		band = IEEE80211_BAND_5GHZ;
-		break;
-
-	default:
+	} else {
 		IWL_WARNING("Invalid scan band count\n");
 		goto done;
 	}
@@ -6770,7 +6773,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	ch_info = iwl3945_get_channel_info(priv, conf->channel->band,
 					   conf->channel->hw_value);
 	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this SKU.\n",
+		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this band.\n",
 			       conf->channel->hw_value, conf->channel->band);
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 883b42f..5ed16ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1774,7 +1774,10 @@ static int iwl4965_scan_initiate(struct iwl_priv *priv)
 	}
 
 	IWL_DEBUG_INFO("Starting scan...\n");
-	priv->scan_bands = 2;
+	if (priv->cfg->sku & IWL_SKU_G)
+		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
+	if (priv->cfg->sku & IWL_SKU_A)
+		priv->scan_bands |= BIT(IEEE80211_BAND_5GHZ);
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->scan_start = jiffies;
 	priv->scan_pass_start = priv->scan_start;
@@ -3023,8 +3026,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 	if (index != -1) {
-		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
 #ifdef CONFIG_IWL4965_HT
+		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+
 		if (tid != MAX_TID_COUNT)
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
@@ -3276,13 +3280,18 @@ static void iwl4965_rx_scan_complete_notif(struct iwl_priv *priv,
 	cancel_delayed_work(&priv->scan_check);
 
 	IWL_DEBUG_INFO("Scan pass on %sGHz took %dms\n",
-		       (priv->scan_bands == 2) ? "2.4" : "5.2",
+		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
+						"2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_pass_start, jiffies)));
 
-	/* Remove this scanned band from the list
-	 * of pending bands to scan */
-	priv->scan_bands--;
+	/* Remove this scanned band from the list of pending
+	 * bands to scan, band G precedes A in order of scanning
+	 * as seen in iwl_bg_request_scan */
+	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ))
+		priv->scan_bands &= ~BIT(IEEE80211_BAND_2GHZ);
+	else if (priv->scan_bands &  BIT(IEEE80211_BAND_5GHZ))
+		priv->scan_bands &= ~BIT(IEEE80211_BAND_5GHZ);
 
 	/* If a request to abort was given, or the scan did not succeed
 	 * then we reset the scan state machine and terminate,
@@ -3292,7 +3301,7 @@ static void iwl4965_rx_scan_complete_notif(struct iwl_priv *priv,
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	} else {
 		/* If there are more bands on this scan pass reschedule */
-		if (priv->scan_bands > 0)
+		if (priv->scan_bands)
 			goto reschedule;
 	}
 
@@ -4635,10 +4644,9 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 
 		scan_ch->channel = ieee80211_frequency_to_channel(channels[i].center_freq);
 
-		ch_info = iwl_get_channel_info(priv, band,
-					 scan_ch->channel);
+		ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
+			IWL_DEBUG_SCAN("Channel %d is INVALID for this band.\n",
 				       scan_ch->channel);
 			continue;
 		}
@@ -5830,8 +5838,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 
-	switch (priv->scan_bands) {
-	case 2:
+	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) {
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate_n_flags =
 				iwl4965_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
@@ -5839,17 +5846,13 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 
 		scan->good_CRC_th = 0;
 		band = IEEE80211_BAND_2GHZ;
-		break;
-
-	case 1:
+	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
 		scan->tx_cmd.rate_n_flags =
 				iwl4965_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
 				RATE_MCS_ANT_B_MSK);
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
 		band = IEEE80211_BAND_5GHZ;
-		break;
-
-	default:
+	} else {
 		IWL_WARNING("Invalid scan band count\n");
 		goto done;
 	}
