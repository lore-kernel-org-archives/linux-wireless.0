Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [84.16.66.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE25511202
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 16:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787066; cv=none; b=pLwv5s18v9zOOfG36M7k0hxMFmHZ+DM2cDdmUBb4pwwzOfq+2sCfb3ANwRFFPbt9MpHGuACE4ArtkCZkC3FYB25RJbIB+AFC9onLqHaM9DnteYJV4aaOE7rVkUMan7lVqHaRSzGfgogG3MEOMY4dzZFWSXdcQFs65YP1V1T5uvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787066; c=relaxed/simple;
	bh=tPmMRt+fbon84goSMryDxiLW8itNfAjjy1Ac7Ps011A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQxVlzGkoJAK1B12H2F+mw+s0eDCDfxWLd4FutNkfBQYQUBAQi9Qs6b/i/ltG6Picb3OMKH80tSHW2Y5L6iEA07tmpKGYIihmgNwUOJHmgd/WjyEEHNRYZZw3GR4SXQnbHBgk1obvL5hl0bUPogYSCReXCL/5wZWZlRub5C0ouE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=etik.com; spf=pass smtp.mailfrom=etik.com; dkim=pass (1024-bit key) header.d=etik.com header.i=@etik.com header.b=Uxad+iiO; arc=none smtp.client-ip=84.16.66.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=etik.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etik.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=etik.com header.i=@etik.com header.b="Uxad+iiO"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hw1JZ3f9Zz8Z1
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 18:50:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=etik.com;
	s=20210927; t=1790787054;
	bh=YNHZ+7rGRAlI1tCmAXMpng03DJZ24AzCUirnUl7KIFE=;
	h=From:To:Cc:Subject:Date:From;
	b=Uxad+iiOgt0IiU2xOiybn3VvgZidrIUdF8Ix2c3DgM3PfUR48bKA//ABmEZzoVdNg
	 5I5Ox2gPuwqedVePz1ebGPXN4PW7ZT6F+0N82WrRHI8n13tdp+Tl7dnnS17h/0W6VB
	 pRoDkmYeq7rOIHIsXiyO5b0c/wtNRUDYHIbOm7fo=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4hw1JY5p51zcg4;
	Wed, 30 Sep 2026 18:50:53 +0200 (CEST)
From: Eduard Hart <eduard.hart@etik.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath11k: use smaller DP rings on low-memory systems
Date: Wed, 30 Sep 2026 18:50:52 +0200
Message-ID: <20260930165052.4998-1-eduard.hart@etik.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: :df975dad7d14b05:ham:e0a7e91052d2b43
X-Infomaniak-Routing: alpha

The data path rings are sized for systems with plenty of RAM. On
IPQ5018 boards with 256 MiB of RAM and a second radio (e.g. QCN6122),
the RX buffers and TX completion rings of both radios take so much
memory that the system runs out of memory shortly after bringing up
both interfaces.

Like ath12k does in ath12k_core_get_memory_mode(), look at the total
system RAM and pick a low-memory DP profile when it is below 256 MiB.
Reserved memory regions are not part of totalram, so boards with 512 MiB
stay well above the threshold and keep the current ring sizes.

The low-memory profile uses:
  TX completion ring:     32768 -> 2048
  RXDMA buffer ring:       4096 -> 1024
  RXDMA monitor status:    1024 ->  512
  RXDMA monitor buffer:    4096 ->  128
  RXDMA monitor dest:      2048 ->  128

The TX completion ring size is also used for the tx_status FIFO and the
IDR range of outstanding TX buffers, so ATH11K_TX_COMPL_NEXT() now wraps
at the selected ring size instead of the compile-time constant.

With this, both radios of a TP-Link RE700X (IPQ5018 + QCN6122, 256 MiB)
stay up under load (4-6 clients) with 14-37 MiB of RAM available and no
OOM, about the same as a 256 MiB build that shrinks the rings at compile
time.

Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6122 hw1.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: Eduard Hart <eduard.hart@etik.com>
---
 drivers/net/wireless/ath/ath11k/dp.c    | 50 +++++++++++++++++++++++--
 drivers/net/wireless/ath/ath11k/dp.h    | 13 ++++++-
 drivers/net/wireless/ath/ath11k/dp_rx.c |  9 +++--
 drivers/net/wireless/ath/ath11k/dp_tx.c | 12 +++---
 4 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index be65d73b904b..2db4f98ed446 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -5,6 +5,8 @@
  */
 
 #include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
 #include "core.h"
 #include "dp_tx.h"
 #include "hal_tx.h"
@@ -414,7 +416,7 @@ static int ath11k_dp_srng_common_setup(struct ath11k_base *ab)
 
 		ret = ath11k_dp_srng_setup(ab, &dp->tx_ring[i].tcl_comp_ring,
 					   HAL_WBM2SW_RELEASE, wbm_num, 0,
-					   DP_TX_COMP_RING_SIZE);
+					   dp->profile->tx_comp_ring_size);
 		if (ret) {
 			ath11k_warn(ab, "failed to set up tcl_comp ring (%d) :%d\n",
 				    i, ret);
@@ -1047,6 +1049,45 @@ void ath11k_dp_free(struct ath11k_base *ab)
 	/* Deinit any SOC level resource */
 }
 
+static const struct ath11k_dp_profile_params ath11k_dp_profile_default = {
+	.tx_comp_ring_size = DP_TX_COMP_RING_SIZE,
+	.rxdma_buf_ring_size = DP_RXDMA_BUF_RING_SIZE,
+	.rxdma_mon_status_ring_size = DP_RXDMA_MON_STATUS_RING_SIZE,
+	.rxdma_monitor_buf_ring_size = DP_RXDMA_MONITOR_BUF_RING_SIZE,
+	.rxdma_monitor_dst_ring_size = DP_RXDMA_MONITOR_DST_RING_SIZE,
+};
+
+static const struct ath11k_dp_profile_params ath11k_dp_profile_low_mem = {
+	.tx_comp_ring_size = 2048,
+	.rxdma_buf_ring_size = 1024,
+	.rxdma_mon_status_ring_size = 512,
+	.rxdma_monitor_buf_ring_size = 128,
+	.rxdma_monitor_dst_ring_size = 128,
+};
+
+static const struct ath11k_dp_profile_params *
+ath11k_dp_get_profile(struct ath11k_base *ab)
+{
+	struct sysinfo si;
+	u64 total_ram;
+
+	si_meminfo(&si);
+	total_ram = (u64)si.totalram * si.mem_unit;
+
+	/* Reserved memory (firmware, TZ, ...) is not part of totalram, so a
+	 * 512 MiB board reports well above 256 MiB while a 256 MiB board with
+	 * two radios does not have enough memory for the default rings.
+	 */
+	if (total_ram < SZ_256M) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT,
+			   "using low memory DP ring sizes (%llu MiB RAM)\n",
+			   total_ram / SZ_1M);
+		return &ath11k_dp_profile_low_mem;
+	}
+
+	return &ath11k_dp_profile_default;
+}
+
 int ath11k_dp_alloc(struct ath11k_base *ab)
 {
 	struct ath11k_dp *dp = &ab->dp;
@@ -1057,6 +1098,7 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
 	int i;
 
 	dp->ab = ab;
+	dp->profile = ath11k_dp_get_profile(ab);
 
 	INIT_LIST_HEAD(&dp->reo_cmd_list);
 	INIT_LIST_HEAD(&dp->reo_cmd_cache_flush_list);
@@ -1084,7 +1126,8 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
 	if (ret)
 		goto fail_link_desc_cleanup;
 
-	size = sizeof(struct hal_wbm_release_ring) * DP_TX_COMP_RING_SIZE;
+	size = sizeof(struct hal_wbm_release_ring) *
+	       dp->profile->tx_comp_ring_size;
 
 	for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
 		idr_init(&dp->tx_ring[i].txbuf_idr);
@@ -1092,7 +1135,8 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
 		dp->tx_ring[i].tcl_data_ring_id = i;
 
 		dp->tx_ring[i].tx_status_head = 0;
-		dp->tx_ring[i].tx_status_tail = DP_TX_COMP_RING_SIZE - 1;
+		dp->tx_ring[i].tx_status_tail =
+			dp->profile->tx_comp_ring_size - 1;
 		dp->tx_ring[i].tx_status = kmalloc(size, GFP_KERNEL);
 		if (!dp->tx_ring[i].tx_status) {
 			ret = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 84f66839f0c6..62e2c43da407 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -78,7 +78,7 @@ struct dp_rxdma_ring {
 	int bufs_max;
 };
 
-#define ATH11K_TX_COMPL_NEXT(x)	(((x) + 1) % DP_TX_COMP_RING_SIZE)
+#define ATH11K_TX_COMPL_NEXT(dp, x)	(((x) + 1) % (dp)->profile->tx_comp_ring_size)
 
 struct dp_tx_ring {
 	u8 tcl_data_ring_id;
@@ -206,7 +206,6 @@ struct ath11k_pdev_dp {
 #define DP_TCL_DATA_RING_SIZE		512
 #define DP_TCL_DATA_RING_SIZE_WCN6750	2048
 #define DP_TX_COMP_RING_SIZE		32768
-#define DP_TX_IDR_SIZE			DP_TX_COMP_RING_SIZE
 #define DP_TCL_CMD_RING_SIZE		32
 #define DP_TCL_STATUS_RING_SIZE		32
 #define DP_REO_DST_RING_MAX		4
@@ -254,8 +253,18 @@ struct ath11k_hp_update_timer {
 	struct ath11k_base *ab;
 };
 
+/* DP ring sizes that depend on the available system memory */
+struct ath11k_dp_profile_params {
+	u32 tx_comp_ring_size;
+	u32 rxdma_buf_ring_size;
+	u32 rxdma_mon_status_ring_size;
+	u32 rxdma_monitor_buf_ring_size;
+	u32 rxdma_monitor_dst_ring_size;
+};
+
 struct ath11k_dp {
 	struct ath11k_base *ab;
+	const struct ath11k_dp_profile_params *profile;
 	enum ath11k_htc_ep_id eid;
 	struct completion htt_tgt_version_received;
 	u8 htt_tgt_ver_major;
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6d95f7b343a5..64063c3f1983 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -578,7 +578,8 @@ static int ath11k_dp_rx_pdev_srng_alloc(struct ath11k *ar)
 	ret = ath11k_dp_srng_setup(ar->ab,
 				   &dp->rx_refill_buf_ring.refill_buf_ring,
 				   HAL_RXDMA_BUF, 0,
-				   dp->mac_id, DP_RXDMA_BUF_RING_SIZE);
+				   dp->mac_id,
+				   ab->dp.profile->rxdma_buf_ring_size);
 	if (ret) {
 		ath11k_warn(ar->ab, "failed to setup rx_refill_buf_ring\n");
 		return ret;
@@ -613,7 +614,7 @@ static int ath11k_dp_rx_pdev_srng_alloc(struct ath11k *ar)
 		ret = ath11k_dp_srng_setup(ar->ab,
 					   srng,
 					   HAL_RXDMA_MONITOR_STATUS, 0, dp->mac_id + i,
-					   DP_RXDMA_MON_STATUS_RING_SIZE);
+					   ab->dp.profile->rxdma_mon_status_ring_size);
 		if (ret) {
 			ath11k_warn(ar->ab,
 				    "failed to setup rx_mon_status_refill_ring %d\n", i);
@@ -636,7 +637,7 @@ static int ath11k_dp_rx_pdev_srng_alloc(struct ath11k *ar)
 	ret = ath11k_dp_srng_setup(ar->ab,
 				   &dp->rxdma_mon_buf_ring.refill_buf_ring,
 				   HAL_RXDMA_MONITOR_BUF, 0, dp->mac_id,
-				   DP_RXDMA_MONITOR_BUF_RING_SIZE);
+				   ab->dp.profile->rxdma_monitor_buf_ring_size);
 	if (ret) {
 		ath11k_warn(ar->ab,
 			    "failed to setup HAL_RXDMA_MONITOR_BUF\n");
@@ -645,7 +646,7 @@ static int ath11k_dp_rx_pdev_srng_alloc(struct ath11k *ar)
 
 	ret = ath11k_dp_srng_setup(ar->ab, &dp->rxdma_mon_dst_ring,
 				   HAL_RXDMA_MONITOR_DST, 0, dp->mac_id,
-				   DP_RXDMA_MONITOR_DST_RING_SIZE);
+				   ab->dp.profile->rxdma_monitor_dst_ring_size);
 	if (ret) {
 		ath11k_warn(ar->ab,
 			    "failed to setup HAL_RXDMA_MONITOR_DST\n");
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index cac970c92806..a67aea979f8c 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -122,7 +122,7 @@ int ath11k_dp_tx(struct ath11k *ar, struct ath11k_vif *arvif,
 
 	spin_lock_bh(&tx_ring->tx_idr_lock);
 	ret = idr_alloc(&tx_ring->txbuf_idr, skb, 0,
-			DP_TX_IDR_SIZE - 1, GFP_ATOMIC);
+			dp->profile->tx_comp_ring_size - 1, GFP_ATOMIC);
 	spin_unlock_bh(&tx_ring->tx_idr_lock);
 
 	if (unlikely(ret < 0)) {
@@ -701,17 +701,17 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 
 	ath11k_hal_srng_access_begin(ab, status_ring);
 
-	while ((ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_head) !=
+	while ((ATH11K_TX_COMPL_NEXT(dp, tx_ring->tx_status_head) !=
 		tx_ring->tx_status_tail) &&
 	       (desc = ath11k_hal_srng_dst_get_next_entry(ab, status_ring))) {
 		memcpy(&tx_ring->tx_status[tx_ring->tx_status_head],
 		       desc, sizeof(struct hal_wbm_release_ring));
 		tx_ring->tx_status_head =
-			ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_head);
+			ATH11K_TX_COMPL_NEXT(dp, tx_ring->tx_status_head);
 	}
 
 	if (unlikely((ath11k_hal_srng_dst_peek(ab, status_ring) != NULL) &&
-		     (ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_head) ==
+		     (ATH11K_TX_COMPL_NEXT(dp, tx_ring->tx_status_head) ==
 		      tx_ring->tx_status_tail))) {
 		/* TODO: Process pending tx_status messages when kfifo_is_full() */
 		ath11k_warn(ab, "Unable to process some of the tx_status ring desc because status_fifo is full\n");
@@ -721,12 +721,12 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 
 	spin_unlock_bh(&status_ring->lock);
 
-	while (ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail) != tx_ring->tx_status_head) {
+	while (ATH11K_TX_COMPL_NEXT(dp, tx_ring->tx_status_tail) != tx_ring->tx_status_head) {
 		struct hal_wbm_release_ring *tx_status;
 		u32 desc_id;
 
 		tx_ring->tx_status_tail =
-			ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail);
+			ATH11K_TX_COMPL_NEXT(dp, tx_ring->tx_status_tail);
 		tx_status = &tx_ring->tx_status[tx_ring->tx_status_tail];
 		ath11k_dp_tx_status_parse(ab, tx_status, &ts);
 
-- 
2.54.0 (Apple Git-157)

