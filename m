Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0E6380FF0
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292490; cv=none; b=gPq7P6bn5iWYSKunke/zHalj2NrCn5nNQow8eTnHI3fffgRnJZA0tmQIYTg5Ci5RBZW71GduAG0SXJA9jFPdDDapOgl5Q3Kgv2r0pqIoCyvXgiZL+3cNkPLkAU8CBk/osgsmhDHQArBa0lRO7i6J4fvD+ZSuMONu1wYN3ftML3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292490; c=relaxed/simple;
	bh=TPm0PJEApfs0asqnoCVyO4Sv/XMBV+MJJZHLOTYSAR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkBoHVa0hYc2PpvTBXngbPwCUeUUMoDwYZoGxHxvd8VHXHv6K64+x1Jg1YlKpB2aT+rp69FCMtHVN2vNVfImQDDi4bXy193//Npka0y4FXvSf0MiQTvKUJ+gF8Q61DEdP0Ls2m1Nyrw1gycXVWrIdKeXP21nDfvY74UgrNCslTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AV+PcggD; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AV+PcggD"
X-UUID: 0b12a2588af611f18dc8c9802ae25ab1-20260729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=bUZ3yzFEP9EJpb4Alw/DrlPrdBce2aj5MYJvZo91Xro=;
	b=AV+PcggD47+ToYTbZnJdWki4h5klq4Af+O6tA7uwDqP4ZS38P2m2YCDqFLg1T3lbi5neWnevGrAhovLbCfa4BDnLEkDg8ANacGw+l26Kxcp2hZziLHqQTv8tTNrAdSwqvYOeanNufH7KRC39Kcia2fomExyQFoqQfxtpQ6kQw5o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:91cbb512-ea33-421c-a78a-43e483c98f49,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:8a735a6,CLOUDID:d05d963b-0769-4b9a-8185-266a4e6c9483,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|136|836|865|888|898,TC:-5,Content:0|
	15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0b12a2588af611f18dc8c9802ae25ab1-20260729
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 610287908; Wed, 29 Jul 2026 10:34:37 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 29 Jul 2026 10:34:36 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 29 Jul 2026 10:34:36 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <eason.lai@mediatek.com>
Subject: [PATCH v2 2/3] wifi: mt76: mt792x: Add TX page pool support for IOMMU-enabled systems
Date: Wed, 29 Jul 2026 10:34:33 +0800
Message-ID: <20260729023434.1105517-3-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260729023434.1105517-1-eason.lai@mediatek.com>
References: <20260709075558.1654164-1-eason.lai@mediatek.com>
 <20260729023434.1105517-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Add support for TX page pool allocation in mt792x devices when IOMMU is
enabled. This optimization reduces DMA mapping overhead by
pre-allocating and reusing page pool buffers for TX operations.

With high IOMMU overhead on certain platforms, HE160 TCP UL peak
throughput could drop below 1.4Gbps. With this patch, throughput reaches
the expected performance (>1.8Gbps).

Key changes:
- Add tx_prealloc_enabled flag to track page pool state
- Implement mt792x-specific DMA queue operations with TX page pool
- Create page pools per TX queue when IOMMU is detected
- Handle page pool buffer cleanup in both success and error paths
- Add proper skip_unmap flag handling for page pool buffers

The page pool path is used for linear skbs without fragments, falling
back to standard DMA mapping for complex skb structures.

Signed-off-by: Eason Lai <eason.lai@mediatek.com>
---
v2:
- Add test result in commit message
- Remove unnecessary condition check in mt792x_create_tx_page_pool()
- Integrate mt792x_dma_tx_cleanup() back to mt76_dma_tx_cleanup()
- Refine mt792x_dma_attach()
- Use mt76_queue_kick() instead of exporting DMA helper functions
---
 drivers/net/wireless/mediatek/mt76/dma.c      |  13 +-
 drivers/net/wireless/mediatek/mt76/dma.h      |   3 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |   3 +
 .../wireless/mediatek/mt76/mt76_connac_mac.c  |   6 +
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   1 +
 .../net/wireless/mediatek/mt76/mt792x_dma.c   | 271 +++++++++++++++++-
 7 files changed, 296 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 57632656eafa..e56d0414d487 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -4,6 +4,8 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/iommu.h>
+#include <net/page_pool/helpers.h>
 #include "mt76.h"
 #include "dma.h"
 #include "mt76_connac.h"
@@ -80,7 +82,7 @@ __mt76_get_rxwi(struct mt76_dev *dev)
 	return t;
 }
 
-static struct mt76_txwi_cache *
+struct mt76_txwi_cache *
 mt76_get_txwi(struct mt76_dev *dev)
 {
 	struct mt76_txwi_cache *t = __mt76_get_txwi(dev);
@@ -93,6 +95,7 @@ mt76_get_txwi(struct mt76_dev *dev)
 
 	return mt76_alloc_txwi(dev);
 }
+EXPORT_SYMBOL_GPL(mt76_get_txwi);
 
 struct mt76_txwi_cache *
 mt76_get_rxwi(struct mt76_dev *dev)
@@ -323,7 +326,7 @@ mt76_dma_add_rx_buf(struct mt76_dev *dev, struct mt76_queue *q,
 	return idx;
 }
 
-static int
+int
 mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 		 struct mt76_queue_buf *buf, int nbufs, u32 info,
 		 struct sk_buff *skb, void *txwi)
@@ -391,6 +394,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 
 	return idx;
 }
+EXPORT_SYMBOL_GPL(mt76_dma_add_buf);
 
 static void
 mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
@@ -444,6 +448,11 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, struct mt76_queue *q, bool flush)
 		mt76_queue_tx_complete(dev, q, &entry);
 
 		if (entry.txwi) {
+			if (entry.skb && entry.txwi->ptr) {
+				mt76_put_page_pool_buf(entry.txwi->ptr, false);
+				entry.txwi->ptr = NULL;
+			}
+
 			if (!(dev->drv->drv_flags & MT_DRV_TXWI_NO_FREE))
 				mt76_put_txwi(dev, entry.txwi);
 		}
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index a2cf82cfdaaa..53f9d7d3075c 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -170,6 +170,9 @@ int mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q,
 		     bool allow_direct);
 void mt76_dma_queue_reset(struct mt76_dev *dev, struct mt76_queue *q,
 			  bool reset_idx);
+int mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
+		     struct mt76_queue_buf *buf, int nbufs, u32 info,
+		     struct sk_buff *skb, void *txwi);
 
 static inline void
 mt76_dma_reset_tx_queue(struct mt76_dev *dev, struct mt76_queue *q)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index ec679d12a2af..291127222e67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -962,6 +962,8 @@ struct mt76_dev {
 	int tx_dma_idx[4];
 	enum mt76_hwrro_mode hwrro_mode;
 
+	bool tx_prealloc_enabled;
+
 	struct mt76_worker tx_worker;
 	struct napi_struct tx_napi;
 
@@ -1790,6 +1792,7 @@ mt76_tx_status_get_hw(struct mt76_dev *dev, struct sk_buff *skb)
 
 void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
 void mt76_put_rxwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
+struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
 struct mt76_txwi_cache *mt76_get_rxwi(struct mt76_dev *dev);
 void mt76_free_pending_rxwi(struct mt76_dev *dev);
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 0ac3ab42ea40..022f86a73287 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -250,6 +250,12 @@ void mt76_connac_txp_skb_unmap(struct mt76_dev *dev,
 {
 	struct mt76_connac_txp_common *txp;
 
+	if (t->ptr) {
+		mt76_put_page_pool_buf(t->ptr, false);
+		t->ptr = NULL;
+		return;
+	}
+
 	txp = mt76_connac_txwi_to_txp(dev, t);
 	if (is_mt76_fw_txp(dev))
 		mt76_connac_txp_skb_unmap_fw(dev, &txp->fw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 4e734f4f65d1..1d2d67f03042 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -470,6 +470,8 @@ static int mt7925_dma_init(struct mt792x_dev *dev)
 			  mt792x_poll_tx);
 	napi_enable(&dev->mt76.tx_napi);
 
+	mt792x_dma_tx_page_pool_init(dev);
+
 	return mt792x_dma_enable(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9567ff883b28..ee5fbd4ba307 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -503,6 +503,7 @@ void mt792x_dma_cleanup(struct mt792x_dev *dev);
 int mt792x_dma_alloc_queues(struct mt792x_dev *dev,
 			    const struct mt792x_dma_layout *layout);
 int mt792x_dma_enable(struct mt792x_dev *dev);
+int mt792x_dma_tx_page_pool_init(struct mt792x_dev *dev);
 int mt792x_wpdma_reset(struct mt792x_dev *dev, bool force);
 int mt792x_wpdma_reinit_cond(struct mt792x_dev *dev);
 int mt792x_dma_disable(struct mt792x_dev *dev, bool force);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
index 8ad94fa58340..9f052c56d1b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
@@ -3,11 +3,16 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/iommu.h>
+#include <net/page_pool/helpers.h>
+#include <linux/of.h>
 
 #include "mt792x.h"
 #include "dma.h"
 #include "trace.h"
 
+static void mt792x_dma_attach(struct mt76_dev *dev);
+
 irqreturn_t mt792x_irq_handler(int irq, void *dev_instance)
 {
 	struct mt792x_dev *dev = dev_instance;
@@ -90,7 +95,7 @@ int mt792x_dma_alloc_queues(struct mt792x_dev *dev,
 {
 	int ret;
 
-	mt76_dma_attach(&dev->mt76);
+	mt792x_dma_attach(&dev->mt76);
 
 	ret = mt792x_dma_disable(dev, true);
 	if (ret)
@@ -441,6 +446,268 @@ int mt792x_wpdma_reinit_cond(struct mt792x_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt792x_wpdma_reinit_cond);
 
+static int mt792x_create_tx_page_pool(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = 0,
+		.nid = NUMA_NO_NODE,
+		.dev = dev->dma_dev,
+	};
+
+	pp_params.pool_size = 256;
+	pp_params.flags |= PP_FLAG_DMA_MAP;
+	pp_params.dma_dir = DMA_BIDIRECTIONAL;
+	pp_params.max_len = PAGE_SIZE;
+	pp_params.offset = 0;
+
+	q->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(q->page_pool)) {
+		int err = PTR_ERR(q->page_pool);
+
+		q->page_pool = NULL;
+		dev_warn(dev->dev, "Failed to create TX page pool for queue %d (err=%d)\n",
+			 q->hw_idx, err);
+		return 0;
+	}
+
+	return 0;
+}
+
+int mt792x_dma_tx_page_pool_init(struct mt792x_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	int i, ret, pool_count = 0;
+
+	if (!iommu_get_domain_for_dev(mdev->dma_dev))
+		return 0;
+
+	if (!mt76_is_mmio(mdev))
+		return 0;
+
+	mdev->tx_prealloc_enabled = true;
+
+	for (i = 0; i < ARRAY_SIZE(mdev->phy.q_tx); i++) {
+		struct mt76_queue *q = mdev->phy.q_tx[i];
+
+		if (!q)
+			continue;
+
+		ret = mt792x_create_tx_page_pool(mdev, q);
+		if (ret)
+			return ret;
+
+		if (q->page_pool)
+			pool_count++;
+	}
+
+	if (pool_count > 0)
+		dev_info(mdev->dev,
+			 "IOMMU enabled, created %d TX page pools\n", pool_count);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt792x_dma_tx_page_pool_init);
+
+static void mt792x_dma_tx_page_pool_cleanup(struct mt792x_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mdev->phy.q_tx); i++) {
+		struct mt76_queue *q = mdev->phy.q_tx[i];
+
+		if (!q || !q->page_pool)
+			continue;
+
+		page_pool_destroy(q->page_pool);
+		q->page_pool = NULL;
+	}
+
+	mdev->tx_prealloc_enabled = false;
+}
+
+static void *
+mt792x_dma_tx_alloc_page_pool_buf(struct mt76_dev *dev, struct mt76_queue *q,
+				  struct sk_buff *skb, dma_addr_t *dma_addr,
+				  int *buf_len)
+{
+	struct page *page;
+	void *buf;
+	int len;
+	u32 offset;
+
+	if (!q->page_pool || !dev->tx_prealloc_enabled)
+		return NULL;
+
+	len = skb_headlen(skb);
+	if (len > PAGE_SIZE)
+		return NULL;
+
+	buf = mt76_get_page_pool_buf(q, &offset, len);
+	if (!buf)
+		return NULL;
+
+	page = virt_to_head_page(buf);
+	*dma_addr = page_pool_get_dma_addr(page) + offset;
+	if (unlikely(!*dma_addr)) {
+		dev_warn_ratelimited(dev->dev, "Page pool returned NULL DMA address\n");
+		mt76_put_page_pool_buf(buf, false);
+		return NULL;
+	}
+
+	*buf_len = len;
+
+	dma_sync_single_for_cpu(dev->dma_dev, *dma_addr, len, DMA_TO_DEVICE);
+	skb_copy_from_linear_data(skb, buf, len);
+	dma_sync_single_for_device(dev->dma_dev, *dma_addr, len, DMA_TO_DEVICE);
+
+	return buf;
+}
+
+static int
+mt792x_dma_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
+			enum mt76_txq_id qid, struct sk_buff *skb,
+			struct mt76_wcid *wcid, struct ieee80211_sta *sta)
+{
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
+	struct mt76_tx_info tx_info = {
+		.skb = skb,
+	};
+	struct mt76_dev *dev = phy->dev;
+	struct ieee80211_hw *hw;
+	int len, n = 0, ret = -ENOMEM;
+	struct mt76_txwi_cache *t;
+	struct sk_buff *iter;
+	dma_addr_t addr;
+	u8 *txwi;
+
+	if (test_bit(MT76_RESET, &phy->state))
+		goto free_skb;
+
+	t = mt76_get_txwi(dev);
+	if (!t)
+		goto free_skb;
+
+	txwi = mt76_get_txwi_ptr(dev, t);
+
+	skb->prev = NULL;
+	skb->next = NULL;
+	if (dev->drv->drv_flags & MT_DRV_TX_ALIGNED4_SKBS)
+		mt76_insert_hdr_pad(skb);
+
+	len = skb_headlen(skb);
+
+	if (dev->tx_prealloc_enabled && q->page_pool &&
+	    !skb_has_frag_list(skb) && !skb_shinfo(skb)->nr_frags) {
+		void *buf;
+		int pp_len;
+
+		buf = mt792x_dma_tx_alloc_page_pool_buf(dev, q, skb, &addr, &pp_len);
+		if (buf) {
+			t->ptr = buf;
+			len = pp_len;
+
+			tx_info.buf[n].addr = t->dma_addr;
+			tx_info.buf[n++].len = dev->drv->txwi_size;
+			tx_info.buf[n].addr = addr;
+			tx_info.buf[n].len = len;
+			tx_info.buf[n].skip_unmap = true;
+			n++;
+
+			goto skip_dma_map;
+		}
+	}
+
+	addr = dma_map_single(dev->dma_dev, skb->data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
+		goto free;
+
+	t->ptr = NULL;
+
+	tx_info.buf[n].addr = t->dma_addr;
+	tx_info.buf[n++].len = dev->drv->txwi_size;
+	tx_info.buf[n].addr = addr;
+	tx_info.buf[n++].len = len;
+
+skip_dma_map:
+	skb_walk_frags(skb, iter) {
+		if (n == ARRAY_SIZE(tx_info.buf))
+			goto unmap;
+
+		addr = dma_map_single(dev->dma_dev, iter->data, iter->len,
+				      DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
+			goto unmap;
+
+		tx_info.buf[n].addr = addr;
+		tx_info.buf[n].skip_unmap = false;
+		tx_info.buf[n++].len = iter->len;
+	}
+	tx_info.nbuf = n;
+
+	if (q->queued + (tx_info.nbuf + 1) / 2 >= q->ndesc - 1) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
+
+	dma_sync_single_for_cpu(dev->dma_dev, t->dma_addr, dev->drv->txwi_size,
+				DMA_TO_DEVICE);
+	ret = dev->drv->tx_prepare_skb(dev, txwi, qid, wcid, sta, &tx_info);
+	dma_sync_single_for_device(dev->dma_dev, t->dma_addr, dev->drv->txwi_size,
+				   DMA_TO_DEVICE);
+	if (ret < 0)
+		goto unmap;
+
+	return mt76_dma_add_buf(dev, q, tx_info.buf, tx_info.nbuf,
+				tx_info.info, tx_info.skb, t);
+
+unmap:
+	for (n--; n > 0; n--) {
+		if (!tx_info.buf[n].skip_unmap)
+			dma_unmap_single(dev->dma_dev, tx_info.buf[n].addr,
+					 tx_info.buf[n].len, DMA_TO_DEVICE);
+	}
+
+	if (t->ptr) {
+		mt76_put_page_pool_buf(t->ptr, false);
+		t->ptr = NULL;
+	}
+
+free:
+#ifdef CONFIG_NL80211_TESTMODE
+	if (mt76_is_testmode_skb(dev, skb, &hw)) {
+		struct mt76_phy *phy = hw->priv;
+
+		if (tx_info.skb == phy->test.tx_skb)
+			phy->test.tx_done--;
+	}
+#endif
+
+	mt76_put_txwi(dev, t);
+
+free_skb:
+	status.skb = tx_info.skb;
+	hw = mt76_tx_status_get_hw(dev, tx_info.skb);
+	spin_lock_bh(&dev->rx_lock);
+	ieee80211_tx_status_ext(hw, &status);
+	spin_unlock_bh(&dev->rx_lock);
+
+	return ret;
+}
+
+static struct mt76_queue_ops mt792x_queue_ops;
+
+static void mt792x_dma_attach(struct mt76_dev *dev)
+{
+	mt76_dma_attach(dev);
+	mt792x_queue_ops = *dev->queue_ops;
+	mt792x_queue_ops.tx_queue_skb = mt792x_dma_tx_queue_skb;
+	dev->queue_ops = &mt792x_queue_ops;
+}
+
 int mt792x_dma_disable(struct mt792x_dev *dev, bool force)
 {
 	/* disable WFDMA0 */
@@ -506,6 +773,8 @@ void mt792x_dma_cleanup(struct mt792x_dev *dev)
 		 MT_WFDMA0_RST_LOGIC_RST);
 
 	mt76_dma_cleanup(&dev->mt76);
+
+	mt792x_dma_tx_page_pool_cleanup(dev);
 }
 EXPORT_SYMBOL_GPL(mt792x_dma_cleanup);
 
-- 
2.45.2

