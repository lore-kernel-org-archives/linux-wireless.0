Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0I3ILJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 04:11:09 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so1176761bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 01:11:08 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 2/3] wl1271: Support firmware RX packet aggregation
Date: Thu, 30 Sep 2010 10:10:58 +0200
Message-Id: <1285834259-3178-3-git-send-email-ido@wizery.com>
In-Reply-To: <1285834259-3178-1-git-send-email-ido@wizery.com>
References: <1285834259-3178-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of retrieving one packet at a time from the firmware, try to
retrieve all available packets at once.
This optimization decreases the number of transactions, which saves
CPU cycles and increases network throughput.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    5 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   15 ++++++-
 drivers/net/wireless/wl12xx/wl1271_rx.c   |   63 +++++++++++++++++++++-------
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 779b130..8a4cd76 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -130,6 +130,8 @@ enum {
 
 #define ACX_TX_DESCRIPTORS         32
 
+#define WL1271_AGGR_BUFFER_SIZE (4 * PAGE_SIZE)
+
 enum wl1271_state {
 	WL1271_STATE_OFF,
 	WL1271_STATE_ON,
@@ -408,6 +410,9 @@ struct wl1271 {
 	/* Rx memory pool address */
 	struct wl1271_rx_mem_pool_addr rx_mem_pool_addr;
 
+	/* Intermediate buffer, used for packet aggregation */
+	u8 *aggr_buf;
+
 	/* The target interrupt mask */
 	struct work_struct irq_work;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index cb18f22..8071da1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2459,6 +2459,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	struct platform_device *plat_dev = NULL;
 	struct wl1271 *wl;
 	int i, ret;
+	unsigned int order;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -2517,11 +2518,18 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	wl1271_debugfs_init(wl);
 
+	order = get_order(WL1271_AGGR_BUFFER_SIZE);
+	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
+	if (!wl->aggr_buf) {
+		ret = -ENOMEM;
+		goto err_hw;
+	}
+
 	/* Register platform device */
 	ret = platform_device_register(wl->plat_dev);
 	if (ret) {
 		wl1271_error("couldn't register platform device");
-		goto err_hw;
+		goto err_aggr;
 	}
 	dev_set_drvdata(&wl->plat_dev->dev, wl);
 
@@ -2547,6 +2555,9 @@ err_bt_coex_state:
 err_platform:
 	platform_device_unregister(wl->plat_dev);
 
+err_aggr:
+	free_pages((unsigned long)wl->aggr_buf, order);
+
 err_hw:
 	wl1271_debugfs_exit(wl);
 	kfree(plat_dev);
@@ -2563,6 +2574,8 @@ EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 int wl1271_free_hw(struct wl1271 *wl)
 {
 	platform_device_unregister(wl->plat_dev);
+	free_pages((unsigned long)wl->aggr_buf,
+			get_order(WL1271_AGGR_BUFFER_SIZE));
 	kfree(wl->plat_dev);
 
 	wl1271_debugfs_exit(wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 94da5dd..bea133b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -74,7 +74,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	}
 }
 
-static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
+static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 {
 	struct wl1271_rx_descriptor *desc;
 	struct sk_buff *skb;
@@ -87,16 +87,16 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	 * workaround this by not retrieving them at all.
 	 */
 	if (unlikely(wl->state == WL1271_STATE_PLT))
-		return;
+		return -EINVAL;
 
 	skb = __dev_alloc_skb(length, GFP_KERNEL);
 	if (!skb) {
 		wl1271_error("Couldn't allocate RX frame");
-		return;
+		return -ENOMEM;
 	}
 
 	buf = skb_put(skb, length);
-	wl1271_read(wl, WL1271_SLV_MEM_DATA, buf, length, true);
+	memcpy(buf, data, length);
 
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) buf;
@@ -116,6 +116,8 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	skb_trim(skb, skb->len - desc->pad_len);
 
 	ieee80211_rx_ni(wl->hw, skb);
+
+	return 0;
 }
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
@@ -124,31 +126,60 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 	u32 buf_size;
 	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+	u32 rx_counter;
 	u32 mem_block;
+	u32 pkt_length;
+	u32 pkt_offset;
 
 	while (drv_rx_counter != fw_rx_counter) {
-		mem_block = wl1271_rx_get_mem_block(status, drv_rx_counter);
-		buf_size = wl1271_rx_get_buf_size(status, drv_rx_counter);
+		buf_size = 0;
+		rx_counter = drv_rx_counter;
+		while (rx_counter != fw_rx_counter) {
+			pkt_length = wl1271_rx_get_buf_size(status, rx_counter);
+			if (buf_size + pkt_length > WL1271_AGGR_BUFFER_SIZE)
+				break;
+			buf_size += pkt_length;
+			rx_counter++;
+			rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
+		}
 
 		if (buf_size == 0) {
 			wl1271_warning("received empty data");
 			break;
 		}
 
+		/*
+		 * Choose the block we want to read
+		 * For aggregated packets, only the first memory block should
+		 * be retrieved. The FW takes care of the rest.
+		 */
+		mem_block = wl1271_rx_get_mem_block(status, drv_rx_counter);
 		wl->rx_mem_pool_addr.addr = (mem_block << 8) +
 			le32_to_cpu(wl_mem_map->packet_memory_pool_start);
 		wl->rx_mem_pool_addr.addr_extra =
 			wl->rx_mem_pool_addr.addr + 4;
-
-		/* Choose the block we want to read */
 		wl1271_write(wl, WL1271_SLV_REG_DATA, &wl->rx_mem_pool_addr,
-			     sizeof(wl->rx_mem_pool_addr), false);
-
-		wl1271_rx_handle_data(wl, buf_size);
-
-		wl->rx_counter++;
-		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+				sizeof(wl->rx_mem_pool_addr), false);
+
+		/* Read all available packets at once */
+		wl1271_read(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
+				buf_size, true);
+
+		/* Split data into separate packets */
+		pkt_offset = 0;
+		while (pkt_offset < buf_size) {
+			pkt_length = wl1271_rx_get_buf_size(status,
+					drv_rx_counter);
+			if (wl1271_rx_handle_data(wl,
+					wl->aggr_buf + pkt_offset,
+					pkt_length) < 0)
+				break;
+			wl->rx_counter++;
+			drv_rx_counter++;
+			drv_rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
+			pkt_offset += pkt_length;
+		}
 	}
-
-	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS,
+			cpu_to_le32(wl->rx_counter));
 }
-- 
1.7.0.4

