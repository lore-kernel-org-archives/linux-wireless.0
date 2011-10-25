Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38840 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1JYKMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:12:24 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 16/34] ath6kl: Make net and target stats vif specific
Date: Tue, 25 Oct 2011 15:40:12 +0530
Message-ID: <1319537430-12459-17-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_121227_666691_B761F21C)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   20 ++++++++++----------
 drivers/net/wireless/ath/ath6kl/core.h     |    6 +++---
 drivers/net/wireless/ath/ath6kl/debug.c    |    8 +++++---
 drivers/net/wireless/ath/ath6kl/main.c     |   12 +++++++-----
 drivers/net/wireless/ath/ath6kl/txrx.c     |   20 ++++++++++----------
 5 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 06389b3..8384793 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1414,7 +1414,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (down_interruptible(&ar->sem))
 		return -EBUSY;
 
-	set_bit(STATS_UPDATE_PEND, &ar->flag);
+	set_bit(STATS_UPDATE_PEND, &vif->flags);
 
 	ret = ath6kl_wmi_get_stats_cmd(ar->wmi);
 
@@ -1425,7 +1425,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	left = wait_event_interruptible_timeout(ar->event_wq,
 						!test_bit(STATS_UPDATE_PEND,
-							  &ar->flag),
+							  &vif->flags),
 						WMI_TIMEOUT);
 
 	up(&ar->sem);
@@ -1435,24 +1435,24 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 	else if (left < 0)
 		return left;
 
-	if (ar->target_stats.rx_byte) {
-		sinfo->rx_bytes = ar->target_stats.rx_byte;
+	if (vif->target_stats.rx_byte) {
+		sinfo->rx_bytes = vif->target_stats.rx_byte;
 		sinfo->filled |= STATION_INFO_RX_BYTES;
-		sinfo->rx_packets = ar->target_stats.rx_pkt;
+		sinfo->rx_packets = vif->target_stats.rx_pkt;
 		sinfo->filled |= STATION_INFO_RX_PACKETS;
 	}
 
-	if (ar->target_stats.tx_byte) {
-		sinfo->tx_bytes = ar->target_stats.tx_byte;
+	if (vif->target_stats.tx_byte) {
+		sinfo->tx_bytes = vif->target_stats.tx_byte;
 		sinfo->filled |= STATION_INFO_TX_BYTES;
-		sinfo->tx_packets = ar->target_stats.tx_pkt;
+		sinfo->tx_packets = vif->target_stats.tx_pkt;
 		sinfo->filled |= STATION_INFO_TX_PACKETS;
 	}
 
-	sinfo->signal = ar->target_stats.cs_rssi;
+	sinfo->signal = vif->target_stats.cs_rssi;
 	sinfo->filled |= STATION_INFO_SIGNAL;
 
-	rate = ar->target_stats.tx_ucast_rate;
+	rate = vif->target_stats.tx_ucast_rate;
 
 	if (is_rate_legacy(rate)) {
 		sinfo->txrate.legacy = rate / 100;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f33159a..0e0fba7 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -391,6 +391,7 @@ enum ath6kl_vif_state {
 	CLEAR_BSSFILTER_ON_BEACON,
 	DTIM_PERIOD_AVAIL,
 	WLAN_ENABLED,
+	STATS_UPDATE_PEND,
 };
 
 struct ath6kl_vif {
@@ -425,6 +426,8 @@ struct ath6kl_vif {
 	u16 next_chan;
 	u16 assoc_bss_beacon_int;
 	u8 assoc_bss_dtim_period;
+	struct net_device_stats net_stats;
+	struct target_stats target_stats;
 };
 
 /* Flag info */
@@ -435,7 +438,6 @@ enum ath6kl_dev_state {
 	TESTMODE,
 	DESTROY_IN_PROGRESS,
 	SKIP_SCAN,
-	STATS_UPDATE_PEND,
 	ROAM_TBL_PEND,
 };
 
@@ -459,8 +461,6 @@ struct ath6kl {
 	struct ath6kl_version version;
 	u32 target_type;
 	u8 tx_pwr;
-	struct net_device_stats net_stats;
-	struct target_stats target_stats;
 	struct ath6kl_node_mapping node_map[MAX_NODE_NUM];
 	u8 ibss_ps_enable;
 	u8 node_num;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index ff02b00..6a4322f 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -395,7 +395,9 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
-	struct target_stats *tgt_stats = &ar->target_stats;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+	struct target_stats *tgt_stats = &vif->target_stats;
 	char *buf;
 	unsigned int len = 0, buf_len = 1500;
 	int i;
@@ -411,7 +413,7 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 		return -EBUSY;
 	}
 
-	set_bit(STATS_UPDATE_PEND, &ar->flag);
+	set_bit(STATS_UPDATE_PEND, &vif->flags);
 
 	if (ath6kl_wmi_get_stats_cmd(ar->wmi)) {
 		up(&ar->sem);
@@ -421,7 +423,7 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 
 	left = wait_event_interruptible_timeout(ar->event_wq,
 						!test_bit(STATS_UPDATE_PEND,
-						&ar->flag), WMI_TIMEOUT);
+						&vif->flags), WMI_TIMEOUT);
 
 	up(&ar->sem);
 
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 6b2f855..cc1acec 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -838,7 +838,9 @@ static void ath6kl_update_target_stats(struct ath6kl *ar, u8 *ptr, u32 len)
 {
 	struct wmi_target_stats *tgt_stats =
 		(struct wmi_target_stats *) ptr;
-	struct target_stats *stats = &ar->target_stats;
+	/* TODO: Findout vif */
+	struct ath6kl_vif *vif = ar->vif;
+	struct target_stats *stats = &vif->target_stats;
 	struct tkip_ccmp_stats *ccmp_stats;
 	u8 ac;
 
@@ -934,8 +936,8 @@ static void ath6kl_update_target_stats(struct ath6kl *ar, u8 *ptr, u32 len)
 	stats->wow_evt_discarded +=
 		le16_to_cpu(tgt_stats->wow_stats.wow_evt_discarded);
 
-	if (test_bit(STATS_UPDATE_PEND, &ar->flag)) {
-		clear_bit(STATS_UPDATE_PEND, &ar->flag);
+	if (test_bit(STATS_UPDATE_PEND, &vif->flags)) {
+		clear_bit(STATS_UPDATE_PEND, &vif->flags);
 		wake_up(&ar->event_wq);
 	}
 }
@@ -1201,9 +1203,9 @@ static int ath6kl_close(struct net_device *dev)
 
 static struct net_device_stats *ath6kl_get_stats(struct net_device *dev)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
+	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	return &ar->net_stats;
+	return &vif->net_stats;
 }
 
 static struct net_device_ops ath6kl_netdev_ops = {
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index ba1678e..cada197 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -357,8 +357,8 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 fail_tx:
 	dev_kfree_skb(skb);
 
-	ar->net_stats.tx_dropped++;
-	ar->net_stats.tx_aborted_errors++;
+	vif->net_stats.tx_dropped++;
+	vif->net_stats.tx_aborted_errors++;
 
 	return 0;
 }
@@ -583,7 +583,7 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 				/* a packet was flushed  */
 				flushing = true;
 
-			ar->net_stats.tx_errors++;
+			vif->net_stats.tx_errors++;
 
 			if (status != -ENOSPC)
 				ath6kl_err("tx error, status: 0x%x\n", status);
@@ -598,8 +598,8 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 				   eid, "OK");
 
 			flushing = false;
-			ar->net_stats.tx_packets++;
-			ar->net_stats.tx_bytes += skb->len;
+			vif->net_stats.tx_packets++;
+			vif->net_stats.tx_bytes += skb->len;
 		}
 
 		ath6kl_tx_clear_node_map(ar, eid, map_no);
@@ -1061,7 +1061,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		   packet->act_len, status);
 
 	if (status || !(skb->data + HTC_HDR_LENGTH)) {
-		ar->net_stats.rx_errors++;
+		vif->net_stats.rx_errors++;
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -1072,8 +1072,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	 */
 	spin_lock_bh(&ar->lock);
 
-	ar->net_stats.rx_packets++;
-	ar->net_stats.rx_bytes += packet->act_len;
+	vif->net_stats.rx_packets++;
+	vif->net_stats.rx_bytes += packet->act_len;
 
 	spin_unlock_bh(&ar->lock);
 
@@ -1111,8 +1111,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	    ((packet->act_len < min_hdr_len) ||
 	     (packet->act_len > WMI_MAX_AMSDU_RX_DATA_FRAME_LENGTH))) {
 		ath6kl_info("frame len is too short or too long\n");
-		ar->net_stats.rx_errors++;
-		ar->net_stats.rx_length_errors++;
+		vif->net_stats.rx_errors++;
+		vif->net_stats.rx_length_errors++;
 		dev_kfree_skb(skb);
 		return;
 	}
-- 
1.7.0.4

