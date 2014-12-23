Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaLWHrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:47:52 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 01/22] wil6210: ADDBA/DELBA flows
Date: Tue, 23 Dec 2014 09:47:03 +0200
Message-Id: <1419320844-23989-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084801_748249_9D8F5E81)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce BACK establishment procedures; decision logic is not implemented
yet; debugfs entry 'addba' used to manually trigger addba/delba for ringid 0.

debugfs usage:
to establish BACK with agg_wsize 16:
  echo 16 > /sys/kernel/debug/ieee80211/phy0/wil6210/addba
to delete BACK:
  echo 0 > /sys/kernel/debug/ieee80211/phy0/wil6210/addba
to change agg_wsize, one need to delete BACK and establish it anew

ADDBA flow for:

- originator

Tx side (initiator) sends WMI_VRING_BA_EN_CMDID providing
agg_wsize and timeout parameters.
Eventually, it gets event confirming BACK agreement - WMI_BA_STATUS_EVENTID
with negotiated parameters. On this event, update Tx vring data
(struct vring_tx_data) and display BACK parameters on debugfs

- recipient

Rx side (recipient) firmware informs driver about ADDBA with
WMI_RCP_ADDBA_REQ_EVENTID, driver process it in service work
queue wq_service. It adjusts parameters and sends response
with WMI_RCP_ADDBA_RESP_CMDID, and final confirmation provided
by firmware with WMI_ADDBA_RESP_SENT_EVENTID. In case of success,
driver updates Rx BACK reorder buffer.

policy for BACK parameters:
- aggregation size (agg_wsize * MPDUsize)) to not exceed 64Kbytes

DELBA flow for:

- originator

driver decides to terminate BACK, it sends WMI_VRING_BA_DIS_CMDID
and updates struct vring_tx_data associated with vring; ignore
WMI_DELBA_EVENTID.

- recipient

firmware informs driver with WMI_DELBA_EVENTID,
driver deletes correspondent reorder buffer

ADDBA request processing requires sending WMI command, therefore
it is processed in work queue context. Same work queue used as for
connect, it get renamed to wq_service

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  53 ++++++++-
 drivers/net/wireless/ath/wil6210/main.c       |  24 ++--
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 146 +++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c       |   2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h    |  36 +++++-
 drivers/net/wireless/ath/wil6210/wmi.c        | 159 +++++++++++++++++++++-----
 6 files changed, 376 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4e6e145..18f5b67 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -110,9 +110,11 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			seq_printf(s, "\n%pM CID %d TID %d [%3d|%3d] idle %3d%%\n",
-				   wil->sta[cid].addr, cid, tid, used, avail,
-				   (int)idle);
+			seq_printf(s,
+				   "\n%pM CID %d TID %d BACK([%d] %d TU) [%3d|%3d] idle %3d%%\n",
+				   wil->sta[cid].addr, cid, tid,
+				   txdata->agg_wsize, txdata->agg_timeout,
+				   used, avail, (int)idle);
 
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
@@ -558,6 +560,50 @@ static const struct file_operations fops_rxon = {
 	.open  = simple_open,
 };
 
+/* block ack for vring 0
+ * write 0 to it to trigger DELBA
+ * write positive agg_wsize to trigger ADDBA
+ */
+static ssize_t wil_write_addba(struct file *file, const char __user *buf,
+			       size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	int rc;
+	uint agg_wsize;
+	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
+
+	if (!kbuf)
+		return -ENOMEM;
+
+	rc = simple_write_to_buffer(kbuf, len, ppos, buf, len);
+	if (rc != len) {
+		kfree(kbuf);
+		return rc >= 0 ? -EIO : rc;
+	}
+
+	kbuf[len] = '\0';
+	rc = kstrtouint(kbuf, 0, &agg_wsize);
+	kfree(kbuf);
+
+	if (rc)
+		return rc;
+
+	if (!wil->vring_tx[0].va)
+		return -EINVAL;
+
+	if (agg_wsize > 0)
+		wmi_addba(wil, 0, agg_wsize, 0);
+	else
+		wmi_delba(wil, 0, 0);
+
+	return len;
+}
+
+static const struct file_operations fops_addba = {
+	.write = wil_write_addba,
+	.open  = simple_open,
+};
+
 /*---tx_mgmt---*/
 /* Write mgmt frame to this file to send it */
 static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
@@ -1217,6 +1263,7 @@ static const struct {
 	{"rxon",		  S_IWUSR,	&fops_rxon},
 	{"tx_mgmt",		  S_IWUSR,	&fops_txmgmt},
 	{"wmi_send",		  S_IWUSR,	&fops_wmi},
+	{"addba",		  S_IWUSR,	&fops_addba},
 	{"temp",	S_IRUGO,		&fops_temp},
 	{"freq",	S_IRUGO,		&fops_freq},
 	{"link",	S_IRUGO,		&fops_link},
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8ff3fe3..9b402b9 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -384,6 +384,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
+	mutex_init(&wil->back_rx_mutex);
 
 	init_completion(&wil->wmi_ready);
 	init_completion(&wil->wmi_call);
@@ -396,25 +397,30 @@ int wil_priv_init(struct wil6210_priv *wil)
 	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
 	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
 	INIT_WORK(&wil->fw_error_worker, wil_fw_error_worker);
+	INIT_WORK(&wil->back_rx_worker, wil_back_rx_worker);
 
 	INIT_LIST_HEAD(&wil->pending_wmi_ev);
+	INIT_LIST_HEAD(&wil->back_rx_pending);
 	spin_lock_init(&wil->wmi_ev_lock);
 	init_waitqueue_head(&wil->wq);
 
-	wil->wmi_wq = create_singlethread_workqueue(WIL_NAME"_wmi");
+	wil->wmi_wq = create_singlethread_workqueue(WIL_NAME "_wmi");
 	if (!wil->wmi_wq)
 		return -EAGAIN;
 
-	wil->wmi_wq_conn = create_singlethread_workqueue(WIL_NAME"_connect");
-	if (!wil->wmi_wq_conn) {
-		destroy_workqueue(wil->wmi_wq);
-		return -EAGAIN;
-	}
+	wil->wq_service = create_singlethread_workqueue(WIL_NAME "_service");
+	if (!wil->wq_service)
+		goto out_wmi_wq;
 
 	wil->last_fw_recovery = jiffies;
 	wil->itr_trsh = itr_trsh;
 
 	return 0;
+
+out_wmi_wq:
+	destroy_workqueue(wil->wmi_wq);
+
+	return -EAGAIN;
 }
 
 /**
@@ -448,7 +454,9 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	mutex_unlock(&wil->mutex);
 	wmi_event_flush(wil);
-	destroy_workqueue(wil->wmi_wq_conn);
+	wil_back_rx_flush(wil);
+	cancel_work_sync(&wil->back_rx_worker);
+	destroy_workqueue(wil->wq_service);
 	destroy_workqueue(wil->wmi_wq);
 }
 
@@ -649,7 +657,7 @@ int wil_reset(struct wil6210_priv *wil)
 
 	wmi_event_flush(wil);
 
-	flush_workqueue(wil->wmi_wq_conn);
+	flush_workqueue(wil->wq_service);
 	flush_workqueue(wil->wmi_wq);
 
 	rc = wil_target_reset(wil);
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 489cb73..8e6d25a 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -219,3 +219,149 @@ void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
 	kfree(r->reorder_time);
 	kfree(r);
 }
+
+/* ADDBA processing */
+static u16 wil_agg_size(struct wil6210_priv *wil, u16 req_agg_wsize)
+{
+	u16 max_agg_size = min_t(u16, WIL_MAX_AGG_WSIZE, WIL_MAX_AMPDU_SIZE /
+				 (mtu_max + WIL_MAX_MPDU_OVERHEAD));
+
+	if (!req_agg_wsize)
+		return max_agg_size;
+
+	return min(max_agg_size, req_agg_wsize);
+}
+
+/* Block Ack - Rx side (recipient */
+int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
+			 u8 dialog_token, __le16 ba_param_set,
+			 __le16 ba_timeout, __le16 ba_seq_ctrl)
+{
+	struct wil_back_rx *req = kzalloc(sizeof(*req), GFP_KERNEL);
+
+	if (!req)
+		return -ENOMEM;
+
+	req->cidxtid = cidxtid;
+	req->dialog_token = dialog_token;
+	req->ba_param_set = le16_to_cpu(ba_param_set);
+	req->ba_timeout = le16_to_cpu(ba_timeout);
+	req->ba_seq_ctrl = le16_to_cpu(ba_seq_ctrl);
+
+	mutex_lock(&wil->back_rx_mutex);
+	list_add_tail(&req->list, &wil->back_rx_pending);
+	mutex_unlock(&wil->back_rx_mutex);
+
+	queue_work(wil->wq_service, &wil->back_rx_worker);
+
+	return 0;
+}
+
+static void wil_back_rx_handle(struct wil6210_priv *wil,
+			       struct wil_back_rx *req)
+{
+	struct wil_sta_info *sta;
+	u8 cid, tid;
+	u16 agg_wsize = 0;
+	/* bit 0: A-MSDU supported
+	 * bit 1: policy (should be 0 for us)
+	 * bits 2..5: TID
+	 * bits 6..15: buffer size
+	 */
+	u16 req_agg_wsize = WIL_GET_BITS(req->ba_param_set, 6, 15);
+	bool agg_amsdu = !!(req->ba_param_set & BIT(0));
+	int ba_policy = req->ba_param_set & BIT(1);
+	u16 agg_timeout = req->ba_timeout;
+	u16 status = WLAN_STATUS_SUCCESS;
+	unsigned long flags;
+	int rc;
+
+	parse_cidxtid(req->cidxtid, &cid, &tid);
+
+	/* sanity checks */
+	if (cid >= WIL6210_MAX_CID) {
+		wil_err(wil, "BACK: invalid CID %d\n", cid);
+		return;
+	}
+
+	sta = &wil->sta[cid];
+	if (sta->status != wil_sta_connected) {
+		wil_err(wil, "BACK: CID %d not connected\n", cid);
+		return;
+	}
+
+	wil_dbg_wmi(wil,
+		    "ADDBA request for CID %d %pM TID %d size %d timeout %d AMSDU%s policy %d token %d\n",
+		    cid, sta->addr, tid, req_agg_wsize, req->ba_timeout,
+		    agg_amsdu ? "+" : "-", !!ba_policy, req->dialog_token);
+
+	/* apply policies */
+	if (ba_policy) {
+		wil_err(wil, "BACK requested unsupported ba_policy == 1\n");
+		status = WLAN_STATUS_INVALID_QOS_PARAM;
+	}
+	if (status == WLAN_STATUS_SUCCESS)
+		agg_wsize = wil_agg_size(wil, req_agg_wsize);
+
+	rc = wmi_addba_rx_resp(wil, cid, tid, req->dialog_token, status,
+			       agg_amsdu, agg_wsize, agg_timeout);
+	if (rc || (status != WLAN_STATUS_SUCCESS))
+		return;
+
+	/* apply */
+	spin_lock_irqsave(&sta->tid_rx_lock, flags);
+
+	wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
+	sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize,
+						  req->ba_seq_ctrl >> 4);
+
+	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+}
+
+void wil_back_rx_flush(struct wil6210_priv *wil)
+{
+	struct wil_back_rx *evt, *t;
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	mutex_lock(&wil->back_rx_mutex);
+
+	list_for_each_entry_safe(evt, t, &wil->back_rx_pending, list) {
+		list_del(&evt->list);
+		kfree(evt);
+	}
+
+	mutex_unlock(&wil->back_rx_mutex);
+}
+
+/* Retrieve next ADDBA request from the pending list */
+static struct list_head *next_back_rx(struct wil6210_priv *wil)
+{
+	struct list_head *ret = NULL;
+
+	mutex_lock(&wil->back_rx_mutex);
+
+	if (!list_empty(&wil->back_rx_pending)) {
+		ret = wil->back_rx_pending.next;
+		list_del(ret);
+	}
+
+	mutex_unlock(&wil->back_rx_mutex);
+
+	return ret;
+}
+
+void wil_back_rx_worker(struct work_struct *work)
+{
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						back_rx_worker);
+	struct wil_back_rx *evt;
+	struct list_head *lh;
+
+	while ((lh = next_back_rx(wil)) != NULL) {
+		evt = list_entry(lh, struct wil_back_rx, list);
+
+		wil_back_rx_handle(wil, evt);
+		kfree(evt);
+	}
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e3f8bdc..d926860 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -653,7 +653,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 			.encap_trans_type = WMI_VRING_ENC_TYPE_802_3,
 			.mac_ctrl = 0,
 			.to_resolution = 0,
-			.agg_max_wsize = 16,
+			.agg_max_wsize = 0,
 			.schd_params = {
 				.priority = cpu_to_le16(0),
 				.timeslot_us = cpu_to_le16(0xfff),
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c6ec5b9..4a9a68e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -57,6 +57,15 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
+#define WIL_MAX_AMPDU_SIZE	(64 * 1024) /* FW/HW limit */
+#define WIL_MAX_AGG_WSIZE	(32) /* FW/HW limit */
+/* Hardware offload block adds the following:
+ * 26 bytes - 3-address QoS data header
+ *  8 bytes - SNAP
+ *  4 bytes - CRC
+ * 24 bytes - security related (if connection is secure)
+ */
+#define WIL_MAX_MPDU_OVERHEAD	(62)
 /* Max supported by wil6210 value for interrupt threshold is 5sec. */
 #define WIL6210_ITR_TRSH_MAX (5000000)
 #define WIL6210_ITR_TRSH_DEFAULT	(300) /* usec */
@@ -303,6 +312,8 @@ struct vring {
 struct vring_tx_data {
 	int enabled;
 	cycles_t idle, last_idle, begin;
+	u8 agg_wsize; /* agreed aggregation window, 0 - no agg */
+	u16 agg_timeout;
 };
 
 enum { /* for wil6210_priv.status */
@@ -397,6 +408,16 @@ enum {
 	fw_recovery_running = 2,
 };
 
+struct wil_back_rx {
+	struct list_head list;
+	/* request params, converted to CPU byte order - what we asked for */
+	u8 cidxtid;
+	u8 dialog_token;
+	u16 ba_param_set;
+	u16 ba_timeout;
+	u16 ba_seq_ctrl;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	int n_msi;
@@ -429,7 +450,7 @@ struct wil6210_priv {
 	u16 reply_size;
 	struct workqueue_struct *wmi_wq; /* for deferred calls */
 	struct work_struct wmi_event_worker;
-	struct workqueue_struct *wmi_wq_conn; /* for connect worker */
+	struct workqueue_struct *wq_service;
 	struct work_struct connect_worker;
 	struct work_struct disconnect_worker;
 	struct work_struct fw_error_worker;	/* for FW error recovery */
@@ -445,6 +466,10 @@ struct wil6210_priv {
 	spinlock_t wmi_ev_lock;
 	struct napi_struct napi_rx;
 	struct napi_struct napi_tx;
+	/* BACK */
+	struct list_head back_rx_pending;
+	struct mutex back_rx_mutex; /* protect @back_rx_pending */
+	struct work_struct back_rx_worker;
 	/* DMA related */
 	struct vring vring_rx;
 	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
@@ -567,6 +592,15 @@ int wmi_p2p_cfg(struct wil6210_priv *wil, int channel);
 int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason);
+int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout);
+int wmi_delba(struct wil6210_priv *wil, u8 ringid, u16 reason);
+int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
+		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout);
+int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
+			 u8 dialog_token, __le16 ba_param_set,
+			 __le16 ba_timeout, __le16 ba_seq_ctrl);
+void wil_back_rx_worker(struct work_struct *work);
+void wil_back_rx_flush(struct wil6210_priv *wil);
 
 void wil6210_clear_irq(struct wil6210_priv *wil);
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 63476c8..e790c45 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -471,7 +471,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 	wil->sta[evt->cid].status = wil_sta_conn_pending;
 
 	wil->pending_connect_cid = evt->cid;
-	queue_work(wil->wmi_wq_conn, &wil->connect_worker);
+	queue_work(wil->wq_service, &wil->connect_worker);
 }
 
 static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
@@ -583,10 +583,7 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 			      int len)
 {
 	struct wmi_vring_ba_status_event *evt = d;
-	struct wil_sta_info *sta;
-	uint i, cid;
-
-	/* TODO: use Rx BA status, not Tx one */
+	struct vring_tx_data *txdata;
 
 	wil_dbg_wmi(wil, "BACK[%d] %s {%d} timeout %d\n",
 		    evt->ringid,
@@ -598,40 +595,71 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 		return;
 	}
 
-	mutex_lock(&wil->mutex);
-
-	cid = wil->vring2cid_tid[evt->ringid][0];
-	if (cid >= WIL6210_MAX_CID) {
-		wil_err(wil, "invalid CID %d for vring %d\n", cid, evt->ringid);
-		goto out;
+	if (evt->status != WMI_BA_AGREED) {
+		evt->ba_timeout = 0;
+		evt->agg_wsize = 0;
 	}
 
-	sta = &wil->sta[cid];
-	if (sta->status == wil_sta_unused) {
-		wil_err(wil, "CID %d unused\n", cid);
-		goto out;
-	}
-
-	wil_dbg_wmi(wil, "BACK for CID %d %pM\n", cid, sta->addr);
-	for (i = 0; i < WIL_STA_TID_NUM; i++) {
-		struct wil_tid_ampdu_rx *r;
-		unsigned long flags;
+	txdata = &wil->vring_tx_data[evt->ringid];
 
-		spin_lock_irqsave(&sta->tid_rx_lock, flags);
+	txdata->agg_timeout = le16_to_cpu(evt->ba_timeout);
+	txdata->agg_wsize = evt->agg_wsize;
+}
 
-		r = sta->tid_rx[i];
-		sta->tid_rx[i] = NULL;
-		wil_tid_ampdu_rx_free(wil, r);
+static void wmi_evt_addba_rx_req(struct wil6210_priv *wil, int id, void *d,
+				 int len)
+{
+	struct wmi_rcp_addba_req_event *evt = d;
 
-		spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+	wil_addba_rx_request(wil, evt->cidxtid, evt->dialog_token,
+			     evt->ba_param_set, evt->ba_timeout,
+			     evt->ba_seq_ctrl);
+}
 
-		if ((evt->status == WMI_BA_AGREED) && evt->agg_wsize)
-			sta->tid_rx[i] = wil_tid_ampdu_rx_alloc(wil,
-						evt->agg_wsize, 0);
+static void wmi_evt_delba(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct wmi_delba_event *evt = d;
+	u8 cid, tid;
+	u16 reason = __le16_to_cpu(evt->reason);
+	struct wil_sta_info *sta;
+	struct wil_tid_ampdu_rx *r;
+	unsigned long flags;
+
+	parse_cidxtid(evt->cidxtid, &cid, &tid);
+	wil_dbg_wmi(wil, "DELBA CID %d TID %d from %s reason %d\n",
+		    cid, tid,
+		    evt->from_initiator ? "originator" : "recipient",
+		    reason);
+	if (!evt->from_initiator) {
+		int i;
+		/* find Tx vring it belongs to */
+		for (i = 0; i < ARRAY_SIZE(wil->vring2cid_tid); i++) {
+			if ((wil->vring2cid_tid[i][0] == cid) &&
+			    (wil->vring2cid_tid[i][1] == tid)) {
+				struct vring_tx_data *txdata =
+					&wil->vring_tx_data[i];
+
+				wil_dbg_wmi(wil, "DELBA Tx vring %d\n", i);
+				txdata->agg_timeout = 0;
+				txdata->agg_wsize = 0;
+
+				break; /* max. 1 matching ring */
+			}
+		}
+		if (i >= ARRAY_SIZE(wil->vring2cid_tid))
+			wil_err(wil, "DELBA: unable to find Tx vring\n");
+		return;
 	}
 
-out:
-	mutex_unlock(&wil->mutex);
+	sta = &wil->sta[cid];
+
+	spin_lock_irqsave(&sta->tid_rx_lock, flags);
+
+	r = sta->tid_rx[tid];
+	sta->tid_rx[tid] = NULL;
+	wil_tid_ampdu_rx_free(wil, r);
+
+	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
 }
 
 static const struct {
@@ -649,6 +677,8 @@ static const struct {
 	{WMI_DATA_PORT_OPEN_EVENTID,	wmi_evt_linkup},
 	{WMI_WBE_LINKDOWN_EVENTID,	wmi_evt_linkdown},
 	{WMI_BA_STATUS_EVENTID,		wmi_evt_ba_status},
+	{WMI_RCP_ADDBA_REQ_EVENTID,	wmi_evt_addba_rx_req},
+	{WMI_DELBA_EVENTID,		wmi_evt_delba},
 };
 
 /*
@@ -1111,6 +1141,73 @@ int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason)
 	return wmi_send(wil, WMI_DISCONNECT_STA_CMDID, &cmd, sizeof(cmd));
 }
 
+int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout)
+{
+	struct wmi_vring_ba_en_cmd cmd = {
+		.ringid = ringid,
+		.agg_max_wsize = size,
+		.ba_timeout = cpu_to_le16(timeout),
+	};
+
+	wil_dbg_wmi(wil, "%s(ring %d size %d timeout %d)\n", __func__,
+		    ringid, size, timeout);
+
+	return wmi_send(wil, WMI_VRING_BA_EN_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_delba(struct wil6210_priv *wil, u8 ringid, u16 reason)
+{
+	struct wmi_vring_ba_dis_cmd cmd = {
+		.ringid = ringid,
+		.reason = cpu_to_le16(reason),
+	};
+
+	wil_dbg_wmi(wil, "%s(ring %d reason %d)\n", __func__,
+		    ringid, reason);
+
+	return wmi_send(wil, WMI_VRING_BA_DIS_CMDID, &cmd, sizeof(cmd));
+}
+
+int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
+		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout)
+{
+	int rc;
+	struct wmi_rcp_addba_resp_cmd cmd = {
+		.cidxtid = mk_cidxtid(cid, tid),
+		.dialog_token = token,
+		.status_code = cpu_to_le16(status),
+		/* bit 0: A-MSDU supported
+		 * bit 1: policy (should be 0 for us)
+		 * bits 2..5: TID
+		 * bits 6..15: buffer size
+		 */
+		.ba_param_set = cpu_to_le16((amsdu ? 1 : 0) | (tid << 2) |
+					    (agg_wsize << 6)),
+		.ba_timeout = cpu_to_le16(timeout),
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_rcp_addba_resp_sent_event evt;
+	} __packed reply;
+
+	wil_dbg_wmi(wil,
+		    "ADDBA response for CID %d TID %d size %d timeout %d status %d AMSDU%s\n",
+		    cid, tid, agg_wsize, timeout, status, amsdu ? "+" : "-");
+
+	rc = wmi_call(wil, WMI_RCP_ADDBA_RESP_CMDID, &cmd, sizeof(cmd),
+		      WMI_ADDBA_RESP_SENT_EVENTID, &reply, sizeof(reply), 100);
+	if (rc)
+		return rc;
+
+	if (reply.evt.status) {
+		wil_err(wil, "ADDBA response failed with status %d\n",
+			le16_to_cpu(reply.evt.status));
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
2.1.0

