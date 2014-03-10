Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36705 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaCJP0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 11:26:55 -0400
Received: by mail-pd0-f182.google.com with SMTP id g10so7283289pdj.27
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 08:26:54 -0700 (PDT)
From: fariyaf@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH v4 03/11] rsi: Adding core and main files.
Date: Mon, 10 Mar 2014 20:56:31 +0530
Message-Id: <1394465199-10042-4-git-send-email-fariyaf@gmail.com> (sfid-20140310_162703_390692_24BEF95C)
In-Reply-To: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
References: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>

This patch adds the files which contain functionality related
to initialization, queuing and de-queuing of packets to be
sent to the device, sending and receiving packets from the
device and OS interface operations.
---
 drivers/net/wireless/rsi/rsi_91x_core.c |  342 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c |  270 ++++++++++++++++++++++++
 2 files changed, 612 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_core.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_main.c

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
new file mode 100644
index 0000000..e89535e
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -0,0 +1,342 @@
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
+#include "rsi_mgmt.h"
+#include "rsi_common.h"
+
+/**
+ * rsi_determine_min_weight_queue() - This function determines the queue with
+ *				      the min weight.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: q_num: Corresponding queue number.
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
+ * rsi_recalculate_weights() - This function recalculates the weights
+ *			       corresponding to each queue.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: recontend_queue bool variable
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
+ * rsi_core_determine_hal_queue() - This function determines the queue from
+ *				    which packet has to be dequeued.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: q_num: Corresponding queue number on success.
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
+ * rsi_core_queue_pkt() - This functions enqueues the packet to the queue
+ *			  specified by the queue number.
+ * @common: Pointer to the driver private structure.
+ * @skb: Pointer to the socket buffer structure.
+ *
+ * Return: None.
+ */
+static void rsi_core_queue_pkt(struct rsi_common *common,
+			       struct sk_buff *skb)
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
+}
+
+/**
+ * rsi_core_dequeue_pkt() - This functions dequeues the packet from the queue
+ *			    specified by the queue number.
+ * @common: Pointer to the driver private structure.
+ * @q_num: Queue number.
+ *
+ * Return: Pointer to sk_buff structure.
+ */
+static struct sk_buff *rsi_core_dequeue_pkt(struct rsi_common *common,
+					    u8 q_num)
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
+ * rsi_core_qos_processor() - This function is used to determine the wmm queue
+ *			      based on the backoff procedure. Data packets are
+ *			      dequeued from the selected hal queue and sent to
+ *			      the below layers.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: None.
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
+		status = adapter->check_hw_queue_status(adapter, q_num);
+		if ((status <= 0)) {
+			mutex_unlock(&common->tx_rxlock);
+			break;
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
+}
+
+/**
+ * rsi_core_xmit() - This function transmits the packets received from mac80211
+ * @common: Pointer to the driver private structure.
+ * @skb: Pointer to the socket buffer structure.
+ *
+ * Return: None.
+ */
+void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
+	struct ieee80211_hdr *tmp_hdr = NULL;
+	u8 q_num, tid = 0;
+
+	if ((!skb) || (!skb->len)) {
+		rsi_dbg(ERR_ZONE, "%s: Null skb/zero Length packet\n",
+			__func__);
+		goto xmit_fail;
+	}
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
+
+	if (common->fsm_state != FSM_MAC_INIT_DONE) {
+		rsi_dbg(ERR_ZONE, "%s: FSM state not open\n", __func__);
+		goto xmit_fail;
+	}
+
+	if ((ieee80211_is_mgmt(tmp_hdr->frame_control)) ||
+	    (ieee80211_is_ctl(tmp_hdr->frame_control))) {
+		q_num = MGMT_SOFT_Q;
+		skb->priority = q_num;
+	} else {
+		if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
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
+		rsi_set_event(&common->tx_thread.event);
+		goto xmit_fail;
+	}
+
+	rsi_core_queue_pkt(common, skb);
+	rsi_dbg(DATA_TX_ZONE, "%s: ===> Scheduling TX thead <===\n", __func__);
+	rsi_set_event(&common->tx_thread.event);
+
+	return;
+
+xmit_fail:
+	rsi_dbg(ERR_ZONE, "%s: Failed to queue packet\n", __func__);
+	/* Dropping pkt here */
+	ieee80211_free_txskb(common->priv->hw, skb);
+}
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
new file mode 100644
index 0000000..066948b
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -0,0 +1,270 @@
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
+#include "rsi_mgmt.h"
+#include "rsi_common.h"
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
+ * rsi_prepare_skb() - This function prepares the skb.
+ * @common: Pointer to the driver private structure.
+ * @buffer: Pointer to the packet data.
+ * @pkt_len: Length of the packet.
+ * @extended_desc: Extended descriptor.
+ *
+ * Return: Successfully skb.
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
+	if (WARN(!pkt_len, "%s: Dummy pkt received", __func__))
+		return NULL;
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
+ * rsi_read_pkt() - This function reads frames from the card.
+ * @common: Pointer to the driver private structure.
+ * @rcv_pkt_len: Received pkt length. In case of USB it is 0.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
+{
+	u8 *frame_desc = NULL, extended_desc = 0;
+	u32 index, length = 0, queueno = 0;
+	u16 actual_length = 0, offset;
+	struct sk_buff *skb = NULL;
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
+		rcv_pkt_len -= actual_length;
+	} while (rcv_pkt_len > 0);
+
+	return 0;
+fail:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(rsi_read_pkt);
+
+/**
+ * rsi_tx_scheduler_thread() - This function is a kernel thread to send the
+ *			       packets to the device.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: None.
+ */
+static void rsi_tx_scheduler_thread(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	u32 timeout = EVENT_WAIT_FOREVER;
+
+	do {
+		if (adapter->determine_event_timeout)
+			timeout = adapter->determine_event_timeout(adapter);
+		rsi_wait_event(&common->tx_thread.event, timeout);
+		rsi_reset_event(&common->tx_thread.event);
+
+		if (common->init_done)
+			rsi_core_qos_processor(common);
+	} while (atomic_read(&common->tx_thread.thread_done) == 0);
+	complete_and_exit(&common->tx_thread.completion, 0);
+}
+
+/**
+ * rsi_91x_init() - This function initializes os interface operations.
+ * @void: Void.
+ *
+ * Return: Pointer to the adapter structure on success, NULL on failure .
+ */
+struct rsi_hw *rsi_91x_init(void)
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
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_head_init(&common->tx_queue[ii]);
+
+	rsi_init_event(&common->tx_thread.event);
+	mutex_init(&common->mutex);
+	mutex_init(&common->tx_rxlock);
+
+	if (rsi_create_kthread(common,
+			       &common->tx_thread,
+			       rsi_tx_scheduler_thread,
+			       "Tx-Thread")) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		goto err;
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
+EXPORT_SYMBOL_GPL(rsi_91x_init);
+
+/**
+ * rsi_91x_deinit() - This function de-intializes os intf operations.
+ * @adapter: Pointer to the adapter structure.
+ *
+ * Return: None.
+ */
+void rsi_91x_deinit(struct rsi_hw *adapter)
+{
+	struct rsi_common *common = adapter->priv;
+	u8 ii;
+
+	rsi_dbg(INFO_ZONE, "%s: Performing deinit os ops\n", __func__);
+
+	rsi_kill_thread(&common->tx_thread);
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_purge(&common->tx_queue[ii]);
+
+	common->init_done = false;
+
+	kfree(common);
+	kfree(adapter->rsi_dev);
+	kfree(adapter);
+}
+EXPORT_SYMBOL_GPL(rsi_91x_deinit);
+
+/**
+ * rsi_91x_hal_module_init() - This function is invoked when the module is
+ *			       loaded into the kernel.
+ *			       It registers the client driver.
+ * @void: Void.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_91x_hal_module_init(void)
+{
+	rsi_dbg(INIT_ZONE, "%s: Module init called\n", __func__);
+	return 0;
+}
+
+/**
+ * rsi_91x_hal_module_exit() - This function is called at the time of
+ *			       removing/unloading the module.
+ *			       It unregisters the client driver.
+ * @void: Void.
+ *
+ * Return: None.
+ */
+static void rsi_91x_hal_module_exit(void)
+{
+	rsi_dbg(INIT_ZONE, "%s: Module exit called\n", __func__);
+}
+
+module_init(rsi_91x_hal_module_init);
+module_exit(rsi_91x_hal_module_exit);
+MODULE_AUTHOR("Redpine Signals Inc");
+MODULE_DESCRIPTION("Station driver for RSI 91x devices");
+MODULE_SUPPORTED_DEVICE("RSI-91x");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.5.4

