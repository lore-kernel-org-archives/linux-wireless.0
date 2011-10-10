Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:41 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so5615227wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:41 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/29] wl12xx: move some functions from remove_interface() to stop()
Date: Mon, 10 Oct 2011 10:12:52 +0200
Message-Id: <1318234397-21081-5-git-send-email-eliad@wizery.com> (sfid-20111010_101244_383173_471C294C)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Leave only vif-specific deinit stuff in remove_interface().
Move the global deinit (including power_off) to stop().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |  157 +++++++++++++++++++-----------------
 1 files changed, 83 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index abe5ef8..e53829a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1803,7 +1803,83 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 
 static void wl1271_op_stop(struct ieee80211_hw *hw)
 {
+	struct wl1271 *wl = hw->priv;
+	int i;
+
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
+
+	mutex_lock(&wl_list_mutex);
+	list_del(&wl->list);
+
+	/*
+	 * this must be before the cancel_work calls below, so that the work
+	 * functions don't perform further work.
+	 */
+	wl->state = WL1271_STATE_OFF;
+	mutex_unlock(&wl_list_mutex);
+
+	wl1271_disable_interrupts(wl);
+	wl1271_flush_deferred_work(wl);
+	cancel_delayed_work_sync(&wl->scan_complete_work);
+	cancel_work_sync(&wl->netstack_work);
+	cancel_work_sync(&wl->tx_work);
+	del_timer_sync(&wl->rx_streaming_timer);
+	cancel_work_sync(&wl->rx_streaming_enable_work);
+	cancel_work_sync(&wl->rx_streaming_disable_work);
+	cancel_delayed_work_sync(&wl->elp_work);
+
+	/* let's notify MAC80211 about the remaining pending TX frames */
+	wl12xx_tx_reset(wl, true);
+	mutex_lock(&wl->mutex);
+
+	wl1271_power_off(wl);
+
+	wl->band = IEEE80211_BAND_2GHZ;
+
+	wl->rx_counter = 0;
+	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
+	wl->tx_blocks_available = 0;
+	wl->tx_allocated_blocks = 0;
+	wl->tx_results_count = 0;
+	wl->tx_packets_count = 0;
+	wl->time_offset = 0;
+	wl->vif = NULL;
+	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+	wl->ap_fw_ps_map = 0;
+	wl->ap_ps_map = 0;
+	wl->sched_scanning = false;
+	memset(wl->roles_map, 0, sizeof(wl->roles_map));
+	memset(wl->links_map, 0, sizeof(wl->links_map));
+	memset(wl->roc_map, 0, sizeof(wl->roc_map));
+	wl->active_sta_count = 0;
+
+	/* The system link is always allocated */
+	__set_bit(WL12XX_SYSTEM_HLID, wl->links_map);
+
+	/*
+	 * this is performed after the cancel_work calls and the associated
+	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
+	 * get executed before all these vars have been reset.
+	 */
+	wl->flags = 0;
+
+	wl->tx_blocks_freed = 0;
+
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		wl->tx_pkts_freed[i] = 0;
+		wl->tx_allocated_pkts[i] = 0;
+	}
+
+	wl1271_debugfs_reset(wl);
+
+	kfree(wl->fw_status);
+	wl->fw_status = NULL;
+	kfree(wl->tx_res_if);
+	wl->tx_res_if = NULL;
+	kfree(wl->target_mem_map);
+	wl->target_mem_map = NULL;
+
+	mutex_unlock(&wl->mutex);
 }
 
 static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
@@ -2053,7 +2129,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	int ret, i;
+	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
@@ -2063,15 +2139,12 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 	wl1271_info("down");
 
-	mutex_lock(&wl_list_mutex);
-	list_del(&wl->list);
-	mutex_unlock(&wl_list_mutex);
-
 	/* enable dyn ps just in case (if left on due to fw crash etc) */
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
-		ieee80211_enable_dyn_ps(wl->vif);
+		ieee80211_enable_dyn_ps(vif);
 
-	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
+	if (wl->scan.state != WL1271_SCAN_STATE_IDLE &&
+	    wl->scan_vif == vif) {
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 		wl->scan_vif = NULL;
@@ -2104,82 +2177,18 @@ deinit:
 	wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
 	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
 
-	/*
-	 * this must be before the cancel_work calls below, so that the work
-	 * functions don't perform further work.
-	 */
-	wl->state = WL1271_STATE_OFF;
-
-	mutex_unlock(&wl->mutex);
-
-	wl1271_disable_interrupts(wl);
-	wl1271_flush_deferred_work(wl);
-	cancel_delayed_work_sync(&wl->scan_complete_work);
-	cancel_work_sync(&wl->netstack_work);
-	cancel_work_sync(&wl->tx_work);
-	del_timer_sync(&wl->rx_streaming_timer);
-	cancel_work_sync(&wl->rx_streaming_enable_work);
-	cancel_work_sync(&wl->rx_streaming_disable_work);
-	cancel_delayed_work_sync(&wlvif->pspoll_work);
-	cancel_delayed_work_sync(&wl->elp_work);
-
-	mutex_lock(&wl->mutex);
-
-	/* let's notify MAC80211 about the remaining pending TX frames */
 	wl12xx_tx_reset_wlvif(wl, wlvif);
-	wl12xx_tx_reset(wl, reset_tx_queues);
-	wl1271_power_off(wl);
-
-	wl->band = IEEE80211_BAND_2GHZ;
-
-	wl->rx_counter = 0;
-	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
-	wl->tx_blocks_available = 0;
-	wl->tx_allocated_blocks = 0;
-	wl->tx_results_count = 0;
-	wl->tx_packets_count = 0;
-	wl->time_offset = 0;
 	wl->bitrate_masks[IEEE80211_BAND_2GHZ] = wl->conf.tx.basic_rate;
 	wl->bitrate_masks[IEEE80211_BAND_5GHZ] = wl->conf.tx.basic_rate_5;
-	wl->vif = NULL;
-	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl1271_free_ap_keys(wl, wlvif);
 	memset(wlvif->ap.sta_hlid_map, 0, sizeof(wlvif->ap.sta_hlid_map));
-	wl->ap_fw_ps_map = 0;
-	wl->ap_ps_map = 0;
-	wl->sched_scanning = false;
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
-	memset(wl->roles_map, 0, sizeof(wl->roles_map));
-	memset(wl->links_map, 0, sizeof(wl->links_map));
-	memset(wl->roc_map, 0, sizeof(wl->roc_map));
-	wl->active_sta_count = 0;
 
-	/* The system link is always allocated */
-	__set_bit(WL12XX_SYSTEM_HLID, wl->links_map);
-
-	/*
-	 * this is performed after the cancel_work calls and the associated
-	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
-	 * get executed before all these vars have been reset.
-	 */
-	wl->flags = 0;
-
-	wl->tx_blocks_freed = 0;
-
-	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		wl->tx_pkts_freed[i] = 0;
-		wl->tx_allocated_pkts[i] = 0;
-	}
-
-	wl1271_debugfs_reset(wl);
+	mutex_unlock(&wl->mutex);
+	cancel_delayed_work_sync(&wlvif->pspoll_work);
 
-	kfree(wl->fw_status);
-	wl->fw_status = NULL;
-	kfree(wl->tx_res_if);
-	wl->tx_res_if = NULL;
-	kfree(wl->target_mem_map);
-	wl->target_mem_map = NULL;
+	mutex_lock(&wl->mutex);
 }
 
 static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
-- 
1.7.6.401.g6a319

