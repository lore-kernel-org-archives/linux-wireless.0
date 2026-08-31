Received: from mail01.salmtek.com (mail01.salmtek.com [65.108.149.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D0B46AED1;
	Mon, 31 Aug 2026 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.108.149.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788189500; cv=none; b=hyxQt6LgGzYFXABGkwAuVl7NQRqfu1pi0ww3UO1Wx7tO9c3tBRJJ98OQv4W6OERD76TIdgTeA8R8fP+BVWQ/Qi4bVBS9lobVgLK09BxBxx3+mzGVXBajf6iiVm2MHXOsenhvadGXpytIDqizW/iHMAX54ND6o8m48lXIfUhyPMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788189500; c=relaxed/simple;
	bh=oG7pZxVGZAS2196JAGe5LmrXqPzUtp/DMka9joAiDwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m10769jr52+3HN17RGMfeluDB6QM15eEjMaHkeZYN4mwKlRD/rFar3dq+Up/8XZwnuiO2Hm3fKN3RZPtszw8ESfV9SPiq35HR3rt/6/gt2SzqWv2GQnkn/k8MeucQade1ylsJIQ2LDqdOHCnq5YMmQtdWEOKDdsGowLGbfUZC1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salmtek.com; spf=none smtp.mailfrom=salmtek.com; dkim=pass (2048-bit key) header.d=salmtek.com header.i=@salmtek.com header.b=URLmNjwp; arc=none smtp.client-ip=65.108.149.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salmtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=salmtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salmtek.com header.i=@salmtek.com header.b="URLmNjwp"
Received: from mail01.salmtek.com (localhost.localdomain [127.0.0.1])
	by mail01.salmtek.com (Proxmox) with ESMTP id EA40E40917;
	Mon, 31 Aug 2026 12:11:13 -0300 (-03)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salmtek.com; h=
	cc:cc:content-transfer-encoding:date:from:from:message-id
	:mime-version:reply-to:subject:subject:to:to; s=selector01; bh=n
	JA55XNvLE2Wi1SwAhyde34kstoTKEwzY+Xqkq/NX3M=; b=URLmNjwpwfsjv+p2G
	SG6cyniA6RH6L/B3ZKMBrv11XvOou6btzUDo2+1cbBfa8VvjmuNd8G+9WP65U/hS
	gQx9q3w0TUIu2WmIMGLC+YefqkNEj6U8NwVJY7YrMIuDab88dJ4mY61WV6sJj25I
	jE/zN0SjNfP+3vLhAhzoh1mBQEH7t1zvVYtC2LFqsEcyhwR4ydkcn84QX9PWZpmd
	f2oOwz3SnKRthXsFhL4vUPgEEQmQt11jDJDaXQT7auD/7jwL1UPf/AjUtB2tce0H
	+HeOWyZLiacDReKAMUQxViwbZcsvFzmGdgSAyGGSzI+fize0U56sQF90JIhCIyl3
	fh9Ig==
From: Sebastian Salmhofer <sebastian.salmhofer@salmtek.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sebastian Salmhofer <sebastian.salmhofer@salmtek.com>
Subject: [PATCH] wifi: ath12k: flush REO queue extension descriptors before freeing the qdesc
Date: Mon, 31 Aug 2026 12:10:11 -0300
Message-ID: <20260831151011.2336305-1-sebastian.salmhofer@salmtek.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit b706fb4e580b ("wifi: ath12k: Use 1KB Cache Flush Command
for QoS TID Descriptors") a QoS TID RX queue descriptor is retired with
a single FLUSH_CACHE command carrying FLUSH_QUEUE_1K_DESC. On QCN9274
that command does not cover the extension descriptors that follow the
queue descriptor in the same 1536-byte allocation. Those hold the MPDU
link pointers and are written by REO on every enqueue and dequeue, so
they are frequently dirty in the REO cache when the TID is deleted.

After the qdesc is unmapped and freed, the REO cache controller later
evicts the stale extension lines and writes them back to the old DMA
address. On a host with the IOMMU enabled this shows up as a burst of
AMD-Vi IO_PAGE_FAULT write events at 128-byte spacing, e.g.

  AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0038 address=0xf6e7a100 flags=0x0020]
  AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0038 address=0xf6e7a180 flags=0x0020]
  ...
  AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0038 address=0xf6e7a580 flags=0x0020]

The faulting addresses always fall at offsets 0x100..0x580 of a
retired qdesc and never at 0x000 or 0x080, i.e. exactly the ten
extension descriptors and never the queue descriptor or the 1K bitmap
descriptor. The writes are triggered by later REO activity, typically
a new station association, so they can occur minutes or hours after the
memory was freed, and the blocked transactions stall the data path for
several seconds. Without an IOMMU the same writes silently corrupt
whatever now occupies that memory.

Restore the per-segment flush of every 128-byte line above the queue
descriptor, as ath11k still does, before issuing the base flush with
FLUSH_QUEUE_1K_DESC and NEED_STATUS. REO commands execute in order, so
the status of the final base flush also confirms the preceding segment
flushes have completed, and the qdesc is still only freed from that
completion. A send failure in the sequence leaves the descriptor on the
retirement list for retry, as before.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: b706fb4e580b ("wifi: ath12k: Use 1KB Cache Flush Command for QoS TID Descriptors")
Signed-off-by: Sebastian Salmhofer <sebastian.salmhofer@salmtek.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 39 ++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -225,22 +225,43 @@
 				    struct ath12k_dp_rx_tid_rxq *rx_tid)
 {
 	struct ath12k_hal_reo_cmd cmd = {};
+	dma_addr_t paddr = rx_tid->qbuf.paddr_aligned;
+	u32 off = rx_tid->qbuf.size;
 	int ret;
 
-	cmd.addr_lo = lower_32_bits(rx_tid->qbuf.paddr_aligned);
-	cmd.addr_hi = upper_32_bits(rx_tid->qbuf.paddr_aligned);
+	/* The REO cache controller caches the queue descriptor and each
+	 * 128-byte extension descriptor as separate objects, and a
+	 * FLUSH_CACHE command only addresses one of them. FLUSH_QUEUE_1K_DESC
+	 * extends the base flush to the 1K-window descriptor but does not
+	 * cover the extension descriptors, so flush those explicitly first.
+	 * The command ring executes in order, hence the final base flush
+	 * status also confirms the extension flushes have completed.
+	 */
+	while (off > HAL_LINK_DESC_ALIGN) {
+		off -= HAL_LINK_DESC_ALIGN;
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.addr_lo = lower_32_bits(paddr + off);
+		cmd.addr_hi = upper_32_bits(paddr + off);
+		ret = ath12k_wifi7_dp_reo_cmd_send(ab, rx_tid,
+						   HAL_REO_CMD_FLUSH_CACHE,
+						   &cmd, NULL);
+		if (ret) {
+			ath12k_warn(ab,
+				    "failed to send FLUSH_CACHE for tid %d offset 0x%x: %d\n",
+				    rx_tid->tid, off, ret);
+			return ret;
+		}
+	}
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.addr_lo = lower_32_bits(paddr);
+	cmd.addr_hi = upper_32_bits(paddr);
 	/* HAL_REO_CMD_FLG_FLUSH_FWD_ALL_MPDUS - all pending MPDUs
-	 *in the bitmap will be forwarded/flushed to REO output rings
+	 * in the bitmap will be forwarded/flushed to REO output rings
 	 */
 	cmd.flag = HAL_REO_CMD_FLG_NEED_STATUS |
 		   HAL_REO_CMD_FLG_FLUSH_FWD_ALL_MPDUS;
 
-	/* For all QoS TIDs (except NON_QOS), the driver allocates a maximum
-	 * window size of 1024. In such cases, the driver can issue a single
-	 * 1KB descriptor flush command instead of sending multiple 128-byte
-	 * flush commands for each QoS TID, improving efficiency.
-	 */
-
 	if (rx_tid->tid != HAL_DESC_REO_NON_QOS_TID)
 		cmd.flag |= HAL_REO_CMD_FLG_FLUSH_QUEUE_1K_DESC;
 
--
2.47.0

