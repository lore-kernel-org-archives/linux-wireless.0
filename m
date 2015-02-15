Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbbBOMDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:06 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 5/9] wil6210: Change of threshold for tx vring idleness measurement
Date: Sun, 15 Feb 2015 14:02:34 +0200
Message-Id: <1424001758-29529-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130318_666488_E05CB77B)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>

Change threshold to be variable debugfs entry from hard-coded 0.
Default threshold value is 16 descriptors because HW is capable
of fetching up to 16 descriptors at once.

Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  3 ++
 drivers/net/wireless/ath/wil6210/txrx.c    | 52 ++++++++++++++++++++----------
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 3ed16e7..eb6de8c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -29,6 +29,7 @@
 static u32 mem_addr;
 static u32 dbg_txdesc_index;
 static u32 dbg_vring_index; /* 24+ for Rx, 0..23 for Tx */
+u32 vring_idle_trsh = 16; /* HW fetches up to 16 descriptors at once */
 
 enum dbg_off_type {
 	doff_u32 = 0,
@@ -1412,6 +1413,8 @@ static const struct dbg_off dbg_statics[] = {
 	{"desc_index",	S_IRUGO | S_IWUSR, (ulong)&dbg_txdesc_index, doff_u32},
 	{"vring_index",	S_IRUGO | S_IWUSR, (ulong)&dbg_vring_index, doff_u32},
 	{"mem_addr",	S_IRUGO | S_IWUSR, (ulong)&mem_addr, doff_u32},
+	{"vring_idle_trsh", S_IRUGO | S_IWUSR, (ulong)&vring_idle_trsh,
+	 doff_u32},
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7e119d0..7f2f560 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -53,34 +53,38 @@ static inline int wil_vring_is_full(struct vring *vring)
 	return wil_vring_next_tail(vring) == vring->swhead;
 }
 
-/*
- * Available space in Tx Vring
- */
-static inline int wil_vring_avail_tx(struct vring *vring)
+/* Used space in Tx Vring */
+static inline int wil_vring_used_tx(struct vring *vring)
 {
 	u32 swhead = vring->swhead;
 	u32 swtail = vring->swtail;
-	int used = (vring->size + swhead - swtail) % vring->size;
+	return (vring->size + swhead - swtail) % vring->size;
+}
 
-	return vring->size - used - 1;
+/* Available space in Tx Vring */
+static inline int wil_vring_avail_tx(struct vring *vring)
+{
+	return vring->size - wil_vring_used_tx(vring) - 1;
 }
 
-/**
- * wil_vring_wmark_low - low watermark for available descriptor space
- */
+/* wil_vring_wmark_low - low watermark for available descriptor space */
 static inline int wil_vring_wmark_low(struct vring *vring)
 {
 	return vring->size/8;
 }
 
-/**
- * wil_vring_wmark_high - high watermark for available descriptor space
- */
+/* wil_vring_wmark_high - high watermark for available descriptor space */
 static inline int wil_vring_wmark_high(struct vring *vring)
 {
 	return vring->size/4;
 }
 
+/* wil_val_in_range - check if value in [min,max) */
+static inline bool wil_val_in_range(int val, int min, int max)
+{
+	return val >= min && val < max;
+}
+
 static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 {
 	struct device *dev = wil_to_dev(wil);
@@ -98,8 +102,7 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 		vring->va = NULL;
 		return -ENOMEM;
 	}
-	/*
-	 * vring->va should be aligned on its size rounded up to power of 2
+	/* vring->va should be aligned on its size rounded up to power of 2
 	 * This is granted by the dma_alloc_coherent
 	 */
 	vring->va = dma_alloc_coherent(dev, sz, &vring->pa, GFP_KERNEL);
@@ -921,6 +924,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	struct vring_tx_data *txdata = &wil->vring_tx_data[vring_index];
 	uint i = swhead;
 	dma_addr_t pa;
+	int used;
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 
@@ -996,8 +1000,14 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	 */
 	vring->ctx[i].skb = skb_get(skb);
 
-	if (wil_vring_is_empty(vring)) /* performance monitoring */
+	/* performance monitoring */
+	used = wil_vring_used_tx(vring);
+	if (wil_val_in_range(vring_idle_trsh,
+			     used, used + nr_frags + 1)) {
 		txdata->idle += get_cycles() - txdata->last_idle;
+		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
+			     vring_index, used, used + nr_frags + 1);
+	}
 
 	/* advance swhead */
 	wil_vring_advance_head(vring, nr_frags + 1);
@@ -1141,6 +1151,8 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 	int cid = wil->vring2cid_tid[ringid][0];
 	struct wil_net_stats *stats = &wil->sta[cid].stats;
 	volatile struct vring_tx_desc *_d;
+	int used_before_complete;
+	int used_new;
 
 	if (unlikely(!vring->va)) {
 		wil_err(wil, "Tx irq[%d]: vring not initialized\n", ringid);
@@ -1154,6 +1166,8 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 
 	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
+	used_before_complete = wil_vring_used_tx(vring);
+
 	while (!wil_vring_is_empty(vring)) {
 		int new_swtail;
 		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
@@ -1215,8 +1229,12 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		}
 	}
 
-	if (wil_vring_is_empty(vring)) { /* performance monitoring */
-		wil_dbg_txrx(wil, "Ring[%2d] empty\n", ringid);
+	/* performance monitoring */
+	used_new = wil_vring_used_tx(vring);
+	if (wil_val_in_range(vring_idle_trsh,
+			     used_new, used_before_complete)) {
+		wil_dbg_txrx(wil, "Ring[%2d] idle %d -> %d\n",
+			     ringid, used_before_complete, used_new);
 		txdata->last_idle = get_cycles();
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 85f0011..4afb8e4 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -27,6 +27,7 @@ extern bool no_fw_recovery;
 extern unsigned int mtu_max;
 extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
+extern u32 vring_idle_trsh;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw" /* code */
-- 
2.1.0

