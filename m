Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47377 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762570Ab2KBBqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 21:46:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add multi-queue support
Date: Thu,  1 Nov 2012 18:44:16 -0700
Message-Id: <1351820656-24461-1-git-send-email-bzhao@marvell.com> (sfid-20121102_024644_081344_D540935C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for multiple TX queues inside mwifiex
driver. Four different queues according to WMM access categories
are defined for each virtual interface. When a packet is
received from netdev for transmission, tx pending count for
particular queue is incremented and if tx pending count has
reached upper water-mark, this queue is stopped instead of
stopping all queues. Similarly when a packet is successfully
transmitted from device, tx pending count is decremented per
queue and if pending count falls below lower water-mark, queue
operations are again resumed. This ensures that not all
tranmission is blocked if traffic with particular TOS value
suddenly increases.

Also wake all queues after association/IBSS_join/uAP_BSS_start
to enable traffic on all queues.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c  |    8 ++--
 drivers/net/wireless/mwifiex/cfg80211.c  |    7 +--
 drivers/net/wireless/mwifiex/debugfs.c   |   10 +++-
 drivers/net/wireless/mwifiex/init.c      |   20 ++++++-
 drivers/net/wireless/mwifiex/join.c      |    6 +--
 drivers/net/wireless/mwifiex/main.c      |   85 +++++++++++------------------
 drivers/net/wireless/mwifiex/main.h      |    3 +-
 drivers/net/wireless/mwifiex/sta_event.c |    9 +--
 drivers/net/wireless/mwifiex/sta_ioctl.c |    6 +--
 drivers/net/wireless/mwifiex/txrx.c      |   28 ++++++----
 drivers/net/wireless/mwifiex/uap_event.c |    7 +++
 drivers/net/wireless/mwifiex/usb.c       |    2 +-
 drivers/net/wireless/mwifiex/wmm.c       |   12 ++--
 drivers/net/wireless/mwifiex/wmm.h       |    2 +
 14 files changed, 107 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 395f1bf..68d52cf 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -197,7 +197,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 				       ra_list_flags);
 		mwifiex_11n_form_amsdu_pkt(skb_aggr, skb_src, &pad);
 
-		mwifiex_write_data_complete(adapter, skb_src, 0);
+		mwifiex_write_data_complete(adapter, skb_src, 0, 0);
 
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
@@ -256,7 +256,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
-			mwifiex_write_data_complete(adapter, skb_aggr, -1);
+			mwifiex_write_data_complete(adapter, skb_aggr, 1, -1);
 			return -1;
 		}
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA &&
@@ -282,13 +282,13 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		dev_err(adapter->dev, "%s: host_to_card failed: %#x\n",
 			__func__, ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		mwifiex_write_data_complete(adapter, skb_aggr, ret);
+		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
 		return 0;
 	case -EINPROGRESS:
 		adapter->data_sent = false;
 		break;
 	case 0:
-		mwifiex_write_data_complete(adapter, skb_aggr, ret);
+		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fdb1eb8..e29505c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2080,8 +2080,8 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), name,
-			      ether_setup, 1);
+	dev = alloc_netdev_mqs(sizeof(struct mwifiex_private *), name,
+			       ether_setup, IEEE80211_NUM_ACS, 1);
 	if (!dev) {
 		wiphy_err(wiphy, "no memory available for netdevice\n");
 		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -2143,8 +2143,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	mwifiex_dev_debugfs_remove(priv);
 #endif
 
-	if (!netif_queue_stopped(priv->netdev))
-		netif_stop_queue(priv->netdev);
+	mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
 
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index a870b58..46e34aa 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -178,6 +178,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 		(struct mwifiex_private *) file->private_data;
 	struct net_device *netdev = priv->netdev;
 	struct netdev_hw_addr *ha;
+	struct netdev_queue *txq;
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page, fmt[64];
 	struct mwifiex_bss_info info;
@@ -229,8 +230,13 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	p += sprintf(p, "num_rx_pkts_err = %lu\n", priv->stats.rx_errors);
 	p += sprintf(p, "carrier %s\n", ((netif_carrier_ok(priv->netdev))
 					 ? "on" : "off"));
-	p += sprintf(p, "tx queue %s\n", ((netif_queue_stopped(priv->netdev))
-					  ? "stopped" : "started"));
+	p += sprintf(p, "tx queue");
+	for (i = 0; i < netdev->num_tx_queues; i++) {
+		txq = netdev_get_tx_queue(netdev, i);
+		p += sprintf(p, " %d:%s", i, netif_tx_queue_stopped(txq) ?
+			     "stopped" : "started");
+	}
+	p += sprintf(p, "\n");
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
 				      (unsigned long) p - page);
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 482faac..39f03ce 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -388,9 +388,17 @@ void mwifiex_wake_up_net_dev_queue(struct net_device *netdev,
 					struct mwifiex_adapter *adapter)
 {
 	unsigned long dev_queue_flags;
+	unsigned int i;
 
 	spin_lock_irqsave(&adapter->queue_lock, dev_queue_flags);
-	netif_tx_wake_all_queues(netdev);
+
+	for (i = 0; i < netdev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(netdev, i);
+
+		if (netif_tx_queue_stopped(txq))
+			netif_tx_wake_queue(txq);
+	}
+
 	spin_unlock_irqrestore(&adapter->queue_lock, dev_queue_flags);
 }
 
@@ -401,9 +409,17 @@ void mwifiex_stop_net_dev_queue(struct net_device *netdev,
 					struct mwifiex_adapter *adapter)
 {
 	unsigned long dev_queue_flags;
+	unsigned int i;
 
 	spin_lock_irqsave(&adapter->queue_lock, dev_queue_flags);
-	netif_tx_stop_all_queues(netdev);
+
+	for (i = 0; i < netdev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(netdev, i);
+
+		if (!netif_tx_queue_stopped(txq))
+			netif_tx_stop_queue(txq);
+	}
+
 	spin_unlock_irqrestore(&adapter->queue_lock, dev_queue_flags);
 }
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 7b0858a..88664ae 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -721,8 +721,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	if (!netif_carrier_ok(priv->netdev))
 		netif_carrier_on(priv->netdev);
-	if (netif_queue_stopped(priv->netdev))
-		netif_wake_queue(priv->netdev);
+	mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 
 	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->scan_block = true;
@@ -1238,8 +1237,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 	if (!netif_carrier_ok(priv->netdev))
 		netif_carrier_on(priv->netdev);
-	if (netif_queue_stopped(priv->netdev))
-		netif_wake_queue(priv->netdev);
+	mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 
 	mwifiex_save_curr_bcn(priv);
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 51a13f8..9c802ed 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -413,49 +413,6 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function fills a driver buffer.
- *
- * The function associates a given SKB with the provided driver buffer
- * and also updates some of the SKB parameters, including IP header,
- * priority and timestamp.
- */
-static void
-mwifiex_fill_buffer(struct sk_buff *skb)
-{
-	struct ethhdr *eth;
-	struct iphdr *iph;
-	struct timeval tv;
-	u8 tid = 0;
-
-	eth = (struct ethhdr *) skb->data;
-	switch (eth->h_proto) {
-	case __constant_htons(ETH_P_IP):
-		iph = ip_hdr(skb);
-		tid = IPTOS_PREC(iph->tos);
-		pr_debug("data: packet type ETH_P_IP: %04x, tid=%#x prio=%#x\n",
-			 eth->h_proto, tid, skb->priority);
-		break;
-	case __constant_htons(ETH_P_ARP):
-		pr_debug("data: ARP packet: %04x\n", eth->h_proto);
-	default:
-		break;
-	}
-/* Offset for TOS field in the IP header */
-#define IPTOS_OFFSET 5
-	tid = (tid >> IPTOS_OFFSET);
-	skb->priority = tid;
-	/* Record the current time the packet was queued; used to
-	   determine the amount of time the packet was queued in
-	   the driver before it was sent to the firmware.
-	   The delay is then sent along with the packet to the
-	   firmware for aggregate delay calculation for stats and
-	   MSDU lifetime expiry.
-	 */
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
-}
-
-/*
  * CFG802.11 network device handler for open.
  *
  * Starts the data queue.
@@ -489,17 +446,23 @@ mwifiex_close(struct net_device *dev)
  */
 int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 {
-	mwifiex_wmm_add_buf_txqueue(priv, skb);
+	struct netdev_queue *txq;
+	int index = mwifiex_1d_to_wmm_queue[skb->priority];
+
+	if (atomic_inc_return(&priv->wmm_tx_pending[index]) >= MAX_TX_PENDING) {
+		txq = netdev_get_tx_queue(priv->netdev, index);
+		if (!netif_tx_queue_stopped(txq)) {
+			netif_tx_stop_queue(txq);
+			dev_dbg(priv->adapter->dev, "stop queue: %d\n", index);
+		}
+	}
+
 	atomic_inc(&priv->adapter->tx_pending);
+	mwifiex_wmm_add_buf_txqueue(priv, skb);
 
 	if (priv->adapter->scan_delay_cnt)
 		atomic_set(&priv->adapter->is_tx_received, true);
 
-	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
-		mwifiex_set_trans_start(priv->netdev);
-		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
-	}
-
 	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 
 	return 0;
@@ -514,6 +477,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
+	struct timeval tv;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
 		jiffies, priv->bss_type, priv->bss_num);
@@ -551,7 +515,16 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
-	mwifiex_fill_buffer(skb);
+
+	/* Record the current time the packet was queued; used to
+	 * determine the amount of time the packet was queued in
+	 * the driver before it was sent to the firmware.
+	 * The delay is then sent along with the packet to the
+	 * firmware for aggregate delay calculation for stats and
+	 * MSDU lifetime expiry.
+	 */
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 
 	mwifiex_queue_tx_pkt(priv, skb);
 
@@ -631,6 +604,13 @@ static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
 	return &priv->stats;
 }
 
+static u16
+mwifiex_netdev_select_wmm_queue(struct net_device *dev, struct sk_buff *skb)
+{
+	skb->priority = cfg80211_classify8021d(skb);
+	return mwifiex_1d_to_wmm_queue[skb->priority];
+}
+
 /* Network device handlers */
 static const struct net_device_ops mwifiex_netdev_ops = {
 	.ndo_open = mwifiex_open,
@@ -640,6 +620,7 @@ static const struct net_device_ops mwifiex_netdev_ops = {
 	.ndo_tx_timeout = mwifiex_tx_timeout,
 	.ndo_get_stats = mwifiex_get_stats,
 	.ndo_set_rx_mode = mwifiex_set_multicast_list,
+	.ndo_select_queue = mwifiex_netdev_select_wmm_queue,
 };
 
 /*
@@ -839,9 +820,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
 		if (priv && priv->netdev) {
-			if (!netif_queue_stopped(priv->netdev))
-				mwifiex_stop_net_dev_queue(priv->netdev,
-							   adapter);
+			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 			if (netif_carrier_ok(priv->netdev))
 				netif_carrier_off(priv->netdev);
 		}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 68f3646..db57dd4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -440,6 +440,7 @@ struct mwifiex_private {
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;
 	struct mwifiex_wmm_desc wmm;
+	atomic_t wmm_tx_pending[IEEE80211_NUM_ACS];
 	struct list_head sta_list;
 	/* spin lock for associated station list */
 	spinlock_t sta_list_spinlock;
@@ -789,7 +790,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		       struct mwifiex_tx_param *tx_param);
 int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags);
 int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
-				struct sk_buff *skb, int status);
+				struct sk_buff *skb, int aggr, int status);
 void mwifiex_clean_txrx(struct mwifiex_private *priv);
 u8 mwifiex_check_last_packet_indication(struct mwifiex_private *priv);
 void mwifiex_check_ps_cond(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 8132119..5b0d719 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -124,8 +124,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	}
 	memset(priv->cfg_bssid, 0, ETH_ALEN);
 
-	if (!netif_queue_stopped(priv->netdev))
-		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+	mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
 }
@@ -197,8 +196,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: LINK_SENSED\n");
 		if (!netif_carrier_ok(priv->netdev))
 			netif_carrier_on(priv->netdev);
-		if (netif_queue_stopped(priv->netdev))
-			mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
+		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 
 	case EVENT_DEAUTHENTICATED:
@@ -306,8 +304,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: ADHOC_BCN_LOST\n");
 		priv->adhoc_is_link_sensed = false;
 		mwifiex_clean_txrx(priv);
-		if (!netif_queue_stopped(priv->netdev))
-			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 552d72e..c8b50c7 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -276,8 +276,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		dev_dbg(adapter->dev, "info: SSID found in scan list ... "
 				      "associating...\n");
 
-		if (!netif_queue_stopped(priv->netdev))
-			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
 
@@ -318,8 +317,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		ret = mwifiex_check_network_compatibility(priv, bss_desc);
 
-		if (!netif_queue_stopped(priv->netdev))
-			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 5cb3f7a..8c80024 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -121,13 +121,13 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
 			ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		mwifiex_write_data_complete(adapter, skb, ret);
+		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
 		adapter->data_sent = false;
 		break;
 	case 0:
-		mwifiex_write_data_complete(adapter, skb, ret);
+		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	default:
 		break;
@@ -144,11 +144,12 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
  * wakes up stalled traffic queue if required, and then frees the buffer.
  */
 int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
-				struct sk_buff *skb, int status)
+				struct sk_buff *skb, int aggr, int status)
 {
-	struct mwifiex_private *priv, *tpriv;
+	struct mwifiex_private *priv;
 	struct mwifiex_txinfo *tx_info;
-	int i;
+	struct netdev_queue *txq;
+	int index;
 
 	if (!skb)
 		return 0;
@@ -172,15 +173,20 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 
 	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT)
 		atomic_dec_return(&adapter->pending_bridged_pkts);
-	if (atomic_dec_return(&adapter->tx_pending) >= LOW_TX_PENDING)
+
+	if (aggr)
+		/* For skb_aggr, do not wake up tx queue */
 		goto done;
 
-	for (i = 0; i < adapter->priv_num; i++) {
-		tpriv = adapter->priv[i];
+	atomic_dec(&adapter->tx_pending);
 
-		if (tpriv->media_connected &&
-		    netif_queue_stopped(tpriv->netdev))
-			mwifiex_wake_up_net_dev_queue(tpriv->netdev, adapter);
+	index = mwifiex_1d_to_wmm_queue[skb->priority];
+	if (atomic_dec_return(&priv->wmm_tx_pending[index]) < LOW_TX_PENDING) {
+		txq = netdev_get_tx_queue(priv->netdev, index);
+		if (netif_tx_queue_stopped(txq)) {
+			netif_tx_wake_queue(txq);
+			dev_dbg(adapter->dev, "wake queue: %d\n", index);
+		}
 	}
 done:
 	dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index a33fa39..21c640d 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -235,11 +235,18 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_UAP_BSS_IDLE:
 		priv->media_connected = false;
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
+		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+
 		mwifiex_clean_txrx(priv);
 		mwifiex_del_all_sta_list(priv);
 		break;
 	case EVENT_UAP_BSS_ACTIVE:
 		priv->media_connected = true;
+		if (!netif_carrier_ok(priv->netdev))
+			netif_carrier_on(priv->netdev);
+		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
 		break;
 	case EVENT_UAP_BSS_START:
 		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 22a5916..bbe1f35 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -238,7 +238,7 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 	} else {
 		dev_dbg(adapter->dev, "%s: DATA\n", __func__);
 		atomic_dec(&card->tx_data_urb_pending);
-		mwifiex_write_data_complete(adapter, context->skb,
+		mwifiex_write_data_complete(adapter, context->skb, 0,
 					    urb->status ? -1 : 0);
 	}
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 600d819..818f871 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -483,7 +483,7 @@ mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
 	struct sk_buff *skb, *tmp;
 
 	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp)
-		mwifiex_write_data_complete(adapter, skb, -1);
+		mwifiex_write_data_complete(adapter, skb, 0, -1);
 }
 
 /*
@@ -650,7 +650,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 
 	if (!priv->media_connected && !mwifiex_is_skb_mgmt_frame(skb)) {
 		dev_dbg(adapter->dev, "data: drop packet in disconnect\n");
-		mwifiex_write_data_complete(adapter, skb, -1);
+		mwifiex_write_data_complete(adapter, skb, 0, -1);
 		return;
 	}
 
@@ -680,7 +680,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 
 	if (!ra_list) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		mwifiex_write_data_complete(adapter, skb, -1);
+		mwifiex_write_data_complete(adapter, skb, 0, -1);
 		return;
 	}
 
@@ -1090,7 +1090,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
-			mwifiex_write_data_complete(adapter, skb, -1);
+			mwifiex_write_data_complete(adapter, skb, 0, -1);
 			return;
 		}
 
@@ -1195,7 +1195,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
-			mwifiex_write_data_complete(adapter, skb, -1);
+			mwifiex_write_data_complete(adapter, skb, 0, -1);
 			return;
 		}
 
@@ -1209,7 +1209,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		adapter->data_sent = false;
 		dev_err(adapter->dev, "host_to_card failed: %#x\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
-		mwifiex_write_data_complete(adapter, skb, ret);
+		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
 		adapter->data_sent = false;
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index ec83995..b92f39d 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -31,6 +31,8 @@ enum ieee_types_wmm_ecw_bitmasks {
 	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
 };
 
+static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
+
 /*
  * This function retrieves the TID of the given RA list.
  */
-- 
1.7.0.2

