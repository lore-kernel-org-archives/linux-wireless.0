Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57936 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933016Ab2DKTyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:00 -0400
Received: by lbbgn12 with SMTP id gn12so588150lbb.32
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:57 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 10/24] wlcore/wl12xx: add hw op for getting rx packet data length
Date: Wed, 11 Apr 2012 22:53:26 +0300
Message-Id: <1334174020-18957-11-git-send-email-coelho@ti.com> (sfid-20120411_215416_545416_1D3E7A1D)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

There is a difference in the way chip families report the length of data
in a single Rx packet. Abstract this into a HW op. Refactor the Rx data
handling function to allocate the correct size for the data, and avoid
trimming the skb.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   14 ++++++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |    9 +++++++++
 drivers/net/wireless/ti/wlcore/rx.c     |   18 ++++++++++++------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index e4fab26..5f81aaf 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -776,6 +776,19 @@ wl12xx_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
 	return WLCORE_RX_BUF_ALIGNED;
 }
 
+static u32 wl12xx_get_rx_packet_len(struct wl1271 *wl, void *rx_data,
+				    u32 data_len)
+{
+	struct wl1271_rx_descriptor *desc = rx_data;
+
+	/* invalid packet */
+	if (data_len < sizeof(*desc) ||
+	    data_len < sizeof(*desc) + desc->pad_len)
+		return 0;
+
+	return data_len - sizeof(*desc) - desc->pad_len;
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -848,6 +861,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_tx_desc_blocks	= wl12xx_set_tx_desc_blocks,
 	.set_tx_desc_data_len	= wl12xx_set_tx_desc_data_len,
 	.get_rx_buf_align	= wl12xx_get_rx_buf_align,
+	.get_rx_packet_len	= wl12xx_get_rx_packet_len,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index eeed297..876f1a1 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -72,5 +72,14 @@ wlcore_hw_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 		wl->ops->prepare_read(wl, rx_desc, len);
 }
 
+static inline u32
+wlcore_hw_get_rx_packet_len(struct wl1271 *wl, void *rx_data, u32 data_len)
+{
+	if (!wl->ops->get_rx_packet_len)
+		BUG_ON(1);
+
+	return wl->ops->get_rx_packet_len(wl, rx_data, data_len);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 3f504d1..6bde6e2 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -110,6 +110,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	u8 is_data = 0;
 	u8 reserved = 0;
 	u16 seq_num;
+	u32 pkt_data_len;
 
 	/*
 	 * In PLT mode we seem to get frames and mac80211 warns about them,
@@ -118,6 +119,13 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	if (unlikely(wl->plt))
 		return -EINVAL;
 
+	pkt_data_len = wlcore_hw_get_rx_packet_len(wl, data, length);
+	if (!pkt_data_len) {
+		wl1271_error("Invalid packet arrived from HW. length %d",
+			     length);
+		return -EINVAL;
+	}
+
 	if (rx_align == WLCORE_RX_BUF_UNALIGNED)
 		reserved = NET_IP_ALIGN;
 
@@ -147,8 +155,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 		return -EINVAL;
 	}
 
-	/* skb length not included rx descriptor */
-	skb = __dev_alloc_skb(length + reserved - sizeof(*desc), GFP_KERNEL);
+	/* skb length not including rx descriptor */
+	skb = __dev_alloc_skb(pkt_data_len + reserved, GFP_KERNEL);
 	if (!skb) {
 		wl1271_error("Couldn't allocate RX frame");
 		return -ENOMEM;
@@ -157,7 +165,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	/* reserve the unaligned payload(if any) */
 	skb_reserve(skb, reserved);
 
-	buf = skb_put(skb, length - sizeof(*desc));
+	buf = skb_put(skb, pkt_data_len);
 
 	/*
 	 * Copy packets from aggregation buffer to the skbs without rx
@@ -165,7 +173,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	 * packets copy the packets in offset of 2 bytes guarantee IP header
 	 * payload aligned to 4 bytes.
 	 */
-	memcpy(buf, data + sizeof(*desc), length - sizeof(*desc));
+	memcpy(buf, data + sizeof(*desc), pkt_data_len);
 	if (rx_align == WLCORE_RX_BUF_PADDED)
 		skb_pull(skb, NET_IP_ALIGN);
 
@@ -185,8 +193,6 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 		     beacon ? "beacon" : "",
 		     seq_num, *hlid);
 
-	skb_trim(skb, skb->len - desc->pad_len);
-
 	skb_queue_tail(&wl->deferred_rx_queue, skb);
 	queue_work(wl->freezable_wq, &wl->netstack_work);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 79ab84e..664df32 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -33,6 +33,7 @@
 /* forward declaration */
 struct wl1271_tx_hw_descr;
 enum wl_rx_buf_align;
+
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
@@ -48,6 +49,8 @@ struct wlcore_ops {
 	enum wl_rx_buf_align (*get_rx_buf_align)(struct wl1271 *wl,
 						 u32 rx_desc);
 	void (*prepare_read)(struct wl1271 *wl, u32 rx_desc, u32 len);
+	u32 (*get_rx_packet_len)(struct wl1271 *wl, void *rx_data,
+				 u32 data_len);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

