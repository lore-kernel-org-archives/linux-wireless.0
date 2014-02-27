Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47557 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaB0OV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:28 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 04/16] wil6210: multiple connect - initial support
Date: Thu, 27 Feb 2014 16:20:43 +0200
Message-ID: <1393510855-17566-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_154708_959807_301D613A)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable multiple (up to 8 - HW/FW limitation) simultaneous connections.
Each connection has its own CID (connection ID) that describes chip's
beam-forming entity. Tx Vring should refer to correct CID for frame to reach
its destination.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  8 +++--
 drivers/net/wireless/ath/wil6210/debugfs.c  | 45 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     | 24 ++++++++++++++-
 drivers/net/wireless/ath/wil6210/txrx.c     | 47 ++++++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h  | 22 +++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c      | 17 +++++++++--
 6 files changed, 148 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 204c7c8..fa713ef 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -110,15 +110,19 @@ static int wil_cfg80211_get_station(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
+
+	int cid = wil_find_cid(wil, mac);
 	struct wmi_notify_req_cmd cmd = {
-		.cid = 0,
+		.cid = cid,
 		.interval_usec = 0,
 	};
 
-	if (memcmp(mac, wil->dst_addr[0], ETH_ALEN))
+	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
+	if (cid < 0)
 		return -ENOENT;
 
 	/* WMI_NOTIFY_REQ_DONE_EVENTID handler fills wil->stats.bf_mcs */
+	/* TODO: keep stats per CID */
 	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
 		      WMI_NOTIFY_REQ_DONE_EVENTID, NULL, 0, 20);
 	if (rc)
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6fdab1a..f12aa0b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -71,8 +71,13 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		struct vring *vring = &(wil->vring_tx[i]);
 		if (vring->va) {
+			int cid = wil->vring2cid_tid[i][0];
+			int tid = wil->vring2cid_tid[i][1];
 			char name[10];
 			snprintf(name, sizeof(name), "tx_%2d", i);
+
+			seq_printf(s, "\n%pM CID %d TID %d\n",
+				   wil->sta[cid].addr, cid, tid);
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
 	}
@@ -592,6 +597,45 @@ static const struct file_operations fops_temp = {
 	.llseek		= seq_lseek,
 };
 
+/*---------Station matrix------------*/
+
+static int wil_sta_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		struct wil_sta_info *p = &wil->sta[i];
+		char *status = "unknown";
+		switch (p->status) {
+		case wil_sta_unused:
+			status = "unused   ";
+			break;
+		case wil_sta_conn_pending:
+			status = "pending  ";
+			break;
+		case wil_sta_connected:
+			status = "connected";
+			break;
+		}
+		seq_printf(s, "[%d] %pM %s\n", i, p->addr, status);
+	}
+
+	return 0;
+}
+
+static int wil_sta_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_sta_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_sta = {
+	.open		= wil_sta_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*----------------*/
 int wil6210_debugfs_init(struct wil6210_priv *wil)
 {
@@ -603,6 +647,7 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 
 	debugfs_create_file("mbox", S_IRUGO, dbg, wil, &fops_mbox);
 	debugfs_create_file("vrings", S_IRUGO, dbg, wil, &fops_vring);
+	debugfs_create_file("stations", S_IRUGO, dbg, wil, &fops_sta);
 	debugfs_create_file("desc", S_IRUGO, dbg, wil, &fops_txdesc);
 	debugfs_create_u32("desc_index", S_IRUGO | S_IWUSR, dbg,
 			   &dbg_txdesc_index);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index fd30cdd..f68481d 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -113,14 +113,20 @@ static void wil_connect_worker(struct work_struct *work)
 
 	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE, cid, 0);
 	wil->pending_connect_cid = -1;
-	if (rc == 0)
+	if (rc == 0) {
+		wil->sta[cid].status = wil_sta_connected;
 		wil_link_on(wil);
+	} else {
+		wil->sta[cid].status = wil_sta_unused;
+	}
 }
 
 int wil_priv_init(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	memset(wil->sta, 0, sizeof(wil->sta));
+
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
 
@@ -370,3 +376,19 @@ int wil_down(struct wil6210_priv *wil)
 
 	return rc;
 }
+
+int wil_find_cid(struct wil6210_priv *wil, const u8 *mac)
+{
+	int i;
+	int rc = -ENOENT;
+
+	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		if ((wil->sta[i].status != wil_sta_unused) &&
+		    (0 == memcmp(wil->sta[i].addr, mac, ETH_ALEN))) {
+			rc = i;
+			break;
+		}
+	}
+
+	return rc;
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 0b0975d..eb60023 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -613,6 +613,9 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	}
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
+	wil->vring2cid_tid[id][0] = cid;
+	wil->vring2cid_tid[id][1] = tid;
+
 	return 0;
  out_free:
 	wil_vring_free(wil, vring, 1);
@@ -634,10 +637,27 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 				       struct sk_buff *skb)
 {
-	struct vring *v = &wil->vring_tx[0];
+	int i;
+	struct ethhdr *eth = (void *)skb->data;
+	int cid = wil_find_cid(wil, eth->h_dest);
+
+	if (cid < 0)
+		return NULL;
 
-	if (v->va)
-		return v;
+	/* TODO: fix for multiple TID */
+	for (i = 0; i < ARRAY_SIZE(wil->vring2cid_tid); i++) {
+		if (wil->vring2cid_tid[i][0] == cid) {
+			struct vring *v = &wil->vring_tx[i];
+			wil_dbg_txrx(wil, "%s(%pM) -> [%d]\n",
+				     __func__, eth->h_dest, i);
+			if (v->va) {
+				return v;
+			} else {
+				wil_dbg_txrx(wil, "vring[%d] not valid\n", i);
+				return NULL;
+			}
+		}
+	}
 
 	return NULL;
 }
@@ -740,9 +760,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	}
 	_d = &(vring->va[i].tx);
 
-	/* FIXME FW can accept only unicast frames for the peer */
-	memcpy(skb->data, wil->dst_addr[vring_index], ETH_ALEN);
-
 	pa = dma_map_single(dev, skb->data,
 			skb_headlen(skb), DMA_TO_DEVICE);
 
@@ -836,6 +853,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	struct ethhdr *eth = (void *)skb->data;
 	struct vring *vring;
 	int rc;
 
@@ -854,9 +872,22 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 
 	/* find vring */
-	vring = wil_find_tx_vring(wil, skb);
+	if (is_unicast_ether_addr(eth->h_dest)) {
+		vring = wil_find_tx_vring(wil, skb);
+	} else {
+		int i = 0;
+		/* TODO: duplicate for all CID's */
+		vring = &wil->vring_tx[i];
+		if (vring->va) {
+			int cid = wil->vring2cid_tid[i][0];
+			/* FIXME FW can accept only unicast frames */
+			memcpy(skb->data, wil->sta[cid].addr, ETH_ALEN);
+		} else {
+			vring = NULL;
+		}
+	}
 	if (!vring) {
-		wil_err(wil, "No Tx VRING available\n");
+		wil_err(wil, "No Tx VRING found for %pM\n", eth->h_dest);
 		goto drop;
 	}
 	/* set up vring entry */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0d7fba4..38df203 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -226,6 +226,24 @@ struct wil6210_stats {
 	u16 peer_tx_sector;
 };
 
+enum wil_sta_status {
+	wil_sta_unused = 0,
+	wil_sta_conn_pending = 1,
+	wil_sta_connected = 2,
+};
+/**
+ * struct wil_sta_info - data for peer
+ *
+ * Peer identified by its CID (connection ID)
+ * NIC performs beam forming for each peer;
+ * if no beam forming done, frame exchange is not
+ * possible.
+ */
+struct wil_sta_info {
+	u8 addr[ETH_ALEN];
+	enum wil_sta_status status;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	int n_msi;
@@ -267,7 +285,8 @@ struct wil6210_priv {
 	/* DMA related */
 	struct vring vring_rx;
 	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
-	u8 dst_addr[WIL6210_MAX_TX_RINGS][ETH_ALEN];
+	u8 vring2cid_tid[WIL6210_MAX_TX_RINGS][2]; /* [0] - CID, [1] - TID */
+	struct wil_sta_info sta[WIL6210_MAX_CID];
 	/* scan */
 	struct cfg80211_scan_request *scan_request;
 
@@ -334,6 +353,7 @@ void wil_link_off(struct wil6210_priv *wil);
 int wil_up(struct wil6210_priv *wil);
 int wil_down(struct wil6210_priv *wil);
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r);
+int wil_find_cid(struct wil6210_priv *wil, const u8 *mac);
 
 void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr);
 void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d65da55..2d60290 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -384,6 +384,11 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 			evt->assoc_req_len, evt->assoc_resp_len);
 		return;
 	}
+	if (evt->cid >= WIL6210_MAX_CID) {
+		wil_err(wil, "Connect CID invalid : %d\n", evt->cid);
+		return;
+	}
+
 	ch = evt->channel + 1;
 	wil_dbg_wmi(wil, "Connect %pM channel [%d] cid %d\n",
 		    evt->bssid, ch, evt->cid);
@@ -439,7 +444,8 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 
 	/* FIXME FW can transmit only ucast frames to peer */
 	/* FIXME real ring_id instead of hard coded 0 */
-	memcpy(wil->dst_addr[0], evt->bssid, ETH_ALEN);
+	memcpy(wil->sta[evt->cid].addr, evt->bssid, ETH_ALEN);
+	wil->sta[evt->cid].status = wil_sta_conn_pending;
 
 	wil->pending_connect_cid = evt->cid;
 	queue_work(wil->wmi_wq_conn, &wil->connect_worker);
@@ -449,14 +455,19 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 			       void *d, int len)
 {
 	struct wmi_disconnect_event *evt = d;
+	int cid = wil_find_cid(wil, evt->bssid);
 
-	wil_dbg_wmi(wil, "Disconnect %pM reason %d proto %d wmi\n",
-		    evt->bssid,
+	wil_dbg_wmi(wil, "Disconnect %pM CID %d reason %d proto %d wmi\n",
+		    evt->bssid, cid,
 		    evt->protocol_reason_status, evt->disconnect_reason);
 
 	wil->sinfo_gen++;
 
+	/* TODO: fix for multiple connections */
+
 	wil6210_disconnect(wil, evt->bssid);
+	if (cid >= 0)
+		wil->sta[cid].status = wil_sta_unused;
 }
 
 static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
-- 
1.8.3.2

