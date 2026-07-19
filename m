Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051FD31195B
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498314; cv=none; b=L9KolLVDQJ30qCY1skpwayuoSCXqeqjXD92ji0N45Fe5F4owfE6Ozfes+2nAaaI9Ckk9YSfMSOPP5szhimthWaXD6ykjvy/yp9nNBkEIyraKkINjpOkhtDrLaJJo1FH5KToPIIFWbE+EJtO55h3VETfIH+B2mAC29Yqxbxwoov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498314; c=relaxed/simple;
	bh=GD8IdMjUF8UO3Pywmd8ajikBSUWd5bktPTNIGDdSqNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIm93TLVuEGjM5jkahD6q5FkSLVTEi5YWC+Cf3AoBcJUrybgUknE7mMpYQXmwjuFGUxh9axhfnz/0ypaicPIEbV5GTin+orPVJMRdo9BD1tdB+20WgxBDwslbkcePfFOVZ/DpFHfCt5Z+vTgixqqutzhK/qDC8E37CDPyFu6xEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DaCCGRV0; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DaCCGRV0"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-698beff7178so7884636a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784498311; x=1785103111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZrnWAngYS6JLzxtxY9C76JD3u8HKuRum017zjKAx33U=;
        b=DaCCGRV0vkRpE8csJ72mEf4tMnoDknWcUplBEdhf5CKGX7EshwSWFZai6PxgrqtZac
         Hs35Diigi2DRE/6MsB2nATYV/pY3m+E0x14r19xMNPK1tvXWvTcWAtGmTDWT9Vc47gqV
         H2fmDitflI21vGeFe/q6igHpGcsIQ/JhG/8CQnzZLHwy9g7zCesWKRp06cknuo5A3Ax4
         /D3CyL7MSLkLfGFNO8n6KhRzg3fIZvQPNtVTaWU/iEeBj4C9bug7m30vMj5BLoMILhOp
         NKCEcoIUEN8mO/N0oAI1+xeGPsQJtnyDM9FKy4zcujkrE+kuUJnY5DbWPjQpoJTUV1XG
         TC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498311; x=1785103111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZrnWAngYS6JLzxtxY9C76JD3u8HKuRum017zjKAx33U=;
        b=GqhKw06g00uK+peo8u8lS0JgGh/pzDQaFcnj2d5JUm6JOSRNl2uWlKdkV4+o0VsNxN
         ggNI03w+TYEoCQJKDT7bmASPwKIZpMYYpP+nCgJQSmB1BjfFlqkdNheZcNExJ1Z5tHGd
         l7yYduhHop4xCnX7ZT5ubrYhq6wtV0kk9mOVzTV/wk1+aFlbRJqS/EiNhb8CjJDvTqn3
         fn0Om1ol25LIPxs4xOQZjyH+8meNZHYUWseUREyx+WHo6XmF5paJASUOvxRpS3Vm9OBW
         nANeTw/aRkk+4fmy29hSTMru651CDrOtV3I3iHkULU2foFPUlFVzNzd6Te9lBYDuuGBw
         j7bg==
X-Gm-Message-State: AOJu0YzbJmRbe6HnWGObi6mZzh8Y6BK2kjf7gw+xbpw6kUQdy6Mq5zPs
	+NBQ/8EMi5V3xMWSDpW9EjyUPCJqtEKtfSP1xXvHxb3AHcxbnqHPyVo+lgHupVQn
X-Gm-Gg: AfdE7clWQjDhGXO4U9SONyOsdccwgcVZynmPiECk5NJ9MGjrb830Xs2DOrI3KiZRMvL
	SFLmW2PQnQ7fyYiKHc4vlHy4+KTUgWfH9R77zJVgY+/nZLlz60DkGKeC4AMmgFTWYDkuSXxspXY
	Vt5vxjuvnnmmPbOy0GDRTRrb0JeGEwYYVxUUJo1BOu1o+NMQ4gK54d2ezOiw5KCtyHTipoEnauq
	N4XXUOvyNHNk4HaxXcX2zruHdcDn8waZajF1/EOM7FHYLenUo1yjOwdDLFcAzKA6kD0BwZ1xnM9
	OmqyfDq+ul1xAoXVDSFiSnmdbAWaqNKywyXoSNfeAJbgANc/YpxBJxHN89R3dwIiTfzUBF84qrt
	7VrvsV0+fwLDB//Gki6Sk6bnIJgBAKgFoEBknnwhdugYQY/e0EUio8AsSaqFHIIs2tJQu5M7n0U
	2CTK7ho8E097+MZw==
X-Received: by 2002:a17:907:709:b0:c16:5a9b:5966 with SMTP id a640c23a62f3a-c16b47c50damr506688866b.33.1784498310938;
        Sun, 19 Jul 2026 14:58:30 -0700 (PDT)
Received: from nv-msd-x1c.mtdk.labs.mlnx ([212.60.125.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c16eb80bbf8sm379116766b.0.2026.07.19.14.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:58:29 -0700 (PDT)
From: Mark Ruvald Pedersen <wabsie@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org
Subject: [RFC PATCH 3/3] wifi: ath11k: use private page-frag caches for RXDMA rings
Date: Sun, 19 Jul 2026 23:58:17 +0200
Message-ID: <20260719215817.2468580-4-wabsie@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260719215817.2468580-1-wabsie@gmail.com>
References: <20260719215817.2468580-1-wabsie@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k allocates RXDMA skb heads with dev_alloc_skb(), which draws from
shared per-CPU page-frag caches. RX buffers from different rings and
unrelated networking allocations can therefore share a high-order
backing page despite having different ownership lifetimes.

On IPQ8074, RX ownership tracing found bounded ring and IDR occupancy
while page-frag backing grew. Two captures found current or historical
cross-origin fragments on 86-87% of the final tracker-visible physical
pages.

Give each RXDMA ring its own page_frag_cache and use it for regular and
monitor-status buffers. New fragments from distinct rings can no longer
share backing pages with one another or with unrelated users. The
monitor-destination path that intentionally uses the data refill ring
also uses that ring's cache.

Commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset
path") moved HIF IRQ shutdown from the common crash-reconfiguration path
into the reset worker. The non-reset QMI recovery path can consequently
reach DP teardown while NAPI can still refill an RXDMA ring.

Quiesce HIF IRQ/NAPI processing on that non-reset path before teardown.
The reset worker already does so before power cycling, therefore keep the
existing reset path unchanged. This makes the cache change self-contained
without relying on repeated IRQ lifecycle transitions.

The refill paths serialize each cache with the corresponding SRNG lock.
Drain the cache only after ring-owned skbs have been DMA-unmapped and
freed and the IDR has been destroyed. Keep the dev_alloc_skb() allocation
flags and headroom behavior; build_skb() propagates head-frag and
pfmemalloc metadata from the backing page.

This leaves buffer and ring sizes and all DMA map/unmap operations
unchanged. It isolates cross-owner lifetime mixing; it does not prevent
lifetime variation among buffers belonging to the same ring.

With the private caches, page-frag backing remained bounded in natural
load, resident, and high-packet-rate pressure runs on IPQ8074. The
non-reset recovery path has not been runtime-tested in isolation.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Signed-off-by: Mark Ruvald Pedersen <wabsie@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 8dacc878c006..e71a22ce332d 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2330,6 +2330,9 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 {
 	int ret;
 
+	if (!ab->is_reset)
+		ath11k_hif_irq_disable(ab);
+
 	mutex_lock(&ab->core_lock);
 	ath11k_thermal_unregister(ab);
 	ath11k_dp_pdev_free(ab);
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 84f66839f0c6..e69dc23b2051 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -7,6 +7,8 @@
 #ifndef ATH11K_DP_H
 #define ATH11K_DP_H
 
+#include <linux/page_frag_cache.h>
+
 #include "hal_rx.h"
 
 #define MAX_RXDMA_PER_PDEV     2
@@ -72,6 +74,7 @@ struct dp_srng {
 
 struct dp_rxdma_ring {
 	struct dp_srng refill_buf_ring;
+	struct page_frag_cache frag_cache;
 	struct idr bufs_idr;
 	/* Protects bufs_idr */
 	spinlock_t idr_lock;
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index e4ea0c216740..6bbfa0ebddd0 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5,9 +5,11 @@
  */
 
 #include <linux/fips.h>
+#include <linux/gfp.h>
 #include <linux/ieee80211.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <net/sock.h>
 #include "core.h"
 #include "debug.h"
 #include "debugfs_htt_stats.h"
@@ -340,6 +342,36 @@ static int ath11k_dp_purge_mon_ring(struct ath11k_base *ab)
 	return -ETIMEDOUT;
 }
 
+static struct sk_buff *
+ath11k_dp_rx_alloc_skb(struct dp_rxdma_ring *rx_ring, unsigned int len)
+{
+	struct page_frag_cache *cache = &rx_ring->frag_cache;
+	gfp_t gfp_mask = GFP_ATOMIC;
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
 int ath11k_dp_rxbufs_replenish(struct ath11k_base *ab, int mac_id,
 			       struct dp_rxdma_ring *rx_ring,
@@ -371,8 +403,8 @@ int ath11k_dp_rxbufs_replenish(struct ath11k_base *ab, int mac_id,
 	num_remain = req_entries;
 
 	while (num_remain > 0) {
-		skb = dev_alloc_skb(DP_RX_BUFFER_SIZE +
-				    DP_RX_BUFFER_ALIGN_SIZE);
+		skb = ath11k_dp_rx_alloc_skb(rx_ring, DP_RX_BUFFER_SIZE +
+					     DP_RX_BUFFER_ALIGN_SIZE);
 		if (!skb)
 			break;
 
@@ -453,6 +485,8 @@ static int ath11k_dp_rxdma_buf_ring_free(struct ath11k *ar,
 	idr_destroy(&rx_ring->bufs_idr);
 	spin_unlock_bh(&rx_ring->idr_lock);
 
+	page_frag_cache_drain(&rx_ring->frag_cache);
+
 	return 0;
 }
 
@@ -2867,8 +2901,8 @@ static struct sk_buff *ath11k_dp_rx_alloc_mon_status_buf(struct ath11k_base *ab,
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 
-	skb = dev_alloc_skb(DP_RX_BUFFER_SIZE +
-			    DP_RX_BUFFER_ALIGN_SIZE);
+	skb = ath11k_dp_rx_alloc_skb(rx_ring, DP_RX_BUFFER_SIZE +
+				     DP_RX_BUFFER_ALIGN_SIZE);
 
 	if (!skb)
 		goto fail_alloc_skb;
