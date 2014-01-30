Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:4914 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaA3QAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 11:00:22 -0500
Message-ID: <52EA75B5.5040002@redpinesignals.com> (sfid-20140130_170030_682221_D838173E)
Date: Thu, 30 Jan 2014 21:24:29 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.13.1 3/9] rsi: Packet queueing/dequeueing to device
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This file contains operations related to queueing and dequeueing
of packets to be be written on to the interface.

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

rsi_core.c |  434 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1 file changed, 434 insertions(+)

diff -uprN a/drivers/net/wireless/rsi/common/rsi_core.c b/drivers/net/wireless/rsi/common/rsi_core.c
--- a/drivers/net/wireless/rsi/common/rsi_core.c	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/common/rsi_core.c	2014-01-30 16:11:51.391541682 +0530
@@ -0,0 +1,434 @@
+/**
+ * @file rsi_core.c
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
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
+ *
+ * @section DESCRIPTION
+ *
+ * This file contains transmit and recieve packets to and from mac80211,
+ * also handles queuing and dequeing of packets.
+ */
+
+#include "../include/rsi_main.h"
+#include "../include/rsi_device_ops.h"
+#include "../include/rsi_hw_intf.h"
+
+#ifdef USE_SDIO_INTF
+static unsigned int pkt_count;
+#endif
+static unsigned int selected_qnum, pkt_cnt;
+
+#ifdef USE_SDIO_INTF
+/**
+ * This function is used to the read buffer status register and set
+ * relevant fields in rsi_common struct.
+ *
+ * @param  common Pointer to the driver provate structure.
+ * @return status: 0 on success, -1 on failure.
+ */
+static int rsi_read_buf_status_reg(struct rsi_common *common)
+{
+	int status = 0;
+	unsigned char buf_status = 0;
+
+	status = rsi_read_register(common->priv,
+				   RSI_DEVICE_BUFFER_STATUS_REGISTER,
+				   &buf_status);
+
+	if (status) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to read status register\n", __func__);
+		return -1;
+	}
+
+	if (buf_status & (BIT(PKT_MGMT_BUFF_FULL))) {
+		if (!common->rx_info.mgmt_buffer_full)
+			common->rx_info.mgmt_buf_full_counter++;
+		common->rx_info.mgmt_buffer_full = true;
+	} else {
+		common->rx_info.mgmt_buffer_full = false;
+	}
+
+	if (buf_status & (BIT(PKT_BUFF_FULL))) {
+		if (!common->rx_info.buffer_full)
+			common->rx_info.buf_full_counter++;
+		common->rx_info.buffer_full = true;
+	} else {
+		common->rx_info.buffer_full = false;
+	}
+
+	if (buf_status & (BIT(PKT_BUFF_SEMI_FULL))) {
+		if (!common->rx_info.semi_buffer_full)
+			common->rx_info.buf_semi_full_counter++;
+		common->rx_info.semi_buffer_full = true;
+	} else {
+		common->rx_info.semi_buffer_full = false;
+	}
+	return status;
+}
+#endif
+
+/**
+ * This function determines the queue from which packets has to be dequeued.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return q_num: Corresponding queue number on success.
+ */
+static unsigned char rsi_core_determine_hal_queue(struct rsi_common *common)
+{
+	unsigned char q_num = INVALID_QUEUE;
+	unsigned char ii, min = 0;
+	unsigned int q_len = 0;
+	unsigned char fresh_contention;
+	struct wmm_qinfo *tx_qinfo = common->tx_qinfo;
+
+	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
+		if (!common->mgmt_q_block)
+			q_num = MGMT_SOFT_Q;
+		else
+			q_num = INVALID_QUEUE;
+		return q_num;
+	}
+	if (pkt_cnt != 0) {
+		pkt_cnt -= 1;
+		return selected_qnum;
+	}
+
+get_queue_num:
+	q_num = 0;
+	fresh_contention = 0;
+
+	/* Selecting first valid contention value */
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
+		q_len = skb_queue_len(&common->tx_queue[ii]);
+		if ((tx_qinfo[ii].pkt_contended) && q_len) {
+			min = tx_qinfo[ii].weight;
+			q_num = ii;
+			break;
+		}
+	}
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
+	/* Adjust the back off values for all queues again */
+	common->tx_qinfo[q_num].pkt_contended = 0;
+
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
+		q_len = skb_queue_len(&common->tx_queue[ii]);
+		/* Check for the need of contention */
+		if (q_len) {
+			if (tx_qinfo[ii].pkt_contended) {
+				if (tx_qinfo[ii].weight > min)
+					tx_qinfo[ii].weight -= min;
+				else
+					tx_qinfo[ii].weight = 0;
+			} else {
+				tx_qinfo[ii].pkt_contended = 1;
+				tx_qinfo[ii].weight = tx_qinfo[ii].wme_params;
+				fresh_contention = 1;
+			}
+		} else { /* No packets so no contention */
+			common->tx_qinfo[ii].weight = 0;
+			common->tx_qinfo[ii].pkt_contended = 0;
+		}
+	}
+
+	q_len = skb_queue_len(&common->tx_queue[q_num]);
+	if (!q_len) {
+		/* If any queues are freshly contended and the selected queue
+		 * doesn't have any packets
+		 * then get the queue number again with fresh values
+		 */
+		if (fresh_contention)
+			goto get_queue_num;
+
+		q_num = INVALID_QUEUE;
+		return q_num;
+	}
+
+	selected_qnum = q_num;
+	q_len = skb_queue_len(&common->tx_queue[q_num]);
+	if (selected_qnum == VO_Q) {
+		if (q_len  >= 9) {
+			pkt_cnt = 8;
+			pkt_cnt -= 1;
+		} else {
+			pkt_cnt = skb_queue_len(&common->tx_queue[q_num]);
+			pkt_cnt -= 1;
+		}
+
+	} else if (selected_qnum == VI_Q) {
+		if (q_len >= 5) {
+			pkt_cnt = 4;
+			pkt_cnt -= 1;
+		} else	{
+			pkt_cnt = skb_queue_len(&common->tx_queue[q_num]);
+			pkt_cnt -= 1;
+		}
+	} else {
+		pkt_cnt = 0;
+	}
+
+	return q_num;
+}
+
+/**
+ * This functions queues the packet to the queue specified by the queue number.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return None.
+ */
+static inline void rsi_core_queue_pkt(struct rsi_common *common,
+				      struct sk_buff *skb)
+{
+	unsigned char q_num = skb->priority;
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
+						   unsigned char q_num)
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
+	unsigned char q_num;
+#ifdef USE_SDIO_INTF
+	unsigned char counter = 0;
+#endif
+	unsigned long tstamp_1, tstamp_2;
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
+#ifdef USE_SDIO_INTF
+		if (common->rx_info.semi_buffer_full)
+			counter = 1;
+		else
+			counter = 4;
+
+		if ((pkt_count++ % counter) == 0) {
+			if (rsi_read_buf_status_reg(common)) {
+				mutex_unlock(&common->tx_rxlock);
+				break;
+			}
+		}
+#endif
+
+		if ((q_num == MGMT_SOFT_Q) &&
+		    (common->rx_info.mgmt_buffer_full)) {
+			rsi_dbg(DATA_TX_ZONE, "%s: Mgmt buffer full\n",
+				__func__);
+			mutex_unlock(&common->tx_rxlock);
+			break;
+		} else if (common->rx_info.buffer_full) {
+			rsi_dbg(DATA_TX_ZONE, "%s: Buffer full\n", __func__);
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
+		switch (q_num) {
+		case MGMT_SOFT_Q:
+			common->tx_stats.total_mgmt_pkt_send++;
+			break;
+		default:
+			common->tx_stats.total_data_pkt_send[q_num]++;
+			break;
+		}
+
+		if (q_num == MGMT_SOFT_Q)
+			rsi_send_mgmt_pkt(common, skb);
+		else
+			rsi_send_data_pkt(common, skb);
+		tstamp_2 = jiffies;
+		mutex_unlock(&common->tx_rxlock);
+
+		if (tstamp_2 > tstamp_1 + (300 * HZ/1000))
+			schedule();
+	}
+	return;
+}
+
+/**
+ * This function transmits the packets which driver recieves from mac80211.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
+{
+	unsigned char q_num;
+	unsigned char frame_type;
+	unsigned char tid = 0;
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
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
+
+static struct rsi_common_ops common_operations = {
+	.set_event = rsi_set_event,
+	.reset_event = rsi_reset_event,
+	.wait_queue_event = rsi_wait_event,
+	.qos_processor = rsi_core_qos_processor,
+#ifdef USE_USB_INTF
+	.rx_urb_submit = rsi_rx_urb_submit,
+	.load_firmware = rsi_write_ta_register_multiple,
+	.host_intf_write_pkt = rsi_write_pkt,
+#endif
+#ifdef USE_SDIO_INTF
+	.load_firmware = rsi_write_register_multiple,
+	.ack_interrupt = rsi_ack_interrupt,
+	.read_reg_multiple = rsi_read_register_multiple,
+	.write_reg_multiple = rsi_write_register_multiple,
+	.write_register = rsi_write_register,
+	.read_register = rsi_read_register,
+	.host_intf_write_pkt = rsi_host_intf_write_pkt,
+	.host_intf_read_pkt = rsi_host_intf_read_pkt,
+#endif
+	.print = rsi_print,
+	.core_xmit = rsi_core_xmit,
+};
+
+/**
+ * This function returns the pointer to the common ops structure.
+ *
+ * @param   none.
+ * @return  common_operations Pointer to the driver common operations success.
+ */
+struct rsi_common_ops *rsi_get_common_ops(void)
+{
+	return &common_operations;
+}



