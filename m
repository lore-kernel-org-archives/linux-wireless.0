Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58844 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaIJNfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:34 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/22] wil6210: fix race condition between BACK event and Rx data
Date: Wed, 10 Sep 2014 16:34:42 +0300
Message-ID: <1410356091-19219-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153549_401090_2C40BD06)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

While handling Rx packet, BACK event arrives and frees tid_ampdu_rx array.
This causes kernel panic while accessing already freed spinlock

The fix is to remove tid_ampdu_rx[]'s spinlock and instead use single
sta's spinlock to guard the whole tid_ampdu_rx array.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  3 +++
 drivers/net/wireless/ath/wil6210/main.c       | 13 ++++++++++++-
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 12 +++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h    |  7 +------
 drivers/net/wireless/ath/wil6210/wmi.c        | 10 +++++++++-
 5 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index e1f9276..21dc437 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1059,6 +1059,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	int i, tid;
+	unsigned long flags;
 
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
@@ -1079,6 +1080,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 			   (p->data_port_open ? " data_port_open" : ""));
 
 		if (p->status == wil_sta_connected) {
+			spin_lock_irqsave(&p->tid_rx_lock, flags);
 			for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
 				struct wil_tid_ampdu_rx *r = p->tid_rx[tid];
 
@@ -1087,6 +1089,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 					wil_print_rxtid(s, r);
 				}
 			}
+			spin_unlock_irqrestore(&p->tid_rx_lock, flags);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 22e9b8a..d2f2c1e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -95,9 +95,16 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 	}
 
 	for (i = 0; i < WIL_STA_TID_NUM; i++) {
-		struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
+		struct wil_tid_ampdu_rx *r;
+		unsigned long flags;
+
+		spin_lock_irqsave(&sta->tid_rx_lock, flags);
+
+		r = sta->tid_rx[i];
 		sta->tid_rx[i] = NULL;
 		wil_tid_ampdu_rx_free(wil, r);
+
+		spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
 	}
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		if (wil->vring2cid_tid[i][0] == cid)
@@ -267,9 +274,13 @@ static void wil_connect_worker(struct work_struct *work)
 
 int wil_priv_init(struct wil6210_priv *wil)
 {
+	uint i;
+
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	memset(wil->sta, 0, sizeof(wil->sta));
+	for (i = 0; i < WIL6210_MAX_CID; i++)
+		spin_lock_init(&wil->sta[i].tid_rx_lock);
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 2b57069..489cb73 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -98,22 +98,25 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 	int mid = wil_rxdesc_mid(d);
 	u16 seq = wil_rxdesc_seq(d);
 	struct wil_sta_info *sta = &wil->sta[cid];
-	struct wil_tid_ampdu_rx *r = sta->tid_rx[tid];
+	struct wil_tid_ampdu_rx *r;
 	u16 hseq;
 	int index;
+	unsigned long flags;
 
 	wil_dbg_txrx(wil, "MID %d CID %d TID %d Seq 0x%03x\n",
 		     mid, cid, tid, seq);
 
+	spin_lock_irqsave(&sta->tid_rx_lock, flags);
+
+	r = sta->tid_rx[tid];
 	if (!r) {
+		spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
 		wil_netif_rx_any(skb, ndev);
 		return;
 	}
 
 	hseq = r->head_seq_num;
 
-	spin_lock(&r->reorder_lock);
-
 	/** Due to the race between WMI events, where BACK establishment
 	 * reported, and data Rx, few packets may be pass up before reorder
 	 * buffer get allocated. Catch up by pretending SSN is what we
@@ -176,7 +179,7 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 	wil_reorder_release(wil, r);
 
 out:
-	spin_unlock(&r->reorder_lock);
+	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
 }
 
 struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
@@ -198,7 +201,6 @@ struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 		return NULL;
 	}
 
-	spin_lock_init(&r->reorder_lock);
 	r->ssn = ssn;
 	r->head_seq_num = ssn;
 	r->buf_size = size;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e51531b..1b11934 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -318,18 +318,12 @@ struct pci_dev;
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
- * @reorder_lock: serializes access to reorder buffer, see below.
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
  *
- * The @reorder_lock is used to protect the members of this
- * struct, except for @timeout, @buf_size and @dialog_token,
- * which are constant across the lifetime of the struct (the
- * dialog token being used only for debugging).
  */
 struct wil_tid_ampdu_rx {
-	spinlock_t reorder_lock; /* see above */
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
@@ -378,6 +372,7 @@ struct wil_sta_info {
 	bool data_port_open; /* can send any data, not only EAPOL */
 	/* Rx BACK */
 	struct wil_tid_ampdu_rx *tid_rx[WIL_STA_TID_NUM];
+	spinlock_t tid_rx_lock; /* guarding tid_rx array */
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(WIL_STA_TID_NUM)];
 	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(WIL_STA_TID_NUM)];
 };
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index ad48f14..c3682c3a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -613,9 +613,17 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 
 	wil_dbg_wmi(wil, "BACK for CID %d %pM\n", cid, sta->addr);
 	for (i = 0; i < WIL_STA_TID_NUM; i++) {
-		struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
+		struct wil_tid_ampdu_rx *r;
+		unsigned long flags;
+
+		spin_lock_irqsave(&sta->tid_rx_lock, flags);
+
+		r = sta->tid_rx[i];
 		sta->tid_rx[i] = NULL;
 		wil_tid_ampdu_rx_free(wil, r);
+
+		spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
+
 		if ((evt->status == WMI_BA_AGREED) && evt->agg_wsize)
 			sta->tid_rx[i] = wil_tid_ampdu_rx_alloc(wil,
 						evt->agg_wsize, 0);
-- 
1.9.1

