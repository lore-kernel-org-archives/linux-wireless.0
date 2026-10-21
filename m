Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609557;
	b=bQ/JMUQw2Hu5ALyL3T2eDuL6m0PAmbtHYQgi1tdt+SQWd1reDNCVb3DAROxTnjCAOVyP
	 HnOvdj1JBXF5kM+UKDhVZbGERBFtTesBD6Nw1yOwEpG3/ChWtK0aZla9pDdGDrWe82eSA
	 /BudEZJxt0dR9tpdiauemhYaisGfNacZ8G+xX/1howe1Oq2nUo3LJshlX26r+vOc+XBhz
	 bC3pmWy9/Otd52Aq5O7yRlF8tM4U5bNE0965ouAWeEfNj1B73LR8Pulop+9k3nNIlum3M
	 U9GYrdxdLbwJfGGQ8yT3LBKYJLmJaSw+PajtKhPlR7ldrLOuWCRed39a8M4+TNwepAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609557;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I345JHLSSLy5DSMQp23RF7w5TAfymNdKQaiRSxlQIQ0=;
	b=OS6QXIul1bGZNNF3Drnb9h2mmldIoGkG+lvCTAQCmpLdwyiJXP3RAyM1Dyqyjm7JbDLH
	 dvl/pWgftfanKtgVRehv8WkKxtQro7WxSTPv7dMyUPprYVH+Kl7/ufYTOgPfTPwHaR6Za
	 vpj706u1mBb1d2uKiAFKiOvpWPvIOAN4HktCcUj5Gdh/MHoJrfNzbcuvpxUEXpG1XbfEa
	 CLxfqwQTBTY7VkXi6W9SCvWQYrY7kSj0qiAoFf2uWvmT+3wmbivLcs8EZAtNwiAJmON/U
	 FlpSihIvTB5s3e5PyltxCvIAOQm9TU2ivXlxXN2DCSfhRTyY++EavMOHmd5tsnPFVfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=SdVuA5yT;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A97B606A325
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A97B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=SdVuA5yT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792609555;
	bh=gkYedKxQPqrcpTi1+UHX8DwS2/mSTMVCfdbMH7ff8+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdVuA5yT6PHdJF/8/lvw6xniy19qGH7bHloX06uZHPxq6oYdzpHr12hQfieKRWE4I
	 kR3eQrCOLqEDZbMqXTQbUdtv/iP7tdVh8UcdtfWbi2mI4MVUQ5cVGuaWh+khRp3fuM
	 WkUkErvvmKNvyKSjCK932uXeNUzQE86hCd8OBm0eNNKyKh7iLVxEEBGaMIbTNoxN/P
	 OMmRuLyYMJcWBez5M+lR9xHr0Dm3aPDXxMKcpV2RCXF12JSMH+j3QZhaLa0r9TaOT6
	 Is1sN2C7aW8p0mvUPowrnB4svcmh22+CI5YnHhjEU12Ayhe/mgIr+Q5lDsW0mUUJFc
	 2fX/oBeyrjV4w==
Received: from hermes-devbox.localdomain (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C51C017E07EC;
	Wed, 21 Oct 2026 21:05:54 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>,
	matthew.leach@collabora.com,
	kernel@collabora.com
Subject: [RFC PATCH rtw-next 3/5] wifi: rtw88: pci: optional RX buffer poisoning and recheck
Date: Wed, 21 Oct 2026 20:05:22 +0100
Message-ID: <20261021190529.3893821-4-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021190529.3893821-1-bob.beckett@collabora.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Robert Beckett <bob.beckett@collabora.com>

Debug aid for the 8822CE 5 GHz replay-counter poisoning reported in
https://lore.kernel.org/linux-wireless/20261016191100.1781056-1-bob.beckett@collabora.com/

The bad frames have a valid RX descriptor and 802.11 header but foreign
bytes from the CCMP header on. On the list three explanations are open:
the device stopped writing after the header, the driver consumed the
buffer before the remaining writes were visible, or the device wrote the
wrong data (e.g. from the wrong place in its RX FIFO).

With rtw88_pci.rx_debug=Y (read when the rings are set up, so set it at
module load):
- RX buffers are mapped DMA_BIDIRECTIONAL and bytes [24, 256) of every
  buffer are filled with a position-dependent pattern before the buffer
  is handed to the device, also reaching a swiotlb bounce buffer;
- for each frame the core reports as suspect, the poison left in the
  drv_info area and in the frame's own bytes after the 802.11 header is
  counted, the head of the buffer is synced for the CPU again after
  100us, and any change is reported and dumped. Reports follow the
  suspect-frame budget (full for the first ones, then rate limited),
  except that a reread that changed is always reported in full.

Poison after the header means the device never wrote those bytes;
foreign non-poison bytes mean it wrote the wrong data; bytes that change
on the reread mean the buffer was consumed before the device finished.

Without the parameter nothing changes.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/wireless/realtek/rtw88/main.h |   1 +
 drivers/net/wireless/realtek/rtw88/pci.c  | 131 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/pci.h  |   2 +
 drivers/net/wireless/realtek/rtw88/rx.c   |   2 +
 4 files changed, 131 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 49f13034db4d..295af5529fcc 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -659,6 +659,7 @@ struct rtw_rx_pkt_stat {
 	bool decrypted;
 	bool is_c2h;
 	bool channel_invalid;
+	bool suspect;
 
 	s32 signal_power;
 	u16 pkt_len;
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 69f2840fed09..d65408084f72 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -22,6 +22,36 @@ module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
 MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
 MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
 
+static bool rtw_pci_rx_debug;
+module_param_named(rx_debug, rtw_pci_rx_debug, bool, 0644);
+MODULE_PARM_DESC(rx_debug,
+		 "Set Y to poison RX buffers and recheck suspect frames (debug, takes effect at probe)");
+
+/* With rx_debug, bytes [RTW_PCI_RX_POISON_START, RTW_PCI_RX_POISON_END) of
+ * every RX buffer are filled with a known pattern before the buffer is
+ * handed to the device, and frames the core reports as suspect are read
+ * again after a short delay. That shows whether the device wrote the bytes
+ * after the 802.11 header at all, and whether they were still changing when
+ * the driver consumed the buffer. The buffers are mapped bidirectionally so
+ * that the pattern also reaches a swiotlb bounce buffer.
+ */
+#define RTW_PCI_RX_POISON_START	24
+#define RTW_PCI_RX_POISON_END	256
+#define RTW_PCI_RX_RECHECK_US	100
+
+static u8 rtw_pci_rx_poison_byte(u32 off)
+{
+	return 0xa5 ^ (u8)off;
+}
+
+static void rtw_pci_rx_poison(struct sk_buff *skb)
+{
+	u32 i;
+
+	for (i = RTW_PCI_RX_POISON_START; i < RTW_PCI_RX_POISON_END; i++)
+		skb->data[i] = rtw_pci_rx_poison_byte(i);
+}
+
 static const u32 rtw_pci_tx_queue_idx_addr[] = {
 	[RTW_TX_QUEUE_BK]	= RTK_PCI_TXBD_IDX_BKQ,
 	[RTW_TX_QUEUE_BE]	= RTK_PCI_TXBD_IDX_BEQ,
@@ -128,6 +158,7 @@ static void rtw_pci_free_tx_ring(struct rtw_dev *rtwdev,
 static void rtw_pci_free_rx_ring_skbs(struct rtw_dev *rtwdev,
 				      struct rtw_pci_rx_ring *rx_ring)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
 	struct sk_buff *skb;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
@@ -140,7 +171,7 @@ static void rtw_pci_free_rx_ring_skbs(struct rtw_dev *rtwdev,
 			continue;
 
 		dma = *((dma_addr_t *)skb->cb);
-		dma_unmap_single(&pdev->dev, dma, buf_sz, DMA_FROM_DEVICE);
+		dma_unmap_single(&pdev->dev, dma, buf_sz, rtwpci->rx_dma_dir);
 		dev_kfree_skb(skb);
 		rx_ring->buf[i] = NULL;
 	}
@@ -211,6 +242,7 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 				 struct rtw_pci_rx_ring *rx_ring,
 				 u32 idx, u32 desc_sz)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
 	struct rtw_pci_rx_buffer_desc *buf_desc;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
@@ -219,7 +251,10 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	if (!skb)
 		return -EINVAL;
 
-	dma = dma_map_single(&pdev->dev, skb->data, buf_sz, DMA_FROM_DEVICE);
+	if (rtwpci->rx_debug)
+		rtw_pci_rx_poison(skb);
+
+	dma = dma_map_single(&pdev->dev, skb->data, buf_sz, rtwpci->rx_dma_dir);
 	if (dma_mapping_error(&pdev->dev, dma))
 		return -EBUSY;
 
@@ -237,11 +272,22 @@ static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
 					struct rtw_pci_rx_ring *rx_ring,
 					u32 idx, u32 desc_sz)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct device *dev = rtwdev->dev;
 	struct rtw_pci_rx_buffer_desc *buf_desc;
 	int buf_sz = RTK_PCI_RX_BUF_SIZE;
 
-	dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
+	if (rtwpci->rx_debug) {
+		/* Only the poisoned head needs to reach the device copy;
+		 * the CPU did not write the rest of the buffer.
+		 */
+		rtw_pci_rx_poison(rx_ring->buf[idx]);
+		dma_sync_single_range_for_device(dev, dma, 0,
+						 RTW_PCI_RX_POISON_END,
+						 DMA_BIDIRECTIONAL);
+	} else {
+		dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
+	}
 
 	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
 						     idx * desc_sz);
@@ -254,6 +300,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 				struct rtw_pci_rx_ring *rx_ring,
 				u8 desc_size, u32 len)
 {
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
 	struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
 	struct sk_buff *skb = NULL;
 	dma_addr_t dma;
@@ -302,7 +349,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 		if (!skb)
 			continue;
 		dma = *((dma_addr_t *)skb->cb);
-		dma_unmap_single(&pdev->dev, dma, buf_sz, DMA_FROM_DEVICE);
+		dma_unmap_single(&pdev->dev, dma, buf_sz, rtwpci->rx_dma_dir);
 		dev_kfree_skb_any(skb);
 		rx_ring->buf[i] = NULL;
 	}
@@ -324,6 +371,13 @@ static int rtw_pci_init_trx_ring(struct rtw_dev *rtwdev)
 	u32 len;
 	int ret;
 
+	rtwpci->rx_debug = READ_ONCE(rtw_pci_rx_debug);
+	rtwpci->rx_dma_dir = rtwpci->rx_debug ? DMA_BIDIRECTIONAL :
+						DMA_FROM_DEVICE;
+	if (rtwpci->rx_debug)
+		rtw_info(rtwdev, "rx_debug: poisoning RX buffers [%u, %u)\n",
+			 RTW_PCI_RX_POISON_START, RTW_PCI_RX_POISON_END);
+
 	tx_desc_size = chip->tx_buf_desc_sz;
 
 	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
@@ -1039,6 +1093,69 @@ static int rtw_pci_get_hw_rx_ring_nr(struct rtw_dev *rtwdev,
 	return count;
 }
 
+/* Called for a frame the core reported as suspect, with the buffer synced
+ * for the CPU. Count how much of the poison survived in the drv_info area
+ * and after the 802.11 header, then read the head of the buffer again a
+ * little later to see whether the device was still writing to it.
+ */
+static void rtw_pci_rx_debug_recheck(struct rtw_dev *rtwdev,
+				     struct rtw_pci *rtwpci,
+				     struct sk_buff *skb, dma_addr_t dma,
+				     u32 idx, struct rtw_rx_pkt_stat *pkt_stat)
+{
+	u32 drv_start = rtwdev->chip->rx_pkt_desc_sz + pkt_stat->shift;
+	u32 drv_end = drv_start + pkt_stat->drv_info_sz;
+	u32 hdr_off = (u8 *)pkt_stat->hdr - skb->data;
+	u32 tail_start = hdr_off + ieee80211_hdrlen(pkt_stat->hdr->frame_control);
+	/* only bytes that belong to the frame; shorter frames leave poison */
+	u32 tail_end = min_t(u32, hdr_off + pkt_stat->pkt_len,
+			     RTW_PCI_RX_POISON_END);
+	u32 tail_len = tail_end > tail_start ? tail_end - tail_start : 0;
+	u32 drv_len = drv_end > drv_start ? drv_end - drv_start : 0;
+	u32 drv_poison = 0, tail_poison = 0, changed = 0, first_changed = 0;
+	u8 before[RTW_PCI_RX_POISON_END];
+	u32 i;
+
+	memcpy(before, skb->data, sizeof(before));
+
+	for (i = max_t(u32, drv_start, RTW_PCI_RX_POISON_START);
+	     i < min_t(u32, drv_end, RTW_PCI_RX_POISON_END); i++)
+		drv_poison += before[i] == rtw_pci_rx_poison_byte(i);
+	for (i = tail_start; i < tail_end; i++)
+		tail_poison += before[i] == rtw_pci_rx_poison_byte(i);
+
+	udelay(RTW_PCI_RX_RECHECK_US);
+	dma_sync_single_range_for_cpu(rtwdev->dev, dma, 0,
+				      RTW_PCI_RX_POISON_END, rtwpci->rx_dma_dir);
+
+	for (i = 0; i < RTW_PCI_RX_POISON_END; i++) {
+		if (skb->data[i] == before[i])
+			continue;
+		if (!changed)
+			first_changed = i;
+		changed++;
+	}
+
+	/* a changed reread is the interesting case, always report it in full */
+	if (!changed && rtwdev->rx_pn_guard.events > RTW_RX_PN_GUARD_DUMPS) {
+		dev_warn_ratelimited(rtwdev->dev,
+				     "rx_debug: ring %u: drv_info %u/%u poison, after header %u/%u poison, %u bytes changed\n",
+				     idx, drv_poison, drv_len, tail_poison, tail_len,
+				     changed);
+		return;
+	}
+
+	rtw_warn(rtwdev,
+		 "rx_debug: ring %u: drv_info %u/%u poison, after header [%u,%u) %u/%u poison, %u bytes changed after %uus (first at %u)\n",
+		 idx, drv_poison, drv_len, tail_start, tail_end,
+		 tail_poison, tail_len, changed, RTW_PCI_RX_RECHECK_US,
+		 first_changed);
+	if (changed)
+		print_hex_dump(KERN_WARNING, "rtw88 rx reread: ",
+			       DUMP_PREFIX_OFFSET, 16, 1, skb->data,
+			       RTW_PCI_RX_POISON_END, false);
+}
+
 static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 			   u8 hw_queue, u32 limit)
 {
@@ -1066,13 +1183,17 @@ static u32 rtw_pci_rx_napi(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		skb = ring->buf[cur_rp];
 		dma = *((dma_addr_t *)skb->cb);
 		dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_SIZE,
-					DMA_FROM_DEVICE);
+					rtwpci->rx_dma_dir);
 		rx_desc = skb->data;
 		ret = rtw_rx_query_rx_desc(rtwdev, rx_desc,
 					   &pkt_stat, &rx_status);
 		if (ret)
 			goto next_rp;
 
+		if (unlikely(rtwpci->rx_debug && pkt_stat.suspect))
+			rtw_pci_rx_debug_recheck(rtwdev, rtwpci, skb, dma,
+						 cur_rp, &pkt_stat);
+
 		/* offset from rx_desc to payload */
 		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
 			     pkt_stat.shift;
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 8ffdea11378f..4a08554512f7 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -225,6 +225,8 @@ struct rtw_pci {
 	u16 link_ctrl;
 	atomic_t link_usage;
 	bool rx_no_aspm;
+	bool rx_debug;
+	enum dma_data_direction rx_dma_dir;
 	DECLARE_BITMAP(flags, NUM_OF_RTW_PCI_FLAGS);
 
 	void __iomem *mmap;
diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index 7e6b0022ad50..d29b4bed2ad3 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -306,6 +306,8 @@ static void rtw_rx_report_suspect(struct rtw_dev *rtwdev, const char *why,
 	if (pkt_stat->pkt_len >= hdr_len + IEEE80211_CCMP_HDR_LEN)
 		pn = rtw_rx_ccmp_pn((u8 *)hdr + hdr_len);
 
+	pkt_stat->suspect = true;
+
 	if (n > RTW_RX_PN_GUARD_DUMPS) {
 		dev_warn_ratelimited(rtwdev->dev,
 				     "suspect hw-decrypted frame #%u (%s): tid %u max pn 0x%012llx pn 0x%012llx%s\n",
-- 
2.55.0

