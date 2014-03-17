Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5536 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbaCQNfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:20 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 21/21] wil6210: fix race between disconnect and Tx NAPI
Date: Mon, 17 Mar 2014 15:34:25 +0200
Message-ID: <1395063265-6522-22-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143529_680029_B3CED3B7)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disconnecting some CID, corresponded Tx vring get released. During vring
release, all descriptors get freed. It is possible that Tx NAPI working on the same
vring simultaneously. If it happens, descriptor may be double freed.

To protect from the race above, make sure NAPI won't process the same vring.
Introduce 'enabled' flag in the struct vring_tx_data. Proceed with Tx NAPI only if
'enabled' flag set. Prior to Tx vring release, clear this flag and make sure NAPI
get synchronized.

NAPI enablement status protected by wil->mutex, add protection where it was
missing and check for it.

During reset, disconnect all peers first, then proceed with the Rx vring. It allows for
the disconnect flow to observe proper 'wil->status' and correctly notify cfg80211 about
connection status change

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  4 ++++
 drivers/net/wireless/ath/wil6210/main.c     | 17 +++++++++++++----
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  2 ++
 drivers/net/wireless/ath/wil6210/txrx.c     | 17 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  9 +++++++++
 drivers/net/wireless/ath/wil6210/wmi.c      |  2 ++
 6 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ed5a7e1..4806a49 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -674,7 +674,11 @@ static int wil_cfg80211_del_station(struct wiphy *wiphy,
 				    struct net_device *dev, u8 *mac)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	mutex_lock(&wil->mutex);
 	wil6210_disconnect(wil, mac);
+	mutex_unlock(&wil->mutex);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0005d9b..95f4efe 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -133,7 +133,9 @@ static void wil_disconnect_worker(struct work_struct *work)
 	struct wil6210_priv *wil = container_of(work,
 			struct wil6210_priv, disconnect_worker);
 
+	mutex_lock(&wil->mutex);
 	_wil6210_disconnect(wil, NULL);
+	mutex_unlock(&wil->mutex);
 }
 
 static void wil_connect_timer_fn(ulong x)
@@ -260,7 +262,9 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 {
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
+	mutex_lock(&wil->mutex);
 	wil6210_disconnect(wil, NULL);
+	mutex_unlock(&wil->mutex);
 	wmi_event_flush(wil);
 	destroy_workqueue(wil->wmi_wq_conn);
 	destroy_workqueue(wil->wmi_wq);
@@ -374,10 +378,14 @@ int wil_reset(struct wil6210_priv *wil)
 {
 	int rc;
 
+	WARN_ON(!mutex_is_locked(&wil->mutex));
+
+	cancel_work_sync(&wil->disconnect_worker);
+	wil6210_disconnect(wil, NULL);
+
 	wil->status = 0; /* prevent NAPI from being scheduled */
 	if (test_bit(wil_status_napi_en, &wil->status)) {
 		napi_synchronize(&wil->napi_rx);
-		napi_synchronize(&wil->napi_tx);
 	}
 
 	if (wil->scan_request) {
@@ -387,9 +395,6 @@ int wil_reset(struct wil6210_priv *wil)
 		wil->scan_request = NULL;
 	}
 
-	cancel_work_sync(&wil->disconnect_worker);
-	wil6210_disconnect(wil, NULL);
-
 	wil6210_disable_irq(wil);
 
 	wmi_event_flush(wil);
@@ -447,6 +452,8 @@ static int __wil_up(struct wil6210_priv *wil)
 	struct wireless_dev *wdev = wil->wdev;
 	int rc;
 
+	WARN_ON(!mutex_is_locked(&wil->mutex));
+
 	rc = wil_reset(wil);
 	if (rc)
 		return rc;
@@ -506,6 +513,8 @@ int wil_up(struct wil6210_priv *wil)
 
 static int __wil_down(struct wil6210_priv *wil)
 {
+	WARN_ON(!mutex_is_locked(&wil->mutex));
+
 	clear_bit(wil_status_napi_en, &wil->status);
 	napi_disable(&wil->napi_rx);
 	napi_disable(&wil->napi_tx);
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index c609761..58fc096 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -70,7 +70,9 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 		goto stop_master;
 
 	/* need reset here to obtain MAC */
+	mutex_lock(&wil->mutex);
 	rc = wil_reset(wil);
+	mutex_unlock(&wil->mutex);
 	if (rc)
 		goto release_irq;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index cfd36cc..c8c5474 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -618,6 +618,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		struct wmi_vring_cfg_done_event cmd;
 	} __packed reply;
 	struct vring *vring = &wil->vring_tx[id];
+	struct vring_tx_data *txdata = &wil->vring_tx_data[id];
 
 	if (vring->va) {
 		wil_err(wil, "Tx ring [%d] already allocated\n", id);
@@ -625,6 +626,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		goto out;
 	}
 
+	memset(txdata, 0, sizeof(*txdata));
 	vring->size = size;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
@@ -648,6 +650,8 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	}
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
+	txdata->enabled = 1;
+
 	return 0;
  out_free:
 	wil_vring_free(wil, vring, 1);
@@ -660,9 +664,16 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 {
 	struct vring *vring = &wil->vring_tx[id];
 
+	WARN_ON(!mutex_is_locked(&wil->mutex));
+
 	if (!vring->va)
 		return;
 
+	/* make sure NAPI won't touch this vring */
+	wil->vring_tx_data[id].enabled = 0;
+	if (test_bit(wil_status_napi_en, &wil->status))
+		napi_synchronize(&wil->napi_tx);
+
 	wil_vring_free(wil, vring, 1);
 }
 
@@ -1028,6 +1039,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct device *dev = wil_to_dev(wil);
 	struct vring *vring = &wil->vring_tx[ringid];
+	struct vring_tx_data *txdata = &wil->vring_tx_data[ringid];
 	int done = 0;
 	int cid = wil->vring2cid_tid[ringid][0];
 	struct wil_net_stats *stats = &wil->sta[cid].stats;
@@ -1038,6 +1050,11 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		return 0;
 	}
 
+	if (!txdata->enabled) {
+		wil_info(wil, "Tx irq[%d]: vring disabled\n", ringid);
+		return 0;
+	}
+
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
 	while (!wil_vring_is_empty(vring)) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index fb1006b..2a2dec7 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -243,6 +243,14 @@ struct vring {
 	struct wil_ctx *ctx; /* ctx[size] - software context */
 };
 
+/**
+ * Additional data for Tx Vring
+ */
+struct vring_tx_data {
+	int enabled;
+
+};
+
 enum { /* for wil6210_priv.status */
 	wil_status_fwready = 0,
 	wil_status_fwconnecting,
@@ -386,6 +394,7 @@ struct wil6210_priv {
 	/* DMA related */
 	struct vring vring_rx;
 	struct vring vring_tx[WIL6210_MAX_TX_RINGS];
+	struct vring_tx_data vring_tx_data[WIL6210_MAX_TX_RINGS];
 	u8 vring2cid_tid[WIL6210_MAX_TX_RINGS][2]; /* [0] - CID, [1] - TID */
 	struct wil_sta_info sta[WIL6210_MAX_CID];
 	/* scan */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 58c3afc..2ba56ee 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -462,7 +462,9 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 
 	wil->sinfo_gen++;
 
+	mutex_lock(&wil->mutex);
 	wil6210_disconnect(wil, evt->bssid);
+	mutex_unlock(&wil->mutex);
 }
 
 static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
-- 
1.8.3.2

