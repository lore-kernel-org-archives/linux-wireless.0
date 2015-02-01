Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25275 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbBAIzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 03:55:36 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 3/6] wil6210: fix race between xmit and Tx vring de-allocation
Date: Sun,  1 Feb 2015 10:55:13 +0200
Message-Id: <1422780916-8577-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150201_095547_461174_31A75D7D)
In-Reply-To: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use spinlock, this should not impact Tx as lock is always free
except for de-allocation.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    | 25 ++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e37cab1..85ecea2 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -671,6 +671,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	}
 
 	memset(txdata, 0, sizeof(*txdata));
+	spin_lock_init(&txdata->lock);
 	vring->size = size;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
@@ -718,8 +719,10 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 
 	wil_dbg_misc(wil, "%s() id=%d\n", __func__, id);
 
+	spin_lock_bh(&txdata->lock);
+	txdata->enabled = 0; /* no Tx can be in progress or start anew */
+	spin_unlock_bh(&txdata->lock);
 	/* make sure NAPI won't touch this vring */
-	wil->vring_tx_data[id].enabled = 0;
 	if (test_bit(wil_status_napi_en, wil->status))
 		napi_synchronize(&wil->napi_tx);
 
@@ -935,8 +938,8 @@ static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
 	return 0;
 }
 
-static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
-			struct sk_buff *skb)
+static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
+			  struct sk_buff *skb)
 {
 	struct device *dev = wil_to_dev(wil);
 	struct vring_tx_desc dd, *d = &dd;
@@ -952,6 +955,9 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 
+	if (unlikely(!txdata->enabled))
+		return -EINVAL;
+
 	if (avail < 1 + nr_frags) {
 		wil_err_ratelimited(wil,
 				    "Tx ring full. No space for %d fragments\n",
@@ -1050,6 +1056,19 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	return -EINVAL;
 }
 
+static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
+			struct sk_buff *skb)
+{
+	int vring_index = vring - wil->vring_tx;
+	struct vring_tx_data *txdata = &wil->vring_tx_data[vring_index];
+	int rc;
+
+	spin_lock(&txdata->lock);
+	rc = __wil_tx_vring(wil, vring, skb);
+	spin_unlock(&txdata->lock);
+	return rc;
+}
+
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 90dc24f..9461156 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -385,6 +385,7 @@ struct vring_tx_data {
 	u16 agg_timeout;
 	u8 agg_amsdu;
 	bool addba_in_progress; /* if set, agg_xxx is for request in progress */
+	spinlock_t lock;
 };
 
 enum { /* for wil6210_priv.status */
-- 
2.1.0

