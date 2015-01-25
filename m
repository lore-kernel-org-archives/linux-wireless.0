Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbbAYIxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:39 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 09/10] wil6210: probe_client
Date: Sun, 25 Jan 2015 10:52:50 +0200
Message-Id: <1422175971-8075-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095346_551600_9AA77658)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Access point require this API to check peer alive status.
Assume peer is alive when it is connected, because
firmware implements keep alive checks and will disconnect
peer if it is not alive.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 91 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     |  5 ++
 drivers/net/wireless/ath/wil6210/wil6210.h  | 12 ++++
 3 files changed, 108 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index f65da91..e758f43 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -808,6 +808,96 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 	return 0;
 }
 
+/* probe_client handling */
+static void wil_probe_client_handle(struct wil6210_priv *wil,
+				    struct wil_probe_client_req *req)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wil_sta_info *sta = &wil->sta[req->cid];
+	/* assume STA is alive if it is still connected,
+	 * else FW will disconnect it
+	 */
+	bool alive = (sta->status == wil_sta_connected);
+
+	cfg80211_probe_status(ndev, sta->addr, req->cookie, alive, GFP_KERNEL);
+}
+
+static struct list_head *next_probe_client(struct wil6210_priv *wil)
+{
+	struct list_head *ret = NULL;
+
+	mutex_lock(&wil->probe_client_mutex);
+
+	if (!list_empty(&wil->probe_client_pending)) {
+		ret = wil->probe_client_pending.next;
+		list_del(ret);
+	}
+
+	mutex_unlock(&wil->probe_client_mutex);
+
+	return ret;
+}
+
+void wil_probe_client_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						probe_client_worker);
+	struct wil_probe_client_req *req;
+	struct list_head *lh;
+
+	while ((lh = next_probe_client(wil)) != NULL) {
+		req = list_entry(lh, struct wil_probe_client_req, list);
+
+		wil_probe_client_handle(wil, req);
+		kfree(req);
+	}
+}
+
+void wil_probe_client_flush(struct wil6210_priv *wil)
+{
+	struct wil_probe_client_req *req, *t;
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	mutex_lock(&wil->probe_client_mutex);
+
+	list_for_each_entry_safe(req, t, &wil->probe_client_pending, list) {
+		list_del(&req->list);
+		kfree(req);
+	}
+
+	mutex_unlock(&wil->probe_client_mutex);
+}
+
+static int wil_cfg80211_probe_client(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     const u8 *peer, u64 *cookie)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	struct wil_probe_client_req *req;
+	int cid = wil_find_cid(wil, peer);
+
+	wil_dbg_misc(wil, "%s(%pM => CID %d)\n", __func__, peer, cid);
+
+	if (cid < 0)
+		return -ENOLINK;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->cid = cid;
+	req->cookie = cid;
+
+	mutex_lock(&wil->probe_client_mutex);
+	list_add_tail(&req->list, &wil->probe_client_pending);
+	mutex_unlock(&wil->probe_client_mutex);
+
+	*cookie = req->cookie;
+	queue_work(wil->wq_service, &wil->probe_client_worker);
+	return 0;
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
 	.scan = wil_cfg80211_scan,
 	.connect = wil_cfg80211_connect,
@@ -827,6 +917,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.start_ap = wil_cfg80211_start_ap,
 	.stop_ap = wil_cfg80211_stop_ap,
 	.del_station = wil_cfg80211_del_station,
+	.probe_client = wil_cfg80211_probe_client,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d259416..b04e0af 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -405,6 +405,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	mutex_init(&wil->wmi_mutex);
 	mutex_init(&wil->back_rx_mutex);
 	mutex_init(&wil->back_tx_mutex);
+	mutex_init(&wil->probe_client_mutex);
 
 	init_completion(&wil->wmi_ready);
 	init_completion(&wil->wmi_call);
@@ -419,10 +420,12 @@ int wil_priv_init(struct wil6210_priv *wil)
 	INIT_WORK(&wil->fw_error_worker, wil_fw_error_worker);
 	INIT_WORK(&wil->back_rx_worker, wil_back_rx_worker);
 	INIT_WORK(&wil->back_tx_worker, wil_back_tx_worker);
+	INIT_WORK(&wil->probe_client_worker, wil_probe_client_worker);
 
 	INIT_LIST_HEAD(&wil->pending_wmi_ev);
 	INIT_LIST_HEAD(&wil->back_rx_pending);
 	INIT_LIST_HEAD(&wil->back_tx_pending);
+	INIT_LIST_HEAD(&wil->probe_client_pending);
 	spin_lock_init(&wil->wmi_ev_lock);
 	init_waitqueue_head(&wil->wq);
 
@@ -485,6 +488,8 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	cancel_work_sync(&wil->back_rx_worker);
 	wil_back_tx_flush(wil);
 	cancel_work_sync(&wil->back_tx_worker);
+	wil_probe_client_flush(wil);
+	cancel_work_sync(&wil->probe_client_worker);
 	destroy_workqueue(wil->wq_service);
 	destroy_workqueue(wil->wmi_wq);
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3575b5d..90dc24f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -504,6 +504,12 @@ struct wil_back_tx {
 	u16 agg_timeout;
 };
 
+struct wil_probe_client_req {
+	struct list_head list;
+	u64 cookie;
+	u8 cid;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	int n_msi;
@@ -564,6 +570,10 @@ struct wil6210_priv {
 	struct list_head back_tx_pending;
 	struct mutex back_tx_mutex; /* protect @back_tx_pending */
 	struct work_struct back_tx_worker;
+	/* keep alive */
+	struct list_head probe_client_pending;
+	struct mutex probe_client_mutex; /* protect @probe_client_pending */
+	struct work_struct probe_client_worker;
 	/* DMA related */
 	struct vring vring_rx;
 	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
@@ -722,6 +732,8 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan);
 int wmi_pcp_stop(struct wil6210_priv *wil);
 void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid,
 			u16 reason_code, bool from_event);
+void wil_probe_client_flush(struct wil6210_priv *wil);
+void wil_probe_client_worker(struct work_struct *work);
 
 int wil_rx_init(struct wil6210_priv *wil, u16 size);
 void wil_rx_fini(struct wil6210_priv *wil);
-- 
2.1.0

