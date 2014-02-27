Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47557 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaB0OVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:30 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 05/16] wil6210: Block ACK
Date: Thu, 27 Feb 2014 16:20:44 +0200
Message-ID: <1393510855-17566-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152137_118856_D8FFEF89)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running multiple connections, hardware can't do BACK reordering
and it should be done on the host.

Model after mac80211's implementation. Drop RCU for now;
to be re-added when BACK will be stabilized

BACK handshaking is not implemented yet in the hardware,
pretend it was done to support the way FW operating

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile     |   1 +
 drivers/net/wireless/ath/wil6210/debugfs.c    |  25 +++-
 drivers/net/wireless/ath/wil6210/main.c       |  12 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 177 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c       |   6 +-
 drivers/net/wireless/ath/wil6210/txrx.h       |   7 +
 drivers/net/wireless/ath/wil6210/wil6210.h    |  47 +++++++
 drivers/net/wireless/ath/wil6210/wmi.c        |  22 +++-
 8 files changed, 290 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/rx_reorder.c

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 990dd42a..c7a3465 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -9,6 +9,7 @@ wil6210-y += wmi.o
 wil6210-y += interrupt.o
 wil6210-y += txrx.o
 wil6210-y += debug.o
+wil6210-y += rx_reorder.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 
 # for tracing framework to find trace.h
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index f12aa0b..729e774 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -598,11 +598,24 @@ static const struct file_operations fops_temp = {
 };
 
 /*---------Station matrix------------*/
+static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
+{
+	int i;
+	u16 index = ((r->head_seq_num - r->ssn) & 0xfff) % r->buf_size;
+	seq_printf(s, "0x%03x [", r->head_seq_num);
+	for (i = 0; i < r->buf_size; i++) {
+		if (i == index)
+			seq_printf(s, "%c", r->reorder_buf[i] ? 'O' : '|');
+		else
+			seq_printf(s, "%c", r->reorder_buf[i] ? '*' : '_');
+	}
+	seq_puts(s, "]\n");
+}
 
 static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	int i;
+	int i, tid;
 
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
@@ -619,6 +632,16 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 			break;
 		}
 		seq_printf(s, "[%d] %pM %s\n", i, p->addr, status);
+
+		if (p->status == wil_sta_connected) {
+			for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
+				struct wil_tid_ampdu_rx *r = p->tid_rx[tid];
+				if (r) {
+					seq_printf(s, "[%2d] ", tid);
+					wil_print_rxtid(s, r);
+				}
+			}
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f68481d..38906f1 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -18,6 +18,7 @@
 #include <linux/if_arp.h>
 
 #include "wil6210.h"
+#include "txrx.h"
 
 /*
  * Due to a hardware issue,
@@ -54,11 +55,20 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 
 static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 {
-	uint i;
+	uint i, cid;
 	struct net_device *ndev = wil_to_ndev(wil);
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	for (cid = 0; cid < WIL6210_MAX_CID; cid++) {
+		struct wil_sta_info *sta = &wil->sta[cid];
+		for (i = 0; i < WIL_STA_TID_NUM; i++) {
+			struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
+			sta->tid_rx[i] = NULL;
+			wil_tid_ampdu_rx_free(wil, r);
+		}
+	}
+
 	wil_link_off(wil);
 	if (test_bit(wil_status_fwconnected, &wil->status)) {
 		clear_bit(wil_status_fwconnected, &wil->status);
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
new file mode 100644
index 0000000..d04629f
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -0,0 +1,177 @@
+#include "wil6210.h"
+#include "txrx.h"
+
+#define SEQ_MODULO 0x1000
+#define SEQ_MASK   0xfff
+
+static inline int seq_less(u16 sq1, u16 sq2)
+{
+	return ((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1);
+}
+
+static inline u16 seq_inc(u16 sq)
+{
+	return (sq + 1) & SEQ_MASK;
+}
+
+static inline u16 seq_sub(u16 sq1, u16 sq2)
+{
+	return (sq1 - sq2) & SEQ_MASK;
+}
+
+static inline int reorder_index(struct wil_tid_ampdu_rx *r, u16 seq)
+{
+	return seq_sub(seq, r->ssn) % r->buf_size;
+}
+
+static void wil_release_reorder_frame(struct wil6210_priv *wil,
+				      struct wil_tid_ampdu_rx *r,
+				      int index)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct sk_buff *skb = r->reorder_buf[index];
+
+	if (!skb)
+		goto no_frame;
+
+	/* release the frame from the reorder ring buffer */
+	r->stored_mpdu_num--;
+	r->reorder_buf[index] = NULL;
+	wil_netif_rx_any(skb, ndev);
+
+no_frame:
+	r->head_seq_num = seq_inc(r->head_seq_num);
+}
+
+static void wil_release_reorder_frames(struct wil6210_priv *wil,
+				       struct wil_tid_ampdu_rx *r,
+				       u16 hseq)
+{
+	int index;
+
+	while (seq_less(r->head_seq_num, hseq)) {
+		index = reorder_index(r, r->head_seq_num);
+		wil_release_reorder_frame(wil, r, index);
+	}
+}
+
+static void wil_reorder_release(struct wil6210_priv *wil,
+				struct wil_tid_ampdu_rx *r)
+{
+	int index = reorder_index(r, r->head_seq_num);
+
+	while (r->reorder_buf[index]) {
+		wil_release_reorder_frame(wil, r, index);
+		index = reorder_index(r, r->head_seq_num);
+	}
+}
+
+void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
+{
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
+	int tid = wil_rxdesc_tid(d);
+	int cid = wil_rxdesc_cid(d);
+	int mid = wil_rxdesc_mid(d);
+	u16 seq = wil_rxdesc_seq(d);
+	struct wil_sta_info *sta = &wil->sta[cid];
+	struct wil_tid_ampdu_rx *r = sta->tid_rx[tid];
+	u16 hseq;
+	int index;
+
+	wil_dbg_txrx(wil, "MID %d CID %d TID %d Seq 0x%03x\n",
+		     mid, cid, tid, seq);
+
+	if (!r) {
+		wil_netif_rx_any(skb, ndev);
+		return;
+	}
+
+	hseq = r->head_seq_num;
+
+	spin_lock(&r->reorder_lock);
+
+	/* frame with out of date sequence number */
+	if (seq_less(seq, r->head_seq_num)) {
+		dev_kfree_skb(skb);
+		goto out;
+	}
+
+	/*
+	 * If frame the sequence number exceeds our buffering window
+	 * size release some previous frames to make room for this one.
+	 */
+	if (!seq_less(seq, r->head_seq_num + r->buf_size)) {
+		hseq = seq_inc(seq_sub(seq, r->buf_size));
+		/* release stored frames up to new head to stack */
+		wil_release_reorder_frames(wil, r, hseq);
+	}
+
+	/* Now the new frame is always in the range of the reordering buffer */
+
+	index = reorder_index(r, seq);
+
+	/* check if we already stored this frame */
+	if (r->reorder_buf[index]) {
+		dev_kfree_skb(skb);
+		goto out;
+	}
+
+	/*
+	 * If the current MPDU is in the right order and nothing else
+	 * is stored we can process it directly, no need to buffer it.
+	 * If it is first but there's something stored, we may be able
+	 * to release frames after this one.
+	 */
+	if (seq == r->head_seq_num && r->stored_mpdu_num == 0) {
+		r->head_seq_num = seq_inc(r->head_seq_num);
+		wil_netif_rx_any(skb, ndev);
+		goto out;
+	}
+
+	/* put the frame in the reordering buffer */
+	r->reorder_buf[index] = skb;
+	r->reorder_time[index] = jiffies;
+	r->stored_mpdu_num++;
+	wil_reorder_release(wil, r);
+
+out:
+	spin_unlock(&r->reorder_lock);
+}
+
+struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
+						int size, u16 ssn)
+{
+	struct wil_tid_ampdu_rx *r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return NULL;
+
+	r->reorder_buf =
+		kcalloc(size, sizeof(struct sk_buff *), GFP_KERNEL);
+	r->reorder_time =
+		kcalloc(size, sizeof(unsigned long), GFP_KERNEL);
+	if (!r->reorder_buf || !r->reorder_time) {
+		kfree(r->reorder_buf);
+		kfree(r->reorder_time);
+		kfree(r);
+		return NULL;
+	}
+
+	spin_lock_init(&r->reorder_lock);
+	r->ssn = ssn;
+	r->head_seq_num = ssn;
+	r->buf_size = size;
+	r->stored_mpdu_num = 0;
+	return r;
+}
+
+void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
+			   struct wil_tid_ampdu_rx *r)
+{
+	if (!r)
+		return;
+	wil_release_reorder_frames(wil, r, r->head_seq_num + r->buf_size);
+	kfree(r->reorder_buf);
+	kfree(r->reorder_time);
+	kfree(r);
+}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index eb60023..48d9715 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -472,7 +472,7 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
  * Pass Rx packet to the netif. Update statistics.
  * Called in softirq context (NAPI poll).
  */
-static void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
+void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 {
 	int rc;
 	unsigned int len = skb->len;
@@ -515,12 +515,12 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			skb->pkt_type = PACKET_OTHERHOST;
 			skb->protocol = htons(ETH_P_802_2);
-
+			wil_netif_rx_any(skb, ndev);
 		} else {
 			skb->protocol = eth_type_trans(skb, ndev);
+			wil_rx_reorder(wil, skb);
 		}
 
-		wil_netif_rx_any(skb, ndev);
 	}
 	wil_rx_refill(wil, v->size);
 }
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index b382827..bc5706a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -436,4 +436,11 @@ static inline struct vring_rx_desc *wil_skb_rxdesc(struct sk_buff *skb)
 	return (void *)skb->cb;
 }
 
+void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev);
+void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb);
+struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
+						int size, u16 ssn);
+void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
+			   struct wil_tid_ampdu_rx *r);
+
 #endif /* WIL6210_TXRX_H */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 38df203..304b990 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -215,6 +215,46 @@ enum { /* for wil6210_priv.status */
 
 struct pci_dev;
 
+/**
+ * struct tid_ampdu_rx - TID aggregation information (Rx).
+ *
+ * @reorder_buf: buffer to reorder incoming aggregated MPDUs
+ * @reorder_time: jiffies when skb was added
+ * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
+ * @reorder_timer: releases expired frames from the reorder buffer.
+ * @last_rx: jiffies of last rx activity
+ * @head_seq_num: head sequence number in reordering buffer.
+ * @stored_mpdu_num: number of MPDUs in reordering buffer
+ * @ssn: Starting Sequence Number expected to be aggregated.
+ * @buf_size: buffer size for incoming A-MPDUs
+ * @timeout: reset timer value (in TUs).
+ * @dialog_token: dialog token for aggregation session
+ * @rcu_head: RCU head used for freeing this struct
+ * @reorder_lock: serializes access to reorder buffer, see below.
+ *
+ * This structure's lifetime is managed by RCU, assignments to
+ * the array holding it must hold the aggregation mutex.
+ *
+ * The @reorder_lock is used to protect the members of this
+ * struct, except for @timeout, @buf_size and @dialog_token,
+ * which are constant across the lifetime of the struct (the
+ * dialog token being used only for debugging).
+ */
+struct wil_tid_ampdu_rx {
+	spinlock_t reorder_lock; /* see above */
+	struct sk_buff **reorder_buf;
+	unsigned long *reorder_time;
+	struct timer_list session_timer;
+	struct timer_list reorder_timer;
+	unsigned long last_rx;
+	u16 head_seq_num;
+	u16 stored_mpdu_num;
+	u16 ssn;
+	u16 buf_size;
+	u16 timeout;
+	u8 dialog_token;
+};
+
 struct wil6210_stats {
 	u64 tsf;
 	u32 snr;
@@ -231,6 +271,9 @@ enum wil_sta_status {
 	wil_sta_conn_pending = 1,
 	wil_sta_connected = 2,
 };
+
+#define WIL_STA_TID_NUM (16)
+
 /**
  * struct wil_sta_info - data for peer
  *
@@ -242,6 +285,10 @@ enum wil_sta_status {
 struct wil_sta_info {
 	u8 addr[ETH_ALEN];
 	enum wil_sta_status status;
+	/* Rx BACK */
+	struct wil_tid_ampdu_rx *tid_rx[WIL_STA_TID_NUM];
+	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(WIL_STA_TID_NUM)];
+	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(WIL_STA_TID_NUM)];
 };
 
 struct wil6210_priv {
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 2d60290..dfbc239 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -563,10 +563,27 @@ static void wmi_evt_ba_status(struct wil6210_priv *wil, int id, void *d,
 			      int len)
 {
 	struct wmi_vring_ba_status_event *evt = d;
+	uint cid, i;
 
 	wil_dbg_wmi(wil, "BACK[%d] %s {%d} timeout %d\n",
-		    evt->ringid, evt->status ? "N/A" : "OK", evt->agg_wsize,
-		    __le16_to_cpu(evt->ba_timeout));
+		    evt->ringid, evt->status == WMI_BA_AGREED ? "OK" : "N/A",
+		    evt->agg_wsize, __le16_to_cpu(evt->ba_timeout));
+	for (cid = 0; cid < WIL6210_MAX_CID; cid++) {
+		struct wil_sta_info *sta = &wil->sta[cid];
+
+		if (sta->status == wil_sta_unused)
+			continue;
+		wil_dbg_wmi(wil, "Init BACK for CID %d %pM\n", cid, sta->addr);
+		for (i = 0; i < WIL_STA_TID_NUM; i++) {
+			struct wil_tid_ampdu_rx *r = sta->tid_rx[i];
+			sta->tid_rx[i] = NULL;
+			wil_tid_ampdu_rx_free(wil, r);
+			if ((evt->status == WMI_BA_AGREED) && evt->agg_wsize)
+				sta->tid_rx[i] = wil_tid_ampdu_rx_alloc(wil,
+							evt->agg_wsize, 0);
+		}
+	}
+
 }
 
 static const struct {
@@ -949,6 +966,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 		},
 		.mid = 0, /* TODO - what is it? */
 		.decap_trans_type = WMI_DECAP_TYPE_802_3,
+		.reorder_type = WMI_RX_SW_REORDER,
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
-- 
1.8.3.2

