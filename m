Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4690 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaIJNfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:15 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 05/22] wil6210: coding style fixes
Date: Wed, 10 Sep 2014 16:34:34 +0300
Message-ID: <1410356091-19219-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153527_567367_AD63FE82)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- parentheses, indentation, typos
- seq_puts() instead of seq_printf() with single argument
- sizeof(var) vs. sizeof(type)

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c    | 53 +++++++++++++++++----------
 drivers/net/wireless/ath/wil6210/main.c       |  7 ++--
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  1 +
 drivers/net/wireless/ath/wil6210/txrx.c       | 43 ++++++++++++----------
 drivers/net/wireless/ath/wil6210/txrx.h       |  3 --
 drivers/net/wireless/ath/wil6210/wil6210.h    |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c        |  4 ++
 drivers/net/wireless/ath/wil6210/wmi.h        | 18 +--------
 9 files changed, 72 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index df77711..cba04e5 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -296,6 +296,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	n = min(request->n_channels, 4U);
 	for (i = 0; i < n; i++) {
 		int ch = request->channels[i]->hw_value;
+
 		if (ch == 0) {
 			wil_err(wil,
 				"Scan requested for unknown frequency %dMhz\n",
@@ -713,7 +714,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		goto out;
 
-
 	netif_carrier_on(ndev);
 
 out:
@@ -804,7 +804,7 @@ struct wireless_dev *wil_cfg80211_init(struct device *dev)
 	int rc = 0;
 	struct wireless_dev *wdev;
 
-	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
 	if (!wdev)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index b1c6a72..e1f9276 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -61,20 +61,22 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 	if (x)
 		seq_printf(s, "0x%08x\n", ioread32(x));
 	else
-		seq_printf(s, "???\n");
+		seq_puts(s, "???\n");
 
 	if (vring->va && (vring->size < 1025)) {
 		uint i;
+
 		for (i = 0; i < vring->size; i++) {
 			volatile struct vring_tx_desc *d = &vring->va[i].tx;
+
 			if ((i % 64) == 0 && (i != 0))
-				seq_printf(s, "\n");
+				seq_puts(s, "\n");
 			seq_printf(s, "%c", (d->dma.status & BIT(0)) ?
 					_s : (vring->ctx[i].skb ? _h : 'h'));
 		}
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
-	seq_printf(s, "}\n");
+	seq_puts(s, "}\n");
 }
 
 static int wil_vring_debugfs_show(struct seq_file *s, void *data)
@@ -85,7 +87,7 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 	wil_print_vring(s, wil, "rx", &wil->vring_rx, 'S', '_');
 
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
-		struct vring *vring = &(wil->vring_tx[i]);
+		struct vring *vring = &wil->vring_tx[i];
 		struct vring_tx_data *txdata = &wil->vring_tx_data[i];
 
 		if (vring->va) {
@@ -163,7 +165,7 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 	if (!wmi_addr(wil, r.base) ||
 	    !wmi_addr(wil, r.tail) ||
 	    !wmi_addr(wil, r.head)) {
-		seq_printf(s, "  ??? pointers are garbage?\n");
+		seq_puts(s, "  ??? pointers are garbage?\n");
 		goto out;
 	}
 
@@ -182,6 +184,7 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 			   le32_to_cpu(d.addr));
 		if (0 == wmi_read_hdr(wil, d.addr, &hdr)) {
 			u16 len = le16_to_cpu(hdr.len);
+
 			seq_printf(s, " -> %04x %04x %04x %02x\n",
 				   le16_to_cpu(hdr.seq), len,
 				   le16_to_cpu(hdr.type), hdr.flags);
@@ -199,6 +202,7 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 				wil_memcpy_fromio_32(databuf, src, len);
 				while (n < len) {
 					int l = min(len - n, 16);
+
 					hex_dump_to_buffer(databuf + n, l,
 							   16, 1, printbuf,
 							   sizeof(printbuf),
@@ -208,11 +212,11 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 				}
 			}
 		} else {
-			seq_printf(s, "\n");
+			seq_puts(s, "\n");
 		}
 	}
  out:
-	seq_printf(s, "}\n");
+	seq_puts(s, "}\n");
 }
 
 static int wil_mbox_debugfs_show(struct seq_file *s, void *data)
@@ -271,11 +275,13 @@ static int wil_debugfs_ulong_set(void *data, u64 val)
 	*(ulong *)data = val;
 	return 0;
 }
+
 static int wil_debugfs_ulong_get(void *data, u64 *val)
 {
 	*val = *(ulong *)data;
 	return 0;
 }
+
 DEFINE_SIMPLE_ATTRIBUTE(wil_fops_ulong, wil_debugfs_ulong_get,
 			wil_debugfs_ulong_set, "%llu\n");
 
@@ -339,6 +345,7 @@ static const struct dbg_off isr_off[] = {
 	{"IMC",		  S_IWUSR, offsetof(struct RGF_ICR, IMC), doff_io32},
 	{},
 };
+
 static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
 				      const char *name,
 				      struct dentry *parent, u32 off)
@@ -422,7 +429,7 @@ static const struct file_operations fops_memread = {
 };
 
 static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
+				    size_t count, loff_t *ppos)
 {
 	enum { max_count = 4096 };
 	struct debugfs_blob_wrapper *blob = file->private_data;
@@ -474,6 +481,7 @@ struct dentry *wil_debugfs_create_ioblob(const char *name,
 {
 	return debugfs_create_file(name, mode, parent, blob, &fops_ioblob);
 }
+
 /*---reset---*/
 static ssize_t wil_write_file_reset(struct file *file, const char __user *buf,
 				    size_t len, loff_t *ppos)
@@ -499,6 +507,7 @@ static const struct file_operations fops_reset = {
 	.write = wil_write_file_reset,
 	.open  = simple_open,
 };
+
 /*---write channel 1..4 to rxon for it, 0 to rxoff---*/
 static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 				   size_t len, loff_t *ppos)
@@ -509,6 +518,7 @@ static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 	bool on;
 
 	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
+
 	if (!kbuf)
 		return -ENOMEM;
 	if (copy_from_user(kbuf, buf, len)) {
@@ -545,6 +555,7 @@ static const struct file_operations fops_rxon = {
 	.write = wil_write_file_rxon,
 	.open  = simple_open,
 };
+
 /*---tx_mgmt---*/
 /* Write mgmt frame to this file to send it */
 static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
@@ -555,8 +566,8 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 	struct wireless_dev *wdev = wil_to_wdev(wil);
 	struct cfg80211_mgmt_tx_params params;
 	int rc;
-
 	void *frame = kmalloc(len, GFP_KERNEL);
+
 	if (!frame)
 		return -ENOMEM;
 
@@ -625,8 +636,10 @@ static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
 {
 	char printbuf[16 * 3 + 2];
 	int i = 0;
+
 	while (i < len) {
 		int l = min(len - i, 16);
+
 		hex_dump_to_buffer(p + i, l, 16, 1, printbuf,
 				   sizeof(printbuf), false);
 		seq_printf(s, "%s%s\n", prefix, printbuf);
@@ -664,10 +677,8 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 	struct wil6210_priv *wil = s->private;
 	struct vring *vring;
 	bool tx = (dbg_vring_index < WIL6210_MAX_TX_RINGS);
-	if (tx)
-		vring = &(wil->vring_tx[dbg_vring_index]);
-	else
-		vring = &wil->vring_rx;
+
+	vring = tx ? &wil->vring_tx[dbg_vring_index] : &wil->vring_rx;
 
 	if (!vring->va) {
 		if (tx)
@@ -682,7 +693,7 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 		 * only field used, .dma.length, is the same
 		 */
 		volatile struct vring_tx_desc *d =
-				&(vring->va[dbg_txdesc_index].tx);
+				&vring->va[dbg_txdesc_index].tx;
 		volatile u32 *u = (volatile u32 *)d;
 		struct sk_buff *skb = vring->ctx[dbg_txdesc_index].skb;
 
@@ -702,7 +713,7 @@ static int wil_txdesc_debugfs_show(struct seq_file *s, void *data)
 			wil_seq_print_skb(s, skb);
 			kfree_skb(skb);
 		}
-		seq_printf(s, "}\n");
+		seq_puts(s, "}\n");
 	} else {
 		if (tx)
 			seq_printf(s, "[%2d] TxDesc index (%d) >= size (%d)\n",
@@ -816,6 +827,7 @@ static const struct file_operations fops_bf = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 };
+
 /*---------SSID------------*/
 static ssize_t wil_read_file_ssid(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
@@ -878,10 +890,10 @@ static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	u32 t_m, t_r;
-
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
+
 	if (rc) {
-		seq_printf(s, "Failed\n");
+		seq_puts(s, "Failed\n");
 		return 0;
 	}
 
@@ -937,6 +949,7 @@ static int wil_link_debugfs_show(struct seq_file *s, void *data)
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
+
 		switch (p->status) {
 		case wil_sta_unused:
 			status = "unused   ";
@@ -997,7 +1010,6 @@ static int wil_info_debugfs_show(struct seq_file *s, void *data)
 	rxf_old = rxf;
 	txf_old = txf;
 
-
 #define CHECK_QSTATE(x) (state & BIT(__QUEUE_STATE_ ## x)) ? \
 	" " __stringify(x) : ""
 
@@ -1032,6 +1044,7 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 {
 	int i;
 	u16 index = ((r->head_seq_num - r->ssn) & 0xfff) % r->buf_size;
+
 	seq_printf(s, "0x%03x [", r->head_seq_num);
 	for (i = 0; i < r->buf_size; i++) {
 		if (i == index)
@@ -1050,6 +1063,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
+
 		switch (p->status) {
 		case wil_sta_unused:
 			status = "unused   ";
@@ -1067,6 +1081,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 		if (p->status == wil_sta_connected) {
 			for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
 				struct wil_tid_ampdu_rx *r = p->tid_rx[tid];
+
 				if (r) {
 					seq_printf(s, "[%2d] ", tid);
 					wil_print_rxtid(s, r);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7dfbcfb..4a884b4 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -71,6 +71,7 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 	struct wil_sta_info *sta = &wil->sta[cid];
+
 	wil_dbg_misc(wil, "%s(CID %d, status %d)\n", __func__, cid,
 		     sta->status);
 
@@ -227,6 +228,7 @@ static void wil_fw_error_worker(struct work_struct *work)
 static int wil_find_free_vring(struct wil6210_priv *wil)
 {
 	int i;
+
 	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		if (!wil->vring_tx[i].va)
 			return i;
@@ -391,7 +393,6 @@ static int wil_target_reset(struct wil6210_priv *wil)
 			W(RGF_PCIE_LOS_COUNTER_CTL, BIT(6) | BIT(8));
 			W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
 		}
-
 	}
 
 	/* TODO: check order here!!! Erez code is different */
@@ -436,6 +437,7 @@ static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
 	ulong to = msecs_to_jiffies(1000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
+
 	if (0 == left) {
 		wil_err(wil, "Firmware not ready\n");
 		return -ETIME;
@@ -461,9 +463,8 @@ int wil_reset(struct wil6210_priv *wil)
 	wil6210_disconnect(wil, NULL);
 
 	wil->status = 0; /* prevent NAPI from being scheduled */
-	if (test_bit(wil_status_napi_en, &wil->status)) {
+	if (test_bit(wil_status_napi_en, &wil->status))
 		napi_synchronize(&wil->napi_rx);
-	}
 
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 97c6a24..2b57069 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -183,6 +183,7 @@ struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 						int size, u16 ssn)
 {
 	struct wil_tid_ampdu_rx *r = kzalloc(sizeof(*r), GFP_KERNEL);
+
 	if (!r)
 		return NULL;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 2cc3569..ce0c4ba 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -52,6 +52,7 @@ static inline int wil_vring_is_full(struct vring *vring)
 {
 	return wil_vring_next_tail(vring) == vring->swhead;
 }
+
 /*
  * Available space in Tx Vring
  */
@@ -110,7 +111,8 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 	 * we can use any
 	 */
 	for (i = 0; i < vring->size; i++) {
-		volatile struct vring_tx_desc *_d = &(vring->va[i].tx);
+		volatile struct vring_tx_desc *_d = &vring->va[i].tx;
+
 		_d->dma.status = TX_DMA_STATUS_DU;
 	}
 
@@ -125,6 +127,7 @@ static void wil_txdesc_unmap(struct device *dev, struct vring_tx_desc *d,
 {
 	dma_addr_t pa = wil_desc_addr(&d->dma.addr);
 	u16 dmalen = le16_to_cpu(d->dma.length);
+
 	switch (ctx->mapped_as) {
 	case wil_mapped_as_single:
 		dma_unmap_single(dev, pa, dmalen, DMA_TO_DEVICE);
@@ -203,11 +206,12 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 	struct device *dev = wil_to_dev(wil);
 	unsigned int sz = RX_BUF_LEN;
 	struct vring_rx_desc dd, *d = &dd;
-	volatile struct vring_rx_desc *_d = &(vring->va[i].rx);
+	volatile struct vring_rx_desc *_d = &vring->va[i].rx;
 	dma_addr_t pa;
 
 	/* TODO align */
 	struct sk_buff *skb = dev_alloc_skb(sz + headroom);
+
 	if (unlikely(!skb))
 		return -ENOMEM;
 
@@ -286,9 +290,11 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 			 */
 			int len = min_t(int, 8 + sizeof(phy_data),
 					wil_rxdesc_phy_length(d));
+
 			if (len > 8) {
 				void *p = skb_tail_pointer(skb);
 				void *pa = PTR_ALIGN(p, 8);
+
 				if (skb_tailroom(skb) >= len + (pa - p)) {
 					phy_length = len - 8;
 					memcpy(phy_data, pa, phy_length);
@@ -384,13 +390,12 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	int cid;
 	struct wil_net_stats *stats;
 
-
 	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
 
 	if (wil_vring_is_empty(vring))
 		return NULL;
 
-	_d = &(vring->va[vring->swhead].rx);
+	_d = &vring->va[vring->swhead].rx;
 	if (!(_d->dma.status & RX_DMA_STATUS_DU)) {
 		/* it is not error, we just reached end of Rx done area */
 		return NULL;
@@ -544,7 +549,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 			[GRO_NORMAL]		= "GRO_NORMAL",
 			[GRO_DROP]		= "GRO_DROP",
 		};
-		wil_dbg_txrx(wil, "Rx complete %d bytes => %s,\n",
+		wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
 			     len, gro_res_str[rc]);
 	}
 }
@@ -585,7 +590,6 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 			else
 				wil_netif_rx_any(skb, ndev);
 		}
-
 	}
 	wil_rx_refill(wil, v->size);
 }
@@ -733,6 +737,7 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	for (i = 0; i < ARRAY_SIZE(wil->vring2cid_tid); i++) {
 		if (wil->vring2cid_tid[i][0] == cid) {
 			struct vring *v = &wil->vring_tx[i];
+
 			wil_dbg_txrx(wil, "%s(%pM) -> [%d]\n",
 				     __func__, eth->h_dest, i);
 			if (v->va) {
@@ -752,6 +757,7 @@ static void wil_set_da_for_vring(struct wil6210_priv *wil,
 {
 	struct ethhdr *eth = (void *)skb->data;
 	int cid = wil->vring2cid_tid[vring_index][0];
+
 	memcpy(eth->h_dest, wil->sta[cid].addr, ETH_ALEN);
 }
 
@@ -762,7 +768,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
  * duplicate skb and send it to other active vrings
  */
 static struct vring *wil_tx_bcast(struct wil6210_priv *wil,
-				       struct sk_buff *skb)
+				  struct sk_buff *skb)
 {
 	struct vring *v, *v2;
 	struct sk_buff *skb2;
@@ -845,8 +851,8 @@ void wil_tx_desc_set_nr_frags(struct vring_tx_desc *d, int nr_frags)
 }
 
 static int wil_tx_desc_offload_cksum_set(struct wil6210_priv *wil,
-				struct vring_tx_desc *d,
-				struct sk_buff *skb)
+					 struct vring_tx_desc *d,
+					 struct sk_buff *skb)
 {
 	int protocol;
 
@@ -914,10 +920,9 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			1 + nr_frags);
 		return -ENOMEM;
 	}
-	_d = &(vring->va[i].tx);
+	_d = &vring->va[i].tx;
 
-	pa = dma_map_single(dev, skb->data,
-			skb_headlen(skb), DMA_TO_DEVICE);
+	pa = dma_map_single(dev, skb->data, skb_headlen(skb), DMA_TO_DEVICE);
 
 	wil_dbg_txrx(wil, "Tx skb %d bytes 0x%p -> %pad\n", skb_headlen(skb),
 		     skb->data, &pa);
@@ -946,10 +951,11 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 		const struct skb_frag_struct *frag =
 				&skb_shinfo(skb)->frags[f];
 		int len = skb_frag_size(frag);
+
 		i = (swhead + f + 1) % vring->size;
-		_d = &(vring->va[i].tx);
+		_d = &vring->va[i].tx;
 		pa = skb_frag_dma_map(dev, frag, 0, skb_frag_size(frag),
-				DMA_TO_DEVICE);
+				      DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
 		vring->ctx[i].mapped_as = wil_mapped_as_page;
@@ -994,7 +1000,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 		i = (swhead + f) % vring->size;
 		ctx = &vring->ctx[i];
-		_d = &(vring->va[i].tx);
+		_d = &vring->va[i].tx;
 		*d = *_d;
 		_d->dma.status = TX_DMA_STATUS_DU;
 		wil_txdesc_unmap(dev, d, ctx);
@@ -1008,7 +1014,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	return -EINVAL;
 }
 
-
 netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
@@ -1036,15 +1041,15 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	pr_once_fw = false;
 
 	/* find vring */
-	if (is_unicast_ether_addr(eth->h_dest)) {
+	if (is_unicast_ether_addr(eth->h_dest))
 		vring = wil_find_tx_vring(wil, skb);
-	} else {
+	else
 		vring = wil_tx_bcast(wil, skb);
-	}
 	if (!vring) {
 		wil_dbg_txrx(wil, "No Tx VRING found for %pM\n", eth->h_dest);
 		goto drop;
 	}
+
 	/* set up vring entry */
 	rc = wil_tx_vring(wil, vring, skb);
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index a1ac4f8..979edf2 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -237,7 +237,6 @@ struct vring_tx_mac {
 #define DMA_CFG_DESC_TX_0_L4_TYPE_LEN 2
 #define DMA_CFG_DESC_TX_0_L4_TYPE_MSK 0xC0000000 /* L4 type: 0-UDP, 2-TCP */
 
-
 #define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_POS 0
 #define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_LEN 7
 #define DMA_CFG_DESC_TX_OFFLOAD_CFG_MAC_LEN_MSK 0x7F /* MAC hdr len */
@@ -246,7 +245,6 @@ struct vring_tx_mac {
 #define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_LEN 1
 #define DMA_CFG_DESC_TX_OFFLOAD_CFG_L3T_IPV4_MSK 0x80 /* 1-IPv4, 0-IPv6 */
 
-
 #define TX_DMA_STATUS_DU         BIT(0)
 
 struct vring_tx_dma {
@@ -347,7 +345,6 @@ struct vring_rx_mac {
 #define RX_DMA_ERROR_L3_ERR   BIT(4)
 #define RX_DMA_ERROR_L4_ERR   BIT(5)
 
-
 /* Status field */
 #define RX_DMA_STATUS_DU         BIT(0)
 #define RX_DMA_STATUS_ERROR      BIT(2)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 063beaf..5f20fab 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -164,6 +164,7 @@ struct fw_map {
 	u32 host; /* PCI/Host address - BAR0 + 0x880000 */
 	const char *name; /* for debugfs */
 };
+
 /* array size should be in sync with actual definition in the wmi.c */
 extern const struct fw_map fw_mapping[7];
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 490c278..97909f0 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -157,6 +157,7 @@ int wmi_read_hdr(struct wil6210_priv *wil, __le32 ptr,
 		 struct wil6210_mbox_hdr *hdr)
 {
 	void __iomem *src = wmi_buffer(wil, ptr);
+
 	if (!src)
 		return -EINVAL;
 
@@ -278,6 +279,7 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 	struct wmi_ready_event *evt = d;
+
 	wil->fw_version = le32_to_cpu(evt->sw_version);
 	wil->n_mids = evt->numof_additional_mids;
 
@@ -708,6 +710,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 			struct wil6210_mbox_hdr_wmi *wmi = &evt->event.wmi;
 			u16 id = le16_to_cpu(wmi->id);
 			u32 tstamp = le32_to_cpu(wmi->timestamp);
+
 			wil_dbg_wmi(wil, "WMI event 0x%04x MID %d @%d msec\n",
 				    id, wmi->mid, tstamp);
 			trace_wil6210_wmi_event(wmi, &wmi[1],
@@ -953,6 +956,7 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 	int rc;
 	u16 len = sizeof(struct wmi_set_appie_cmd) + ie_len;
 	struct wmi_set_appie_cmd *cmd = kzalloc(len, GFP_KERNEL);
+
 	if (!cmd)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 061618c..27b9743 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -179,7 +179,6 @@ enum wmi_crypto_type {
 	WMI_CRYPT_AES_GCMP		= 0x20,
 };
 
-
 enum wmi_connect_ctrl_flag_bits {
 	WMI_CONNECT_ASSOC_POLICY_USER		= 0x0001,
 	WMI_CONNECT_SEND_REASSOC		= 0x0002,
@@ -219,7 +218,6 @@ struct wmi_disconnect_sta_cmd {
 	__le16 disconnect_reason;
 } __packed;
 
-
 /*
  * WMI_SET_PMK_CMDID
  */
@@ -234,7 +232,6 @@ struct  wmi_set_pmk_cmd {
 	u8 pmk[WMI_PMK_LEN];
 } __packed;
 
-
 /*
  * WMI_SET_PASSPHRASE_CMDID
  */
@@ -273,7 +270,6 @@ struct wmi_delete_cipher_key_cmd {
 	u8 mac[WMI_MAC_LEN];
 } __packed;
 
-
 /*
  * WMI_START_SCAN_CMDID
  *
@@ -325,7 +321,6 @@ struct wmi_probed_ssid_cmd {
 	u8 ssid[WMI_MAX_SSID_LEN];
 } __packed;
 
-
 /*
  * WMI_SET_APPIE_CMDID
  * Add Application specified IE to a management frame
@@ -351,7 +346,6 @@ struct wmi_set_appie_cmd {
 	u8 ie_info[0];
 } __packed;
 
-
 /*
  * WMI_PXMT_RANGE_CFG_CMDID
  */
@@ -380,7 +374,6 @@ struct wmi_rf_mgmt_cmd {
 	__le32 rf_mgmt_type;
 } __packed;
 
-
 /*
  * WMI_RF_RX_TEST_CMDID
  */
@@ -426,7 +419,6 @@ struct wmi_bcon_ctrl_cmd {
 	u8 disable_sec;
 } __packed;
 
-
 /******* P2P ***********/
 
 /*
@@ -797,7 +789,6 @@ struct wmi_temp_sense_cmd {
 	__le32 measure_marlon_r_en;
 } __packed;
 
-
 /*
  * WMI Events
  */
@@ -887,7 +878,6 @@ enum wmi_event_id {
  * Events data structures
  */
 
-
 enum wmi_fw_status {
 	WMI_FW_STATUS_SUCCESS,
 	WMI_FW_STATUS_FAILURE,
@@ -1038,8 +1028,8 @@ struct wmi_disconnect_event {
 	__le16 protocol_reason_status;	/* reason code, see 802.11 spec. */
 	u8 bssid[WMI_MAC_LEN];		/* set if known */
 	u8 disconnect_reason;		/* see wmi_disconnect_reason */
-	u8 assoc_resp_len;		/* not in use */
-	u8 assoc_info[0];		/* not in use */
+	u8 assoc_resp_len;	/* not used */
+	u8 assoc_info[0];	/* not used */
 } __packed;
 
 /*
@@ -1081,7 +1071,6 @@ struct wmi_delba_event {
 	__le16 reason;
 } __packed;
 
-
 /*
  * WMI_VRING_CFG_DONE_EVENTID
  */
@@ -1147,7 +1136,6 @@ struct wmi_data_port_open_event {
 	u8 reserved[3];
 } __packed;
 
-
 /*
  * WMI_GET_PCP_CHANNEL_EVENTID
  */
@@ -1156,7 +1144,6 @@ struct wmi_get_pcp_channel_event {
 	u8 reserved[3];
 } __packed;
 
-
 /*
 * WMI_PORT_ALLOCATED_EVENTID
 */
@@ -1260,7 +1247,6 @@ struct wmi_rx_mgmt_info {
 	u8 channel;	/* From Radio MNGR */
 } __packed;
 
-
 /*
  * WMI_TX_MGMT_PACKET_EVENTID
  */
-- 
1.9.1

