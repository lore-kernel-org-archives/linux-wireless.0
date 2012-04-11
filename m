Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:52573 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933050Ab2DKTyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:00 -0400
Received: by lbbge1 with SMTP id ge1so963961lbb.9
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 09/24] wlcore/wl12xx: add prepare_read hw op for Rx data
Date: Wed, 11 Apr 2012 22:53:25 +0300
Message-Id: <1334174020-18957-10-git-send-email-coelho@ti.com> (sfid-20120411_215411_133198_338C665A)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only difference in the read_data operations is that some chips
need to prepare the data to be read before reading.  So instead of
having a mandatory read_data operation, we now have an option
prepare_data operation that only needs to be implemented for chips
that require it.

In the wl12xx lower driver, we only set the prepare_data operation for
wl127x chips.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   32 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |    7 ++++++
 drivers/net/wireless/ti/wlcore/rx.c     |   31 +----------------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 4 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 43c2c7f..e4fab26 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -32,6 +32,7 @@
 #include "../wlcore/acx.h"
 #include "../wlcore/tx.h"
 #include "../wlcore/rx.h"
+#include "../wlcore/io.h"
 #include "../wlcore/boot.h"
 
 #include "reg.h"
@@ -239,6 +240,29 @@ static const int wl12xx_rtable[REG_TABLE_LEN] = {
 #define WL128X_FW_NAME_SINGLE	"ti-connectivity/wl128x-fw-4-sr.bin"
 #define WL128X_PLT_FW_NAME	"ti-connectivity/wl128x-fw-4-plt.bin"
 
+static void wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
+{
+	if (wl->chip.id != CHIP_ID_1283_PG20) {
+		struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
+		struct wl1271_rx_mem_pool_addr rx_mem_addr;
+
+		/*
+		 * Choose the block we want to read
+		 * For aggregated packets, only the first memory block
+		 * should be retrieved. The FW takes care of the rest.
+		 */
+		u32 mem_block = rx_desc & RX_MEM_BLOCK_MASK;
+
+		rx_mem_addr.addr = (mem_block << 8) +
+			le32_to_cpu(wl_mem_map->packet_memory_pool_start);
+
+		rx_mem_addr.addr_extra = rx_mem_addr.addr + 4;
+
+		wl1271_write(wl, WL1271_SLV_REG_DATA,
+			     &rx_mem_addr, sizeof(rx_mem_addr), false);
+	}
+}
+
 static int wl12xx_identify_chip(struct wl1271 *wl)
 {
 	int ret = 0;
@@ -253,6 +277,10 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
+
+		/* read data preparation is only needed by wl127x */
+		wl->ops->prepare_read = wl127x_prepare_read;
+
 		break;
 
 	case CHIP_ID_1271_PG20:
@@ -264,6 +292,10 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
+
+		/* read data preparation is only needed by wl127x */
+		wl->ops->prepare_read = wl127x_prepare_read;
+
 		break;
 
 	case CHIP_ID_1283_PG20:
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index ddb439d..eeed297 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -65,5 +65,12 @@ wlcore_hw_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
 	return wl->ops->get_rx_buf_align(wl, rx_desc);
 }
 
+static inline void
+wlcore_hw_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
+{
+	if (wl->ops->prepare_read)
+		wl->ops->prepare_read(wl, rx_desc, len);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index d1e4206..3f504d1 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -38,13 +38,6 @@
  */
 #include "../wl12xx/reg.h"
 
-static u8 wl12xx_rx_get_mem_block(struct wl12xx_fw_status *status,
-				  u32 drv_rx_counter)
-{
-	return le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
-		RX_MEM_BLOCK_MASK;
-}
-
 static u32 wlcore_rx_get_buf_size(struct wl1271 *wl,
 				  u32 rx_pkt_desc)
 {
@@ -202,13 +195,11 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 
 void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 {
-	struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	u32 buf_size;
 	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 rx_counter;
-	u32 mem_block;
 	u32 pkt_len, align_pkt_len;
 	u32 pkt_offset, des;
 	u8 hlid;
@@ -234,27 +225,9 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 			break;
 		}
 
-		if (wl->chip.id != CHIP_ID_1283_PG20) {
-			/*
-			 * Choose the block we want to read
-			 * For aggregated packets, only the first memory block
-			 * should be retrieved. The FW takes care of the rest.
-			 */
-			mem_block = wl12xx_rx_get_mem_block(status,
-							    drv_rx_counter);
-
-			wl->rx_mem_pool_addr.addr = (mem_block << 8) +
-			   le32_to_cpu(wl_mem_map->packet_memory_pool_start);
-
-			wl->rx_mem_pool_addr.addr_extra =
-				wl->rx_mem_pool_addr.addr + 4;
-
-			wlcore_write_data(wl, REG_SLV_REG_DATA,
-					  &wl->rx_mem_pool_addr,
-					  sizeof(wl->rx_mem_pool_addr), false);
-		}
-
 		/* Read all available packets at once */
+		des = le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]);
+		wlcore_hw_prepare_read(wl, des, buf_size);
 		wlcore_read_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
 				 buf_size, true);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 3c2ded5..79ab84e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -47,6 +47,7 @@ struct wlcore_ops {
 				     struct sk_buff *skb);
 	enum wl_rx_buf_align (*get_rx_buf_align)(struct wl1271 *wl,
 						 u32 rx_desc);
+	void (*prepare_read)(struct wl1271 *wl, u32 rx_desc, u32 len);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

