Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57392 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbbCOOA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:59 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 6/7] wil6210: implement broadcast/multicast data
Date: Sun, 15 Mar 2015 16:00:23 +0200
Message-Id: <1426428024-4538-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150105_479720_BE302BFE)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dedicated vring for multicast frames; this vring allocated for
AP and PBSS (both P2P GO and client) configurations

For short frames, use MCS0; for long - MCS1

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  11 +-
 drivers/net/wireless/ath/wil6210/debugfs.c  |  18 ++-
 drivers/net/wireless/ath/wil6210/main.c     |  33 ++++++
 drivers/net/wireless/ath/wil6210/txrx.c     | 175 +++++++++++++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h  |   6 +
 5 files changed, 167 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c9f362c..8f7596f 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -783,8 +783,17 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	rc = wmi_pcp_start(wil, info->beacon_interval, wmi_nettype,
 			   channel->hw_value);
 	if (rc)
-		netif_carrier_off(ndev);
+		goto err_pcp_start;
 
+	rc = wil_bcast_init(wil);
+	if (rc)
+		goto err_bcast;
+
+	goto out; /* success */
+err_bcast:
+	wmi_pcp_stop(wil);
+err_pcp_start:
+	netif_carrier_off(ndev);
 out:
 	mutex_unlock(&wil->mutex);
 	return rc;
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a42cb89..bbc22d8 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -121,12 +121,18 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			seq_printf(s,
-				"\n%pM CID %d TID %d BACK([%d] %d TU A%s) [%3d|%3d] idle %s\n",
-				wil->sta[cid].addr, cid, tid,
-				txdata->agg_wsize, txdata->agg_timeout,
-				txdata->agg_amsdu ? "+" : "-",
-				used, avail, sidle);
+			if (cid < WIL6210_MAX_CID)
+				seq_printf(s,
+					   "\n%pM CID %d TID %d BACK([%u] %u TU A%s) [%3d|%3d] idle %s\n",
+					   wil->sta[cid].addr, cid, tid,
+					   txdata->agg_wsize,
+					   txdata->agg_timeout,
+					   txdata->agg_amsdu ? "+" : "-",
+					   used, avail, sidle);
+			else
+				seq_printf(s,
+					   "\nBroadcast [%3d|%3d] idle %s\n",
+					   used, avail, sidle);
 
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a5fd605..c2a2384 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -68,6 +68,7 @@ MODULE_PARM_DESC(mtu_max, " Max MTU value.");
 
 static uint rx_ring_order = WIL_RX_RING_SIZE_ORDER_DEFAULT;
 static uint tx_ring_order = WIL_TX_RING_SIZE_ORDER_DEFAULT;
+static uint bcast_ring_order = WIL_BCAST_RING_SIZE_ORDER_DEFAULT;
 
 static int ring_order_set(const char *val, const struct kernel_param *kp)
 {
@@ -216,6 +217,7 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
+		wil_bcast_fini(wil);
 		netif_tx_stop_all_queues(ndev);
 		netif_carrier_off(ndev);
 
@@ -360,6 +362,35 @@ static int wil_find_free_vring(struct wil6210_priv *wil)
 	return -EINVAL;
 }
 
+int wil_bcast_init(struct wil6210_priv *wil)
+{
+	int ri = wil->bcast_vring, rc;
+
+	if ((ri >= 0) && wil->vring_tx[ri].va)
+		return 0;
+
+	ri = wil_find_free_vring(wil);
+	if (ri < 0)
+		return ri;
+
+	rc = wil_vring_init_bcast(wil, ri, 1 << bcast_ring_order);
+	if (rc == 0)
+		wil->bcast_vring = ri;
+
+	return rc;
+}
+
+void wil_bcast_fini(struct wil6210_priv *wil)
+{
+	int ri = wil->bcast_vring;
+
+	if (ri < 0)
+		return;
+
+	wil->bcast_vring = -1;
+	wil_vring_fini_tx(wil, ri);
+}
+
 static void wil_connect_worker(struct work_struct *work)
 {
 	int rc;
@@ -407,6 +438,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	init_completion(&wil->wmi_call);
 
 	wil->pending_connect_cid = -1;
+	wil->bcast_vring = -1;
 	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
 	setup_timer(&wil->scan_timer, wil_scan_timer_fn, (ulong)wil);
 
@@ -656,6 +688,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
+	wil_bcast_fini(wil);
 
 	/* prevent NAPI from being scheduled */
 	bitmap_zero(wil->status, wil_status_last);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 2453470..1fe390f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -523,7 +523,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	struct wireless_dev *wdev = wil_to_wdev(wil);
 	unsigned int len = skb->len;
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
-	int cid = wil_rxdesc_cid(d);
+	int cid = wil_rxdesc_cid(d); /* always 0..7, no need to check */
 	struct ethhdr *eth = (void *)skb->data;
 	/* here looking for DA, not A1, thus Rxdesc's 'mcast' indication
 	 * is not suitable, need to look at data
@@ -749,6 +749,72 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	return rc;
 }
 
+int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
+{
+	int rc;
+	struct wmi_bcast_vring_cfg_cmd cmd = {
+		.action = cpu_to_le32(WMI_VRING_CMD_ADD),
+		.vring_cfg = {
+			.tx_sw_ring = {
+				.max_mpdu_size =
+					cpu_to_le16(wil_mtu2macbuf(mtu_max)),
+				.ring_size = cpu_to_le16(size),
+			},
+			.ringid = id,
+			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
+		},
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_vring_cfg_done_event cmd;
+	} __packed reply;
+	struct vring *vring = &wil->vring_tx[id];
+	struct vring_tx_data *txdata = &wil->vring_tx_data[id];
+
+	wil_dbg_misc(wil, "%s() max_mpdu_size %d\n", __func__,
+		     cmd.vring_cfg.tx_sw_ring.max_mpdu_size);
+
+	if (vring->va) {
+		wil_err(wil, "Tx ring [%d] already allocated\n", id);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	memset(txdata, 0, sizeof(*txdata));
+	spin_lock_init(&txdata->lock);
+	vring->size = size;
+	rc = wil_vring_alloc(wil, vring);
+	if (rc)
+		goto out;
+
+	wil->vring2cid_tid[id][0] = WIL6210_MAX_CID; /* CID */
+	wil->vring2cid_tid[id][1] = 0; /* TID */
+
+	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
+
+	rc = wmi_call(wil, WMI_BCAST_VRING_CFG_CMDID, &cmd, sizeof(cmd),
+		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		goto out_free;
+
+	if (reply.cmd.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "Tx config failed, status 0x%02x\n",
+			reply.cmd.status);
+		rc = -EINVAL;
+		goto out_free;
+	}
+	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
+
+	txdata->enabled = 1;
+
+	return 0;
+ out_free:
+	wil_vring_free(wil, vring, 1);
+ out:
+
+	return rc;
+}
+
 void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 {
 	struct vring *vring = &wil->vring_tx[id];
@@ -772,7 +838,7 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 	memset(txdata, 0, sizeof(*txdata));
 }
 
-static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
+static struct vring *wil_find_tx_ucast(struct wil6210_priv *wil,
 				       struct sk_buff *skb)
 {
 	int i;
@@ -805,15 +871,6 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	return NULL;
 }
 
-static void wil_set_da_for_vring(struct wil6210_priv *wil,
-				 struct sk_buff *skb, int vring_index)
-{
-	struct ethhdr *eth = (void *)skb->data;
-	int cid = wil->vring2cid_tid[vring_index][0];
-
-	memcpy(eth->h_dest, wil->sta[cid].addr, ETH_ALEN);
-}
-
 static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			struct sk_buff *skb);
 
@@ -834,6 +891,9 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 			continue;
 
 		cid = wil->vring2cid_tid[i][0];
+		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+			continue;
+
 		if (!wil->sta[cid].data_port_open &&
 		    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
 			break;
@@ -848,57 +908,17 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 	return NULL;
 }
 
-/*
- * Find 1-st vring and return it; set dest address for this vring in skb
- * duplicate skb and send it to other active vrings
- */
-static struct vring *wil_tx_bcast(struct wil6210_priv *wil,
-				  struct sk_buff *skb)
+static struct vring *wil_find_tx_bcast(struct wil6210_priv *wil,
+				       struct sk_buff *skb)
 {
-	struct vring *v, *v2;
-	struct sk_buff *skb2;
-	int i;
-	u8 cid;
-
-	/* find 1-st vring eligible for data */
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
-		v = &wil->vring_tx[i];
-		if (!v->va)
-			continue;
-
-		cid = wil->vring2cid_tid[i][0];
-		if (!wil->sta[cid].data_port_open)
-			continue;
-
-		goto found;
-	}
-
-	wil_dbg_txrx(wil, "Tx while no vrings active?\n");
-
-	return NULL;
-
-found:
-	wil_dbg_txrx(wil, "BCAST -> ring %d\n", i);
-	wil_set_da_for_vring(wil, skb, i);
-
-	/* find other active vrings and duplicate skb for each */
-	for (i++; i < WIL6210_MAX_TX_RINGS; i++) {
-		v2 = &wil->vring_tx[i];
-		if (!v2->va)
-			continue;
-		cid = wil->vring2cid_tid[i][0];
-		if (!wil->sta[cid].data_port_open)
-			continue;
+	struct vring *v;
+	int i = wil->bcast_vring;
 
-		skb2 = skb_copy(skb, GFP_ATOMIC);
-		if (skb2) {
-			wil_dbg_txrx(wil, "BCAST DUP -> ring %d\n", i);
-			wil_set_da_for_vring(wil, skb2, i);
-			wil_tx_vring(wil, v2, skb2);
-		} else {
-			wil_err(wil, "skb_copy failed\n");
-		}
-	}
+	if (i < 0)
+		return NULL;
+	v = &wil->vring_tx[i];
+	if (!v->va)
+		return NULL;
 
 	return v;
 }
@@ -995,6 +1015,8 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	uint i = swhead;
 	dma_addr_t pa;
 	int used;
+	bool mcast = (vring_index == wil->bcast_vring);
+	uint len = skb_headlen(skb);
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 
@@ -1020,7 +1042,17 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		return -EINVAL;
 	vring->ctx[i].mapped_as = wil_mapped_as_single;
 	/* 1-st segment */
-	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
+	wil_tx_desc_map(d, pa, len, vring_index);
+	if (unlikely(mcast)) {
+		d->mac.d[0] |= BIT(MAC_CFG_DESC_TX_0_MCS_EN_POS); /* MCS 0 */
+		if (unlikely(len > WIL_BCAST_MCS0_LIMIT)) {
+			/* set MCS 1 */
+			d->mac.d[0] |= (1 << MAC_CFG_DESC_TX_0_MCS_INDEX_POS);
+			/* packet mode 2 */
+			d->mac.d[1] |= BIT(MAC_CFG_DESC_TX_1_PKT_MODE_EN_POS) |
+				       (2 << MAC_CFG_DESC_TX_1_PKT_MODE_POS);
+		}
+	}
 	/* Process TCP/UDP checksum offloading */
 	if (unlikely(wil_tx_desc_offload_cksum_set(wil, d, skb))) {
 		wil_err(wil, "Tx[%2d] Failed to set cksum, drop packet\n",
@@ -1126,6 +1158,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct ethhdr *eth = (void *)skb->data;
+	bool bcast = is_multicast_ether_addr(eth->h_dest);
 	struct vring *vring;
 	static bool pr_once_fw;
 	int rc;
@@ -1153,10 +1186,8 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		/* in STA mode (ESS), all to same VRING */
 		vring = wil_find_tx_vring_sta(wil, skb);
 	} else { /* direct communication, find matching VRING */
-		if (is_unicast_ether_addr(eth->h_dest))
-			vring = wil_find_tx_vring(wil, skb);
-		else
-			vring = wil_tx_bcast(wil, skb);
+		vring = bcast ? wil_find_tx_bcast(wil, skb) :
+				wil_find_tx_ucast(wil, skb);
 	}
 	if (unlikely(!vring)) {
 		wil_dbg_txrx(wil, "No Tx VRING found for %pM\n", eth->h_dest);
@@ -1219,7 +1250,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	struct vring_tx_data *txdata = &wil->vring_tx_data[ringid];
 	int done = 0;
 	int cid = wil->vring2cid_tid[ringid][0];
-	struct wil_net_stats *stats = &wil->sta[cid].stats;
+	struct wil_net_stats *stats = NULL;
 	volatile struct vring_tx_desc *_d;
 	int used_before_complete;
 	int used_new;
@@ -1238,6 +1269,9 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 
 	used_before_complete = wil_vring_used_tx(vring);
 
+	if (cid < WIL6210_MAX_CID)
+		stats = &wil->sta[cid].stats;
+
 	while (!wil_vring_is_empty(vring)) {
 		int new_swtail;
 		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
@@ -1279,12 +1313,15 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			if (skb) {
 				if (likely(d->dma.error == 0)) {
 					ndev->stats.tx_packets++;
-					stats->tx_packets++;
 					ndev->stats.tx_bytes += skb->len;
-					stats->tx_bytes += skb->len;
+					if (stats) {
+						stats->tx_packets++;
+						stats->tx_bytes += skb->len;
+					}
 				} else {
 					ndev->stats.tx_errors++;
-					stats->tx_errors++;
+					if (stats)
+						stats->tx_errors++;
 				}
 				wil_consume_skb(skb, d->dma.error == 0);
 			}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a6b096e..4310972 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -50,6 +50,8 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL_TX_Q_LEN_DEFAULT		(4000)
 #define WIL_RX_RING_SIZE_ORDER_DEFAULT	(10)
 #define WIL_TX_RING_SIZE_ORDER_DEFAULT	(10)
+#define WIL_BCAST_RING_SIZE_ORDER_DEFAULT	(7)
+#define WIL_BCAST_MCS0_LIMIT		(1024) /* limit for MCS0 frame size */
 /* limit ring size in range [32..32k] */
 #define WIL_RING_SIZE_ORDER_MIN	(5)
 #define WIL_RING_SIZE_ORDER_MAX	(15)
@@ -595,6 +597,7 @@ struct wil6210_priv {
 	struct vring_tx_data vring_tx_data[WIL6210_MAX_TX_RINGS];
 	u8 vring2cid_tid[WIL6210_MAX_TX_RINGS][2]; /* [0] - CID, [1] - TID */
 	struct wil_sta_info sta[WIL6210_MAX_CID];
+	int bcast_vring;
 	/* scan */
 	struct cfg80211_scan_request *scan_request;
 
@@ -757,6 +760,9 @@ void wil_rx_fini(struct wil6210_priv *wil);
 int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		      int cid, int tid);
 void wil_vring_fini_tx(struct wil6210_priv *wil, int id);
+int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size);
+int wil_bcast_init(struct wil6210_priv *wil);
+void wil_bcast_fini(struct wil6210_priv *wil);
 
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int wil_tx_complete(struct wil6210_priv *wil, int ringid);
-- 
2.1.0

