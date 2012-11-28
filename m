Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2K1Jnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:35 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so5186649wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:35 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 20/20] wlcore: Always pass DMA-able buffers to mmc functions
Date: Wed, 28 Nov 2012 11:42:49 +0200
Message-Id: <1354095769-8724-21-git-send-email-arik@wizery.com> (sfid-20121128_104349_273923_B270C788)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Some of the mmc drivers initiate DMA transfers with buffers passed from
higher layers. This means that the driver shouldn't ever pass non
DMA-able buffers, such as ones that are unaligned, allocated on the
stack or static.

Fix a couple of calls to the mmc layer in which buffers which weren't
necessarily DMA-able were passed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   31 +++++++++++++++++++++++++------
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    2 ++
 drivers/net/wireless/ti/wlcore/io.h     |   10 ++++------
 drivers/net/wireless/ti/wlcore/main.c   |   10 ++++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 5 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index be26d35..be1b792 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -613,7 +613,7 @@ static int wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 
 	if (wl->chip.id != CHIP_ID_1283_PG20) {
 		struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
-		struct wl127x_rx_mem_pool_addr rx_mem_addr;
+		struct wl12xx_priv *priv = wl->priv;
 
 		/*
 		 * Choose the block we want to read
@@ -622,13 +622,13 @@ static int wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 		 */
 		u32 mem_block = rx_desc & RX_MEM_BLOCK_MASK;
 
-		rx_mem_addr.addr = (mem_block << 8) +
+		priv->rx_mem_addr->addr = (mem_block << 8) +
 			le32_to_cpu(wl_mem_map->packet_memory_pool_start);
 
-		rx_mem_addr.addr_extra = rx_mem_addr.addr + 4;
+		priv->rx_mem_addr->addr_extra = priv->rx_mem_addr->addr + 4;
 
-		ret = wlcore_write(wl, WL1271_SLV_REG_DATA, &rx_mem_addr,
-				   sizeof(rx_mem_addr), false);
+		ret = wlcore_write(wl, WL1271_SLV_REG_DATA, priv->rx_mem_addr,
+				   sizeof(*priv->rx_mem_addr), false);
 		if (ret < 0)
 			return ret;
 	}
@@ -1778,6 +1778,10 @@ static int wl12xx_setup(struct wl1271 *wl)
 			wl1271_error("Invalid tcxo parameter %s", tcxo_param);
 	}
 
+	priv->rx_mem_addr = kmalloc(sizeof(*priv->rx_mem_addr), GFP_KERNEL);
+	if (!priv->rx_mem_addr)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -1811,6 +1815,21 @@ out:
 	return ret;
 }
 
+static int __devexit wl12xx_remove(struct platform_device *pdev)
+{
+	struct wl1271 *wl = platform_get_drvdata(pdev);
+	struct wl12xx_priv *priv;
+
+	if (!wl)
+		goto out;
+	priv = wl->priv;
+
+	kfree(priv->rx_mem_addr);
+
+out:
+	return wlcore_remove(pdev);
+}
+
 static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
 	{ "wl12xx", 0 },
 	{  } /* Terminating Entry */
@@ -1819,7 +1838,7 @@ MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
 
 static struct platform_driver wl12xx_driver = {
 	.probe		= wl12xx_probe,
-	.remove		= __devexit_p(wlcore_remove),
+	.remove		= __devexit_p(wl12xx_remove),
 	.id_table	= wl12xx_id_table,
 	.driver = {
 		.name	= "wl12xx_driver",
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index b542bfd..9bb60de 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -55,6 +55,8 @@ struct wl12xx_priv {
 
 	int ref_clock;
 	int tcxo_clock;
+
+	struct wl127x_rx_mem_pool_addr *rx_mem_addr;
 };
 
 #endif /* __WL12XX_PRIV_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 5897747..70f9bdc 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -105,13 +105,12 @@ static inline int __must_check wlcore_raw_read32(struct wl1271 *wl, int addr,
 {
 	int ret;
 
-	ret = wlcore_raw_read(wl, addr, &wl->buffer_32,
-			      sizeof(wl->buffer_32), false);
+	ret = wlcore_raw_read(wl, addr, wl->buffer_32, sizeof(u32), false);
 	if (ret < 0)
 		return ret;
 
 	if (val)
-		*val = le32_to_cpu(wl->buffer_32);
+		*val = le32_to_cpu(*wl->buffer_32);
 
 	return 0;
 }
@@ -119,9 +118,8 @@ static inline int __must_check wlcore_raw_read32(struct wl1271 *wl, int addr,
 static inline int __must_check wlcore_raw_write32(struct wl1271 *wl, int addr,
 						  u32 val)
 {
-	wl->buffer_32 = cpu_to_le32(val);
-	return wlcore_raw_write(wl, addr, &wl->buffer_32,
-				sizeof(wl->buffer_32), false);
+	*wl->buffer_32 = cpu_to_le32(val);
+	return wlcore_raw_write(wl, addr, wl->buffer_32, sizeof(u32), false);
 }
 
 static inline int __must_check wlcore_read(struct wl1271 *wl, int addr,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1793a82..e4ff66a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5890,8 +5890,17 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 		goto err_fwlog;
 	}
 
+	wl->buffer_32 = kmalloc(sizeof(u32), GFP_KERNEL);
+	if (!wl->buffer_32) {
+		ret = -ENOMEM;
+		goto err_mbox;
+	}
+
 	return hw;
 
+err_mbox:
+	kfree(wl->mbox);
+
 err_fwlog:
 	free_page((unsigned long)wl->fwlog);
 
@@ -5930,6 +5939,7 @@ int wlcore_free_hw(struct wl1271 *wl)
 	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
 
 	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
+	kfree(wl->buffer_32);
 	kfree(wl->mbox);
 	free_page((unsigned long)wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 8877d73..6e49105 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -341,7 +341,7 @@ struct wl1271 {
 
 	struct wl1271_stats stats;
 
-	__le32 buffer_32;
+	__le32 *buffer_32;
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 
-- 
1.7.9.5

