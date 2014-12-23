Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:47:54 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 02/22] wil6210: simple ADDBA on originator (Tx) side
Date: Tue, 23 Dec 2014 09:47:04 +0200
Message-Id: <1419320844-23989-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084802_346858_D69F0122)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon Tx vring creation, initiate BACK establishment
with maximum possible window size.

When establishing secure connection, there is EAPOL data exchange
between connection itself and "data port open", where security
is done and non-EAPOL data may be transferred. It is better to
send EAPOL frames using normal ACK because of firmware considerations.

send ADDBA only is 2 conditions met:
- data port open for the corresponded STA
- vring created

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c       |  5 ++
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 91 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c       |  4 ++
 drivers/net/wireless/ath/wil6210/wil6210.h    | 15 +++++
 drivers/net/wireless/ath/wil6210/wmi.c        | 19 ++++++
 5 files changed, 134 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 9b402b9..42e1192 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -385,6 +385,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
 	mutex_init(&wil->back_rx_mutex);
+	mutex_init(&wil->back_tx_mutex);
 
 	init_completion(&wil->wmi_ready);
 	init_completion(&wil->wmi_call);
@@ -398,9 +399,11 @@ int wil_priv_init(struct wil6210_priv *wil)
 	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
 	INIT_WORK(&wil->fw_error_worker, wil_fw_error_worker);
 	INIT_WORK(&wil->back_rx_worker, wil_back_rx_worker);
+	INIT_WORK(&wil->back_tx_worker, wil_back_tx_worker);
 
 	INIT_LIST_HEAD(&wil->pending_wmi_ev);
 	INIT_LIST_HEAD(&wil->back_rx_pending);
+	INIT_LIST_HEAD(&wil->back_tx_pending);
 	spin_lock_init(&wil->wmi_ev_lock);
 	init_waitqueue_head(&wil->wq);
 
@@ -456,6 +459,8 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	wmi_event_flush(wil);
 	wil_back_rx_flush(wil);
 	cancel_work_sync(&wil->back_rx_worker);
+	wil_back_tx_flush(wil);
+	cancel_work_sync(&wil->back_tx_worker);
 	destroy_workqueue(wil->wq_service);
 	destroy_workqueue(wil->wmi_wq);
 }
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 8e6d25a..ce1206a 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -365,3 +365,94 @@ void wil_back_rx_worker(struct work_struct *work)
 		kfree(evt);
 	}
 }
+
+/* BACK - Tx (originator) side */
+static void wil_back_tx_handle(struct wil6210_priv *wil,
+			       struct wil_back_tx *req)
+{
+	struct vring_tx_data *txdata = &wil->vring_tx_data[req->ringid];
+	int rc;
+
+	if (txdata->addba_in_progress) {
+		wil_dbg_misc(wil, "ADDBA for vring[%d] already in progress\n",
+			     req->ringid);
+		return;
+	}
+	if (txdata->agg_wsize) {
+		wil_dbg_misc(wil,
+			     "ADDBA for vring[%d] already established wsize %d\n",
+			     req->ringid, txdata->agg_wsize);
+		return;
+	}
+	txdata->addba_in_progress = true;
+	rc = wmi_addba(wil, req->ringid, req->agg_wsize, req->agg_timeout);
+	if (rc)
+		txdata->addba_in_progress = false;
+}
+
+static struct list_head *next_back_tx(struct wil6210_priv *wil)
+{
+	struct list_head *ret = NULL;
+
+	mutex_lock(&wil->back_tx_mutex);
+
+	if (!list_empty(&wil->back_tx_pending)) {
+		ret = wil->back_tx_pending.next;
+		list_del(ret);
+	}
+
+	mutex_unlock(&wil->back_tx_mutex);
+
+	return ret;
+}
+
+void wil_back_tx_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						 back_tx_worker);
+	struct wil_back_tx *evt;
+	struct list_head *lh;
+
+	while ((lh = next_back_tx(wil)) != NULL) {
+		evt = list_entry(lh, struct wil_back_tx, list);
+
+		wil_back_tx_handle(wil, evt);
+		kfree(evt);
+	}
+}
+
+void wil_back_tx_flush(struct wil6210_priv *wil)
+{
+	struct wil_back_tx *evt, *t;
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	mutex_lock(&wil->back_tx_mutex);
+
+	list_for_each_entry_safe(evt, t, &wil->back_tx_pending, list) {
+		list_del(&evt->list);
+		kfree(evt);
+	}
+
+	mutex_unlock(&wil->back_tx_mutex);
+}
+
+int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid)
+{
+	struct wil_back_tx *req = kzalloc(sizeof(*req), GFP_KERNEL);
+
+	if (!req)
+		return -ENOMEM;
+
+	req->ringid = ringid;
+	req->agg_wsize = wil_agg_size(wil, 0);
+	req->agg_timeout = 0;
+
+	mutex_lock(&wil->back_tx_mutex);
+	list_add_tail(&req->list, &wil->back_tx_pending);
+	mutex_unlock(&wil->back_tx_mutex);
+
+	queue_work(wil->wq_service, &wil->back_tx_worker);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d926860..71eaeec 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -701,6 +701,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
 	txdata->enabled = 1;
+	if (wil->sta[cid].data_port_open)
+		wil_addba_tx_request(wil, id);
 
 	return 0;
  out_free:
@@ -713,6 +715,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 {
 	struct vring *vring = &wil->vring_tx[id];
+	struct vring_tx_data *txdata = &wil->vring_tx_data[id];
 
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
@@ -727,6 +730,7 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 		napi_synchronize(&wil->napi_tx);
 
 	wil_vring_free(wil, vring, 1);
+	memset(txdata, 0, sizeof(*txdata));
 }
 
 static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4a9a68e..9cd76da 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -314,6 +314,7 @@ struct vring_tx_data {
 	cycles_t idle, last_idle, begin;
 	u8 agg_wsize; /* agreed aggregation window, 0 - no agg */
 	u16 agg_timeout;
+	bool addba_in_progress; /* if set, agg_xxx is for request in progress */
 };
 
 enum { /* for wil6210_priv.status */
@@ -418,6 +419,14 @@ struct wil_back_rx {
 	u16 ba_seq_ctrl;
 };
 
+struct wil_back_tx {
+	struct list_head list;
+	/* request params, converted to CPU byte order - what we asked for */
+	u8 ringid;
+	u8 agg_wsize;
+	u16 agg_timeout;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	int n_msi;
@@ -470,6 +479,9 @@ struct wil6210_priv {
 	struct list_head back_rx_pending;
 	struct mutex back_rx_mutex; /* protect @back_rx_pending */
 	struct work_struct back_rx_worker;
+	struct list_head back_tx_pending;
+	struct mutex back_tx_mutex; /* protect @back_tx_pending */
+	struct work_struct back_tx_worker;
 	/* DMA related */
 	struct vring vring_rx;
 	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
@@ -601,6 +613,9 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
 void wil_back_rx_worker(struct work_struct *work);
 void wil_back_rx_flush(struct wil6210_priv *wil);
+int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid);
+void wil_back_tx_worker(struct work_struct *work);
+void wil_back_tx_flush(struct wil6210_priv *wil);
 
 void wil6210_clear_irq(struct wil6210_priv *wil);
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index e790c45..8a4f8b7 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -544,6 +544,22 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	}
 }
 
+static void wil_addba_tx_cid(struct wil6210_priv *wil, u8 cid)
+{
+	struct vring_tx_data *t;
+	int i;
+
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+		if (cid != wil->vring2cid_tid[i][0])
+			continue;
+		t = &wil->vring_tx_data[i];
+		if (!t->enabled)
+			continue;
+
+		wil_addba_tx_request(wil, i);
+	}
+}
+
 static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -558,6 +574,7 @@ static void wmi_evt_linkup(struct wil6210_priv *wil, int id, void *d, int len)
 	}
 
 	wil->sta[cid].data_port_open = true;
+	wil_addba_tx_cid(wil, cid);
 	netif_carrier_on(ndev);
 }
 
@@ -604,6 +621,7 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 
 	txdata->agg_timeout = le16_to_cpu(evt->ba_timeout);
 	txdata->agg_wsize = evt->agg_wsize;
+	txdata->addba_in_progress = false;
 }
 
 static void wmi_evt_addba_rx_req(struct wil6210_priv *wil, int id, void *d,
@@ -642,6 +660,7 @@ static void wmi_evt_delba(struct wil6210_priv *wil, int id, void *d, int len)
 				wil_dbg_wmi(wil, "DELBA Tx vring %d\n", i);
 				txdata->agg_timeout = 0;
 				txdata->agg_wsize = 0;
+				txdata->addba_in_progress = false;
 
 				break; /* max. 1 matching ring */
 			}
-- 
2.1.0

