Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaLWHsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:36 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 22/22] wil6210: relax spinlocks in rx reorder
Date: Tue, 23 Dec 2014 09:47:24 +0200
Message-Id: <1419320844-23989-23-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_734081_C63029C9)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the Rx reorder mechanism, nothing is done in the interrupt
context, so there is no need to use 'irq' flavors of spinlock.
Rx done in NAPI context (tasklet), other manipulations - in the
thread context.

Having interrupts enabled makes it better for the OS in general.
Besides, if enslaved under bonding, bridge or team driver, Rx
won't work with interrupts disabled.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  6 +++---
 drivers/net/wireless/ath/wil6210/main.c       |  7 ++++---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 17 +++++++++--------
 drivers/net/wireless/ath/wil6210/wmi.c        |  7 ++++---
 4 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 59d764c..c7ea765 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1258,10 +1258,10 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 }
 
 static int wil_sta_debugfs_show(struct seq_file *s, void *data)
+__acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 {
 	struct wil6210_priv *wil = s->private;
 	int i, tid;
-	unsigned long flags;
 
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
@@ -1282,7 +1282,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 			   (p->data_port_open ? " data_port_open" : ""));
 
 		if (p->status == wil_sta_connected) {
-			spin_lock_irqsave(&p->tid_rx_lock, flags);
+			spin_lock_bh(&p->tid_rx_lock);
 			for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
 				struct wil_tid_ampdu_rx *r = p->tid_rx[tid];
 
@@ -1291,7 +1291,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 					wil_print_rxtid(s, r);
 				}
 			}
-			spin_unlock_irqrestore(&p->tid_rx_lock, flags);
+			spin_unlock_bh(&p->tid_rx_lock);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f44b640..62dc241 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -166,12 +166,14 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 
 static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
 			       u16 reason_code, bool from_event)
+__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 {
 	uint i;
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 	struct wil_sta_info *sta = &wil->sta[cid];
 
+	might_sleep();
 	wil_dbg_misc(wil, "%s(CID %d, status %d)\n", __func__, cid,
 		     sta->status);
 
@@ -194,15 +196,14 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
 
 	for (i = 0; i < WIL_STA_TID_NUM; i++) {
 		struct wil_tid_ampdu_rx *r;
-		unsigned long flags;
 
-		spin_lock_irqsave(&sta->tid_rx_lock, flags);
+		spin_lock_bh(&sta->tid_rx_lock);
 
 		r = sta->tid_rx[i];
 		sta->tid_rx[i] = NULL;
 		wil_tid_ampdu_rx_free(wil, r);
 
-		spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+		spin_unlock_bh(&sta->tid_rx_lock);
 	}
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		if (wil->vring2cid_tid[i][0] == cid)
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 5af8012..5522092 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -89,7 +89,9 @@ static void wil_reorder_release(struct wil6210_priv *wil,
 	}
 }
 
+/* called in NAPI context */
 void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
+__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
@@ -102,7 +104,6 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 	struct wil_tid_ampdu_rx *r;
 	u16 hseq;
 	int index;
-	unsigned long flags;
 
 	wil_dbg_txrx(wil, "MID %d CID %d TID %d Seq 0x%03x mcast %01x\n",
 		     mid, cid, tid, seq, mcast);
@@ -112,13 +113,12 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 		return;
 	}
 
-	spin_lock_irqsave(&sta->tid_rx_lock, flags);
+	spin_lock(&sta->tid_rx_lock);
 
 	r = sta->tid_rx[tid];
 	if (!r) {
-		spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
 		wil_netif_rx_any(skb, ndev);
-		return;
+		goto out;
 	}
 
 	hseq = r->head_seq_num;
@@ -196,7 +196,7 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 	wil_reorder_release(wil, r);
 
 out:
-	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+	spin_unlock(&sta->tid_rx_lock);
 }
 
 struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
@@ -276,6 +276,7 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
 
 static void wil_back_rx_handle(struct wil6210_priv *wil,
 			       struct wil_back_rx *req)
+__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 {
 	struct wil_sta_info *sta;
 	u8 cid, tid;
@@ -291,9 +292,9 @@ static void wil_back_rx_handle(struct wil6210_priv *wil,
 	u16 agg_timeout = req->ba_timeout;
 	u16 status = WLAN_STATUS_SUCCESS;
 	u16 ssn = req->ba_seq_ctrl >> 4;
-	unsigned long flags;
 	int rc;
 
+	might_sleep();
 	parse_cidxtid(req->cidxtid, &cid, &tid);
 
 	/* sanity checks */
@@ -327,12 +328,12 @@ static void wil_back_rx_handle(struct wil6210_priv *wil,
 		return;
 
 	/* apply */
-	spin_lock_irqsave(&sta->tid_rx_lock, flags);
+	spin_lock_bh(&sta->tid_rx_lock);
 
 	wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
 	sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
 
-	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+	spin_unlock_bh(&sta->tid_rx_lock);
 }
 
 void wil_back_rx_flush(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 432ec55..f3524a1 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -644,14 +644,15 @@ static void wmi_evt_addba_rx_req(struct wil6210_priv *wil, int id, void *d,
 }
 
 static void wmi_evt_delba(struct wil6210_priv *wil, int id, void *d, int len)
+__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 {
 	struct wmi_delba_event *evt = d;
 	u8 cid, tid;
 	u16 reason = __le16_to_cpu(evt->reason);
 	struct wil_sta_info *sta;
 	struct wil_tid_ampdu_rx *r;
-	unsigned long flags;
 
+	might_sleep();
 	parse_cidxtid(evt->cidxtid, &cid, &tid);
 	wil_dbg_wmi(wil, "DELBA CID %d TID %d from %s reason %d\n",
 		    cid, tid,
@@ -681,13 +682,13 @@ static void wmi_evt_delba(struct wil6210_priv *wil, int id, void *d, int len)
 
 	sta = &wil->sta[cid];
 
-	spin_lock_irqsave(&sta->tid_rx_lock, flags);
+	spin_lock_bh(&sta->tid_rx_lock);
 
 	r = sta->tid_rx[tid];
 	sta->tid_rx[tid] = NULL;
 	wil_tid_ampdu_rx_free(wil, r);
 
-	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+	spin_unlock_bh(&sta->tid_rx_lock);
 }
 
 static const struct {
-- 
2.1.0

