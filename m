Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63899 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbZFLLQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:08 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 15/33] wl12xx: Moved wl1251 TX path implementation into chip
	specific files
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:54 +0300
Message-ID: <20090612111553.8877.64008.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Moved wl1251 TX path implementation into chip specific files to enable
parallel implementation for the wl1271 TX path.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/Makefile    |    4 
 drivers/net/wireless/wl12xx/main.c      |   13 -
 drivers/net/wireless/wl12xx/tx.c        |  557 -------------------------------
 drivers/net/wireless/wl12xx/tx.h        |  215 ------------
 drivers/net/wireless/wl12xx/wl1251.c    |    7 
 drivers/net/wireless/wl12xx/wl1251_tx.c |  557 +++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_tx.h |  216 ++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h    |    1 
 8 files changed, 789 insertions(+), 781 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/tx.c
 delete mode 100644 drivers/net/wireless/wl12xx/tx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_tx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251_tx.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index d43de27..7e05ea3 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,4 +1,4 @@
-wl12xx-objs		= main.o spi.o event.o tx.o rx.o \
-			  ps.o cmd.o acx.o boot.o init.o wl1251.o \
+wl12xx-objs		= main.o spi.o event.o wl1251_tx.o rx.o \
+			  ps.o cmd.o acx.o boot.o init.o wl1251.o  \
 			  debugfs.o
 obj-$(CONFIG_WL12XX)	+= wl12xx.o
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 73232db..8feba36 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -37,7 +37,7 @@
 #include "wl1251.h"
 #include "spi.h"
 #include "event.h"
-#include "tx.h"
+#include "wl1251_tx.h"
 #include "rx.h"
 #include "ps.h"
 #include "init.h"
@@ -303,6 +303,11 @@ static int wl12xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	skb_queue_tail(&wl->tx_queue, skb);
 
+	/*
+	 * The chip specific setup must run before the first TX packet -
+	 * before that, the tx_work will not be initialized!
+	 */
+
 	schedule_work(&wl->tx_work);
 
 	/*
@@ -400,8 +405,7 @@ static void wl12xx_op_stop(struct ieee80211_hw *hw)
 	mutex_lock(&wl->mutex);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl12xx_tx_flush(wl);
-
+	wl->chip.op_tx_flush(wl);
 	wl12xx_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
@@ -1176,7 +1180,7 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 {
 	/* The tx descriptor buffer and the TKIP space */
 	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
-		+ WL12XX_TKIP_IV_SPACE;
+		+ WL1251_TKIP_IV_SPACE;
 
 	/* unit us */
 	/* FIXME: find a proper value */
@@ -1226,7 +1230,6 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 
 	skb_queue_head_init(&wl->tx_queue);
 
-	INIT_WORK(&wl->tx_work, wl12xx_tx_work);
 	INIT_WORK(&wl->filter_work, wl12xx_filter_work);
 	wl->channel = WL12XX_DEFAULT_CHANNEL;
 	wl->scanning = false;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
deleted file mode 100644
index 62145e2..0000000
--- a/drivers/net/wireless/wl12xx/tx.c
+++ /dev/null
@@ -1,557 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include "wl12xx.h"
-#include "reg.h"
-#include "spi.h"
-#include "tx.h"
-#include "ps.h"
-
-static bool wl12xx_tx_double_buffer_busy(struct wl12xx *wl, u32 data_out_count)
-{
-	int used, data_in_count;
-
-	data_in_count = wl->data_in_count;
-
-	if (data_in_count < data_out_count)
-		/* data_in_count has wrapped */
-		data_in_count += TX_STATUS_DATA_OUT_COUNT_MASK + 1;
-
-	used = data_in_count - data_out_count;
-
-	WARN_ON(used < 0);
-	WARN_ON(used > DP_TX_PACKET_RING_CHUNK_NUM);
-
-	if (used >= DP_TX_PACKET_RING_CHUNK_NUM)
-		return true;
-	else
-		return false;
-}
-
-static int wl12xx_tx_path_status(struct wl12xx *wl)
-{
-	u32 status, addr, data_out_count;
-	bool busy;
-
-	addr = wl->data_path->tx_control_addr;
-	status = wl12xx_mem_read32(wl, addr);
-	data_out_count = status & TX_STATUS_DATA_OUT_COUNT_MASK;
-	busy = wl12xx_tx_double_buffer_busy(wl, data_out_count);
-
-	if (busy)
-		return -EBUSY;
-
-	return 0;
-}
-
-static int wl12xx_tx_id(struct wl12xx *wl, struct sk_buff *skb)
-{
-	int i;
-
-	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
-		if (wl->tx_frames[i] == NULL) {
-			wl->tx_frames[i] = skb;
-			return i;
-		}
-
-	return -EBUSY;
-}
-
-static void wl12xx_tx_control(struct tx_double_buffer_desc *tx_hdr,
-			      struct ieee80211_tx_info *control, u16 fc)
-{
-	*(u16 *)&tx_hdr->control = 0;
-
-	tx_hdr->control.rate_policy = 0;
-
-	/* 802.11 packets */
-	tx_hdr->control.packet_type = 0;
-
-	if (control->flags & IEEE80211_TX_CTL_NO_ACK)
-		tx_hdr->control.ack_policy = 1;
-
-	tx_hdr->control.tx_complete = 1;
-
-	if ((fc & IEEE80211_FTYPE_DATA) &&
-	    ((fc & IEEE80211_STYPE_QOS_DATA) ||
-	     (fc & IEEE80211_STYPE_QOS_NULLFUNC)))
-		tx_hdr->control.qos = 1;
-}
-
-/* RSN + MIC = 8 + 8 = 16 bytes (worst case - AES). */
-#define MAX_MSDU_SECURITY_LENGTH      16
-#define MAX_MPDU_SECURITY_LENGTH      16
-#define WLAN_QOS_HDR_LEN              26
-#define MAX_MPDU_HEADER_AND_SECURITY  (MAX_MPDU_SECURITY_LENGTH + \
-				       WLAN_QOS_HDR_LEN)
-#define HW_BLOCK_SIZE                 252
-static void wl12xx_tx_frag_block_num(struct tx_double_buffer_desc *tx_hdr)
-{
-	u16 payload_len, frag_threshold, mem_blocks;
-	u16 num_mpdus, mem_blocks_per_frag;
-
-	frag_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
-	tx_hdr->frag_threshold = cpu_to_le16(frag_threshold);
-
-	payload_len = tx_hdr->length + MAX_MSDU_SECURITY_LENGTH;
-
-	if (payload_len > frag_threshold) {
-		mem_blocks_per_frag =
-			((frag_threshold + MAX_MPDU_HEADER_AND_SECURITY) /
-			 HW_BLOCK_SIZE) + 1;
-		num_mpdus = payload_len / frag_threshold;
-		mem_blocks = num_mpdus * mem_blocks_per_frag;
-		payload_len -= num_mpdus * frag_threshold;
-		num_mpdus++;
-
-	} else {
-		mem_blocks_per_frag = 0;
-		mem_blocks = 0;
-		num_mpdus = 1;
-	}
-
-	mem_blocks += (payload_len / HW_BLOCK_SIZE) + 1;
-
-	if (num_mpdus > 1)
-		mem_blocks += min(num_mpdus, mem_blocks_per_frag);
-
-	tx_hdr->num_mem_blocks = mem_blocks;
-}
-
-static int wl12xx_tx_fill_hdr(struct wl12xx *wl, struct sk_buff *skb,
-			      struct ieee80211_tx_info *control)
-{
-	struct tx_double_buffer_desc *tx_hdr;
-	struct ieee80211_rate *rate;
-	int id;
-	u16 fc;
-
-	if (!skb)
-		return -EINVAL;
-
-	id = wl12xx_tx_id(wl, skb);
-	if (id < 0)
-		return id;
-
-	fc = *(u16 *)skb->data;
-	tx_hdr = (struct tx_double_buffer_desc *) skb_push(skb,
-							   sizeof(*tx_hdr));
-
-	tx_hdr->length = cpu_to_le16(skb->len - sizeof(*tx_hdr));
-	rate = ieee80211_get_tx_rate(wl->hw, control);
-	tx_hdr->rate = cpu_to_le16(rate->hw_value);
-	tx_hdr->expiry_time = cpu_to_le32(1 << 16);
-	tx_hdr->id = id;
-
-	/* FIXME: how to get the correct queue id? */
-	tx_hdr->xmit_queue = 0;
-
-	wl12xx_tx_control(tx_hdr, control, fc);
-	wl12xx_tx_frag_block_num(tx_hdr);
-
-	return 0;
-}
-
-/* We copy the packet to the target */
-static int wl12xx_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
-				 struct ieee80211_tx_info *control)
-{
-	struct tx_double_buffer_desc *tx_hdr;
-	int len;
-	u32 addr;
-
-	if (!skb)
-		return -EINVAL;
-
-	tx_hdr = (struct tx_double_buffer_desc *) skb->data;
-
-	if (control->control.hw_key &&
-	    control->control.hw_key->alg == ALG_TKIP) {
-		int hdrlen;
-		u16 fc;
-		u8 *pos;
-
-		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
-		tx_hdr->length += WL12XX_TKIP_IV_SPACE;
-
-		hdrlen = ieee80211_hdrlen(fc);
-
-		pos = skb_push(skb, WL12XX_TKIP_IV_SPACE);
-		memmove(pos, pos + WL12XX_TKIP_IV_SPACE,
-			sizeof(*tx_hdr) + hdrlen);
-	}
-
-	/* Revisit. This is a workaround for getting non-aligned packets.
-	   This happens at least with EAPOL packets from the user space.
-	   Our DMA requires packets to be aligned on a 4-byte boundary.
-	*/
-	if (unlikely((long)skb->data & 0x03)) {
-		int offset = (4 - (long)skb->data) & 0x03;
-		wl12xx_debug(DEBUG_TX, "skb offset %d", offset);
-
-		/* check whether the current skb can be used */
-		if (!skb_cloned(skb) && (skb_tailroom(skb) >= offset)) {
-			unsigned char *src = skb->data;
-
-			/* align the buffer on a 4-byte boundary */
-			skb_reserve(skb, offset);
-			memmove(skb->data, src, skb->len);
-		} else {
-			wl12xx_info("No handler, fixme!");
-			return -EINVAL;
-		}
-	}
-
-	/* Our skb->data at this point includes the HW header */
-	len = WL12XX_TX_ALIGN(skb->len);
-
-	if (wl->data_in_count & 0x1)
-		addr = wl->data_path->tx_packet_ring_addr +
-			wl->data_path->tx_packet_ring_chunk_size;
-	else
-		addr = wl->data_path->tx_packet_ring_addr;
-
-	wl12xx_spi_mem_write(wl, addr, skb->data, len);
-
-	wl12xx_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
-		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
-
-	return 0;
-}
-
-static void wl12xx_tx_trigger(struct wl12xx *wl)
-{
-	u32 data, addr;
-
-	if (wl->data_in_count & 0x1) {
-		addr = ACX_REG_INTERRUPT_TRIG_H;
-		data = INTR_TRIG_TX_PROC1;
-	} else {
-		addr = ACX_REG_INTERRUPT_TRIG;
-		data = INTR_TRIG_TX_PROC0;
-	}
-
-	wl12xx_reg_write32(wl, addr, data);
-
-	/* Bumping data in */
-	wl->data_in_count = (wl->data_in_count + 1) &
-		TX_STATUS_DATA_OUT_COUNT_MASK;
-}
-
-/* caller must hold wl->mutex */
-static int wl12xx_tx_frame(struct wl12xx *wl, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info;
-	int ret = 0;
-	u8 idx;
-
-	info = IEEE80211_SKB_CB(skb);
-
-	if (info->control.hw_key) {
-		idx = info->control.hw_key->hw_key_idx;
-		if (unlikely(wl->default_key != idx)) {
-			ret = wl12xx_acx_default_key(wl, idx);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	ret = wl12xx_tx_path_status(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_tx_fill_hdr(wl, skb, info);
-	if (ret < 0)
-		return ret;
-
-	ret = wl12xx_tx_send_packet(wl, skb, info);
-	if (ret < 0)
-		return ret;
-
-	wl12xx_tx_trigger(wl);
-
-	return ret;
-}
-
-void wl12xx_tx_work(struct work_struct *work)
-{
-	struct wl12xx *wl = container_of(work, struct wl12xx, tx_work);
-	struct sk_buff *skb;
-	bool woken_up = false;
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	if (unlikely(wl->state == WL12XX_STATE_OFF))
-		goto out;
-
-	while ((skb = skb_dequeue(&wl->tx_queue))) {
-		if (!woken_up) {
-			wl12xx_ps_elp_wakeup(wl);
-			woken_up = true;
-		}
-
-		ret = wl12xx_tx_frame(wl, skb);
-		if (ret == -EBUSY) {
-			/* firmware buffer is full, stop queues */
-			wl12xx_debug(DEBUG_TX, "tx_work: fw buffer full, "
-				     "stop queues");
-			ieee80211_stop_queues(wl->hw);
-			wl->tx_queue_stopped = true;
-			skb_queue_head(&wl->tx_queue, skb);
-			goto out;
-		} else if (ret < 0) {
-			dev_kfree_skb(skb);
-			goto out;
-		}
-	}
-
-out:
-	if (woken_up)
-		wl12xx_ps_elp_sleep(wl);
-
-	mutex_unlock(&wl->mutex);
-}
-
-static const char *wl12xx_tx_parse_status(u8 status)
-{
-	/* 8 bit status field, one character per bit plus null */
-	static char buf[9];
-	int i = 0;
-
-	memset(buf, 0, sizeof(buf));
-
-	if (status & TX_DMA_ERROR)
-		buf[i++] = 'm';
-	if (status & TX_DISABLED)
-		buf[i++] = 'd';
-	if (status & TX_RETRY_EXCEEDED)
-		buf[i++] = 'r';
-	if (status & TX_TIMEOUT)
-		buf[i++] = 't';
-	if (status & TX_KEY_NOT_FOUND)
-		buf[i++] = 'k';
-	if (status & TX_ENCRYPT_FAIL)
-		buf[i++] = 'e';
-	if (status & TX_UNAVAILABLE_PRIORITY)
-		buf[i++] = 'p';
-
-	/* bit 0 is unused apparently */
-
-	return buf;
-}
-
-static void wl12xx_tx_packet_cb(struct wl12xx *wl,
-				struct tx_result *result)
-{
-	struct ieee80211_tx_info *info;
-	struct sk_buff *skb;
-	int hdrlen, ret;
-	u8 *frame;
-
-	skb = wl->tx_frames[result->id];
-	if (skb == NULL) {
-		wl12xx_error("SKB for packet %d is NULL", result->id);
-		return;
-	}
-
-	info = IEEE80211_SKB_CB(skb);
-
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-	    (result->status == TX_SUCCESS))
-		info->flags |= IEEE80211_TX_STAT_ACK;
-
-	info->status.rates[0].count = result->ack_failures + 1;
-	wl->stats.retry_count += result->ack_failures;
-
-	/*
-	 * We have to remove our private TX header before pushing
-	 * the skb back to mac80211.
-	 */
-	frame = skb_pull(skb, sizeof(struct tx_double_buffer_desc));
-	if (info->control.hw_key &&
-	    info->control.hw_key->alg == ALG_TKIP) {
-		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		memmove(frame + WL12XX_TKIP_IV_SPACE, frame, hdrlen);
-		skb_pull(skb, WL12XX_TKIP_IV_SPACE);
-	}
-
-	wl12xx_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
-		     " status 0x%x (%s)",
-		     result->id, skb, result->ack_failures, result->rate,
-		     result->status, wl12xx_tx_parse_status(result->status));
-
-
-	ieee80211_tx_status(wl->hw, skb);
-
-	wl->tx_frames[result->id] = NULL;
-
-	if (wl->tx_queue_stopped) {
-		wl12xx_debug(DEBUG_TX, "cb: queue was stopped");
-
-		skb = skb_dequeue(&wl->tx_queue);
-
-		/* The skb can be NULL because tx_work might have been
-		   scheduled before the queue was stopped making the
-		   queue empty */
-
-		if (skb) {
-			ret = wl12xx_tx_frame(wl, skb);
-			if (ret == -EBUSY) {
-				/* firmware buffer is still full */
-				wl12xx_debug(DEBUG_TX, "cb: fw buffer "
-					     "still full");
-				skb_queue_head(&wl->tx_queue, skb);
-				return;
-			} else if (ret < 0) {
-				dev_kfree_skb(skb);
-				return;
-			}
-		}
-
-		wl12xx_debug(DEBUG_TX, "cb: waking queues");
-		ieee80211_wake_queues(wl->hw);
-		wl->tx_queue_stopped = false;
-	}
-}
-
-/* Called upon reception of a TX complete interrupt */
-void wl12xx_tx_complete(struct wl12xx *wl)
-{
-	int i, result_index, num_complete = 0;
-	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
-
-	if (unlikely(wl->state != WL12XX_STATE_ON))
-		return;
-
-	/* First we read the result */
-	wl12xx_spi_mem_read(wl, wl->data_path->tx_complete_addr,
-			    result, sizeof(result));
-
-	result_index = wl->next_tx_complete;
-
-	for (i = 0; i < ARRAY_SIZE(result); i++) {
-		result_ptr = &result[result_index];
-
-		if (result_ptr->done_1 == 1 &&
-		    result_ptr->done_2 == 1) {
-			wl12xx_tx_packet_cb(wl, result_ptr);
-
-			result_ptr->done_1 = 0;
-			result_ptr->done_2 = 0;
-
-			result_index = (result_index + 1) &
-				(FW_TX_CMPLT_BLOCK_SIZE - 1);
-			num_complete++;
-		} else {
-			break;
-		}
-	}
-
-	/* Every completed frame needs to be acknowledged */
-	if (num_complete) {
-		/*
-		 * If we've wrapped, we have to clear
-		 * the results in 2 steps.
-		 */
-		if (result_index > wl->next_tx_complete) {
-			/* Only 1 write is needed */
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr +
-					     (wl->next_tx_complete *
-					      sizeof(struct tx_result)),
-					     &result[wl->next_tx_complete],
-					     num_complete *
-					     sizeof(struct tx_result));
-
-
-		} else if (result_index < wl->next_tx_complete) {
-			/* 2 writes are needed */
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr +
-					     (wl->next_tx_complete *
-					      sizeof(struct tx_result)),
-					     &result[wl->next_tx_complete],
-					     (FW_TX_CMPLT_BLOCK_SIZE -
-					      wl->next_tx_complete) *
-					     sizeof(struct tx_result));
-
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr,
-					     result,
-					     (num_complete -
-					      FW_TX_CMPLT_BLOCK_SIZE +
-					      wl->next_tx_complete) *
-					     sizeof(struct tx_result));
-
-		} else {
-			/* We have to write the whole array */
-			wl12xx_spi_mem_write(wl,
-					     wl->data_path->tx_complete_addr,
-					     result,
-					     FW_TX_CMPLT_BLOCK_SIZE *
-					     sizeof(struct tx_result));
-		}
-
-	}
-
-	wl->next_tx_complete = result_index;
-}
-
-/* caller must hold wl->mutex */
-void wl12xx_tx_flush(struct wl12xx *wl)
-{
-	int i;
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *info;
-
-	/* TX failure */
-/* 	control->flags = 0; FIXME */
-
-	while ((skb = skb_dequeue(&wl->tx_queue))) {
-		info = IEEE80211_SKB_CB(skb);
-
-		wl12xx_debug(DEBUG_TX, "flushing skb 0x%p", skb);
-
-		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
-				continue;
-
-		ieee80211_tx_status(wl->hw, skb);
-	}
-
-	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
-		if (wl->tx_frames[i] != NULL) {
-			skb = wl->tx_frames[i];
-			info = IEEE80211_SKB_CB(skb);
-
-			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
-				continue;
-
-			ieee80211_tx_status(wl->hw, skb);
-			wl->tx_frames[i] = NULL;
-		}
-}
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
deleted file mode 100644
index dc82691..0000000
--- a/drivers/net/wireless/wl12xx/tx.h
+++ /dev/null
@@ -1,215 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_TX_H__
-#define __WL12XX_TX_H__
-
-#include <linux/bitops.h>
-
-/*
- *
- * TX PATH
- *
- * The Tx path uses a double buffer and a tx_control structure, each located
- * at a fixed address in the device's memory. On startup, the host retrieves
- * the pointers to these addresses. A double buffer allows for continuous data
- * flow towards the device. The host keeps track of which buffer is available
- * and alternates between these two buffers on a per packet basis.
- *
- * The size of each of the two buffers is large enough to hold the longest
- * 802.3 packet - maximum size Ethernet packet + header + descriptor.
- * TX complete indication will be received a-synchronously in a TX done cyclic
- * buffer which is composed of 16 tx_result descriptors structures and is used
- * in a cyclic manner.
- *
- * The TX (HOST) procedure is as follows:
- * 1. Read the Tx path status, that will give the data_out_count.
- * 2. goto 1, if not possible.
- *    i.e. if data_in_count - data_out_count >= HwBuffer size (2 for double
- *    buffer).
- * 3. Copy the packet (preceded by double_buffer_desc), if possible.
- *    i.e. if data_in_count - data_out_count < HwBuffer size (2 for double
- *    buffer).
- * 4. increment data_in_count.
- * 5. Inform the firmware by generating a firmware internal interrupt.
- * 6. FW will increment data_out_count after it reads the buffer.
- *
- * The TX Complete procedure:
- * 1. To get a TX complete indication the host enables the tx_complete flag in
- *    the TX descriptor Structure.
- * 2. For each packet with a Tx Complete field set, the firmware adds the
- *    transmit results to the cyclic buffer (txDoneRing) and sets both done_1
- *    and done_2 to 1 to indicate driver ownership.
- * 3. The firmware sends a Tx Complete interrupt to the host to trigger the
- *    host to process the new data. Note: interrupt will be send per packet if
- *    TX complete indication was requested in tx_control or per crossing
- *    aggregation threshold.
- * 4. After receiving the Tx Complete interrupt, the host reads the
- *    TxDescriptorDone information in a cyclic manner and clears both done_1
- *    and done_2 fields.
- *
- */
-
-#define TX_COMPLETE_REQUIRED_BIT	0x80
-#define TX_STATUS_DATA_OUT_COUNT_MASK   0xf
-#define WL12XX_TX_ALIGN_TO 4
-#define WL12XX_TX_ALIGN(len) (((len) + WL12XX_TX_ALIGN_TO - 1) & \
-			     ~(WL12XX_TX_ALIGN_TO - 1))
-#define WL12XX_TKIP_IV_SPACE 4
-
-struct tx_control {
-	/* Rate Policy (class) index */
-	unsigned rate_policy:3;
-
-	/* When set, no ack policy is expected */
-	unsigned ack_policy:1;
-
-	/*
-	 * Packet type:
-	 * 0 -> 802.11
-	 * 1 -> 802.3
-	 * 2 -> IP
-	 * 3 -> raw codec
-	 */
-	unsigned packet_type:2;
-
-	/* If set, this is a QoS-Null or QoS-Data frame */
-	unsigned qos:1;
-
-	/*
-	 * If set, the target triggers the tx complete INT
-	 * upon frame sending completion.
-	 */
-	unsigned tx_complete:1;
-
-	/* 2 bytes padding before packet header */
-	unsigned xfer_pad:1;
-
-	unsigned reserved:7;
-} __attribute__ ((packed));
-
-
-struct tx_double_buffer_desc {
-	/* Length of payload, including headers. */
-	u16 length;
-
-	/*
-	 * A bit mask that specifies the initial rate to be used
-	 * Possible values are:
-	 * 0x0001 - 1Mbits
-	 * 0x0002 - 2Mbits
-	 * 0x0004 - 5.5Mbits
-	 * 0x0008 - 6Mbits
-	 * 0x0010 - 9Mbits
-	 * 0x0020 - 11Mbits
-	 * 0x0040 - 12Mbits
-	 * 0x0080 - 18Mbits
-	 * 0x0100 - 22Mbits
-	 * 0x0200 - 24Mbits
-	 * 0x0400 - 36Mbits
-	 * 0x0800 - 48Mbits
-	 * 0x1000 - 54Mbits
-	 */
-	u16 rate;
-
-	/* Time in us that a packet can spend in the target */
-	u32 expiry_time;
-
-	/* index of the TX queue used for this packet */
-	u8 xmit_queue;
-
-	/* Used to identify a packet */
-	u8 id;
-
-	struct tx_control control;
-
-	/*
-	 * The FW should cut the packet into fragments
-	 * of this size.
-	 */
-	u16 frag_threshold;
-
-	/* Numbers of HW queue blocks to be allocated */
-	u8 num_mem_blocks;
-
-	u8 reserved;
-} __attribute__ ((packed));
-
-enum {
-	TX_SUCCESS              = 0,
-	TX_DMA_ERROR            = BIT(7),
-	TX_DISABLED             = BIT(6),
-	TX_RETRY_EXCEEDED       = BIT(5),
-	TX_TIMEOUT              = BIT(4),
-	TX_KEY_NOT_FOUND        = BIT(3),
-	TX_ENCRYPT_FAIL         = BIT(2),
-	TX_UNAVAILABLE_PRIORITY = BIT(1),
-};
-
-struct tx_result {
-	/*
-	 * Ownership synchronization between the host and
-	 * the firmware. If done_1 and done_2 are cleared,
-	 * owned by the FW (no info ready).
-	 */
-	u8 done_1;
-
-	/* same as double_buffer_desc->id */
-	u8 id;
-
-	/*
-	 * Total air access duration consumed by this
-	 * packet, including all retries and overheads.
-	 */
-	u16 medium_usage;
-
-	/* Total media delay (from 1st EDCA AIFS counter until TX Complete). */
-	u32 medium_delay;
-
-	/* Time between host xfer and tx complete */
-	u32 fw_hnadling_time;
-
-	/* The LS-byte of the last TKIP sequence number. */
-	u8 lsb_seq_num;
-
-	/* Retry count */
-	u8 ack_failures;
-
-	/* At which rate we got a ACK */
-	u16 rate;
-
-	u16 reserved;
-
-	/* TX_* */
-	u8 status;
-
-	/* See done_1 */
-	u8 done_2;
-} __attribute__ ((packed));
-
-void wl12xx_tx_work(struct work_struct *work);
-void wl12xx_tx_complete(struct wl12xx *wl);
-void wl12xx_tx_flush(struct wl12xx *wl);
-
-#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251.c b/drivers/net/wireless/wl12xx/wl1251.c
index b793325..903624a 100644
--- a/drivers/net/wireless/wl12xx/wl1251.c
+++ b/drivers/net/wireless/wl12xx/wl1251.c
@@ -30,7 +30,7 @@
 #include "boot.h"
 #include "event.h"
 #include "acx.h"
-#include "tx.h"
+#include "wl1251_tx.h"
 #include "rx.h"
 #include "ps.h"
 #include "init.h"
@@ -471,7 +471,7 @@ static void wl1251_irq_work(struct work_struct *work)
 
 	if (intr & WL1251_ACX_INTR_TX_RESULT) {
 		wl12xx_debug(DEBUG_IRQ, "WL1251_ACX_INTR_TX_RESULT");
-		wl12xx_tx_complete(wl);
+		wl1251_tx_complete(wl);
 	}
 
 	if (intr & (WL1251_ACX_INTR_EVENT_A | WL1251_ACX_INTR_EVENT_B)) {
@@ -712,9 +712,12 @@ void wl1251_setup(struct wl12xx *wl)
 	wl->chip.op_hw_init = wl1251_hw_init;
 	wl->chip.op_plt_init = wl1251_plt_init;
 	wl->chip.op_fw_version = wl1251_fw_version;
+	wl->chip.op_tx_flush = wl1251_tx_flush;
 
 	wl->chip.p_table = wl1251_part_table;
 	wl->chip.acx_reg_table = wl1251_acx_reg_table;
 
 	INIT_WORK(&wl->irq_work, wl1251_irq_work);
+	INIT_WORK(&wl->tx_work, wl1251_tx_work);
+
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
new file mode 100644
index 0000000..c42c43d
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -0,0 +1,557 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "wl12xx.h"
+#include "reg.h"
+#include "spi.h"
+#include "wl1251_tx.h"
+#include "ps.h"
+
+static bool wl1251_tx_double_buffer_busy(struct wl12xx *wl, u32 data_out_count)
+{
+	int used, data_in_count;
+
+	data_in_count = wl->data_in_count;
+
+	if (data_in_count < data_out_count)
+		/* data_in_count has wrapped */
+		data_in_count += TX_STATUS_DATA_OUT_COUNT_MASK + 1;
+
+	used = data_in_count - data_out_count;
+
+	WARN_ON(used < 0);
+	WARN_ON(used > DP_TX_PACKET_RING_CHUNK_NUM);
+
+	if (used >= DP_TX_PACKET_RING_CHUNK_NUM)
+		return true;
+	else
+		return false;
+}
+
+static int wl1251_tx_path_status(struct wl12xx *wl)
+{
+	u32 status, addr, data_out_count;
+	bool busy;
+
+	addr = wl->data_path->tx_control_addr;
+	status = wl12xx_mem_read32(wl, addr);
+	data_out_count = status & TX_STATUS_DATA_OUT_COUNT_MASK;
+	busy = wl1251_tx_double_buffer_busy(wl, data_out_count);
+
+	if (busy)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int wl1251_tx_id(struct wl12xx *wl, struct sk_buff *skb)
+{
+	int i;
+
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+		if (wl->tx_frames[i] == NULL) {
+			wl->tx_frames[i] = skb;
+			return i;
+		}
+
+	return -EBUSY;
+}
+
+static void wl1251_tx_control(struct tx_double_buffer_desc *tx_hdr,
+			      struct ieee80211_tx_info *control, u16 fc)
+{
+	*(u16 *)&tx_hdr->control = 0;
+
+	tx_hdr->control.rate_policy = 0;
+
+	/* 802.11 packets */
+	tx_hdr->control.packet_type = 0;
+
+	if (control->flags & IEEE80211_TX_CTL_NO_ACK)
+		tx_hdr->control.ack_policy = 1;
+
+	tx_hdr->control.tx_complete = 1;
+
+	if ((fc & IEEE80211_FTYPE_DATA) &&
+	    ((fc & IEEE80211_STYPE_QOS_DATA) ||
+	     (fc & IEEE80211_STYPE_QOS_NULLFUNC)))
+		tx_hdr->control.qos = 1;
+}
+
+/* RSN + MIC = 8 + 8 = 16 bytes (worst case - AES). */
+#define MAX_MSDU_SECURITY_LENGTH      16
+#define MAX_MPDU_SECURITY_LENGTH      16
+#define WLAN_QOS_HDR_LEN              26
+#define MAX_MPDU_HEADER_AND_SECURITY  (MAX_MPDU_SECURITY_LENGTH + \
+				       WLAN_QOS_HDR_LEN)
+#define HW_BLOCK_SIZE                 252
+static void wl1251_tx_frag_block_num(struct tx_double_buffer_desc *tx_hdr)
+{
+	u16 payload_len, frag_threshold, mem_blocks;
+	u16 num_mpdus, mem_blocks_per_frag;
+
+	frag_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
+	tx_hdr->frag_threshold = cpu_to_le16(frag_threshold);
+
+	payload_len = tx_hdr->length + MAX_MSDU_SECURITY_LENGTH;
+
+	if (payload_len > frag_threshold) {
+		mem_blocks_per_frag =
+			((frag_threshold + MAX_MPDU_HEADER_AND_SECURITY) /
+			 HW_BLOCK_SIZE) + 1;
+		num_mpdus = payload_len / frag_threshold;
+		mem_blocks = num_mpdus * mem_blocks_per_frag;
+		payload_len -= num_mpdus * frag_threshold;
+		num_mpdus++;
+
+	} else {
+		mem_blocks_per_frag = 0;
+		mem_blocks = 0;
+		num_mpdus = 1;
+	}
+
+	mem_blocks += (payload_len / HW_BLOCK_SIZE) + 1;
+
+	if (num_mpdus > 1)
+		mem_blocks += min(num_mpdus, mem_blocks_per_frag);
+
+	tx_hdr->num_mem_blocks = mem_blocks;
+}
+
+static int wl1251_tx_fill_hdr(struct wl12xx *wl, struct sk_buff *skb,
+			      struct ieee80211_tx_info *control)
+{
+	struct tx_double_buffer_desc *tx_hdr;
+	struct ieee80211_rate *rate;
+	int id;
+	u16 fc;
+
+	if (!skb)
+		return -EINVAL;
+
+	id = wl1251_tx_id(wl, skb);
+	if (id < 0)
+		return id;
+
+	fc = *(u16 *)skb->data;
+	tx_hdr = (struct tx_double_buffer_desc *) skb_push(skb,
+							   sizeof(*tx_hdr));
+
+	tx_hdr->length = cpu_to_le16(skb->len - sizeof(*tx_hdr));
+	rate = ieee80211_get_tx_rate(wl->hw, control);
+	tx_hdr->rate = cpu_to_le16(rate->hw_value);
+	tx_hdr->expiry_time = cpu_to_le32(1 << 16);
+	tx_hdr->id = id;
+
+	/* FIXME: how to get the correct queue id? */
+	tx_hdr->xmit_queue = 0;
+
+	wl1251_tx_control(tx_hdr, control, fc);
+	wl1251_tx_frag_block_num(tx_hdr);
+
+	return 0;
+}
+
+/* We copy the packet to the target */
+static int wl1251_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
+				 struct ieee80211_tx_info *control)
+{
+	struct tx_double_buffer_desc *tx_hdr;
+	int len;
+	u32 addr;
+
+	if (!skb)
+		return -EINVAL;
+
+	tx_hdr = (struct tx_double_buffer_desc *) skb->data;
+
+	if (control->control.hw_key &&
+	    control->control.hw_key->alg == ALG_TKIP) {
+		int hdrlen;
+		u16 fc;
+		u8 *pos;
+
+		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
+		tx_hdr->length += WL1251_TKIP_IV_SPACE;
+
+		hdrlen = ieee80211_hdrlen(fc);
+
+		pos = skb_push(skb, WL1251_TKIP_IV_SPACE);
+		memmove(pos, pos + WL1251_TKIP_IV_SPACE,
+			sizeof(*tx_hdr) + hdrlen);
+	}
+
+	/* Revisit. This is a workaround for getting non-aligned packets.
+	   This happens at least with EAPOL packets from the user space.
+	   Our DMA requires packets to be aligned on a 4-byte boundary.
+	*/
+	if (unlikely((long)skb->data & 0x03)) {
+		int offset = (4 - (long)skb->data) & 0x03;
+		wl12xx_debug(DEBUG_TX, "skb offset %d", offset);
+
+		/* check whether the current skb can be used */
+		if (!skb_cloned(skb) && (skb_tailroom(skb) >= offset)) {
+			unsigned char *src = skb->data;
+
+			/* align the buffer on a 4-byte boundary */
+			skb_reserve(skb, offset);
+			memmove(skb->data, src, skb->len);
+		} else {
+			wl12xx_info("No handler, fixme!");
+			return -EINVAL;
+		}
+	}
+
+	/* Our skb->data at this point includes the HW header */
+	len = WL1251_TX_ALIGN(skb->len);
+
+	if (wl->data_in_count & 0x1)
+		addr = wl->data_path->tx_packet_ring_addr +
+			wl->data_path->tx_packet_ring_chunk_size;
+	else
+		addr = wl->data_path->tx_packet_ring_addr;
+
+	wl12xx_spi_mem_write(wl, addr, skb->data, len);
+
+	wl12xx_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
+		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
+
+	return 0;
+}
+
+static void wl1251_tx_trigger(struct wl12xx *wl)
+{
+	u32 data, addr;
+
+	if (wl->data_in_count & 0x1) {
+		addr = ACX_REG_INTERRUPT_TRIG_H;
+		data = INTR_TRIG_TX_PROC1;
+	} else {
+		addr = ACX_REG_INTERRUPT_TRIG;
+		data = INTR_TRIG_TX_PROC0;
+	}
+
+	wl12xx_reg_write32(wl, addr, data);
+
+	/* Bumping data in */
+	wl->data_in_count = (wl->data_in_count + 1) &
+		TX_STATUS_DATA_OUT_COUNT_MASK;
+}
+
+/* caller must hold wl->mutex */
+static int wl1251_tx_frame(struct wl12xx *wl, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
+	int ret = 0;
+	u8 idx;
+
+	info = IEEE80211_SKB_CB(skb);
+
+	if (info->control.hw_key) {
+		idx = info->control.hw_key->hw_key_idx;
+		if (unlikely(wl->default_key != idx)) {
+			ret = wl12xx_acx_default_key(wl, idx);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	ret = wl1251_tx_path_status(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1251_tx_fill_hdr(wl, skb, info);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1251_tx_send_packet(wl, skb, info);
+	if (ret < 0)
+		return ret;
+
+	wl1251_tx_trigger(wl);
+
+	return ret;
+}
+
+void wl1251_tx_work(struct work_struct *work)
+{
+	struct wl12xx *wl = container_of(work, struct wl12xx, tx_work);
+	struct sk_buff *skb;
+	bool woken_up = false;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL12XX_STATE_OFF))
+		goto out;
+
+	while ((skb = skb_dequeue(&wl->tx_queue))) {
+		if (!woken_up) {
+			wl12xx_ps_elp_wakeup(wl);
+			woken_up = true;
+		}
+
+		ret = wl1251_tx_frame(wl, skb);
+		if (ret == -EBUSY) {
+			/* firmware buffer is full, stop queues */
+			wl12xx_debug(DEBUG_TX, "tx_work: fw buffer full, "
+				     "stop queues");
+			ieee80211_stop_queues(wl->hw);
+			wl->tx_queue_stopped = true;
+			skb_queue_head(&wl->tx_queue, skb);
+			goto out;
+		} else if (ret < 0) {
+			dev_kfree_skb(skb);
+			goto out;
+		}
+	}
+
+out:
+	if (woken_up)
+		wl12xx_ps_elp_sleep(wl);
+
+	mutex_unlock(&wl->mutex);
+}
+
+static const char *wl1251_tx_parse_status(u8 status)
+{
+	/* 8 bit status field, one character per bit plus null */
+	static char buf[9];
+	int i = 0;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (status & TX_DMA_ERROR)
+		buf[i++] = 'm';
+	if (status & TX_DISABLED)
+		buf[i++] = 'd';
+	if (status & TX_RETRY_EXCEEDED)
+		buf[i++] = 'r';
+	if (status & TX_TIMEOUT)
+		buf[i++] = 't';
+	if (status & TX_KEY_NOT_FOUND)
+		buf[i++] = 'k';
+	if (status & TX_ENCRYPT_FAIL)
+		buf[i++] = 'e';
+	if (status & TX_UNAVAILABLE_PRIORITY)
+		buf[i++] = 'p';
+
+	/* bit 0 is unused apparently */
+
+	return buf;
+}
+
+static void wl1251_tx_packet_cb(struct wl12xx *wl,
+				struct tx_result *result)
+{
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+	int hdrlen, ret;
+	u8 *frame;
+
+	skb = wl->tx_frames[result->id];
+	if (skb == NULL) {
+		wl12xx_error("SKB for packet %d is NULL", result->id);
+		return;
+	}
+
+	info = IEEE80211_SKB_CB(skb);
+
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    (result->status == TX_SUCCESS))
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
+	info->status.rates[0].count = result->ack_failures + 1;
+	wl->stats.retry_count += result->ack_failures;
+
+	/*
+	 * We have to remove our private TX header before pushing
+	 * the skb back to mac80211.
+	 */
+	frame = skb_pull(skb, sizeof(struct tx_double_buffer_desc));
+	if (info->control.hw_key &&
+	    info->control.hw_key->alg == ALG_TKIP) {
+		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		memmove(frame + WL1251_TKIP_IV_SPACE, frame, hdrlen);
+		skb_pull(skb, WL1251_TKIP_IV_SPACE);
+	}
+
+	wl12xx_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
+		     " status 0x%x (%s)",
+		     result->id, skb, result->ack_failures, result->rate,
+		     result->status, wl1251_tx_parse_status(result->status));
+
+
+	ieee80211_tx_status(wl->hw, skb);
+
+	wl->tx_frames[result->id] = NULL;
+
+	if (wl->tx_queue_stopped) {
+		wl12xx_debug(DEBUG_TX, "cb: queue was stopped");
+
+		skb = skb_dequeue(&wl->tx_queue);
+
+		/* The skb can be NULL because tx_work might have been
+		   scheduled before the queue was stopped making the
+		   queue empty */
+
+		if (skb) {
+			ret = wl1251_tx_frame(wl, skb);
+			if (ret == -EBUSY) {
+				/* firmware buffer is still full */
+				wl12xx_debug(DEBUG_TX, "cb: fw buffer "
+					     "still full");
+				skb_queue_head(&wl->tx_queue, skb);
+				return;
+			} else if (ret < 0) {
+				dev_kfree_skb(skb);
+				return;
+			}
+		}
+
+		wl12xx_debug(DEBUG_TX, "cb: waking queues");
+		ieee80211_wake_queues(wl->hw);
+		wl->tx_queue_stopped = false;
+	}
+}
+
+/* Called upon reception of a TX complete interrupt */
+void wl1251_tx_complete(struct wl12xx *wl)
+{
+	int i, result_index, num_complete = 0;
+	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
+
+	if (unlikely(wl->state != WL12XX_STATE_ON))
+		return;
+
+	/* First we read the result */
+	wl12xx_spi_mem_read(wl, wl->data_path->tx_complete_addr,
+			    result, sizeof(result));
+
+	result_index = wl->next_tx_complete;
+
+	for (i = 0; i < ARRAY_SIZE(result); i++) {
+		result_ptr = &result[result_index];
+
+		if (result_ptr->done_1 == 1 &&
+		    result_ptr->done_2 == 1) {
+			wl1251_tx_packet_cb(wl, result_ptr);
+
+			result_ptr->done_1 = 0;
+			result_ptr->done_2 = 0;
+
+			result_index = (result_index + 1) &
+				(FW_TX_CMPLT_BLOCK_SIZE - 1);
+			num_complete++;
+		} else {
+			break;
+		}
+	}
+
+	/* Every completed frame needs to be acknowledged */
+	if (num_complete) {
+		/*
+		 * If we've wrapped, we have to clear
+		 * the results in 2 steps.
+		 */
+		if (result_index > wl->next_tx_complete) {
+			/* Only 1 write is needed */
+			wl12xx_spi_mem_write(wl,
+					     wl->data_path->tx_complete_addr +
+					     (wl->next_tx_complete *
+					      sizeof(struct tx_result)),
+					     &result[wl->next_tx_complete],
+					     num_complete *
+					     sizeof(struct tx_result));
+
+
+		} else if (result_index < wl->next_tx_complete) {
+			/* 2 writes are needed */
+			wl12xx_spi_mem_write(wl,
+					     wl->data_path->tx_complete_addr +
+					     (wl->next_tx_complete *
+					      sizeof(struct tx_result)),
+					     &result[wl->next_tx_complete],
+					     (FW_TX_CMPLT_BLOCK_SIZE -
+					      wl->next_tx_complete) *
+					     sizeof(struct tx_result));
+
+			wl12xx_spi_mem_write(wl,
+					     wl->data_path->tx_complete_addr,
+					     result,
+					     (num_complete -
+					      FW_TX_CMPLT_BLOCK_SIZE +
+					      wl->next_tx_complete) *
+					     sizeof(struct tx_result));
+
+		} else {
+			/* We have to write the whole array */
+			wl12xx_spi_mem_write(wl,
+					     wl->data_path->tx_complete_addr,
+					     result,
+					     FW_TX_CMPLT_BLOCK_SIZE *
+					     sizeof(struct tx_result));
+		}
+
+	}
+
+	wl->next_tx_complete = result_index;
+}
+
+/* caller must hold wl->mutex */
+void wl1251_tx_flush(struct wl12xx *wl)
+{
+	int i;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+
+	/* TX failure */
+/* 	control->flags = 0; FIXME */
+
+	while ((skb = skb_dequeue(&wl->tx_queue))) {
+		info = IEEE80211_SKB_CB(skb);
+
+		wl12xx_debug(DEBUG_TX, "flushing skb 0x%p", skb);
+
+		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+				continue;
+
+		ieee80211_tx_status(wl->hw, skb);
+	}
+
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+		if (wl->tx_frames[i] != NULL) {
+			skb = wl->tx_frames[i];
+			info = IEEE80211_SKB_CB(skb);
+
+			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+				continue;
+
+			ieee80211_tx_status(wl->hw, skb);
+			wl->tx_frames[i] = NULL;
+		}
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl12xx/wl1251_tx.h
new file mode 100644
index 0000000..a5d4c82
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.h
@@ -0,0 +1,216 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL1251_TX_H__
+#define __WL1251_TX_H__
+
+#include <linux/bitops.h>
+
+/*
+ *
+ * TX PATH
+ *
+ * The Tx path uses a double buffer and a tx_control structure, each located
+ * at a fixed address in the device's memory. On startup, the host retrieves
+ * the pointers to these addresses. A double buffer allows for continuous data
+ * flow towards the device. The host keeps track of which buffer is available
+ * and alternates between these two buffers on a per packet basis.
+ *
+ * The size of each of the two buffers is large enough to hold the longest
+ * 802.3 packet - maximum size Ethernet packet + header + descriptor.
+ * TX complete indication will be received a-synchronously in a TX done cyclic
+ * buffer which is composed of 16 tx_result descriptors structures and is used
+ * in a cyclic manner.
+ *
+ * The TX (HOST) procedure is as follows:
+ * 1. Read the Tx path status, that will give the data_out_count.
+ * 2. goto 1, if not possible.
+ *    i.e. if data_in_count - data_out_count >= HwBuffer size (2 for double
+ *    buffer).
+ * 3. Copy the packet (preceded by double_buffer_desc), if possible.
+ *    i.e. if data_in_count - data_out_count < HwBuffer size (2 for double
+ *    buffer).
+ * 4. increment data_in_count.
+ * 5. Inform the firmware by generating a firmware internal interrupt.
+ * 6. FW will increment data_out_count after it reads the buffer.
+ *
+ * The TX Complete procedure:
+ * 1. To get a TX complete indication the host enables the tx_complete flag in
+ *    the TX descriptor Structure.
+ * 2. For each packet with a Tx Complete field set, the firmware adds the
+ *    transmit results to the cyclic buffer (txDoneRing) and sets both done_1
+ *    and done_2 to 1 to indicate driver ownership.
+ * 3. The firmware sends a Tx Complete interrupt to the host to trigger the
+ *    host to process the new data. Note: interrupt will be send per packet if
+ *    TX complete indication was requested in tx_control or per crossing
+ *    aggregation threshold.
+ * 4. After receiving the Tx Complete interrupt, the host reads the
+ *    TxDescriptorDone information in a cyclic manner and clears both done_1
+ *    and done_2 fields.
+ *
+ */
+
+#define TX_COMPLETE_REQUIRED_BIT	0x80
+#define TX_STATUS_DATA_OUT_COUNT_MASK   0xf
+
+#define WL1251_TX_ALIGN_TO 4
+#define WL1251_TX_ALIGN(len) (((len) + WL1251_TX_ALIGN_TO - 1) & \
+			     ~(WL1251_TX_ALIGN_TO - 1))
+#define WL1251_TKIP_IV_SPACE 4
+
+struct tx_control {
+	/* Rate Policy (class) index */
+	unsigned rate_policy:3;
+
+	/* When set, no ack policy is expected */
+	unsigned ack_policy:1;
+
+	/*
+	 * Packet type:
+	 * 0 -> 802.11
+	 * 1 -> 802.3
+	 * 2 -> IP
+	 * 3 -> raw codec
+	 */
+	unsigned packet_type:2;
+
+	/* If set, this is a QoS-Null or QoS-Data frame */
+	unsigned qos:1;
+
+	/*
+	 * If set, the target triggers the tx complete INT
+	 * upon frame sending completion.
+	 */
+	unsigned tx_complete:1;
+
+	/* 2 bytes padding before packet header */
+	unsigned xfer_pad:1;
+
+	unsigned reserved:7;
+} __attribute__ ((packed));
+
+
+struct tx_double_buffer_desc {
+	/* Length of payload, including headers. */
+	u16 length;
+
+	/*
+	 * A bit mask that specifies the initial rate to be used
+	 * Possible values are:
+	 * 0x0001 - 1Mbits
+	 * 0x0002 - 2Mbits
+	 * 0x0004 - 5.5Mbits
+	 * 0x0008 - 6Mbits
+	 * 0x0010 - 9Mbits
+	 * 0x0020 - 11Mbits
+	 * 0x0040 - 12Mbits
+	 * 0x0080 - 18Mbits
+	 * 0x0100 - 22Mbits
+	 * 0x0200 - 24Mbits
+	 * 0x0400 - 36Mbits
+	 * 0x0800 - 48Mbits
+	 * 0x1000 - 54Mbits
+	 */
+	u16 rate;
+
+	/* Time in us that a packet can spend in the target */
+	u32 expiry_time;
+
+	/* index of the TX queue used for this packet */
+	u8 xmit_queue;
+
+	/* Used to identify a packet */
+	u8 id;
+
+	struct tx_control control;
+
+	/*
+	 * The FW should cut the packet into fragments
+	 * of this size.
+	 */
+	u16 frag_threshold;
+
+	/* Numbers of HW queue blocks to be allocated */
+	u8 num_mem_blocks;
+
+	u8 reserved;
+} __attribute__ ((packed));
+
+enum {
+	TX_SUCCESS              = 0,
+	TX_DMA_ERROR            = BIT(7),
+	TX_DISABLED             = BIT(6),
+	TX_RETRY_EXCEEDED       = BIT(5),
+	TX_TIMEOUT              = BIT(4),
+	TX_KEY_NOT_FOUND        = BIT(3),
+	TX_ENCRYPT_FAIL         = BIT(2),
+	TX_UNAVAILABLE_PRIORITY = BIT(1),
+};
+
+struct tx_result {
+	/*
+	 * Ownership synchronization between the host and
+	 * the firmware. If done_1 and done_2 are cleared,
+	 * owned by the FW (no info ready).
+	 */
+	u8 done_1;
+
+	/* same as double_buffer_desc->id */
+	u8 id;
+
+	/*
+	 * Total air access duration consumed by this
+	 * packet, including all retries and overheads.
+	 */
+	u16 medium_usage;
+
+	/* Total media delay (from 1st EDCA AIFS counter until TX Complete). */
+	u32 medium_delay;
+
+	/* Time between host xfer and tx complete */
+	u32 fw_hnadling_time;
+
+	/* The LS-byte of the last TKIP sequence number. */
+	u8 lsb_seq_num;
+
+	/* Retry count */
+	u8 ack_failures;
+
+	/* At which rate we got a ACK */
+	u16 rate;
+
+	u16 reserved;
+
+	/* TX_* */
+	u8 status;
+
+	/* See done_1 */
+	u8 done_2;
+} __attribute__ ((packed));
+
+void wl1251_tx_work(struct work_struct *work);
+void wl1251_tx_complete(struct wl12xx *wl);
+void wl1251_tx_flush(struct wl12xx *wl);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index c1d00c0..c38aa54 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -163,6 +163,7 @@ struct wl12xx_chip {
 	void (*op_target_enable_interrupts)(struct wl12xx *wl);
 	int (*op_hw_init)(struct wl12xx *wl);
 	int (*op_plt_init)(struct wl12xx *wl);
+	void (*op_tx_flush)(struct wl12xx *wl);
 	void (*op_fw_version)(struct wl12xx *wl);
 
 	struct wl12xx_partition_set *p_table;

