Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2073B961F
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279797; cv=none; b=I2eqSm3Kgn0q/35HQAJIKbWliptS51wQVrIQqVNwWN+EYqfmUsQLxE/5MlwFZqnDaq8Go93pAsbuB1+7J1Wb3zFYMW5Eaa7110PO+Be2f1wRVQ/FlO6oHbjog9X71XddQCJTXIH+yGCN2mM2wod/e+fHurKiZXqn+7eItiCC9aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279797; c=relaxed/simple;
	bh=PI9JdG8RKUds1bXg2cg0muGbBKUxJhzK4cN2ffiJZ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2pnjwbWg3H7IUMzK9elVL3i+C93EezwJQfSKn+RX5lhhT8I8l1ba2ai7WC7cWbuiA+ZWjENs/K6IIe5tyWXooknKYdGBQ0DO8cqG0ldZJA8NBEUBeecOFcFP9Mgi8acr1LOYgBusD9gTTj8ngYfCDAYCFUC5v5TKGi3TRtZrNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHI5j5ON; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHI5j5ON"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2e36c3478aso398882866b.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 02:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279794; x=1791884594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sKZMczwgWcdJJIgzlUEuriqeYRN99r4Avg0hTCaOGbs=;
        b=ZHI5j5ONYbo+Ivq2I2YgK8njNtRzp/P2pvWamPXw3enNXwBO7UU2hf7q0uo2g+uK2T
         DAQH00/BKnolgZtAnVO8WFmI+h1KOQZpHeM3RdLqlanJpHwmQ3bNUlxy4+gA24fIbKXT
         UG8RjohjBnzOResHJcMo6PJT3gK+OaxvYIaCFRzGIV1G8M30Yjqx4M4f5EgsUbiAp5g9
         y5gtyJ0K40ARJvDJ5PXi6D1yaAhGYitKFuJHrWj2ZBrb5ruNngn/2vFw0dWzM3GPe5O/
         vJcvwMZHA7SBKjNdN0SUS8i77FUAbm4pbQSKi7zGqZtH+0c9ZkO6MKvaWqmzi1YW+Qbp
         z55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279794; x=1791884594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sKZMczwgWcdJJIgzlUEuriqeYRN99r4Avg0hTCaOGbs=;
        b=046zmw7PgVWVsROn2U5mhPOcfA+iATraMimySuIa7RX/VW7NEIMa2ORhAzWnZRMc7r
         Yj/QtgfF5GAgNnX/7hKXTZPqewKtbyOW9JBR7f6R+xJeG51V73S1V0xNge1UEoGOlcKV
         Ii1zV/21ETKgnYr4W4aPBayixfygJjKszUYvcDWvBy0vmHnJoGmUIe+ojmwxN/JNG9Sa
         qnQjAkFWsb9q5TvajpxwmH6R6OEAw7GbNrjW1ItFgYpQVVkhLpHvoDI+EX2T4ZUGGeVA
         Suj5vwBQVHwk09RnRWy+kNoPdHF2oidNhdInW015gLRWZipCX8qYvwE7WSBbIqNRD53C
         nkSw==
X-Gm-Message-State: AFuF++kXjnkIV5PLGJwlX9hcYmJ/GU5EuXu72+qqVUpqokUw0XTcNYLk
	h6pdckcGW41tWQgCN9i2Fd6eBOWJYIJ+T92sTbXMFCrrc+NgINlHk1z7
X-Gm-Gg: AYBFou1w/n4nxfqXpLPmaj1LlsbP52HKAxrOSfhjeeK4kYLqhPyv41J6rv3DNjGSIK4
	YlAw96PgyC89ScQbifp255DKaDpCRH02S1SW0QtNE68w5vEqxxXIHE8oUyd7OTjxiunBS8LtoJ0
	yG45L6ChYhxocZOuv7cts8pZsM/T+Z3FI4bQDcIPVrI6hF8qBtZA5jLqed4E7kncBrYmXVjAR4F
	vbgVVoUE+A7dnsm3xVEuxFXamIl7yyTc5DQ9ixkkGshuKL/DLAAO4zndg4xguNuutXbf7XKGjBb
	943tJH7VbD2X/DXfSUeXUq9M+/NSUXSPzgFkaVXR5kpxwf4BzO1cobhZmuE8fGE6xW7J0TmqUz5
	W6ZRgvlvssw7dnDOooUCqQwdS3GlSBpcVip6ZjM9nkQhJ/B9NLoYrECcbk6ynlXZXEdDoT29eHA
	uahLcyXY8u+IuqK99AVDbvwQZY0asdbNmIi17VBvvUmul8CXqFatWXTAR/eGpMlOCDCEA3D74Kc
	JmLwAQ2nQODcw==
X-Received: by 2002:a17:906:c107:b0:c2d:d27d:ef88 with SMTP id a640c23a62f3a-c316a0734f9mr105156866b.42.1791279793825;
        Tue, 06 Oct 2026 02:43:13 -0700 (PDT)
Received: from Quarx2k-PC.lan ([92.124.138.168])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562da31esm183753966b.38.2026.10.06.02.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:43:13 -0700 (PDT)
From: Nikolai Semendiaev <agent00791@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	jjohnson@kernel.org,
	wabsie@gmail.com
Subject: [PATCH 2/2] wifi: ath12k: use private page-frag caches for RXDMA rings
Date: Tue,  6 Oct 2026 15:41:47 +0600
Message-ID: <7bb1b30324eea87b53a8c585566842a1a0ec7d06.1791279304.git.agent00791@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791233788.git.agent00791@gmail.com>
References: <cover.1791233788.git.agent00791@gmail.com>
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
 drivers/net/wireless/ath/ath12k/dp.c     |  3 ++
 drivers/net/wireless/ath/ath12k/dp.h     |  3 ++
 drivers/net/wireless/ath/ath12k/dp_mon.c | 29 +++++++++------
 drivers/net/wireless/ath/ath12k/dp_rx.c  | 45 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/dp_rx.h  |  2 ++
 6 files changed, 69 insertions(+), 16 deletions(-)

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
index 83f9edfab..7c097c506 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -4,6 +4,7 @@
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
+#include <linux/page_frag_cache.h>
 #include "core.h"
 #include "dp_tx.h"
 #include "hif.h"
@@ -1020,6 +1021,8 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 
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

