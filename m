Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.75.77.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383722;
	b=vB3LSIVdYNdfXRIZKFLGYqy/1hB5yDl/57h/czouB+bfa5EGPlst8tP+bXoLu9CfNBX+
	 5SjXuVPoIbzLrVWRdHvN8OfBnPxkHsZR/sHas7P5gaWtT1CzddVVBTr4ZQTB3L+tmr2/T
	 FaXjK1JBPgnl7EShCgrYNvcDGg+QyFatfcpFLCv7MmMWT4jx1G0tj4ae0PZgbYtHM58Dc
	 yK0w8x6YUfHrpBv1O6N6uR5nflnnrzcQrz+w3Iop3GEYg+Gn2F0UVUUrsZqhV/QKh+93f
	 WxafpTE6TIE/qSNYbVsiYcudfK62Hz6vilsqh3bq4i6dwn+fJ8VqbIh1BtaiDqK1OcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383722;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=bxt2nv0f1bKBHkgigvBF7w7wqjjptYdKTh7c/KlEmKo=;
	b=NfDUVs7NdQbX+4G/w5YIkyYM+AnEK+lnSeGL+bPU+TKQ7YOOkcsNeGfgj3Mj5pJq/x27
	 IO+BIL3ajSGH3rwuuKSJ/Etf7cldN2J3XmBIVcehIwwzel5uH72oOQHI5bS3PQxCGJk9v
	 Z7T2QYyaINx0G6ZKcRs8PiF70zq9+Nhor+3wnvLyhyDzmGaQa/U2cvwMh8euGMgfkL03W
	 PCOZ444uFwt2A0c1XUFip5mVKS/VpU+qid+xPVL/EUkQoo4Ett7+VpPUVCeBDKPpMUjfJ
	 YoDHZTXYMtQEDVRb95ezcfORxwF5TgN+v2LF9j5qu+GXxbdwD8cWGo0Hr6pNWrdEFgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=adriel.eu;
	spf=pass smtp.mailfrom=adriel.eu;
	dkim=pass header.d=adriel.eu header.i=@adriel.eu header.a=rsa-sha256 header.s=dkim header.b=bzsZii4L;
	arc=none smtp.remote-ip=51.75.77.166
Received: from mail.adriel.eu (mail.adriel.eu [51.75.77.166])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78431606A325;
	Fri, 30 Oct 2026 18:08:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78431606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adriel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adriel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=adriel.eu header.i=@adriel.eu header.a=rsa-sha256 header.s=dkim header.b=bzsZii4L
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 606F4262204;
	Fri, 30 Oct 2026 14:08:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=adriel.eu; s=dkim;
	t=1793383713; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=bxt2nv0f1bKBHkgigvBF7w7wqjjptYdKTh7c/KlEmKo=;
	b=bzsZii4LmloETK2WHSp7K9tpl5l00mE/4fyJqn7A5PjLaueRvYWIiU7jqYGH6JODlYytHv
	bbLJXD0fda64DOKKh2BI0ZwtT1Z1b7bHWhcGuA4fCelyT1xIAk4NNh0BAM9gQnf0IjxE7k
	psFWvq9fzKPbDjVQQH3JdkdhdRhuDR0akXg2RoF5Dly7LPLwcXF1QyNNHbnCg/kOQ1evlx
	d0BOrjk6ZqQ+Uj+OxtPh8qCCIHBE5R53/2/c1ZN/0k8+6JYpv6O9FNo1Xha3RUVuOmVFaq
	fofAhP5qAYkzkn/10ADHCW6ZZzh9UfKuv+V+5Ks59ND8Lp3AP3kdbEkbvN8cSw==
From: Adriel Santos <adriel@adriel.eu>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 1/2] wifi: ath11k: copy the first fragment's descriptor before queuing it
Date: Fri, 30 Oct 2026 15:07:04 -0300
Message-ID: <20261030180705.1702009-2-adriel@adriel.eu>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030180705.1702009-1-adriel@adriel.eu>
References: <20261030180705.1702009-1-adriel@adriel.eu>
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
X-Last-TLS-Session-Version: TLSv1.3

ath11k_dp_rx_frag_h_mpdu() queues a received fragment on rx_tid->rx_frags
and sets its bit in rx_frag_bitmap before, for fragment 0, it copies the
REO destination descriptor with kmemdup(GFP_ATOMIC). If that copy fails,
the function returns -ENOMEM and its caller,
ath11k_dp_process_rx_err_buf(), frees the msdu and returns its link
descriptor while the msdu is still on rx_frags:

- the next flush of rx_frags (a new sequence number, the fragment timer,
  peer teardown or a key install) frees the skb a second time;
- if the remaining fragments of the MPDU arrive first, the bitmap is
  complete, ath11k_dp_rx_h_defrag() walks the list with the freed skb,
  and ath11k_dp_rx_h_defrag_reo_reinject() dereferences the NULL
  rx_tid->dst_ring_desc.

This has not been seen in the field; it was reproduced only by forcing
the allocation to fail.

Copy the descriptor before the fragment is queued, so a failure leaves
nothing of this fragment in rx_tid and the caller's free is the only
one. Fragments other than 0 still return their link descriptor after
being queued.

Found during an LLM-assisted review of the RX defragmentation path; the
fix and its testing were LLM-assisted as well.

Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Fixes: 243874c64c81 ("ath11k: handle RX fragments")
Signed-off-by: Adriel Santos <adriel@adriel.eu>
---

Notes:
    How this was tested, and what was not done:
    
    - Found while debugging fragment reception on an IPQ5018 board; the
      failure needs a 64-byte GFP_ATOMIC allocation to fail, so it was never
      seen in normal use. Under Documentation/process/threat-model.rst it is
      a regular bug.
    - To exercise the error path, a test-only module parameter made the
      kmemdup() fail for every Nth first fragment (N = 1 or 3), with a
      client sending 1000-byte pings and TCP uploads fragmented at 256 bytes
      on 2.4 GHz (host data path), over two days:
      - without this patch, the board crashed and rebooted within seconds,
        4 times out of 4; in the two runs that sent one ping at a time, at
        the first forced failure. There is no serial console, so no oops
        trace was captured.
      - with it, 9365 forced failures over 22 minutes: each affected frame
        was dropped, with no warning, SUnreclaim flat, and normal reception
        once the parameter was cleared.
    - The tests ran on OpenWrt's backports of this driver (with downstream
      patches; NSS offload disabled for the radio), not on ath-next. The
      function and its caller are the same there; on ath-next the patch is
      build-tested only (arm64, W=1, no new warnings).
    - That tree also carries a not-yet-submitted change that programs the
      IPQ5018 RX fragment destination in REO1_MISC_CTL, which ath-next does
      not write for this chip. Without it, fragments may not reach this
      function on IPQ5018 at all, so ath-next may not take the tested path
      on that chip.
    - ath12k has the same order in ath12k/wifi7/dp_rx.c; no ath12k hardware
      was available to test a fix.

 drivers/net/wireless/ath/ath11k/dp_rx.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6d95f7b34..789a56488 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3674,6 +3674,17 @@ static int ath11k_dp_rx_frag_h_mpdu(struct ath11k *ar,
 		goto out_unlock;
 	}
 
+	/* On failure the caller frees msdu, so it must not be queued yet */
+	if (frag_no == 0) {
+		rx_tid->dst_ring_desc = kmemdup(ring_desc,
+						sizeof(*rx_tid->dst_ring_desc),
+						GFP_ATOMIC);
+		if (!rx_tid->dst_ring_desc) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+	}
+
 	if (!rx_tid->rx_frag_bitmap || (frag_no > __fls(rx_tid->rx_frag_bitmap)))
 		__skb_queue_tail(&rx_tid->rx_frags, msdu);
 	else
@@ -3683,18 +3694,9 @@ static int ath11k_dp_rx_frag_h_mpdu(struct ath11k *ar,
 	if (!more_frags)
 		rx_tid->last_frag_no = frag_no;
 
-	if (frag_no == 0) {
-		rx_tid->dst_ring_desc = kmemdup(ring_desc,
-						sizeof(*rx_tid->dst_ring_desc),
-						GFP_ATOMIC);
-		if (!rx_tid->dst_ring_desc) {
-			ret = -ENOMEM;
-			goto out_unlock;
-		}
-	} else {
+	if (frag_no != 0)
 		ath11k_dp_rx_link_desc_return(ab, ring_desc,
 					      HAL_WBM_REL_BM_ACT_PUT_IN_IDLE);
-	}
 
 	if (!rx_tid->last_frag_no ||
 	    rx_tid->rx_frag_bitmap != GENMASK(rx_tid->last_frag_no, 0)) {
-- 
2.47.3

