Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:55755 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932962Ab2DKTx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:57 -0400
Received: by lagu2 with SMTP id u2so1387529lag.21
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:49 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 01/24] wlcore/wl12xx: set the number of Tx descriptors per chip family
Date: Wed, 11 Apr 2012 22:53:17 +0300
Message-Id: <1334174020-18957-2-git-send-email-coelho@ti.com> (sfid-20120411_215458_376419_DD943621)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Each chip family can have a different amount of Tx descriptors. These
are set on init.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wlcore/acx.c    |    2 +-
 drivers/net/wireless/ti/wlcore/main.c   |    4 +++-
 drivers/net/wireless/ti/wlcore/tx.c     |   10 +++++-----
 drivers/net/wireless/ti/wlcore/wl12xx.h |    2 --
 drivers/net/wireless/ti/wlcore/wlcore.h |   10 ++++++++--
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index e05a1cf..57c70a4 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -674,6 +674,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->ops = &wl12xx_ops;
 	wl->ptable = wl12xx_ptable;
 	wl->rtable = wl12xx_rtable;
+	wl->num_tx_desc = 16;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index cba8af2..c811f75 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -978,7 +978,7 @@ int wl12xx_acx_mem_cfg(struct wl1271 *wl)
 	mem_conf->rx_mem_block_num = mem->rx_block_num;
 	mem_conf->tx_min_mem_block_num = mem->tx_min_block_num;
 	mem_conf->num_ssid_profiles = mem->ssid_profiles;
-	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
+	mem_conf->total_tx_descriptors = cpu_to_le32(wl->num_tx_desc);
 	mem_conf->dyn_mem_enable = mem->dynamic_memory;
 	mem_conf->tx_free_req = mem->min_req_tx_blocks;
 	mem_conf->rx_free_req = mem->min_req_rx_blocks;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2e29baf..7b39a86 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5269,7 +5269,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	__set_bit(WL12XX_SYSTEM_HLID, wl->links_map);
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
-	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
+	for (i = 0; i < wl->num_tx_desc; i++)
 		wl->tx_frames[i] = NULL;
 
 	spin_lock_init(&wl->wl_lock);
@@ -5411,6 +5411,8 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 		goto out_free_hw;
 	}
 
+	BUG_ON(wl->num_tx_desc > WLCORE_MAX_TX_DESCRIPTORS);
+
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->ref_clock = pdata->board_ref_clock;
 	wl->tcxo_clock = pdata->board_tcxo_clock;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 176b950..815d0ac 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -61,8 +61,8 @@ static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 {
 	int id;
 
-	id = find_first_zero_bit(wl->tx_frames_map, ACX_TX_DESCRIPTORS);
-	if (id >= ACX_TX_DESCRIPTORS)
+	id = find_first_zero_bit(wl->tx_frames_map, wl->num_tx_desc);
+	if (id >= wl->num_tx_desc)
 		return -EBUSY;
 
 	__set_bit(id, wl->tx_frames_map);
@@ -74,7 +74,7 @@ static int wl1271_alloc_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 {
 	if (__test_and_clear_bit(id, wl->tx_frames_map)) {
-		if (unlikely(wl->tx_frames_cnt == ACX_TX_DESCRIPTORS))
+		if (unlikely(wl->tx_frames_cnt == wl->num_tx_desc))
 			clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
 		wl->tx_frames[id] = NULL;
@@ -818,7 +818,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	u8 retries = 0;
 
 	/* check for id legality */
-	if (unlikely(id >= ACX_TX_DESCRIPTORS || wl->tx_frames[id] == NULL)) {
+	if (unlikely(id >= wl->num_tx_desc || wl->tx_frames[id] == NULL)) {
 		wl1271_warning("TX result illegal id: %d", id);
 		return;
 	}
@@ -1011,7 +1011,7 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 	if (reset_tx_queues)
 		wl1271_handle_tx_low_watermark(wl);
 
-	for (i = 0; i < ACX_TX_DESCRIPTORS; i++) {
+	for (i = 0; i < wl->num_tx_desc; i++) {
 		if (wl->tx_frames[i] == NULL)
 			continue;
 
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index b4db4cc..1516622 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -89,8 +89,6 @@
 #define WL1271_AP_BSS_INDEX        0
 #define WL1271_AP_DEF_BEACON_EXP   20
 
-#define ACX_TX_DESCRIPTORS         16
-
 #define WL1271_AGGR_BUFFER_SIZE (4 * PAGE_SIZE)
 
 enum wl1271_state {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 01ac091..a4f576d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -27,6 +27,9 @@
 #include "wl12xx.h"
 #include "event.h"
 
+/* The maximum number of Tx descriptors in all chip families */
+#define WLCORE_MAX_TX_DESCRIPTORS 32
+
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
@@ -174,8 +177,8 @@ struct wl1271 {
 	struct workqueue_struct *freezable_wq;
 
 	/* Pending TX frames */
-	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
-	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
+	unsigned long tx_frames_map[BITS_TO_LONGS(WLCORE_MAX_TX_DESCRIPTORS)];
+	struct sk_buff *tx_frames[WLCORE_MAX_TX_DESCRIPTORS];
 	int tx_frames_cnt;
 
 	/* FW Rx counter */
@@ -303,6 +306,9 @@ struct wl1271 {
 
 	/* per-chip-family private structure */
 	void *priv;
+
+	/* number of TX descriptors the HW supports. */
+	u32 num_tx_desc;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.5.4

