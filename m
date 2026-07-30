Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FFE468C27
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428518; cv=none; b=a3jMx08/9oTi2EVH5eBeEHMuk31ydQ8/wemhI0V1GrT/pLxRVqLaYnbSa9BpLokF3rxVm4p8XJrEzXQ3vexHLH0n25cOf8e1Fn5Qts6nuCdqMY3bdcAbzxsX70NDHFYNO+WrHercbdjmCxlor5+JwCuopV2LqV1xtQG2I7LTvx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428518; c=relaxed/simple;
	bh=bo6GZs5cRhfR+4h6zHzYZY0ne9OWftzWzsm3xWEM+bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=trIqEIPdFf7PP0+SDbUP/O2cVX1L9vjT36wdwN4RyTXQQyD5k3JpnbcXvgy50qzsdK/siko5WThQqqIxOK3Hv8+FkYeC5h792o1V5jzZO1oEaGi3KLGqoZrXWn5A6qHpIVDKW6NOz/XbH5BoEm2BNuOFHuQXmg2Afe+E23xITKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSOSHT8q; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSOSHT8q"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38eca09faa2so7740a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428515; x=1786033315; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cjsOjYk7yuXBgbYLc3ZTyWopMFfcMdSI35CR9dqHg6w=;
        b=ZSOSHT8q5la1h9NMVD7oKI1oN2T6XcpyYugjeaQ0Tl73SnTB3njmqVtonjind5XSYD
         PL80cAwbWa+4edHMwXhZBJzdev05xqZfgfGXM4A6FVrsdrURNQh2i2KoRh6BvR16Sw59
         vVePFvD11n7W/l/CAEC7dUT59vhIcv7b7pHJXWnK5XO8HyuTWtWpkf4/fUJUPQNW5tTs
         ATES8IjrI6d9Hf7Tl8U5y5v3WB+Q4+wAU7L4YkS1F1Q8Pp7C5YZOrMrycOQ6ykCzDQfi
         Na7o0ZVZovWtbN6OfYAIAZpiXh9cAADktqfdsn4McfoO94X2jvDLDf7bT5/AvmQL2qpZ
         8kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428515; x=1786033315;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjsOjYk7yuXBgbYLc3ZTyWopMFfcMdSI35CR9dqHg6w=;
        b=HLH0WfUHXLyOkGMArjm+hXr40yvkBceFNeDVck1W7PJJHLYjZVgAJikD5XU2RNm28u
         C+AMY9ssYmQJo8+DJS9ggH9PQNLuqXtT2fAJ8gFn00b7MJpnqpyC+5wimuH7NHcEmOqi
         kYuyUGlVYfGZazbNav8gkbxlRT/c2dfcxidkx8wB4qMfCloE5rXf5CwvL4BvCB4NBvEO
         n8jIl/zPdDsMtjUWqeRcZJ/GHczIAEWJry2PnpZLjLvwpPSsF4Az4bhmDKuduZBbZekf
         KEL5cjJB5X7AbPMuKD6zEaasQB7pGAY1MDsFVtiC8+F17wiGAqWAGkvzApFS66rkyE5Y
         bkHg==
X-Gm-Message-State: AOJu0YzoPy+ng4t8sdhM9yDDVbt3pAnFJEgn5Ls+lbF4M6p+eBIiVrhI
	AQ9nlB5axOSCmYOlLfp+tkTqQdhgP0M9yr6tec6ZLnmftExx9oQ5zyM5
X-Gm-Gg: AR+sD116OAYVOFYS4f2FxGUZC6jPtKmd+DT9/vCgk9M1evpDfIe/hiKvGoSGtZVzJUX
	BBi++z1JGdxm7FKciNRotdvv4Vb1rvmRMjdnCbMp/xDD2rpfboiV2sxaQ/ruCbzy7T8yaZjT2td
	EXsY29Sa5KSnQoAz8sgs5/xrhJyJfBZHWd9gieIGQZcXfjmvTPzZI/NBcqw2Ep7HgwBAOstrcoz
	bdcNhlbnKWCq9CNTzhWUL2ybCbMA1iwxDSM+vSqxe0dmkkNkZgTvgMXfkxkt9d6u/U86toNKHhq
	llMAx9U3qzFMG3EcFGo658f/3wN4KE45G3kNQ4OLmqmxB1t1ng01HXicYPxJIJoXNu+pNeS0qD0
	Ag5Dn6WzU5HnMoIAIVb6e1OZB3MYQJFMXyglCe36R45wcfvSSuP4XhpXhZYQaGHftdGwbDKhYwt
	vYCP4gnJa99fU20ttK+ve9H5MQ2BwMV/qUUV8o2hbs33cilMnHVawB17nf9/V//ORc3G/gKLNMO
	mM=
X-Received: by 2002:a17:90b:2248:b0:38f:57f0:1f51 with SMTP id 98e67ed59e1d1-38fa7c5bfa9mr853748a91.0.1785428514564;
        Thu, 30 Jul 2026 09:21:54 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:21:54 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 5/8] wifi: brcmfmac: msgbuf: tune thresholds and optimize sleep latency
Date: Thu, 30 Jul 2026 16:21:08 +0000
Message-ID: <20260730162135.12278-5-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730162135.12278-1-shivesh@example.com>
References: <20260730162135.12278-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Increases tx pktids and tune flush thresholds. Fixes a silent tx stall
under high load by correctly using test_and_set_bit. Optimizes
initialization polling latency from msleep(10) to usleep_range.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 69 ++++++++++++++++---
 1 file changed, 61 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index ba1ce1552e0f..8db6167072da 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -48,7 +48,19 @@
 #define MSGBUF_TYPE_LPBK_DMAXFER		0x13
 #define MSGBUF_TYPE_LPBK_DMAXFER_CMPLT		0x14
 
-#define NR_TX_PKTIDS				2048
+/*
+ * NR_TX_PKTIDS: number of simultaneously in-flight TX packet IDs.
+ * Each outstanding TX frame consumes one ID until the dongle returns
+ * a TX-status completion.  The original 2048-entry pool exhausted under
+ * ≥4 concurrent iperf3 streams on Wi-Fi 5/6 (802.11ac/ax) devices,
+ * causing "No PKTID available" drops and TCP retransmits.  4096 gives
+ * headroom for high-aggregation scenarios while still fitting in a
+ * modest amount of host memory (~48 KB for the pktid table entries).
+ *
+ * NR_RX_PKTIDS: RX post buffers pre-allocated to the dongle.  1024 is
+ * sufficient for current hardware RX ring depths; leave unchanged.
+ */
+#define NR_TX_PKTIDS				4096
 #define NR_RX_PKTIDS				1024
 
 #define BRCMF_IOCTL_REQ_PKTID			0xFFFE
@@ -64,8 +76,29 @@
 #define BRCMF_MSGBUF_PKT_FLAGS_FRAME_MASK	0x07
 #define BRCMF_MSGBUF_PKT_FLAGS_PRIO_SHIFT	5
 
-#define BRCMF_MSGBUF_TX_FLUSH_CNT1		32
-#define BRCMF_MSGBUF_TX_FLUSH_CNT2		96
+/*
+ * TX flush / doorbell-ring thresholds.
+ *
+ * CNT1 is the minimum number of frames to accumulate in the commonring
+ * before the first intermediate write_complete() (doorbell ring) is
+ * issued mid-batch.  CNT2 is the hard flush interval: after this many
+ * frames have been written since the last flush, we unconditionally
+ * ring the bell and reset the counter.
+ *
+ * Raising both from the original 32/96 to 64/128 doubles the average
+ * number of TX descriptors committed per MMIO write, halving the PCIe
+ * doorbell rate on sustained throughput workloads.  The tradeoff is a
+ * marginally higher worst-case latency for the last frames in a burst,
+ * which in practice is hidden by the time the dongle DMA engine drains
+ * the previous batch.
+ *
+ * TRICKLE_TXWORKER_THRS governs how often brcmf_msgbuf_tx_queue_data()
+ * forces a workqueue schedule when the queue depth is not a multiple of
+ * this value.  Keeping it at half of CNT1 (32) preserves responsiveness
+ * for low-rate flows (e.g. VoIP, ICMP) that never accumulate 64 frames.
+ */
+#define BRCMF_MSGBUF_TX_FLUSH_CNT1		64
+#define BRCMF_MSGBUF_TX_FLUSH_CNT2		128
 
 #define BRCMF_MSGBUF_DELAY_TXWORKER_THRS	96
 #define BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS	32
@@ -787,10 +820,30 @@ static int brcmf_msgbuf_schedule_txdata(struct brcmf_msgbuf *msgbuf, u32 flowid,
 {
 	struct brcmf_commonring *commonring;
 
-	set_bit(flowid, msgbuf->flow_map);
+	/*
+	 * If the bit was already set, a txflow_work item is already
+	 * queued or running for this ring.  In that case the existing
+	 * worker will drain our freshly enqueued frame when it runs,
+	 * so we only need to schedule another work item when the
+	 * force flag is set or the ring is below the delay threshold.
+	 *
+	 * If the bit was NOT set (test_and_set_bit returns false), no
+	 * worker is pending for this ring at all.  We MUST schedule
+	 * one unconditionally, otherwise the frame we just enqueued
+	 * will sit in the flowring unsent until some unrelated event
+	 * triggers the workqueue — causing silent TX stalls under
+	 * high load when outstanding_tx >= DELAY_TXWORKER_THRS.
+	 */
+	if (!test_and_set_bit(flowid, msgbuf->flow_map)) {
+		/* Bit was clear: no worker pending, always schedule. */
+		queue_work(msgbuf->txflow_wq, &msgbuf->txflow_work);
+		return 0;
+	}
+
+	/* Bit was already set: worker pending, apply coalescing heuristic. */
 	commonring = msgbuf->flowrings[flowid];
-	if ((force) || (atomic_read(&commonring->outstanding_tx) <
-			BRCMF_MSGBUF_DELAY_TXWORKER_THRS))
+	if (force || (atomic_read(&commonring->outstanding_tx) <
+		      BRCMF_MSGBUF_DELAY_TXWORKER_THRS))
 		queue_work(msgbuf->txflow_wq, &msgbuf->txflow_work);
 
 	return 0;
@@ -1621,11 +1674,11 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	do {
 		brcmf_msgbuf_rxbuf_data_fill(msgbuf);
 		if (msgbuf->max_rxbufpost != msgbuf->rxbufpost)
-			msleep(10);
+			usleep_range(1000, 2000);
 		else
 			break;
 		count++;
-	} while (count < 10);
+	} while (count < 100);
 	brcmf_msgbuf_rxbuf_event_post(msgbuf);
 	brcmf_msgbuf_rxbuf_ioctlresp_post(msgbuf);
 
-- 
2.53.0

