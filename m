Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:52273 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760353Ab2FGJRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:17:40 -0400
Received: by lbbgo11 with SMTP id go11so460000lbb.31
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 02:17:37 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 5/5] wl18xx: pad only last frame in aggregration buffer for PG2
Date: Thu,  7 Jun 2012 12:17:25 +0300
Message-Id: <1339060645-3574-6-git-send-email-coelho@ti.com> (sfid-20120607_111746_416576_AA4BEC67)
In-Reply-To: <1339060645-3574-1-git-send-email-coelho@ti.com>
References: <1339060645-3574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

In PG2 only the last frame in the aggregate buffer should be
aligned to the sdio block size. This frame's header msb should be
set to 0, while in all the previous frames in the aggregation
buffer, this bit should be set to 1.

[Add a HW op for setting the frame ctrl bit only for 18xx. Other minor
cleanups - Arik]

[Make the pre_pkt_send operation optional -- Luca]

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/main.c   |   30 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/tx.h     |    3 +++
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 +++++++++
 drivers/net/wireless/ti/wlcore/tx.c     |   16 +++++++++++-----
 drivers/net/wireless/ti/wlcore/tx.h     |    4 ++--
 drivers/net/wireless/ti/wlcore/wlcore.h |    4 ++++
 7 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f74d76c..364fb2f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1406,6 +1406,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.debugfs_init		= wl12xx_debugfs_add_files,
 	.get_spare_blocks	= wl12xx_get_spare_blocks,
 	.set_key		= wl12xx_set_key,
+	.pre_pkt_send		= NULL,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 84f8e27..fd02795 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -600,7 +600,8 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		wl->plt_fw_name = WL18XX_FW_NAME;
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
 			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
-			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
+			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
+			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
 
 		break;
 	case CHIP_ID_185x_PG10:
@@ -847,7 +848,6 @@ wl18xx_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 			  u32 blks, u32 spare_blks)
 {
 	desc->wl18xx_mem.total_mem_blocks = blks;
-	desc->wl18xx_mem.reserved = 0;
 }
 
 static void
@@ -856,6 +856,12 @@ wl18xx_set_tx_desc_data_len(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 {
 	desc->length = cpu_to_le16(skb->len);
 
+	/* if only the last frame is to be padded, we unset this bit on Tx */
+	if (wl->quirks & WLCORE_QUIRK_TX_PAD_LAST_FRAME)
+		desc->wl18xx_mem.ctrl = WL18XX_TX_CTRL_NOT_PADDED;
+	else
+		desc->wl18xx_mem.ctrl = 0;
+
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: hlid: %d "
 		     "len: %d life: %d mem: %d", desc->hlid,
 		     le16_to_cpu(desc->length),
@@ -1152,6 +1158,25 @@ out:
 	return ret;
 }
 
+static u32 wl18xx_pre_pkt_send(struct wl1271 *wl,
+			       u32 buf_offset, u32 last_len)
+{
+	if (wl->quirks & WLCORE_QUIRK_TX_PAD_LAST_FRAME) {
+		struct wl1271_tx_hw_descr *last_desc;
+
+		/* get the last TX HW descriptor written to the aggr buf */
+		last_desc = (struct wl1271_tx_hw_descr *)(wl->aggr_buf +
+							buf_offset - last_len);
+
+		/* the last frame is padded up to an SDIO block */
+		last_desc->wl18xx_mem.ctrl &= ~WL18XX_TX_CTRL_NOT_PADDED;
+		return ALIGN(buf_offset, WL12XX_BUS_BLOCK_SIZE);
+	}
+
+	/* no modifications */
+	return buf_offset;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -1176,6 +1201,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.handle_static_data	= wl18xx_handle_static_data,
 	.get_spare_blocks = wl18xx_get_spare_blocks,
 	.set_key	= wl18xx_set_key,
+	.pre_pkt_send	= wl18xx_pre_pkt_send,
 };
 
 /* HT cap appropriate for wide channels */
diff --git a/drivers/net/wireless/ti/wl18xx/tx.h b/drivers/net/wireless/ti/wl18xx/tx.h
index 8aecaf0..ccddc54 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.h
+++ b/drivers/net/wireless/ti/wl18xx/tx.h
@@ -32,6 +32,9 @@
 #define WL18XX_TX_STATUS_DESC_ID_MASK    0x7F
 #define WL18XX_TX_STATUS_STAT_BIT_IDX    7
 
+/* Indicates this TX HW frame is not padded to SDIO block size */
+#define WL18XX_TX_CTRL_NOT_PADDED	BIT(7)
+
 /*
  * The FW uses a special bit to indicate a wide channel should be used in
  * the rate policy.
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 34e0498..9e7787b 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -188,4 +188,13 @@ wlcore_hw_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	return wl->ops->set_key(wl, cmd, vif, sta, key_conf);
 }
 
+static inline u32
+wlcore_hw_pre_pkt_send(struct wl1271 *wl, u32 buf_offset, u32 last_len)
+{
+	if (wl->ops->pre_pkt_send)
+		return wl->ops->pre_pkt_send(wl, buf_offset, last_len);
+
+	return buf_offset;
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index da9a07d..6983e7a 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -178,10 +178,11 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
 					  unsigned int packet_length)
 {
-	if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN)
-		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
-	else
+	if ((wl->quirks & WLCORE_QUIRK_TX_PAD_LAST_FRAME) ||
+	    !(wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN))
 		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
+	else
+		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
 }
 EXPORT_SYMBOL(wlcore_calc_packet_alignment);
 
@@ -662,7 +663,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 	struct wl12xx_vif *wlvif;
 	struct sk_buff *skb;
 	struct wl1271_tx_hw_descr *desc;
-	u32 buf_offset = 0;
+	u32 buf_offset = 0, last_len = 0;
 	bool sent_packets = false;
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	int ret;
@@ -686,6 +687,9 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			 * Flush buffer and try again.
 			 */
 			wl1271_skb_queue_head(wl, wlvif, skb);
+
+			buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset,
+							    last_len);
 			wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
 					  buf_offset, true);
 			sent_packets = true;
@@ -711,7 +715,8 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 				ieee80211_free_txskb(wl->hw, skb);
 			goto out_ack;
 		}
-		buf_offset += ret;
+		last_len = ret;
+		buf_offset += last_len;
 		wl->tx_packets_count++;
 		if (has_data) {
 			desc = (struct wl1271_tx_hw_descr *) skb->data;
@@ -721,6 +726,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 
 out_ack:
 	if (buf_offset) {
+		buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset, last_len);
 		wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
 				  buf_offset, true);
 		sent_packets = true;
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 49e441f..fa4be1b 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -93,9 +93,9 @@ struct wl18xx_tx_mem {
 	u8 total_mem_blocks;
 
 	/*
-	 * always zero
+	 * control bits
 	 */
-	u8 reserved;
+	u8 ctrl;
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index e634500..761a72f 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -80,6 +80,7 @@ struct wlcore_ops {
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key_conf);
+	u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
 };
 
 enum wlcore_partitions {
@@ -420,6 +421,9 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 /* Some firmwares may not support ELP */
 #define WLCORE_QUIRK_NO_ELP			BIT(6)
 
+/* pad only the last frame in the aggregate buffer */
+#define WLCORE_QUIRK_TX_PAD_LAST_FRAME		BIT(7)
+
 /* extra header space is required for TKIP */
 #define WLCORE_QUIRK_TKIP_HEADER_SPACE		BIT(8)
 
-- 
1.7.10

