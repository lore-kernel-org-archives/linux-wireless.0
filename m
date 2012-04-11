Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:47213 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933057Ab2DKTyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:01 -0400
Received: by lagr15 with SMTP id r15so1131725lag.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:58 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 11/24] wlcore/wl12xx: split Tx completion to immediate/delayed
Date: Wed, 11 Apr 2012 22:53:27 +0300
Message-Id: <1334174020-18957-12-git-send-email-coelho@ti.com> (sfid-20120411_215417_082930_5AF1D0DE)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

One chip family employs immediate Tx completion, where knowledge of
completed packets is given as part of the FW status. Another is only
notified of Tx completion via the FW status, and has to read the
completion status of the packets from a different location.

Implement the wl12xx tx completion as a delayed Tx completion.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   10 ++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |   12 ++++++++++++
 drivers/net/wireless/ti/wlcore/main.c   |    8 +++++---
 drivers/net/wireless/ti/wlcore/tx.c     |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 ++
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 5f81aaf..6b187d0 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -789,6 +789,14 @@ static u32 wl12xx_get_rx_packet_len(struct wl1271 *wl, void *rx_data,
 	return data_len - sizeof(*desc) - desc->pad_len;
 }
 
+static void wl12xx_tx_delayed_compl(struct wl1271 *wl)
+{
+	if (wl->fw_status->tx_results_counter == (wl->tx_results_count & 0xff))
+		return;
+
+	wl1271_tx_complete(wl);
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -862,6 +870,8 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_tx_desc_data_len	= wl12xx_set_tx_desc_data_len,
 	.get_rx_buf_align	= wl12xx_get_rx_buf_align,
 	.get_rx_packet_len	= wl12xx_get_rx_packet_len,
+	.tx_immediate_compl	= NULL,
+	.tx_delayed_compl	= wl12xx_tx_delayed_compl,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 876f1a1..14748d3 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -81,5 +81,17 @@ wlcore_hw_get_rx_packet_len(struct wl1271 *wl, void *rx_data, u32 data_len)
 	return wl->ops->get_rx_packet_len(wl, rx_data, data_len);
 }
 
+static inline void wlcore_hw_tx_delayed_compl(struct wl1271 *wl)
+{
+	if (wl->ops->tx_delayed_compl)
+		wl->ops->tx_delayed_compl(wl);
+}
+
+static inline void wlcore_hw_tx_immediate_compl(struct wl1271 *wl)
+{
+	if (wl->ops->tx_immediate_compl)
+		wl->ops->tx_immediate_compl(wl);
+}
+
 #endif
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3f558d5..0392166 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -49,6 +49,7 @@
 #include "boot.h"
 #include "testmode.h"
 #include "scan.h"
+#include "hw_ops.h"
 
 #define WL1271_BOOT_RETRIES 3
 
@@ -933,6 +934,9 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		smp_mb__after_clear_bit();
 
 		wl12xx_fw_status(wl, wl->fw_status);
+
+		wlcore_hw_tx_immediate_compl(wl);
+
 		intr = le32_to_cpu(wl->fw_status->intr);
 		intr &= WL1271_INTR_MASK;
 		if (!intr) {
@@ -969,9 +973,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 			}
 
 			/* check for tx results */
-			if (wl->fw_status->tx_results_counter !=
-			    (wl->tx_results_count & 0xff))
-				wl1271_tx_complete(wl);
+			wlcore_hw_tx_delayed_compl(wl);
 
 			/* Make sure the deferred queues don't get too long */
 			defer_count = skb_queue_len(&wl->deferred_tx_queue) +
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 1fabc48..d1811b8 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -905,6 +905,7 @@ void wl1271_tx_complete(struct wl1271 *wl)
 		wl->tx_results_count++;
 	}
 }
+EXPORT_SYMBOL(wl1271_tx_complete);
 
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 664df32..29b39f9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -51,6 +51,8 @@ struct wlcore_ops {
 	void (*prepare_read)(struct wl1271 *wl, u32 rx_desc, u32 len);
 	u32 (*get_rx_packet_len)(struct wl1271 *wl, void *rx_data,
 				 u32 data_len);
+	void (*tx_delayed_compl)(struct wl1271 *wl);
+	void (*tx_immediate_compl)(struct wl1271 *wl);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

