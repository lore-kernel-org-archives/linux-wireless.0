Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog013.obsmtp.com ([74.125.150.66]:48583 "EHLO
	na6sys009bog013.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2HDByu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:54:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/16] mwifiex: do le_to_cpu conversion for Rx packet header elements
Date: Fri,  3 Aug 2012 18:06:02 -0700
Message-Id: <1344042374-6892-5-git-send-email-bzhao@marvell.com> (sfid-20120804_035537_369921_EF652462)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We do similar conversion for Tx packet header but it was missing
for Rx packet header. Without this fix, Rx packet header won't
be correctly parsed on big endian platform.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h     |    8 +++---
 drivers/net/wireless/mwifiex/sta_rx.c |   38 +++++++++++++++-----------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index e831b44..a0222ec 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -424,10 +424,10 @@ struct txpd {
 struct rxpd {
 	u8 bss_type;
 	u8 bss_num;
-	u16 rx_pkt_length;
-	u16 rx_pkt_offset;
-	u16 rx_pkt_type;
-	u16 seq_num;
+	__le16 rx_pkt_length;
+	__le16 rx_pkt_offset;
+	__le16 rx_pkt_type;
+	__le16 seq_num;
 	u8 priority;
 	u8 rx_rate;
 	s8 snr;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 02ce3b7..d91d5c0 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -54,8 +54,8 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
-	rx_pkt_hdr = (struct rx_packet_hdr *) ((u8 *) local_rx_pd +
-				local_rx_pd->rx_pkt_offset);
+	rx_pkt_hdr = (void *)local_rx_pd +
+		     le16_to_cpu(local_rx_pd->rx_pkt_offset);
 
 	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
 		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
@@ -125,7 +125,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u8 ta[ETH_ALEN];
-	u16 rx_pkt_type;
+	u16 rx_pkt_type, rx_pkt_offset, rx_pkt_length, seq_num;
 	struct mwifiex_private *priv =
 			mwifiex_get_priv_by_id(adapter, rx_info->bss_num,
 					       rx_info->bss_type);
@@ -134,16 +134,17 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		return -1;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
-	rx_pkt_type = local_rx_pd->rx_pkt_type;
+	rx_pkt_type = le16_to_cpu(local_rx_pd->rx_pkt_type);
+	rx_pkt_offset = le16_to_cpu(local_rx_pd->rx_pkt_offset);
+	rx_pkt_length = le16_to_cpu(local_rx_pd->rx_pkt_length);
+	seq_num = le16_to_cpu(local_rx_pd->seq_num);
 
-	rx_pkt_hdr = (struct rx_packet_hdr *) ((u8 *) local_rx_pd +
-					local_rx_pd->rx_pkt_offset);
+	rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_offset;
 
-	if ((local_rx_pd->rx_pkt_offset + local_rx_pd->rx_pkt_length) >
-	    (u16) skb->len) {
-		dev_err(adapter->dev, "wrong rx packet: len=%d,"
-			" rx_pkt_offset=%d, rx_pkt_length=%d\n", skb->len,
-		       local_rx_pd->rx_pkt_offset, local_rx_pd->rx_pkt_length);
+	if ((rx_pkt_offset + rx_pkt_length) > (u16) skb->len) {
+		dev_err(adapter->dev,
+			"wrong rx packet: len=%d, rx_pkt_offset=%d, rx_pkt_length=%d\n",
+			skb->len, rx_pkt_offset, rx_pkt_length);
 		priv->stats.rx_dropped++;
 
 		if (adapter->if_ops.data_complete)
@@ -154,14 +155,14 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		return ret;
 	}
 
-	if (local_rx_pd->rx_pkt_type == PKT_TYPE_AMSDU) {
+	if (rx_pkt_type == PKT_TYPE_AMSDU) {
 		struct sk_buff_head list;
 		struct sk_buff *rx_skb;
 
 		__skb_queue_head_init(&list);
 
-		skb_pull(skb, local_rx_pd->rx_pkt_offset);
-		skb_trim(skb, local_rx_pd->rx_pkt_length);
+		skb_pull(skb, rx_pkt_offset);
+		skb_trim(skb, rx_pkt_length);
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
 					 priv->wdev->iftype, 0, false);
@@ -189,17 +190,14 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
 	} else {
 		if (rx_pkt_type != PKT_TYPE_BAR)
-			priv->rx_seq[local_rx_pd->priority] =
-						local_rx_pd->seq_num;
+			priv->rx_seq[local_rx_pd->priority] = seq_num;
 		memcpy(ta, priv->curr_bss_params.bss_descriptor.mac_address,
 		       ETH_ALEN);
 	}
 
 	/* Reorder and send to OS */
-	ret = mwifiex_11n_rx_reorder_pkt(priv, local_rx_pd->seq_num,
-					     local_rx_pd->priority, ta,
-					     (u8) local_rx_pd->rx_pkt_type,
-					     skb);
+	ret = mwifiex_11n_rx_reorder_pkt(priv, seq_num, local_rx_pd->priority,
+					 ta, (u8) rx_pkt_type, skb);
 
 	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
 		if (adapter->if_ops.data_complete)
-- 
1.7.0.2

