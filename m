Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.75.77.166
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383723;
	b=OpXcWAgVW33P1z3q/OMr2tr0py3IwVpqFKyOTYVpt2ZbbVKDgamsyF2TVDsfb1JV41wZ
	 OEwqEDyfp4giJ1prh55aZ4v0PnO3qlKQaf/t5mtFMAo6aik3q3ycKskKqkACbd7pfbGrA
	 rX3xfxT5/W8z+YFLD6ExuC+HGJMwazbupYr/1MyxRcN/JXcARoE3RxJveSIU9HoMIZPRA
	 ZRB/Y2eoLRFOweWnQS8RPxo5k/nDLHKkn76PEytF9KOZo58b+1x+HVrHtMeAIFi26kqUo
	 YFlfoqMVq8s0uFhzl52XL+QWpRuQ9KMQp5KlQsn8fTCRDIAGZo5wt1nrjWydvhZFOUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383723;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=qHLOZ3eazynpKs4MwOyw7uyzuUk6W5PCYG4t6E8R0nI=;
	b=FNMAyRmEUoZVAj+sfw638lqjNiEk9JzoFIIjY9zVo97gJTZwoiGbegUCLd2cGxP4MY88
	 9utcKMZqT2W6FUmVE+KvuzFRTvhdoHH8qcEbeNGBmaH3KaK9eiFpKEusKbAa3iCTJUdVZ
	 Ff9V+E2kJ4qph1qRroVF/5XgrSfp5p0d8HXkqaaZUTeWG2piKuhah9986/vkB2w9qvZiw
	 YdVFQsEmjjW+WsHwsQOMelidT+trFnCpydgwZwQ441h+OPpV6uMbUB9nv98du2MhgEhBC
	 hcv19/SBq1baNuubRazgZY2xQkAMJ/nwtq5qlnL3217d95AlrygTVDdSAFETjDL6HLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=adriel.eu;
	spf=pass smtp.mailfrom=adriel.eu;
	dkim=pass header.d=adriel.eu header.i=@adriel.eu header.a=rsa-sha256 header.s=dkim header.b="b7/OrD70";
	arc=none smtp.remote-ip=51.75.77.166
Received: from mail.adriel.eu (mail.adriel.eu [51.75.77.166])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F041606A335;
	Fri, 30 Oct 2026 18:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F041606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adriel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adriel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=adriel.eu header.i=@adriel.eu header.a=rsa-sha256 header.s=dkim header.b=b7/OrD70
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 98C3426224B;
	Fri, 30 Oct 2026 14:08:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=adriel.eu; s=dkim;
	t=1793383716; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding:in-reply-to:references;
	bh=qHLOZ3eazynpKs4MwOyw7uyzuUk6W5PCYG4t6E8R0nI=;
	b=b7/OrD70rGhRxJoMv/jB3Sqiko0OtFaMlIpr22TzsagyeceoMdWfpEAZLutI/zBeXJEs0v
	f0yy0xbtoVN1BGzgL/x1HcOojyQVLPUHi+3tCkW39SSYybppiK+Bw/16NE3DncyDpGWND2
	hL/ptZIvWmYhbNtbqm8gCZIIIW7TMGmk271k3fqgnpSyuSvkoHQ9fbSvuJHGkgUJ6tEv/5
	x2S7EE92OGyHbowHbKyXlvtbsTPczIk10GR5GPfOKDJufWXqxa2A9GUHzrOp3nIiLhAay1
	SbNhCqEAdYEGkCIqCU6lnCJpJ0Hy/5t9Vi2xFojv6I2myCbqQViCV4zIK9DW+A==
From: Adriel Santos <adriel@adriel.eu>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 2/2] wifi: ath12k: copy the first fragment's descriptor before queuing it
Date: Fri, 30 Oct 2026 15:07:05 -0300
Message-ID: <20261030180705.1702009-3-adriel@adriel.eu>
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

ath12k_wifi7_dp_rx_frag_h_mpdu() queues a received fragment on
rx_tid->rx_frags and sets its bit in rx_frag_bitmap before, for fragment
0, it copies the REO destination descriptor with kmemdup(GFP_ATOMIC). If
that copy fails, the function returns -ENOMEM and its caller,
ath12k_wifi7_dp_process_rx_err_buf(), frees the msdu and returns its link
descriptor while the msdu is still on rx_frags:

- the next flush of rx_frags (a new sequence number, the fragment timer
  or peer teardown) frees the skb a second time;
- if the remaining fragments of the MPDU arrive first, the bitmap is
  complete, ath12k_wifi7_dp_rx_h_defrag() walks the list with the freed
  skb, and ath12k_wifi7_dp_rx_h_defrag_reo_reinject() dereferences the
  NULL rx_tid->dst_ring_desc.

This has not been seen in the field; it was reproduced, on ath11k only,
by forcing the allocation to fail.

Copy the descriptor before the fragment is queued, so a failure leaves
nothing of this fragment in rx_tid and the caller's free is the only
one. Fragments other than 0 still return their link descriptor after
being queued.

ath11k has the same code and gets the same fix.

Found during an LLM-assisted review of the RX defragmentation path; the
fix was LLM-assisted as well.

Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Adriel Santos <adriel@adriel.eu>
---

Notes:
    Found while fixing the same bug in ath11k (previous patch), which was
    tested on IPQ5018 with forced kmemdup() failures. No ath12k hardware was
    available: this patch is build-tested only (arm64, W=1, no new
    warnings), and no reproducer was run on ath12k.

 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a32c80440..d84cbb8df 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -1227,6 +1227,17 @@ static int ath12k_wifi7_dp_rx_frag_h_mpdu(struct ath12k_pdev_dp *dp_pdev,
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
 	if ((!rx_tid->rx_frag_bitmap || frag_no > __fls(rx_tid->rx_frag_bitmap)))
 		__skb_queue_tail(&rx_tid->rx_frags, msdu);
 	else
@@ -1236,18 +1247,9 @@ static int ath12k_wifi7_dp_rx_frag_h_mpdu(struct ath12k_pdev_dp *dp_pdev,
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
 		ath12k_wifi7_dp_rx_link_desc_return(dp, &ring_desc->buf_addr_info,
 						    HAL_WBM_REL_BM_ACT_PUT_IN_IDLE);
-	}
 
 	if (!rx_tid->last_frag_no ||
 	    rx_tid->rx_frag_bitmap != GENMASK(rx_tid->last_frag_no, 0)) {
-- 
2.47.3

