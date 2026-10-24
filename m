Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792816789;
	b=p/jJ5s4AntPAcd9+IDYKxhz3mp6at7gVEqS7iGLprebe55F9UDMbzvLvLZLY/zykJ5uq
	 PomjenRlSTcj+pn9zaRna2F75JpZbL23rnx+V6Ve0B3bq22w0KCLe94EFOfHCQgf6wNwl
	 71GwbGlZc6ahlU/xf4abMeBnLMMICSSRQcBsa/8Lf7G/kLUAGvjUoJtoycLCgy8YkbG2t
	 0gEVCduf6steAEXujbxlfPua0R/ePWt5yVeRF9ZXUEjciIUX+1ouLzCYTkyZCLL6MHYVf
	 kR1HD7uWudexjv8WPvQiuhT2NJ+Zu0vNECa9WBpif3y1TK+6s7W+Xj54imupUZUF3lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792816789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3HaU3JTYEsqzcj7t+o5JM4q8kNKPVWEXADi4DwUtYP8=;
	b=hqHTJjRFS/6q/l4KGcZcC8xM0naDqVOPSHXYgPJDlUFv2HK5BfdipTUz3vhiMZLLpOIc
	 iMlGAe5XRU1AdUCbR5/AvA11SphDJzmA5FZ7xQSUpEXHimrpzH4EztvPhNaUMAnR1hfB+
	 NwVjN252V1Alt6t3x1rnKaI3CwoOjakRHMzF4cG1wM2Zwb5HxMLlqG8DIo00E0RXZlya8
	 RE3naqpdo45RZ1oj2yzRjizUtP8Qt5fJuFo0TFMstkLc3isK+vTX+oROjMeV4mbo8KjJ3
	 O728lxECVDnYdmYso1KaKVtSlN4E2jLp077EI1owQXFsFvYj7XPQLHwOjH03cgo63jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="V/pid0Yn";
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCE1606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 04:39:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECCE1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=V/pid0Yn
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so847830a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 21:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792816788; x=1793421588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3HaU3JTYEsqzcj7t+o5JM4q8kNKPVWEXADi4DwUtYP8=;
        b=V/pid0YnewNbwPiHJMqlDa4Ogbl50OrP/1+idMC8DrAEn1/BRFh/3emXbEkdU0Ci5L
         cs7omddMd+zsC3lLk7ylF6mw2zjOpxme4mz1qlUu0M4l8d5EOJcof6b0pobH3EcrYpUP
         arKJVbXB0reHjXbLcNgrObK9x2c6iEG/8FJf0Tdx1bgz93PpxhKUg/W2aM0aC6ri/6S/
         DqPPvMvonoPJIwPlRakUZb2ivoeWR4nyoNHG84AvlwJobrdiTOLueLMjVNwNTtDdgt4k
         L7F7v4jMunxhm9D334gDGdE3UlHeLlSDtXY4WOky5QP/0U0ansSmrkzqy2IRaGLQ/gov
         H56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792816788; x=1793421588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3HaU3JTYEsqzcj7t+o5JM4q8kNKPVWEXADi4DwUtYP8=;
        b=lVOEVGe5YcM7eH00u8Meofs2dQTJQG10jhVEIZ5iw9DnhmIdKSSRoOWlKeeHVHDuZS
         HH2/bAITRJPBLOw7t3dEJ/7j+v+tyATmdYj7EKHincScN8q8ZlO0dQvxZwBXclgzoTtp
         xMcJX8d4Ya12Rof2JV7qGX/3vZzZY/COxHJQnfxbSL9HBs7bAln/1S45mPi4zVLlOGQI
         njB3aSS6DAaIgVeVi+0Y3b0FqLSN+TqqBaAeQpmGadVfJiiPdbFOdOEWyXNhiR7wcRCG
         47n/qb1IIp7SawbMVB7s9YTL3Usx+ZVScj4GzD57PAn1gs8SsW/OqY/q4bhxFbjoRfaH
         ahzw==
X-Gm-Message-State: AFq9FYJPsu0B/eIiimxXWVr2aRlwdEz61oUjbRjgpfirfuNU6Ok3YWbY
	Vd3oRLvk04vz6IsB2an49B9qSTBc5VBWZtYTCwr9UWp7c3ikyruh0cehEhBdFA==
X-Gm-Gg: AYBFou3KMqdfr545YhTpKJIJc8vKq6FHKBlS6qezinQpLTQmEcNq3uhG40yJt6h3aR1
	6l/BTzsIyGkQhV/Z0K5zVhzTYrN37e/O4lJ2YKnfl5FWUGj+6ne/95t8i3FiGQYytgohtWoCx4K
	MSlJcz3fX2nNVJ1K6shyE47WkgxPQ4k1qe3p+WcAJxCXaG2VBT71z1lVuOj7vZ3WJOFWfUKM5KU
	lBiHCMoeeJ3PiBK8VI11NvVOYb4vPt0iZiLZgf09Dj3fjFkwZ+hr20aqiwVKghdcuQ1ZLgUi7+N
	C1btOCREKAOIDB600MVo2Fmy7d9yemmPmwzwFVBwvhY5uFCA4s7OYeQB/YLx5eKs8oRlwf9qOQC
	OM8HJGAA47r5dR0xrV8pXRJYiga4rz4outQhLmr+gco1ymP5yXCG65d7tqTrbstBp6lCrleU/U1
	r3u7r/2phycT64bibAhVC68CFV/0hJ3lBSLBdIBJuTVFg507G+xu1XKhozwV9jEYvxYlBlehhJs
	gUttj4jUmhKLggbSRchCGoppM6TOUDBLlV//9UEyK17f0WVP/bhc/9eIJKeRaps93YLtc54gTLK
	w0C6SCePeyTg75G/FNk9euljWps6xfZcnXKs775DgM8spuXfJ9+kW17VPHE9Gzo76yKNOE4bpmu
	tylIWk9bahe8mnI6KfbGjVBZiNjsn
X-Received: by 2002:a17:90b:3c06:b0:3ac:af8d:c839 with SMTP id 98e67ed59e1d1-3adeabe0ccdmr1080585a91.35.1792816788146;
        Fri, 23 Oct 2026 21:39:48 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb75254sm768481a91.4.2026.10.23.21.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 21:39:47 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ath9k: use page_pool for RX buffers
Date: Fri, 23 Oct 2026 21:39:44 -0700
Message-ID: <20261024043944.3221303-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Allocate RX buffers from a page_pool instead of allocating a new skb
and mapping it for every received frame. The pool keeps its pages
mapped, so refilling a descriptor only needs a sync for the device,
and buffers are recycled once the stack is done with them.

The pool uses the smallest page order that fits at least two buffers
and is sized for the number of pages the RX ring needs. With 4 KiB
pages a buffer plus skb_shared_info does not fit into half a page, so
this means order-1 pages split into three fragments.

Buffers are now aligned to the page_pool fragment alignment (at least
the DMA cache alignment) plus NET_SKB_PAD instead of to the PCI cache
line size reported in common->cachelsz. This keeps them cache line
aligned, which is what the hardware needs.

On a Meraki MX60 (APM82181, 3x3 AR9300-family PCIe card, 5 GHz HT40)
forwarding 90 Mbit/s of UDP from a wireless client to the WAN port,
the CPU load drops from 56.2% to 54.8% (mean of 12 runs each, in-boot
A/B), and the share of ath9k itself drops from 14.1% to 11.9% of the
samples. TCP throughput is unchanged (air time bound).

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |   1 +
 drivers/net/wireless/ath/ath9k/ath9k.h |   2 +
 drivers/net/wireless/ath/ath9k/recv.c  | 167 ++++++++++++++++---------
 3 files changed, 109 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 47d570a5ca6a..d674d19210b5 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -22,6 +22,7 @@ config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211 && HAS_DMA
 	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
+	select PAGE_POOL
 	select ATH9K_HW
 	select ATH9K_COMMON
 	help
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e8635bf81f9d..a3b94a99b321 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -33,6 +33,7 @@
 
 struct ath_node;
 struct ath_vif;
+struct page_pool;
 
 extern struct ieee80211_ops ath9k_ops;
 extern int ath9k_modparam_nohwcrypt;
@@ -312,6 +313,7 @@ struct ath_rx {
 
 	struct ath_rxbuf *buf_hold;
 	struct sk_buff *frag;
+	struct page_pool *page_pool;
 
 	u32 ampdu_ref;
 };
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 93b41a1bb2af..4bff0f74dba1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <net/page_pool/helpers.h>
 #include "ath9k.h"
 #include "ar9003_mac.h"
 
@@ -107,6 +108,77 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
 }
 
+static unsigned int ath_rx_buf_size(struct ath_common *common)
+{
+	return SKB_DATA_ALIGN(NET_SKB_PAD + common->rx_bufsize) +
+	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+}
+
+static int ath_rx_page_pool_create(struct ath_softc *sc, int nbufs)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned int size = ath_rx_buf_size(common);
+	struct page_pool_params pp_params = {};
+	struct page_pool *pp;
+	unsigned int order;
+
+	/*
+	 * Use pages that hold at least two buffers. With 4 KiB pages a
+	 * buffer does not fit into half a page, so this ends up as
+	 * order-1 pages shared by three buffers.
+	 */
+	order = get_order(2 * size);
+
+	pp_params.order = order;
+	pp_params.pool_size = DIV_ROUND_UP(nbufs, (PAGE_SIZE << order) / size);
+	pp_params.nid = NUMA_NO_NODE;
+	pp_params.dev = sc->dev;
+	pp_params.flags = PP_FLAG_DMA_MAP;
+
+	/* EDMA chips clear the RX status from the CPU side */
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		pp_params.dma_dir = DMA_BIDIRECTIONAL;
+	else
+		pp_params.dma_dir = DMA_FROM_DEVICE;
+
+	pp = page_pool_create(&pp_params);
+	if (IS_ERR(pp)) {
+		ath_err(common, "failed to create rx page pool\n");
+		return PTR_ERR(pp);
+	}
+
+	sc->rx.page_pool = pp;
+	return 0;
+}
+
+static struct sk_buff *ath_rx_buf_alloc(struct ath_softc *sc,
+					dma_addr_t *addr, gfp_t gfp)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct page_pool *pp = sc->rx.page_pool;
+	unsigned int size = ath_rx_buf_size(common);
+	unsigned int offset;
+	struct sk_buff *skb;
+	struct page *page;
+
+	page = page_pool_alloc(pp, &offset, &size, gfp);
+	if (!page)
+		return NULL;
+
+	skb = build_skb(page_address(page) + offset, size);
+	if (!skb) {
+		page_pool_put_page(pp, page, -1, false);
+		return NULL;
+	}
+
+	skb_mark_for_recycle(skb);
+	skb_reserve(skb, NET_SKB_PAD);
+
+	*addr = page_pool_get_dma_addr(page) + offset + NET_SKB_PAD;
+
+	return skb;
+}
+
 static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 				 enum ath9k_rx_qtype qtype)
 {
@@ -170,8 +242,6 @@ static void ath_rx_remove_buffer(struct ath_softc *sc,
 
 static void ath_rx_edma_cleanup(struct ath_softc *sc)
 {
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_rxbuf *bf;
 
 	ath_rx_remove_buffer(sc, ATH9K_RX_QUEUE_LP);
@@ -179,9 +249,6 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
 		if (bf->bf_mpdu) {
-			dma_unmap_single(sc->dev, bf->bf_buf_addr,
-					common->rx_bufsize,
-					DMA_BIDIRECTIONAL);
 			dev_kfree_skb_any(bf->bf_mpdu);
 			bf->bf_buf_addr = 0;
 			bf->bf_mpdu = NULL;
@@ -218,7 +285,7 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 	INIT_LIST_HEAD(&sc->rx.rxbuf);
 
 	for (i = 0; i < nbufs; i++, bf++) {
-		skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_KERNEL);
+		skb = ath_rx_buf_alloc(sc, &bf->bf_buf_addr, GFP_KERNEL);
 		if (!skb) {
 			error = -ENOMEM;
 			goto rx_init_fail;
@@ -227,19 +294,9 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 		memset(skb->data, 0, common->rx_bufsize);
 		bf->bf_mpdu = skb;
 
-		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-						 common->rx_bufsize,
-						 DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(sc->dev,
-						bf->bf_buf_addr))) {
-				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
-				bf->bf_buf_addr = 0;
-				ath_err(common,
-					"dma_mapping_error() on RX init\n");
-				error = -ENOMEM;
-				goto rx_init_fail;
-		}
+		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+					   common->rx_bufsize,
+					   DMA_BIDIRECTIONAL);
 
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
 	}
@@ -278,8 +335,18 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
 			     sc->sc_ah->caps.rx_status_len;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-		return ath_rx_edma_init(sc, nbufs);
+	error = ath_rx_page_pool_create(sc, nbufs);
+	if (error)
+		return error;
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		error = ath_rx_edma_init(sc, nbufs);
+		if (error) {
+			page_pool_destroy(sc->rx.page_pool);
+			sc->rx.page_pool = NULL;
+		}
+		return error;
+	}
 
 	ath_dbg(common, CONFIG, "cachelsz %u rxbufsize %u\n",
 		common->cachelsz, common->rx_bufsize);
@@ -296,27 +363,16 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = ath_rxbuf_alloc(common, common->rx_bufsize,
-				      GFP_KERNEL);
+		skb = ath_rx_buf_alloc(sc, &bf->bf_buf_addr, GFP_KERNEL);
 		if (skb == NULL) {
 			error = -ENOMEM;
 			goto err;
 		}
 
 		bf->bf_mpdu = skb;
-		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-						 common->rx_bufsize,
-						 DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(sc->dev,
-					       bf->bf_buf_addr))) {
-			dev_kfree_skb_any(skb);
-			bf->bf_mpdu = NULL;
-			bf->bf_buf_addr = 0;
-			ath_err(common,
-				"dma_mapping_error() on RX init\n");
-			error = -ENOMEM;
-			goto err;
-		}
+		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+					   common->rx_bufsize,
+					   DMA_FROM_DEVICE);
 	}
 	sc->rx.rxlink = NULL;
 err:
@@ -328,27 +384,24 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 void ath_rx_cleanup(struct ath_softc *sc)
 {
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct sk_buff *skb;
 	struct ath_rxbuf *bf;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		ath_rx_edma_cleanup(sc);
-		return;
-	}
-
-	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = bf->bf_mpdu;
-		if (skb) {
-			dma_unmap_single(sc->dev, bf->bf_buf_addr,
-					 common->rx_bufsize,
-					 DMA_FROM_DEVICE);
-			dev_kfree_skb(skb);
-			bf->bf_buf_addr = 0;
-			bf->bf_mpdu = NULL;
+	} else {
+		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+			skb = bf->bf_mpdu;
+			if (skb) {
+				dev_kfree_skb(skb);
+				bf->bf_buf_addr = 0;
+				bf->bf_mpdu = NULL;
+			}
 		}
 	}
+
+	page_pool_destroy(sc->rx.page_pool);
+	sc->rx.page_pool = NULL;
 }
 
 /*
@@ -1118,7 +1171,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
+		requeue_skb = ath_rx_buf_alloc(sc, &new_buf_addr, GFP_ATOMIC);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
@@ -1130,16 +1183,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		}
 
 		/* We will now give hardware our shiny new allocated skb */
-		new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
-					      common->rx_bufsize, dma_type);
-		if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
-			dev_kfree_skb_any(requeue_skb);
-			goto requeue_drop_frag;
-		}
-
-		/* Unmap the frame */
-		dma_unmap_single(sc->dev, bf->bf_buf_addr,
-				 common->rx_bufsize, dma_type);
+		dma_sync_single_for_device(sc->dev, new_buf_addr,
+					   common->rx_bufsize, dma_type);
 
 		bf->bf_mpdu = requeue_skb;
 		bf->bf_buf_addr = new_buf_addr;
-- 
2.56.0

