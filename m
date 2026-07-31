Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198194499BE
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512968; cv=none; b=T9GcxVAWJ2vuauX0tDmaYvfjz+rwGuux5M8Zj6mUHSVzvZG0QWTrkG/vIYfnaccwRXAtroUO2hyBqEW1n8VvryBSdjtTRxCy/VdRCLqHUBWKuhJ7wOH5at86qjSo1oxtIkMPJOze2t2FhywLS5+diAvaEOR1+GjLzcQOYrF/rmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512968; c=relaxed/simple;
	bh=bo6GZs5cRhfR+4h6zHzYZY0ne9OWftzWzsm3xWEM+bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3O6e2WhwDi6QWdknbVRG7G9FsZTiYujRoQ56EUPcvFYrbUyVeK4vIw7KmaX+OiAXdUV0Qtg54OfuddxEd2f5eka5XMjWkQnKj3VLLBGHSCqJSIwJTSZRV4Yrnl9Bt8+cjtU8j6IkAbj2+f3h2yFcaoexFlMHtpadPW8gaFBG3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khfBC/8q; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khfBC/8q"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ccdce28edeso1166175ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512965; x=1786117765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cjsOjYk7yuXBgbYLc3ZTyWopMFfcMdSI35CR9dqHg6w=;
        b=khfBC/8qgCqymQftNSjQzWzpxk5yfkqVg1IrQrWbzVcwuc/Fxjzr3nhFmMrJ/Tn0X9
         pUjodzYaCngKP443ZPt9tu/MX7P4CmaJhxyemYtNjLu7cPyuhbQ2ybs0Npqzr5/WJ/Ba
         ch4tggiBLnEQAnnzOMeYa/4thPQo+ySuCyp7Q1LIxa6rtk1mgbXJZk4U/3zuqvYwSeZu
         ahKC/hwzs7sVimOMYZM62gjlsbZLhtD8eWuGuNjx2Xp9Z4+KdkhQ2aLv4JqVYAr0lEaF
         GC4fdMNNvlexJsDD5W0mT1l9p/Q4XB4ofFi4tjhNXPe6DqFYMucyb9Nk6TGNuEgCjKMF
         UTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512965; x=1786117765;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjsOjYk7yuXBgbYLc3ZTyWopMFfcMdSI35CR9dqHg6w=;
        b=Xr/Hx4skfb8RwssF8E5vH8m7z/X+ZvjpLdg6/3iAnrss+Q7iTlPVV7nBKgfuJDpEQU
         7TO7Wq5zBnOZqqHZf6Utzcv88J4yamxUri1U0P6s+0HYIUlkFDP57AOvUpLpZozfpBmb
         og4onumPTQSUnWMo/9NUOSo2Rn04wfgynQ+TpEOWdlmfjG6Qckbc9J78Emg6nonorqQv
         v15CiTQ6Shd8XqkdU2zL+dbBw1ifq7QfT00reh/r/0dENCNyNI6o08/9jN+Ws3wHOTb/
         D0geNP8Bpz9hk1oPfBPna8wVyNbVE4+vvPynJdsKbhD6se8DvmC2QYrK9UvdBAK3SfY5
         GqQA==
X-Gm-Message-State: AOJu0Yyxt6/gYpZRSvZX1AbdsTAunHBaKFCMGHiWv6avOw0Awl/OPj6u
	GdsSP05DGWpOisLF6uylaGmoNL1o5FAzaRkj8BCwc1LccUHYoHi9BuTv
X-Gm-Gg: AR+sD11v+ggNDKN7UksDsXMhdOebyDnvp/GLVkXE/BwdgFpb7l199xXhsdYlOPzpslb
	+iUP7WIoGQLMo9gf7BuJMJ6j6HiqLpKR1thI7uCl7iFgyTQzTyeT1v2N5WxfTVCxC7GXVnjh3jl
	uaBUeRDFvUvE0016nzaLPWEp8c2fvKmOusUExpeJ6VMQsQLj6t7NH/ysVw6DleMjKTonB2YqER6
	760pHRKNwdXawKyKCEpxBYdw5Xc5R7LYE1lPhUJpVSQt+tYgpX+DATZM7rGFS996wxNFXCa15OP
	oaDfr0FdAuQp3PBzvlfzESzHm+yKG70KhVMummZnsFCKUVKOkXF/nUc9GhvaO0y09fDaEzW6Wb4
	EtHZXf3vbf7dN5cLwJUy/yQVPnXvGD2pimTsWB16OjcI7t+YO5m0CNxDYKCizLui5R8o+avyNHj
	z1ptnQI0gJD2wxoT4QSm/d1aP+nEa0UHffSO7v/6NEgMIproGNxN8lUKyqK6AhUaYFUjaWWzxBm
	Qw=
X-Received: by 2002:a17:903:3c23:b0:2d0:2741:f31b with SMTP id d9443c01a7336-2d0523fc4ecmr7602255ad.4.1785512965351;
        Fri, 31 Jul 2026 08:49:25 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:25 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 5/8] wifi: brcmfmac: msgbuf: tune thresholds and optimize sleep latency
Date: Fri, 31 Jul 2026 15:48:37 +0000
Message-ID: <20260731154901.1822-6-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
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

