Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41617 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcA1R5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 12:57:05 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 1/4] wil6210: prevent access to vring_tx_data lock during its init
Date: Thu, 28 Jan 2016 19:24:02 +0200
Message-Id: <1454001845-28414-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160128_185709_496588_94A65C8D)
In-Reply-To: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil_tx_vring locks the vring_tx_data lock before accessing the TX
vring to check if it is enabled and valid for use.
In case of quick disconnect / connect events for the same station,
spin_lock(&txdata->lock) can be called during the lock initialization
in the vring init function.
To prevent such a race, the TX vrings spin lock should be initialized
once during wil6210 driver initialization.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c |  3 +++
 drivers/net/wireless/ath/wil6210/txrx.c | 26 +++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0652efe..712ebbf 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -438,6 +438,9 @@ int wil_priv_init(struct wil6210_priv *wil)
 	for (i = 0; i < WIL6210_MAX_CID; i++)
 		spin_lock_init(&wil->sta[i].tid_rx_lock);
 
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++)
+		spin_lock_init(&wil->vring_tx_data[i].lock);
+
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
 	mutex_init(&wil->back_rx_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 9680b97..6af2090 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -717,6 +717,21 @@ void wil_rx_fini(struct wil6210_priv *wil)
 		wil_vring_free(wil, vring, 0);
 }
 
+static inline void wil_tx_data_init(struct vring_tx_data *txdata)
+{
+	spin_lock_bh(&txdata->lock);
+	txdata->dot1x_open = 0;
+	txdata->enabled = 0;
+	txdata->idle = 0;
+	txdata->last_idle = 0;
+	txdata->begin = 0;
+	txdata->agg_wsize = 0;
+	txdata->agg_timeout = 0;
+	txdata->agg_amsdu = 0;
+	txdata->addba_in_progress = false;
+	spin_unlock_bh(&txdata->lock);
+}
+
 int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		      int cid, int tid)
 {
@@ -758,8 +773,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		goto out;
 	}
 
-	memset(txdata, 0, sizeof(*txdata));
-	spin_lock_init(&txdata->lock);
+	wil_tx_data_init(txdata);
 	vring->size = size;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
@@ -791,8 +805,10 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 
 	return 0;
  out_free:
+	spin_lock_bh(&txdata->lock);
 	txdata->dot1x_open = false;
 	txdata->enabled = 0;
+	spin_unlock_bh(&txdata->lock);
 	wil_vring_free(wil, vring, 1);
 	wil->vring2cid_tid[id][0] = WIL6210_MAX_CID;
 	wil->vring2cid_tid[id][1] = 0;
@@ -834,8 +850,7 @@ int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
 		goto out;
 	}
 
-	memset(txdata, 0, sizeof(*txdata));
-	spin_lock_init(&txdata->lock);
+	wil_tx_data_init(txdata);
 	vring->size = size;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
@@ -865,8 +880,10 @@ int wil_vring_init_bcast(struct wil6210_priv *wil, int id, int size)
 
 	return 0;
  out_free:
+	spin_lock_bh(&txdata->lock);
 	txdata->enabled = 0;
 	txdata->dot1x_open = false;
+	spin_unlock_bh(&txdata->lock);
 	wil_vring_free(wil, vring, 1);
  out:
 
@@ -894,7 +911,6 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 		napi_synchronize(&wil->napi_tx);
 
 	wil_vring_free(wil, vring, 1);
-	memset(txdata, 0, sizeof(*txdata));
 }
 
 static struct vring *wil_find_tx_ucast(struct wil6210_priv *wil,
-- 
1.8.5.2

