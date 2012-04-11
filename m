Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54963 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933047Ab2DKTx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:58 -0400
Received: by lagv3 with SMTP id v3so1144496lag.41
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:55 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 08/24] wlcore/wl12xx: add hw op for getting rx buffer data alignment
Date: Wed, 11 Apr 2012 22:53:24 +0300
Message-Id: <1334174020-18957-9-git-send-email-coelho@ti.com> (sfid-20120411_215500_475641_2969706A)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

An aligned data buffer is such where the Ethernet portion of the packet
starts on a 4-byte boundary. Some chip families support padding the Rx
data buffer to achieve such alignment, others rely on the host to perform
it.
Implement the HW op for getting alignment state in wl12xx. Add
support for HW-padded alignment in the Rx flow.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   11 +++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |   11 +++++++++++
 drivers/net/wireless/ti/wlcore/rx.c     |   26 ++++++++++++--------------
 drivers/net/wireless/ti/wlcore/rx.h     |    7 +++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    7 +++++--
 5 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 790c622..43c2c7f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -31,6 +31,7 @@
 #include "../wlcore/io.h"
 #include "../wlcore/acx.h"
 #include "../wlcore/tx.h"
+#include "../wlcore/rx.h"
 #include "../wlcore/boot.h"
 
 #include "reg.h"
@@ -734,6 +735,15 @@ wl12xx_set_tx_desc_data_len(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 	}
 }
 
+static enum wl_rx_buf_align
+wl12xx_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
+{
+	if (rx_desc & RX_BUF_UNALIGNED_PAYLOAD)
+		return WLCORE_RX_BUF_UNALIGNED;
+
+	return WLCORE_RX_BUF_ALIGNED;
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -805,6 +815,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.calc_tx_blocks		= wl12xx_calc_tx_blocks,
 	.set_tx_desc_blocks	= wl12xx_set_tx_desc_blocks,
 	.set_tx_desc_data_len	= wl12xx_set_tx_desc_data_len,
+	.get_rx_buf_align	= wl12xx_get_rx_buf_align,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 8a56e8d..ddb439d 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -23,6 +23,7 @@
 #define __WLCORE_HW_OPS_H__
 
 #include "wlcore.h"
+#include "rx.h"
 
 static inline u32
 wlcore_hw_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
@@ -54,5 +55,15 @@ wlcore_hw_set_tx_desc_data_len(struct wl1271 *wl,
 	wl->ops->set_tx_desc_data_len(wl, desc, skb);
 }
 
+static inline enum wl_rx_buf_align
+wlcore_hw_get_rx_buf_align(struct wl1271 *wl, u32 rx_desc)
+{
+
+	if (!wl->ops->get_rx_buf_align)
+		BUG_ON(1);
+
+	return wl->ops->get_rx_buf_align(wl, rx_desc);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index f5811d6..d1e4206 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -30,6 +30,7 @@
 #include "rx.h"
 #include "tx.h"
 #include "io.h"
+#include "hw_ops.h"
 
 /*
  * TODO: this is here just for now, it must be removed when the data
@@ -62,14 +63,6 @@ static u32 wlcore_rx_get_align_buf_size(struct wl1271 *wl, u32 pkt_len)
 	return pkt_len;
 }
 
-static bool wl12xx_rx_get_unaligned(struct wl12xx_fw_status *status,
-				    u32 drv_rx_counter)
-{
-	/* Convert the value to bool */
-	return !!(le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
-		RX_BUF_UNALIGNED_PAYLOAD);
-}
-
 static void wl1271_rx_status(struct wl1271 *wl,
 			     struct wl1271_rx_descriptor *desc,
 			     struct ieee80211_rx_status *status,
@@ -114,7 +107,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
 }
 
 static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
-				 bool unaligned, u8 *hlid)
+				 enum wl_rx_buf_align rx_align, u8 *hlid)
 {
 	struct wl1271_rx_descriptor *desc;
 	struct sk_buff *skb;
@@ -122,7 +115,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	u8 *buf;
 	u8 beacon = 0;
 	u8 is_data = 0;
-	u8 reserved = unaligned ? NET_IP_ALIGN : 0;
+	u8 reserved = 0;
 	u16 seq_num;
 
 	/*
@@ -132,6 +125,9 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	if (unlikely(wl->plt))
 		return -EINVAL;
 
+	if (rx_align == WLCORE_RX_BUF_UNALIGNED)
+		reserved = NET_IP_ALIGN;
+
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) data;
 
@@ -177,6 +173,9 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	 * payload aligned to 4 bytes.
 	 */
 	memcpy(buf, data + sizeof(*desc), length - sizeof(*desc));
+	if (rx_align == WLCORE_RX_BUF_PADDED)
+		skb_pull(skb, NET_IP_ALIGN);
+
 	*hlid = desc->hlid;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -213,7 +212,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	u32 pkt_len, align_pkt_len;
 	u32 pkt_offset, des;
 	u8 hlid;
-	bool unaligned = false;
+	enum wl_rx_buf_align rx_align;
 
 	while (drv_rx_counter != fw_rx_counter) {
 		buf_size = 0;
@@ -264,8 +263,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 		while (pkt_offset < buf_size) {
 			des = le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]);
 			pkt_len = wlcore_rx_get_buf_size(wl, des);
-			unaligned = wl12xx_rx_get_unaligned(status,
-					drv_rx_counter);
+			rx_align = wlcore_hw_get_rx_buf_align(wl, des);
 
 			/*
 			 * the handle data call can only fail in memory-outage
@@ -274,7 +272,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 			 */
 			if (wl1271_rx_handle_data(wl,
 						  wl->aggr_buf + pkt_offset,
-						  pkt_len, unaligned,
+						  pkt_len, rx_align,
 						  &hlid) == 1) {
 				if (hlid < WL12XX_MAX_LINKS)
 					__set_bit(hlid, active_hlids);
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index b30b153..18eb38b 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -102,6 +102,13 @@
 /* If set, the start of IP payload is not 4 bytes aligned */
 #define RX_BUF_UNALIGNED_PAYLOAD     BIT(20)
 
+/* Describes the alignment state of a Rx buffer */
+enum wl_rx_buf_align {
+	WLCORE_RX_BUF_ALIGNED,
+	WLCORE_RX_BUF_UNALIGNED,
+	WLCORE_RX_BUF_PADDED,
+};
+
 enum {
 	WL12XX_RX_CLASS_UNKNOWN,
 	WL12XX_RX_CLASS_MANAGEMENT,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 9fc57e8..3c2ded5 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -27,11 +27,12 @@
 #include "wl12xx.h"
 #include "event.h"
 
-struct wl1271_tx_hw_descr;
-
 /* The maximum number of Tx descriptors in all chip families */
 #define WLCORE_MAX_TX_DESCRIPTORS 32
 
+/* forward declaration */
+struct wl1271_tx_hw_descr;
+enum wl_rx_buf_align;
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
@@ -44,6 +45,8 @@ struct wlcore_ops {
 	void (*set_tx_desc_data_len)(struct wl1271 *wl,
 				     struct wl1271_tx_hw_descr *desc,
 				     struct sk_buff *skb);
+	enum wl_rx_buf_align (*get_rx_buf_align)(struct wl1271 *wl,
+						 u32 rx_desc);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

