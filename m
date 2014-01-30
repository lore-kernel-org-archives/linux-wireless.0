Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:12125 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaA3P6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 10:58:48 -0500
Message-ID: <52EA7609.30107@redpinesignals.com> (sfid-20140130_165852_648985_0A621F09)
Date: Thu, 30 Jan 2014 21:25:53 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.13.1 7/9] rsi: Sending pkts to device
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This patch has the functions which send the packets to be 
written onto the device. 

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

rsi_91x_pkt.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1 file changed, 231 insertions(+)

diff -uprN a/drivers/net/wireless/rsi/91x/rsi_91x_pkt.c b/drivers/net/wireless/rsi/91x/rsi_91x_pkt.c
--- a/drivers/net/wireless/rsi/91x/rsi_91x_pkt.c	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/91x/rsi_91x_pkt.c	2014-01-30 16:25:56.129903584 +0530
@@ -0,0 +1,231 @@
+/**
+ * @file rsi_91x_pkt.c
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
+ * The file handles the data/mgmt packets transfer to the device.
+ */
+
+#include "../include/rsi_main.h"
+#include "../include/rsi_device_ops.h"
+#include "../include/rsi_mgmt.h"
+
+/**
+ * This function sends the recieved data packet from driver to onair.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return status: 0 on success, -1 on failure.
+ */
+int rsi_send_data_pkt(struct rsi_common *common,
+		      struct sk_buff *skb)
+{
+	unsigned short *frame_desc;
+	unsigned short seq_num = 0;
+	struct ieee80211_hdr *tmp_hdr = NULL;
+	unsigned char ieee80211_size = MIN_802_11_HDR_LEN;
+	unsigned char extnd_size = 0;
+	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
+	struct ieee80211_bss_conf *bss = NULL;
+	int status = -1;
+
+	info = IEEE80211_SKB_CB(skb);
+	bss = &info->control.vif->bss_conf;
+	tx_params = (struct skb_info *)info->driver_data;
+
+	if ((common->fsm_state != FSM_MAC_INIT_DONE) || (!bss->assoc))
+		goto err;
+
+	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
+	seq_num = (tmp_hdr->seq_ctrl >> 4);
+
+	extnd_size = ((uintptr_t)skb->data & 0x3);
+
+	if ((FRAME_DESC_SZ + extnd_size) > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
+		goto err;
+	} else {
+		skb_push(skb, (FRAME_DESC_SZ + extnd_size));
+	}
+
+	frame_desc = (unsigned short *)&skb->data[0];
+	memset((unsigned char *)frame_desc, 0, FRAME_DESC_SZ);
+
+	if (tmp_hdr->frame_control & IEEE80211_QOS_ENABLED) {
+		ieee80211_size += 2;
+		frame_desc[6] |= cpu_to_le16(BIT(12));
+	}
+
+	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
+	    (common->secinfo.security_enable)) {
+		if (rsi_is_cipher_wep(common))
+			ieee80211_size += 4;
+		else
+			ieee80211_size += 8;
+		frame_desc[6] |= cpu_to_le16(BIT(15));
+	}
+
+	frame_desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
+				(RSI_WIFI_DATA_Q << 12));
+	frame_desc[2] = cpu_to_le16((extnd_size) | (ieee80211_size) << 8);
+
+	if (common->min_rate != 0xffff) {
+		/* Send fixed rate */
+		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
+		frame_desc[4] = cpu_to_le16(common->min_rate);
+	}
+
+	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
+	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
+				(skb->priority & 0xf) |
+				(tx_params->sta_id << 8));
+
+	common->common_ops->print(DATA_TX_ZONE, skb->data, skb->len);
+	if (skb->len <= 1594) {
+		status = common->common_ops->host_intf_write_pkt(common->priv,
+								 skb->data,
+								 skb->len);
+		if (status) {
+			rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
+				__func__);
+		}
+	}
+
+err:
+	++common->tx_stats.total_data_pkt_freed[skb->priority];
+	rsi_indicate_tx_status(common->priv, skb, status);
+	return status;
+}
+EXPORT_SYMBOL(rsi_send_data_pkt);
+
+/**
+ * This functions sends the recieved management packet from driver to onair.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return status: 0 on success, -1 on failure.
+ */
+int rsi_send_mgmt_pkt(struct rsi_common *common,
+		      struct sk_buff *skb)
+{
+	unsigned short *msg = NULL;
+	unsigned char vap_id = 0;
+	struct ieee80211_hdr *wh = NULL;
+	unsigned char extnd_size = 0;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_bss_conf *bss = NULL;
+	struct skb_info *tx_params;
+	int status = -1;
+
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+	extnd_size = ((uintptr_t)skb->data & 0x3);
+
+	if (tx_params->flags & INTERNAL_MGMT_PKT) {
+		if ((extnd_size) > skb_headroom(skb)) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n",
+				__func__);
+			dev_kfree_skb(skb);
+			return -1;
+		} else {
+			skb_push(skb, extnd_size);
+		}
+		skb->data[extnd_size + 4] = cpu_to_le16(extnd_size);
+		common->common_ops->print(MGMT_TX_ZONE,
+					  (unsigned char *)skb->data,
+					  skb->len);
+		status = common->common_ops->host_intf_write_pkt(common->priv,
+						(unsigned char *)skb->data,
+						skb->len);
+		if (status) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to write the packet\n", __func__);
+			common->common_ops->print(ERR_ZONE,
+						  skb->data,
+						  skb->len);
+		}
+		dev_kfree_skb(skb);
+		return status;
+	}
+
+	bss = &info->control.vif->bss_conf;
+	wh = (struct ieee80211_hdr *)&skb->data[0];
+
+	if (common->fsm_state != FSM_MAC_INIT_DONE)
+		goto err;
+
+	if (FRAME_DESC_SZ > skb_headroom(skb))
+		goto err;
+	else
+		skb_push(skb, FRAME_DESC_SZ);
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	msg = (unsigned short *)skb->data;
+
+	if (skb->len > MAX_MGMT_PKT_SIZE) {
+		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
+		goto err;
+	}
+
+	msg[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
+			    (RSI_WIFI_MGMT_Q << 12));
+	msg[1] = cpu_to_le16(TX_DOT11_MGMT);
+	msg[2] = cpu_to_le16(MIN_802_11_HDR_LEN << 8);
+	msg[3] = cpu_to_le16(RATE_INFO_ENABLE);
+	msg[6] = cpu_to_le16(wh->seq_ctrl >> 4);
+
+	if (wh->addr1[0] & 0x1)
+		msg[3] |= cpu_to_le16(RSI_BROADCAST_PKT);
+
+	if (common->band == IEEE80211_BAND_2GHZ)
+		msg[4] = cpu_to_le16(RSI_11B_MODE);
+	else
+		msg[4] = cpu_to_le16(0xB | RSI_11G_MODE);
+
+	/* Indicate to firmware to give cfm */
+	if ((skb->data[16] == 0x40) && (!bss->assoc)) {
+		msg[1] |= cpu_to_le16(1 << 10);
+		msg[7] = cpu_to_le16(PROBEREQ_CONFIRM);
+		common->mgmt_q_block = true;
+	}
+
+	msg[7] |= cpu_to_le16(vap_id << 8);
+
+	common->common_ops->print(MGMT_TX_ZONE,
+				  (unsigned char *)msg,
+				  skb->len);
+
+	status = common->common_ops->host_intf_write_pkt(common->priv,
+							 (unsigned char *)msg,
+							 skb->len);
+	if (status) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n",
+			__func__);
+		common->common_ops->print(ERR_ZONE,
+					  (unsigned char *)msg,
+					  skb->len);
+	}
+
+err:
+	rsi_indicate_tx_status(common->priv, skb, status);
+	return status;
+}
+EXPORT_SYMBOL(rsi_send_mgmt_pkt);



