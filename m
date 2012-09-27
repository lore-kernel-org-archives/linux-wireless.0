Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41666 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2I0Kil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:41 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Igal Chernobelsky <igalc@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/31] wlcore/wl18xx/wl12xx: aggregation buffer size set
Date: Thu, 27 Sep 2012 13:37:49 +0300
Message-Id: <1348742289-6587-12-git-send-email-luca@coelho.fi> (sfid-20120927_123950_438239_BBF9E970)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Aggregation buffer size is set separately per 18xx/12xx chip family.
For 18xx aggragation buffer is set to 13 pages to utilize all
the available tx/rx descriptors for aggregation.

[Arik - remove redundant parts from the patch]

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    2 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    2 ++
 drivers/net/wireless/ti/wl18xx/main.c   |    2 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    2 ++
 drivers/net/wireless/ti/wlcore/main.c   |    8 ++++----
 drivers/net/wireless/ti/wlcore/rx.c     |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++-
 8 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f38e769..0a8bc0c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1630,7 +1630,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	struct ieee80211_hw *hw;
 	struct wl12xx_priv *priv;
 
-	hw = wlcore_alloc_hw(sizeof(*priv));
+	hw = wlcore_alloc_hw(sizeof(*priv), WL12XX_AGGR_BUFFER_SIZE);
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
 		return PTR_ERR(hw);
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index c8ff7ec..9953374 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -38,6 +38,8 @@
 #define WL128X_SUBTYPE_VER	2
 #define WL128X_MINOR_VER	115
 
+#define WL12XX_AGGR_BUFFER_SIZE	(4 * PAGE_SIZE)
+
 #define WL12XX_NUM_TX_DESCRIPTORS 16
 #define WL12XX_NUM_RX_DESCRIPTORS 8
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 934708b..3f4fbd8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1380,7 +1380,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	struct wl18xx_priv *priv;
 	int ret;
 
-	hw = wlcore_alloc_hw(sizeof(*priv));
+	hw = wlcore_alloc_hw(sizeof(*priv), WL18XX_AGGR_BUFFER_SIZE);
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
 		ret = PTR_ERR(hw);
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 9882e29..a6e61a2 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -33,6 +33,8 @@
 
 #define WL18XX_CMD_MAX_SIZE          740
 
+#define WL18XX_AGGR_BUFFER_SIZE		(13 * PAGE_SIZE)
+
 #define WL18XX_NUM_TX_DESCRIPTORS 32
 #define WL18XX_NUM_RX_DESCRIPTORS 32
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 612008f..7fe19de 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5313,7 +5313,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 #define WL1271_DEFAULT_CHANNEL 0
 
-struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
+struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
 {
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
@@ -5398,12 +5398,13 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	mutex_init(&wl->mutex);
 	mutex_init(&wl->flush_mutex);
 
-	order = get_order(WL1271_AGGR_BUFFER_SIZE);
+	order = get_order(aggr_buf_size);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
 	if (!wl->aggr_buf) {
 		ret = -ENOMEM;
 		goto err_wq;
 	}
+	wl->aggr_buf_size = aggr_buf_size;
 
 	wl->dummy_packet = wl12xx_alloc_dummy_packet(wl);
 	if (!wl->dummy_packet) {
@@ -5466,8 +5467,7 @@ int wlcore_free_hw(struct wl1271 *wl)
 	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
 	free_page((unsigned long)wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
-	free_pages((unsigned long)wl->aggr_buf,
-			get_order(WL1271_AGGR_BUFFER_SIZE));
+	free_pages((unsigned long)wl->aggr_buf, get_order(wl->aggr_buf_size));
 
 	wl1271_debugfs_exit(wl);
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index f55e2f9..9ee0ec6 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -221,7 +221,7 @@ int wlcore_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 			pkt_len = wlcore_rx_get_buf_size(wl, des);
 			align_pkt_len = wlcore_rx_get_align_buf_size(wl,
 								     pkt_len);
-			if (buf_size + align_pkt_len > WL1271_AGGR_BUFFER_SIZE)
+			if (buf_size + align_pkt_len > wl->aggr_buf_size)
 				break;
 			buf_size += align_pkt_len;
 			rx_counter++;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index f9c26b1..a90d3cd 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -193,7 +193,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	int id, ret = -EBUSY, ac;
 	u32 spare_blocks;
 
-	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
+	if (buf_offset + total_len > wl->aggr_buf_size)
 		return -EAGAIN;
 
 	spare_blocks = wlcore_hw_get_spare_blocks(wl, is_gem);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 81790a0..a7e9d58 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -237,6 +237,7 @@ struct wl1271 {
 
 	/* Intermediate buffer, used for packet aggregation */
 	u8 *aggr_buf;
+	u32 aggr_buf_size;
 
 	/* Reusable dummy packet template */
 	struct sk_buff *dummy_packet;
@@ -399,7 +400,7 @@ struct wl1271 {
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
 int __devexit wlcore_remove(struct platform_device *pdev);
-struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size);
+struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size);
 int wlcore_free_hw(struct wl1271 *wl);
 int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		   struct ieee80211_vif *vif,
-- 
1.7.10.4

