Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57261 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022Ab2DKTyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:14 -0400
Received: by lahl5 with SMTP id l5so938690lah.15
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:11 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 24/24] wlcore/wl12xx: adapt FW status for multiple families
Date: Wed, 11 Apr 2012 22:53:40 +0300
Message-Id: <1334174020-18957-25-git-send-email-coelho@ti.com> (sfid-20120411_215439_776700_6E6AD04A)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Add room for a private data struct at the end of the common FW status.
Add a convenience "counters" struct inside the FW status.

The wl12xx family does not currently use the FW status private data.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wlcore/main.c   |   18 +++++++++++-------
 drivers/net/wireless/ti/wlcore/rx.c     |    2 +-
 drivers/net/wireless/ti/wlcore/rx.h     |    2 +-
 drivers/net/wireless/ti/wlcore/wl12xx.h |   27 ++++++++++++++++++---------
 drivers/net/wireless/ti/wlcore/wlcore.h |    5 ++++-
 6 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index be48c47..d7dd3de 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1343,6 +1343,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
+	wl->fw_status_priv_len = 0;
 	memcpy(&wl->ht_cap, &wl12xx_ht_cap, sizeof(wl12xx_ht_cap));
 	wl12xx_conf_init(wl);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b80f08b..63658f5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -387,7 +387,7 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 
 static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 					   struct wl12xx_vif *wlvif,
-					   struct wl12xx_fw_status *status)
+					   struct wl_fw_status *status)
 {
 	struct wl1271_link *lnk;
 	u32 cur_fw_ps_map;
@@ -407,9 +407,10 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 
 	for_each_set_bit(hlid, wlvif->ap.sta_hlid_map, WL12XX_MAX_LINKS) {
 		lnk = &wl->links[hlid];
-		cnt = status->tx_lnk_free_pkts[hlid] - lnk->prev_freed_pkts;
+		cnt = status->counters.tx_lnk_free_pkts[hlid] -
+			lnk->prev_freed_pkts;
 
-		lnk->prev_freed_pkts = status->tx_lnk_free_pkts[hlid];
+		lnk->prev_freed_pkts = status->counters.tx_lnk_free_pkts[hlid];
 		lnk->allocated_pkts -= cnt;
 
 		wl12xx_irq_ps_regulate_link(wl, wlvif, hlid,
@@ -418,16 +419,19 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 }
 
 static void wl12xx_fw_status(struct wl1271 *wl,
-			     struct wl12xx_fw_status *status)
+			     struct wl_fw_status *status)
 {
 	struct wl12xx_vif *wlvif;
 	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
 	int avail, freed_blocks;
 	int i;
+	size_t status_len;
+
+	status_len = sizeof(*status) + wl->fw_status_priv_len;
 
 	wlcore_raw_read_data(wl, REG_RAW_FW_STATUS_ADDR, status,
-			     sizeof(*status), false);
+			     status_len, false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -439,10 +443,10 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		/* prevent wrap-around in freed-packets counter */
 		wl->tx_allocated_pkts[i] -=
-				(status->tx_released_pkts[i] -
+				(status->counters.tx_released_pkts[i] -
 				wl->tx_pkts_freed[i]) & 0xff;
 
-		wl->tx_pkts_freed[i] = status->tx_released_pkts[i];
+		wl->tx_pkts_freed[i] = status->counters.tx_released_pkts[i];
 	}
 
 	/* prevent wrap-around in total blocks counter */
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 6bde6e2..89bd938 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -199,7 +199,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	return is_data;
 }
 
-void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
+void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status)
 {
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	u32 buf_size;
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 18eb38b..6e129e2 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -136,7 +136,7 @@ struct wl1271_rx_descriptor {
 	u8  reserved;
 } __packed;
 
-void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status);
+void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index b09c9ed..a9b220c 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -145,8 +145,21 @@ struct wl1271_stats {
 
 #define AP_MAX_STATIONS            8
 
+struct wl_fw_packet_counters {
+	/* Cumulative counter of released packets per AC */
+	u8 tx_released_pkts[NUM_TX_QUEUES];
+
+	/* Cumulative counter of freed packets per HLID */
+	u8 tx_lnk_free_pkts[WL12XX_MAX_LINKS];
+
+	/* Cumulative counter of released Voice memory blocks */
+	u8 tx_voice_released_blks;
+
+	u8 padding[3];
+} __packed;
+
 /* FW status registers */
-struct wl12xx_fw_status {
+struct wl_fw_status {
 	__le32 intr;
 	u8  fw_rx_counter;
 	u8  drv_rx_counter;
@@ -173,16 +186,12 @@ struct wl12xx_fw_status {
 	/* Size (in Memory Blocks) of TX pool */
 	__le32 tx_total;
 
-	/* Cumulative counter of released packets per AC */
-	u8 tx_released_pkts[NUM_TX_QUEUES];
+	struct wl_fw_packet_counters counters;
 
-	/* Cumulative counter of freed packets per HLID */
-	u8 tx_lnk_free_pkts[WL12XX_MAX_LINKS];
-
-	/* Cumulative counter of released Voice memory blocks */
-	u8 tx_voice_released_blks;
-	u8 padding_1[3];
 	__le32 log_start_addr;
+
+	/* Private status to be used by the lower drivers */
+	u8 priv[0];
 } __packed;
 
 struct wl1271_rx_mem_pool_addr {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 960aefb..39f9fad 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -260,7 +260,7 @@ struct wl1271 {
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 
-	struct wl12xx_fw_status *fw_status;
+	struct wl_fw_status *fw_status;
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
 	/* Current chipset configuration */
@@ -346,6 +346,9 @@ struct wl1271 {
 
 	/* HW HT (11n) capabilities */
 	struct ieee80211_sta_ht_cap ht_cap;
+
+	/* size of the private FW status data */
+	size_t fw_status_priv_len;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.5.4

