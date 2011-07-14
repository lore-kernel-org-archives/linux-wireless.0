Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:57348 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107Ab1GNIue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 04:50:34 -0400
Received: by wyg24 with SMTP id 24so7342wyg.27
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 01:50:31 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Add support to RX packets payload alignment
Date: Thu, 14 Jul 2011 11:50:27 +0300
Message-Id: <1310633427-15882-1-git-send-email-shahar_levi@ti.com> (sfid-20110714_105037_970079_755FCAF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of QoS packets the packet payload isn't aligned to
4 bytes. In that case the mac80211 layer take care of that
via memmove() in ieee80211_deliver_skb().
Add support of copy packets from aggregation buffer to the
skbs with packet payload aligned care. In case of QoS packets
copy the packets in offset of 2 bytes guarantee payload aligned
to 4 bytes.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/rx.c |   39 ++++++++++++++++++++++++++++++-------
 drivers/net/wireless/wl12xx/rx.h |    8 ++++--
 2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 0450fb4..46f4af6 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -38,12 +38,20 @@ static u8 wl1271_rx_get_mem_block(struct wl1271_fw_common_status *status,
 }
 
 static u32 wl1271_rx_get_buf_size(struct wl1271_fw_common_status *status,
-				 u32 drv_rx_counter)
+				  u32 drv_rx_counter)
 {
 	return (le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
 		RX_BUF_SIZE_MASK) >> RX_BUF_SIZE_SHIFT_DIV;
 }
 
+static bool wl1271_rx_get_unaligned(struct wl1271_fw_common_status *status,
+				    u32 drv_rx_counter)
+{
+	/* Convert the value to bool */
+	return !!(le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
+		RX_BUF_UNALIGNED_PAYLOAD);
+}
+
 static void wl1271_rx_status(struct wl1271 *wl,
 			     struct wl1271_rx_descriptor *desc,
 			     struct ieee80211_rx_status *status,
@@ -89,7 +97,8 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	}
 }
 
-static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
+static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
+				 bool unaligned)
 {
 	struct wl1271_rx_descriptor *desc;
 	struct sk_buff *skb;
@@ -97,6 +106,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	u8 *buf;
 	u8 beacon = 0;
 	u8 is_data = 0;
+	u8 reserved = unaligned ? NET_IP_ALIGN : 0;
 
 	/*
 	 * In PLT mode we seem to get frames and mac80211 warns about them,
@@ -131,17 +141,25 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 		return -EINVAL;
 	}
 
-	skb = __dev_alloc_skb(length, GFP_KERNEL);
+	/* skb length not included rx descriptor */
+	skb = __dev_alloc_skb(length + reserved - sizeof(*desc), GFP_KERNEL);
 	if (!skb) {
 		wl1271_error("Couldn't allocate RX frame");
 		return -ENOMEM;
 	}
 
-	buf = skb_put(skb, length);
-	memcpy(buf, data, length);
+	/* reserve the unaligned payload(if any) */
+	skb_reserve(skb, reserved);
+
+	buf = skb_put(skb, length - sizeof(*desc));
 
-	/* now we pull the descriptor out of the buffer */
-	skb_pull(skb, sizeof(*desc));
+	/*
+	 * Copy packets from aggregation buffer to the skbs without rx
+	 * descriptor and with packet payload aligned care. In case of unaligned
+	 * packets copy the packets in offset of 2 bytes guarantee IP header
+	 * payload aligned to 4 bytes.
+	 */
+	memcpy(buf, data + sizeof(*desc), length - sizeof(*desc));
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_beacon(hdr->frame_control))
@@ -175,6 +193,7 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 	u32 pkt_offset;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 	bool had_data = false;
+	bool unaligned = false;
 
 	while (drv_rx_counter != fw_rx_counter) {
 		buf_size = 0;
@@ -222,6 +241,10 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 		while (pkt_offset < buf_size) {
 			pkt_length = wl1271_rx_get_buf_size(status,
 					drv_rx_counter);
+
+			unaligned = wl1271_rx_get_unaligned(status,
+					drv_rx_counter);
+
 			/*
 			 * the handle data call can only fail in memory-outage
 			 * conditions, in that case the received frame will just
@@ -229,7 +252,7 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 			 */
 			if (wl1271_rx_handle_data(wl,
 						  wl->aggr_buf + pkt_offset,
-						  pkt_length) == 1)
+						  pkt_length, unaligned) == 1)
 				had_data = true;
 
 			wl->rx_counter++;
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index c88e3fa..68b64eb 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -93,9 +93,11 @@
 #define WL1271_RX_DESC_MIC_FAIL         0x02
 #define WL1271_RX_DESC_DRIVER_RX_Q_FAIL 0x03
 
-#define RX_MEM_BLOCK_MASK     0xFF
-#define RX_BUF_SIZE_MASK      0xFFF00
-#define RX_BUF_SIZE_SHIFT_DIV 6
+#define RX_MEM_BLOCK_MASK            0xFF
+#define RX_BUF_SIZE_MASK             0xFFF00
+#define RX_BUF_SIZE_SHIFT_DIV        6
+/* If set, the start of IP payload is not 4 bytes aligned */
+#define RX_BUF_UNALIGNED_PAYLOAD     BIT(20)
 
 enum {
 	WL12XX_RX_CLASS_UNKNOWN,
-- 
1.7.1

