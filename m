Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14472 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaB0OVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:44 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 10/16] wil6210: per-connection statistics
Date: Thu, 27 Feb 2014 16:20:49 +0200
Message-ID: <1393510855-17566-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152154_232796_53653A90)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculate statistics per connection, report with "iw station dump"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 36 ++++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/txrx.c     | 21 +++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h  | 11 +++++++++
 drivers/net/wireless/ath/wil6210/wmi.c      | 15 +++++++++++-
 4 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 495347b..12e0539 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -115,6 +115,7 @@ static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 		struct wil6210_mbox_hdr_wmi wmi;
 		struct wmi_notify_req_done_event evt;
 	} __packed reply;
+	struct wil_net_stats *stats = &wil->sta[cid].stats;
 	int rc;
 
 	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
@@ -122,14 +123,43 @@ static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 	if (rc)
 		return rc;
 
+	wil_dbg_wmi(wil, "Link status for CID %d: {\n"
+		    "  MCS %d TSF 0x%016llx\n"
+		    "  BF status 0x%08x SNR 0x%08x\n"
+		    "  Tx Tpt %d goodput %d Rx goodput %d\n"
+		    "  Sectors(rx:tx) my %d:%d peer %d:%d\n""}\n",
+		    cid, le16_to_cpu(reply.evt.bf_mcs),
+		    le64_to_cpu(reply.evt.tsf), reply.evt.status,
+		    le32_to_cpu(reply.evt.snr_val),
+		    le32_to_cpu(reply.evt.tx_tpt),
+		    le32_to_cpu(reply.evt.tx_goodput),
+		    le32_to_cpu(reply.evt.rx_goodput),
+		    le16_to_cpu(reply.evt.my_rx_sector),
+		    le16_to_cpu(reply.evt.my_tx_sector),
+		    le16_to_cpu(reply.evt.other_rx_sector),
+		    le16_to_cpu(reply.evt.other_tx_sector));
+
 	sinfo->generation = wil->sinfo_gen;
 
-	sinfo->filled |= STATION_INFO_TX_BITRATE;
+	sinfo->filled = STATION_INFO_RX_BYTES |
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_RX_PACKETS |
+			STATION_INFO_TX_PACKETS |
+			STATION_INFO_RX_BITRATE |
+			STATION_INFO_TX_BITRATE |
+			STATION_INFO_RX_DROP_MISC |
+			STATION_INFO_TX_FAILED;
+
 	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
 	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
-	sinfo->filled |= STATION_INFO_RX_BITRATE;
 	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
-	sinfo->rxrate.mcs = wil->stats.last_mcs_rx;
+	sinfo->rxrate.mcs = stats->last_mcs_rx;
+	sinfo->rx_bytes = stats->rx_bytes;
+	sinfo->rx_packets = stats->rx_packets;
+	sinfo->rx_dropped_misc = stats->rx_dropped;
+	sinfo->tx_bytes = stats->tx_bytes;
+	sinfo->tx_packets = stats->tx_packets;
+	sinfo->tx_failed = stats->tx_errors;
 
 	if (test_bit(wil_status_fwconnected, &wil->status)) {
 		sinfo->filled |= STATION_INFO_SIGNAL;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 5ff59ee..baced1b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -344,6 +344,9 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	u16 dmalen;
 	u8 ftype;
 	u8 ds_bits;
+	int cid;
+	struct wil_net_stats *stats;
+
 
 	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
 
@@ -383,8 +386,10 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
-
-	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d);
+	cid = wil_rxdesc_cid(d);
+	stats = &wil->sta[cid].stats;
+	stats->last_mcs_rx = wil_rxdesc_mcs(d);
+	wil->stats.last_mcs_rx = stats->last_mcs_rx;
 
 	/* use radiotap header only if required */
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
@@ -475,7 +480,11 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 {
 	int rc;
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	unsigned int len = skb->len;
+	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
+	int cid = wil_rxdesc_cid(d);
+	struct wil_net_stats *stats = &wil->sta[cid].stats;
 
 	skb_orphan(skb);
 
@@ -483,10 +492,13 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 
 	if (likely(rc == NET_RX_SUCCESS)) {
 		ndev->stats.rx_packets++;
+		stats->rx_packets++;
 		ndev->stats.rx_bytes += len;
+		stats->rx_bytes += len;
 
 	} else {
 		ndev->stats.rx_dropped++;
+		stats->rx_dropped++;
 	}
 }
 
@@ -968,6 +980,8 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	struct device *dev = wil_to_dev(wil);
 	struct vring *vring = &wil->vring_tx[ringid];
 	int done = 0;
+	int cid = wil->vring2cid_tid[ringid][0];
+	struct wil_net_stats *stats = &wil->sta[cid].stats;
 
 	if (!vring->va) {
 		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
@@ -1009,9 +1023,12 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		if (skb) {
 			if (d->dma.error == 0) {
 				ndev->stats.tx_packets++;
+				stats->tx_packets++;
 				ndev->stats.tx_bytes += skb->len;
+				stats->tx_bytes += skb->len;
 			} else {
 				ndev->stats.tx_errors++;
+				stats->tx_errors++;
 			}
 
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 304b990..b64175a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -274,6 +274,16 @@ enum wil_sta_status {
 
 #define WIL_STA_TID_NUM (16)
 
+struct wil_net_stats {
+	unsigned long	rx_packets;
+	unsigned long	tx_packets;
+	unsigned long	rx_bytes;
+	unsigned long	tx_bytes;
+	unsigned long	tx_errors;
+	unsigned long	rx_dropped;
+	u16 last_mcs_rx;
+};
+
 /**
  * struct wil_sta_info - data for peer
  *
@@ -285,6 +295,7 @@ enum wil_sta_status {
 struct wil_sta_info {
 	u8 addr[ETH_ALEN];
 	enum wil_sta_status status;
+	struct wil_net_stats stats;
 	/* Rx BACK */
 	struct wil_tid_ampdu_rx *tid_rx[WIL_STA_TID_NUM];
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(WIL_STA_TID_NUM)];
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 635aa32..8de7ffd 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -510,10 +510,16 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	int sz = eapol_len + ETH_HLEN;
 	struct sk_buff *skb;
 	struct ethhdr *eth;
+	int cid;
+	struct wil_net_stats *stats = NULL;
 
 	wil_dbg_wmi(wil, "EAPOL len %d from %pM\n", eapol_len,
 		    evt->src_mac);
 
+	cid = wil_find_cid(wil, evt->src_mac);
+	if (cid >= 0)
+		stats = &wil->sta[cid].stats;
+
 	if (eapol_len > 196) { /* TODO: revisit size limit */
 		wil_err(wil, "EAPOL too large\n");
 		return;
@@ -524,6 +530,7 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 		wil_err(wil, "Failed to allocate skb\n");
 		return;
 	}
+
 	eth = (struct ethhdr *)skb_put(skb, ETH_HLEN);
 	memcpy(eth->h_dest, ndev->dev_addr, ETH_ALEN);
 	memcpy(eth->h_source, evt->src_mac, ETH_ALEN);
@@ -532,9 +539,15 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	skb->protocol = eth_type_trans(skb, ndev);
 	if (likely(netif_rx_ni(skb) == NET_RX_SUCCESS)) {
 		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += skb->len;
+		ndev->stats.rx_bytes += sz;
+		if (stats) {
+			stats->rx_packets++;
+			stats->rx_bytes += sz;
+		}
 	} else {
 		ndev->stats.rx_dropped++;
+		if (stats)
+			stats->rx_dropped++;
 	}
 }
 
-- 
1.8.3.2

