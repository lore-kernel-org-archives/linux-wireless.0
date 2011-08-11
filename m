Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1HKGtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:49:18 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 6/7] ath6kl: data path for supporting HIF USB on AR6004
Date: Thu, 11 Aug 2011 14:48:14 +0800
Message-ID: <1313045295-16202-6-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_084921_505953_7B48DA5A)
In-Reply-To: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For optimizing htc packet with usb on the AR6004.
And handling padding data on the AR6004.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.h  |    8 ++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h  |    3 +++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 2f18017..4b6980a 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -308,6 +308,14 @@ struct htc_packet {
 
 	void (*completion) (struct htc_target *, struct htc_packet *);
 	struct htc_target *context;
+
+	/*
+	 * optimization for network-oriented data, the HTC packet
+	 * can pass the network buffer corresponding to the HTC packet
+	 * lower layers may optimized the transfer knowing this is
+	 * a network buffer
+	 */
+	struct sk_buff *netbufcontext;
 };
 
 enum htc_send_full_action {
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 2712cf0..a02808c 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -216,6 +216,7 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	cookie->map_no = 0;
 	set_htc_pkt_info(&cookie->htc_pkt, cookie, skb->data, skb->len,
 			 eid, ATH6KL_CONTROL_PKT_TAG);
+	cookie->htc_pkt.netbufcontext = skb;
 
 	/*
 	 * This interface is asynchronous, if there is an error, cleanup
@@ -324,6 +325,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	cookie->map_no = map_no;
 	set_htc_pkt_info(&cookie->htc_pkt, cookie, skb->data, skb->len,
 			 eid, htc_tag);
+	cookie->htc_pkt.netbufcontext = skb;
 
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, skb->data, skb->len);
 
@@ -692,6 +694,8 @@ void ath6kl_rx_refill(struct htc_target *target, enum htc_endpoint_id endpoint)
 		packet = (struct htc_packet *) skb->head;
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				ATH6KL_BUFFER_SIZE, endpoint);
+		packet->netbufcontext = skb;
+
 		list_add_tail(&packet->list, &queue);
 	}
 
@@ -712,6 +716,8 @@ void ath6kl_refill_amsdu_rxbufs(struct ath6kl *ar, int count)
 		packet = (struct htc_packet *) skb->head;
 		set_htc_rxpkt_info(packet, skb, skb->data,
 				   ATH6KL_AMSDU_BUFFER_SIZE, 0);
+		packet->netbufcontext = skb;
+
 		spin_lock_bh(&ar->lock);
 		list_add_tail(&packet->list, &ar->amsdu_rx_buffer_queue);
 		spin_unlock_bh(&ar->lock);
@@ -1016,6 +1022,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	struct wmi_data_hdr *dhdr;
 	int min_hdr_len;
 	u8 meta_type, dot11_hdr = 0;
+	u8 pad_before_data_start;
 	int status = packet->status;
 	enum htc_endpoint_id ept = packet->endpoint;
 	bool is_amsdu, prev_ps, ps_state = false;
@@ -1164,6 +1171,9 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	seq_no = wmi_data_hdr_get_seqno(dhdr);
 	meta_type = wmi_data_hdr_get_meta(dhdr);
 	dot11_hdr = wmi_data_hdr_get_dot11(dhdr);
+	pad_before_data_start =
+		(dhdr->info3 >> WMI_DATA_HDR_PAD_BEFORE_DATA_SHIFT)
+			& WMI_DATA_HDR_PAD_BEFORE_DATA_MASK;
 
 	ath6kl_wmi_data_hdr_remove(ar->wmi, skb);
 
@@ -1183,6 +1193,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		break;
 	}
 
+	skb_pull(skb, pad_before_data_start);
+
 	if (dot11_hdr)
 		status = ath6kl_wmi_dot11_hdr_remove(ar->wmi, skb);
 	else if (!is_amsdu)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index fe3ddce..4b5fae8 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -181,6 +181,9 @@ enum wmi_data_hdr_data_type {
 #define WMI_DATA_HDR_META_MASK      0x7
 #define WMI_DATA_HDR_META_SHIFT     13
 
+#define WMI_DATA_HDR_PAD_BEFORE_DATA_MASK               0xFF
+#define WMI_DATA_HDR_PAD_BEFORE_DATA_SHIFT              0x8
+
 struct wmi_data_hdr {
 	s8 rssi;
 
-- 
1.7.0.4

