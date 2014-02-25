Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:65403 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaBYQ1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 11:27:08 -0500
Message-ID: <530CC3FA.9000204@redpinesignals.com> (sfid-20140225_172712_971110_80104FCE)
Date: Tue, 25 Feb 2014 21:55:30 +0530
From: Fariya Fatima <fariya.f@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.14.0-rc4 v2 3/10] rsi: Adding core and main files
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima

This patch adds the files which contain functionality related
to initialization, queuing and de-queuing of packets to be 
sent to the device, sending and receiving packets from the
device and OS interface operations.

Signed-off-by: Fariya Fatima <fariya.f@redpinesignals.com>
---

rsi_91x_core.c |  360 +++++++++++++++++++++++++++++++++++++++++++
rsi_91x_main.c |  468 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
2 files changed, 828 insertions(+)

diff -rupN linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_core.c linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_core.c
--- linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_core.c	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_core.c	2014-02-25 14:45:20.425060202 +0530
@@ -0,0 +1,360 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "rsi_sdio.h"
+#include "rsi_mgmt.h"
+#include "rsi_device_ops.h"
+
+/**
+ * This function determines the queue with the min weight.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return q_num: Corresponding queue number.
+ */
+static u8 rsi_determine_min_weight_queue(struct rsi_common *common)
+{
+	struct wmm_qinfo *tx_qinfo = common->tx_qinfo;
+	u32 q_len = 0;
+	u8 ii = 0;
+
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
+		q_len = skb_queue_len(&common->tx_queue[ii]);
+		if ((tx_qinfo[ii].pkt_contended) && q_len) {
+			common->min_weight = tx_qinfo[ii].weight;
+			break;
+		}
+	}
+	return ii;
+}
+
+/**
+ * This function recalculates the weights corresponding to each queue.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return recontend_queue bool variable
+ */
+static bool rsi_recalculate_weights(struct rsi_common *common)
+{
+	struct wmm_qinfo *tx_qinfo = common->tx_qinfo;
+	bool recontend_queue = false;
+	u8 ii = 0;
+	u32 q_len = 0;
+
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
+		q_len = skb_queue_len(&common->tx_queue[ii]);
+		/* Check for the need of contention */
+		if (q_len) {
+			if (tx_qinfo[ii].pkt_contended) {
+				tx_qinfo[ii].weight =
+				((tx_qinfo[ii].weight > common->min_weight) ?
+				 tx_qinfo[ii].weight - common->min_weight : 0);
+			} else {
+				tx_qinfo[ii].pkt_contended = 1;
+				tx_qinfo[ii].weight = tx_qinfo[ii].wme_params;
+				recontend_queue = true;
+			}
+		} else { /* No packets so no contention */
+			tx_qinfo[ii].weight = 0;
+			tx_qinfo[ii].pkt_contended = 0;
+		}
+	}
+
+	return recontend_queue;
+}
+
+/**
+ * This function determines the queue from which packet
+ * has to be dequeued.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return q_num: Corresponding queue number on success.
+ */
+static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
+{
+	bool recontend_queue = false;
+	u32 q_len = 0;
+	u8 q_num = INVALID_QUEUE;
+	u8 ii, min = 0;
+
+	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
+		if (!common->mgmt_q_block)
+			q_num = MGMT_SOFT_Q;
+		return q_num;
+	}
+
+	if (common->pkt_cnt != 0) {
+		--common->pkt_cnt;
+		return common->selected_qnum;
+	}
+
+get_queue_num:
+	q_num = 0;
+	recontend_queue = false;
+
+	q_num = rsi_determine_min_weight_queue(common);
+	q_len = skb_queue_len(&common->tx_queue[ii]);
+	ii = q_num;
+
+	/* Selecting the queue with least back off */
+	for (; ii < NUM_EDCA_QUEUES; ii++) {
+		if (((common->tx_qinfo[ii].pkt_contended) &&
+		     (common->tx_qinfo[ii].weight < min)) && q_len) {
+			min = common->tx_qinfo[ii].weight;
+			q_num = ii;
+		}
+	}
+
+	common->tx_qinfo[q_num].pkt_contended = 0;
+	/* Adjust the back off values for all queues again */
+	recontend_queue = rsi_recalculate_weights(common);
+
+	q_len = skb_queue_len(&common->tx_queue[q_num]);
+	if (!q_len) {
+		/* If any queues are freshly contended and the selected queue
+		 * doesn't have any packets
+		 * then get the queue number again with fresh values
+		 */
+		if (recontend_queue)
+			goto get_queue_num;
+
+		q_num = INVALID_QUEUE;
+		return q_num;
+	}
+
+	common->selected_qnum = q_num;
+	q_len = skb_queue_len(&common->tx_queue[q_num]);
+
+	switch (common->selected_qnum) {
+	case VO_Q:
+		if (q_len > MAX_CONTINUOUS_VO_PKTS)
+			common->pkt_cnt = (MAX_CONTINUOUS_VO_PKTS - 1);
+		else
+			common->pkt_cnt = --q_len;
+		break;
+
+	case VI_Q:
+		if (q_len > MAX_CONTINUOUS_VI_PKTS)
+			common->pkt_cnt = (MAX_CONTINUOUS_VI_PKTS - 1);
+		else
+			common->pkt_cnt = --q_len;
+
+		break;
+
+	default:
+		common->pkt_cnt = 0;
+		break;
+	}
+
+	return q_num;
+}
+
+/**
+ * This functions enqueues the packet to the queue specified
+ * by the queue number.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return None.
+ */
+static inline void rsi_core_queue_pkt(struct rsi_common *common,
+				      struct sk_buff *skb)
+{
+	u8 q_num = skb->priority;
+	if (q_num >= NUM_SOFT_QUEUES) {
+		rsi_dbg(ERR_ZONE, "%s: Invalid Queue Number: q_num = %d\n",
+			__func__, q_num);
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	skb_queue_tail(&common->tx_queue[q_num], skb);
+	return;
+}
+
+/**
+ * This functions dequeues the packet from the queue specified by
+ * the queue number.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  q_num Queue number.
+ * @return Pointer to sk_buff structure.
+ */
+static inline struct sk_buff *rsi_core_dequeue_pkt(struct rsi_common *common,
+						   u8 q_num)
+{
+	if (q_num >= NUM_SOFT_QUEUES) {
+		rsi_dbg(ERR_ZONE, "%s: Invalid Queue Number: q_num = %d\n",
+			__func__, q_num);
+		return NULL;
+	}
+
+	return skb_dequeue(&common->tx_queue[q_num]);
+}
+
+/**
+ * This function is used to determine the wmm queue based on the backoff
+ * procedure. Data packets are dequeued from the selected hal queue and
+ * sent to the below layers.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return None.
+ */
+void rsi_core_qos_processor(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct sk_buff *skb;
+	unsigned long tstamp_1, tstamp_2;
+	u8 q_num;
+	int status;
+
+	tstamp_1 = jiffies;
+	while (1) {
+		q_num = rsi_core_determine_hal_queue(common);
+		rsi_dbg(DATA_TX_ZONE,
+			"%s: Queue number = %d\n", __func__, q_num);
+
+		if (q_num == INVALID_QUEUE) {
+			rsi_dbg(DATA_TX_ZONE, "%s: No More Pkt\n", __func__);
+			break;
+		}
+
+		mutex_lock(&common->tx_rxlock);
+
+		if (adapter->hw_intf == RSI_91X_INTF_SDIO) {
+			struct rsi_91xdev *dev_info =
+				(struct rsi_91xdev *)adapter->rsi_device;
+
+			if (adapter->hw_intf_ops->read_buffer_status(adapter)) {
+				mutex_unlock(&common->tx_rxlock);
+				break;
+			}
+
+			if ((q_num == MGMT_SOFT_Q) &&
+			    (dev_info->rx_info.mgmt_buffer_full)) {
+				rsi_dbg(DATA_TX_ZONE, "%s: Mgmt buffer full\n",
+					__func__);
+				mutex_unlock(&common->tx_rxlock);
+				break;
+			} else if (dev_info->rx_info.buffer_full) {
+				rsi_dbg(DATA_TX_ZONE, "%s: Buffer full\n",
+					__func__);
+				mutex_unlock(&common->tx_rxlock);
+				break;
+			}
+		}
+
+		if ((q_num < MGMT_SOFT_Q) &&
+		    ((skb_queue_len(&common->tx_queue[q_num])) <=
+		      MIN_DATA_QUEUE_WATER_MARK)) {
+			if (ieee80211_queue_stopped(adapter->hw, WME_AC(q_num)))
+				ieee80211_wake_queue(adapter->hw,
+						     WME_AC(q_num));
+		}
+
+		skb = rsi_core_dequeue_pkt(common, q_num);
+		if (skb == NULL) {
+			mutex_unlock(&common->tx_rxlock);
+			break;
+		}
+
+		if (q_num == MGMT_SOFT_Q)
+			status = rsi_send_mgmt_pkt(common, skb);
+		else
+			status = rsi_send_data_pkt(common, skb);
+
+		if (status) {
+			mutex_unlock(&common->tx_rxlock);
+			break;
+		}
+
+		common->tx_stats.total_tx_pkt_send[q_num]++;
+
+		tstamp_2 = jiffies;
+		mutex_unlock(&common->tx_rxlock);
+
+		if (tstamp_2 > tstamp_1 + (300 * HZ / 1000))
+			schedule();
+	}
+	return;
+}
+
+/**
+ * This function transmits the packets received from mac80211.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
+	u8 q_num, frame_type, tid = 0;
+
+	if ((!skb) || (!skb->len)) {
+		rsi_dbg(ERR_ZONE, "%s: Null skb/zero Length packet\n",
+			__func__);
+		goto xmit_fail;
+	}
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+
+	if (common->fsm_state != FSM_MAC_INIT_DONE) {
+		rsi_dbg(ERR_ZONE, "%s: FSM state not open\n", __func__);
+		goto xmit_fail;
+	}
+
+	frame_type = (skb->data[0] & 0x0f);
+
+	if ((frame_type == IEEE80211_MGMT_FRAME) ||
+	    (frame_type == IEEE80211_CTL_FRAME)) {
+		q_num = MGMT_SOFT_Q;
+		skb->priority = q_num;
+	} else {
+		if (skb->data[MAC_80211_HDR_FRAME_CONTROL] & 0x80) {
+			tid = (skb->data[24] & IEEE80211_QOS_TID);
+			skb->priority = TID_TO_WME_AC(tid);
+		} else {
+			tid = IEEE80211_NONQOS_TID;
+			skb->priority = BE_Q;
+		}
+		q_num = skb->priority;
+		tx_params->tid = tid;
+		tx_params->sta_id = 0;
+	}
+
+	if ((q_num != MGMT_SOFT_Q) &&
+	    ((skb_queue_len(&common->tx_queue[q_num]) + 1) >=
+	     DATA_QUEUE_WATER_MARK)) {
+		if (!ieee80211_queue_stopped(adapter->hw, WME_AC(q_num)))
+			ieee80211_stop_queue(adapter->hw, WME_AC(q_num));
+		rsi_set_event(&common->tx_event);
+		goto xmit_fail;
+	}
+
+	rsi_core_queue_pkt(common, skb);
+	rsi_dbg(DATA_TX_ZONE, "%s: ===> Scheduling TX thead <===\n", __func__);
+	rsi_set_event(&common->tx_event);
+
+	return 0;
+
+xmit_fail:
+	rsi_dbg(ERR_ZONE, "%s: Failed to queue packet\n", __func__);
+	if (skb)
+		dev_kfree_skb(skb);
+	return -1;
+}
diff -rupN linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_main.c linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_main.c
--- linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_main.c	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_main.c	2014-02-25 14:45:20.425060202 +0530
@@ -0,0 +1,468 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/kthread.h>
+#include "rsi_sdio.h"
+#include "rsi_device_ops.h"
+#include "rsi_mgmt.h"
+
+u32 rsi_zone_enabled = /* INFO_ZONE |
+			INIT_ZONE |
+			MGMT_TX_ZONE |
+			MGMT_RX_ZONE |
+			DATA_TX_ZONE |
+			DATA_RX_ZONE |
+			FSM_ZONE |
+			ISR_ZONE | */
+			ERR_ZONE |
+			0;
+EXPORT_SYMBOL_GPL(rsi_zone_enabled);
+
+/**
+ * This function initializes device event.
+ *
+ * @param  pevent Pointer to the event data structure.
+ * @return 0 on success.
+ */
+static inline int rsi_init_event(struct rsi_event *pevent)
+{
+	atomic_set(&pevent->event_condition, 1);
+	init_waitqueue_head(&pevent->event_queue);
+	return 0;
+}
+
+/**
+ * This function is used to put the current execution in a queue
+ * and reschedules itself for execution on "timeout" or when a
+ * wakeup is generated.
+ *
+ * @param  event Pointer to the event structure.
+ * @param  timeout Timeout value in msecs.
+ * @return status: 0 on success, -1 on failure.
+ */
+static inline int rsi_wait_event(struct rsi_event *event, u32 timeout)
+{
+	int status = 0;
+
+	if (!timeout)
+		status = wait_event_interruptible(event->event_queue,
+				(atomic_read(&event->event_condition) == 0));
+	else
+		status = wait_event_interruptible_timeout(event->event_queue,
+				(atomic_read(&event->event_condition) == 0),
+				timeout);
+	return status;
+}
+
+/**
+ * This function handles the set event functionality.
+ *
+ * @param  event Pointer to the event structure.
+ * @return None.
+ */
+void rsi_set_event(struct rsi_event *event)
+{
+	atomic_set(&event->event_condition, 0);
+	wake_up_interruptible(&event->event_queue);
+}
+EXPORT_SYMBOL_GPL(rsi_set_event);
+
+/**
+ * This function handle the reset event functionality.
+ *
+ * @param  event Pointer to the event structure.
+ * @return None.
+ */
+static inline void rsi_reset_event(struct rsi_event *event)
+{
+	atomic_set(&event->event_condition, 1);
+}
+
+/**
+ * This function creates a kernel thread.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  thread Thread handler type (rx/tx).
+ * @param  func_ptr Type of interface thread to be created(like sdio/usb).
+ * @param  name Name of thread.
+ * @return 0 on thread creation.
+ */
+static int rsi_create_kthread(struct rsi_common *common,
+			      struct rsi_thread *thread,
+			      void *func_ptr,
+			      u8 *name)
+{
+	init_completion(&thread->completion);
+	thread->task = kthread_run(func_ptr, common, name);
+	return 0;
+}
+
+/**
+ * This function kills tx/rx thread depending upon type
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return Thread stop return code.
+ */
+static int rsi_kill_thread(struct rsi_common *common, u8 type)
+{
+	struct rsi_thread *handle;
+
+	if (type) {
+		/* Kill tx thread */
+		handle = &common->tx_thread;
+		atomic_inc(&common->tx_thread_done);
+		rsi_set_event(&common->tx_event);
+	} else {
+		/* Kill rx thread */
+		handle = &common->rx_thread;
+		atomic_inc(&common->rx_thread_done);
+		rsi_set_event(&common->rx_event);
+	}
+
+	wait_for_completion(&handle->completion);
+	return kthread_stop(handle->task);
+}
+
+/**
+ * This function prepares the skb.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  buffer Pointer to the packet data.
+ * @param  pkt_len Length of the packet.
+ * @param  extended_desc Extended descriptor.
+ * @return Successfully skb.
+ */
+static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
+				       u8 *buffer,
+				       u32 pkt_len,
+				       u8 extended_desc)
+{
+	struct ieee80211_tx_info *info;
+	struct skb_info *rx_params;
+	struct sk_buff *skb = NULL;
+	u8 payload_offset;
+
+	if (!pkt_len) {
+		rsi_dbg(ERR_ZONE, "%s: Dummy pkt has come in\n", __func__);
+		BUG_ON(1);
+	}
+
+	if (pkt_len > (RSI_RCV_BUFFER_LEN * 4)) {
+		rsi_dbg(ERR_ZONE, "%s: Pkt size > max rx buf size %d\n",
+			__func__, pkt_len);
+		pkt_len = RSI_RCV_BUFFER_LEN * 4;
+	}
+
+	pkt_len -= extended_desc;
+	skb = dev_alloc_skb(pkt_len + FRAME_DESC_SZ);
+	if (skb == NULL)
+		return NULL;
+
+	payload_offset = (extended_desc + FRAME_DESC_SZ);
+	skb_put(skb, pkt_len);
+	memcpy((skb->data), (buffer + payload_offset), skb->len);
+
+	info = IEEE80211_SKB_CB(skb);
+	rx_params = (struct skb_info *)info->driver_data;
+	rx_params->rssi = rsi_get_rssi(buffer);
+	rx_params->channel = rsi_get_connected_channel(common->priv);
+
+	return skb;
+}
+
+/**
+ * This function reads frames from the card.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  rcv_pkt_len Received pkt length. In case of USB it is 0.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_read_pkt(struct rsi_common *common, u32 rcv_pkt_len)
+{
+	struct rsi_hw *adapter = common->priv;
+	u8 *frame_desc = NULL, extended_desc = 0;
+	u32 index, length = 0, queueno = 0;
+	u16 actual_length = 0, offset;
+	struct sk_buff *skb = NULL;
+	u32 pkt_len = rcv_pkt_len;
+
+	index = 0;
+	do {
+		frame_desc = &common->rx_data_pkt[index];
+		actual_length = *(u16 *)&frame_desc[0];
+		offset = *(u16 *)&frame_desc[2];
+
+		queueno = rsi_get_queueno(frame_desc, offset);
+		length = rsi_get_length(frame_desc, offset);
+		extended_desc = rsi_get_extended_desc(frame_desc, offset);
+
+		/* In case of USB, we don't know before hand the actual length,
+		 * so initializing it here
+		 */
+		if (adapter->hw_intf == RSI_91X_INTF_USB)
+			pkt_len = actual_length;
+
+		switch (queueno) {
+		case RSI_WIFI_DATA_Q:
+			skb = rsi_prepare_skb(common,
+					      (frame_desc + offset),
+					      length,
+					      extended_desc);
+			if (skb == NULL)
+				goto fail;
+
+			rsi_indicate_pkt_to_os(common, skb);
+			break;
+
+		case RSI_WIFI_MGMT_Q:
+			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
+			break;
+
+		default:
+			rsi_dbg(ERR_ZONE, "%s: pkt from invalid queue: %d\n",
+				__func__,   queueno);
+			goto fail;
+		}
+
+		index  += actual_length;
+		pkt_len -= actual_length;
+	} while (pkt_len);
+
+	return 0;
+fail:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(rsi_read_pkt);
+
+/**
+ * This function is a kernel thread to send the packets to the device.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return None.
+ */
+static void rsi_tx_scheduler_thread(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct rsi_91xdev *dev_info = (struct rsi_91xdev *)adapter->rsi_device;
+	u32 timeout = EVENT_WAIT_FOREVER;
+
+	do {
+		if (adapter->hw_intf == RSI_91X_INTF_SDIO) {
+			if (dev_info->rx_info.buffer_full)
+				timeout = 2;
+			else
+				timeout = EVENT_WAIT_FOREVER;
+		}
+		rsi_wait_event(&common->tx_event, timeout);
+		rsi_reset_event(&common->tx_event);
+
+		if (common->init_done)
+			rsi_core_qos_processor(common);
+	} while (atomic_read(&common->tx_thread_done) == 0);
+	complete_and_exit(&common->tx_thread.completion, 0);
+}
+
+/**
+ * This is a kernel thread to receive the packets from the USB device.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return None.
+ */
+
+static void rsi_usb_rx_thread(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	int status;
+
+	do {
+		rsi_wait_event(&common->rx_event, EVENT_WAIT_FOREVER);
+
+		if (atomic_read(&common->rx_thread_done))
+			goto out;
+
+		mutex_lock(&common->tx_rxlock);
+		status = rsi_read_pkt(common, 0);
+		if (status) {
+			rsi_dbg(ERR_ZONE, "%s: Failed To read data", __func__);
+			mutex_unlock(&common->tx_rxlock);
+			return;
+		}
+		mutex_unlock(&common->tx_rxlock);
+		rsi_reset_event(&common->rx_event);
+		if (adapter->hw_intf_ops->rx_urb_submit(adapter)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed in urb submission", __func__);
+			return;
+		}
+	} while (1);
+
+out:
+	rsi_dbg(INFO_ZONE, "%s: Terminated thread\n", __func__);
+	complete_and_exit(&common->rx_thread.completion, 0);
+	return;
+}
+
+/**
+ * This function initializes os interface operations.
+ *
+ * @param void.
+ * @return Pointer to the adapter structure on success, NULL on failure .
+ */
+struct rsi_hw *rsi_init_os_intf_ops(enum rsi_91x_intf intf)
+{
+	struct rsi_hw *adapter = NULL;
+	struct rsi_common *common = NULL;
+	u8 ii = 0;
+
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	if (!adapter)
+		return NULL;
+
+	adapter->priv = kzalloc(sizeof(*common), GFP_KERNEL);
+	if (adapter->priv == NULL) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of memory\n",
+			__func__);
+		kfree(adapter);
+		return NULL;
+	} else {
+		common = adapter->priv;
+		common->priv = adapter;
+	}
+
+	adapter->hw_intf = intf;
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_head_init(&common->tx_queue[ii]);
+
+	rsi_init_event(&common->tx_event);
+	mutex_init(&common->mutex);
+	mutex_init(&common->tx_rxlock);
+
+	if (intf == RSI_91X_INTF_USB) {
+		rsi_init_event(&common->rx_event);
+		common->rx_data_pkt = kmalloc(2048, GFP_KERNEL);
+		if (!common->rx_data_pkt) {
+			rsi_dbg(ERR_ZONE, "%s: Failed to allocate memory\n",
+				__func__);
+			goto err;
+		}
+	}
+
+	common->init_done = true;
+	return adapter;
+
+err:
+	kfree(common);
+	kfree(adapter);
+	return NULL;
+}
+EXPORT_SYMBOL(rsi_init_os_intf_ops);
+
+int rsi_init_thread_ops(struct rsi_common *common,
+			enum rsi_91x_intf intf)
+{
+	if (rsi_create_kthread(common,
+			       &common->tx_thread,
+			       rsi_tx_scheduler_thread,
+			       "Thread")) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		return -1;
+	}
+
+	if (intf == RSI_91X_INTF_USB) {
+		if (rsi_create_kthread(common,
+				       &common->rx_thread,
+				       rsi_usb_rx_thread,
+				       "RX-Thread")) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n",
+				__func__);
+			goto err;
+		}
+	}
+	return 0;
+err:
+	rsi_kill_thread(common, TX);
+	return -1;
+}
+EXPORT_SYMBOL_GPL(rsi_init_thread_ops);
+
+/**
+ * This function de-intializes os interface operations.
+ *
+ * @param  adapter Pointer to the adapter structure.
+ * @return None.
+ */
+void rsi_deinit_os_intf_ops(struct rsi_hw *adapter)
+{
+	struct rsi_common *common = adapter->priv;
+	u8 ii;
+
+	rsi_dbg(INFO_ZONE, "%s: Performing deinit os ops\n", __func__);
+
+	if (adapter->hw_intf == RSI_91X_INTF_USB) {
+		rsi_kill_thread(common, RX);
+		kfree(common->rx_data_pkt);
+	}
+
+	rsi_kill_thread(common, TX);
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_purge(&common->tx_queue[ii]);
+
+	common->init_done = false;
+
+	kfree(common);
+	kfree(adapter->rsi_device);
+	kfree(adapter);
+	return;
+}
+EXPORT_SYMBOL_GPL(rsi_deinit_os_intf_ops);
+
+/**
+ * This function is invoked when the module is loaded into the kernel.
+ * It registers the client driver.
+ *
+ * @param  Void.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_91x_hal_module_init(void)
+{
+	rsi_dbg(INIT_ZONE, "%s: Module init called\n", __func__);
+	return 0;
+}
+
+/**
+ * This function is called at the time of removing/unloading the module.
+ * It unregisters the client driver.
+ *
+ * @param  Void.
+ * @return None.
+ */
+static void rsi_91x_hal_module_exit(void)
+{
+	rsi_dbg(INIT_ZONE, "%s: Module exit called\n", __func__);
+	return;
+}
+
+module_init(rsi_91x_hal_module_init);
+module_exit(rsi_91x_hal_module_exit);
+MODULE_AUTHOR("Redpine Signals Inc");
+MODULE_DESCRIPTION("Station driver for RSI 91x devices");
+MODULE_SUPPORTED_DEVICE("RSI-91x");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");





