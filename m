Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51856 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2EREq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 00:46:56 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so1565076wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 21:46:56 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 5/5] wlcore/wl12xx/wl18xx: implement op_set_key per HW arch
Date: Fri, 18 May 2012 07:46:40 +0300
Message-Id: <1337316400-23875-6-git-send-email-arik@wizery.com> (sfid-20120518_064700_554640_B521545F)
In-Reply-To: <1337316400-23875-1-git-send-email-arik@wizery.com>
References: <1337316400-23875-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 12xx set_key just calls the common wlcore_set_key function, in order
to program the keys into the FW.

The 18xx variant changes the spare block count when a GEM or TKIP
key is set. Also modify the get_spare_blocks HW op for 18xx to return
the correct numbers of spare blocks, according to what is currently
set in FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    9 +++
 drivers/net/wireless/ti/wl18xx/acx.c    |    4 ++
 drivers/net/wireless/ti/wl18xx/main.c   |   96 +++++++++++++++++++++++++++----
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    3 +
 drivers/net/wireless/ti/wlcore/hw_ops.h |   12 ++++
 drivers/net/wireless/ti/wlcore/main.c   |   14 ++++-
 drivers/net/wireless/ti/wlcore/tx.c     |    3 +
 drivers/net/wireless/ti/wlcore/tx.h     |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |    8 +++
 9 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 94ca51a..4ed23aa 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1375,6 +1375,14 @@ static int wl12xx_get_spare_blocks(struct wl1271 *wl, bool is_gem)
 	return WL12XX_TX_HW_BLOCK_SPARE_DEFAULT;
 }
 
+static int wl12xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key_conf)
+{
+	return wlcore_set_key(wl, cmd, vif, sta, key_conf);
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
@@ -1399,6 +1407,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.ap_get_mimo_wide_rate_mask = NULL,
 	.debugfs_init		= wl12xx_debugfs_add_files,
 	.get_spare_blocks	= wl12xx_get_spare_blocks,
+	.set_key		= wl12xx_set_key,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 3379db2..01ba403 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -32,6 +32,10 @@ int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 	struct wl18xx_acx_host_config_bitmap *bitmap_conf;
 	int ret;
 
+	wl1271_debug(DEBUG_ACX, "acx cfg bitmap %d blk %d spare %d field %d",
+		     host_cfg_bitmap, sdio_blk_size, extra_mem_blks,
+		     len_field_size);
+
 	bitmap_conf = kzalloc(sizeof(*bitmap_conf), GFP_KERNEL);
 	if (!bitmap_conf) {
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5b51410..1e8f690 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -851,17 +851,12 @@ static void wl18xx_tx_immediate_completion(struct wl1271 *wl)
 	wl18xx_tx_immediate_complete(wl);
 }
 
-static int wl18xx_hw_init(struct wl1271 *wl)
+static int wl18xx_set_host_cfg_bitmap(struct wl1271 *wl, u32 extra_mem_blk)
 {
 	int ret;
-	struct wl18xx_priv *priv = wl->priv;
-	u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE |
-		HOST_IF_CFG_ADD_RX_ALIGNMENT;
-
 	u32 sdio_align_size = 0;
-
-	/* (re)init private structures. Relevant on recovery as well. */
-	priv->last_fw_rls_idx = 0;
+	u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE |
+			      HOST_IF_CFG_ADD_RX_ALIGNMENT;
 
 	/* Enable Tx SDIO padding */
 	if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN) {
@@ -876,12 +871,28 @@ static int wl18xx_hw_init(struct wl1271 *wl)
 	}
 
 	ret = wl18xx_acx_host_if_cfg_bitmap(wl, host_cfg_bitmap,
-					    sdio_align_size,
-					    WL18XX_TX_HW_EXTRA_BLOCK_SPARE,
+					    sdio_align_size, extra_mem_blk,
 					    WL18XX_HOST_IF_LEN_SIZE_FIELD);
 	if (ret < 0)
 		return ret;
 
+	return 0;
+}
+
+static int wl18xx_hw_init(struct wl1271 *wl)
+{
+	int ret;
+	struct wl18xx_priv *priv = wl->priv;
+
+	/* (re)init private structures. Relevant on recovery as well. */
+	priv->last_fw_rls_idx = 0;
+	priv->extra_spare_vif_count = 0;
+
+	/* set the default amount of spare blocks in the bitmap */
+	ret = wl18xx_set_host_cfg_bitmap(wl, WL18XX_TX_HW_BLOCK_SPARE);
+	if (ret < 0)
+		return ret;
+
 	if (checksum_param) {
 		ret = wl18xx_acx_set_checksum_state(wl);
 		if (ret != 0)
@@ -1039,8 +1050,68 @@ static int wl18xx_handle_static_data(struct wl1271 *wl,
 
 static int wl18xx_get_spare_blocks(struct wl1271 *wl, bool is_gem)
 {
-	/* TODO: dynamically change to extra only when we have GEM or TKIP */
-	return WL18XX_TX_HW_EXTRA_BLOCK_SPARE;
+	struct wl18xx_priv *priv = wl->priv;
+
+	/* If we have VIFs requiring extra spare, indulge them */
+	if (priv->extra_spare_vif_count)
+		return WL18XX_TX_HW_EXTRA_BLOCK_SPARE;
+
+	return WL18XX_TX_HW_BLOCK_SPARE;
+}
+
+static int wl18xx_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key_conf)
+{
+	struct wl18xx_priv *priv = wl->priv;
+	bool change_spare = false;
+	int ret;
+
+	/*
+	 * when adding the first or removing the last GEM/TKIP interface,
+	 * we have to adjust the number of spare blocks.
+	 */
+	change_spare = (key_conf->cipher == WL1271_CIPHER_SUITE_GEM ||
+		key_conf->cipher == WLAN_CIPHER_SUITE_TKIP) &&
+		((priv->extra_spare_vif_count == 0 && cmd == SET_KEY) ||
+		 (priv->extra_spare_vif_count == 1 && cmd == DISABLE_KEY));
+
+	/* no need to change spare - just regular set_key */
+	if (!change_spare)
+		return wlcore_set_key(wl, cmd, vif, sta, key_conf);
+
+	/*
+	 * stop the queues and flush to ensure the next packets are
+	 * in sync with FW spare block accounting
+	 */
+	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
+	wl1271_tx_flush(wl);
+
+	ret = wlcore_set_key(wl, cmd, vif, sta, key_conf);
+	if (ret < 0)
+		goto out;
+
+	/* key is now set, change the spare blocks */
+	if (cmd == SET_KEY) {
+		ret = wl18xx_set_host_cfg_bitmap(wl,
+					WL18XX_TX_HW_EXTRA_BLOCK_SPARE);
+		if (ret < 0)
+			goto out;
+
+		priv->extra_spare_vif_count++;
+	} else {
+		ret = wl18xx_set_host_cfg_bitmap(wl,
+					WL18XX_TX_HW_BLOCK_SPARE);
+		if (ret < 0)
+			goto out;
+
+		priv->extra_spare_vif_count--;
+	}
+
+out:
+	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
+	return ret;
 }
 
 static struct wlcore_ops wl18xx_ops = {
@@ -1066,6 +1137,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.debugfs_init	= wl18xx_debugfs_add_files,
 	.handle_static_data	= wl18xx_handle_static_data,
 	.get_spare_blocks = wl18xx_get_spare_blocks,
+	.set_key	= wl18xx_set_key,
 };
 
 /* HT cap appropriate for wide channels */
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 34e202b..b9c4309 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -36,6 +36,9 @@ struct wl18xx_priv {
 	u8 last_fw_rls_idx;
 
 	u8 board_type;
+
+	/* number of VIFs requiring extra spare mem-blocks */
+	int extra_spare_vif_count;
 };
 
 #define WL18XX_FW_MAX_TX_STATUS_DESC 33
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 2cb3521..34e0498 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -176,4 +176,16 @@ wlcore_hw_get_spare_blocks(struct wl1271 *wl, bool is_gem)
 	return wl->ops->get_spare_blocks(wl, is_gem);
 }
 
+static inline int
+wlcore_hw_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
+		  struct ieee80211_vif *vif,
+		  struct ieee80211_sta *sta,
+		  struct ieee80211_key_conf *key_conf)
+{
+	if (!wl->ops->set_key)
+		BUG_ON(1);
+
+	return wl->ops->set_key(wl, cmd, vif, sta, key_conf);
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1daaf1d..fe46a5b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2885,12 +2885,21 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	return 0;
 }
 
-static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int wlcore_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta,
 			     struct ieee80211_key_conf *key_conf)
 {
 	struct wl1271 *wl = hw->priv;
+
+	return wlcore_hw_set_key(wl, cmd, vif, sta, key_conf);
+}
+
+int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key_conf)
+{
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 	u32 tx_seq_32 = 0;
@@ -3001,6 +3010,7 @@ out_unlock:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wlcore_set_key);
 
 static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
@@ -4646,7 +4656,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
 	.tx = wl1271_op_tx,
-	.set_key = wl1271_op_set_key,
+	.set_key = wlcore_op_set_key,
 	.hw_scan = wl1271_op_hw_scan,
 	.cancel_hw_scan = wl1271_op_cancel_hw_scan,
 	.sched_scan_start = wl1271_op_sched_scan_start,
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 78bf1b9..da9a07d 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1055,6 +1055,7 @@ out:
 	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FLUSH);
 	mutex_unlock(&wl->flush_mutex);
 }
+EXPORT_SYMBOL_GPL(wl1271_tx_flush);
 
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
 {
@@ -1115,6 +1116,7 @@ void wlcore_stop_queues(struct wl1271 *wl,
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wlcore_stop_queue(wl, i, reason);
 }
+EXPORT_SYMBOL_GPL(wlcore_stop_queues);
 
 void wlcore_wake_queues(struct wl1271 *wl,
 			enum wlcore_queue_stop_reason reason)
@@ -1124,6 +1126,7 @@ void wlcore_wake_queues(struct wl1271 *wl,
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wlcore_wake_queue(wl, i, reason);
 }
+EXPORT_SYMBOL_GPL(wlcore_wake_queues);
 
 void wlcore_reset_stopped_queues(struct wl1271 *wl)
 {
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index e058a55..49e441f 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -188,6 +188,7 @@ enum wlcore_queue_stop_reason {
 	WLCORE_QUEUE_STOP_REASON_WATERMARK,
 	WLCORE_QUEUE_STOP_REASON_FW_RESTART,
 	WLCORE_QUEUE_STOP_REASON_FLUSH,
+	WLCORE_QUEUE_STOP_REASON_SPARE_BLK, /* 18xx specific */
 };
 
 static inline int wl1271_tx_get_queue(int queue)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index c065ea6..e634500 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -76,6 +76,10 @@ struct wlcore_ops {
 	int (*handle_static_data)(struct wl1271 *wl,
 				  struct wl1271_static_data *static_data);
 	int (*get_spare_blocks)(struct wl1271 *wl, bool is_gem);
+	int (*set_key)(struct wl1271 *wl, enum set_key_cmd cmd,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *key_conf);
 };
 
 enum wlcore_partitions {
@@ -388,6 +392,10 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
 int __devexit wlcore_remove(struct platform_device *pdev);
 struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size);
 int wlcore_free_hw(struct wl1271 *wl);
+int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key_conf);
 
 /* Firmware image load chunk size */
 #define CHUNK_SIZE	16384
-- 
1.7.9.5

