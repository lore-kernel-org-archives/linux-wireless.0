Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6549 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530AbbE1O1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 10:27:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SEPRgi007969
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 07:27:16 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1umgmaqyfu-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 07:27:16 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 08/17] mwifiex: maintain station statistic in uap mode
Date: Fri, 29 May 2015 01:24:49 +0530
Message-ID: <1432842898-3219-9-git-send-email-patila@marvell.com> (sfid-20150528_162720_422397_F72A7F3D)
In-Reply-To: <1432842898-3219-1-git-send-email-patila@marvell.com>
References: <1432842898-3219-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch maintain statistic information for the stations associated
to the mwifiex micro AP, include tx/rx bytes/packets, signal strength,
tx bitrate.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h       |  7 ++++++-
 drivers/net/wireless/mwifiex/main.h     | 13 +++++++++++++
 drivers/net/wireless/mwifiex/txrx.c     | 13 +++++++++++--
 drivers/net/wireless/mwifiex/uap_txrx.c | 18 +++++++++++++++++-
 drivers/net/wireless/mwifiex/util.c     | 13 +++++++++++++
 5 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 124120d..1a87188 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -632,7 +632,12 @@ struct uap_rxpd {
 	__le16 rx_pkt_type;
 	__le16 seq_num;
 	u8 priority;
-	u8 reserved1;
+	u8 rx_rate;
+	s8 snr;
+	s8 nf;
+	u8 ht_info;
+	u8 reserved[3];
+	u8 flags;
 };
 
 struct mwifiex_fw_chan_stats {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 88d3779..837e610 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -741,6 +741,18 @@ struct mwifiex_tdls_capab {
 	struct ieee80211_vht_operation vhtoper;
 };
 
+struct mwifiex_station_stats {
+	u64 last_rx;
+	s8 rssi;
+	u64 rx_bytes;
+	u64 tx_bytes;
+	u32 rx_packets;
+	u32 tx_packets;
+	u32 tx_failed;
+	u8 last_tx_rate;
+	u8 last_tx_htinfo;
+};
+
 /* This is AP/TDLS specific structure which stores information
  * about associated/peer STA
  */
@@ -755,6 +767,7 @@ struct mwifiex_sta_node {
 	u16 max_amsdu;
 	u8 tdls_status;
 	struct mwifiex_tdls_capab tdls_cap;
+	struct mwifiex_station_stats stats;
 };
 
 struct mwifiex_auto_tdls_peer {
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 28dcc84..c4c7d8d 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -88,13 +88,22 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 *head_ptr;
 	struct txpd *local_tx_pd = NULL;
+	struct mwifiex_sta_node *dest_node;
+	struct ethhdr *hdr = (void *)skb->data;
 
 	hroom = (adapter->iface_type == MWIFIEX_USB) ? 0 : INTF_HEADER_LEN;
 
-	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
+	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP) {
+		dest_node = mwifiex_get_sta_entry(priv, hdr->h_dest);
+		if (dest_node) {
+			dest_node->stats.tx_bytes += skb->len;
+			dest_node->stats.tx_packets++;
+		}
+
 		head_ptr = mwifiex_process_uap_txpd(priv, skb);
-	else
+	} else {
 		head_ptr = mwifiex_process_sta_txpd(priv, skb);
+	}
 
 	if ((adapter->data_sent || adapter->tx_lock_flag) && head_ptr) {
 		skb_queue_tail(&adapter->tx_data_q, skb);
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 61c52fd..8766741 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -97,6 +97,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
 	struct ethhdr *p_ethhdr;
+	struct mwifiex_sta_node *src_node;
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
@@ -180,6 +181,15 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	tx_info->bss_type = priv->bss_type;
 	tx_info->flags |= MWIFIEX_BUF_FLAG_BRIDGED_PKT;
 
+	src_node = mwifiex_get_sta_entry(priv, rx_pkt_hdr->eth803_hdr.h_source);
+	if (src_node) {
+		src_node->stats.last_rx = jiffies;
+		src_node->stats.rx_bytes += skb->len;
+		src_node->stats.rx_packets++;
+		src_node->stats.last_tx_rate = uap_rx_pd->rx_rate;
+		src_node->stats.last_tx_htinfo = uap_rx_pd->ht_info;
+	}
+
 	if (is_unicast_ether_addr(rx_pkt_hdr->eth803_hdr.h_dest)) {
 		/* Update bridge packet statistics as the
 		 * packet is not going to kernel/upper layer.
@@ -275,6 +285,8 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 	rx_pkt_type = le16_to_cpu(uap_rx_pd->rx_pkt_type);
 	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd->rx_pkt_offset);
 
+	ether_addr_copy(ta, rx_pkt_hdr->eth803_hdr.h_source);
+
 	if ((le16_to_cpu(uap_rx_pd->rx_pkt_offset) +
 	     le16_to_cpu(uap_rx_pd->rx_pkt_length)) > (u16) skb->len) {
 		mwifiex_dbg(adapter, ERROR,
@@ -282,6 +294,11 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 			    skb->len, le16_to_cpu(uap_rx_pd->rx_pkt_offset),
 			    le16_to_cpu(uap_rx_pd->rx_pkt_length));
 		priv->stats.rx_dropped++;
+
+		node = mwifiex_get_sta_entry(priv, ta);
+		if (node)
+			node->stats.tx_failed++;
+
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
@@ -295,7 +312,6 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 		return ret;
 	}
 
-	memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
 
 	if (rx_pkt_type != PKT_TYPE_BAR && uap_rx_pd->priority < MAX_NUM_TID) {
 		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 370323a..2e3dc07 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -416,12 +416,25 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
  */
 int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
 {
+	struct mwifiex_sta_node *src_node;
+	struct ethhdr *p_ethhdr;
+
 	if (!skb)
 		return -1;
 
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
 
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		p_ethhdr = (void *)skb->data;
+		src_node = mwifiex_get_sta_entry(priv, p_ethhdr->h_source);
+		if (src_node) {
+			src_node->stats.last_rx = jiffies;
+			src_node->stats.rx_bytes += skb->len;
+			src_node->stats.rx_packets++;
+		}
+	}
+
 	skb->dev = priv->netdev;
 	skb->protocol = eth_type_trans(skb, priv->netdev);
 	skb->ip_summed = CHECKSUM_NONE;
-- 
1.8.1.4

