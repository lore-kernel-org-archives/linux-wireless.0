Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BAF3CE4B1
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791409169; cv=none; b=Ig7Rxh4Br28ej4tk2sMVwo8TFJqzK33yvoxwzmqk+gegBPuiIAlYhae3NmouFadEgSTUPE6sAuLyVYpUk+hKkg+NXgdBMdM1I/5eKw0Njku/MmBHiaB5VjS+StrLij2ME65Tqqzd6wDV8IsFxeUU9S2DoM0BVw9c+XXe75Y5M58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791409169; c=relaxed/simple;
	bh=b1QwmtP17j8UgyJPZ26QsnNlZyTDDWSyf/e7GKwiZpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQmuQ09whMx6R2BeyjaZE+sWsgItw8IRuDmo5xPDKGJQCYkTQbNyDeAH82NK7Mc5cFM5b0fo5TMJcVPm0ZyI2sKjuSisRGgD+hm15KN6p9SK4fIc6NACB603fvt1AQVRBq344GDsWBh8PHXdt2uJe0wfuf6L32D21qN0Sze5RRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpLObG5s; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpLObG5s"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3a772ec8389so19151841fa.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 14:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791409166; x=1792013966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nbFKDiOR41JSs82+WBXfytOmE7iZvhjEFmB4K0h8AvM=;
        b=hpLObG5sUi2jO6vj6c/CzVMpNifHQI2cxS4vp8OvT5ilgoeEdXNOFSt5zvN8wFG/0u
         cYadV3xyHQ+SHshkGwqUYP+L1Nzac8KER2j3IadOfpS1RbnEfwwrU7Nsvey9p1IYUT/M
         cGFnYT3SvBdgYLSBNygSy6OBlnLL5V5V7zIAJ5PjMrdZicRfz7ZMULSnCXF94EzrHPtG
         pFMDnDYHdM/M9ixTy2hJt5QQpZ51r9B+171/A9POVPJBh954aZ+xBL4Hi9lJEoRouz0F
         0ZSegOu2XhEN/Gt5reC4x1TgKZ8LbwcZQLYdCi9N0TOvmRRVxO8sNi49bgVYzOVkL/bO
         2XCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791409166; x=1792013966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nbFKDiOR41JSs82+WBXfytOmE7iZvhjEFmB4K0h8AvM=;
        b=HfVrRAj4B2lYwHK76MovcyB8Ge5wxNkDBNQGoUP/IDZH8OYEzTJv6ZOSx9Q2W6Ufcm
         slXZr3odU+EG+GMiH4HijkCsNzDQ9NR+POrCMxA5cT3Qp1X/9IwlqsNzsh7nueCxDG1E
         QOeN6o8UwfTdsQMGc71Ev9Ts8qFzpkmnMxeT8OgaZXq0uMBuC83BqUfaBpv+icexQwD1
         uZZmTO5Q2OCxEilx0ErX2otQYgBPuIDb+DN8OU75Sy6TX/5Rrv0kSq4j8aCZjUyiuDed
         pJVvCerpjHZ2+qn06EBBVajhL53lTNTsj6f3BCikGwv6jcpe24b/MlL0EpI9xKvDbC0I
         fRjQ==
X-Gm-Message-State: AFq9FYLzQOynZFpsfbqpyxSu9DWsQLJf7twS93zBMYoYykzFpE4xesPw
	BkWXpB4nfhnsj53bIA6anvaGVCeVnE51Yvbkv9fuTX4TbBl2wphaVMqc
X-Gm-Gg: AYBFou1CIZGAv6xQ1EwTYUzd7Ly2hMfXAR/+q+CUY+ZM9kbRqj1f4iNsP40xdqsNpf6
	nOE/k+tpjM3ial3rFWsuEx2RqjdpeS8GUB9Sc+L7hG9lGJdeBZiyvpok1c6ijPhb/seRmvk5Tp/
	ug4dF1GdTk/hOVYeB3zbEM3Sd6MBBO8KaGPfD9ovb560HX3qcz4rY6zIP9SQo0LbviSzXeryGWm
	yIcmErYLAaDN6u4OhpkIdonzIRTAdltdBXldkftLhJFc7w1QAtlTXn7XNz48XxcIbln0ds8wwQ8
	K/3wTsCjng+pstinm5tk8Y9s/WsHPb5iZ0zpJleVx28zQx642t5QIi3KMM2OpoZMbeI3zbuAVO3
	Rc4hqPEyyxeRU1nj+dIcSVIBHLW9IXL+OGiPlgEtzu2bm0l8nbaXtuGDAgHZB9qqgBmcwZM3zf5
	p8QTTSLH5jsfS0q8Mdt4zc9tGNKsOL6KDCp9+3cRL5DxnxpWil5NKpTxASoxYIe+rWKIFFLpXbY
	fg=
X-Received: by 2002:a2e:bc2a:0:b0:3a3:74b7:fc03 with SMTP id 38308e7fff4ca-3a9ac61053cmr3436821fa.15.1791409165827;
        Wed, 07 Oct 2026 14:39:25 -0700 (PDT)
Received: from Quarx2k-PC.lan ([92.124.138.168])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9ae563df4sm1241411fa.30.2026.10.07.14.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:39:24 -0700 (PDT)
From: Nikolai Semendiaev <agent00791@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	jjohnson@kernel.org,
	wabsie@gmail.com
Subject: [PATCH v2 2/2] wifi: ath12k: use private page-frag caches for RXDMA rings
Date: Thu,  8 Oct 2026 03:38:29 +0600
Message-ID: <bd52182ca4916b55632a710be2f5c9cfd25f07a2.1791408913.git.agent00791@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791408913.git.agent00791@gmail.com>
References: <cover.1791408913.git.agent00791@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RXDMA buffers allocated with dev_alloc_skb() share per-CPU page-fragment
caches with other network users. Long-lived ring buffers can pin mostly
unused 32-KiB backing pages as short-lived network allocations cycle
through those caches. On QCN9274, OOM was observed during sustained WAN
downloads when Ethernet and ath12k processing shared a CPU.

Give regular and monitor RXDMA rings private page-fragment caches. The
existing refill SRNG locks serialize cache access. Preserve NET_SKB_PAD,
allocation flags and the DMA mapping and unmapping operations.

Drain each monitor cache after releasing its IDR-owned buffers, and the
regular RX cache after releasing its cookie-conversion descriptors.
Disable external IRQ/NAPI processing before non-reset crash teardown;
the reset worker already does so.

Use skb_reserve() for DMA alignment because skb_pull() cannot advance
an empty skb. Allocate extra alignment space for monitor status buffers
to preserve at least RX_MON_STATUS_BUF_SIZE of DMA capacity.

Based on Mark Ruvald Pedersen's ath11k per-ring page-fragment isolation.

Link: https://lore.kernel.org/linux-wireless/20260719215817.2468580-4-wabsie@gmail.com/
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nikolai Semendiaev <agent00791@gmail.com>
---
 drivers/net/wireless/ath/ath12k/core.c   |  3 ++
 drivers/net/wireless/ath/ath12k/dp.c     |  4 +++
 drivers/net/wireless/ath/ath12k/dp.h     |  3 ++
 drivers/net/wireless/ath/ath12k/dp_mon.c | 29 +++++++++------
 drivers/net/wireless/ath/ath12k/dp_rx.c  | 45 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/dp_rx.h  |  2 ++
 6 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 0c72948f3..8216f344e 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1390,6 +1390,9 @@ static int ath12k_core_reconfigure_on_crash(struct ath12k_base *ab)
 {
 	int ret, total_vdev;
 
+	if (!ab->is_reset)
+		ath12k_hif_irq_disable(ab);
+
 	mutex_lock(&ab->core_lock);
 	ath12k_link_sta_rhash_tbl_destroy(ab);
 	ath12k_thermal_unregister(ab);
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 83f9edfab..2f45ade5a 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -4,6 +4,8 @@
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
+#include <linux/bug.h>
+#include <linux/page_frag_cache.h>
 #include "core.h"
 #include "dp_tx.h"
 #include "hif.h"
@@ -1020,6 +1022,8 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 
 	spin_unlock_bh(&dp->rx_desc_lock);
 
+	page_frag_cache_drain(&dp->rx_refill_buf_ring.frag_cache);
+
 	/* TX Descriptor cleanup */
 	for (i = 0; i < ATH12K_HW_MAX_QUEUES; i++) {
 		spin_lock_bh(&dp->tx_desc_lock[i]);
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index c53eac20b..0b68bd8ba 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -11,6 +11,7 @@
 #include "hw.h"
 #include "dp_htt.h"
 #include "dp_cmn.h"
+#include <linux/mm_types.h>
 #include <linux/rhashtable.h>
 
 #define MAX_RXDMA_PER_PDEV     2
@@ -51,6 +52,7 @@ struct dp_srng {
 
 struct dp_rxdma_mon_ring {
 	struct dp_srng refill_buf_ring;
+	struct page_frag_cache frag_cache;
 	struct idr bufs_idr;
 	/* Protects bufs_idr */
 	spinlock_t idr_lock;
@@ -59,6 +61,7 @@ struct dp_rxdma_mon_ring {
 
 struct dp_rxdma_ring {
 	struct dp_srng refill_buf_ring;
+	struct page_frag_cache frag_cache;
 	int bufs_max;
 };
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 709507d44..8b2b81b46 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -5,6 +5,7 @@
  */
 
 #include "dp_mon.h"
+#include "dp_rx.h"
 #include "debug.h"
 #include "dp_tx.h"
 #include "peer.h"
@@ -44,15 +45,17 @@ struct sk_buff
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 
-	skb = dev_alloc_skb(RX_MON_STATUS_BUF_SIZE);
+	skb = ath12k_dp_rx_alloc_skb(&rx_ring->frag_cache,
+				     RX_MON_STATUS_BUF_SIZE +
+				     RX_MON_STATUS_BUF_ALIGN);
 
 	if (!skb)
 		goto fail_alloc_skb;
 
 	if (!IS_ALIGNED((unsigned long)skb->data,
 			RX_MON_STATUS_BUF_ALIGN)) {
-		skb_pull(skb, PTR_ALIGN(skb->data, RX_MON_STATUS_BUF_ALIGN) -
-			 skb->data);
+		skb_reserve(skb, PTR_ALIGN(skb->data, RX_MON_STATUS_BUF_ALIGN) -
+			    skb->data);
 	}
 
 	paddr = dma_map_single(ab->dev, skb->data,
@@ -598,14 +601,16 @@ int ath12k_dp_mon_buf_replenish(struct ath12k_base *ab,
 	ath12k_hal_srng_access_begin(ab, srng);
 
 	while (req_entries > 0) {
-		skb = dev_alloc_skb(DP_RX_BUFFER_SIZE + DP_RX_BUFFER_ALIGN_SIZE);
+		skb = ath12k_dp_rx_alloc_skb(&buf_ring->frag_cache,
+					     DP_RX_BUFFER_SIZE +
+					     DP_RX_BUFFER_ALIGN_SIZE);
 		if (unlikely(!skb))
 			goto fail_alloc_skb;
 
 		if (!IS_ALIGNED((unsigned long)skb->data, DP_RX_BUFFER_ALIGN_SIZE)) {
-			skb_pull(skb,
-				 PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
-				 skb->data);
+			skb_reserve(skb,
+				    PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
+				    skb->data);
 		}
 
 		paddr = dma_map_single(ab->dev, skb->data,
@@ -687,15 +692,17 @@ int ath12k_dp_mon_status_bufs_replenish(struct ath12k_base *ab,
 	num_remain = req_entries;
 
 	while (num_remain > 0) {
-		skb = dev_alloc_skb(RX_MON_STATUS_BUF_SIZE);
+		skb = ath12k_dp_rx_alloc_skb(&rx_ring->frag_cache,
+					     RX_MON_STATUS_BUF_SIZE +
+					     RX_MON_STATUS_BUF_ALIGN);
 		if (!skb)
 			break;
 
 		if (!IS_ALIGNED((unsigned long)skb->data,
 				RX_MON_STATUS_BUF_ALIGN)) {
-			skb_pull(skb,
-				 PTR_ALIGN(skb->data, RX_MON_STATUS_BUF_ALIGN) -
-				 skb->data);
+			skb_reserve(skb,
+				    PTR_ALIGN(skb->data, RX_MON_STATUS_BUF_ALIGN) -
+				    skb->data);
 		}
 
 		paddr = dma_map_single(ab->dev, skb->data,
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index cfaf26ae2..a0ea0d51e 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -5,9 +5,12 @@
  */
 
 #include <linux/fips.h>
+#include <linux/gfp.h>
 #include <linux/ieee80211.h>
 #include <linux/kernel.h>
+#include <linux/page_frag_cache.h>
 #include <linux/skbuff.h>
+#include <net/sock.h>
 #include "core.h"
 #include "debug.h"
 #include "hw.h"
@@ -68,6 +71,35 @@ static void ath12k_dp_rx_enqueue_free(struct ath12k_dp *dp,
 	spin_unlock_bh(&dp->rx_desc_lock);
 }
 
+struct sk_buff *ath12k_dp_rx_alloc_skb(struct page_frag_cache *cache,
+				       unsigned int len)
+{
+	gfp_t gfp_mask = GFP_ATOMIC | __GFP_NOWARN;
+	struct sk_buff *skb;
+	void *data;
+
+	len += NET_SKB_PAD;
+	len = SKB_HEAD_ALIGN(len);
+
+	if (sk_memalloc_socks())
+		gfp_mask |= __GFP_MEMALLOC;
+
+	/* Refill paths serialize the per-ring cache with the SRNG lock. */
+	data = page_frag_alloc(cache, len, gfp_mask);
+	if (!data)
+		return NULL;
+
+	skb = build_skb(data, len);
+	if (!skb) {
+		page_frag_free(data);
+		return NULL;
+	}
+
+	skb_reserve(skb, NET_SKB_PAD);
+
+	return skb;
+}
+
 /* Returns number of Rx buffers replenished */
 int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 				struct dp_rxdma_ring *rx_ring,
@@ -114,16 +146,17 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 	}
 
 	while (num_remain > 0) {
-		skb = dev_alloc_skb(DP_RX_BUFFER_SIZE +
-				    DP_RX_BUFFER_ALIGN_SIZE);
+		skb = ath12k_dp_rx_alloc_skb(&rx_ring->frag_cache,
+					     DP_RX_BUFFER_SIZE +
+					     DP_RX_BUFFER_ALIGN_SIZE);
 		if (!skb)
 			break;
 
 		if (!IS_ALIGNED((unsigned long)skb->data,
 				DP_RX_BUFFER_ALIGN_SIZE)) {
-			skb_pull(skb,
-				 PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
-				 skb->data);
+			skb_reserve(skb,
+				    PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
+				    skb->data);
 		}
 
 		paddr = dma_map_single(dp->dev, skb->data,
@@ -193,6 +226,8 @@ static int ath12k_dp_rxdma_mon_buf_ring_free(struct ath12k_base *ab,
 	idr_destroy(&rx_ring->bufs_idr);
 	spin_unlock_bh(&rx_ring->idr_lock);
 
+	page_frag_cache_drain(&rx_ring->frag_cache);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 827004745..99b989b69 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -232,6 +232,8 @@ int ath12k_dp_rx_bufs_replenish(struct ath12k_dp *dp,
 				struct dp_rxdma_ring *rx_ring,
 				struct list_head *used_list,
 				int req_entries);
+struct sk_buff *ath12k_dp_rx_alloc_skb(struct page_frag_cache *cache,
+				       unsigned int len);
 int ath12k_dp_rx_pdev_mon_attach(struct ath12k *ar);
 int ath12k_dp_rx_peer_frag_setup(struct ath12k *ar, const u8 *peer_mac, int vdev_id);
 
-- 
2.43.0

