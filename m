Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60909 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0JLIyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 04:54:06 -0400
Received: by wye20 with SMTP id 20so1182931wye.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 01:54:04 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 1/4] wl1271: TX aggregation optimization
Date: Tue, 12 Oct 2010 10:53:50 +0200
Message-Id: <1286873633-10080-2-git-send-email-ido@wizery.com>
In-Reply-To: <1286873633-10080-1-git-send-email-ido@wizery.com>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case the aggregation buffer is too small to hold all available packets,
the buffer is transferred to the FW and no more packets are aggregated.
Although there may be enough available TX blocks, no additional packets will
be handled by the current TX work.

Fix this by flushing the aggregation buffer when it's full, and continue
transferring packets as long as there are enough available TX blocks.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index e3dc13c..b13b373 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -52,7 +52,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	int id, ret = -EBUSY;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
-		return -EBUSY;
+		return -EAGAIN;
 
 	/* allocate free identifier for the packet */
 	id = wl1271_tx_id(wl, skb);
@@ -210,7 +210,8 @@ void wl1271_tx_work(struct work_struct *work)
 	struct sk_buff *skb;
 	bool woken_up = false;
 	u32 sta_rates = 0;
-	u32 buf_offset;
+	u32 buf_offset = 0;
+	bool sent_packets = false;
 	int ret;
 
 	/* check if the rates supported by the AP have changed */
@@ -233,9 +234,6 @@ void wl1271_tx_work(struct work_struct *work)
 		wl1271_acx_rate_policies(wl);
 	}
 
-	/* Prepare the transfer buffer, by aggregating all
-	 * available packets */
-	buf_offset = 0;
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
 			ret = wl1271_ps_elp_wakeup(wl, false);
@@ -245,10 +243,20 @@ void wl1271_tx_work(struct work_struct *work)
 		}
 
 		ret = wl1271_prepare_tx_frame(wl, skb, buf_offset);
-		if (ret == -EBUSY) {
+		if (ret == -EAGAIN) {
 			/*
-			 * Either the firmware buffer is full, or the
-			 * aggregation buffer is.
+			 * Aggregation buffer is full.
+			 * Flush buffer and try again.
+			 */
+			skb_queue_head(&wl->tx_queue, skb);
+			wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
+				buf_offset, true);
+			sent_packets = true;
+			buf_offset = 0;
+			continue;
+		} else if (ret == -EBUSY) {
+			/*
+			 * Firmware buffer is full.
 			 * Queue back last skb, and stop aggregating.
 			 */
 			skb_queue_head(&wl->tx_queue, skb);
@@ -265,6 +273,9 @@ out_ack:
 	if (buf_offset) {
 		wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
 				buf_offset, true);
+		sent_packets = true;
+	}
+	if (sent_packets) {
 		/* interrupt the firmware with the new packets */
 		wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
 	}
-- 
1.7.0.4

