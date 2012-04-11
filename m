Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:40829 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933045Ab2DKTx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:58 -0400
Received: by lbom4 with SMTP id m4so893721lbo.25
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:55 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 07/24] wlcore: introduce Rx block-size alignment HW quirk
Date: Wed, 11 Apr 2012 22:53:23 +0300
Message-Id: <1334174020-18957-8-git-send-email-coelho@ti.com> (sfid-20120411_215453_398123_97198669)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

For chip-families that support aligned buffers in the Rx side. The Rx
flow changes slightly for these chips.

Currently these modifications rely on a hard-coded block-size of 256.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/rx.c     |   41 ++++++++++++++++++++----------
 drivers/net/wireless/ti/wlcore/rx.h     |    3 ++
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++
 3 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index db761af..f5811d6 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -44,11 +44,22 @@ static u8 wl12xx_rx_get_mem_block(struct wl12xx_fw_status *status,
 		RX_MEM_BLOCK_MASK;
 }
 
-static u32 wl12xx_rx_get_buf_size(struct wl12xx_fw_status *status,
-				 u32 drv_rx_counter)
+static u32 wlcore_rx_get_buf_size(struct wl1271 *wl,
+				  u32 rx_pkt_desc)
 {
-	return (le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
-		RX_BUF_SIZE_MASK) >> RX_BUF_SIZE_SHIFT_DIV;
+	if (wl->quirks & WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN)
+		return (rx_pkt_desc & ALIGNED_RX_BUF_SIZE_MASK) >>
+		       ALIGNED_RX_BUF_SIZE_SHIFT;
+
+	return (rx_pkt_desc & RX_BUF_SIZE_MASK) >> RX_BUF_SIZE_SHIFT_DIV;
+}
+
+static u32 wlcore_rx_get_align_buf_size(struct wl1271 *wl, u32 pkt_len)
+{
+	if (wl->quirks & WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN)
+		return ALIGN(pkt_len, WL12XX_BUS_BLOCK_SIZE);
+
+	return pkt_len;
 }
 
 static bool wl12xx_rx_get_unaligned(struct wl12xx_fw_status *status,
@@ -199,8 +210,8 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 rx_counter;
 	u32 mem_block;
-	u32 pkt_length;
-	u32 pkt_offset;
+	u32 pkt_len, align_pkt_len;
+	u32 pkt_offset, des;
 	u8 hlid;
 	bool unaligned = false;
 
@@ -208,10 +219,13 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 		buf_size = 0;
 		rx_counter = drv_rx_counter;
 		while (rx_counter != fw_rx_counter) {
-			pkt_length = wl12xx_rx_get_buf_size(status, rx_counter);
-			if (buf_size + pkt_length > WL1271_AGGR_BUFFER_SIZE)
+			des = le32_to_cpu(status->rx_pkt_descs[rx_counter]);
+			pkt_len = wlcore_rx_get_buf_size(wl, des);
+			align_pkt_len = wlcore_rx_get_align_buf_size(wl,
+								     pkt_len);
+			if (buf_size + align_pkt_len > WL1271_AGGR_BUFFER_SIZE)
 				break;
-			buf_size += pkt_length;
+			buf_size += align_pkt_len;
 			rx_counter++;
 			rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
 		}
@@ -248,9 +262,8 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 		/* Split data into separate packets */
 		pkt_offset = 0;
 		while (pkt_offset < buf_size) {
-			pkt_length = wl12xx_rx_get_buf_size(status,
-					drv_rx_counter);
-
+			des = le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]);
+			pkt_len = wlcore_rx_get_buf_size(wl, des);
 			unaligned = wl12xx_rx_get_unaligned(status,
 					drv_rx_counter);
 
@@ -261,7 +274,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 			 */
 			if (wl1271_rx_handle_data(wl,
 						  wl->aggr_buf + pkt_offset,
-						  pkt_length, unaligned,
+						  pkt_len, unaligned,
 						  &hlid) == 1) {
 				if (hlid < WL12XX_MAX_LINKS)
 					__set_bit(hlid, active_hlids);
@@ -274,7 +287,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 			wl->rx_counter++;
 			drv_rx_counter++;
 			drv_rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
-			pkt_offset += pkt_length;
+			pkt_offset += wlcore_rx_get_align_buf_size(wl, pkt_len);
 		}
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 86ba6b1..b30b153 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -96,6 +96,9 @@
 #define RX_MEM_BLOCK_MASK            0xFF
 #define RX_BUF_SIZE_MASK             0xFFF00
 #define RX_BUF_SIZE_SHIFT_DIV        6
+#define ALIGNED_RX_BUF_SIZE_MASK     0xFFFF00
+#define ALIGNED_RX_BUF_SIZE_SHIFT    8
+
 /* If set, the start of IP payload is not 4 bytes aligned */
 #define RX_BUF_UNALIGNED_PAYLOAD     BIT(20)
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 3c0fbc6..9fc57e8 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -346,6 +346,9 @@ int wlcore_free_hw(struct wl1271 *wl);
 /* wl127x and SPI don't support SDIO block size alignment */
 #define WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT	BIT(2)
 
+/* means aggregated Rx packets are aligned to a SDIO block */
+#define WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN		BIT(3)
+
 /* Older firmwares did not implement the FW logger over bus feature */
 #define WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(4)
 
-- 
1.7.5.4

