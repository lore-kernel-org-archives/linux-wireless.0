Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61850 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab0I1PH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:07:58 -0400
Received: by wwd20 with SMTP id 20so96229wwd.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 08:07:56 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/2] wl1271: Support firmware TX packet aggregation
Date: Tue, 28 Sep 2010 17:07:44 +0200
Message-Id: <1285686464-8668-3-git-send-email-ido@wizery.com>
In-Reply-To: <1285686464-8668-1-git-send-email-ido@wizery.com>
References: <1285686464-8668-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of sending one packet at a time to the firmware, try to
send all available packets at once.
This optimization decreases the number of transactions, which saves
CPU cycles and increases network throughput.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |   99 ++++++++++++-------------------
 1 files changed, 37 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 1b8295c..e3dc13c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -43,13 +43,17 @@ static int wl1271_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 	return -EBUSY;
 }
 
-static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
+static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
+				u32 buf_offset)
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 total_blocks;
 	int id, ret = -EBUSY;
 
+	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
+		return -EBUSY;
+
 	/* allocate free identifier for the packet */
 	id = wl1271_tx_id(wl, skb);
 	if (id < 0)
@@ -82,7 +86,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 	return ret;
 }
 
-static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
+static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 			      u32 extra, struct ieee80211_tx_info *control)
 {
 	struct timespec ts;
@@ -133,59 +137,17 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d", pad);
-	return 0;
-}
-
-static int wl1271_tx_send_packet(struct wl1271 *wl, struct sk_buff *skb,
-				 struct ieee80211_tx_info *control)
-{
-
-	struct wl1271_tx_hw_descr *desc;
-	int len;
-
-	/* FIXME: This is a workaround for getting non-aligned packets.
-	   This happens at least with EAPOL packets from the user space.
-	   Our DMA requires packets to be aligned on a 4-byte boundary.
-	*/
-	if (unlikely((long)skb->data & 0x03)) {
-		int offset = (4 - (long)skb->data) & 0x03;
-		wl1271_debug(DEBUG_TX, "skb offset %d", offset);
-
-		/* check whether the current skb can be used */
-		if (!skb_cloned(skb) && (skb_tailroom(skb) >= offset)) {
-			unsigned char *src = skb->data;
-
-			/* align the buffer on a 4-byte boundary */
-			skb_reserve(skb, offset);
-			memmove(skb->data, src, skb->len);
-		} else {
-			wl1271_info("No handler, fixme!");
-			return -EINVAL;
-		}
-	}
-
-	len = WL1271_TX_ALIGN(skb->len);
-
-	/* perform a fixed address block write with the packet */
-	wl1271_write(wl, WL1271_SLV_MEM_DATA, skb->data, len, true);
-
-	/* write packet new counter into the write access register */
-	wl->tx_packets_count++;
-
-	desc = (struct wl1271_tx_hw_descr *) skb->data;
-	wl1271_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u (%u words)",
-		     desc->id, skb, len, desc->length);
-
-	return 0;
 }
 
 /* caller must hold wl->mutex */
-static int wl1271_tx_frame(struct wl1271 *wl, struct sk_buff *skb)
+static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
+							u32 buf_offset)
 {
 	struct ieee80211_tx_info *info;
 	u32 extra = 0;
 	int ret = 0;
 	u8 idx;
+	u32 total_len;
 
 	if (!skb)
 		return -EINVAL;
@@ -208,19 +170,22 @@ static int wl1271_tx_frame(struct wl1271 *wl, struct sk_buff *skb)
 		}
 	}
 
-	ret = wl1271_tx_allocate(wl, skb, extra);
+	ret = wl1271_tx_allocate(wl, skb, extra, buf_offset);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_tx_fill_hdr(wl, skb, extra, info);
-	if (ret < 0)
-		return ret;
+	wl1271_tx_fill_hdr(wl, skb, extra, info);
 
-	ret = wl1271_tx_send_packet(wl, skb, info);
-	if (ret < 0)
-		return ret;
+	/*
+	 * The length of each packet is stored in terms of words. Thus, we must
+	 * pad the skb data to make sure its length is aligned.
+	 * The number of padding bytes is computed and set in wl1271_tx_fill_hdr
+	 */
+	total_len = WL1271_TX_ALIGN(skb->len);
+	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
+	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
 
-	return ret;
+	return total_len;
 }
 
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
@@ -245,7 +210,7 @@ void wl1271_tx_work(struct work_struct *work)
 	struct sk_buff *skb;
 	bool woken_up = false;
 	u32 sta_rates = 0;
-	u32 prev_tx_packets_count;
+	u32 buf_offset;
 	int ret;
 
 	/* check if the rates supported by the AP have changed */
@@ -262,14 +227,15 @@ void wl1271_tx_work(struct work_struct *work)
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	prev_tx_packets_count = wl->tx_packets_count;
-
 	/* if rates have changed, re-configure the rate policy */
 	if (unlikely(sta_rates)) {
 		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
 		wl1271_acx_rate_policies(wl);
 	}
 
+	/* Prepare the transfer buffer, by aggregating all
+	 * available packets */
+	buf_offset = 0;
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
 			ret = wl1271_ps_elp_wakeup(wl, false);
@@ -278,21 +244,30 @@ void wl1271_tx_work(struct work_struct *work)
 			woken_up = true;
 		}
 
-		ret = wl1271_tx_frame(wl, skb);
+		ret = wl1271_prepare_tx_frame(wl, skb, buf_offset);
 		if (ret == -EBUSY) {
-			/* firmware buffer is full, lets stop transmitting. */
+			/*
+			 * Either the firmware buffer is full, or the
+			 * aggregation buffer is.
+			 * Queue back last skb, and stop aggregating.
+			 */
 			skb_queue_head(&wl->tx_queue, skb);
 			goto out_ack;
 		} else if (ret < 0) {
 			dev_kfree_skb(skb);
 			goto out_ack;
 		}
+		buf_offset += ret;
+		wl->tx_packets_count++;
 	}
 
 out_ack:
-	/* interrupt the firmware with the new packets */
-	if (prev_tx_packets_count != wl->tx_packets_count)
+	if (buf_offset) {
+		wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
+				buf_offset, true);
+		/* interrupt the firmware with the new packets */
 		wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
+	}
 
 out:
 	if (woken_up)
-- 
1.7.0.4

