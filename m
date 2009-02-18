Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZBRXuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwl3945: use iwl_rx_scan handlers
Date: Wed, 18 Feb 2009 15:54:26 -0800
Message-Id: <1235001273-7808-2-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005042_984152_1F7EEBED)
In-Reply-To: <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch makes use of iwl_rx_scan handler for 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  128 +--------------------------
 1 files changed, 1 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f78a69a..cbd8871 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1518,127 +1518,6 @@ static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 		queue_work(priv->workqueue, &priv->beacon_update);
 }
 
-/* Service response to REPLY_SCAN_CMD (0x80) */
-static void iwl3945_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanreq_notification *notif =
-	    (struct iwl_scanreq_notification *)pkt->u.raw;
-
-	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
-#endif
-}
-
-/* Service SCAN_START_NOTIFICATION (0x82) */
-static void iwl3945_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanstart_notification *notif =
-	    (struct iwl_scanstart_notification *)pkt->u.raw;
-	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
-	IWL_DEBUG_SCAN(priv, "Scan start: "
-		       "%d [802.11%s] "
-		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
-		       notif->channel,
-		       notif->band ? "bg" : "a",
-		       notif->tsf_high,
-		       notif->tsf_low, notif->status, notif->beacon_timer);
-}
-
-/* Service SCAN_RESULTS_NOTIFICATION (0x83) */
-static void iwl3945_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scanresults_notification *notif =
-	    (struct iwl_scanresults_notification *)pkt->u.raw;
-#endif
-
-	IWL_DEBUG_SCAN(priv, "Scan ch.res: "
-		       "%d [802.11%s] "
-		       "(TSF: 0x%08X:%08X) - %d "
-		       "elapsed=%lu usec (%dms since last)\n",
-		       notif->channel,
-		       notif->band ? "bg" : "a",
-		       le32_to_cpu(notif->tsf_high),
-		       le32_to_cpu(notif->tsf_low),
-		       le32_to_cpu(notif->statistics[0]),
-		       le32_to_cpu(notif->tsf_low) - priv->scan_start_tsf,
-		       jiffies_to_msecs(elapsed_jiffies
-					(priv->last_scan_jiffies, jiffies)));
-
-	priv->last_scan_jiffies = jiffies;
-	priv->next_scan_jiffies = 0;
-}
-
-/* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
-static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
-#endif
-
-	IWL_DEBUG_SCAN(priv, "Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
-		       scan_notif->scanned_channels,
-		       scan_notif->tsf_low,
-		       scan_notif->tsf_high, scan_notif->status);
-
-	/* The HW is no longer scanning */
-	clear_bit(STATUS_SCAN_HW, &priv->status);
-
-	/* The scan completion notification came in, so kill that timer... */
-	cancel_delayed_work(&priv->scan_check);
-
-	IWL_DEBUG_INFO(priv, "Scan pass on %sGHz took %dms\n",
-		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
-							"2.4" : "5.2",
-		       jiffies_to_msecs(elapsed_jiffies
-					(priv->scan_pass_start, jiffies)));
-
-	/* Remove this scanned band from the list of pending
-	 * bands to scan, band G precedes A in order of scanning
-	 * as seen in iwl3945_bg_request_scan */
-	if (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ))
-		priv->scan_bands &= ~BIT(IEEE80211_BAND_2GHZ);
-	else if (priv->scan_bands &  BIT(IEEE80211_BAND_5GHZ))
-		priv->scan_bands &= ~BIT(IEEE80211_BAND_5GHZ);
-
-	/* If a request to abort was given, or the scan did not succeed
-	 * then we reset the scan state machine and terminate,
-	 * re-queuing another scan if one has been requested */
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-	} else {
-		/* If there are more bands on this scan pass reschedule */
-		if (priv->scan_bands > 0)
-			goto reschedule;
-	}
-
-	priv->last_scan_jiffies = jiffies;
-	priv->next_scan_jiffies = 0;
-	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
-
-	clear_bit(STATUS_SCANNING, &priv->status);
-
-	IWL_DEBUG_INFO(priv, "Scan took %dms\n",
-		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
-
-	queue_work(priv->workqueue, &priv->scan_completed);
-
-	return;
-
-reschedule:
-	priv->scan_pass_start = jiffies;
-	queue_work(priv->workqueue, &priv->request_scan);
-}
-
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
@@ -1707,12 +1586,7 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl3945_hw_rx_statistics;
 	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl3945_hw_rx_statistics;
 
-	priv->rx_handlers[REPLY_SCAN_CMD] = iwl3945_rx_reply_scan;
-	priv->rx_handlers[SCAN_START_NOTIFICATION] = iwl3945_rx_scan_start_notif;
-	priv->rx_handlers[SCAN_RESULTS_NOTIFICATION] =
-	    iwl3945_rx_scan_results_notif;
-	priv->rx_handlers[SCAN_COMPLETE_NOTIFICATION] =
-	    iwl3945_rx_scan_complete_notif;
+	iwl_setup_rx_scan_handlers(priv);
 	priv->rx_handlers[CARD_STATE_NOTIFICATION] = iwl3945_rx_card_state_notif;
 
 	/* Set up hardware specific Rx handlers */
-- 
1.5.4.3

